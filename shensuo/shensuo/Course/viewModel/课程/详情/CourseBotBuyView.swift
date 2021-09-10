//
//  CourseBotBuyView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/6.
//

import UIKit
import BSText

enum CourseBuyType {
    case free
    case vipFree
    case pay
}
//SSMyVipViewController
class CourseBotBuyView: UIView {
    
    var isProject = false
    
    var isStep = false
    ///购买回调
    var buyBlock : voidBlock? = nil
    var type : CourseBuyType = .free
    let btnBGImg = UIImageView.initWithName(imgName: "course_buy_btn")
    
    let normalLab = UILabel.initSomeThing(title: "加入学习", titleColor: .white, font: .MediumFont(size: 18), ali: .center)
    let normalBtn = UIButton()
    
    var price : String? = nil{
        didSet{
            if price != nil {
                let protocolText = NSMutableAttributedString(string: String.init(format: "%.2f贝 单独购买", price?.toDouble ?? 0))
                protocolText.bs_font = .MediumFont(size: 24)
                protocolText.bs_color = .init(hex: "#FECC99")
                protocolText.bs_alignment = .center
                protocolText.bs_set(font: .MediumFont(size: 11), range: .init(location: protocolText.length - 5, length: 5))
                tipLab2.attributedText = protocolText
            }
        }
    }
    
    let tipLab2 = BSLabel()
    let tipLab = BSLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.addSubview(btnBGImg)
        btnBGImg.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(58)
            make.centerY.equalToSuperview()
        }
        btnBGImg.isHidden = true
        
        normalLab.layer.cornerRadius = 29
        normalLab.layer.masksToBounds = true
        normalLab.backgroundColor = .init(hex: "#FD8024")
        self.addSubview(normalLab)
        normalLab.snp.makeConstraints { make in
            make.edges.equalTo(btnBGImg)
        }
        tipLab.textAlignment = .center
        tipLab2.textAlignment = .center
        self.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(58)
            make.top.equalTo(normalLab)
        }
        
        self.addSubview(tipLab2)
        tipLab2.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.width.equalTo(screenWid * 0.5)
            make.height.equalTo(58)
            make.top.equalTo(normalLab)
        }
        let tipBtn = UIButton()
        let tipBtn2 = UIButton()
        tipLab.addSubview(tipBtn)
        tipLab2.addSubview(tipBtn2)
        tipBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tipBtn2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tipBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in

                ///上报事件
                HQPushActionWith(name: "click_buy_vip", dic:  ["current_page":self.isProject ? "方案vip免费按钮" : "课程vip免费按钮"])
                HQPush(vc: SSMyVipViewController(), style: .lightContent)
            
        }
        tipBtn2.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.isStep{
                NotificationCenter.default.post(name: NeedToAddProjectNotification,object: nil,userInfo: nil)
            }
            self.buyBlock?()
            
        }
        self.addSubview(normalBtn)
        normalBtn.snp.makeConstraints { make in
            make.edges.equalTo(btnBGImg)
        }
        normalBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.isStep{
                NotificationCenter.default.post(name: NeedToAddProjectNotification,object: nil,userInfo: nil)
            }

            self.buyBlock?()
            
        }
    }
    
    
    func changgeWithType(type:CourseBuyType){
        self.type = type
        if isStep{
            self.normalLab.isHidden = false
            self.btnBGImg.isHidden = true
            self.normalBtn.isHidden = false
            self.tipLab2.isHidden = true
            self.tipLab.isHidden = true
            if type == .free {
                self.normalLab.text = "加入学习"
            }else{
                
                self.normalLab.text = self.isProject ? "返回方案详情购买" : "返回课程详情购买"
            }
            
            return
        }
        switch type {
        case .free:
            self.normalLab.isHidden = false
            self.btnBGImg.isHidden = true
            self.normalBtn.isHidden = false
            self.tipLab2.isHidden = true
            self.tipLab.isHidden = true
            self.normalLab.text = "加入学习"
        case .pay:
            self.normalLab.isHidden = false
            self.btnBGImg.isHidden = true
            self.tipLab2.isHidden = true
            self.tipLab.isHidden = true
            self.normalBtn.isHidden = false
            self.normalLab.text = "立即购买"
        case .vipFree:
            let state = UserVipState()
            if state == .isVip {
                self.normalLab.isHidden = false
                self.btnBGImg.isHidden = true
                self.tipLab2.isHidden = true
                self.tipLab.isHidden = false
                self.normalBtn.isHidden = false
                self.normalLab.text = ""
                let protocolText = NSMutableAttributedString(string: "免费学习 年卡会员")
                protocolText.bs_alignment = .center
                protocolText.bs_font = .MediumFont(size: 18)
                protocolText.bs_color = .white
                protocolText.bs_set(font: .MediumFont(size: 11), range: .init(location: 4, length: 5))
                tipLab.attributedText = protocolText
            }else if state == .loseVip{
                self.normalLab.isHidden = true
                self.btnBGImg.isHidden = false
                self.normalBtn.isHidden = true
                self.tipLab2.isHidden = false
                self.tipLab.isHidden = false
                self.normalLab.text = ""
                let protocolText = NSMutableAttributedString(string: "免费学习 续费年卡会员")
                protocolText.bs_alignment = .center
                protocolText.bs_font = .MediumFont(size: 18)
                protocolText.bs_color = .white
                protocolText.bs_set(font: .MediumFont(size: 11), range: .init(location: 4, length: 7))
                tipLab.attributedText = protocolText
                
                tipLab.snp.remakeConstraints { make in
                    make.width.equalTo(screenWid * 0.45)
                    make.height.equalTo(58)
                    make.right.equalTo(-10)
                    make.top.equalTo(normalLab)
                }
            }else{
                self.normalLab.isHidden = true
                self.btnBGImg.isHidden = false
                self.normalBtn.isHidden = true
                self.tipLab2.isHidden = false
                self.tipLab.isHidden = false
                self.normalLab.text = ""
                let protocolText = NSMutableAttributedString(string: "免费学习 开通年卡会员")
                protocolText.bs_alignment = .center
                protocolText.bs_font = .MediumFont(size: 18)
                protocolText.bs_color = .white
                protocolText.bs_set(font: .MediumFont(size: 11), range: .init(location: 4, length: 7))
                
                tipLab.attributedText = protocolText
                
                tipLab.snp.remakeConstraints { make in
                    make.width.equalTo(screenWid * 0.45)
                    make.height.equalTo(58)
                    make.right.equalTo(-10)
                    make.top.equalTo(normalLab)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
