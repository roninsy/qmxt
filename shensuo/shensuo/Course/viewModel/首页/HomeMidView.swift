//
//  HomeMidView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/31.
//

import UIKit
import BSText


class HomeMidView: UIView {
    
//    var touchBlock : stringBlock? = nil
    
    let tipLab = UILabel.initSomeThing(title: "为您推荐", titleColor: .init(hex: "#313131"), font: .boldSystemFont(ofSize: 18), ali: .left)
    let playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    let musicView = MusicPlayView()
    var url : String? = nil{
        didSet{
            if url != nil{
                let palyerItem = AVPlayerItem(url: NSURL(string: url!)! as URL)
                self.player = AVPlayer.init(playerItem: palyerItem)
                self.player.rate = 1.0//播放速度 播放前设置
                self.playerLayer.player = self.player
                playerLayer.videoGravity = .resizeAspect
                //播放
                self.player.play()
            }
        }
    }
    let playerWid = screenWid - 44
    let playerHei = (screenWid - 44) / 16 * 9
    var myHei : CGFloat = 140
    
    let courseBg = UIView()
    let courseImg = UIImageView.initWithName(imgName: "normal_img_zfx")
    let courseTitle = UILabel.initSomeThing(title: "形体美学课程，美丽换新升级", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 14), ali: .left)
    let subLab = BSLabel()
    let collectBtn = UIButton()
    let collectLab = UILabel.initSomeThing(title: "收藏", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 11), ali: .center)
    ///静音按钮
    let muteBtn = UIButton()
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil {
                self.url = model?.productionUrl
                self.musicView.isHidden = model!.video
                if !model!.video {
                    self.musicView.type = 1
                    self.musicView.setupUI()
                    self.musicView.model = model
                }
                self.courseImg.kf.setImage(with: URL.init(string: model!.headerImage ?? ""),placeholder: UIImage.init(named: "normal_wid_max"))
                self.courseTitle.text = model!.title
                self.collectBtn.isSelected = model!.collect
                self.collectLab.text = model!.collect ? "已收藏" : "收藏"
                let total = String(model!.totalStep?.intValue ?? 1)
                let protocolText = NSMutableAttributedString(string: "基础课程：共\(total)节")
                protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 6, length: total.length))
               
                protocolText.bs_font = .boldSystemFont(ofSize: 11)
                subLab.attributedText = protocolText
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        self.addSubview(self.tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.right.equalToSuperview()
            make.height.equalTo(60)
        }
        self.playerLayer.frame = .init(x: 10, y: 60, width: playerWid, height: playerHei)
        self.playerLayer.cornerRadius = 8
        self.playerLayer.masksToBounds = true
        self.layer.addSublayer(playerLayer)
         myHei += playerHei
        
        musicView.backgroundColor = .init(hex: "#333333")
        musicView.layer.cornerRadius = 8
        musicView.layer.masksToBounds = true
        self.musicView.frame = self.playerLayer.frame
        self.addSubview(musicView)
        
        courseBg.layer.cornerRadius = 8
        courseBg.layer.masksToBounds = true
        self.addSubview(courseBg)
        courseBg.backgroundColor = .init(hex: "#F6F7F8")
        courseBg.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(60)
        }
        
        courseImg.contentMode = .scaleAspectFill
        courseImg.layer.masksToBounds = true
        courseBg.addSubview(courseImg)
        courseImg.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.left.top.equalToSuperview()
        }
        
        courseBg.addSubview(courseTitle)
        courseTitle.snp.makeConstraints { make in
            make.left.equalTo(courseImg.snp.right).offset(10)
            make.height.equalTo(20)
            make.top.equalTo(9)
            make.right.equalTo(-38)
        }
        
        subLab.textColor = .init(hex: "#999999")
        courseBg.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.left.equalTo(courseTitle)
            make.height.equalTo(16)
            make.bottom.equalTo(-5)
            make.right.equalTo(courseTitle)
        }
        
        courseBg.addSubview(collectBtn)
        collectBtn.setImage(UIImage.init(named: "collect_icon_black"), for: .normal)
        collectBtn.setImage(UIImage.init(named: "collect_icon_sel"), for: .selected)
        collectBtn.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(21)
            make.right.equalTo(-13)
            make.top.equalTo(8)
        }
        
        let cBtn = UIButton()
        courseBg.addSubview(cBtn)
        cBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.right.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        
        cBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            CommunityNetworkProvider.request(.addCollect(sourceId: self.model?.id ?? "", type: 1)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                self.collectBtn.isSelected = !self.collectBtn.isSelected
                                self.collectLab.text = self.collectBtn.isSelected ? "已收藏" : "收藏"
                            }
                        }
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
        }
        
        
        courseBg.addSubview(collectLab)
        collectLab.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(16)
            make.centerX.equalTo(collectBtn)
            make.bottom.equalTo(-5)
        }
        
        muteBtn.setImage(UIImage.init(named: "home_play_mute_sel"), for: .normal)
        muteBtn.setImage(UIImage.init(named: "home_play_mute"), for: .selected)
        self.addSubview(muteBtn)
        muteBtn.snp.makeConstraints { make in
            make.right.top.equalTo(self.musicView)
            make.width.equalTo(36)
            make.height.equalTo(28)
        }
        
        muteBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            btn.isSelected = !btn.isSelected
            self.player.isMuted = btn.isSelected
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playEnd(){
        self.player.currentItem?.seek(to: .zero, completionHandler: { flag in
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if model != nil {
            GotoTypeVC(type: 2, cid: model?.id ?? "")
        }
    }
    
}
