//
//  ShareForInfoView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/2.
//

import UIKit
import BSText

class ShareForInfoView: UIView {
    
    let bgImage = UIImageView()
    
    let backBtn = UIButton.initWithBackBtn(isBlack: false)
    
    let titleLab = UILabel.initSomeThing(title: "二维码名片", titleColor: .white, font: .SemiboldFont(size: 18), ali: .center)
    
    let whiteBG = UIView()

    let headView = UIImageView()
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#000000"), font: .MediumFont(size: 17), ali: .left)
    let vipIcon = UIImageView.initWithName(imgName: "vip_icon")
    
    let checkIcon = UIImageView()
    let sublab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#000000"), font: .systemFont(ofSize: 13), ali: .left)
    ///总分钟
    let minLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 20), ali: .left)
    let minTip = UILabel.initSomeThing(title: "总分钟", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .left)
    ///总消耗
    let kllLab = BSLabel()
    let kllTip = UILabel.initSomeThing(title: "总消耗", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .left)
    ///总消耗
    let daysLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 20), ali: .left)
    let daysTip = UILabel.initSomeThing(title: "总天数", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .left)
    
    let sologenLab = UILabel.initSomeThing(title: "立挺美好人生", titleColor: .init(hex: "#999990"), font: .systemFont(ofSize: 14), ali: .left)
    let qrCodeTip = UILabel.initSomeThing(title: "保存到手机相册，\n打开全民形体，即可自动识别", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 11), ali: .left)
    
    let logoImg = UIImageView.initWithName(imgName: "share_logo")
    let botImg = UIImageView.initWithName(imgName: "share_my_bot")
    let qrCodeImg = UIImageView()
    
    let wechatBtn = UIButton.initTopImgBtn(imgName: "share_wechat_friend", titleStr: "微信好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let wechatLineBtn = UIButton.initTopImgBtn(imgName: "share_wechat_line", titleStr: "微信朋友圈", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let QQBtn = UIButton.initTopImgBtn(imgName: "share_qq", titleStr: "QQ好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let weiboBtn = UIButton.initTopImgBtn(imgName: "share_weibo", titleStr: "新浪微博", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let mdBtn = UIButton.initTopImgBtn(imgName: "share_md", titleStr: "保存到相册", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    
    
    var model : MyShareModel? = nil{
        didSet{
            if model != nil {
                self.headView.kf.setImage(with: URL.init(string: model?.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.bgImage.kf.setImage(with: URL.init(string: model?.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.nameLab.text = model?.nickName
                self.nameLab.sizeToFit()
                self.vipIcon.isHidden = model?.vip == false
                self.checkIcon.isHidden = model?.type == "0"
                self.sublab.text = model?.showWords
                self.minLab.text = model?.minutesTotal
                
                let kllStr = getNumString(num: model?.calorieTotal?.toDouble ?? 0)
                
                let atrStr = NSMutableAttributedString.init(string: "\(kllStr)千卡")
                atrStr.bs_font = UIFont.systemFont(ofSize: 13)
                atrStr.bs_set(font: .SemiboldFont(size: 20), range: .init(location: 0, length: kllStr.length))
                atrStr.bs_color = .init(hex: "#666666")
                atrStr.bs_set(color: .init(hex: "#333333"), range: .init(location: 0, length: kllStr.length))
                self.kllLab.attributedText = atrStr
                
                self.daysLab.text = model?.daysTotal
                self.qrCodeImg.image = (model?.qrCodeUrl ?? ShareRegisterURL).creatQRImage(size: 100)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.changgeImage()
                }
                
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                    self.bgImage.image = getImageFromView(view: self.whiteBG)
                //                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        
        bgImage.contentMode = .scaleAspectFill
        self.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(51)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalTo(backBtn)
        }
        
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 16
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.width.equalTo(296)
            make.height.equalTo(isBigScreen ? 484 : 450)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        headView.layer.cornerRadius = 32
        headView.layer.masksToBounds = true
        whiteBG.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(24)
            make.top.equalTo(38)
        }
        
        whiteBG.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(headView.snp.right).offset(11)
            make.top.equalTo(43)
        }
        nameLab.sizeToFit()
        
        whiteBG.addSubview(vipIcon)
        vipIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(nameLab.snp.right).offset(4)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(24)
        }
        
        whiteBG.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(4)
            make.width.equalTo(72)
        }
        
        whiteBG.addSubview(sublab)
        sublab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(checkIcon.snp.right).offset(8)
            make.top.equalTo(checkIcon)
            make.right.equalTo(-12)
        }
        
        let labWid = 90
        let labHei = 28
        whiteBG.addSubview(minLab)
        minLab.snp.makeConstraints { make in
            make.width.equalTo(labWid)
            make.height.equalTo(labHei)
            make.left.equalTo(24)
            make.top.equalTo(headView.snp.bottom).offset(39)
        }
        
        whiteBG.addSubview(minTip)
        minTip.snp.makeConstraints { make in
            make.width.equalTo(labWid)
            make.height.equalTo(18)
            make.left.equalTo(minLab)
            make.top.equalTo(minLab.snp.bottom).offset(4)
        }
        
        whiteBG.addSubview(kllLab)
        kllLab.snp.makeConstraints { make in
            make.width.equalTo(labWid)
            make.height.equalTo(labHei)
            make.left.equalTo(112)
            make.top.equalTo(minLab)
        }
        
        whiteBG.addSubview(kllTip)
        kllTip.snp.makeConstraints { make in
            make.width.equalTo(labWid)
            make.height.equalTo(18)
            make.left.equalTo(kllLab)
            make.top.equalTo(minLab.snp.bottom).offset(4)
        }
        
        whiteBG.addSubview(daysLab)
        daysLab.snp.makeConstraints { make in
            make.width.equalTo(labWid)
            make.height.equalTo(labHei)
            make.left.equalTo(216)
            make.top.equalTo(minLab)
        }
        
        whiteBG.addSubview(daysTip)
        daysTip.snp.makeConstraints { make in
            make.width.equalTo(labWid)
            make.height.equalTo(18)
            make.left.equalTo(daysLab)
            make.top.equalTo(minLab.snp.bottom).offset(4)
        }
        
        whiteBG.addSubview(logoImg)
        logoImg.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(24)
            make.top.equalTo(minTip.snp.bottom).offset(35)
            make.width.equalTo(87)
        }
        
        whiteBG.addSubview(sologenLab)
        sologenLab.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(24)
            make.top.equalTo(logoImg.snp.bottom).offset(4)
            make.width.equalTo(87)
        }
        
        whiteBG.addSubview(qrCodeImg)
        qrCodeImg.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.equalTo(24)
            make.bottom.equalTo(-24)
            make.width.equalTo(100)
        }
        
        
        
        whiteBG.addSubview(botImg)
        botImg.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(150)
        }
        
        qrCodeTip.numberOfLines = 0
        whiteBG.addSubview(qrCodeTip)
        qrCodeTip.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.left.equalTo(24)
            make.bottom.equalTo(qrCodeImg.snp.top).offset(-8)
            make.width.equalTo(190)
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
                make.bottom.equalTo(isBigScreen ? -51 : -21)
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
    
    ///图片高斯模糊
    func changgeImage() {
        if bgImage.image == nil {
            return
        }
        //获取原始图片
        let inputImage =  CIImage(image: bgImage.image!)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(5, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: .init(width: 200, height: 200))
        let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: rect)
        //显示生成的模糊图片
        bgImage.image = UIImage(cgImage: cgImage!)
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
            HQPushActionWith(name: "share_content", dic:  ["course_type":"我的二维码",
                                                              "content_id":"",
                                                                     "share_method":share_method])
        }
        let msg = JSHAREMessage()
        if type == 1 {
            msg.title = "[\(model?.nickName ?? "")]邀请您加入全民形体学习"
            msg.text = "立挺美好人生，和我一起变美吧~"
            msg.url = model?.qrCodeUrl ?? ShareRegisterURL
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
            msg.url = model?.qrCodeUrl ?? ShareRegisterURL
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
