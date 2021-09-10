//
//  MyMainViewZeroCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/12.
//

import UIKit

class MyMainViewZeroCell: UICollectionViewCell {

    let bgImg = UIImageView()
    
    let topImg = UIImageView()
    
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .MediumFont(size: 16), ali: .center)
    
    let subtitleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 12), ali: .right)
    
    let rImg = UIImageView.initWithName(imgName: "my_zerocell_r")
    
    ///需要初始化
    var needSetup = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///bgImg：背景图,topImgStr:顶部图，titleStr：主标题，subTitle：子标题
    func setupInfo(bgImgStr:String,topImgStr:String,titleStr:String,subTitle:String){
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(bgImg)
        bgImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.needSetup = false
        self.bgImg.image = UIImage.init(named: bgImgStr)
        self.topImg.image = UIImage.init(named: topImgStr)
        self.contentView.addSubview(topImg)
        topImg.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(subTitle.count > 0 ? 19 : 28)
            make.centerX.equalToSuperview()
        }
        
        titleLab.text = titleStr
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(subTitle.count > 0 ? 55 : 69)
            make.left.right.equalToSuperview()
        }
        
        subtitleLab.text = subTitle
        self.contentView.addSubview(subtitleLab)
        subtitleLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.right.equalTo(-72)
            make.top.equalTo(80)
            make.left.equalToSuperview()
        }
        
        rImg.isHidden = subTitle.count == 0
        self.contentView.addSubview(rImg)
        rImg.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.right.equalTo(-62)
            make.width.equalTo(7)
            make.centerY.equalTo(subtitleLab)
        }
    }
}
