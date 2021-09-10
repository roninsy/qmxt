//
//  ContentIsDelView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/16.
//

import UIKit

class ContentIsDelView: UIView {
    
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    
    let navTitle = UILabel.initSomeThing(title: "内容被删除", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(16 + NavStatusHei)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                self.removeFromSuperview()
            }
        }
        
        self.addSubview(navTitle)
        navTitle.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backBtn)
        }
        
        let line = UIView()
        line.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
            make.top.equalTo(backBtn.snp.bottom).offset(13)
        }
        
        let icon = UIImageView.initWithName(imgName: "no_content_icon")
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(line.snp.bottom).offset(67)
        }
        
        let iconLab = UILabel.initSomeThing(title: "内容已被删除", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .center)
        self.addSubview(iconLab)
        iconLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
            make.top.equalTo(icon.snp.bottom).offset(32)
        }
        
        let botView = UIView()
        botView.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(iconLab.snp.bottom).offset(48)
        }
        
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
