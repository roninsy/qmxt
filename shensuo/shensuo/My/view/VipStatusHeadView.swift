//
//  VipStatusHeadView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/10.
//

import UIKit
import BSText

class VipStatusHeadView: UIView {

    ///0开通前 1开通后
    var type = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        if type == 0 {
            let bgImg = UIImageView.initWithName(imgName: "vip_top_bg")
            let vipImg = UIImageView.initWithName(imgName: "vip_icon")
            let vipLogoImg = UIImageView.initWithName(imgName: "全民形体会员")
            self.addSubview(bgImg)
            bgImg.contentMode = .scaleAspectFill
            bgImg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            self.addSubview(vipImg)
            vipImg.snp.makeConstraints { make in
                make.width.height.equalTo(18)
                make.left.equalTo(24)
                make.top.equalTo(29)
            }
            
            self.addSubview(vipLogoImg)
            vipLogoImg.snp.makeConstraints { make in
                make.width.equalTo(107)
                make.height.equalTo(17)
                make.left.equalTo(50)
                make.centerY.equalTo(vipImg)
            }
            
            let tipLab = UILabel.initSomeThing(title: "免费学习会员专属课程、方案", titleColor: .init(hex: "#F5CF9E"), font: .systemFont(ofSize: 14), ali: .left)
            self.addSubview(tipLab)
            tipLab.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.left.equalTo(vipImg)
                make.right.equalTo(-20)
                make.top.equalTo(vipImg.snp.bottom).offset(11)
            }
            
            let priceLab = BSLabel()
            let priceStr = String(UserInfo.getSharedInstance().vipPrice ?? 365)
            let protocolText = NSMutableAttributedString(string: "会员专享价 ¥\(priceStr)年")
            protocolText.bs_color = .init(hex: "#F5CF9E")
            protocolText.bs_font = .systemFont(ofSize: 16)
            protocolText.bs_set(font: .SemiboldFont(size: 24), range: NSRange.init(location: 7, length: priceStr.length))
            priceLab.attributedText = protocolText
            self.addSubview(priceLab)
            priceLab.snp.makeConstraints { make in
                make.height.equalTo(33)
                make.left.equalTo(vipImg)
                make.top.equalTo(tipLab.snp.bottom).offset(20)
            }
            priceLab.sizeToFit()
            
            let maketPriceLab = UILabel.initSomeThing(title: "￥\(UserInfo.getSharedInstance().vipMarketPrice ?? 1500)/年", titleColor: .init(hex: "#F5CF9E"), font: .systemFont(ofSize: 16), ali: .left)
            self.addSubview(maketPriceLab)
            maketPriceLab.snp.makeConstraints { make in
                make.height.equalTo(22)
                make.left.equalTo(priceLab.snp.right).offset(8)
                make.top.equalTo(priceLab).offset(8)
            }
            maketPriceLab.sizeToFit()
            
            let priceLine = UIView()
            priceLine.backgroundColor = .init(hex: "#F5CF9E")
            self.addSubview(priceLine)
            priceLine.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalTo(maketPriceLab)
                make.centerY.equalTo(maketPriceLab)
            }
        }
    }
}
