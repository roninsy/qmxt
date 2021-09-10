//
//  MyCollectionReusableView.swift
//  shensuo
//
//  Created by  yang on 2021/4/1.
//

import UIKit
import SnapKit

class SSMyHeaderReusableView: UICollectionReusableView {
    
    var userInfoModel:SSUserInfoModel? = nil{
        didSet{
            if userInfoModel != nil {
                
                if userInfoModel!.vip {
                    hyView.hgImage.isHidden = false
                    hyView.timeLabel.isHidden = false
                    hyView.num.isHidden = false
                    hyView.typeImageV.isHidden = false
                    hyView.timeLabel.text = "有效期至" + (userInfoModel?.vipEndDate ?? "")
                    hyView.num.text = userInfoModel?.vipNumber
                } else {
                    hyView.enablehgImage.isHidden = false
                    hyView.tipsLabel.isHidden = false
                }
                
                personView.headImageView.kf.setImage(with: URL.init(string: (userInfoModel?.headImage) ?? ""), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
                //                personView.setNamelabelWidth(nameText: (userInfoModel?.nickName) ?? "")
                personView.nameLabel.text = userInfoModel!.nickName
                personView.hjBtn.setTitle(String(format: "徽章 %d", (userInfoModel?.badgeNumber ?? "")), for: .normal)
                personView.hjBtn.sizeToFit()
                personView.hjBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                    let vc = SSMyBadgeViewController()
                    HQPush(vc: vc, style: .lightContent)
                }
                fourView.fenContent.numLabel.text = String(userInfoModel?.fansNumber ?? 0)
                fourView.foceContent.numLabel.text = String(userInfoModel?.focusNumber ?? 0)
                fourView.tipContent.numLabel.text = String(userInfoModel?.likeTimes ?? 0)
                fourView.meiContent.numLabel.text = String(userInfoModel?.currentPoints ?? 0)  //userInfoModel?.currentPoints ?? ""
                
                userInfoModel!.vip ? hyView.buyButton.setImage(UIImage.init(named: "my_sufei"), for: .normal) : hyView.buyButton.setImage(UIImage.init(named: "my_buyvip"), for: .normal)
                
            }
        }
    }
    
    
    var optionV:optionView = {
        let option = optionView.init()
        return option
    }()
    
    
    //个人资料
    var personView : persionInfoView = {
        let person = persionInfoView()
        person.isUserInteractionEnabled = true
        return person
    }()
    //粉丝关注美币点赞
    var fourView : fourTipsView = {
        let four = fourTipsView.init()
        return four
    }()
    //会员信息
    var hyView : huiyunInfo = {
        let hy = huiyunInfo.init()
        return hy
    }()
    
