//
//  SSVedioListCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/21.
//

import UIKit
import AVKit
import Player

class SSVedioListCell: UITableViewCell {
    
    var reloadBlock : stringBlock? = nil
    
    var currentIndex = 0
    ///进度条
    let progress = HQSlider()
    
    let minProgress = UIProgressView()
    ///进度条已加载进度的颜色
    var progressTintColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    ///是否需要自动播放
    var autoPlay = false
    ///是否拉黑
    var isSlectBlack = false
    
    ///是否作者
    var isAuthor = false{
        didSet{
            ///是作者
            detaileShareBtn.setImage(UIImage.init(named: isAuthor ? "my_share" : "more_white"), for: .normal)
            if isAuthor == false {
                self.loadSlectBlack()
            }
        }
    }
    
    var totalTime : Double = 0
    
    var timeShowNum = 300
    
    let editBtn = UIButton.initTitle(title: "编辑", fontSize: 13, titleColor: .white)
    var navView:SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
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
    
    var detaileModel: SSNotesDetaileModel? = nil{
        didSet {
            if detaileModel != nil {
                self.cid = detaileModel?.id ?? ""
                self.isAuthor = detaileModel?.authorId == UserInfo.getSharedInstance().userId
                navDetailView.headImage.kf.setImage(with: URL.init(string: detaileModel!.headerImageUrl ?? ""), placeholder: UIImage.init(named: "user_normal_icon"))
                
                navDetailView.titleLabel.text = detaileModel?.userName
                
                ///详情
                contentL.text = detaileModel?.content
                contentH = labelHeightLineSpac(font: UIFont.systemFont(ofSize: 16), fixedWidth: screenWid - 76, str: contentL.text ?? "",lineSpec: 5)
                contentL.snp.updateConstraints { make in
                    make.height.equalTo(contentH)
                }
                
                releaseTitleL.text = detaileModel?.title
                let titleH = heightWithFont(font: UIFont.MediumFont(size: 16), fixedWidth: screenWid - 76, str: releaseTitleL.text ?? "")
                releaseTitleL.snp.updateConstraints { make in
                    make.height.equalTo(titleH)
                }
                
                editBtn.isHidden = !(detaileModel?.authorId == UserInfo.getSharedInstance().userId)
                headBtn.kf.setImage(with: URL(string: detaileModel?.userHeadImage ?? ""), for: .normal)
                nickNameL?.text = detaileModel?.userName
                
                if autoPlay {
                    self.autoPlay = false
                    reloadVedioUrl()
                    player._avplayer.play()
                }
                
                DispatchQueue.main.async {
                    self.refreshData()
                    self.loadIsFocusData()
                    self.loadGiftRankingData()
                }
            }
        }
    }
    
