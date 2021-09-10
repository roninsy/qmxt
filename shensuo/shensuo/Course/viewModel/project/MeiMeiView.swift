//
//  MeiMeiView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/18.
//人工智能美美

import UIKit

class MeiMeiView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        // shadowCode
        self.layer.shadowColor = UIColor(red: 0.6, green: 0.57, blue: 0.62, alpha: 0.14).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10

        self.layer.cornerRadius = 6;
        self.alpha = 1
        
        let titleLab = UILabel.initSomeThing(title: "智能方案", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 18), ali: .left)
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        
        let robotImg = UIImageView.initWithName(imgName: "jiqiren")
        self.addSubview(robotImg)
        robotImg.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.height.equalTo(100)
            make.left.equalTo(28)
            make.top.equalTo(49)
        }
        
        let sayLab = UILabel.initSomeThing(title: "亲亲，我是人工智能美美~", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .left)
        self.addSubview(sayLab)
        sayLab.snp.makeConstraints { make in
            make.left.equalTo(126)
            make.top.equalTo(65)
            make.width.equalTo(160)
            make.height.equalTo(18)
        }
        
        let sayLab2 = UILabel.initSomeThing(title: "人工智能帮您量身定制变美方案", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), ali: .left)
        self.addSubview(sayLab2)
        sayLab2.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(21)
            make.height.equalTo(20)
        }
        sayLab2.sizeToFit()
        
        let enterBtn = UIButton.initTitle(title: "立即定制", fontSize: 16, titleColor: .white, bgColor: .init(hex: "#FD8024"))
        enterBtn.titleLabel?.font = .MediumFont(size: 16)
        self.addSubview(enterBtn)
        enterBtn.frame = .init(x: 0, y: 169 - 32, width: screenWid - 20, height: 32)
        enterBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        HQRoude(view: enterBtn, cs: [.bottomLeft,.bottomRight], cornerRadius: 6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
