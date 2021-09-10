//
//  ShareForMedalListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/16.
//

import UIKit

class ShareForMedalListView: UIView {
    
    let mainBotImg = UIImageView.initWithName(imgName: "share_project_bot")
    
    let mainImg = UIImageView.initWithName(imgName: "share_medal_list_main")
    
    var listView : UICollectionView!
    
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
    
    var medalGetNum = "0"{
        didSet{
            self.sublab.text = " | 在全民形体获得了\(medalGetNum)枚徽章"
        }
    }
    
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
    
    var models : [badgeCateGoryModel] = NSArray() as! [badgeCateGoryModel]
    
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
        
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 16
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(isBigScreen ? 592 : 432)
            make.top.equalTo(100)
        }
        
        let myTip = UILabel.initSomeThing(title: "我的徽章", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 15), ali: .center)
        
        whiteBG.addSubview(myTip)
        myTip.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(21)
            make.top.equalTo(21)
        }
        
        let itemWid = (screenWid - 78) / 3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: itemWid, height: 80)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        listView = UICollectionView.init(frame: .init(x: 0, y: 0, width: screenWid - 78, height: 250), collectionViewLayout: layout)
        listView.backgroundColor = .clear
        listView.register(ShareForMedalListItemView.self, forCellWithReuseIdentifier: "ShareForMedalListItemView")
        whiteBG.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(55)
            make.bottom.equalTo(-213)
        }
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        listView.delegate = self
        listView.dataSource = self
        listView.isPagingEnabled = true
        
        mainImg.contentMode = .scaleToFill
        whiteBG.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.top.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-178)
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
            make.left.equalTo(53)
            make.bottom.equalTo(-133)
        }
        
        whiteBG.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(16)
            make.width.equalTo(80)
            make.bottom.equalTo(-97)
        }
        
        
        whiteBG.addSubview(sublab)
        sublab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(nameLab.snp.right)
            make.centerY.equalTo(nameLab)
            make.right.equalTo(-15)
        }
        
        whiteBG.addSubview(appLogoImg)
        appLogoImg.snp.makeConstraints { make in
            make.height.equalTo(57)
            make.left.equalTo(16)
            make.bottom.equalTo(-16)
            make.width.equalTo(57)
        }
        
        whiteBG.addSubview(logoImg)
        logoImg.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.left.equalTo(86)
            make.bottom.equalTo(-47)
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
                make.bottom.equalTo(isBigScreen ? -51 : -24)
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

extension ShareForMedalListView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ShareForMedalListItemView = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareForMedalListItemView", for: indexPath) as! ShareForMedalListItemView
        cell.model = self.models[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}


class ShareForMedalListItemView: UICollectionViewCell {
    
    var model : badgeCateGoryModel? = nil{
        didSet{
            if model != nil{
                mainImg.kf.setImage(with: URL.init(string: model!.obtainImage),placeholder: UIImage.init(named: "normal_img_zfx"))
                self.nameLab.text = model?.categoryName
            }
        }
    }
    let mainImg = UIImageView.initWithName(imgName: "gift_flower")
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 10), ali: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        mainImg.contentMode = .scaleAspectFit
        self.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.width.equalTo(56)
            make.height.equalTo(51)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainImg.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
