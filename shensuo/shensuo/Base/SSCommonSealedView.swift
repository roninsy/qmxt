//
//  SSCommonSealedView.swift
//  shensuo
//
//  Created by  yang on 2021/7/16.
//

import UIKit

class SSCommonSealedView: UIView {

  
    let leftBtn = UIButton.initBgImage(imgname: "back_black")
    let backBtn = UIButton.initTitle(title: "返回", fontSize: 18, titleColor: color33)
    let tipIcon = UIImageView.initWithName(imgName: "user_delete")
    //标题
    let nameL = UILabel.initSomeThing(title: "账号被删除", fontSize: 17, titleColor: color33)
    let tipesL = UILabel.initSomeThing(title: "账号被永久封号/封号5天/封号15天", fontSize: 16, titleColor: color33)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = bgColor
        
        let topV = UIView.init()
        self.addSubview(topV)
        topV.backgroundColor = .white
        topV.snp.makeConstraints { make in

            make.leading.trailing.equalToSuperview()
            make.height.equalTo(NavBarHeight)
            make.top.equalTo(0)
        }

        topV.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { make in

            make.leading.equalTo(12)
            make.width.height.equalTo(48)
            make.bottom.equalTo(0)
        }

        topV.addSubview(nameL)
        nameL.font = UIFont.SemiboldFont(size: 18)
        nameL.snp.makeConstraints { make in

            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftBtn)
        }
        
        let centerBgV = UIView.init()
        addSubview(centerBgV)
        centerBgV.backgroundColor = .white
        centerBgV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topV.snp.bottom).offset(12)
            make.height.equalTo(422)
        }
        centerBgV.addSubview(tipIcon)
        tipIcon.snp.makeConstraints { make in
            
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(180)
            make.width.equalTo(310)
        }
        
        tipesL.font = .SemiboldFont(size: 18)
        tipesL.textAlignment = .center
        centerBgV.addSubview(tipesL)
        tipesL.numberOfLines = 0
        tipesL.snp.makeConstraints({ make in
            
            make.top.equalTo(tipIcon.snp.bottom).offset(24)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            
            
        })
        
        
        centerBgV.addSubview(backBtn)
        backBtn.layer.cornerRadius = 22.5
        backBtn.layer.masksToBounds = true
        backBtn.backgroundColor = .white
        backBtn.layer.borderWidth = 0.5
        backBtn.layer.borderColor = bgColor.cgColor
        backBtn.snp.makeConstraints { make in
            
            make.height.equalTo(45)
            make.width.equalTo(300)
            make.top.equalTo(tipesL.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
