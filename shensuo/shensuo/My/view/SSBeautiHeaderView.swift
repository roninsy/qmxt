//
//  SSBeautiHeaderView.swift
//  shensuo
//
//  Created by  yang on 2021/5/5.
//

import UIKit

class SSBeautiHeaderView: UIView {
    
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
    
    let titleLabel = UILabel.initSomeThing(title: "美币余额", isBold: false, fontSize: 16, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    let valueLabel = UILabel.initSomeThing(title: "5000", isBold: true, fontSize: 36, textAlignment: .center, titleColor: .init(hex: "#333333"))


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
        navView.backWithTitleOptionBtn(title: "美币任务", option: "美币魔盒")
    }
    
    func buildUI() -> Void {
        addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*320)
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
        
        bgImageView.addSubview(layerImage)
        layerImage.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(screenWid/414*134)
        }
        
        bgImageView.addSubview(infoImageView)
        infoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-16)
        }
        
        infoImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
        
        infoImageView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
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
