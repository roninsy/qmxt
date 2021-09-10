//
//  ShareForProjectView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/3.
//

import UIKit

class ShareForProjectView: UIView {
    ///0 二维码名片 1.课程。10、方案 2。分享徽章 3.分享礼物间 4.动态 5.vip 6.徽章墙 7、美丽日记 8、美丽相册
    var type = 1
    
    let backBtn = UIButton.initWithBackBtn(isBlack: false)
    
    let titleLab = UILabel.initSomeThing(title: "分享", titleColor: .white, font: .SemiboldFont(size: 18), ali: .center)
    
    let whiteBG = UIView()
    
    let mainImg = UIImageView()
    let mainBotImg = UIImageView.initWithName(imgName: "share_project_bot")
    
    let headView = UIImageView()
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#000000"), font: .MediumFont(size: 17), ali: .left)
    
    let topNameLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .SemiboldFont(size: 20), ali: .left)
    let topGiftLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .SemiboldFont(size: 20), ali: .left)
    
    let sublab = UILabel.initSomeThing(title: "邀请您加入全民形体学习课程", titleColor: .init(hex: "#000000"), font: .systemFont(ofSize: 15), ali: .left)
    
    let appLogoImg = UIImageView.initWithName(imgName: "my_icon")
    let sologenLab = UILabel.initSomeThing(title: "立挺美好人生", titleColor: .init(hex: "#999990"), font: .systemFont(ofSize: 12), ali: .left)
    
    let logoImg = UIImageView.initWithName(imgName: "share_logo_black")

    let qrCodeImg = UIImageView()
    
    let wechatBtn = UIButton.initTopImgBtn(imgName: "share_wechat_friend", titleStr: "微信好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let wechatLineBtn = UIButton.initTopImgBtn(imgName: "share_wechat_line", titleStr: "微信朋友圈", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let QQBtn = UIButton.initTopImgBtn(imgName: "share_qq", titleStr: "QQ好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let mdBtn = UIButton.initTopImgBtn(imgName: "share_md", titleStr: "保存到相册", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    
    ///只是分享
    var onlyShare = false{
        didSet{
            if onlyShare {
                self.sublab.text = "邀请您加入全民形体"
                self.mainImg.image = UIImage.init(named: "share_user")
            }
        }
    }
    
    var model : MyShareModel? = nil{
        didSet{
            if model != nil {
                self.headView.kf.setImage(with: URL.init(string: model!.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.nameLab.text = model?.nickName
                self.nameLab.sizeToFit()
                self.qrCodeImg.image = (model!.qrCodeUrl ?? ShareRegisterURL).creatQRImage(size: 100)

            }
        }
    }
    
    var detalisModel : CourseDetalisModel? = nil{
        didSet{
            if detalisModel != nil {
                self.mainImg.kf.setImage(with: URL.init(string: detalisModel!.headerImage ?? ""),placeholder: UIImage.init(named: "big_normal_v"))
               
            }
        }
    }
    
    //详情
    var xqModel:SSXCXQModel? = nil {
        didSet{
            if xqModel != nil {
                if xqModel?.images.count != 0 {
                    self.mainImg.kf.setImage(with: URL.init(string: xqModel!.images[0]),placeholder: UIImage.init(named: "big_normal_v"))
                }else{
                    self.mainImg.image = UIImage.init(named: "share_user")
                }
            }
        }
    }
    
    var notesModel : SSNotesDetaileModel? = nil{
        didSet{
            if notesModel != nil {
                self.mainImg.kf.setImage(with: URL.init(string: notesModel!.headerImageUrl ?? ""),placeholder: UIImage.init(named: "big_normal_v"))
               
            }
        }
    }
    
    var giftModel : GiftRankModel? = nil{
        didSet{
            self.topNameLab.text = giftModel?.name
            self.topGiftLab.text = "收到了\(giftModel?.totalPeople ?? 0)人的\(giftModel?.totalGifts ?? 0)件礼物"
        }
    }
    
    var isGiftRoom = false{
        didSet{
            if isGiftRoom {
                self.mainImg.image = UIImage.init(named: "share_gift_top")
                self.topNameLab.isHidden = false
                self.topGiftLab.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#353535")
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(51)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalTo(backBtn)
        }
        
        let minHei : CGFloat = isFullScreen ? 0 : 130
        
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 16
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.width.equalTo(366)
            make.height.equalTo(592 - minHei)
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
        }
        
        mainImg.frame = .init(x: 16, y: 16, width: 334, height: 398 - minHei)
        mainImg.contentMode = .scaleAspectFill
        whiteBG.addSubview(mainImg)
        HQRoude(view: mainImg, cs: [.topLeft,.topRight], cornerRadius: 16)
        
        whiteBG.addSubview(mainBotImg)
        mainBotImg.snp.makeConstraints { make in
            make.width.equalTo(334)
            make.height.equalTo(52)
            make.left.equalTo(mainImg)
            make.bottom.equalTo(mainImg.snp.bottom).offset(1)
        }
        
        
        whiteBG.addSubview(topNameLab)
        topNameLab.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.height.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(56)
        }
        
        whiteBG.addSubview(topGiftLab)
        topGiftLab.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.height.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(56 + 32)
        }
        topNameLab.isHidden = true
        topGiftLab.isHidden = true
        
        headView.layer.cornerRadius = 32
        headView.layer.masksToBounds = true
        whiteBG.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(53)
            make.bottom.equalTo(-133)
        }
        
        whiteBG.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(headView.snp.bottom).offset(12)
        }
        nameLab.sizeToFit()
        
        let nameLine = UIView()
        whiteBG.addSubview(nameLine)
        nameLine.backgroundColor = .init(hex: "#333333")
        nameLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(16)
            make.centerY.equalTo(nameLab)
            make.left.equalTo(nameLab.snp.right).offset(10)
        }
        
        whiteBG.addSubview(sublab)
        sublab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(nameLine).offset(11)
            make.top.equalTo(nameLab)
            make.right.equalTo(-16)
        }
        
        
        whiteBG.addSubview(appLogoImg)
        appLogoImg.snp.makeConstraints { make in
            make.height.equalTo(57)
            make.left.equalTo(16)
            make.bottom.equalTo(-20)
            make.width.equalTo(57)
        }
        
        whiteBG.addSubview(logoImg)
        logoImg.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.left.equalTo(appLogoImg.snp.right).offset(12)
            make.top.equalTo(appLogoImg).offset(9)
            make.width.equalTo(82)
        }
        
        whiteBG.addSubview(sologenLab)
        sologenLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.left.equalTo(86)
            make.bottom.equalTo(-24)
            make.width.equalTo(80)
        }
        
