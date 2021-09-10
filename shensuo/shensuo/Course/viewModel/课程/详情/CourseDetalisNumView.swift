//
//  KeChengDetalisNumView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/21.
//

import UIKit
import BSText

class CourseDetalisNumView: UIView {
    
    var selToMenuBlock:voidBlock? = nil
    ///0课程详情 1小节详情
    var type = 0{
        didSet{
            if type == 1 {
                btnWid = screenWid / 3
                self.setpNumLab.isHidden = true
                self.line1.isHidden = true
                setpNumLab.snp.updateConstraints { make in
                    make.width.equalTo(0)
                }
                botLab1.snp.updateConstraints { make in
                    make.width.equalTo(0)
                }
                personLab.snp.updateConstraints { make in
                    make.width.equalTo(btnWid)
                }
                botLab2.snp.updateConstraints { make in
                    make.width.equalTo(btnWid)
                }
                minLab.snp.updateConstraints { make in
                    make.width.equalTo(btnWid)
                }
                botLab3.snp.updateConstraints { make in
                    make.width.equalTo(btnWid)
                }
                kllLab.snp.updateConstraints { make in
                    make.width.equalTo(btnWid)
                }
                botLab4.snp.updateConstraints { make in
                    make.width.equalTo(btnWid)
                }
            }
        }
    }
    
    var btnWid = screenWid / 4

