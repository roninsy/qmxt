//
//  CourseTitleView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/18.
//

import UIKit

class CourseTitleView: UIView {
    
    let back = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    let moreBtn = UIButton.initImgv(imgv: .initWithName(imgName: "more_black"))
    let botLine = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(back)
        back.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalTo(-8)
            make.left.equalTo(4)
        }
        back.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.width.equalTo(screenWid / 2)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.bottom.equalTo(-8)
        }
        
        self.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.right.equalTo(-6)
            make.height.equalTo(24)
            make.bottom.equalTo(-8)
        }
        
        
        
        self.addSubview(botLine)
        botLine.backgroundColor = .init(hex: "#E6E6E6")
        botLine.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
