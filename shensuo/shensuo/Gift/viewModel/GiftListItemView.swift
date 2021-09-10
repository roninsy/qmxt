//
//  GiftListItemView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/25.
//

import UIKit

class GiftListItemView: UICollectionViewCell {
    
    var sendBlock:voidBlock? = nil
    var sel : Bool = false{
        didSet{
            if sel{
                self.backgroundColor = .init(hex: "#39363b")
                self.sendBtn.isHidden = false
                self.priceLab2.isHidden = false
                self.nameLab.isHidden = true
                self.priceLab.isHidden = true
                self.giftImgV.snp.updateConstraints { make in
                    make.width.height.equalTo(66)
                }
            }else{
                self.backgroundColor = .clear
                self.sendBtn.isHidden = true
                self.priceLab2.isHidden = true
                self.nameLab.isHidden = false
                self.priceLab.isHidden = false
                self.giftImgV.snp.updateConstraints { make in
                    make.width.height.equalTo(60)
                }
            }
        }
    }
    
    var model : GiftModel? = nil{
        didSet{
            if model != nil{
                giftImgV.kf.setImage(with: URL.init(string: model!.image ?? ""),placeholder: UIImage.init(named: "gift_flower"))
                self.nameLab.text = model?.name
                self.priceLab.text = "\(model!.points!)美币"
                self.priceLab2.text = "\(model!.points!)美币"
            }
        }
    }
    let giftImgV = UIImageView.initWithName(imgName: "gift_flower")
    let sendBtn = UIButton.initTitle(title: "赠送", font: .systemFont(ofSize: 14), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    let nameLab = UILabel.initSomeThing(title: "鲜花", titleColor: .white, font: .MediumFont(size: 15), ali: .center)
    let priceLab = UILabel.initSomeThing(title: "100美币", titleColor: .white, font: .MediumFont(size: 10), ali: .center)
    
    let priceLab2 = UILabel.initSomeThing(title: "100美币", titleColor: .white, font: .MediumFont(size: 10), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        self.addSubview(giftImgV)
        giftImgV.snp.makeConstraints { make in
            make.bottom.equalTo(-54)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-29)
            make.height.equalTo(15)
        }
        self.addSubview(priceLab)
        priceLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
            make.height.equalTo(10)
        }
        
        self.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        sendBtn.isHidden = true
        sendBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.sendBlock?()
        }
        
        self.addSubview(priceLab2)
        priceLab2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(giftImgV.snp.bottom)
            make.bottom.equalTo(-30)
        }
        sendBtn.isHidden = true
        priceLab2.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

class GiftSendedListItemView: UICollectionViewCell {
    
    var model : GiftUserModel? = nil{
        didSet{
            if model != nil{
                giftImgV.kf.setImage(with: URL.init(string: model!.image!)!,placeholder: UIImage.init(named: "gift_flower"))
                self.nameLab.text = "\(model?.name ?? "")X\(model!.total ?? 0)"
            }
        }
    }
    let giftImgV = UIImageView.initWithName(imgName: "gift_flower")
   
    let nameLab = UILabel.initSomeThing(title: "鲜花X100", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 12), ali: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(giftImgV)
        giftImgV.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(giftImgV.snp.bottom).offset(9)
            make.height.equalTo(12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
