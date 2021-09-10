//
//  RulerForBodyView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/25.
//
///录入身体数据，卡尺页面

import UIKit

class RulerForBodyView: UIView, DYScrollRulerDelegate {
    var dayNum = 0
    var backBlock : arrBlock? = nil
    func dyScrollRulerView(_ rulerView: DYScrollRulerView!, valueChange value: Float) {
        if rulerView.tag == 1 {
            heiNum = value
        }
        if rulerView.tag == 2 {
            strongNum = value
        }
        if rulerView.tag == 3 {
            weiNum = value
        }
    }
    let navView = UIView()
    let titleLab = UILabel.initSomeThing(title: "基本信息", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    let sview = UIScrollView()
    
    let tipLab = UILabel.initSomeThing(title: "计算BMI和体脂率记录你的变化", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 16), ali: .left)
    
    ///身高卡尺
    let heiRuler : DYScrollRulerView = DYScrollRulerView.init(frame: CGRect.init(x: 16, y: 130, width: screenWid - 32, height: DYScrollRulerView.rulerViewHeight() + 20), theMinValue: 100, theMaxValue: 280, theStep: 0.5, theUnit: "CM", theNum: 2)
    ///体重卡尺
    var strongRuler : DYScrollRulerView = DYScrollRulerView.init(frame: CGRect.init(x: 16, y: 346, width: screenWid - 32, height: DYScrollRulerView.rulerViewHeight() + 20), theMinValue: 20, theMaxValue: 400, theStep: 0.5, theUnit: "KG", theNum: 2)
    ///腰围卡尺
    var weiRuler : DYScrollRulerView =  DYScrollRulerView.init(frame: CGRect.init(x: 16, y: 560, width: screenWid - 32, height: DYScrollRulerView.rulerViewHeight() + 20), theMinValue: 20, theMaxValue: 250, theStep: 0.5, theUnit: "CM", theNum: 2)
    
    var heiNum : Float = 165
    var strongNum : Float = 50
    var weiNum : Float = 70
    
    let enterBtn = UIButton.initTitle(title: "确定", font: .MediumFont(size: 18), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        navView.backgroundColor = .white
        self.addSubview(navView)
        navView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44 + NavStatusHei)
        }
        
        navView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
            make.height.equalTo(44)
        }
        
        navView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.bottom.equalTo(-10)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navView.snp.bottom)
            make.height.equalTo(12)
        }
        
        sview.contentSize = .init(width: screenWid, height: 726)
        sview.showsVerticalScrollIndicator = false
        self.addSubview(sview)
        sview.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalTo(-80)
        }
        
        sview.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.equalTo(300)
            make.height.equalTo(22)
            make.top.equalTo(32)
        }
        
        let heiLab = UILabel.initSomeThing(title: "身高", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 18), ali: .left)
        let strongLab = UILabel.initSomeThing(title: "体重", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 18), ali: .left)
        let weiLab = UILabel.initSomeThing(title: "腰围", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 18), ali: .left)
        
        sview.addSubview(heiLab)
        heiLab.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(50)
            make.left.equalTo(16)
            make.top.equalTo(93)
        }
        sview.addSubview(strongLab)
        strongLab.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(50)
            make.left.equalTo(16)
            make.top.equalTo(309)
        }
        sview.addSubview(weiLab)
        weiLab.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(50)
            make.left.equalTo(16)
            make.top.equalTo(523)
        }
        
        heiRuler.setDefaultValue(165, animated: false)
        heiRuler.backgroundColor = .clear
        heiRuler.triangleColor = .init(hex: "#FD8024")
        heiRuler.delegate = self
        heiRuler.scrollByHand = true
        heiRuler.unitLab.font = .systemFont(ofSize: 16)
        heiRuler.unitLab.textColor =  .init(hex: "#FD8024")
        heiRuler.valueTF.font = .SemiboldFont(size: 32)
        heiRuler.valueTF.textColor =  .init(hex: "#FD8024")
        
        strongRuler.setDefaultValue(50, animated: false)
        strongRuler.backgroundColor = .clear
        strongRuler.triangleColor = .init(hex: "#FD8024")
        strongRuler.delegate = self
        strongRuler.scrollByHand = true
        strongRuler.unitLab.font = .systemFont(ofSize: 16)
        strongRuler.unitLab.textColor =  .init(hex: "#FD8024")
        strongRuler.valueTF.font = .SemiboldFont(size: 32)
        strongRuler.valueTF.textColor =  .init(hex: "#FD8024")
        
        weiRuler.setDefaultValue(70, animated: false)
        weiRuler.backgroundColor = .clear
        weiRuler.triangleColor = .init(hex: "#FD8024")
        weiRuler.delegate = self
        weiRuler.scrollByHand = true
        weiRuler.unitLab.font = .systemFont(ofSize: 16)
        weiRuler.unitLab.textColor =  .init(hex: "#FD8024")
        weiRuler.valueTF.font = .SemiboldFont(size: 32)
        weiRuler.valueTF.textColor =  .init(hex: "#FD8024")
       
        heiRuler.tag = 1
        strongRuler.tag = 2
        weiRuler.tag = 3
        
        sview.addSubview(heiRuler)
        sview.addSubview(strongRuler)
        sview.addSubview(weiRuler)
        
        enterBtn.layer.cornerRadius = 22.5
        enterBtn.layer.masksToBounds = true
        self.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
        }
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] btn in
            self!.backBlock?([self!.heiNum,self!.strongNum,self!.weiNum])
            self?.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDays(){
        
    }
}
