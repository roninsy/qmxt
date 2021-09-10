//
//  SSPersionHeaderView.swift
//  shensuo
//
//  Created by  yang on 2021/4/9.
//

import UIKit
import HEPhotoPicker
import MBProgressHUD

class SSPersionHeaderView: UIView,HEPhotoPickerViewControllerDelegate {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    let sskey = SSCustomgGetSecurtKey()
    var userInfoModel:SSUserInfoModel? = nil{
        didSet{
            if userInfoModel != nil {
                DispatchQueue.main.async {
                    self.setupSubViews()
                    print("pviewId:\(self.userInfoModel?.userId ?? "")--\(self.userInfoModel?.nickName ?? "")")
                    self.pView.nameLabel.text = self.userInfoModel?.nickName
                    let maxWid = screenWid - 250
                    var nameWid = self.pView.nameLabel.sizeThatFits(.init(width: maxWid, height: 20)).width
                    if nameWid > maxWid{
                        nameWid = maxWid
                    }
                    self.pView.nameLabel.snp.updateConstraints { make in
                        make.width.equalTo(nameWid)
                    }
                    self.pView.headImageView.kf.setImage(with: URL.init(string: (self.userInfoModel?.headImage) ?? ""), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
                    //                personView.setNamelabelWidth(nameText: (userInfoModel?.nickName)!)
                    self.pView.hjBtn.setTitle(String.init(format: "徽章%d", self.userInfoModel?.badgeNumber ?? ""), for: .normal)
                    self.pView.hjBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                        let vc = SSMyBadgeViewController()
                        HQPush(vc: vc, style: .lightContent)
                    }
                    self.pView.addressLabel.text = self.userInfoModel?.province?.appending(self.userInfoModel?.city ?? "")
                    
                    self.pNotesLabel.text = self.userInfoModel?.introduce
                    
                    self.pBottonView.fenContent.numLabel.text = String(self.userInfoModel?.fansNumber ?? 0)
                    self.pBottonView.foceContent.numLabel.text = String(self.userInfoModel?.focusNumber ?? 0)
                    self.pBottonView.tipContent.numLabel.text = String(self.userInfoModel?.likeTimes ?? 0)
                    self.pView.sexBtn.image = UIImage.init(named: self.userInfoModel?.sex == 1 ? "nanxing" : "nvxing")
                    self.pView.authenticationUserL.text = self.userInfoModel?.showWords
                    self.pView.hgimage.isHidden = self.userInfoModel?.vip == true ? false : true
                    self.pView.authenticationUserImg.image = UIImage.init(named: self.userInfoModel?.userType == 0 ? "" : (self.userInfoModel?.userType == 1 ? "icon_renzheng" : "person_renzheng"))
                    self.pView.snp.updateConstraints { make in
                        
                        make.height.equalTo(self.userInfoModel?.userType == 0 ? 80 : 80 + self.userInfoModel!.authenticationH )
                    }
                    if (self.userInfoModel?.oneSelf == true) {
                        
                        self.pView.btnTitleAndColor(title: "修改资料", bgColor: UIColor.init(r: 0, g: 0, b: 0, a: 0.14),needBrod: false)
                        
                    }
                    else{
                        
                        self.pView.btnTitleAndColor(title:self.userInfoModel?.focusType ?? false ? "未关注" : "已关注", bgColor: UIColor.init(r: 0, g: 0, b: 0, a: 0.14),needBrod: self.userInfoModel?.focusType ?? false ? false : true)
                        self.pView.followOrDataBtn.snp.updateConstraints { make in
                            
                            make.width.equalTo(60)
                        }
                    }
                    
                    self.navView.searchBtn.setImage(UIImage.init(named: self.userInfoModel?.oneSelf ?? false ? "icon-erweima" : "my_more" ), for: .normal)
                    
                    self.pView.authenticationUserView.snp.updateConstraints { make in
                        
                        make.height.equalTo(self.userInfoModel?.userType == 0 ? 0 : 24)
                    }
                    if self.userInfoModel?.userType != 0 {
                        self.pView.authenticationUserImg.image = UIImage.init(named: self.userInfoModel?.userType == 2 ? "person_renzheng" : "icon_renzheng")
                    }
                    
                    
                    self.pNotesLabel.snp.updateConstraints { make in
                        
                        make.height.equalTo(self.userInfoModel!.introduceH)
                    }
                    
                    //                fourView.meiContent.numLabel.text =
                }
            }
            
        }
    }
    
