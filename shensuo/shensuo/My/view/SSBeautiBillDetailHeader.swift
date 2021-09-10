//
//  SSBeautiBillDetailHeader.swift
//  shensuo
//
//  Created by  yang on 2021/5/5.
//

import UIKit

enum headerType {
    case bill //美币
    case account //账户
}

class SSBeautiBillDetailHeader: UIView {

    var navView:SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
    var type : headerType = .bill
    
    let bgImageView = UIImageView.initWithName(imgName: "bt_bg")
    let layerImage = UIImageView.initWithName(imgName:"bt_mh")
    
    var infoImageView:UIImageView = {
        let infoImage = UIImageView.init()
        infoImage.backgroundColor = .white
        infoImage.isUserInteractionEnabled = true
        infoImage.layer.masksToBounds = true
        infoImage.layer.cornerRadius = 5
        return infoImage
    }()
    
    let titleLabel = UILabel.initSomeThing(title: "账户余额", fontSize: 16, titleColor: .init(hex: "#333333"))
    let valueLabel = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 36, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let checkBtn = UIButton.init()
    
    let incom = UILabel.initSomeThing(title: "总收入", fontSize: 16, titleColor: .init(hex: "#333333"))
    let incomValue = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 18, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outcom = UILabel.initSomeThing(title: "总支出", fontSize: 16, titleColor: .init(hex: "#333333"))
    let outcomValue = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 18, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let lineView = UIView.init()
    
    let buyBtn = UIButton.init()
    
    var mainMeiBiView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    func setTitle() -> Void {
        checkBtn.setBackgroundImage(UIImage.init(named: "bt_exbg"), for: .normal)
        checkBtn.setTitleColor(.white, for: .normal)
        checkBtn.titleLabel?.font = .systemFont(ofSize: 14)
        if self.type == .account {
            navView.backBtnWithTitle(title: "账户明细")
            checkBtn.setTitle("提现", for: .normal)
            buyBtn.isHidden = true
        } else {
            self.titleLabel.text = "美币余额"
            navView.backWithTitleOptionBtn(title: "我的美币", option: "")
            checkBtn.setTitle("我的兑换", for: .normal)
        }
    }
    
    func buildUI() -> Void {
        addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*372)
        }
        
        bgImageView.addSubview(navView)
        navView.backgroundColor = .clear
        navView.backBtn.setImage(UIImage.init(named: "back_white"), for: .normal)
        navView.titleLabel.textColor = .white
        navView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(48)
            make.height.equalTo(44)
        }
        navView.optionBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
//            let billBoxVC = SSBeautiBillBoxViewController.init()
//            billBoxVC.point = UserInfo.getSharedInstance().points
//            billBoxVC.hidesBottomBarWhenPushed = true
//            HQPush(vc: billBoxVC, style: .lightContent)
        }
        
        bgImageView.addSubview(layerImage)
        layerImage.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(screenWid/414*134)
        }
        
        bgImageView.addSubview(infoImageView)
        infoImageView.isUserInteractionEnabled = true
        infoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-16)
        }
        
        infoImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(23)
            make.left.equalTo(27)
            make.height.equalTo(22)
            make.width.equalTo(100)
        }
        
        valueLabel.adjustsFontSizeToFitWidth = true
        infoImageView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(27)
            make.right.equalTo(-100)
            make.height.equalTo(50)
        }
        
        infoImageView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.right.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(80)
        }
        
        infoImageView.addSubview(incom)
        incom.snp.makeConstraints { (make) in
            make.left.equalTo(22)
            make.width.equalTo(60)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-106)
        }
        
        infoImageView.addSubview(incomValue)
        incomValue.snp.makeConstraints { (make) in
            make.left.equalTo(22)
            make.width.equalTo(120)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-77)
        }
        
        infoImageView.addSubview(lineView)
        lineView.backgroundColor = .init(hex: "#EEEFF0")
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(incom.snp.bottom).offset(-5)
            make.width.equalTo(1)
            make.height.equalTo(21)
            make.left.equalTo(145)
        }
        
        infoImageView.addSubview(outcom)
        outcom.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(36)
            make.centerY.equalTo(incom)
            make.width.height.equalTo(incom)
        }
        
        infoImageView.addSubview(outcomValue)
        outcomValue.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(36)
            make.centerY.equalTo(incomValue)
            make.width.height.equalTo(incomValue)
        }
        
        infoImageView.addSubview(buyBtn)
        buyBtn.setTitle("购买美币", for: .normal)
        buyBtn.setTitleColor(.init(hex: "#333333"), for: .normal)
        buyBtn.setImage(UIImage.init(named: "bt_buy"), for: .normal)
        buyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(22)
            make.bottom.equalTo(-15)
        }
        buyBtn.isHidden = self.type == .account

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