    let setpNumLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#FD8024"), font: .SemiboldFont(size: 24), ali: .center)
    let personLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#FD8024"), font: .SemiboldFont(size: 24), ali: .center)
    let minLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 24), ali: .center)
    let kllLab = BSLabel()
    
    let botLab1 = UILabel.initSomeThing(title: "预设总小节数", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    let botLab2 = UILabel.initSomeThing(title: "学习人数", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    let botLab3 = UILabel.initSomeThing(title: "总分钟", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    let botLab4 = UILabel.initSomeThing(title: "总消耗", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    let line1 = UIView()
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil {
                personLab.text = "\(model?.studyTimes ?? "0")"
                minLab.text = "\(model?.minutes ?? "0")"
                
                let kllStr = getNumString(num: model?.calorie?.doubleValue ?? 0)
                let protocolText = NSMutableAttributedString(string:  "\(kllStr)千卡")
                protocolText.bs_alignment = .center
                protocolText.bs_font = .SemiboldFont(size: 24)
                protocolText.bs_color = .init(hex: "#333333")
                protocolText.bs_set(font: .systemFont(ofSize: 15), range: .init(location: protocolText.length - 2, length: 2))
                
                kllLab.attributedText = protocolText
            }
            
        }
    }
    var myModel : CourseDetalisModel? = nil{
        didSet{
            if myModel != nil {
                setpNumLab.text = "\(myModel?.totalStep?.intValue ?? 0)"
                personLab.text = "\(myModel?.buyTimes?.intValue ?? 0)"
                minLab.text = "\(myModel?.totalMinutes?.intValue ?? 0)"
                
                let kllNum = myModel?.totalCalorie?.intValue ?? 0
                var kllStr = String(kllNum)
                if kllNum >= 100000 {
                    kllStr = "10万+"
                }else if kllNum > 10000{
                    kllStr = String.init(format: "%.1f万", Double(kllNum) / 10000.0)
                }
                let protocolText = NSMutableAttributedString(string:  "\(kllStr)千卡")
                
                protocolText.bs_alignment = .center
                protocolText.bs_font = .SemiboldFont(size: isBigScreen ? 24 : 20)
                protocolText.bs_color = .init(hex: "#333333")
                protocolText.bs_set(font: .systemFont(ofSize:isBigScreen ? 15 : 12 ), range: .init(location: protocolText.length - 2, length: 2))
                
                kllLab.attributedText = protocolText
                
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0...3 {
            switch i {
            case 0:
                self.addSubview(setpNumLab)
                self.addSubview(botLab1)
                setpNumLab.snp.makeConstraints { (make) in
                    make.left.equalTo(CGFloat(i)*btnWid)
                    make.top.equalTo(25)
                    make.height.equalTo(33)
                    make.width.equalTo(btnWid)
                }
                botLab1.snp.makeConstraints { (make) in
                    make.left.equalTo(CGFloat(i)*btnWid)
                    make.top.equalTo(setpNumLab.snp.bottom)
                    make.height.equalTo(20)
                    make.width.equalTo(btnWid)
                }
                
                line1.backgroundColor = .init(hex: "#CBCCCD")
                self.addSubview(line1)
                line1.snp.makeConstraints { (make) in
                    make.width.equalTo(0.5)
                    make.height.equalTo(21)
                    make.top.equalTo(45)
                    make.right.equalTo(botLab1)
                }
                let learnBtn = UIButton()
                learnBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                    self.selToMenuBlock?()
                }
                self.addSubview(learnBtn)
                learnBtn.snp.makeConstraints { make in
                    make.top.left.right.equalTo(setpNumLab)
                    make.bottom.equalTo(botLab1)
                }
            case 1:
                self.addSubview(personLab)
                self.addSubview(botLab2)
                personLab.snp.makeConstraints { (make) in
                    make.left.equalTo(line1)
                    make.top.equalTo(25)
                    make.height.equalTo(33)
                    make.width.equalTo(btnWid)
                }
                botLab2.snp.makeConstraints { (make) in
                    make.left.equalTo(line1)
                    make.top.equalTo(personLab.snp.bottom)
                    make.height.equalTo(20)
                    make.width.equalTo(btnWid)
                }
                let line = UIView()
                line.backgroundColor = .init(hex: "#CBCCCD")
                self.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.width.equalTo(0.5)
                    make.height.equalTo(21)
                    make.top.equalTo(45)
                    make.right.equalTo(botLab2)
                }
                let learnBtn = UIButton()
                learnBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                    let vc = CoureseLearnNumsVC()
                    if self.type == 1 && self.model != nil{
                        vc.mainView.isStep = true
                        vc.mainView.stepModel = self.model
                        vc.cid = self.model?.id ?? ""
                    }else{
                        vc.cid = self.myModel?.id ?? ""
                    }
                    vc.mainView.setupUI()
                    HQPush(vc: vc, style: .default)
                }
                self.addSubview(learnBtn)
                learnBtn.snp.makeConstraints { make in
                    make.top.left.right.equalTo(personLab)
                    make.bottom.equalTo(botLab2)
                }
            case 2:
                self.addSubview(minLab)
                self.addSubview(botLab3)
                minLab.snp.makeConstraints { (make) in
                    make.left.equalTo(personLab.snp.right)
                    make.top.equalTo(25)
                    make.height.equalTo(33)
                    make.width.equalTo(btnWid)
                }
                botLab3.snp.makeConstraints { (make) in
                    make.left.equalTo(personLab.snp.right)
                    make.top.equalTo(minLab.snp.bottom)
                    make.height.equalTo(20)
                    make.width.equalTo(btnWid)
                }
                let line = UIView()
                line.backgroundColor = .init(hex: "#CBCCCD")
                self.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.width.equalTo(0.5)
                    make.height.equalTo(21)
                    make.top.equalTo(45)
                    make.right.equalTo(botLab3)
                }
            case 3:
                self.addSubview(kllLab)
                self.addSubview(botLab4)
                kllLab.snp.makeConstraints { (make) in
                    make.left.equalTo(minLab.snp.right)
                    make.top.equalTo(25)
                    make.height.equalTo(33)
                    make.width.equalTo(btnWid)
                }
                botLab4.snp.makeConstraints { (make) in
                    make.left.equalTo(minLab.snp.right)
                    make.top.equalTo(kllLab.snp.bottom)
                    make.height.equalTo(20)
                    make.width.equalTo(btnWid)
                }
                let line = UIView()
                line.backgroundColor = .init(hex: "#CBCCCD")
                self.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.width.equalTo(0.5)
                    make.height.equalTo(21)
                    make.top.equalTo(45)
                    make.right.equalTo(botLab4)
                }
            default:
                break
            }
            
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
