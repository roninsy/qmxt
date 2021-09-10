//
//  SSMyPopFocusView.swift
//  shensuo
//
//  Created by  yang on 2021/4/5.
//

import UIKit

typealias closeBtnBlock = ((String)->())


//关注弹出框
class SSMyPopFocusView: UIView {
    
    var closeClick : ((String)->())?
    
    var reloadBlock : intBlock? = nil
    
    var ctView : contentView = {
        let cView = contentView.init()
        cView.backgroundColor = UIColor.white
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 10
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    var tipImageV : UIImageView = {
        let tipImage = UIImageView.init()
        tipImage.image = UIImage.init(named: "mlnst")
        return tipImage
    }()
    
    var closeBtn : UIButton = {
        let close = UIButton.init()
        close.setImage(UIImage.init(named: "closebtn"), for: .normal)
        return close
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
    }
    
    func buildUI() -> Void {
        self.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenHei)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isUserInteractionEnabled = true
        
        self.addSubview(ctView)
        ctView.isUserInteractionEnabled = true
        ctView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenWid-40)
            make.height.equalTo((screenWid-40)/374*567)
        }
        
        addSubview(tipImageV)
        tipImageV.snp.makeConstraints { (make) in
            make.top.equalTo(ctView.snp.top).offset(-40)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(78)
        }
        
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(ctView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(45)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickCloseBtn() -> Void {
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


class contentView: UIView {
    
    var popModels : [SSFocusPopModel]? = nil {
        didSet {
            if popModels != nil {
                self.contentTableView.reloadData()
            }
        }
    }
    
    var noteLabel : UILabel = {
        let nLabel = UILabel.init()
        nLabel.text = "特别为您推荐可能感兴趣的女神"
        nLabel.textColor = UIColor.init(hex: "#999999")
        nLabel.textAlignment = .center
        nLabel.font = UIFont.systemFont(ofSize: 13)
        return nLabel
    }()
    
    var contentTableView : UITableView = {
        let cTable = UITableView.init()
        return cTable
    }()
    
    var focusBtn:UIButton = {
        let allBtn = UIButton.init()
        allBtn.backgroundColor = UIColor.init(hex: "#FD8024")
        allBtn.layer.masksToBounds = true
        allBtn.layer.cornerRadius = 15
        allBtn.titleLabel?.textAlignment = .center
        allBtn.setTitle("全部关注", for: .normal)
        return allBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        laySubViews()
        loadData()
    }
    
    func loadData() -> Void {
        CommunityNetworkProvider.request(.getSuggestedFollows(pageNumber: 1, pageSize: 10, userId: UserInfo.getSharedInstance().userId ?? "", userType: "")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                if dic == nil {
                                    self.superview?.isHidden = true
                                    self.superview?.removeFromSuperview()
                                    
                                    return
                                }
                                let total = dic?["totalElements"] as! String
                                if (total.toInt ?? 0) > 0 {
                                    let arr = dic?["content"] as! NSArray
                                    self.popModels = arr.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
                                }else{
                                    self.superview?.isHidden = true
                                    self.superview?.removeFromSuperview()
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
    func loadFocusBatch(idArrays: [String])  {
        
//        let jsonData = try! JSONSerialization.data(withJSONObject: idArrays, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let str = String(data: jsonData, encoding: String.Encoding.utf8)!
        UserInfoNetworkProvider.request(.getFocusBatch(integers: idArrays)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                            
                                self.superview?.isHidden = true
                                self.superview?.removeFromSuperview()
                            }else{
                                self.superview?.isHidden = true
                                self.superview?.removeFromSuperview()
                                HQGetTopVC()?.view.makeToast(model?.message)
                            }
                        }
                    } catch {
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    
    func laySubViews() -> Void {
        
        addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(focusCell.self, forCellReuseIdentifier: "focusCell")
        contentTableView.tableFooterView = UIView.init()
        addSubview(contentTableView)
        contentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(noteLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        
        addSubview(focusBtn)
        focusBtn.addTarget(self, action: #selector(clickFocusAll), for: .touchUpInside)
        focusBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    @objc func clickFocusAll()
    {
        
        if popModels != nil && popModels?.count ?? 0 > 0 {
            
            var idArrays = [String]()
            
            for index in 0..<(popModels!.count) {
                let model = popModels![index]
                
                idArrays.append(model.id ?? "")
            }
            
            self.loadFocusBatch(idArrays: idArrays)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class unRegisterCell: UITableViewCell {
    
    var headImageView : UIImageView = {
        let headerV = UIImageView.init()
        headerV.image = UIImage.init(named: "kecheng_xingti")
        headerV.layer.masksToBounds = true
        headerV.layer.cornerRadius = 32
        return headerV
    }()
    
    var nameLabel : UILabel = {
        let name = UILabel.init()
        name.textColor = .init(hex: "#333333")
        name.font = .systemFont(ofSize: 170)
        return name
    }()
    
    var invitationBtn : UIButton = {
        let btn = UIButton.init()
        return btn
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupSubViews() -> Void {
        contentView.addSubview(headImageView)
        headImageView.layer.cornerRadius = 32
        headImageView.layer.masksToBounds = true
        headImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.height.width.equalTo(64)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(headImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BlackUserListCell: UITableViewCell {

    let headView = UIImageView()
    let Ricon = UIImageView.initWithName(imgName: "r_icon")
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 17), ali: .left)
    
    let vipIcon = UIImageView.initWithName(imgName: "my_newisvip")
    
    let checkIcon = UIImageView()
    let subLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 13), ali: .left)
    
    let focusBtn = UIButton.initTitle(title: "解除拉黑", font: .MediumFont(size: 13), titleColor: .init(hex: "#FD8024"), bgColor: .white)
    
    let detalisLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .left)
    
    let botLine = UIView()
    
    var reloadBlock : voidBlock? = nil
    
    var model : SSFocusPopModel? = nil{
        didSet{
            if model != nil {
                self.headView.kf.setImage(with: URL.init(string: model!.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.Ricon.isHidden = (model?.userType ?? 0) == 0
                self.nameLab.text = model?.nickName
                let maxWid = screenWid - 230
                var wid = nameLab.sizeThatFits(.init(width: (maxWid), height: 24)).width
                if wid > maxWid{
                    wid = maxWid
                }
                nameLab.snp.updateConstraints { make in
                    make.width.equalTo(wid)
                }
                let checkType = model?.type ?? 0
                
                self.vipIcon.isHidden = !(model?.vip ?? false)
                self.checkIcon.image = UIImage.init(named: checkType == 2 ? "check_person_search" : "check_com_search")
//                self.checkIcon.isHidden = checkType == 0
                self.subLab.isHidden = self.checkIcon.isHidden
                if checkType == 2 {
                    self.subLab.text = model?.showWords
                }else{
                    self.subLab.text = model?.enterpriseSgs
                }
                
                self.detalisLab.isHidden = checkType != 0
                self.detalisLab.text = model?.introduce
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "reuseIdentifier")
        self.selectionStyle = .none
        headView.layer.cornerRadius = 32
        headView.layer.masksToBounds = true
        self.contentView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(Ricon)
        Ricon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.right.bottom.equalTo(headView)
        }
        
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(headView.snp.right).offset(12)
            make.top.equalTo(22)
            make.width.equalTo(30)
        }
        
        self.contentView.addSubview(vipIcon)
        vipIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(nameLab.snp.right).offset(4)
            make.centerY.equalTo(nameLab)
        }
        
        self.contentView.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(72)
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(4)
        }
        
        self.contentView.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(checkIcon.snp.right).offset(4)
            make.centerY.equalTo(checkIcon)
            make.right.equalTo(-90)
        }
        
        self.contentView.addSubview(detalisLab)
        detalisLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(nameLab)
            make.centerY.equalTo(checkIcon)
            make.right.equalTo(-90)
        }
        
        focusBtn.layer.cornerRadius = 16
        focusBtn.layer.masksToBounds = true
        focusBtn.layer.borderWidth = 1
        focusBtn.layer.borderColor = UIColor.init(hex: "#FD8024").cgColor
        self.addSubview(focusBtn)
        focusBtn.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(32)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        focusBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.loadAddUserBlack()
        }
        
        botLine.backgroundColor = .init(hex: "#EEEFF1")
        self.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///拉黑用户
    func loadAddUserBlack()  {
                    
        UserInfoNetworkProvider.request(.getAddUserBlack(blackUserId: model?.id ?? "")) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultStringModel.self)
                            if model?.code == 0 {
                                DispatchQueue.main.async {[weak self] in
                                    let tipString = model?.data ?? ""
                                    HQGetTopVC()?.view.makeToast(tipString)
                                    self?.reloadBlock?()
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
    
}

class focusCell: UITableViewCell {
    
    var reloadBlock : intBlock? = nil
    
    var cellType : listType = .FocusList
    var nameLabelWidth:CGFloat = 0
    var compLabelleading:CGFloat = 84
    var isVerified = false
    var userId = ""
    
    var focusModel:SSFocusPopModel? = nil {
        didSet{
            if focusModel != nil {
                self.userId = focusModel?.userId ?? ""
                headImageV.kf.setImage(with: URL.init(string: focusModel?.headImage ?? ""), placeholder: UIImage.init(named: "user_normal_icon"), options: nil, completionHandler: nil)
                nameLabel.text = focusModel?.nickName
                fansLabel.text = "粉丝:" + (focusModel?.fansNumber ?? "")
                if focusModel?.verify == "0" {
                    isVerified = false
                    typeImageV.image = UIImage()
//                    typeImageV.removeFromSuperview()
//                    compLabelleading = 10+64+10
                    typeImageV.isHidden = false
                }else{
                    if focusModel?.userType == 1 {
                        typeImageV.image = UIImage.init(named: "check_person_search")
//                        compLabelleading = 10+64+10+63+10
                        isVerified = true
                        typeImageV.isHidden = false
                    } else {
                        typeImageV.image = UIImage.init(named: "check_com_search")
//                        compLabelleading = 10+64+10+63+10
                        isVerified = true
                        typeImageV.isHidden = false
                    }
                }
                addressLabel.text = focusModel?.introduce
                type = 3
                if focusModel?.focusType == true{
                    focusBtn.setTitle("已关注", for: .normal)
                    focusBtn.setTitleColor(UIColor.init(hex: "#CBCCCD"), for: .normal)
                    focusBtn.backgroundColor = .white
                    focusBtn.layer.borderWidth = 1
                    focusBtn.layer.borderColor = UIColor.init(hex: "#CBCCCD").cgColor
                }else{
                    focusBtn.setTitle("关注", for: .normal)
                    focusBtn.backgroundColor = UIColor.init(hex: "#FD8024")
                    focusBtn.layer.borderColor = UIColor.clear.cgColor
                    focusBtn.setTitleColor(.white, for: .normal)
                }
            }
        }
    }
   
    
    var model : SSFocusPopModel? = nil {
        didSet{
            if model != nil {
                self.userId = model?.userId ?? ""
                headImageV.kf.setImage(with: URL.init(string: (model?.headImage) ?? ""), placeholder: UIImage.init(named: "user_normal_icon"), options: nil, completionHandler: nil)
                nameLabel.text = model?.nickName
                let statusLabelSize = model?.nickName!.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
                hyImageView.isHidden = model?.vip == true ? false : true

                nameLabelWidth = CGFloat(statusLabelSize!.width + 4)
                if model!.type == 1 {
                    typeImageV.image = UIImage.init(named: "person_renzheng")
                    compLabelleading = 10+64+10+63+10
                } else if model!.type == 2 {
                    typeImageV.image = UIImage.init(named: "icon_renzheng")
                    compLabelleading = 10+64+10+63+10
                } else {
                    typeImageV.removeFromSuperview()
                    compLabelleading = 10+64+10
                }
                
                compLabel.text = model?.introduce
                nameLabel.sizeToFit()
                
                focusBtn.setTitle("解除拉黑", for: .normal)
                focusBtn.setTitleColor(UIColor.init(hex: "#FD8024"), for: .normal)
                focusBtn.backgroundColor = .white
                focusBtn.layer.borderWidth = 1
                focusBtn.layer.borderColor = UIColor.init(hex: "#FD8024").cgColor
                
            }
        }
    }
    
    var friendListModel: SSRegisterModel? = nil{
        
        didSet {
            
            if friendListModel != nil {
                
                headImageV.kf.setImage(with: URL.init(string: friendListModel?.userHeadImage ?? ""), placeholder: UIImage.init(named: "user_normal_icon"), options: nil, completionHandler: nil)
                nameLabel.text = friendListModel?.userName
                fansLabel.text = "粉丝:" + (friendListModel?.fansNumber)!
                if friendListModel?.verified == true {
                    
                    typeImageV.isHidden = false
                    isVerified = true
                    if friendListModel?.verifiedType == 1 {
                        typeImageV.image = UIImage.init(named: "person_renzheng")
                    } else{
                        typeImageV.image = UIImage.init(named: "icon_renzheng")
                    }
                    //                    subViewLayout(type: 3)
                    
                }else{
                    //                    subViewLayout(type: 4)
                    typeImageV.image = UIImage.init(named: "")
                    typeImageV.isHidden = true
                    isVerified = false
                }
                addressLabel.text = friendListModel?.introduce
                var distance = Float(friendListModel?.distance ?? "0.0")
                if distance ?? 0 > 1 {
                    
                    compLabel.text = String(format: "%.2f", distance ?? 0.0) + "km"
                }else{
                    
                    distance = (distance ?? 0.0) * 1000
                    compLabel.text = String(format: "%.2f", distance ?? 0.0) + "m"
                    
                }
                hyImageView.isHidden = friendListModel?.vip == true ? false : true
//                subViewLayout(type: 3)
                type = 3
                self.userId = friendListModel?.userId ?? ""
                if friendListModel!.focusType == false{
                    focusBtn.setTitle("已关注", for: .normal)
                    focusBtn.setTitleColor(UIColor.init(hex: "#CBCCCD"), for: .normal)
                    focusBtn.backgroundColor = .white
                    focusBtn.layer.borderWidth = 1
                    focusBtn.layer.borderColor = UIColor.init(hex: "#CBCCCD").cgColor
                }else{
                    focusBtn.setTitle("关注", for: .normal)
                    focusBtn.backgroundColor = UIColor.init(hex: "#FD8024")
                    focusBtn.setTitleColor(.white, for: .normal)
                }
            }
        }
    }
    
    var registerModel : SSRegisterModel? = nil{
        didSet{
            if registerModel != nil {
                headImageV.kf.setImage(with: URL.init(string: (registerModel?.headImageUrl) ?? ""), placeholder: UIImage.init(named: "placeHolder"), options: nil, completionHandler: nil)
                nameLabel.text = registerModel?.registeredName
                let statusLabelSize = registerModel?.registeredName!.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
                hyImageView.isHidden = registerModel?.vip == true ? false : true

                nameLabelWidth = CGFloat(statusLabelSize!.width + 4)
                
//                if registerModel!.focusUserType == 1 {
//                    typeImageV.image = UIImage.init(named: "qiyerz")
//                    compLabelleading = 10+64+10+63+10
//                } else if registerModel!.focusUserType == 2 {
//                    typeImageV.image = UIImage.init(named: "check_person")
//                    compLabelleading = 10+64+10+63+10
//                } else {
//                    typeImageV.removeFromSuperview()
//                    compLabelleading = 10+64+10
//                }
                
                addressLabel.text = "通讯录好友:" + (registerModel?.addressBookName ?? "")
                fansLabel.text = "粉丝:" + (registerModel?.fansNumber ?? "")
//                setSubViews()
                
                nameLabel.sizeToFit()
//                subViewLayout(type: 2)
                self.userId = registerModel?.userId ?? ""
                type = 2
                if registerModel!.focusType == false {
                    focusBtn.setTitle("已关注", for: .normal)
                    focusBtn.setTitleColor(UIColor.init(hex: "#CBCCCD"), for: .normal)
                    focusBtn.backgroundColor = .white
                    focusBtn.layer.borderWidth = 1
                    focusBtn.layer.borderColor = UIColor.init(hex: "#CBCCCD").cgColor
                }else{
                    
                    focusBtn.setTitle("关注", for: .normal)
                    focusBtn.backgroundColor = UIColor.init(hex: "#FD8024")
                    focusBtn.setTitleColor(.white, for: .normal)

                }
            }
        }
    }
    
    var unregisterModel : SSUnRegisterModel? = nil{
        didSet{
            if unregisterModel != nil {
                nameLabel.text = unregisterModel?.name
//                setSubViews()
                focusBtn.backgroundColor = .hex(hexString: "#56A1FA")
                focusBtn.setTitle("邀请", for: .normal)
//                layoutIfNeeded()
//                subViewLayout(type: 1)
                type = 1
             
            }
        }
    }
    
    
    
    //头像
    var headImageV: UIImageView = {
        let headerV = UIImageView.init()
        headerV.image = UIImage.init(named: "kecheng_xingti")
        headerV.layer.masksToBounds = true
        headerV.layer.cornerRadius = 32
        return headerV
    }()
    
    //认证标
    var rzImageV:UIImageView = {
        let rzV = UIImageView.init()
        rzV.image = UIImage.init(named: "renzheng")
        return rzV
    }()
    
    //名称
    var nameLabel:UILabel = {
        let nameL = UILabel.init()
        nameL.textAlignment = .left
        nameL.textColor = .init(hex: "#333333")
        nameL.font = UIFont.boldSystemFont(ofSize: 15)
        return nameL
    }()
    
    //会员标
    var hyImageView : UIImageView = {
        let hyImage = UIImageView.init()
        hyImage.image = UIImage.init(named: "vip_icon")
        return hyImage
    }()
    
    
    //企业认证/个人认证标
    var typeImageV:UIImageView = {
        let typeV = UIImageView.init()
        typeV.image = UIImage.init(named: "qiyerz")
        return typeV
    }()
    
    //通讯录好友
    var addressLabel:UILabel = {
        let addlabel = UILabel.init()
        addlabel.font = .systemFont(ofSize: 13)
        addlabel.textColor = .init(hex: "#333333")
        return addlabel
    }()
    
    //个人介绍
    var compLabel:UILabel = {
        let cLabel = UILabel.init()
        cLabel.textAlignment = .left
        cLabel.font = .systemFont(ofSize: 13)
        cLabel.textColor = UIColor.init(hex: "#333333")
        return cLabel
    }()
    
    //粉丝数
    var fansLabel:UILabel = {
        let fenNum = UILabel.init()
        fenNum.textAlignment = .left
        fenNum.textColor = color99
        fenNum.font = .systemFont(ofSize: 13)
        return fenNum
    }()
    
    //关注
    var focusBtn:UIButton = {
        let fBtn = UIButton.init()
        fBtn.backgroundColor = UIColor.init(hex: "#FD8024")
        fBtn.layer.masksToBounds = true
        fBtn.layer.cornerRadius = 16
        fBtn.setTitle("关注", for:.normal)
        fBtn.titleLabel?.font = .systemFont(ofSize: 12)
        fBtn.setTitleColor(.white, for: .normal)
        
        return fBtn
    }()
    
    
    var type = 1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubViews()
        self.focusBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.cellType == .BlackList{
                self.loadAddUserBlack()
            }else{
                self.focusBtnClick()
            }

        }
    }
    
    func setSubViews() -> Void {
        
        contentView.addSubview(headImageV)
       
        
        contentView.insertSubview(rzImageV, aboveSubview: headImageV)
        contentView.addSubview(focusBtn)
        
        
        contentView.addSubview(nameLabel)
        
        
        contentView.addSubview(hyImageView)
        
        
        contentView.addSubview(typeImageV)
       
        
        contentView.addSubview(addressLabel)
        contentView.addSubview(fansLabel)
        contentView.addSubview(compLabel)
      
        
        let lineV = UIView.init()
        lineV.backgroundColor = bgColor
        contentView.addSubview(lineV)
        lineV.snp.makeConstraints { make in
            
            make.trailing.equalTo(16)
            make.height.equalTo(0.5)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    func focusBtnClick(){
        UserInfoNetworkProvider.request(.focusOption(focusUserId: userId)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                let flag = dic?["type"] as? Bool ?? true
                                DispatchQueue.main.async {
                                    HQGetTopVC()?.view.makeToast(flag == true ? "关注成功" : "取消关注成功")
                                }
                                self.reloadBlock?(self.tag)
                                if flag == true {
                                    self.focusBtn.setTitle("已关注", for: .normal)
                                    self.focusBtn.setTitleColor(UIColor.init(hex: "#CBCCCD"), for: .normal)
                                    self.focusBtn.backgroundColor = .white
                                    self.focusBtn.layer.borderWidth = 1
                                    self.focusBtn.layer.borderColor = UIColor.init(hex: "#CBCCCD").cgColor
                                }else{
                                    self.focusBtn.setTitle("关注", for: .normal)
                                    self.focusBtn.layer.borderColor = UIColor.clear.cgColor
                                    self.focusBtn.backgroundColor = UIColor.init(hex: "#FD8024")
                                    self.focusBtn.setTitleColor(.white, for: .normal)

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
    
    ///拉黑用户
    func loadAddUserBlack()  {
                    
        UserInfoNetworkProvider.request(.getAddUserBlack(blackUserId: model?.id ?? "")) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultStringModel.self)
                            if model?.code == 0 {
                                DispatchQueue.main.async {[weak self] in
                                    let tipString = model?.data ?? ""
                                    HQGetTopVC()?.view.makeToast(tipString)
                                    self?.reloadBlock?(self?.tag ?? 0)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //1: 通讯录未关注 2: 通讯录关注
//    func subViewLayout(type: Int) {
    override func layoutSubviews() {
        superview?.layoutSubviews()
    
        headImageV.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.height.width.equalTo(64)
            make.centerY.equalToSuperview()
        }
        rzImageV.snp.makeConstraints { (make) in
            make.bottom.equalTo(headImageV.snp.bottom)
            make.width.equalTo(25)
            make.height.equalTo(31)
            make.trailing.equalTo(headImageV.snp.trailing).offset(6)
        }
        focusBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(68)
            make.height.equalTo(32)
        }
        if type == 1 {
            
            nameLabel.snp.makeConstraints { make in
                
                make.leading.equalTo(headImageV.snp.trailing).offset(16)
                make.centerY.equalToSuperview()
            }
        }else{
            
            nameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(headImageV.snp.top).offset(-3)
                make.leading.equalTo(headImageV.snp.trailing).offset(12)
            }
            hyImageView.snp.makeConstraints { (make) in
                make.centerY.equalTo(nameLabel)
                make.leading.equalTo(nameLabel.snp.trailing).offset(5)
                make.width.height.equalTo(22)
            }
            if isVerified {
                
//                if typeImageV.frame.width < 10 {
//
//                    typeImageV.snp.updateConstraints { make in
//
//                        make.width.equalTo(63)
//                    }
//                }else{
                    
                    typeImageV.snp.makeConstraints { (make) in
                        make.leading.equalTo(nameLabel)
                        make.height.equalTo(24)
                        make.width.equalTo(72)
                        make.centerY.equalTo(headImageV)
                    }
              //  }
                
                addressLabel.snp.makeConstraints { (make) in
    //                make.top.equalTo(nameLabel.snp.bottom)
                    make.leading.equalTo(typeImageV.snp.trailing).offset(6)
                    make.centerY.equalTo(headImageV)
                    make.height.equalTo(20)
                    make.trailing.equalTo(focusBtn.snp.leading).offset(-6)
                }
                
            }else{

//                if typeImageV.frame.width > 10 {
//
//                    typeImageV.snp.updateConstraints { make in
//
//                        make.width.equalTo(0.1)
//                    }
//                }
                addressLabel.snp.makeConstraints { (make) in
    //                make.top.equalTo(nameLabel.snp.bottom)
                    make.leading.equalTo(headImageV.snp.trailing).offset(12)
                    make.centerY.equalTo(headImageV)
                    make.height.equalTo(20)
                    make.trailing.equalTo(focusBtn.snp.leading).offset(-6)
                }
            }
            
        
            
            
            fansLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(headImageV)
                make.leading.equalTo(nameLabel)
            }
            
            if type != 2 {
                
                compLabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(fansLabel.snp.trailing).offset(6)
                    make.centerY.equalTo(fansLabel)
                }
            }
        }
        
    }
    
}

extension contentView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.popModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "focusCell", for: indexPath) as! focusCell
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        cell.focusBtn.tag = indexPath.row
        let model = self.popModels![indexPath.row]
        cell.focusModel = model
        cell.focusBtn.addTarget(self, action: #selector(clickFocusBtn(btn:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtindexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func clickFocusBtn(btn:UIButton) -> Void {
        NSLog("############ clickFocusBtn------%d", btn.tag)
        let model = self.popModels![btn.tag]
        
            UserInfoNetworkProvider.request(.focusOption(focusUserId: model.id ?? "")) { (result) in
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
                                        btn.setTitle("关注", for: .normal)
                                        btn.backgroundColor = UIColor.init(hex: "#FD8024")
                                        btn.layer.borderColor = UIColor.clear.cgColor
                                        btn.setTitleColor(.white, for: .normal)
                                        
                                    }else{
                                        HQGetTopVC()?.view.makeToast("关注成功")
                                        btn.setTitle("已关注", for: .normal)
                                        btn.setTitleColor(UIColor.init(hex: "#CBCCCD"), for: .normal)
                                        btn.backgroundColor = .white
                                        btn.layer.borderWidth = 1
                                        btn.layer.borderColor = UIColor.init(hex: "#CBCCCD").cgColor
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

