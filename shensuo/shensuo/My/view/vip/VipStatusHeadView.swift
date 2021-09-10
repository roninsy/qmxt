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
        for sv in self.subviews {
            sv.removeFromSuperview()
        }
        if type == 0 {
            let bgImg = UIImageView.initWithName(imgName: "vip_top_bg")
            let vipImg = UIImageView.initWithName(imgName: "vip_icon")
            let vipLogoImg = UIImageView.initWithName(imgName: "全民形体会员")
            self.addSubview(bgImg)
            bgImg.contentMode = .scaleToFill
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
            let protocolText = NSMutableAttributedString(string: "会员专享价 \(priceStr)贝/年")
            protocolText.bs_color = .init(hex: "#F5CF9E")
            protocolText.bs_font = .systemFont(ofSize: 16)
            protocolText.bs_set(font: .SemiboldFont(size: 24), range: NSRange.init(location: 6, length: priceStr.length))
            priceLab.attributedText = protocolText
            self.addSubview(priceLab)
            priceLab.snp.makeConstraints { make in
                make.height.equalTo(33)
                make.left.equalTo(vipImg)
                make.top.equalTo(tipLab.snp.bottom).offset(20)
            }
            priceLab.sizeToFit()
            
            let maketPriceLab = UILabel.initSomeThing(title: "\(UserInfo.getSharedInstance().vipMarketPrice ?? 1500)贝/年", titleColor: .init(hex: "#F5CF9E"), font: .systemFont(ofSize: 16), ali: .left)
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

        }else{
            
            let bgImg = UIImageView.initWithName(imgName: "vip_top_bg_true")
            let vipImg = UIImageView.initWithName(imgName: "vip_icon_true")
            self.addSubview(bgImg)
            bgImg.contentMode = .scaleToFill
            bgImg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let headBG = UIView()
            headBG.backgroundColor = .white
            headBG.layer.cornerRadius = 30
            headBG.layer.masksToBounds = true
            self.addSubview(headBG)
            headBG.snp.makeConstraints { make in
                make.width.height.equalTo(60)
                make.left.equalTo(24)
                make.top.equalTo(24)
            }
            
            let headImg = UIImageView()
            headImg.kf.setImage(with: URL.init(string: UserInfo.getSharedInstance().headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
            headImg.layer.cornerRadius = 28
            headImg.layer.masksToBounds = true
            self.addSubview(headImg)
            headImg.snp.makeConstraints { make in
                make.width.height.equalTo(56)
                make.center.equalTo(headBG)
            }
            
            let RIcon = UIImageView.initWithName(imgName: "r_icon")
            self.addSubview(RIcon)
            RIcon.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.right.equalTo(headBG).offset(-5)
                make.bottom.equalTo(headBG).offset(5)
            }
            
            let nameLab = UILabel.initSomeThing(title: UserInfo.getSharedInstance().nickName ?? "", titleColor: .init(hex: "#FFD6AE"), font: .MediumFont(size: 18), ali: .left)
            self.addSubview(nameLab)
            nameLab.snp.makeConstraints { make in
                make.height.equalTo(25)
                make.left.equalTo(headBG.snp.right).offset(13)
                make.top.equalTo(headBG).offset(7)
            }
            nameLab.sizeToFit()
            
            self.addSubview(vipImg)
            vipImg.snp.makeConstraints { make in
                make.width.equalTo(16)
                make.height.equalTo(19)
                make.left.equalTo(nameLab.snp.right).offset(6)
                make.centerY.equalTo(nameLab)
            }
            
            let timeLab = UILabel.initSomeThing(title: "有效期 至 \(UserInfo.getSharedInstance().endEffectiveDate ?? "")", titleColor: .init(hex: "#FFD6AE"), font: .systemFont(ofSize: 13), ali: .left)
            self.addSubview(timeLab)
            timeLab.snp.makeConstraints { make in
                make.height.equalTo(18)
                make.left.equalTo(nameLab)
                make.right.equalTo(-24)
                make.top.equalTo(nameLab.snp.bottom).offset(4)
            }
            
            let vipInfoLab = BSLabel()
            let vipDay = String(UserInfo.getSharedInstance().vipDays ?? 0)
            let thriftMoney = UserInfo.getSharedInstance().thriftMoney?.stringValue ?? "0"
            let protocolText = NSMutableAttributedString(string: "已成为会员\(vipDay)天，累计节省\(thriftMoney)贝")
            protocolText.bs_color = .init(hex: "#F5CF9E")
            protocolText.bs_font = .systemFont(ofSize: 14)
            protocolText.bs_set(font: .SemiboldFont(size: 18), range: NSRange.init(location: 5, length: vipDay.length))
            protocolText.bs_set(font: .SemiboldFont(size: 18), range: NSRange.init(location: 11 + vipDay.length, length: thriftMoney.length))
            protocolText.bs_set(color: .init(hex: "#FFCA69"), range: NSRange.init(location: 5, length: vipDay.length))
            protocolText.bs_set(color: .init(hex: "#FFCA69"), range: NSRange.init(location: 11 + vipDay.length, length: thriftMoney.length))
            
            vipInfoLab.attributedText = protocolText
            self.addSubview(vipInfoLab)
            vipInfoLab.snp.makeConstraints { make in
                make.height.equalTo(25)
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.top.equalTo(timeLab.snp.bottom).offset(30)
            }
            
            let vipNum = UILabel.initSomeThing(title: "NO：\(UserInfo.getSharedInstance().vipNumber ?? "")", titleColor: .init(hex: "#FFD6AE"), font: .SemiboldFont(size: 16), ali: .left)
            self.addSubview(vipNum)
            vipNum.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.bottom.equalTo(-16)
                make.right.equalTo(-24)
                make.height.equalTo(22)
            }
        }
    }
}
