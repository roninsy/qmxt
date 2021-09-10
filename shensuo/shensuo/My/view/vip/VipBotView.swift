//
//  VipBotView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/10.
//

import UIKit
import BSText

class VipBotView: UIView {

    let topLab = BSLabel()
    
    let bgImg = UIImageView.initWithName(imgName: "vip_bot_bg")
    
    let courseLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .right)
    
    let projectLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .right)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(topLab)
        topLab.snp.makeConstraints { make in
            make.height.equalTo(33)
            make.left.right.equalToSuperview()
            make.top.equalTo(16)
        }
        let priceStr = String(UserInfo.getSharedInstance().costSavingsOfYears?.stringValue ?? "4000")
        let protocolText = NSMutableAttributedString(string: "会员平均每年可省¥\(priceStr)")
        protocolText.bs_color = .init(hex: "#333333")
        protocolText.bs_font = .systemFont(ofSize: 16)
        protocolText.bs_alignment = .center
        protocolText.bs_set(font: .SemiboldFont(size: 24), range: NSRange.init(location: 8, length: priceStr.length + 1))
        protocolText.bs_set(color: .init(hex: "#EF0B19"), range: NSRange.init(location: 8, length: priceStr.length + 1))
        topLab.attributedText = protocolText

        self.addSubview(bgImg)
        bgImg.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(181)
            make.top.equalTo(65)
        }
        
        let tipLab1 = UILabel.initSomeThing(title: "专享会员免费课程", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
        self.addSubview(tipLab1)
        tipLab1.snp.makeConstraints { make in
            make.left.equalTo(36)
            make.top.equalTo(89)
            make.right.equalTo(-140)
            make.height.equalTo(22)
        }
        
        let tipLab2 = UILabel.initSomeThing(title: "VIP课程免费学", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), ali: .left)
        self.addSubview(tipLab2)
        tipLab2.snp.makeConstraints { make in
            make.left.equalTo(tipLab1)
            make.top.equalTo(tipLab1.snp.bottom).offset(6)
            make.right.equalTo(tipLab1)
            make.height.equalTo(20)
        }
        
        
        let tipLab3 = UILabel.initSomeThing(title: "专享会员免费方案", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
        self.addSubview(tipLab3)
        tipLab3.snp.makeConstraints { make in
            make.left.equalTo(tipLab1)
            make.top.equalTo(174)
            make.right.equalTo(tipLab1)
            make.height.equalTo(22)
        }
        
        let tipLab4 = UILabel.initSomeThing(title: "VIP方案免费学", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), ali: .left)
        self.addSubview(tipLab4)
        tipLab4.snp.makeConstraints { make in
            make.left.equalTo(tipLab3)
            make.top.equalTo(tipLab3.snp.bottom).offset(6)
            make.right.equalTo(tipLab3)
            make.height.equalTo(20)
        }
        
        self.addSubview(courseLab)
        courseLab.snp.makeConstraints { make in
            make.right.equalTo(-36)
            make.width.equalTo(100)
            make.height.equalTo(22)
            make.top.equalTo(102)
        }
        
        self.addSubview(projectLab)
        projectLab.snp.makeConstraints { make in
            make.right.equalTo(-36)
            make.width.equalTo(100)
            make.height.equalTo(22)
            make.top.equalTo(187)
        }
        
        courseLab.text = "\(UserInfo.getSharedInstance().costSavingsForCourse?.stringValue ?? "2000")贝"
        projectLab.text = "\(UserInfo.getSharedInstance().costSavingsForPlan?.stringValue ?? "2000")贝"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
