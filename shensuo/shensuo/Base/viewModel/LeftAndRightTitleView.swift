//
//  LeftAndRightTitleView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/17.
//

import UIKit

class LeftAndRightTitleView: UIView {
    var selBlock : voidBlock? = nil
    
    var hasRightIcon = true{
        didSet{
            if hasRightIcon == false {
                rightIcon.isHidden = true
                rightTitle.snp.updateConstraints { make in
                    make.right.equalTo(-16)
                }
            }else{
                rightIcon.isHidden = false
                rightTitle.snp.updateConstraints { make in
                    make.right.equalTo(-33)
                }
            }
        }
    }
    
    let leftTitle = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#878889"), font: .systemFont(ofSize: 16), ali: .left)
    let rightTitle = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .right)
    let rightIcon = UIImageView.initWithName(imgName: "right_black_nobg")
    let botLine = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(leftTitle)
        leftTitle.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.bottom.equalTo(0)
            make.width.equalTo(100)
        }
        
        self.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        self.addSubview(rightTitle)
        rightTitle.snp.makeConstraints { make in
            make.right.equalTo(-33)
            make.top.bottom.equalTo(0)
            make.left.equalTo(100)
        }
        
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selBlock?()
    }
}