    var page = 1
    var models : [CommentModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                }
            }
        }
    }
    
    ///时间按钮组件
    var timeView = UIView()
    ///拖动时时间文本
    var timeLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .MediumFont(size: 30), ali: .right)
    var totalTimeLab = UILabel.initSomeThing(title: "", titleColor: .gray, font: .systemFont(ofSize: 30), ali: .left)
    
    var rankModels: GiftRankModel?
    var giftView : giftHeadView = {
        let gift = giftHeadView.init()
        return gift
    }()
    
    let focusBtn: UIButton = UIButton.initTitle(title: "关注", fontSize: 13, titleColor: .white)
    var isFocus: Bool = false
    var navDetailView : SSDetaiNavView = {
        let nav = SSDetaiNavView.init()
        return nav
    }()
    var commentView:SSDetailCommentView = {
        let comment = SSDetailCommentView.init()
        return comment
    }()
    var detaileCommitView: SSDetaileCommitView = SSDetaileCommitView()
    
    let playBtn = UIButton.initBgImage(imgname: "anniu-bofnag")
    let hiddenBtn = UIButton.initBgImage(imgname: "icon-shousuo")
    
    //    var playerViewController = AVPlayerViewController()
    var player = Player()
    var contentL: UILabel!
    var contentH: CGFloat! = 0.0
    var releaseTitleL: UILabel!
    var headBtn = UIButton.init()
    var nickNameL: UILabel?
    let detaileShareBtn = UIButton.initBgImage(imgname: "more_white")
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .black
        
        navView.backgroundColor = .black
        self.contentView.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
        
        navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        navDetailView.backBlock = {
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
            HQGetTopVC()?.tabBarController?.tabBar.isHidden = false
        }
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickHeadImage))
        navDetailView.headImage.addGestureRecognizer(tap)
        
        HQGetTopVC()?.addChild(player)
        self.contentView.addSubview(player.view)
        player.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.player.view.backgroundColor = .black
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        
        //        self.playerViewController.showsPlaybackControls = false
        
        
        self.contentView.addSubview(playBtn)
        playBtn.snp.makeConstraints { make in
            
            make.height.width.equalTo(132)
            make.center.equalToSuperview()
        }
        playBtn.isHidden = true
        playBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
            self.player._avplayer.play()
            self.playBtn.isHidden = true
        })
        
        commentView.isVideo = true
        commentView.backgroundColor = .black
        self.contentView.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(SafeBottomHei + 49)
        }
        
        minProgress.tintColor = .lightGray
        self.contentView.addSubview(minProgress)
        minProgress.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(commentView.snp.top)
            make.height.equalTo(2)
        }
        
        progress.tintColor = .clear
        progress.backgroundColor = .clear
        progress.thumbTintColor = .clear
        
        self.contentView.addSubview(progress)
        progress.snp.makeConstraints { make in
            make.left.equalTo(-10)
            make.right.equalTo(10)
            make.height.equalTo(40)
            make.bottom.equalTo(commentView.snp.top).offset(19)
        }
        progress.reactive.controlEvents(.valueChanged).observeValues { sld in
            self.minProgress.isHidden = true
            ///隐藏底部界面
            self.hiddenBtn.isSelected = true
            self.hiddenBtn.isHidden = true
            self.progress.tintColor = .white
            self.progress.thumbTintColor = .white
            self.hiddenAction()
            ///计算时间
            let changgetime = Float(self.player.maximumDuration) * sld.value
            self.player._avplayer.seek(to: .init(seconds: Double(changgetime), preferredTimescale: self.player._avplayer.currentTime().timescale), toleranceBefore: .zero, toleranceAfter: .zero)
            
            self.timeShowNum = 0
            let nowS = Int(changgetime)
            let totalS = Int(self.player.maximumDuration)
            self.timeLab.text = "\(nowS / 60):\(String.init(format: "%02d", nowS % 60))"
            self.totalTimeLab.text = "\(totalS / 60):\(String.init(format: "%02d", totalS % 60))"
            self.timeLab.changeWordSpace(space: 2)
            self.timeLab.textAlignment = .right
            self.totalTimeLab.changeWordSpace(space: 2)
            self.totalTimeLab.textAlignment = .left
            self.timeView.isHidden = false
            
            self.playBtn.isHidden = true
            self.player._avplayer.play()
        }
        
        contentL = UILabel.initSomeThing(title: "", fontSize: 16, titleColor: .white)
        contentL.numberOfLines = 0
        
        self.contentView.addSubview(contentL)
        contentL.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-60)
            make.height.equalTo(40)
            make.bottom.equalTo(progress.snp.top).offset(0)
        }
        
        releaseTitleL = UILabel.initSomeThing(title: "", titleColor: .white, font: .SemiboldFont(size: 16), ali: .left)
        
        releaseTitleL.numberOfLines = 2
        self.contentView.addSubview(releaseTitleL)
        releaseTitleL.snp.makeConstraints { make in
            make.right.equalTo(contentL)
            make.left.equalTo(contentL)
            make.height.equalTo(20)
            make.bottom.equalTo(contentL.snp.top).offset(-8)
        }
        
        
        self.contentView.addSubview(hiddenBtn)
        hiddenBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.hiddenBtn.isSelected = !self.hiddenBtn.isSelected
            self.hiddenAction()
        }
        hiddenBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.top.equalTo(contentL).offset(-6)
        }
        
        
        let leftBtn = UIButton.initBgImage(imgname: "icon-fanhui-baise")
        self.contentView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { make in
            
            make.leading.equalTo(0)
            make.top.equalTo(navView)
            make.height.width.equalTo(48)
        }
        
        leftBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        self.contentView.addSubview(giftView)
        giftView.snp.makeConstraints { make in
            make.center.equalTo(navView)
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        
        
        self.contentView.addSubview(detaileShareBtn)
        detaileShareBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-12)
            make.centerY.equalTo(navView)
            make.height.width.equalTo(24)
        }
        detaileShareBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.isAuthor{
                self.goToShare()
            }else{
                self.showBottomAlert()
            }
        }
        
        
        
        editBtn.titleLabel?.font = UIFont.MediumFont(size: 13)
        self.contentView.addSubview(editBtn)
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
        editBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = SSReleaseNewsViewController()
            vc.notesDetaile = self.detaileModel
            vc.inType = 6
            DispatchQueue.main.async {
                HQGetTopVC()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        editBtn.isHidden = true
        
        giftView.giftBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            self?.jumpToGiftRank()
        })
        
        headBtn.layer.cornerRadius = 18
        headBtn.layer.masksToBounds = true
        self.contentView.addSubview(headBtn)
        headBtn.setImage(UIImage.init(named: "kecheng_qipao"), for: .normal)
        headBtn.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.height.width.equalTo(36)
            make.bottom.equalTo(releaseTitleL.snp.top).offset(-16)
        }
        headBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.clickHeadImage()
        })
        
        
        nickNameL = UILabel.initSomeThing(title: "", fontSize: 17, titleColor: .white)
        self.contentView.addSubview(nickNameL!)
        nickNameL!.snp.makeConstraints { make in
            make.leading.equalTo(headBtn.snp.trailing).offset(normalMarginHeight)
            make.centerY.equalTo(headBtn)
        }
        
        self.contentView.addSubview(focusBtn)
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
        
        self.contentView.addSubview(timeView)
        timeView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-200)
        }
        timeView.isHidden = true
        
        timeView.addSubview(timeLab)
        timeLab.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalTo(screenWid / 2 - 15)
        }
        
        let timeLine = UILabel.initSomeThing(title: "/", titleColor: .gray, font: .systemFont(ofSize: 25), ali: .center)
        timeView.addSubview(timeLine)
        timeLine.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        timeView.addSubview(totalTimeLab)
        totalTimeLab.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(screenWid / 2 - 15)
        }
        
        
        
        customTap(target: self, action: #selector(playVCAction), view: player.view)
        self.addBtnClick()
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentFinish), name: CommentCompletionNotification, object: nil)
    }
    
    func reloadVedioUrl(){
        let url = URL(string: self.detaileModel?.videoUrl ?? "")
        if url != nil {
            self.player.url = url
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func playVCAction() {
        self.progress.tintColor = .clear
        self.minProgress.isHidden = false
        self.timeView.isHidden = true
        self.hiddenBtn.isSelected = false
        self.hiddenBtn.isHidden = false
        self.hiddenAction()
        player._avplayer.pause()
        playBtn.isHidden = false
    }
    
    ///评论完成
    @objc func commentFinish(){
        self.endEditing(false)
        self.detaileCommitView.vc.textView.text = ""
        self.detaileCommitView.page = 1
        self.detaileCommitView.loadCommitData()
        let postTimes = detaileModel?.postTimes ?? 0
        detaileModel?.postTimes = postTimes + 1
        commentView.pinglunBtn.setTitle(String(detaileModel?.postTimes ?? 0), for: .normal)
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
                            
                            self?.isFocus = model?.data ?? false
                            self?.focusBtn.setTitle(self?.isFocus == true ? "已关注" : "关注", for: .normal)
                            
                            
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
                                if self.rankModels?.gifts != nil && (self.rankModels?.gifts?.content!.count ?? 0 > 0){
                                    self.giftView.images = self.rankModels?.gifts?.content!
                                    
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
    @objc func clickHeadImage(){
        //        (UserInfo.getSharedInstance().userId ?? ""))
        let vc = SSPersionDetailViewController.init()
        vc.cid = detaileModel?.authorId ?? ""
        HQGetTopVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///跳转到分享页面
    func goToShare() {
        let vc = ShareVC()
        vc.type = 4
        vc.notesModel = self.detaileModel!
        vc.setupMainView()
        HQPush(vc: vc, style: .lightContent)
    }
    
    ///跳转到礼物排行榜
    func jumpToGiftRank()  {
        
        let vc = GiftRankVC()
        vc.mainView.mainId = self.cid
        vc.mainView.type = 3
        vc.mainView.userId = detaileModel?.authorId ?? ""
        vc.mainView.isSelf = detaileModel?.authorId == (UserInfo.getSharedInstance().userId ?? "")
        vc.mainView.titleText = detaileModel?.userName ?? ""
        HQPush(vc: vc, style: .default)
    }
    
    ///显示或隐藏底部页面
    @objc func hiddenAction() {
        if self.hiddenBtn.isSelected == true{
            self.headBtn.isHidden = true
            self.contentL.isHidden = true
            self.releaseTitleL.isHidden = true
            self.nickNameL?.isHidden = true
            self.focusBtn.isHidden = true
        }else{
            self.headBtn.isHidden = false
            self.contentL.isHidden = false
            self.releaseTitleL.isHidden = false
            self.nickNameL?.isHidden = false
            self.focusBtn.isHidden = false
            //                self?.showMoreTitleBtn.isHidden = false
        }
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
                            if dic != nil {
                                self?.detaileModel = dic?.kj.model(SSNotesDetaileModel.self)
                                
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
    
    func loadPlayData() -> Void {
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
                            if dic != nil {
                                self?.detaileModel = dic?.kj.model(SSNotesDetaileModel.self)
                                self?.reloadVedioUrl()
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
    
    func refreshData() -> Void {
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
    }
    
    
    func addBtnClick()  {
        
        navDetailView.clickFocusBtnHandler = { button in
            self.focusOption(button: button)
            
        }
        
        commentView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        commentView.giftBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            ///上报事件
            HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":"动态",
                                                              "content_id":""])
            ///显示发送礼物界面
            let giftView = GiftListView()
            giftView.sid = self.detaileModel?.id ?? ""
            giftView.uid = self.detaileModel?.authorId ?? "-1"
            giftView.type = 3
            giftView.sendGiftBlock = {
                
            }
            HQGetTopVC()?.view.addSubview(giftView)
            giftView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        commentView.pinglunBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.detaileCommitView = SSDetaileCommitView()
            self.detaileCommitView.cid = self.detaileModel?.id ?? ""
            self.detaileCommitView.page = 1
            self.detaileCommitView.model = self.dataModel
            self.detaileCommitView.loadCommitData()
            self.detaileCommitView.backgroundColor = .clear
            DispatchQueue.main.async {
                HQGetTopVC()?.view.addSubview(self.detaileCommitView)
                self.detaileCommitView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        
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
                                
                                var num:Int = self.detaileModel?.likeTimes?.toInt ?? 0
                                num += btn.isSelected ? 1 : -1
                                if num < 0{
                                    num = 0
                                }
                                btn.setTitle(String(num), for: .normal)
                                HQGetTopVC()?.view.makeToast(btn.isSelected ? "点赞成功" : "取消成功")
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
                                var num:Int = self.detaileModel?.collectTimes?.toInt ?? 0
                                num += btn.isSelected ? 1 : -1
                                
                                if num < 0{
                                    num = 0
                                }
                                btn.setTitle(String(num), for: .normal)
                                HQGetTopVC()?.view.makeToast(btn.isSelected ? "收藏成功" : "取消成功")
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
}


extension SSVedioListCell : PlayerDelegate,PlayerPlaybackDelegate{
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        HQGetTopVC()?.view.makeToast("视频加载失败，请稍后重试")
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        timeShowNum += 1
        ///1秒后隐藏时间文本
        if timeShowNum == 100 {
            self.minProgress.isHidden = false
            self.progress.tintColor = .clear
            self.progress.thumbTintColor = .clear
            self.timeView.isHidden = true
            self.hiddenBtn.isSelected = false
            self.hiddenBtn.isHidden = false
            self.hiddenAction()
        }
        if timeShowNum < 100 {
            return
        }
        if timeShowNum > 10000 {
            timeShowNum = 300
        }
        let fraction = Double(player.currentTime.seconds) / Double(player.maximumDuration)
        self.progress.value = Float(fraction)
        self.minProgress.progress = Float(fraction)
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        self.playBtn.isHidden = true
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        self.player._avplayer.seek(to: CMTime.zero)
        self.timeView.isHidden = true
        //        self.playBtn.isHidden = false
        self.player._avplayer.play()
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    ///用户是否被拉黑
    func loadSlectBlack()  {
                    
        UserInfoNetworkProvider.request(.getSelectBlack(blackUserId: cid)) { [weak self] result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultStringModel.self)
                            if model?.code == 0 {
                                
                                if model?.data != nil {
                                    
                                    if model?.data == "0" {
                                        self?.isSlectBlack = false
                                    }else{
                                        self?.isSlectBlack = true
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
    
    ///拉黑用户
    func loadAddUserBlack()  {
                    
        UserInfoNetworkProvider.request(.getAddUserBlack(blackUserId: detaileModel?.authorId ?? "")) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultStringModel.self)
                            if model?.code == 0 {
                                DispatchQueue.main.async {
                                    let tipString = model?.data ?? ""
                                    HQGetTopVC()?.view.makeToast(tipString)
                                    if tipString.contains("解除"){
                                        
                                    }else{
                                        self.reloadBlock?(self.detaileModel?.id ?? "")
                                    }
                                }
                            }
                        }
                    }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
                }
            }
        }
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        let share = UIAlertAction(title:"分享", style: .default)
        {
            action in
            self.goToShare()
        }
        
        alertController.addAction(cancel)
        
        let disAgree = UIAlertAction(title:"投诉", style: .default)
        {
            action in
            let cpView = ComplainView()
            cpView.contentType = 5
            cpView.sourceId = self.detaileModel?.id ?? ""
            HQGetTopVC()?.view.addSubview(cpView)
            cpView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        }
        
        let blackBtn = UIAlertAction(title:self.isSlectBlack == false ? "拉黑作者" : "解除拉黑", style: .default)
        {[weak self]
            action in
            self?.loadAddUserBlack()
        }
        alertController.addAction(share)
        alertController.addAction(disAgree)
        alertController.addAction(blackBtn)
        
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
    
}
