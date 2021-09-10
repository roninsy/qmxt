//
//  CommentHeadView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/29.
//

import UIKit

class CommentHeadView: UIView {

    let titleLab = UILabel.initSomeThing(title: "评论", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 17), ali: .left)

    let viewNum = UILabel.initSomeThing(title: "0", fontSize: 14, titleColor: .init(hex: "#999999"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(16)
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
        }
        
        
        viewNum.textAlignment = .right
        self.addSubview(viewNum)
        viewNum.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.height.equalTo(20)
            make.left.equalTo(200)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
