//
//  UserHeadRoudeView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/22.
//

import UIKit

///用户圆形头像视图
class UserHeadRoudeView: UIView {

    var space = 1
    let headImg = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        headImg.layer.cornerRadius = 11
        headImg.layer.masksToBounds = true
        headImg.image = UIImage.init(named: "user_normal_icon")
        self.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.top.equalTo(space)
            make.left.equalTo(space)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