    var hdImageView: UIImageView = {
        let hdImage = UIImageView.init()
        hdImage.image = UIImage.init(named: "my_hd")
        return hdImage
        
    }()
    
    
    var bgImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "my_bg")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        bgImageView.addSubview(optionV)
        optionV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bgImageView.addSubview(personView)
        personView.snp.makeConstraints { (make) in
            make.top.equalTo(optionV.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        bgImageView.addSubview(fourView)
        fourView.snp.makeConstraints { (make) in
            make.top.equalTo(personView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bgImageView.addSubview(hyView)
        hyView.snp.makeConstraints { (make) in
            make.top.equalTo(fourView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(screenWid-60)
            make.bottom.equalToSuperview()
        }
        
        bgImageView.addSubview(hdImageView)
        hdImageView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.width.equalToSuperview()
            make.height.equalTo(30)
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//按钮
class optionView: UIView {
    //    var sysBtn : UIButton = {
    //        let sBtn = UIButton.init()
    //        sBtn.setImage(UIImage.init(named: "my_sys"), for: .normal)
    //        return sBtn
    //    }()
    //
    //    var setBtn : UIButton = {
    //        let sBtn = UIButton.init()
    //        sBtn.setImage(UIImage.init(named: "my_set"), for: .normal)
    //
    //        return sBtn
    //    }()
    
    let sysBtn = UIButton.initBgImage(imgname: "my_newsys")
    let setBtn = UIButton.initBgImage(imgname: "my_newmessage")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    func initLayout() -> Void {
        addSubview(setBtn)
        setBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(28)
        }
        
        addSubview(sysBtn)
        sysBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalTo(setBtn.snp.left).offset(-10)
            make.width.height.equalTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:个人信息
class persionInfoView: UIView {
    
    var nameLabelWidth:CGFloat = 0
    
    var headImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.image = UIImage.init(named: "imagePlace")
        return imageView
    }()
    
    var sexImageView : UIImageView = {
        let sexImageView = UIImageView.init()
        sexImageView.layer.masksToBounds = true
        sexImageView.image = UIImage.init(named: "nvxing")
        return sexImageView
    }()
    
    var nameLabel : UILabel = {
        let name = UILabel.init()
        name.textAlignment = .left
        name.numberOfLines = 0
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 18)
        name.text = "昵称昵称"
        return name
    }()
    
    var hgImageView : UIImageView = {
        let hgImage = UIImageView.init()
        //        hgImage.image = UIImage.init(named: "my_huiyuan")
        hgImage.image = UIImage.init(named: "my_newisvip")
        return hgImage
    }()
    
    var hjBtn : UIButton = {
        let hj = UIButton.init()
        hj.layer.masksToBounds = true
        hj.layer.cornerRadius = 12
        hj.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.1)
        hj.setImage(UIImage.init(named: "my_newhj"), for: .normal)
        hj.setTitle("徽章 0", for: .normal)
        
        hj.titleLabel?.font = .systemFont(ofSize: 10)
        hj.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 6, bottom: 0, right: 2)
        hj.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 2)
        hj.sizeToFit()
        return hj
    }()
    
    var ewmBtn : UIButton = {
        let ewm = UIButton.init()
        ewm.setImage(UIImage.init(named: "my_ewm"), for: .normal)
        return ewm
    }()
    
    var nextImageView : UIImageView = {
        let next = UIImageView.init()
        next.image = UIImage.init(named: "my_next")
        return next
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        headImageView.backgroundColor = .gray
        // 头像
        addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        // 性别
        addSubview(sexImageView)
        sexImageView.snp.makeConstraints { make in
            make.left.equalTo(headImageView.snp.right).offset(16)
            make.top.equalToSuperview().offset(3)
            make.height.equalTo(25)
        }
        
        // 昵称
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sexImageView.snp.right).offset(8)
            make.top.equalToSuperview().offset(3)
            make.height.equalTo(25)
//            make.width.equalTo(nameLabelWidth)
        }
        
        // 会员
        addSubview(hgImageView)
        hgImageView.snp.makeConstraints { (make) in
            make.left.equalTo(sexImageView.snp.right).offset(4)
            make.centerY.equalTo(sexImageView)
            make.height.width.equalTo(22)
        }
        
        // 徽章ß
        addSubview(hjBtn)
        hjBtn.snp.makeConstraints { (make) in
            make.left.equalTo(sexImageView)
            make.top.equalTo(sexImageView.snp.bottom).offset(7)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        // >（更多）
        addSubview(nextImageView)
        nextImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        // 二维码
        addSubview(ewmBtn)
        ewmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(nextImageView.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    //    func setNamelabelWidth(nameText:String) -> Void {
    //        nameLabel.text = nameText
    //        let statusLabelSize = nameText.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
    //        nameLabelWidth = statusLabelSize.width + 4
    //        buildUI()
    //    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 点赞关注粉丝美币
class fourTipsView: UIView {
    
    var clickFenContentHander: (()->())?
    var clickFocusContentHander:(()->())?
    var clickFocusBtnHander:((UIButton)->(Void))?
    
    //点赞
    var tipContent: labelContent = {
        let con = labelContent.init()
        con.numLabel.text = "0"
        con.tipLabel.text = "点赞"
        return con
    }()
    
    //关注
    var foceContent : labelContent = {
        let foce = labelContent.init()
        foce.numLabel.text = "0"
        foce.tipLabel.text = "关注"
        return foce
    }()
    
    //粉丝
    var fenContent : labelContent = {
        let fen = labelContent.init()
        fen.numLabel.text = "0"
        fen.tipLabel.text = "粉丝"
        
        return fen
    }()
    
    //美币
    var meiContent : labelContent = {
        let mei = labelContent.init()
        mei.numLabel.text = "090"
        mei.tipLabel.text = "美币"
        mei.lineImage.isHidden = true
        return mei
    }()
    
    //关注
    
    var focusBtn : UIButton = {
        let focus = UIButton.init()
        focus.backgroundColor = UIColor.init(hex: "#FD8024")
        focus.setTitle("关注", for: .normal)
        focus.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        focus.layer.masksToBounds = true
        focus.layer.cornerRadius = 12
        return focus
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
        
        let tapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapFenView))
        tapGest.numberOfTapsRequired = 1
        tapGest.numberOfTouchesRequired = 1
        fenContent.addGestureRecognizer(tapGest)
        
        let focusGest = UITapGestureRecognizer.init(target: self, action: #selector(tapFocusView))
        focusGest.numberOfTapsRequired = 1
        focusGest.numberOfTouchesRequired = 1
        foceContent.addGestureRecognizer(focusGest)
        
        focusBtn.reactive.controlEvents(.touchUpInside).observeValues { [self] (btn) in
            clickFocusBtnHander!(btn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapFenView() {
        if clickFenContentHander != nil {
            clickFenContentHander!()
        }
    }
    
    @objc func tapFocusView(){
        if clickFocusContentHander != nil {
            clickFocusContentHander!()
        }
    }
    
    func initLayout() {
        addSubview(tipContent)
        tipContent.snp.makeConstraints { (make) in
            make.top.left.height.equalToSuperview()
            make.width.equalTo(screenWid/4)
            
        }
        
        addSubview(foceContent)
        foceContent.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
            make.left.equalTo(tipContent.snp.right)
            make.width.equalTo(screenWid/4)
        }
        
        addSubview(fenContent)
        fenContent.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
            make.left.equalTo(foceContent.snp.right)
            make.width.equalTo(screenWid/4)
            
        }
        
        addSubview(meiContent)
        meiContent.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
            make.left.equalTo(fenContent.snp.right)
            make.width.equalTo(screenWid/4)
            
        }
        
        addSubview(focusBtn)
        focusBtn.isHidden = true
        focusBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(fenContent.snp.right)
            make.width.equalTo(68)
            make.height.equalTo(32)
        }
        
        let meiBiBtn = UIButton()
        addSubview(meiBiBtn)
        meiBiBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(meiContent)
        }
        meiBiBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = SSBeautiBillDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            HQPush(vc: vc, style: .default)
        }
    }
}

