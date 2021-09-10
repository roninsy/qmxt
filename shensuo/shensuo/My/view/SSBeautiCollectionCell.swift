//
//  SSBeautiCollectionCell.swift
//  shensuo
//
//  Created by  yang on 2021/5/5.
//

import UIKit

class SSBeautiCollectionCell: UICollectionViewCell {
    
    var cardImageView:UIImageView = {
        let card = UIImageView.init()
        card.image = UIImage.init(named: "bt_qbg")
        return card
    }()
    
    var iconV = UIImageView.initWithName(imgName: "bt_qbg")
    
    
    var boxModel:SSBillBoxModel? = nil{
        didSet{
            if boxModel != nil {
                iconV.kf.setImage(with: URL.init(string: boxModel?.image ?? ""), placeholder: UIImage.init(named: "bt_qbg"), options: nil, completionHandler: nil)
                intorduce.text = "\(boxModel?.name ?? "")"
                billPrice.text = String(format: "%.0f美币", boxModel!.needPoints!)
            }
        }
    }
    
    /*
    var boxModel:SSBillBoxModel? = nil{
        didSet{
            if boxModel != nil {
                
                cardImageView.kf.setImage(with: URL.init(string: boxModel?.image ?? ""), placeholder: UIImage.init(named: "bt_qbg"), options: nil, completionHandler: nil)
                intorduce.text = boxModel?.name
                billPrice.text = String(format: "%d美币", boxModel!.needPoints!)
                
                
                if boxModel?.type == 1 {
                    freeImage.isHidden = true
                    cardName.text = "抵扣券"
                    price.text = String(format: "%d元", boxModel!.worth!)
                    if boxModel?.frequency == 1 {
                        intorduce.text = String(format: "%d元抵扣券(每天限领1次)", boxModel!.worth!)
                    } else {
                        intorduce.text = String(format: "%d元抵扣券", boxModel!.worth!)
                    }
                } else if boxModel?.type == 2 {
                    freeImage.isHidden = true
                    if boxModel?.useCondition == 1 {
                        cardName.text = String(format: "%d折券", boxModel!.discount!)
                        price.text = String(format: "%d元内可用", boxModel!.payMore!)
                        intorduce.text = String(format: "%d折券(%d元内可用)", boxModel!.discount!, boxModel!.payMore!)
                    } else if boxModel?.useCondition == 2 {
                        cardImageView.image = UIImage.init(named: "bt_kabg")
                        cardName.text = "会员券"
                        price.text = boxModel?.name
                        intorduce.text = String(format: "%@使用券", boxModel!.name!)
                    } else if boxModel?.useCondition == 3 {
                        cardName.text = String(format: "%d折券", boxModel!.discount!)
                        price.text = String(format: "大于%d元可用", boxModel!.payMore!)
                        intorduce.text = String(format: "%d折券(大于%d元可用)", boxModel!.discount!, boxModel!.payMore!)
                    } else {
                        cardName.text = String(format: "%d折券", boxModel!.discount!)
                        price.text = "无限制"
                        intorduce.text = "无限制"
                    }

                } else {
                    if boxModel?.useCondition == 1 {
                        cardName.text = String(format: "%d折券", boxModel!.discount!)
                        price.text = String(format: "%d元内可用", boxModel!.payMore!)
                        intorduce.text = String(format: "%d折券(%d元内可用)", boxModel!.discount!, boxModel!.payMore!)
                    } else if boxModel?.useCondition == 2 {
                        cardImageView.image = UIImage.init(named: "bt_kabg")
                        cardName.text = "会员券"
                        price.text = boxModel?.name
                        intorduce.text = String(format: "%@使用券", boxModel!.name!)
                    } else if boxModel?.useCondition == 3 {
                        cardName.text = String(format: "%d折券", boxModel!.discount!)
                        price.text = String(format: "大于%d元可用", boxModel!.payMore!)
                        intorduce.text = String(format: "%d折券(大于%d元可用)", boxModel!.discount!, boxModel!.payMore!)
                    } else {
                        cardName.text = String(format: "%d折券", boxModel!.discount!)
                        price.text = "无限制"
                        intorduce.text = "无限制"
                    }
//                    cardName.text = "免费券"
//                    freeImage.isHidden = false
//                    price.text = String(format: "%d元内可用", boxModel!.payMore!)
//                    intorduce.text = String(format: "免费券(%d元内可用)", boxModel!.payMore!)
                }

                billPrice.text = String(format: "%d美币", boxModel!.needPoints!)
            }
        }
    }*/
    
    
    let cardName = UILabel.initSomeThing(title: "抵扣券", fontSize: 14, titleColor: .init(hex: "#FFFFFF"))
    let price = UILabel.initSomeThing(title: "1元", fontSize: 16, titleColor: .init(hex: "#FFFFFF"))
    let intorduce = UILabel.initSomeThing(title: "1元抵扣券（每天限领1次）", fontSize: 14, titleColor: .init(hex: "#333333"))
    let billPrice = UILabel.initSomeThing(title: "100美币", fontSize: 18, titleColor: .init(hex: "#EF0B19"))
    let freeImage = UIImageView.initWithName(imgName: "bt_free")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        
        buildUI()
    }
    
    func buildUI() -> Void {
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo((screenWid/2-15)/193*148)
        }
        
//        addSubview(iconV)
//        iconV.snp.makeConstraints { make in
//
//            make.leading.equalTo(cardImageView).offset(14)
//            make.trailing.equalTo(cardImageView).offset(-14)
//            make.height.equalTo(93)
//            make.centerX.equalTo(cardImageView)
//        }
        
//        cardImageView.addSubview(cardName)
//        cardName.snp.makeConstraints { (make) in
//            make.left.equalTo(33)
//            make.top.equalTo(40)
//            make.height.equalTo(20)
//            make.right.equalToSuperview().offset(-20)
//        }
        
//        cardImageView.addSubview(freeImage)
//        freeImage.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-32)
//            make.width.height.equalTo(24)
//            make.centerY.equalTo(cardName)
//        }
        
//        cardImageView.addSubview(price)
//        price.textAlignment = .right
//        price.snp.makeConstraints { (make) in
//            make.top.equalTo(88)
//            make.height.equalTo(22)
//            make.right.equalToSuperview().offset(-40)
//            make.left.equalToSuperview().offset(30)
//        }
        
        addSubview(intorduce)
        intorduce.numberOfLines = 2
        intorduce.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(cardImageView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(billPrice)
        billPrice.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(intorduce.snp.bottom).offset(8)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