///账户明细头部
class SSAmountDetailHeader: UIView {

    var navView:SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
    var type : headerType = .bill
    
    let bgImageView = UIImageView.initWithName(imgName: "bt_bg")
    let layerImage = UIImageView.initWithName(imgName:"bt_mh")
    
    var infoImageView:UIImageView = {
        let infoImage = UIImageView.init()
        infoImage.backgroundColor = .white
        infoImage.isUserInteractionEnabled = true
        infoImage.layer.masksToBounds = true
        infoImage.layer.cornerRadius = 5
        return infoImage
    }()
    
    let titleLabel = UILabel.initSomeThing(title: "账户余额", fontSize: 16, titleColor: .init(hex: "#333333"))
    let valueLabel = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 36, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let checkBtn = UIButton.initTitle(title: "提现", font: .systemFont(ofSize: 16), titleColor: .init(hex: "#FD8024"), bgColor: .white)
    
    
    
    let incom = UILabel.initSomeThing(title: "总收入", fontSize: 16, titleColor: .init(hex: "#333333"))
    let incomValue = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 18, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outcom = UILabel.initSomeThing(title: "总支出", fontSize: 16, titleColor: .init(hex: "#333333"))
    let outcomValue = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 18, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let lineView = UIView.init()
    
    var mainMeiBiView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    func setTitle() -> Void {
        navView.backBtnWithTitle(title: "账户明细")
    }
    
    func buildUI() -> Void {
        addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*372)
        }
        
        bgImageView.addSubview(navView)
        navView.backgroundColor = .clear
        navView.backBtn.setImage(UIImage.init(named: "back_white"), for: .normal)
        navView.titleLabel.textColor = .white
        navView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(48)
            make.height.equalTo(44)
        }
        navView.optionBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
//            let billBoxVC = SSBeautiBillBoxViewController.init()
//            billBoxVC.point = UserInfo.getSharedInstance().points
//            billBoxVC.hidesBottomBarWhenPushed = true
//            HQPush(vc: billBoxVC, style: .lightContent)
        }
        
        bgImageView.addSubview(layerImage)
        layerImage.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(screenWid/414*134)
        }
        
        bgImageView.addSubview(infoImageView)
        infoImageView.isUserInteractionEnabled = true
        infoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-16)
        }
        
        infoImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(23)
            make.left.equalTo(27)
            make.height.equalTo(22)
            make.width.equalTo(100)
        }
        
        valueLabel.adjustsFontSizeToFitWidth = true
        infoImageView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(27)
            make.right.equalTo(-100)
            make.height.equalTo(50)
        }
        
        checkBtn.layer.borderColor = UIColor.init(hex: "#FD8024").cgColor
        checkBtn.layer.borderWidth = 1
        checkBtn.layer.cornerRadius = 16
        checkBtn.layer.masksToBounds = true
        infoImageView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.top.equalTo(23)
            make.right.equalTo(-16)
            make.height.equalTo(32)
            make.width.equalTo(80)
        }
        
        checkBtn.isHidden = true
        if (UserInfo.getSharedInstance().appVersion ?? 0) <= (UserInfo.getSharedInstance().version ?? 0) {
            checkBtn.isHidden = false
        }
        
        infoImageView.addSubview(incom)
        incom.snp.makeConstraints { (make) in
            make.left.equalTo(22)
            make.width.equalTo(60)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-54)
        }
        
        infoImageView.addSubview(incomValue)
        incomValue.snp.makeConstraints { (make) in
            make.left.equalTo(22)
            make.width.equalTo(120)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-77)
        }
        
        infoImageView.addSubview(lineView)
        lineView.backgroundColor = .init(hex: "#EEEFF0")
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(incom.snp.bottom).offset(-5)
            make.width.equalTo(1)
            make.height.equalTo(21)
            make.left.equalTo(145)
        }
        
        infoImageView.addSubview(outcom)
        outcom.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(36)
            make.centerY.equalTo(incom)
            make.width.height.equalTo(incom)
        }
        
        infoImageView.addSubview(outcomValue)
        outcomValue.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(36)
            make.centerY.equalTo(incomValue)
            make.width.height.equalTo(incomValue)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
