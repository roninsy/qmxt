//
//  ShareForVipView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/16.
//

import UIKit

class ShareForVipView: UIView {
    
    let mainBotImg = UIImageView.initWithName(imgName: "share_project_bot")
    
    let mainImg = UIImageView.initWithName(imgName: "share_vip_main")
    
    let backBtn = UIButton.initWithBackBtn(isBlack: false)
    
    let titleLab = UILabel.initSomeThing(title: "分享", titleColor: .white, font: .SemiboldFont(size: 18), ali: .center)
    
    let whiteBG = UIView()
    
    let headView = UIImageView()
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#000000"), font: .MediumFont(size: 17), ali: .left)
    
    let sublab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 15), ali: .left)
    
    let sologenLab = UILabel.initSomeThing(title: "立挺美好人生", titleColor: .init(hex: "#999990"), font: .systemFont(ofSize: 14), ali: .left)
    
    let logoImg = UIImageView.initWithName(imgName: "share_logo")
    let qrCodeImg = UIImageView()
    
    let wechatBtn = UIButton.initTopImgBtn(imgName: "share_wechat_friend", titleStr: "微信好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let wechatLineBtn = UIButton.initTopImgBtn(imgName: "share_wechat_line", titleStr: "微信朋友圈", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let QQBtn = UIButton.initTopImgBtn(imgName: "share_qq", titleStr: "QQ好友", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let weiboBtn = UIButton.initTopImgBtn(imgName: "share_weibo", titleStr: "新浪微博", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let mdBtn = UIButton.initTopImgBtn(imgName: "share_md", titleStr: "保存到相册", titleColor: .white, font: .systemFont(ofSize: 12), imgWid: 54)
    let appLogoImg = UIImageView.initWithName(imgName: "my_icon")
    
    var model : MyShareModel? = nil{
        didSet{
            if model != nil {
                self.headView.kf.setImage(with: URL.init(string: model!.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.nameLab.text = model?.nickName
                let wid = self.nameLab.sizeThatFits(CGSize.init(width: 120, height: 25)).width
                self.nameLab.snp.updateConstraints { make in
                    make.width.equalTo(wid)
                }
                self.qrCodeImg.image = (model!.qrCodeUrl ?? ShareRegisterURL).creatQRImage(size: 100)
            }
        }
    }
    
    let imgHei = screenWid / 414 * 371
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#353535")
        
//        self.addSubview(backBtn)
//        backBtn.snp.makeConstraints { make in
//            make.width.height.equalTo(24)
//            make.left.equalTo(16)
//            make.top.equalTo(51)
//        }
//        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
//            HQGetTopVC()?.navigationController?.popViewController(animated: true)
//        }
//        
//        self.addSubview(titleLab)
//        titleLab.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(30)
//            make.centerY.equalTo(backBtn)
//        }
        
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 16
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(imgHei + 173)
            make.top.equalTo(100)
        }
        
        mainImg.contentMode = .scaleToFill
        whiteBG.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.top.equalTo(-1)
            make.left.equalTo(0)
            make.right.equalTo(1)
            make.height.equalTo(imgHei)
        }
        
        whiteBG.addSubview(mainBotImg)
        mainBotImg.snp.makeConstraints { make in
            make.width.equalTo(334)
            make.height.equalTo(52)
            make.left.equalTo(mainImg)
            make.bottom.equalTo(mainImg.snp.bottom).offset(1)
        }
        
        headView.layer.cornerRadius = 32
        headView.layer.masksToBounds = true
        whiteBG.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(37)
            make.bottom.equalTo(-133)
        }
        
        whiteBG.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(22)
            make.width.equalTo(80)
            make.bottom.equalTo(-94)
        }
        
        whiteBG.addSubview(sublab)
        sublab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(nameLab.snp.right)
            make.centerY.equalTo(nameLab)
            make.right.equalTo(-15)
        }
        self.sublab.text = " | 已开通年卡会员"
        
        whiteBG.addSubview(appLogoImg)
        appLogoImg.snp.makeConstraints { make in
            make.height.equalTo(57)
            make.left.equalTo(21)
            make.bottom.equalTo(-19)
            make.width.equalTo(57)
        }
        
        whiteBG.addSubview(logoImg)
        logoImg.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.left.equalTo(86)
            make.bottom.equalTo(-49)
            make.width.equalTo(82)
        }
        
        whiteBG.addSubview(sologenLab)
        sologenLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.left.equalTo(logoImg)
            make.top.equalTo(logoImg.snp.bottom).offset(8)
            make.width.equalTo(87)
        }
        
        whiteBG.addSubview(qrCodeImg)
        qrCodeImg.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.right.equalTo(-16)
            make.bottom.equalTo(-8)
            make.width.equalTo(80)
        }
        
        
//        let shareBtnArr = [wechatBtn,wechatLineBtn,QQBtn,mdBtn]
//        let btnWid = screenWid / 4
//        for i in 0...3{
//            let btn = shareBtnArr[i]
//            btn.tag = i
//            self.addSubview(btn)
//            btn.snp.makeConstraints { make in
//                make.width.equalTo(btnWid)
//                make.height.equalTo(81)
//                make.left.equalTo(CGFloat(i) * btnWid)
//                make.bottom.equalTo(isBigScreen ? -51 : -24)
//            }
//            btn.reactive.controlEvents(.touchUpInside).observeValues { btn2 in
//                self.shareWithType(type: btn2.tag + 1)
//            }
//        }
        
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