class labelContent: UIView {
    
    var numLabel : UILabel = {
        let num = UILabel.init()
        num.textAlignment = .center
        num.textColor = .white
        num.font = UIFont.boldSystemFont(ofSize: 18)
        return num
    }()
    
    var tipLabel : UILabel = {
        let tip = UILabel.init()
        tip.textAlignment = .center
        tip.textColor = .white
        tip.font = UIFont.systemFont(ofSize: 13)
        return tip
    }()
    
    var lineImage : UIImageView = {
        let line = UIImageView.init()
        line.backgroundColor = .white
        return line
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initLayout() {
        addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.width.equalToSuperview()
            make.height.equalTo(24)
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(numLabel.snp.bottom)
            make.height.equalTo(24)
        }
        
        addSubview(lineImage)
        lineImage.isHidden = true
        lineImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(8)
        }
    }
}

//MARK:会员卡信息
class huiyunInfo: UIView {
    
    //    var hyBgImage : UIImageView = {
    //        let hyBg = UIImageView.init()
    //        hyBg.image = UIImage.init(named: "my_huiyunkabg")
    //        return hyBg
    //    }()
    
    var hyBgImage = UIImageView.init()
    
    var buyButton : UIButton = {
        let buyBtn = UIButton.init()
        //        buyBtn.setImage(UIImage.init(named: "my_buyvip"), for: .normal)
        return buyBtn
    }()
    
    let hgImage = UIImageView.initWithName(imgName: "my_newnovip")
    let enablehgImage = UIImageView.initWithName(imgName: "my_enablehg")
    
    let title = UILabel.initSomeThing(title: "全民形体会员", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#FFFFFF"))
    let tipsLabel = UILabel.initSomeThing(title: "免费学习会员专属课程、方案", fontSize: 12, titleColor: .init(hex: "#FFFFFF"))
    
    let timeLabel  = UILabel.initSomeThing(title: "有效期至2022.12.12", fontSize: 11, titleColor: .init(hex: "#C0A694"))
    let typeImageV = UIImageView.initWithName(imgName: "my_nianka")
    let num = UILabel.initSomeThing(title: "6457 0882 8783 0902", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#F7D19D"))
    let vip_icon = UIImageView.initWithName(imgName: "vip_icon_true")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    func initLayout() {
        addSubview(hyBgImage)
        hyBgImage.isUserInteractionEnabled = true
        hyBgImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        hyBgImage.addSubview(hgImage)
        //        hgImage.isHidden = true
        hgImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(20)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        hyBgImage.addSubview(enablehgImage)
        enablehgImage.isHidden = true
        enablehgImage.snp.makeConstraints { (make) in
            make.left.top.equalTo(20)
            make.width.height.equalTo(22)
        }
        
        
        hyBgImage.addSubview(vip_icon)
        vip_icon.isHidden = true
        vip_icon.snp.makeConstraints { make in
            
            make.leading.equalTo(23)
            make.width.equalTo(41)
            make.height.equalTo(48)
            make.top.equalTo(20)
        }
        
        hyBgImage.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(hgImage.snp.right).offset(10)
            make.centerY.equalTo(hgImage)
            //            make.top.equalTo(20)
            make.height.equalTo(18)
            make.width.equalTo(120)
        }
        
        hyBgImage.addSubview(tipsLabel)
        //        tipsLabel.isHidden = true
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hgImage)
            make.top.equalTo(title.snp.bottom).offset(4)
            make.width.equalTo(180)
            make.height.equalTo(20)
        }
        
        hyBgImage.addSubview(timeLabel)
        timeLabel.isHidden = true
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.width.equalTo(120)
        }
        
        hyBgImage.addSubview(typeImageV)
        typeImageV.isHidden = true
        typeImageV.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(6)
            make.centerY.equalTo(timeLabel)
            make.width.equalTo(26)
            make.height.equalTo(14)
        }
        
        hyBgImage.addSubview(num)
        num.isHidden = true
        num.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        hyBgImage.addSubview(buyButton)
        buyButton.backgroundColor = .init(hex: "#FD8024")
        buyButton.setTitle("立即开通", for: .normal)
        buyButton.titleLabel?.font = .systemFont(ofSize: 14)
        buyButton.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
        buyButton.layer.masksToBounds = true
        buyButton.layer.cornerRadius = 15
        buyButton.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.right.equalTo(-10)
        }
        buyButton.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
