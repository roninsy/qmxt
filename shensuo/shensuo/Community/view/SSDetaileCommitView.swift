//
//  SSDetaileCommitView.swift
//  shensuo
//
//  Created by  yang on 2021/7/2.
//

import UIKit

class SSDetaileCommitView: UIView {
    
    let vc = CommentInputView()
    var total = 0
    let hideBtn = UIButton()
    var cid = ""
    var tableView: UITableView! = {
        
        let tab = UITableView.init(frame: CGRect.zero, style:.plain)
        tab.rowHeight = 100
        return tab
    }()
    
    var model: SSCommitModel? = nil {
        
        didSet {
                    vc.type = 3
                    vc.isReCommnet = false
                    vc.commentId = ""
                    vc.atUserId = model?.userId ?? ""
                    vc.sourceId = cid
//                    vc.atText = "@\(model?.nickName ?? "") "

        }
    }
    var models : [CommentModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    var page = 1
    ///cell是否显示更多按钮
    var isShowMore = false
    var selId : String = ""
    var selUserId : String = ""
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(hideBtn)
        hideBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hideBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.endEditing(false)
            self.removeFromSuperview()
        }
        
        let whiteBg = UIView()
        whiteBg.backgroundColor = .white
        self.addSubview(whiteBg)
        whiteBg.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(SafeBottomHei + 1)
        }
        
        self.addSubview(vc)
        vc.type = 3
        vc.needHideWithFinish = false
        vc.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-SafeBottomHei)
            make.height.equalTo(56)
        }
        vc.commentCheck()
        
        self.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(240)
            make.bottom.equalTo(-(SafeBottomHei + 56))
        }
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {[weak self] in
            self?.page += 1
            self?.loadCommitData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCommitData() -> Void {
        CommunityNetworkProvider.request(.commentList(id: self.cid , page: self.page, pageSize: 10, type: 3)) { result in
            self.tableView.mj_footer?.endRefreshing()
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            let total = dic["totalElements"] as! String
                            self.total = total.toInt ?? 0
                            if (self.total) > (self.models?.count ?? 0) {
                                let arr = dic["content"] as! NSArray
                                if self.page == 1 {
                                    self.models = arr.kj.modelArray(type: CommentModel.self)
                                        as? [CommentModel]
                                }else{
                                    let models = arr.kj.modelArray(type: CommentModel.self)
                                        as? [CommentModel]
                                    
                                    self.models = (self.models ?? []) + (models ?? [])
                                }
                                self.tableView.reloadData()
                            }
                        }else{
                            
                        }
                    }
                } catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
}
extension SSDetaileCommitView : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if models == nil {
            return 0
        }
        return (models?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.total <= (self.models?.count ?? 0) {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.tableView.mj_footer?.endRefreshing()
        }
     
        let model = models![section]
        if model.needShowMore {
            if model.isShowMore {
                return 1 + (model.replyList?.count ?? 0)
            }else{
                return 1 + 2 + 1
            }
        }
        return 1 + (model.replyList?.count ?? 0)
    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.models?.count ?? 0
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        var model = self.models![indexPath.section ]
        if indexPath.row == 0 {
            var cell : CommentListCell? = tableView.dequeueReusableCell(withIdentifier: "CommentListCell") as? CommentListCell
            if cell == nil {
                cell = CommentListCell.init(style: .default, reuseIdentifier: "CommentListCell")
                
                cell?.moreBigBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
                    self.selId = cell?.model?.id ?? ""
                    self.selUserId = cell?.model?.userId ?? ""
                    print("sid:\(self.selUserId)")
                    self.showBottomAlert()
                })
            }
            cell?.topLine.isHidden = indexPath.section == 0
            cell?.authId = self.model?.userId ?? ""
            cell?.model = model
            if model.cellHei == 0{
                self.models![indexPath.section] = cell!.model!
            }
            cell?.moreBtn.isHidden = !isShowMore
            return cell!
        }else if(indexPath.row == 3 && model.needShowMore && model.isShowMore == false){
            var cell : CommentLookMoreCell? = tableView.dequeueReusableCell(withIdentifier: "CommentLookMoreCell") as? CommentLookMoreCell
            if cell == nil {
                cell = CommentLookMoreCell.init(style: .default, reuseIdentifier: "CommentLookMoreCell")
                cell?.showBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
                    var model = self.models![indexPath.section]
                    model.isShowMore = true
                    self.models![cell!.tag] = model
                    self.tableView.reloadData()
                })
            }
            cell?.tag = indexPath.section
            cell?.titleLab.text = "查看全部\(model.replyList!.count)条回复"
            return cell!
        }else{
            var cell : CommentReCell? = tableView.dequeueReusableCell(withIdentifier: "CommentReCell") as? CommentReCell
            if cell == nil {
                cell = CommentReCell.init(style: .default, reuseIdentifier: "CommentReCell")
                cell?.moreBigBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
                    self.selId = cell?.model?.id ?? ""
                    self.selUserId = cell?.model?.userId ?? ""
                    print("sid:\(self.selUserId)")
                    self.showBottomAlert()
                })
            }
            cell?.authId = self.model?.userId ?? ""
            cell?.model = model.replyList![indexPath.row - 1]
            if model.replyList![indexPath.row - 1].cellHei == 0{
                model.replyList![indexPath.row - 1] = cell!.model!
                self.models![indexPath.section] = model
                
            }
            cell?.moreBtn.isHidden = !isShowMore
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        var rename = ""
        let model = self.models![indexPath.section - 1]
        if indexPath.row == 0 {
            rename = model.nickName ?? ""
            self.selId = model.id ?? ""
            self.selUserId = model.userId ?? ""
        }else{
            let model2 = model.replyList![indexPath.row - 1]
            rename = model2.nickName ?? ""
            self.selId = model2.id ?? ""
            self.selUserId = model2.userId ?? ""
        }
        let vc = CommentInputView()
        vc.type = 3
        vc.isReCommnet = true
        vc.commentId = self.selId
        vc.atUserId = self.selUserId
        vc.sourceId = model.id ?? ""
        vc.atText = "@\(rename) "
        vc.commentCheck()
        vc.canCommentBlock = {
            DispatchQueue.main.async {
                HQGetTopVC()?.view.addSubview(vc)
                vc.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                vc.textView.becomeFirstResponder()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.models![indexPath.section]
        if indexPath.row == 0 {
            return CGFloat(model.cellHei! > 0 ? model.cellHei! : model.normalHei)
        }else if(indexPath.row == 3 && model.needShowMore && model.isShowMore == false){
            return 37
        }else{
            let model2 = model.replyList![indexPath.row - 1]
            return CGFloat(model2.cellHei! > 0 ? model2.cellHei! : model2.normalHei)
        }
    }
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){
        if !isShowMore{
            ///更多按钮被隐藏
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        let disAgree = UIAlertAction(title:"投诉", style: .default)
        {
            action in
            let cpView = ComplainView()
            cpView.commentType = 3
            cpView.contentType = 8
            cpView.sourceId = self.selId
            HQGetTopVC()?.view.addSubview(cpView)
            cpView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        }
        alertController.addAction(cancel)
        alertController.addAction(disAgree)
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
}

