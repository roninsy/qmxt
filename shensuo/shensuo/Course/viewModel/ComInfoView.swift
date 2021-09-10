//
//  ComInfoView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/23.
//

import UIKit
//企业信息标签
class ComInfoView: UIView {

    let headImg = UIImageView.initWithName(imgName: "user_normal_icon")
    let RIcon = UIImageView.initWithName(imgName: "r_icon")
    let nameLab = UILabel.initSomeThing(title: "身所", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 17), ali: .left)
    let nameIcon = UIImageView.initWithName(imgName: "my_huiyuan")
    let checkIcon = UIImageView.initWithName(imgName: "check_com")
    let subLab = UILabel.initSomeThing(title: "身所魅力女性修练课堂", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 13), ali: .left)
    
    let rightIcon = UIImageView.initWithName(imgName: "right_black_nobg")
    
    var myModel : CourseDetalisModel? = nil{
        didSet{
            if myModel != nil {
                nameLab.text = myModel?.copyrightName
                nameLab.sizeToFit()
                subLab.text = myModel?.copyrightShow
                checkIcon.isHidden = (subLab.text?.length ?? 0) < 1
                RIcon.isHidden = checkIcon.isHidden
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#FDFAF0")
        self.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(64)
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(RIcon)
        RIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(headImg).offset(-4)
            make.bottom.equalTo(headImg)
        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headImg.snp.right).offset(12)
            make.height.equalTo(24)
            make.top.equalTo(24)
        }
        
        self.addSubview(nameIcon)
        nameIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.left.equalTo(nameLab.snp.right).offset(4)
            make.centerY.equalTo(nameLab)
        }
        
        self.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { (make) in
            make.width.equalTo(63)
            make.height.equalTo(17)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.left.equalTo(nameLab)
        }
        
        self.addSubview(subLab)
        subLab.snp.makeConstraints { (make) in
            make.left.equalTo(checkIcon.snp.right).offset(8)
            make.height.equalTo(18)
            make.right.equalTo(-50)
            make.centerY.equalTo(checkIcon)
        }
        
        self.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
