//
//  GiftNotiView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/22.
//

import UIKit

class GiftNotiView: UIView {
    var myWid = screenWid / 3 * 2
    var model:NotificationCenterGiftModel? = nil{
        didSet{
            if model != nil{
                titleLab.text = "\(model!.giverName!)给\(model!.receiverName!)"
                subLab.text = "送\(model!.giftName!)"
                headImg.kf.setImage(with: URL.init(string: model!.giverHeadImage ?? ""))
                giftImg.kf.setImage(with: URL.init(string: model!.giftImage ?? ""))
                numLab.text = "\(model!.giftTimes ?? "0")"
            }
        }
    }
    
    let headBG = UIView()
    let headImg = UIImageView.initWithName(imgName: "user_normal_icon")
    let titleLab = UILabel.initSomeThing(title: "某某给某某", titleColor: .white, font: .systemFont(ofSize: 14), ali: .left)
    let subLab = UILabel.initSomeThing(title: "送鲜花", titleColor: .white, font: .systemFont(ofSize: 12), ali: .left)
    let giftImg = UIImageView.initWithName(imgName: "gift_flower")
    let chengLab = UILabel.initSomeThing(title: "X", titleColor: .init(hex: "#FD8024"), font: .systemFont(ofSize: 18), ali: .center)
    let numLab = UILabel.initSomeThing(title: "1", titleColor: .init(hex: "#FD8024"), font: .systemFont(ofSize: 36), ali: .left)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let mainBg = UIImageView.initWithName(imgName: "gift_nofi")
        self.addSubview(mainBg)
        mainBg.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        headBG.backgroundColor = .white
        headBG.layer.cornerRadius = 15
        headBG.layer.masksToBounds = true
        mainBg.addSubview(headBG)
        headBG.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(5)
        }
        
        headImg.backgroundColor = .white
        headImg.layer.cornerRadius = 14
        headImg.layer.masksToBounds = true
        mainBg.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerY.equalToSuperview()
            make.left.equalTo(6)
        }
        
        mainBg.addSubview(giftImg)
        giftImg.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalTo(-9)
        }
        
        mainBg.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(headBG.snp.right).offset(5.5)
            make.height.equalTo(21)
            make.top.equalTo(0)
            make.right.equalTo(giftImg.snp.left).offset(-5)
        }
        
        mainBg.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.left.right.equalTo(titleLab)
            make.height.equalTo(12)
            make.bottom.equalTo(-5)
        }
        
        self.addSubview(chengLab)
        chengLab.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.left.equalTo(mainBg.snp.right)
            make.bottom.equalTo(-5)
            make.height.equalTo(18)
        }
        
        numLab.adjustsFontSizeToFitWidth = true
        self.addSubview(numLab)
        numLab.snp.makeConstraints { make in
            make.width.equalTo(myWid - 230)
            make.left.equalTo(chengLab.snp.right)
            make.bottom.equalTo(chengLab)
            make.height.equalTo(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
