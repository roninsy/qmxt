//
//  SSReleasePreviewController.swift
//  shensuo
//
//  Created by  yang on 2021/6/25.
//

import UIKit
import BMPlayer
import AVFoundation
import AVKit

class SSReleasePreviewController: SSBaseViewController {

    var cid = ""
    var releaseModel: SSReleaseModel? = nil{
        
        didSet{
            
            headBtn.setImage(UIImage.init(named: "kecheng_qipao"), for: .normal)
            navView.backgroundColor = releaseModel?.noteType == 2 ? .white :  UIColor.clear
            noteType = releaseModel?.noteType
        }
    }
    let playBtn = UIButton.initBgImage(imgname: "anniu-bofnag")
    var noteType: Int?
    
    var bottomV = SSReleaseBottomView()
    var tableHeaderView : UIView = {
        let header = UIView.init()
        return header
    }()
    
    var headBtn = UIButton()
    var titleL: UILabel!
    var mainTableView : UITableView = {
        let tableView = UITableView.init()
        return tableView
    }()
    
    var headScroll : SSDetailHeadView = {
        let head = SSDetailHeadView.init()
        return head
    }()
    
    var noteView:SSDetailNotesView = {
        let note = SSDetailNotesView.init()
        return note
    }()
    
    var models : [CommentModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                }
            }
        }
    }
    
    var playerVC : BMPlayer? = nil
    var page = 1
    ///cell是否显示更多按钮
    var isShowMore = false
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if noteType == 2 {
            
            navView.backBtnWithTitle(title: "")
            buildBottomV()
            layoutSubviews()
            mainTableView.tableHeaderView = tableHeaderView
            mainTableView.tableHeaderView?.frame.size.height = screenWid/414*546+30+250
            mainTableView.separatorStyle = .none
            mainTableView.tableFooterView = UIView.init()
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.beginUpdates()
            mainTableView.endUpdates()
            headScroll.initImageScroll(images: [])
            headScroll.locationImageScroll(images:(releaseModel?.locationImgs)! as NSArray)
            noteView.titleLabel.text = releaseModel?.title ?? ""
            noteView.detailLabel.text = releaseModel?.content ?? ""

        }else{
            
            buildBottomV()
            layoutSubviews()
            navView.backBtnWithTitle(title: "")
        }
        
                
    }
    
    func playWithURL(url:URL){
        
        playerView = AVPlayer(url: url)
        playerViewController.player = playerView
        self.present(playerViewController, animated: true) {
                   self.playerViewController.player?.play()
               }
    }
  
    @objc func clickHeadImage(){
        self.navigationController?.pushViewController(SSPersionDetailViewController.init(), animated: true)
    }
    
    
    func loadData() -> Void {
        
        SSCommonApi.laod(completion: { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data
                            if dic == nil {

                                return
                            }
                            HQGetTopVC()?.view.makeToast("调到发布成功页面")
                        }else{

                        }

                    }

                } catch {

                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
            
        }, releaseModel: releaseModel!)
    }
    
    func buildBottomV()  {
            
        
        self.view.addSubview(bottomV)
        bottomV.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(87.5 + SafeBottomHei)
        }
        bottomV.buildUI(str: "返回编辑", icon: noteType == 2 ? "icon-bianji" : "icon-bianji-white", iconW: 32, topMargin: 4, iconTopM: 22)
        if noteType == 1 {
            
            bottomV.titleL.textColor = .white
        }
        bottomV.saveBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.navigationController?.popViewController(animated: true)
        })
        
        bottomV.btn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.sendBtn()
        })
        bottomV.btn.alpha = 0.4
        bottomV.backgroundColor = noteType == 2 ? .white : UIColor.clear

    }
    func sendBtn()  {
        
        if releaseModel?.title == "" {
            
            HQGetTopVC()?.view.makeToast("请先去添加标题")

            return

        }
        if releaseModel?.imageNames.count == 0 && releaseModel?.videoName == "" {
            
            HQGetTopVC()?.view.makeToast(releaseModel?.noteType == 2 ? "请先去上传图片" : "请先去上传视频")
            return
        }
        
       loadData()
    }
    
    func layoutSubviews() -> Void {
        
        if noteType == 1 {
            
            let imageV = UIImageView.init(image: releaseModel?.locationImg)
            
            view.insertSubview(imageV, belowSubview: bottomV)
            imageV.snp.makeConstraints { make in
                
                make.edges.equalToSuperview()
            }
            
            view.addSubview(playBtn)
            playBtn.snp.makeConstraints { make in
                
                make.height.width.equalTo(132)
                make.center.equalToSuperview()
            }
            playBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
                let url = self?.releaseModel?.locationVideo
                if url != nil{
                    self?.playWithURL(url: url!)
                }
            })
            
            let contentL = UILabel.initSomeThing(title: releaseModel?.content ?? "", fontSize: 16, titleColor: .white)
            contentL.numberOfLines = 2
            let contentH = labelHeightLineSpac(font: UIFont.systemFont(ofSize: 16), fixedWidth: screenWid - 32, str: contentL.text ?? "",lineSpec: 13)
            view.addSubview(contentL)
            contentL.snp.makeConstraints { make in
                
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(contentH)
                make.bottom.equalTo(bottomV.snp.top).offset(-16)
            }
            
            let releaseTitleL = UILabel.initSomeThing(title: releaseModel?.title ?? "", fontSize: 16, titleColor: .white)
            releaseTitleL.numberOfLines = 2
            let titleH = heightWithFont(font: UIFont.MediumFont(size: 20), fixedWidth: screenWid - 32, str: releaseTitleL.text ?? "")
            view.addSubview(releaseTitleL)
            releaseTitleL.snp.makeConstraints { make in
                
                make.leading.trailing.equalTo(contentL)
                make.height.equalTo(titleH)
                make.bottom.equalTo(contentL.snp.top).offset(-16)
            }
            let leftBtn = UIButton.initBgImage(imgname: "icon-fanhui-baise")
            view.addSubview(leftBtn)
            leftBtn.snp.makeConstraints { make in
                
                make.leading.equalTo(0)
                make.centerY.equalTo(navView)
                make.height.width.equalTo(48)
            }
            
            leftBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
                
                self?.navigationController?.popViewController(animated: true)
            })
            
            
            view.addSubview(headBtn)
            headBtn.setImage(UIImage.init(named: "kecheng_qipao"), for: .normal)
            headBtn.snp.makeConstraints { make in

                make.leading.equalTo(16)
                make.height.width.equalTo(36)
                make.bottom.equalTo(releaseTitleL.snp.top).offset(-16)
            }
            
            
            if UserInfo.getSharedInstance().headImage != "" && UserInfo.getSharedInstance().headImage != nil {
                
                headBtn.kf.setImage(with: URL(string: UserInfo.getSharedInstance().headImage!), for: .normal)

            }
            
            titleL = UILabel.initSomeThing(title: UserInfo.getSharedInstance().nickName ?? "", fontSize: 17, titleColor: color33)
            view.addSubview(titleL)
            titleL.snp.makeConstraints { make in
                make.leading.equalTo(headBtn.snp.trailing).offset(normalMarginHeight)
                make.centerY.equalTo(headBtn)
            }
            
            
        }else{
        navView.addSubview(headBtn)
//        headBtn.setImage(UIImage.init(named: "kecheng_qipao"), for: .normal)
        headBtn.snp.makeConstraints { make in
            
            make.leading.equalTo(navView.backBtn.snp.trailing).offset(16)
            make.height.width.equalTo(36)
            make.centerY.equalTo(navView)
        }
        
            
        titleL = UILabel.initSomeThing(title: UserInfo.getSharedInstance().nickName ?? "", fontSize: 17, titleColor: color33)
        navView.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.leading.equalTo(headBtn.snp.trailing).offset(normalMarginHeight)
            make.centerY.equalTo(navView)
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomV.snp.top)
        }
        
        tableHeaderView.addSubview(headScroll)
        headScroll.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(screenWid/414*546)
        }
        
        tableHeaderView.addSubview(noteView)
        noteView.snp.makeConstraints { (make) in
            make.top.equalTo(headScroll.snp.bottom)
            make.left.right.equalToSuperview()
            
        }
            
        }
                
    }

}

