//
//  SearchNoDataView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit

class SearchNoDataView: UIView {

    let mainImg = UIImageView.initWithName(imgName: "search_nodata")
    let tipLab = UILabel.initSomeThing(title: "抱歉，没有找到相关信息\n请换个关键字试试~", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(177)
            make.centerX.equalToSuperview()
            make.top.equalTo(28)
        }
        
       
        tipLab.numberOfLines = 0
        self.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(mainImg.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
