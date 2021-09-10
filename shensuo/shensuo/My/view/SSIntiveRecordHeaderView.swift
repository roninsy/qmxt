//
//  SSIntiveRecordHeaderView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/10.
//

import UIKit

class SSIntiveRecordHeaderView: UIView {
    
    var navView:SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
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
    
    let titleLabel = UILabel.initSomeThing(title: "邀请成功人数", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .center)
    let valueLabel = UILabel.initSomeThing(title: "0", isBold: true, fontSize: 36, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    
    let intiveImg = UIImageView.initWithName(imgName: "intive_user_btn")
    let intiveLab = UILabel.initSomeThing(title: "邀请好友", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    let intiveBtn = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    
    func buildUI() -> Void {
        addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*320)
        }

        
        navView.backBtnWithTitle(title: "邀请记录")

       
        bgImageView.addSubview(navView)
        navView.backgroundColor = .clear
        navView.backBtn.setImage(UIImage.init(named: "back_white"), for: .normal)
        navView.titleLabel.textColor = .white
        navView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(48)
            make.height.equalTo(44)
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
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        infoImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(43)
            make.left.right.equalTo(0)
            make.height.equalTo(22)
        }
        
        valueLabel.adjustsFontSizeToFitWidth = true
        infoImageView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        infoImageView.addSubview(intiveImg)
        intiveImg.snp.makeConstraints { (make) in
            make.top.equalTo(valueLabel.snp.bottom).offset(32)
            make.left.equalTo((screenWid - 32 - 100) / 2)
            make.height.width.equalTo(24)
        }
        
        infoImageView.addSubview(intiveLab)
        intiveLab.snp.makeConstraints { (make) in
            make.left.equalTo(intiveImg.snp.right)
            make.width.equalTo(76)
            make.height.equalTo(22)
            make.centerY.equalTo(intiveImg)
        }
        
        infoImageView.addSubview(intiveBtn)
        intiveBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(intiveImg)
            make.right.equalTo(intiveLab)
        }
        intiveBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = ShareVC()
            vc.type = 1
            vc.onlyShare = true
            vc.setupMainView()
            HQPush(vc: vc, style: .lightContent)
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
