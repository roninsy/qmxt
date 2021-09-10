//
//  OtherCommentListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/20.
//

import UIKit

class OtherCommentListView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var noDataView = UILabel.initSomeThing(title: "快来发表你的评论吧", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 16), ali: .center)
    
    var authId = ""
    ///投诉类型
    var contentType = 9
    
    var isShowBottomAlert = false
    
    var refMsgCount : stringBlock? = nil
    var refBlock : intBlock? = nil
    
    var alertController : UIAlertController? = nil
    ///cell是否显示更多按钮
    var isShowMore = false
    var cid = ""
    ///4美丽日志，5美丽相册
    var type:Int = 0
    var page:Int = 1

    let sectionHead2 = CommentHeadView()
    
    
    var models : [CommentModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                }
            }
        }
    }
    
    var selId : String = ""
    var selUserId : String = ""
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame,style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
//            .init(hex: "#F7F8F9")
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.contentInsetAdjustmentBehavior = .never
       
        NotificationCenter.default.addObserver(self, selector: #selector(commentFinish), name: CommentCompletionNotification, object: nil)
        
    }
    
    @objc func commentFinish(){
        self.page = 1
        self.getNetInfo()
        self.commentNumInfo()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let num = (models?.count ?? 0)
        return (num > 0 ? num : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ///没有评论，返回默认cell
        let num = (models?.count ?? 0)
        if num == 0 {
            return num
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let num = (models?.count ?? 0)
            if num == 0 {
                noDataView.backgroundColor = .white
                noDataView.frame = .init(x: 0, y: 0, width: screenWid, height: 100)
                return noDataView
            }
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            let num = (models?.count ?? 0)
            if num == 0 {
                return 100
            }
        }
        return 0
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = self.models![indexPath.section]
        if indexPath.row == 0 {
            var cell : CommentListCell? = tableView.dequeueReusableCell(withIdentifier: "CommentListCell") as? CommentListCell
            if cell == nil {
                cell = CommentListCell.init(style: .default, reuseIdentifier: "CommentListCell")
                cell?.longTouchBlock = {
                    self.selId = cell?.model?.id ?? ""
                    self.selUserId = cell?.model?.userId ?? ""
                    self.contentType = 8
                    self.showBottomAlert()
                }
            }
//            cell?.topLine.isHidden = indexPath.section == 1
            cell?.authId = self.authId
            cell?.model = model
            if model.cellHei == 0{
                self.models![indexPath.section] = cell!.model!
            }
//            cell?.moreBtn.isHidden = !isShowMore
            return cell!
        }else if(indexPath.row == 3 && model.needShowMore && model.isShowMore == false){
            var cell : CommentLookMoreCell? = tableView.dequeueReusableCell(withIdentifier: "CommentLookMoreCell") as? CommentLookMoreCell
            if cell == nil {
                cell = CommentLookMoreCell.init(style: .default, reuseIdentifier: "CommentLookMoreCell")
                cell?.showBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
                    var model = self.models![indexPath.section]
                    model.isShowMore = true
                    self.models![cell!.tag] = model
                    self.getreplyListInfo(tag: cell!.tag)
                })
            }
            cell?.tag = indexPath.section
//            cell?.titleLab.text = "查看全部\(model.replyCount ?? 0)条回复"
            return cell!
        }else{
            var cell : CommentReCell? = tableView.dequeueReusableCell(withIdentifier: "CommentReCell") as? CommentReCell
            if cell == nil {
                cell = CommentReCell.init(style: .default, reuseIdentifier: "CommentReCell")
                cell?.longTouchBlock = {
                    self.selId = cell?.model?.id ?? ""
                    self.selUserId = cell?.model?.userId ?? ""
                    self.contentType = 9
                    self.showBottomAlert()
                }
            }
            cell?.authId = self.authId
            cell?.model = model.replyList![indexPath.row - 1]
            if model.replyList![indexPath.row - 1].cellHei == 0{
                model.replyList![indexPath.row - 1] = cell!.model!
                self.models![indexPath.section] = model
                
            }

            return cell!
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            return sectionHead2
        }
        return nil

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 48
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rename = ""
        let model = self.models![indexPath.section]
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
        vc.type = self.type
        vc.isReCommnet = true
        vc.commentId = model.id ?? ""
        vc.atUserId = self.selUserId
        vc.sourceId =  self.cid
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
    
    func getNetInfo(){
        if page == 1 {
            self.models?.removeAll()
        }
        CommunityNetworkProvider.request(.commentList(id: cid, page: page, pageSize: 10, type: type)) { result in
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

                            if (total.toInt ?? 0) > 0 {
                                let arr = dic["content"] as! NSArray
                                if self.page == 1 {
                                    self.models = arr.kj.modelArray(type: CommentModel.self)
                                        as? [CommentModel]
                                    
                                }else{
                                    let models = arr.kj.modelArray(type: CommentModel.self)
                                        as? [CommentModel]
                                    
                                    self.models = (self.models ?? []) + (models ?? [])
                                }
                                self.reloadData()
                            }else{
                                //                                self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
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
    
    ///获取回复列表
    func getreplyListInfo(tag : Int){
        CommunityNetworkProvider.request(.selectCourseReplyListApp(id: self.models?[tag].id ?? "", number: page, pageSize: 1000, type: type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data
                            var comentModel = self.models?[tag]
                            let arr = dic?["content"] as? NSArray
                            let models = arr?.kj.modelArray(ReplyListModel.self)
                            comentModel?.replyList = models
                            if comentModel != nil {
                                DispatchQueue.main.async {
                                    self.models?[tag] = comentModel!
                                    self.reloadData()
                                }
                            }
                        }
                    }
                } catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    ///获取评论数量
    func commentNumInfo(){
        CommunityNetworkProvider.request(.selectCommentCountApp(id: cid, type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            let total = model!.data ?? 0
                            var totalStr = "\(total)"
                            if total > 10000  {
                                totalStr = String.init(format: "%.1f万", Double(total) / 10000.0)
                            }
                            self.sectionHead2.titleLab.text = "评论（\(totalStr)）"
                            self.refMsgCount?(totalStr)
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
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){
        if self.isShowBottomAlert {
            return
        }
        self.isShowBottomAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowBottomAlert = false
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        let disAgree = UIAlertAction(title:"投诉", style: .default)
        {
            action in
            let cpView = ComplainView()
            cpView.commentType = self.type
            cpView.contentType = self.contentType
            cpView.sourceId = self.selId
            HQGetTopVC()?.view.addSubview(cpView)
            cpView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        alertController.addAction(cancel)
        if self.selUserId == (UserInfo.getSharedInstance().userId ?? "-1") {
            let del = UIAlertAction(title:"删除", style: .default)
            {
                action in
                self.cancleSureAlertAction(title: "您确定删除此评论？", content: "") { ac in
                    if self.contentType == 8{
                        self.delComment()
                    }else{
                        self.delReply()
                    }
                }
            }
            alertController.addAction(del)
        }
        alertController.addAction(disAgree)
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
    
    func cancleSureAlertAction(title: String,content: String,sureHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: title, message: content, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "确定", style: .default, handler: sureHandle)
    
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        sureAction.setValue(btnColor, forKey: "_titleTextColor")
        cancelAction.setValue(color99, forKey: "_titleTextColor")
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        HQGetTopVC()?.present(alert, animated: true, completion: nil)
    }
    
    func delComment(){
        CommunityNetworkProvider.request(.deleteComment(id: self.selId, type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            HQGetTopVC()?.view.makeToast("删除成功")
                            self.page = 1
                            self.getNetInfo()
                        }
                    }
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func delReply(){
        CommunityNetworkProvider.request(.deleteReply(id: self.selId, type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            HQGetTopVC()?.view.makeToast("删除成功")
                            self.page = 1
                            self.getNetInfo()
                        }
                    }
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
}
