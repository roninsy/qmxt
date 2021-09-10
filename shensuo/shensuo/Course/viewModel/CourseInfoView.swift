//
//  KeChengInfoView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/1.
//

import UIKit
import BSText

class CourseInfoView: UIView {
    var model : PersonageListModel? = nil{
        didSet{
            if model != nil{
                self.bgImg.snp.updateConstraints { (make) in
                    make.height.equalTo(model!.imgHei)
                }
                let imgUrl = model!.headerImage ?? ""
                bgImg.kf.setImage(with: URL.init(string: imgUrl),placeholder: UIImage.init(named: "big_normal_v"))
                headImg.kf.setImage(with: URL.init(string: model!.userHeaderImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                titleLab.text = model?.title
                titleLab.snp.updateConstraints { make in
                    make.height.equalTo(model!.titleHei)
                }
                nameLab.text = model?.nickName
                if model?.free ?? false {
                    priceLab.text = model?.genre == 1 ? "免费课程" : "免费方案"
                    priceLab.backgroundColor = .init(hex: "#FFE7E7")
                    priceLab.textColor = .init(hex: "#FF6161")
                    freeImg.isHidden = true
                }else if model?.vipFree ?? false{
                    priceLab.backgroundColor = .init(hex: "#F5EDE3")
                    priceLab.textColor = .init(hex: "#FD8024")
                    priceLab.text = "  免费"
                    freeImg.isHidden = false
                }else{
                    priceLab.backgroundColor = .init(hex: "#FF6161")
                    priceLab.textColor = .white
                    priceLab.text = model?.genre == 1 ? "付费课程" : "付费方案"
                    freeImg.isHidden = true
                }

                giftNumLab.text = getNumString(num: model?.giftTimes?.toDouble ?? 0)
                giftNumLab.snp.updateConstraints { make in
                    make.width.equalTo(giftNumLab.sizeThatFits(.init(width: 80, height: 15)).width)
                }
                
                let isKeCheng = (model!.genre == 1 || model!.genre == 6)
                self.botBg.isHidden = !isKeCheng
                self.botTitle.isHidden = !isKeCheng
                if isKeCheng {
                    botTitle.text = "\(model?.buyTimes ?? "0")人已学习，共\(model?.genre == 1 ? (model?.totalStep ?? "0") : (model?.totalDays ?? "0"))\(model?.genre == 1 ? "节" : "天")"
                }
                if model?.userType == 2 || model?.userType == 3{
                    self.RImg.isHidden = false
                }else{
                    self.RImg.isHidden = true
                }
                
                readNumLab.text = getNumString(num: model?.viewTimes?.toDouble ?? 0)

                likeNumLab.text = getNumString(num: model?.likeTimes?.toDouble ?? 0)

                newImg.isHidden = model!.newest == false
            }
        }
    }
    
    let newImg = UIImageView.initWithName(imgName: "home_new")
    let myWid = screenWid / 2 - 15
    
    let bgImg = UIImageView.initWithName(imgName: "normal_wid_max")
    let titleLab = BSLabel()
    let headImg = UIImageView.initWithName(imgName: "bottom_fangansel")
    let nameLab = UILabel.initSomeThing(title: "", fontSize: 13, titleColor: .init(hex: "#B4B4B4"))
    let giftNumLab = UILabel.initSomeThing(title: "0", fontSize: 12, titleColor: .init(hex: "#B4B4B4"))
    let giftImg = UIImageView.initWithName(imgName: "gift_play")
    let priceLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#EF0B19"), font: .MediumFont(size: 10), ali: .center)
    let freeImg = UIImageView.initWithName(imgName: "home_vip")
    let RImg = UIImageView.initWithName(imgName: "r_icon")
    let readNumLab = UILabel.initSomeThing(title: "", fontSize: 10, titleColor: .white)
    let likeNumLab = UILabel.initSomeThing(title: "", fontSize: 10, titleColor: .white)
    
    let botBg = UIView()
    let botTitle = UILabel.initSomeThing(title: "", titleColor: .white, font: .systemFont(ofSize: 11), ali: .center)
    
    let imgWid = (screenWid - 34) / 2
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        bgImg.contentMode = .scaleAspectFill
        bgImg.layer.masksToBounds = true
        self.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(imgWid / 3 * 4)
            make.top.equalToSuperview()
        }
        
        self.addSubview(titleLab)
        let line = TextLinePositionSimpleModifier()
        line.fixedLineHeight = 21
        titleLab.text = "\t唤醒女人柔软天性"
        titleLab.linePositionModifier = line
        titleLab.font = .boldSystemFont(ofSize: 15)
        titleLab.textColor = .init(hex: "#333333")
        titleLab.numberOfLines = 0
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(bgImg.snp.bottom).offset(12)
            make.height.equalTo(21)
        }
        
