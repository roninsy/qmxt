//
//  PlayEndView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/21.
//
///视频播放结束页面

import UIKit

class PlayEndView: UIView {
    var isFinish = false
    
    var isFirstVideo = false
    
    var isEnd = false{
        didSet{
            if self.isEnd {
                var btnNum = 2
                self.topLab.text = isFinish ? "本课程学习完成，越努力越幸运" : "学习完成，您确定要继续下一节学习吗？"
                if isFinish {
                    self.quickBtn.setTitle("复习上一节", for: .normal)
                    self.enterBtn.setTitle("学习完成", for: .normal)
                }else{
                    btnNum += 1
                    self.quickBtn.setTitle("复习上一节", for: .normal)
                    self.enterBtn.setTitle("学习完成", for: .normal)
                    self.nextBtn.isHidden = false
                }
                if isFirstVideo {
                    btnNum -= 1
                    self.quickBtn.isHidden = true
                }
                
                self.enterBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.isFirstVideo ? 0 : btnWid + 16)
                }
                
                self.btnView.snp.updateConstraints { make in
                    make.width.equalTo(btnWid * btnNum + (btnNum - 1) * 16)
                }
            }
        }
    }
    
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "play_white_close"))
    let topLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .systemFont(ofSize: 18), ali: .center)
    let stepList = EndStepListView()
    let quickBtn = UIButton.initTitle(title: "残忍退出", fontSize: 18, titleColor: .init(hex: "#FD8024"))
    let nextBtn = UIButton.initTitle(title: "继续下一节", fontSize: 18, titleColor: .init(hex: "#FD8024"))
    let enterBtn = UIButton.initTitle(title: "继续坚持", fontSize: 18, titleColor: .white)
    let backView = UIView()
    
    let btnView = UIView()
    let btnWid = 156
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backView.backgroundColor = .black
        backView.alpha = 0.8
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(21)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        
        topLab.adjustsFontSizeToFitWidth = true
        self.addSubview(topLab)
        topLab.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(95)
            make.height.equalTo(25)
        }
        
        self.addSubview(btnView)
        btnView.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(btnWid * 2 + 16)
            make.centerX.equalToSuperview()
            make.top.equalTo(244)
        }
        
        self.enterBtn.backgroundColor = .init(hex: "#FD8024")
        self.enterBtn.layer.cornerRadius = 22.5
        self.enterBtn.layer.masksToBounds = true
        btnView.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.width.equalTo(btnWid)
            make.height.equalTo(45)
            make.top.equalToSuperview()
            make.left.equalTo(btnWid + 16)
        }
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        
        btnView.addSubview(quickBtn)
        quickBtn.snp.makeConstraints { make in
            make.width.equalTo(btnWid)
            make.height.equalTo(45)
            make.top.equalToSuperview()
            make.left.equalTo(0)
        }
        quickBtn.setBackgroundImage(.init(named: "line_btn_orange"), for: .normal)
        quickBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        
        btnView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.width.equalTo(btnWid)
            make.height.equalTo(45)
            make.top.equalToSuperview()
            make.right.equalTo(0)
        }
        nextBtn.setBackgroundImage(.init(named: "line_btn_orange"), for: .normal)
        nextBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        nextBtn.isHidden = true
        
        self.addSubview(stepList)
        stepList.snp.makeConstraints { make in
            make.width.equalTo(screenHei / 2)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
            make.top.equalTo(172)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