    var bgImg: String? = nil {
        didSet{
            backImageV.kf.setImage(with: URL.init(string: bgImg ?? ""), placeholder: UIImage.init(named: "my_bg"), options: nil, completionHandler: nil)
        }
    }
    var backImageV : UIImageView = {
        let bg = UIImageView.init()
        bg.image = UIImage.init(named: "my_bg")
        bg.isUserInteractionEnabled = true
        
        let v = UIView.init(frame: bg.frame)
        v.backgroundColor = .gray
        v.alpha = 0.2
        bg.addSubview(v)
        return bg
    }()
    
    var navView : SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
    var pView : persionView = {
        let p = persionView.init()
        return p
    }()
    
    var pNotesLabel: UILabel = {
        let pNotes = UILabel.init()
        pNotes.textAlignment = .left
        pNotes.textColor = .white
        pNotes.font = .systemFont(ofSize: 12)
        pNotes.numberOfLines = 0
        return pNotes
    }()
    
    var moreBtn: UIButton = {
        
        let btn = UIButton.initBgImage(imgname: "back_white")
        return btn
    }()
    
    var pBottonView : SSNewfourTipsView = {
        let pBotton = SSNewfourTipsView.init()
        pBotton.fenContent.lineImage.isHidden = true
        return pBotton
    }()
    
    ///正在选择背景图片
    var inSelMode = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        loadPersonInfo()
        
        
        pBottonView.clickFocusBtnHander = { button in
            
            UserInfoNetworkProvider.request(.focusOption(focusUserId: (self.userInfoModel?.userId)!)) { (result) in
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
    }
    
    func selectImageOrVideo() {
        if self.inSelMode {
            return
        }
        sskey.getSecurtKey()
        self.inSelMode = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.inSelMode = false
        }
        let defaultSelections = [HEPhotoAsset]()
        
        let option = HEPickerOptions.init()
        // 只能选择一个视频
        option.singleVideo = true
        
        // 将上次选择的数据传入，表示支持多次累加选择，
        //                option.defaultSelections = self.selectedModel
        // 选择图片的最大个数
        
        option.maxCountOfImage = 1
        // 图片和视频只能选择一种
        option.mediaType = .image
        option.defaultSelections = defaultSelections
        let imagePickerController = HEPhotoPickerViewController.init(delegate: self,options: option)
        imagePickerController.delegate = self
        let nav = UINavigationController.init(rootViewController: imagePickerController)
        nav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            HQGetTopVC()?.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        if selectedImages.count == 0 {
            return
        }
        
        self.backImageV.image = selectedImages[0]
        
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
        
        let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        myQueue.async { [weak self] in
            imgUpload.uploadImg((selectedImages[0]) as UIImage) { (image) in
                self?.uploadImageInfo(name: image)
            } faildBlock: {
                DispatchQueue.main.async {
                    HQGetTopVC()?.view.makeToast("上传失败，请重试")
                }
            }
        }
    }
    