        self.addSubview(newImg)
        newImg.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(15)
            make.left.equalTo(titleLab)
            make.top.equalTo(titleLab).offset(3)
        }
        
        headImg.layer.cornerRadius = 10
        headImg.layer.masksToBounds = true
        self.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.left.equalTo(titleLab)
        }
        
        self.addSubview(RImg)
        RImg.snp.makeConstraints { make in
            make.width.height.equalTo(7)
            make.bottom.equalTo(headImg).offset(2)
            make.right.equalTo(headImg).offset(2)
        }
        
        self.addSubview(giftNumLab)
        giftNumLab.snp.makeConstraints { (make) in
            make.right.equalTo(-11)
            make.height.equalTo(headImg)
            make.top.equalTo(headImg)
            make.width.equalTo(20)
        }
        
        
        self.addSubview(giftImg)
        giftImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.centerY.equalTo(headImg)
            make.right.equalTo(giftNumLab.snp.left).offset(-4)
        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headImg.snp.right).offset(9)
            make.right.equalTo(giftImg.snp.left)
            make.height.equalTo(headImg)
            make.top.equalTo(headImg)
        }
        
        priceLab.layer.cornerRadius = 10
        priceLab.layer.masksToBounds = true
        self.addSubview(priceLab)
        priceLab.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(headImg.snp.bottom).offset(11)
            make.left.equalTo(titleLab)
            make.width.equalTo(60)
        }
        
        self.addSubview(freeImg)
        freeImg.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(11)
            make.left.equalTo(priceLab).offset(12)
            make.centerY.equalTo(priceLab)
        }

        let topBg = UIImageView.initWithName(imgName: "home_cell_tbg")
        self.addSubview(topBg)
        topBg.snp.makeConstraints { make in
            make.width.equalTo(133)
            make.height.equalTo(20)
            make.left.top.equalTo(bgImg)
        }
        
        let readImg = UIImageView.initWithName(imgName: "read_num_white")
        let likeImg = UIImageView.initWithName(imgName: "like_num_white")
        self.addSubview(readImg)
        readImg.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.left.equalTo(5)
            make.centerY.equalTo(topBg)
        }
        
        self.addSubview(readNumLab)
        readNumLab.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(15)
            make.left.equalTo(readImg.snp.right).offset(3)
            make.centerY.equalTo(topBg)
        }
        
        let lineRead = UIView()
        lineRead.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.4)
        self.addSubview(lineRead)
        lineRead.snp.makeConstraints { make in
            make.height.equalTo(7)
            make.width.equalTo(0.5)
            make.centerY.equalTo(topBg)
            make.right.equalTo(readNumLab)
        }
        
        self.addSubview(likeImg)
        likeImg.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.left.equalTo(lineRead).offset(4)
            make.centerY.equalTo(topBg)
        }
        
        self.addSubview(likeNumLab)
        likeNumLab.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(15)
            make.left.equalTo(likeImg.snp.right).offset(3)
            make.centerY.equalTo(topBg)
        }
        
        botBg.backgroundColor = .black
        botBg.alpha = 0.21
        self.addSubview(botBg)
        botBg.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bgImg)
        }
        
        self.addSubview(botTitle)
        botTitle.snp.makeConstraints { make in
            make.edges.equalTo(botBg)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
