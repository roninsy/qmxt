//
//  ShareForMedalView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit

class ShareForMedalView: UIView {
    let backBtn = UIButton.initWithBackBtn(isBlack: false)
    
    let titleLab = UILabel.initSomeThing(title: "晒晒我的徽章", titleColor: .white, font: .SemiboldFont(size: 18), ali: .center)
    
    let whiteBG = UIView()
    
    let mainImg = UIImageView.initWithName(imgName: "share_medal_top")
    
    let headView = UIImageView()
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .SemiboldFont(size: 16), ali: .center)
    
    let timeLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .systemFont(ofSize: 13), ali: .center)
    
    
    let medalView = CategoryForFinishView()
    
    let appLogoImg = UIImageView.initWithName(imgName: "my_icon")
    let sologenLab = UILabel.initSomeThing(title: "立挺美好人生", titleColor: .init(hex: "#999990"), font: .systemFont(ofSize: 12), ali: .left)
    
    let logoImg = UIImageView.initWithName(imgName: "share_logo_black")

    let qrCodeImg = UIImageView()
    
    let wechatBtn = UIButton.initTopImgBtn(imgName: "share_wechat_friend", titleStr: "微信好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let wechatLineBtn = UIButton.initTopImgBtn(imgName: "share_wechat_line", titleStr: "微信朋友圈", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let QQBtn = UIButton.initTopImgBtn(imgName: "share_qq", titleStr: "QQ好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let mdBtn = UIButton.initTopImgBtn(imgName: "share_md", titleStr: "保存到相册", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    
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
    
    ///徽章模型
    var medalModel : SSNotesBadgesModel? = nil{
        didSet{
            medalView.categoryImg.kf.setImage(with: URL.init(string: medalModel?.badgeImageUrl ?? ""))
            medalView.categoryName.text = medalModel?.badgeTypeName
            timeLab.text = "\(medalModel?.creatTime ?? "")\(medalModel?.creatTime ?? "获得")"
            self.shareBadge()
        }
    }
    
    ///获取版本号
    func shareBadge(){
        NetworkProvider.request(.shareBadge(badgeId: medalModel?.id ?? "")) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {

                        }
                    }
                }catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
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
            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalTo(backBtn)
        }

        whiteBG.layer.cornerRadius = 16
        whiteBG.layer.masksToBounds = true
        whiteBG.backgroundColor = .white
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.width.equalTo(330)
            make.height.equalTo(isBigScreen ? 532 : 450)
            make.centerX.equalToSuperview()
            make.top.equalTo(isFullScreen ? 142 : 80)
        }
        
        whiteBG.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(135)
        }
        
        let headBG = UIView()
        headBG.backgroundColor = .white
        headBG.layer.cornerRadius = 29
        headBG.layer.masksToBounds = true
        whiteBG.addSubview(headBG)
        headBG.snp.makeConstraints { make in
            make.width.height.equalTo(58)
            make.centerX.equalToSuperview()
            make.top.equalTo(106)
        }
        ///添加阴影
        let borderLayer1 = CALayer()
        borderLayer1.frame = headBG.bounds
        headBG.layer.addSublayer(borderLayer1)
        // shadowCode
        headBG.layer.shadowColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 0.5).cgColor
        headBG.layer.shadowOffset = CGSize(width: 0, height: 2)
        headBG.layer.shadowOpacity = 1
        headBG.layer.shadowRadius = 4
        
        headView.layer.cornerRadius = 27
        headView.layer.masksToBounds = true
        whiteBG.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.width.height.equalTo(54)
            make.center.equalTo(headBG)
        }
        
        whiteBG.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.left.right.equalToSuperview()
            make.top.equalTo(30)
        }
        
        
        whiteBG.addSubview(timeLab)
        timeLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(16)
            make.top.equalTo(nameLab.snp.bottom).offset(6)
            make.right.equalTo(-16)
        }
        
        ///添加勋章页面
        whiteBG.addSubview(medalView)
        medalView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(isBigScreen ? 200 : 160)
            make.top.equalTo(headBG.snp.bottom).offset(isBigScreen ? 36 : 16)
        }
        
        whiteBG.addSubview(appLogoImg)
        appLogoImg.snp.makeConstraints { make in
            make.height.equalTo(57)
            make.left.equalTo(16)
            make.bottom.equalTo(-30)
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
            make.bottom.equalTo(-36)
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
            make.right.equalTo(-15)
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
            var share_method = type == 1 ? "微信好友" : "微信朋友圈"
            if type == 3 {
                share_method = "QQ好友"
            }
            ///上报事件
            HQPushActionWith(name: "share_content", dic:  ["course_type":"徽章墙",
                                                           "content_id":"",
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
