//
//  GiftUserView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/23.
//

import UIKit

class GiftUserView: UIView {

    var clickIndex : voidBlock? = nil
    let bgImg = UIImageView()
    let headImg = UIImageView()
    let RIcon = UIImageView.initWithName(imgName: "r_icon")
    let botLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 13), ali: .center)
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.width.height.equalTo(72)
        }
        
        headImg.layer.cornerRadius = 25.5
        headImg.layer.masksToBounds = true
        self.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(51)
            make.center.equalTo(bgImg)
        }
        self.addSubview(RIcon)
        RIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(headImg).offset(-4)
            make.bottom.equalTo(headImg)
        }
        self.addSubview(botLab)
        botLab.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clickIndex?()
    }
}
