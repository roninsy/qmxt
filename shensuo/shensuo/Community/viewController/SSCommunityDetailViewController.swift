//
//  SSCommunityDetailViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit
import AVFoundation
import AVKit
//动态详情
class SSCommunityDetailViewController: SSBaseViewController {
    
    var noDataView = UILabel.initSomeThing(title: "快来发表你的评论吧", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 16), ali: .center)
    
    ///是否需要刷新
    var needSetupUI = true
    //
    var cid = ""
    //进入必传
    var dataModel:SSCommitModel? = nil {
        didSet {
            if dataModel != nil {
                cid = dataModel?.id ?? ""
                //                type = dataModel?.noteType ?? ""
                
            }
        }
    }
    
    let sectionHead = CommentHeadView()
    var fullView: FullScreenImageListView?
    var type: String = ""
    //是否是从个人中心动态
    var isInFromPerson = false
    var detaileModel: SSNotesDetaileModel? = nil{
        
        didSet {
            if detaileModel != nil {
                self.cid = detaileModel?.id ?? ""
                
                if detaileModel?.authorId == UserInfo.getSharedInstance().userId {
                    navDetailView.shareBtn.setImage(UIImage.init(named: "icon-fenxiang_gray"), for: .normal)
                }
                
                commentView.isVideo = detaileModel?.type == 1 ? true : false
                commentView.backgroundColor = detaileModel?.type == 1 ? .black : .white
                navDetailView.headImage.kf.setImage(with: URL.init(string: detaileModel!.userHeadImage ?? ""), placeholder: UIImage.init(named: "user_normal_icon"))
                navDetailView.titleLabel.text = detaileModel?.userName
                //                navDetailView.focusBtn.isSelected = detaileModel.
                if detaileModel?.authorId == UserInfo.getSharedInstance().userId {
                    self.navDetailView.focusBtn.isHidden = true
                }else{
                    self.navDetailView.focusBtn.isHidden = false
                    loadIsFocusData()
                }
                sectionHead.viewNum.text = "\(getNumString(num: detaileModel!.viewTimes?.doubleValue ?? 0))阅读"
                refreshData()
                loadGiftRankingData()
                loadCommitData()
                ///上传事件
                HQPushActionWith(name: "content_view", dic: ["content_id":self.cid,
                                                 "content_type":"动态",
                                                 "note_type":"图文",
                                                 "editor_id":self.detaileModel?.authorId ?? "",
                                                 "editor_name":self.detaileModel?.userName ?? "",
                                                 "publish_time":self.detaileModel?.createdTime ?? ""])
            }
        }
    }
    var rankModels: GiftRankModel?
    var giftView : giftHeadView = {
        let gift = giftHeadView.init()
        return gift
    }()
    
    
    var dtModel:SSDongTaiModel? = nil{
        didSet{
            if dtModel != nil {
                refreshData()
            }
        }
    }
    var xcModel:MLRJModel? = nil
    
    
    var tableHeaderView : UIView = {
        let header = UIView.init()
        return header
    }()
    
    
    var mainTableView : UITableView = {
        let tableView = UITableView.init()
        return tableView
    }()
    
    
    var navDetailView : SSDetaiNavView = {
        let nav = SSDetaiNavView.init()
        return nav
    }()
    
    
    var headScroll : SSDetailHeadView = {
        let head = SSDetailHeadView.init()
        head.isUserInteractionEnabled = true
        return head
    }()
    
    
    var noteView:SSDetailNotesView = {
        let note = SSDetailNotesView.init()
        return note
    }()
    
    
    var commentView:SSDetailCommentView = {
        let comment = SSDetailCommentView.init()
        return comment
    }()
    
    var models : [CommentModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                }
            }
        }
    }
    var page = 1
    ///cell是否显示更多按钮
    var isShowMore = false
    
    let playBtn = UIButton.initBgImage(imgname: "anniu-bofnag")
    let hiddenBtn = UIButton.initBgImage(imgname: "icon-shousuo")
    var contentL: UILabel!
    var releaseTitleL: UILabel!
    var headBtn = UIButton.init()
    var nickNameL: UILabel?
    let playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    let playerImg = UIImageView()
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var isFocus: Bool! = false
    let focusBtn: UIButton = UIButton.initTitle(title: "关注", fontSize: 13, titleColor: .white)
    //    let showMoreTitleBtn: UIButton = UIButton.initTitle(title: "展开", fontSize: 14, titleColor: .white)
    var contentH: CGFloat! = 0.0
    var detaileCommitView: SSDetaileCommitView?
    var selId : String = ""
    var selUserId : String = ""
    
    let detaileShareBtn = UIButton()
    
    @objc func commentFinish() {
        
        detaileCommitView?.removeFromSuperview()
        page = 1
        loadCommitData()
        commentNumInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentFinish), name: CommentCompletionNotification, object: nil)
        if dataModel == nil {
            HQGetTopVC()?.view.makeToast("缺少必传参数")
            navigationController?.popViewController(animated: true)
            return
        }
        
        navDetailView.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            self?.tabBarController?.tabBar.isHidden = false
        }
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickHeadImage))
        navDetailView.headImage.addGestureRecognizer(tap)
        
        loadData()
        commentNumInfo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    //关注/取消关注
    func focusOption(button:UIButton) -> Void {
        UserInfoNetworkProvider.request(.focusOption(focusUserId: detaileModel?.authorId ?? "")) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            let flag = dic?["type"] as? Bool ?? true
                            if (!flag) {
                                HQGetTopVC()?.view.makeToast("取消成功")
                                button.setTitle("关注", for: .normal)
                            }else{
                                HQGetTopVC()?.view.makeToast("关注成功")
                                button.setTitle("已关注", for: .normal)
                            }
                            
                        }
                    }
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func loadCommitData() -> Void {
        CommunityNetworkProvider.request(.commentList(id: self.cid , page: self.page, pageSize: 10, type: 3)) { result in
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
                                if self.type == "1" {
                                    
                                    
                                    
                                }else{
                                    
                                    self.mainTableView.reloadData()
                                    
                                }
                                
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
    
    func refreshData() -> Void {
        headScroll.initImageScroll(images: (detaileModel?.imageUrls) as NSArray? ?? [])
        commentView.likeBtn.setTitle(String(detaileModel?.likeTimes ?? ""), for: .normal)
        //        commentView.giftBtn.setTitle(detaileModel?.giftUserTimes, for: .normal)
        if detaileModel?.iliked == true {
            commentView.likeBtn.isSelected = true
        }else{
            
            commentView.scBtn.isSelected = false
        }
        commentView.scBtn.setTitle(detaileModel?.collectTimes ?? "", for: .normal)
        commentView.pinglunBtn.setTitle(String(detaileModel?.postTimes ?? 0), for: .normal)
        
        if detaileModel?.icollected == true {
            commentView.scBtn.isSelected = true
        }else{
            commentView.scBtn.isSelected = false
        }
        //        if type == "2" {
        //
        //            noteView.titleLabel.text = detaileModel?.title
        //            noteView.detailLabel.text = detaileModel?.content
        //        }
        
        //        headScroll.initImageScroll(images: (dtModel?.imageUrls!)! as NSArray)
        //        commentView.likeBtn.setTitle(String(dtModel?.likeTimes ?? 0), for: .normal)
        //        commentView.giftBtn.setTitle(dtModel?.giftUserTimes, for: .normal)
        //        if dtModel?.blike == true {
        //            commentView.likeBtn.isSelected = true
        //        }
        
    }
    
    func loadData() -> Void {
        UserInfoNetworkProvider.request(.publishedDetail(noteId: cid)) { [weak self] result in
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
                            self?.detaileModel = dic?.kj.model(SSNotesDetaileModel.self)
                            self?.type = "\(self?.detaileModel?.type ?? 2)"
                            if self?.type == "2" {
                                
                                self?.layoutSubviews()
                                self?.buildTableUI()
                                
                            }else{
                                
                                self?.layoutSubviewsVideo()
                                self?.buildTableUI()
                            }
                            //                            self.xqModel = dic.kj.model(SSXCXQModel.self)
                            //                            headScroll.initImageScroll(images: self.xqModel!.images as NSArray)
                        }else{
                            
                            HQGetTopVC()?.view.makeToast(model?.message)
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
        CommunityNetworkProvider.request(.selectCommentCountApp(id: cid, type: 3)) { result in
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
                            self.sectionHead.titleLab.text = "评论（\(totalStr)条）"
                            self.commentView.pinglunBtn.setTitle(totalStr, for: .normal)
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
    
    ///获取礼物排行榜
    func loadGiftRankingData() {
        GiftNetworkProvider.request(.giftRanking(source: cid, type: "3", number: 1, pageSize: 10)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.rankModels = model!.data!.kj.model(type: GiftRankModel.self) as? GiftRankModel
                                if self.rankModels?.gifts != nil && (self.rankModels?.gifts?.content!.count ?? 0 > 0) {
                                    
                                    if self.type == "2" {
                                        self.headScroll.giftView.images = self.rankModels?.gifts?.content!
                                        
                                    }else{
                                        
                                        self.giftView.images = self.rankModels?.gifts?.content!
                                    }
                                }
                            }
                        }else{
                            
                        }
                    }
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    func loadIsFocusData() {
        
        UserInfoNetworkProvider.request(.isFocusUser(userId: detaileModel?.authorId ?? ""))  { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultBoolModel.self)
                        if model?.code == 0 {
                            
                            self?.isFocus = model?.data
                            if self?.type == "2" {
                                
                                self?.navDetailView.focusBtn.isSelected = self?.isFocus == true ? true : false
                                self?.navDetailView.focusBtn.setTitle(self?.isFocus == true ? "已关注" : "关注", for: .normal)
                                
                            }else{
                                
                                self?.focusBtn.setTitle(self?.isFocus == true ? "已关注" : "关注", for: .normal)
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
    
    @objc func clickHeadImage(){
        //        (UserInfo.getSharedInstance().userId ?? ""))
        let vc = SSPersionDetailViewController.init()
        vc.cid = detaileModel?.authorId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func headViewAction()  {
        var imgs: [UIImage] = Array()
        
        if self.detaileModel?.imageUrls != nil && self.detaileModel?.imageUrls?.count ?? 0 > 0 {
            
            for index in 0..<(self.dataModel?.imageList?.count ?? 0)! {
                
                let imgV = UIImageView.init()
                imgV.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenHei - NavBarHeight)
                imgV.kf.setImage(with: URL.init(string: (self.detaileModel?.imageUrls!)![index]),placeholder: UIImage.init(named: "user_normal_icon"))
                imgV.contentMode = .scaleAspectFit
                imgs.append(imgV.image!)
                
            }
        }
        if imgs.count > 0 {
            
            fullView = FullScreenImageListView()
            fullView!.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenHei)
            fullView!.imgArr = imgs
            fullView?.hasDelBtn = false
            fullView?.closeBlock = {_ in
                
                
            }
            UIApplication.shared.keyWindow?.addSubview(fullView!)
            
        }else{
            
            
        }
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SSCommunityDetailViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.navigationController?.pushViewController(SSSendCommentViewController(), animated: true)
    }
}

extension SSCommunityDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if models == nil {
            
            return 1
        }
        return (models?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return sectionHead
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 48
        }
        return 0
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = (models?.count ?? 0)
        if num == 0 {
            return 0
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
            cell?.authId = self.detaileModel?.authorId ?? ""
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
                    self.mainTableView.reloadData()
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
            cell?.authId = self.detaileModel?.authorId ?? ""
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
        vc.sourceId = self.cid
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
}

extension SSCommunityDetailViewController{
    
    
    func buildTableUI()  {
        if self.needSetupUI == false {
            return
        }
        self.needSetupUI = false
        
        let headTitleH = labelHeightLineSpac(font: .MediumFont(size: 20), fixedWidth: screenWid - 32, str: detaileModel?.title ?? "", lineSpec: 2)
        let headContentH = labelHeightLineSpac(font: UIFont.systemFont(ofSize: 16   ), fixedWidth: screenWid - 32, str: detaileModel?.content ?? "", lineSpec: 2)
        mainTableView.tableHeaderView = tableHeaderView
        mainTableView.tableHeaderView?.frame.size.height = screenWid/414*546 + headTitleH + headContentH + 30 + 12
        //        mainTableView.tableHeaderView?.frame.size.height = headTitleH+40+headContentH
        mainTableView.separatorStyle = .none
        mainTableView.tableFooterView = UIView.init()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        //        mainTableView.beginUpdates()
        //        mainTableView.endUpdates()
        
        navDetailView.clickFocusBtnHandler = { button in
            self.focusOption(button: button)
            
        }
        
        //        navDetailView.shareBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
        //
        //            self?.goToShare()
        ////            HQGetTopVC()?.view.makeToast("分享待完善")
        //        })
        
        commentView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        
        commentView.giftBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            ///上报事件
            HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":"动态",
                                                              "content_id":""])
            ///显示发送礼物界面
            let giftView = GiftListView()
            giftView.sid = self?.detaileModel?.id ?? ""
            giftView.uid = self?.detaileModel?.authorId ?? "-1"
            giftView.type = 3
            giftView.sendGiftBlock = {
                
            }
            HQGetTopVC()?.view.addSubview(giftView)
            giftView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        })
        
        commentView.pinglunBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            if self?.type == "1" {
                self?.detaileCommitView = SSDetaileCommitView()
                self!.detaileCommitView!.model = self?.dataModel
                self?.detaileCommitView!.models = self?.models
                self!.detaileCommitView!.backgroundColor = .clear
                DispatchQueue.main.async {
                    HQGetTopVC()?.view.addSubview(self!.detaileCommitView!)
                    self!.detaileCommitView!.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                }
                
            }else{
                
                let vc = CommentInputView()
                vc.type = 3
                vc.isReCommnet = false
                vc.commentId = ""
                vc.atUserId = self?.detaileModel?.authorId ?? ""
                vc.sourceId = self?.detaileModel?.id ?? ""
                //                vc.atText = "@\(rename) "
                
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
            
        })
        
        commentView.likeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            CommunityNetworkProvider.request(.addLike(sourceId: self.detaileModel?.id ?? "", type: 3)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            
                            if model?.code == 0 {
                                btn.isSelected = !btn.isSelected
                                
                                var num:Int = btn.title(for: .normal)?.toInt ?? 0
                                num += btn.isSelected ? 1 : -1
                                if num < 0{
                                    num = 0
                                }
                                btn.setTitle(String(num), for: .normal)
                                if btn.isSelected {
                                    self.view.makeToast("点赞成功")
                                }else{
                                    self.view.makeToast("取消点赞")
                                }
                                
                            }else{
                                
                            }
                        }
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
        }
        
        commentView.scBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            CommunityNetworkProvider.request(.addCollect(sourceId: self.detaileModel?.id ?? "", type: 3)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                btn.isSelected = !btn.isSelected
                                var num:Int = btn.title(for: .normal)?.toInt ?? 0
                                num += btn.isSelected ? 1 : -1
                                if num < 0{
                                    num = 0
                                }
                                btn.setTitle(String(num), for: .normal)
                                if btn.isSelected {
                                    self.view.makeToast("收藏成功")
                                }else{
                                    self.view.makeToast("取消收藏")
                                }
                            }
                        }
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
        }
        
        headScroll.giftView.giftBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.jumpToGiftRank()
        })
        
        commentView.giftBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            
        }
    }
    
    func layoutSubviewsVideo() {
        
        if detaileModel?.videoUrl != nil && detaileModel?.videoUrl != "" {
            self.addChild(playerViewController)
            self.view.addSubview(playerViewController.view)
            playerViewController.showsPlaybackControls = false
            
            playerView = AVPlayer(url: URL(string: self.detaileModel?.videoUrl ?? "")!)
            playerViewController.player = playerView
            
            //        self.playerViewController.showsPlaybackControls = false
            self.playerViewController.player?.play()
        }
        
        view.addSubview(playBtn)
        playBtn.snp.makeConstraints { make in
            
            make.height.width.equalTo(132)
            make.center.equalToSuperview()
        }
        playBtn.isHidden = true
        playBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] (btn) in
            
            self?.playerViewController.player?.play()
            self?.playBtn.isHidden = true
        })
        
        
        view.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        contentL = UILabel.initSomeThing(title: detaileModel?.content ?? "", fontSize: 16, titleColor: .white)
        contentL.numberOfLines = 0
        contentH = labelHeightLineSpac(font: UIFont.systemFont(ofSize: 16), fixedWidth: screenWid - 76, str: contentL.text ?? "",lineSpec: 5)
        view.addSubview(contentL)
        contentL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(-60)
            make.height.equalTo(contentH)
            make.bottom.equalTo(commentView.snp.top).offset(-16)
        }
        releaseTitleL = UILabel.initSomeThing(title: detaileModel?.title ?? "", fontSize: 16, titleColor: .white)
        
        releaseTitleL.numberOfLines = 2
        let titleH = heightWithFont(font: UIFont.MediumFont(size: 20), fixedWidth: screenWid - 76, str: releaseTitleL.text ?? "")
        view.addSubview(releaseTitleL)
        releaseTitleL.snp.makeConstraints { make in
            
            make.leading.trailing.equalTo(contentL)
            make.height.equalTo(titleH)
            make.bottom.equalTo(contentL.snp.top).offset(-16)
        }
        
        //        if contentH > 55 {
        //
        //            view.addSubview(showMoreTitleBtn)
        //            showMoreTitleBtn.snp.makeConstraints { make in
        //
        //                make.leading.equalTo(releaseTitleL)
        //                make.top.equalTo(contentL.snp.bottom).offset(0)
        //            }
        //            showMoreTitleBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
        //
        //                self?.showMoreTitleBtn.isSelected = !(self?.showMoreTitleBtn.isSelected)!
        //                let h: CGFloat = self!.contentH
        //                if self?.showMoreTitleBtn.isSelected == true{
        //
        //                    self?.contentL.snp.updateConstraints({ make in
        //
        //                        make.height.equalTo(h)
        //                    })
        //                    self?.showMoreTitleBtn.setTitle("关闭", for: .normal)
        //                }else{
        //
        //                    self?.contentL.snp.updateConstraints({ make in
        //
        //                        make.height.equalTo(h > 55 ? 50 : (h))
        //                    })
        //                    self?.showMoreTitleBtn.setTitle("展开", for: .normal)
        //                }
        //
        //            })
        //        }
        
        
        view.addSubview(hiddenBtn)
        hiddenBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] (hiddenBtn) in
            
            self?.hiddenBtn.isSelected = !(self?.hiddenBtn.isSelected)!
            if self?.hiddenBtn.isSelected == true{
                
                self?.headBtn.isHidden = true
                self?.contentL.isHidden = true
                self?.releaseTitleL.isHidden = true
                self?.nickNameL?.isHidden = true
                self?.focusBtn.isHidden = true
                //                self?.showMoreTitleBtn.isHidden = true
                
            }else{
                
                self?.headBtn.isHidden = false
                self?.contentL.isHidden = false
                self?.releaseTitleL.isHidden = false
                self?.nickNameL?.isHidden = false
                self?.focusBtn.isHidden = false
                //                self?.showMoreTitleBtn.isHidden = false
            }
            
        })
        hiddenBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.top.equalTo(contentL).offset(-6)
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
        
        view.addSubview(giftView)
        giftView.snp.makeConstraints { make in
            
            make.center.equalTo(navView)
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        
        detaileShareBtn.setImage(UIImage.init(named: "more_black"), for: .normal)
        view.addSubview(detaileShareBtn)
        detaileShareBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(-12)
            make.centerY.equalTo(navView)
            make.height.width.equalTo(24)
        }
        detaileShareBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            self?.showBottomAlert2()
        })
        
        if detaileModel?.authorId == UserInfo.getSharedInstance().userId {
            
            let editBtn = UIButton.initTitle(title: "编辑", fontSize: 13, titleColor: .white)
            editBtn.titleLabel?.font = UIFont.MediumFont(size: 13)
            view.addSubview(editBtn)
            editBtn.backgroundColor = .clear
            editBtn.layer.cornerRadius = 16
            editBtn.layer.masksToBounds = true
            editBtn.layer.borderWidth = 1
            editBtn.layer.borderColor = UIColor.white.cgColor
            editBtn.snp.makeConstraints { make in
                
                make.trailing.equalTo(detaileShareBtn.snp.leading).offset(-12)
                make.height.equalTo(32)
                make.width.equalTo(68)
                make.centerY.equalTo(navView)
            }
            editBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
                let vc = SSReleaseNewsViewController()
                vc.notesDetaile = self?.detaileModel
                vc.inType = 6
                self?.navigationController?.pushViewController(vc, animated: true)
                
            })
        }
        
        
        giftView.giftBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            self?.jumpToGiftRank()
        })
        
        view.addSubview(headBtn)
        headBtn.layer.cornerRadius = 18
        headBtn.layer.masksToBounds = true
        headBtn.setImage(UIImage.init(named: "kecheng_qipao"), for: .normal)
        headBtn.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.height.width.equalTo(36)
            make.bottom.equalTo(releaseTitleL.snp.top).offset(-16)
        }
        headBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.clickHeadImage()
        })
        
        if detaileModel?.headerImageUrl != "" && detaileModel?.headerImageUrl != nil {
            
            headBtn.kf.setImage(with: URL(string: detaileModel?.headerImageUrl! ?? ""), for: .normal)
            
        }
        
        nickNameL = UILabel.initSomeThing(title: detaileModel?.userName ?? "", fontSize: 17, titleColor: .white)
        view.addSubview(nickNameL!)
        nickNameL!.snp.makeConstraints { make in
            make.leading.equalTo(headBtn.snp.trailing).offset(normalMarginHeight)
            make.centerY.equalTo(headBtn)
        }
        
        view.addSubview(focusBtn)
        focusBtn.layer.cornerRadius = 16
        focusBtn.layer.masksToBounds = true
        focusBtn.titleLabel?.font = .MediumFont(size: 13)
        focusBtn.backgroundColor = btnColor
        focusBtn.snp.makeConstraints { make in
            
            make.leading.equalTo(nickNameL!.snp.trailing).offset(16)
            make.width.equalTo(70)
            make.height.equalTo(32)
            make.centerY.equalTo(nickNameL!)
        }
        
        focusBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            self?.focusOption(button: self!.focusBtn)
        })
        customTap(target: self, action: #selector(playVCAction), view: playerViewController.view)
    }
    
    func jumpToGiftRank()  {
        
        let vc = GiftRankVC()
        vc.mainView.mainId = self.cid
        vc.mainView.type = 3
        vc.mainView.userId = detaileModel?.authorId ?? ""
        vc.mainView.isSelf = detaileModel?.authorId == (UserInfo.getSharedInstance().userId ?? "")
        vc.mainView.titleText = detaileModel?.userName ?? ""
        HQPush(vc: vc, style: .default)
    }
    
    @objc func playVCAction() {
        
        playerViewController.player?.pause()
        playBtn.isHidden = false
    }
    
    
    func layoutSubviews() -> Void {
        
        
        self.view.addSubview(navDetailView)
        navDetailView.shareBtn.setImage(UIImage.init(named: "more_gray"), for: .normal)
        navDetailView.shareBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.showBottomAlert2()
        }
        navDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(NavBarHeight)
        }
        
        self.view.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navDetailView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(commentView.snp.top)
        }
        
        tableHeaderView.addSubview(headScroll)
        headScroll.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(screenWid/414*546)
        }
        ///添加图片点击事件
        let hsBtn = UIButton()
        tableHeaderView.addSubview(hsBtn)
        hsBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(headScroll)
            make.top.equalTo(headScroll).offset(60)
        }
        hsBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.headViewAction()
        }
        
        //        headScroll.isUserInteractionEnabled = true
        //        let headImgTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(headViewAction))
        //        headScroll.addGestureRecognizer(headImgTap)
        let headTitleH: CGFloat = labelHeightLineSpac(font: .MediumFont(size: 20), fixedWidth: screenWid - 32, str: detaileModel?.title ?? "", lineSpec: 2)
        let headContentH: CGFloat = labelHeightLineSpac(font: UIFont.systemFont(ofSize: 16   ), fixedWidth: screenWid - 32, str: detaileModel?.content ?? "", lineSpec: 2)
        tableHeaderView.addSubview(noteView)
        noteView.snp.makeConstraints { (make) in
            make.top.equalTo(headScroll.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(headTitleH + headContentH + 20)
            
        }
        noteView.titleLabel.text = detaileModel?.title
        noteView.detailLabel.text = detaileModel?.content
        noteView.timeLab.text = detaileModel?.createdTime
        
        let botLine = UIView()
        botLine.backgroundColor = .init(hex: "#f6f6f6")
        tableHeaderView.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.height.equalTo(12)
            make.left.right.equalToSuperview()
        }
    }
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){
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
    
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert2(){
        if detaileModel?.authorId == UserInfo.getSharedInstance().userId {
            goToShare()
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")
        
        let disAgree = UIAlertAction(title:"投诉", style: .default)
        {
            action in
            let cpView = ComplainView()
            cpView.contentType = 5
            cpView.sourceId = self.cid
            HQGetTopVC()?.view.addSubview(cpView)
            cpView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        }
        let share = UIAlertAction(title:"分享", style: .default)
        {
            action in
            self.goToShare()
            
        }
        alertController.addAction(cancel)
        alertController.addAction(disAgree)
        alertController.addAction(share)
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
    
    func goToShare() {
        let vc = ShareVC()
        vc.type = 4
        vc.notesModel = self.detaileModel!
        vc.setupMainView()
        HQPush(vc: vc, style: .lightContent)
    }
    
}
