//
//  StepPlayView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/21.
//

import UIKit
import BMPlayer
import AVKit
import MediaPlayer
import WebKit

enum PlayFinishType {
    ///退出
    case exit
    ///上一节
    case frontStep
    ///下一节
    case nextStep
}

class StepPlayView: UIView{
    ///是否为新增完成
    var isFinish = false
    var totalMin : Double = 0
    var totalKll : Double = 0
    var totalPoints : Int = 0
    var finishDic = NSMutableDictionary()
    ///已完成小节字符串
    var finishStepStr = ""
    var isAdd = false
    var finishType : PlayFinishType = .exit
    var cv : FrontCameraView? = nil
    let wid = screenWid
    let hei = screenHei
    var musicView = UIView()
    
    var playerVC : BMPlayer? = nil
    var playUrl : String? = nil{
        didSet{
            if playUrl != nil && playUrl!.length > 10 {
                self.playWithURL(url: playUrl!)
            }
        }
    }
    
    var reSeek : Double = 0
    
    lazy var musicPlayView : MusicPlayView = { () -> MusicPlayView in
        let mv = MusicPlayView()
        mv.setupUI()
        self.playerVC?.playerLayer?.addSubview(mv)
        mv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.playerVC?.bringSubviewToFront((self.playerVC?.controlView)!)
        return mv
    }()
    ///小节ID
    var cid = ""
    let listView = StepListViewForPlayView()
    var detalisView : StepDetalisForPlayView? = nil
    var stepNumView : StepNumForPlayView? = nil
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil{
                self.needLock = model2?.isAdd == false && model?.freeTry == false
                self.cid = model?.id ?? ""
                //                if model!.video == true {
                
                //                }else{
                //                    self.setupVideoView()
                //                }
            }
        }
    }
    
    var webHei :CGFloat = 0
    
    let musicBtnView = StepMusicBtnView()
    let vedioImg : UIImageView = UIImageView.initWithName(imgName: "normal_wid_max")
    let vedioBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "home_play"))
    
    let lockLab = UILabel.initSomeThing(title: "小节详情付费方可查看", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 16), ali: .left)
    let webView = WKWebView()
    var webFinishBlock : voidBlock?
    //
    
    var myHei : CGFloat = 0
    let imgWid : CGFloat = (screenWid - 32)
    let imgHei : CGFloat = (screenWid - 32) / 394 * 207
    
    var htmlStr : String? = nil{
        didSet{
            if htmlStr?.length == 0 {
                return
            }
            do{
                if needLock {
                    self.lockLab.isHidden = false
                    webView.snp.makeConstraints { make in
                        make.height.equalTo(22)
                    }
                    myHei = myHei + 30
                }else{
                    self.lockLab.isHidden = true
                    webView.loadHTMLString((htmlStr ?? ""), baseURL: nil)
                    
                }
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    var model2 = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
    
    var needLock = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        webView.backgroundColor = .white
        webView.isUserInteractionEnabled = false
        webView.navigationDelegate = self
        self.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(16)
            make.width.equalTo(screenWid - 32)
            make.height.equalTo(100)
            make.bottom.equalTo(-10)
        }
        self.isAdd = model2?.isAdd ?? false
    }
    
    func setupView(){
        self.needLock = model2?.isAdd == false && model?.freeTry == false && model2?.free == false
        self.setupVideoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVideoView(){
        if model?.video ?? false {
            vedioImg.layer.cornerRadius = 6
            vedioImg.layer.masksToBounds = true
            vedioImg.contentMode = .scaleAspectFill
            self.addSubview(vedioImg)
            vedioImg.snp.makeConstraints { make in
                make.width.equalTo(imgWid)
                make.height.equalTo(imgHei)
                make.top.equalTo(15)
                make.left.equalTo(16)
            }
            
            self.addSubview(vedioBtn)
            vedioBtn.snp.makeConstraints { make in
                make.width.height.equalTo(36)
                make.center.equalTo(vedioImg)
            }
            
            let vedioFullBtn = UIButton()
            self.addSubview(vedioFullBtn)
            vedioFullBtn.snp.makeConstraints { make in
                make.edges.equalTo(vedioImg)
            }
            
            vedioFullBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                self.upPlayUrl()
            }
            
            if needLock {
                ///加上视频锁
                let lockView = UIView()
                lockView.layer.cornerRadius = 6
                lockView.layer.masksToBounds = true
                lockView.backgroundColor = .black
                lockView.alpha = 0.53
                self.addSubview(lockView)
                lockView.snp.makeConstraints { make in
                    make.edges.equalTo(vedioImg)
                }
                
                let lockLab = UILabel.initSomeThing(title: "付费方可查看", titleColor: .white, font: .MediumFont(size: 14), ali: .center)
                self.addSubview(lockLab)
                lockLab.snp.makeConstraints { make in
                    make.height.equalTo(20)
                    make.width.equalTo(100)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(vedioBtn.snp.bottom).offset(3)
                }
                
                let lockBtn = UIButton()
                self.addSubview(lockBtn)
                lockBtn.snp.makeConstraints { make in
                    make.edges.equalTo(vedioImg)
                }
                lockBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                    self.upPlayUrl()
                }
            }
            
            self.webView.snp.updateConstraints { make in
                make.top.equalTo(imgHei + 25)
            }
            self.myHei = imgHei + 25
        }else{
            self.addSubview(musicBtnView)
            musicBtnView.model = model
            musicBtnView.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(57)
                make.top.equalTo(15)
            }
            let musicBtn = UIButton()
            self.addSubview(musicBtn)
            musicBtn.snp.makeConstraints { make in
                make.edges.equalTo(musicBtnView)
            }
            
            musicBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                self.upPlayUrl()
            }
            
            self.webView.snp.updateConstraints { make in
                make.top.equalTo(57 + 25)
            }
            
            self.myHei = 57 + 25
            self.musicBtnView.lockView.isHidden = !self.needLock
        }
        if needLock {
            self.webView.addSubview(lockLab)
            lockLab.snp.makeConstraints { make in
                make.top.left.equalToSuperview()
                make.width.equalTo(screenWid - 32)
                make.height.equalTo(20)
            }
            lockLab.isHidden = true
        }
        
    }
    
    func setupMusicView(){
        musicView.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(musicView)
        musicView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.height.equalTo(57)
            make.top.equalTo(15)
            make.left.equalTo(16)
        }
        
        self.webView.snp.updateConstraints { make in
            make.top.equalTo(57 + 25)
        }
        self.myHei += 57 + 25
    }
    
    func playWithURL(url:String){
        let videoURL = URL.init(string: url)
        if videoURL == nil {
            HQGetTopVC()?.view.makeToast("获取播放链接失败，请退出重试")
            return
        }
        if self.playerVC != nil {
            let asset = BMPlayerResource.init(url: videoURL!)
            playerVC!.setVideo(resource: asset)
            if model != nil{
                stepNumView?.model = model
                detalisView!.selNum = (model?.step?.intValue ?? 1) - 1
                if self.model2?.type != 0 {
                    playerVC!.controlView.dayLab.text = "第\(self.model?.day ?? 1)天"
                }
            }
            playerVC?.avPlayer?.allowsExternalPlayback = model?.video ?? true
            if self.model?.video == false {
                self.musicPlayView.isHidden = true
                self.playerVC?.controlView.tvBtn.isHidden = true
                self.playerVC?.controlView.cameraBtn.isHidden = true
                self.playerVC?.controlView.jixiangBtn.isHidden = true
            }else{
                self.musicPlayView.isHidden = false
                self.musicPlayView.model = self.model
                self.playerVC?.controlView.tvBtn.isHidden = false
                self.playerVC?.controlView.cameraBtn.isHidden = false
                self.playerVC?.controlView.jixiangBtn.isHidden = false
            }
            if self.reSeek != 0 {
                self.playerVC?.avPlayer?.seek(to: .init(value: CMTimeValue(self.reSeek), timescale: (self.playerVC?.avPlayer?.currentTime().timescale)!))
            }
            return
        }
        ///下个页面为横屏
        let rotation : UIInterfaceOrientationMask = .landscapeLeft
        //            [.landscapeLeft, .landscapeRight]
        let app = UIApplication.shared.delegate as! AppDelegate
        app.blockRotation = rotation
        UserInfo.getSharedInstance().noShowGiftMsg = true
        playerVC = BMPlayer()
        let asset = BMPlayerResource.init(url: videoURL!)
        playerVC!.setVideo(resource: asset)
        
        playerVC?.frame = HQGetTopVC()!.view.bounds
        playerVC?.playerLayer?.frame = HQGetTopVC()!.view.bounds
        HQGetTopVC()?.view.addSubview(playerVC!)
        
        playerVC?.controlView.backButton.reactive.controlEvents(.touchUpInside).observeValues({ btn in
            self.showEndView(isEnd: false)
        })
        
        UserInfo.getSharedInstance().showSVGAMsg = false
        
        if !(self.model?.video ?? false) {
            ///设置音乐播放UI
            self.musicPlayView.isHidden = false
            self.musicPlayView.model = self.model
        }else{
            self.musicPlayView.isHidden = true
        }
        
        let giftView = GiftRankForPlayView()
        playerVC!.controlView.giftRankView.addSubview(giftView)
        giftView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(30)
            make.top.left.equalTo(0)
        }
        giftView.mainID = self.cid
        giftView.getNetInfo()
        
        self.stepNumView = StepNumForPlayView()
        if model != nil{
            stepNumView?.model = model
        }
        playerVC!.controlView.dayView.isHidden = self.model2?.type == 0
        if self.model2?.type != 0 {
            playerVC!.controlView.dayLab.text = "第\(self.model?.day ?? 1)天"
        }
        playerVC!.controlView.stepNumView.addSubview(stepNumView!)
        stepNumView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        playerVC!.controlView.selBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] btn in
            self?.playerVC?.controlView.stepListView.isHidden = false
        }
        
        playerVC!.controlView.detalisBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] btn in
            self?.playerVC?.controlView.stepDetalisView.isHidden = false
        }
        
        //        tvBtn.setImage(UIImage.init(named: "play_tv_sel"), for: .selected)
        //        tvBtn.setImage(UIImage.init(named: "play_tv"), for: .normal)
        //        - (void)routePickerViewWillBeginPresentingRoutes:(AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)){
        //            _lab.text = @"AirPlay界面弹出时回调";
        //        }
        //        //AirPlay界面结束时回调
        //        - (void)routePickerViewDidEndPresentingRoutes:(AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)){
        //            _lab.text = @"AirPlay界面结束时回调";
        //        }
        let mpv = MPVolumeView()
        let tvIcon = UIImageView.initWithName(imgName: "play_tv")
        mpv.addSubview(tvIcon)
        tvIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mpv.showsVolumeSlider = false
        mpv.showsRouteButton = true
        playerVC!.controlView.tvBtn.addSubview(mpv)
        mpv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(audioChangedNotification(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
        //        playerVC!.controlView.tvBtn
        
        
        playerVC!.controlView.jixiangBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] btn in
            btn.isSelected = !btn.isSelected
            self?.changgeJixiang(isSel: btn.isSelected)
        }
        
        playerVC!.controlView.cameraBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] btn in
            btn.isSelected = !btn.isSelected
            if btn.isSelected{
                self?.openCamera()
            }else{
                self?.closeCamera()
            }
        }
        
        if model2 != nil {
            playerVC?.controlView.stepListView.snp.makeConstraints { make in
                make.width.equalTo(168)
                make.top.bottom.equalToSuperview()
                make.right.equalTo((isFullScreen ? -40 : 0))
            }
            
            
            listView.models = model2?.courseStepList ?? []
            playerVC?.controlView.stepListView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            listView.selIndex = { selNum in
                let model = self.listView.models[selNum]
                self.model = model
                self.upPlayUrl()
            }
            
            playerVC?.controlView.stepDetalisView.snp.makeConstraints { make in
                make.width.equalTo(358)
                make.top.bottom.equalToSuperview()
                make.right.equalTo((isFullScreen ? -40 : 0))
            }
            
            detalisView = StepDetalisForPlayView()
            detalisView!.models = model2?.courseStepList ?? []
            detalisView!.selNum = (model?.step?.intValue ?? 1) - 1
            detalisView!.isAdd = self.isAdd
            playerVC?.controlView.stepDetalisView.addSubview(detalisView!)
            detalisView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        
        //        playerVC!.controlView.giftBtn.reactive.controlEvents(.valueChanged).observeValues { sw in
        //            UserInfo.getSharedInstance().noShowGiftMsg = !sw.isOn
        //        }
        //        let stepDetalis = StepDetalisForPlayView()
        //        playerVC.controlView.topMaskView.addSubview(stepDetalis)
        //        stepDetalis.snp.makeConstraints { make in
        //            make.width.equalTo(358)
        //            make.top.bottom.right.equalToSuperview()
        //        }
        playerVC!.backBlock = {[weak self] (isFullScreen) in
            self?.closePlayView()
        }
        
        playerVC!.delegate = self
        
    }
    
    ///关闭播放页面
    func closePlayView(){
        DispatchQueue.main.async {
            UserInfo.getSharedInstance().noShowGiftMsg = false
            UserInfo.getSharedInstance().showSVGAMsg = true
            self.playerVC!.pause()
            self.playerVC!.removeFromSuperview()
            let app = UIApplication.shared.delegate as! AppDelegate
            app.blockRotation = .portrait
            self.playerVC = nil
        }
    }
    
    ///添加摄像头画面
    func openCamera(){
        DispatchQueue.main.async {
            ///添加前置摄像头画面
            self.cv = FrontCameraView.init(frame: CGRect.init(x: self.hei / 2, y: 0, width: self.hei / 2, height: self.wid))
            self.cv!.transform = CGAffineTransform.init(rotationAngle: .pi / 2)
            //        self.playerVC?.layer.addSublayer(cv!.layer)
            self.playerVC?.addSubview(self.cv!)
            self.playerVC?.bringSubviewToFront((self.playerVC?.controlView)!)
            
            self.playerVC!.playerLayer!.frame = CGRect.init(x: -120, y: 0, width: self.wid / 9 * 16, height: self.wid)
        }
        
    }
    func closeCamera(){
        cv?.removeFromSuperview()
        cv = nil
        self.playerVC!.playerLayer!.frame = CGRect.init(x: 0, y: 0, width: self.hei, height: self.wid)
    }
    
    func changgeJixiang(isSel:Bool){
        if #available(iOS 13.0, *) {
            self.playerVC?.controlView.onTapGestureTapped(.init())
            ///镜像旋转
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.65) {
                    if isSel{
                        self.playerVC?.playerLayer?.transform3D = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
                        
                    }else{
                        self.playerVC?.playerLayer?.transform3D = CATransform3DMakeRotation(CGFloat.pi * 2, 0, 1, 0)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    ///获取格言
    func upGeTan(){
        CourseNetworkProvider.request(.selectMottoForApp) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let content = model?.data?["content"] as? String ?? ""
                            let author = model?.data?["author"] as? String ?? ""
                            self.playerVC?.controlView.geYanLab.text = "\(content) \n———\(author)"
                        }
                    }
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    ///获取播放链接
    func upPlayUrl(){
        if (model?.freeTry ?? false) && (model?.productionUrl?.count ?? 0) > 0{
            ///免费试学
            self.playUrl = model?.productionUrl ?? ""
            self.upGeTan()
            return
        }else if !(self.isAdd){
            if model2?.free == true {
                HQGetTopVC()?.view.makeToast("请先加入学习")
            }else{
                HQGetTopVC()?.view.makeToast("请先返回课程详情购买")
            }
            return
        }
        
        CourseNetworkProvider.request(.selectCourseStepUrl(cid: cid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.playUrl = model?.data?["productionUrl"] as? String
                            self.upGeTan()
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
    
    func showEndView(isEnd:Bool){
        
        if model2?.userId == UserInfo.getSharedInstance().userId || model2?.isAdd == false {
            self.closePlayView()
            ///发布者本人
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
            return
        }
        ///播放结束
        let endView = PlayEndView()
        self.isFinish = isEnd
        if isEnd {
            let sid = self.model?.id ?? ""
            var arr = model2?.courseStepList ?? []
            if arr.count > 0 {
                for i in 0...arr.endIndex - 1 {
                    var tempModel = arr[i]
                    if tempModel.id == sid{
                        tempModel.finished = true
                        arr[i] = tempModel
                        self.model2?.courseStepList = arr
                        break
                    }
                }
            }
            let finish = (self.model?.step?.intValue ?? 1) >= (self.model2?.courseStepList?.count ?? 1)
            endView.isFirstVideo = (self.model?.id == self.model2!.courseStepList?[0].id)
            endView.isFinish = finish
            endView.isEnd = isEnd
        }else{
            self.playerVC?.pause()
            endView.topLab.text = "中途退出，\(self.model!.step?.stringValue ?? "0")/\(self.model!.totalStep?.stringValue ?? "0")小节学习记录将无法保存，也无法获得美币/徽章奖励，您确定要退出吗？"
        }
        if model2?.dayMap != nil {
            endView.stepList.finishStr = self.finishStepStr
            endView.stepList.finishDay = model2?.finishDays?.intValue ?? 0
            endView.stepList.dayMap = model2?.dayMap
        }else{
            endView.stepList.models = model2?.courseStepList ?? []
        }
        
        endView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.finishType = .exit
            endView.removeFromSuperview()
            self.finishWithType()
        }
        endView.quickBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if btn.title(for: .normal) == "残忍退出"{
                self.finishType = .exit
            }else{
                self.finishType = .frontStep
            }
            endView.removeFromSuperview()
            self.finishWithType()
        }
        endView.enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if isEnd{
                self.finishType = .exit
                self.finishWithType()
            }else{
                self.playerVC?.controlView.isHidden = false
                self.playerVC?.play()
            }
            endView.removeFromSuperview()
        }
        endView.nextBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.finishType = .nextStep
            endView.removeFromSuperview()
            self.finishWithType()
        }
        self.playerVC?.controlView.isHidden = true
        self.playerVC?.addSubview(endView)
        endView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    ///新增学习完成
    func endToFinish(){
        self.closeCamera()
        if self.model?.finished ?? false {
            return
        }
        CourseNetworkProvider.request(.addTraining(courseId: self.model2?.id ?? "", courseStepId: self.model?.id ?? "")) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let pointsDic = model?.data?["completionJobResult"] as? NSDictionary
                            let points = pointsDic?["pointsSum"] as? String
                            if points != "0" && points != "" && points != nil{
                                ///显示获得美币
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    ShowMeibiAddView(num: points?.toInt ?? 0)
                                }
                            }
                            self.isFinish = true
                            let fh = self.finishStepStr.count > 0 ? "、" : ""
                            ///添加小节完成信息
                            self.finishStepStr = "\(self.finishStepStr)\(fh)\(self.model?.step?.intValue ?? 1)/\(self.model?.totalStep?.intValue ?? 1)"
                            ///添加分钟和卡路里
                            self.totalMin += self.model?.minutes?.toDouble ?? 0
                            self.totalKll += self.model?.calorie?.doubleValue ?? 0
                            let dic = model?.data
                            let dic22 = dic?["completionJobResult"] as? NSDictionary
                            if dic22 != nil {
                                ///添加获得美币数量
                                self.totalPoints += dic22!["pointsSum"] as? Int ?? 0
                            }
                            
                            
                            if dic != nil {
                                let dic2 = NSMutableDictionary.init(dictionary: dic!)
                                dic2["topImage"] = self.model2?.headerImage ?? ""
                                self.finishDic = dic2
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
    
    ///显示学习感受页面
    func showFeelView(isEnd:Bool){
       
        if model2?.userId == UserInfo.getSharedInstance().userId {
            self.closePlayView()
            ///发布者本人
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
            return
        }

        if isEnd {
            let viewTime = playerVC?.avPlayer?.currentTime().seconds
            let feelView = FinishFeelView()
            feelView.cid = self.model2?.id ?? ""
            feelView.sid = self.model?.id ?? ""
            feelView.model = self.model2
            feelView.stepModel = self.model
            feelView.viewTime = viewTime ?? 0
            feelView.isEnd = isEnd
            self.playerVC?.addSubview(feelView)
            feelView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            feelView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                self.showEndView(isEnd: isEnd)
            }
            feelView.enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                self.showEndView(isEnd: isEnd)
            }
        }
        
    }
    
    ///根据类型进行结束课程
    func finishWithType(){
        self.playerVC?.controlView.isHidden = false
        switch finishType {
        case .exit:
            if self.isFinish {
                let vc = StudyFinishVC()
                vc.mainView.model = self.model2
                self.finishDic["finishStepStr"] = self.finishStepStr
                self.finishDic["totalMin"] = String.init(format:"%.0f",self.totalMin)
                self.finishDic["totalKll"] = String.init(format:"%.0f",self.totalKll)
                self.finishDic["totalPoints"] = String.init(format:"%d",self.totalPoints)
                vc.mainView.infoDic = self.finishDic
                self.closePlayView()
                HQPush(vc: vc, style: .lightContent)
            }else{
                ///中途退出
                let vc = StudyFinishVC()
                vc.mainView2.viewTime = playerVC?.avPlayer?.currentTime().seconds ?? 0
                vc.mainView2.model = self.model2
                vc.mainView2.stepModel = self.model
                vc.showUnfinish()
                self.closePlayView()
                HQPush(vc: vc, style: .lightContent)
            }
            
        case .frontStep:
            self.listView.finishId = self.cid
            var selIndex = self.model?.step?.intValue ?? 0
            selIndex -= 1
            if selIndex > 0 {
                selIndex -= 1
            }
            if (self.model2?.courseStepList?.count ?? 0) > selIndex{
                self.model = self.model2!.courseStepList![selIndex]
            }
            self.upPlayUrl()
        case .nextStep:
            self.listView.finishId = self.cid
            let selIndex = self.model?.step?.intValue ?? 0
            let allIndex = (self.model2?.courseStepList?.count ?? 1)
            if selIndex < allIndex {
                self.model = self.model2!.courseStepList![selIndex]
            }
            self.upPlayUrl()
        }
    }
}

extension StepPlayView : BMPlayerDelegate{
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
        if state == .readyToPlay {
            self.playerVC!.controlView.geYanLab.isHidden = true
        }
        if state == .playedToTheEnd {
            self.endToFinish()
            self.showFeelView(isEnd: true)
        }
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        if playing {
            self.playerVC!.controlView.geYanLab.isHidden = true
            self.upGeTan()
        }else{
            self.playerVC!.controlView.geYanLab.isHidden = false
        }
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        
    }
    @objc func audioChangedNotification(notification:NSNotification) {
        //        self.playWithAir()
    }
    
    func playWithAir(){
        let lay = AVPlayerLayer.init(layer: self.playerVC!.playerLayer!)
        lay.frame = self.bounds
        self.layer.addSublayer(lay)
    }
}


extension StepPlayView : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var webheight = 0.0
        // 获取内容实际高度
        self.webView .evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
                self.webView.snp.updateConstraints { make in
                    make.height.equalTo(webheight)
                }
                self.webHei = CGFloat(webheight)
                myHei = myHei + webHei
                self.webFinishBlock?()
            }
        }
    }
}