    func loadPersonInfo() -> Void {
        UserInfoNetworkProvider.request(.userInfo(userId: (UserInfo.getSharedInstance().userId ?? ""))) { [self] result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            self.userInfoModel = dic?.kj.model(SSUserInfoModel.self)
                            
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() -> Void {
        
        backImageV.layer.masksToBounds = true
        backImageV.contentMode = .scaleAspectFill
        addSubview(backImageV)
        backImageV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if UserInfo.getSharedInstance().userId == userInfoModel?.userId {
            let btn = UIButton()
            btn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                self.selectImageOrVideo()
            }
            self.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.edges.equalTo(backImageV)
            }
        }
        
        self.addSubview(navView)
        navView.titleWithOpentionBtn(title: "")
        navView.backgroundColor = .clear
        //        navView.backBtn.setImage(UIImage.init(named: "back_white"), for: .normal)
        navView.addBtn.setImage(UIImage.init(named: "icon-fenxiang"), for: .normal)
        
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
        
        navView.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { make in
            
            make.height.width.equalTo(48)
            make.leading.equalTo(4)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(pView)
        pView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(126)
        }
        
        self.addSubview(pNotesLabel)
        pNotesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pView.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
        self.addSubview(pBottonView)
        pBottonView.snp.makeConstraints { (make) in
            make.top.equalTo(pNotesLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    
    
    func uploadImageInfo(name:String){
        UserNetworkProvider.request(.setBgImage(bgImage: name)) { result in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: HQGetTopVC()!.view, animated: false)
            }
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                HQGetTopVC()?.view.makeToast("设置成功")
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
}

class persionView: UIView {
    
    var headImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.image = UIImage.init(named: "user_normal_icon")
        
        return imageView
    }()
    
    var followOrDataBtn: UIButton = {
        
        let btn = UIButton.init()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    var sexBtn : UIImageView = {
        let sex = UIImageView.initWithName(imgName: "nanxing")
        return sex
    }()
    
    var nameLabel : UILabel = {
        let name = UILabel.init()
        name.textAlignment = .left
        name.numberOfLines = 1
        name.textColor = .white
        name.font = UIFont.SemiboldFont(size: 18)
        return name
    }()
    
    var hgimage : UIImageView = {
        let hg = UIImageView.init()
        hg.image = UIImage.init(named: "my_newisvip")
        return hg
    }()
    
    var hjBtn : UIButton = {
        let hj = UIButton.init()
        hj.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.14)
        hj.layer.masksToBounds = true
        hj.layer.cornerRadius = 12
        hj.setImage(UIImage.init(named: "my_newhj"), for: .normal)
        hj.setTitle("徽章0", for: .normal)
        hj.contentEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        return hj
    }()
    
    
    var addressLabel : UILabel = {
        let address = UILabel.init()
        address.backgroundColor = UIColor.init(red: 0.84, green: 0.84, blue: 0.84, alpha: 0.14)
        //        address.backgroundColor = UIColor.init(hex: "#D5D5D5")
        address.layer.masksToBounds = true
        address.layer.cornerRadius = 8
        address.textAlignment = .left
        address.textColor = .white
        return address
    }()
    
    //认证用户
    var authenticationUserView: UIView = {
        
        let v = UIView.init()
        v.backgroundColor = UIColor.clear
        return v
        
        
    }()
    //认证用户
    var authenticationUserImg: UIImageView = {
        
        let img = UIImageView.initWithName(imgName: "person_renzheng")
        
        return img
    }()
    
    //认证用户
    var authenticationUserL: UILabel = {
        
        let label = UILabel.initSomeThing(title: "", fontSize: 13, titleColor: .white)
        
        return label
    }()
    var addressIcon: UIImageView = {
        
        let icon = UIImageView.initWithName(imgName: "address_icon_write")
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        
    }
    
    func btnTitleAndColor(title: String,bgColor: UIColor,needBrod: Bool)  {
        
        followOrDataBtn.setTitle(title, for: .normal)
        followOrDataBtn.setTitleColor(.white, for: .normal)
        followOrDataBtn.backgroundColor = bgColor
        followOrDataBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        if needBrod {
            
            followOrDataBtn.layer.borderWidth = 0.5
            followOrDataBtn.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func setupSubViews() -> Void {
        addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.height.width.equalTo(60)
        }
        
        addSubview(followOrDataBtn)
        followOrDataBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.top.equalTo(headImageView)
            make.height.equalTo(28)
            make.width.equalTo(90)
        }
        
        addSubview(sexBtn)
        sexBtn.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView)
            make.left.equalTo(headImageView.snp.right).offset(18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sexBtn.snp.right).offset(1)
            make.centerY.equalTo(sexBtn)
            make.width.equalTo(100)
        }
        
        addSubview(hgimage)
        hgimage.snp.makeConstraints { (make) in
            make.centerY.equalTo(sexBtn)
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.width.height.equalTo(18)
        }
        
        addSubview(hjBtn)
        hjBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        hjBtn.snp.makeConstraints { (make) in
            make.left.equalTo(sexBtn)
            make.top.equalTo(sexBtn.snp.bottom).offset(12)
            //            make.width.equalTo(64)
            make.height.equalTo(24)
        }
        
        addSubview(addressIcon)
        addressIcon.snp.makeConstraints { make in
            
            make.centerY.equalTo(hjBtn)
            make.leading.equalTo(hjBtn.snp.trailing).offset(11)
            make.height.width.equalTo(16)
        }
        
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hjBtn)
            make.left.equalTo(addressIcon.snp.right).offset(12)
            make.height.equalTo(21)
        }
        
        addSubview(authenticationUserView)
        authenticationUserView.snp.makeConstraints { make in
            
            make.leading.equalTo(10)
            make.width.equalTo(72)
            make.top.equalTo(headImageView.snp.bottom).offset(26)
            make.height.equalTo(24)
        }
        
        authenticationUserView.addSubview(authenticationUserImg)
        authenticationUserImg.snp.makeConstraints { make in
            
            make.leading.equalToSuperview()
            make.height.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(72)
        }
        
        authenticationUserView.addSubview(authenticationUserL)
        authenticationUserL.snp.makeConstraints { make in
            
            make.leading.equalTo(authenticationUserImg.snp.trailing).offset(5)
            make.height.centerY.trailing.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

