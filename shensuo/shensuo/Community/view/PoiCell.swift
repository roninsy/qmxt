//
//  PoiCell.swift
//  Jixue
//
//  Created by 陈鸿庆 on 2020/5/12.
//  Copyright © 2020 yuchen. All rights reserved.
//

import UIKit
import AMapSearchKit

class PoiCell: UITableViewCell {
    var poi : AMapPOI?
    var currentStr: String!
    let title = UILabel.initSomeThing(title: "", fontSize: 16, titleColor: color33)
    
    let subTitle = UILabel.initSomeThing(title: "", fontSize: 12, titleColor: color66)
    let selImg = UIImageView.init(image: UIImage.init(named: "my_btnSelect"))
    
    let dontShow =  UILabel.initSomeThing(title: "不显示位置", fontSize: 16, titleColor: color33)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(selImg)
        
        selImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(26)
            make.right.equalTo(-10)
            make.top.equalTo((62 - 26) / 2)
        }
        
        self.contentView.addSubview(title)
        title.font = UIFont.MediumFont(size: 16)
        
        self.contentView.addSubview(subTitle)
        self.contentView.addSubview(dontShow)
        subTitle.font = UIFont.MediumFont(size: 12)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.equalTo(30)
            make.top.equalTo(10)
            make.right.equalTo(selImg.snp.left).offset(-10)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.height.equalTo(15)
            make.top.equalTo(title.snp.bottom)
            make.right.equalTo(selImg.snp.left).offset(-10)
        }
        dontShow.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.bottom.equalTo(0)
            make.right.equalTo(selImg.snp.left).offset(-10)
        }
        
//        selImg.isHidden = true
        self.selectionStyle = .none
        
        let line = UIView.init()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        line.backgroundColor = bgColor
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool{
        didSet{
//            self.selImg.isHidden = !isSelected
        }
    }
    
}
