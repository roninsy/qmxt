//
//  StepMusicBtnView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/19.
//

import UIKit

class StepMusicBtnView: UIView {

    let lockView = UIView()
    
    let mohuImg = UIImageView.initWithName(imgName: "music_buy_mohu")
    
    let lockIcon = UIImageView.initWithName(imgName: "courese_lock_icon")
    
    let lockLab = UILabel.initSomeThing(title: "付费方可查看", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .center)
    
    let progressView = UIProgressView()
    
    let playIcon = UIImageView.initWithName(imgName: "play_gray_icon")
    
    let startTimeLab = UILabel.initSomeThing(title: "0:00", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 12), ali: .left)
    let endTimeLab = UILabel.initSomeThing(title: "0:00", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 12), ali: .right)
    
    var model:CourseStepListModel? = nil{
        didSet{
            self.endTimeLab.text = "\(model?.minutes ?? "0"):00"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        
        progressView.trackTintColor = .init(hex: "#DEDFE0")
        self.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-48)
            make.height.equalTo(2)
            make.centerY.equalToSuperview()
        }
        
        let whiteBtn = UIView()
        whiteBtn.backgroundColor = .white
        whiteBtn.layer.cornerRadius = 5.5
        whiteBtn.layer.masksToBounds = true
        self.addSubview(whiteBtn)
        whiteBtn.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.width.equalTo(11)
            make.height.equalTo(11)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(playIcon)
        playIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(startTimeLab)
        startTimeLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.width.equalTo(100)
            make.left.equalTo(progressView)
            make.top.equalTo(whiteBtn.snp.bottom)
        }
        
        self.addSubview(endTimeLab)
        endTimeLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.width.equalTo(100)
            make.right.equalTo(progressView)
            make.top.equalTo(whiteBtn.snp.bottom)
        }
        
        self.addSubview(lockView)
        lockView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lockView.addSubview(mohuImg)
        mohuImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mohuImg.alpha = 0.88
        
        lockView.addSubview(lockIcon)
        lockIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(6)
        }
        
        lockView.addSubview(lockLab)
        lockLab.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