//        let qrBg = UIButton.initWithLineBtn(title: "", font: .systemFont(ofSize: 12), titleColor: .white, bgColor: .white, lineColor: .init(hex: "#EEEFF0"), cr: 0)
//        whiteBG.addSubview(qrBg)
//        qrBg.snp.makeConstraints { make in
//            make.height.equalTo(68)
//            make.right.equalTo(-16)
//            make.bottom.equalTo(-20)
//            make.width.equalTo(68)
//        }
        
        whiteBG.addSubview(qrCodeImg)
        qrCodeImg.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.centerY.equalTo(appLogoImg)
            make.right.equalTo(mainImg)
            make.width.equalTo(80)
        }


        let shareBtnArr = [wechatBtn,wechatLineBtn,QQBtn,mdBtn]
        let btnWid = screenWid / 4
        for i in 0...3{
            let btn = shareBtnArr[i]
            btn.tag = i
            self.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.width.equalTo(btnWid)
                make.height.equalTo(81)
                make.left.equalTo(CGFloat(i) * btnWid)
                make.bottom.equalTo(isFullScreen ? -51 : -10)
            }
            btn.reactive.controlEvents(.touchUpInside).observeValues { btn2 in
                self.shareWithType(type: btn2.tag + 1)
            }
        }
        
        getNetInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        UserNetworkProvider.request(.QRCode) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.model = model?.data?.kj.model(MyShareModel.self)
                        }
                    }
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    ///1.微信好友，2.微信朋友圈 3.QQ好友 4.新浪微博
    func shareWithType(type:Int){
        if type != 4 {
            var contentId = ""
            var share_method = type == 1 ? "微信好友" : "微信朋友圈"
            if type == 3 {
                share_method = "QQ好友"
            }
            var typeName = self.type == 1 ? "课程" : "方案"
            contentId = self.detalisModel?.id ?? ""
            if onlyShare {
                typeName = "个人主页"
            }
            if isGiftRoom {
                typeName = "礼物间"
            }
            if notesModel != nil {
                typeName = "动态"
                contentId = self.notesModel?.id ?? ""
            }
            if type == 7 {
                typeName = "美丽日记"
                contentId = self.xqModel?.id ?? ""
            }
            ///上报事件
            HQPushActionWith(name: "share_content", dic:  ["course_type":typeName,
                                                           "content_id":contentId,
                                                                     "share_method":share_method])
        }
        let msg = JSHAREMessage()
        if type == 1 {
            msg.title = "[\(model?.nickName ?? "")]邀请您加入全民形体学习"
            msg.text = "立挺美好人生，和我一起变美吧~"
            msg.url = model!.qrCodeUrl ?? ShareRegisterURL
            msg.image =  headView.image!.jpegData(compressionQuality: 0.8)
            msg.mediaType = .link
            msg.platform = .wechatSession
        }else if type == 2 {
            msg.image = getImageFromView(view: whiteBG).jpegData(compressionQuality: 0.8)
            msg.mediaType = .image
            msg.platform = .wechatTimeLine
        }else if type == 3 {
            msg.title = "[\(model?.nickName ?? "")]邀请您加入全民形体学习"
            msg.text = "立挺美好人生，和我一起变美吧~"
            msg.url = model!.qrCodeUrl ?? ShareRegisterURL
            msg.image =  headView.image!.jpegData(compressionQuality: 0.8)
            msg.mediaType = .link
            msg.platform = .QQ
        }else if type == 4 {
            self.loadImage(image: getImageFromView(view: whiteBG))
        }
        
        var flag = true
        if type == 1 || type == 2 {
            flag = CheckAppInstalled(type: 0)
        }else if type == 3{
            flag = CheckAppInstalled(type: 2)
        }
        if !flag {
            return
        }
        
        JSHAREService .share(msg) { state, error in
            
        }
    }
    
    func loadImage(image:UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil{
            self.makeToast("保存失败，请检查相册权限")
        }else{
            self.makeToast("保存成功")
        }
        
    }
}