extension SSReleasePreviewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.navigationController?.pushViewController(SSSendCommentViewController(), animated: true)
    }
}

extension SSReleasePreviewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var model = self.models![indexPath.section - 1]
        if indexPath.row == 0 {
            var cell : CommentListCell? = tableView.dequeueReusableCell(withIdentifier: "CommentListCell") as? CommentListCell
            if cell == nil {
                cell = CommentListCell.init(style: .default, reuseIdentifier: "CommentListCell")
                cell?.moreBigBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in

                })
            }
            cell?.topLine.isHidden = indexPath.section == 1
            cell?.model = model
            if model.cellHei == 0{
                self.models![indexPath.section - 1] = cell!.model!
            }
            cell?.moreBtn.isHidden = !isShowMore
            return cell!
        }else if(indexPath.row == 3 && model.needShowMore && model.isShowMore == false){
            var cell : CommentLookMoreCell? = tableView.dequeueReusableCell(withIdentifier: "CommentLookMoreCell") as? CommentLookMoreCell
            if cell == nil {
                cell = CommentLookMoreCell.init(style: .default, reuseIdentifier: "CommentLookMoreCell")
                cell?.showBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
                    var model = self.models![indexPath.section - 1]
                    model.isShowMore = true
                    self.models![cell!.tag] = model
                    self.mainTableView.reloadData()
                })
            }
            cell?.tag = indexPath.section - 1
            cell?.titleLab.text = "查看全部\(model.replyList!.count)条回复"
            return cell!
        }else{
            var cell : CommentReCell? = tableView.dequeueReusableCell(withIdentifier: "CommentReCell") as? CommentReCell
            if cell == nil {
                cell = CommentReCell.init(style: .default, reuseIdentifier: "CommentReCell")
                cell?.moreBigBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
//                    self.selId = cell?.model?.id ?? ""
//                    self.selUserId = cell?.model?.userId ?? ""
//                    print("sid:\(self.selUserId)")
//                    self.showBottomAlert()
                })
            }
//            cell?.authId = self.?.authorId ?? ""
            cell?.model = model.replyList![indexPath.row - 1]
            if model.replyList![indexPath.row - 1].cellHei == 0{
                model.replyList![indexPath.row - 1] = cell!.model!
                self.models![indexPath.section - 1] = model
                
            }
            cell?.moreBtn.isHidden = !isShowMore
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.models![indexPath.section - 1]
        if indexPath.row == 0 {
            return CGFloat(model.cellHei! > 0 ? model.cellHei! : model.normalHei)
        }else if(indexPath.row == 3 && model.needShowMore && model.isShowMore == false){
            return 37
        }else{
            let model2 = model.replyList![indexPath.row - 1]
            return CGFloat(model2.cellHei! > 0 ? model2.cellHei! : model2.normalHei)
        }
    }
}
