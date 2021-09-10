//
//  SSPersonPersongGiftRankTop3Cell.swift
//  shensuo
//
//  Created by  yang on 2021/6/29.
//

import UIKit

class SSPersonPersongGiftRankTop3Cell: UITableViewCell {

    var userId = ""{
        didSet{
            topCellArr[0].isSelf = userId == UserInfo.getSharedInstance().userId
            topCellArr[2].isSelf = userId == UserInfo.getSharedInstance().userId
            topCellArr[1].isSelf = userId == UserInfo.getSharedInstance().userId
        }
        
    }
    let topCellArr = [GiftTop3Cell(),GiftTop3Cell(),GiftTop3Cell()]
    let topCellWid = 120.0
    var giftArr: [GiftUserModel]? = nil {
        
        didSet{
            
            if giftArr == nil {
                
                return
            }
            for index in 0..<(giftArr!.count > 3 ? 3 : giftArr!.count) {
                
                topCellArr[index].model = giftArr![index]
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellSpace = (Double(screenWid) - topCellWid * 3) / 54.0
        
       
        topCellArr[1].rankNum = 2
        contentView.addSubview(topCellArr[1])
        topCellArr[1].snp.makeConstraints { make in
            make.bottom.equalTo(-12)
            make.width.equalTo(topCellWid)
            make.left.equalTo(cellSpace * 20)
            make.height.equalTo(190)
        }
        
        topCellArr[1].touchBlock = { str in
            let arr = str.split(separator: "-")
            let uid = String(arr[0])
            let x = Double(arr[1]) ?? 0
            let y = Double(arr[2]) ?? 0
            self.getUserStand(uid: uid,x: x,y: y)
        }
        

        topCellArr[0].rankNum = 1
        contentView.addSubview(topCellArr[0])
        topCellArr[0].snp.makeConstraints { make in
            make.bottom.equalTo(-12)
            make.width.equalTo(topCellWid)
            make.left.equalTo(topCellArr[1].snp.right).offset(cellSpace * 7)
            make.height.equalTo(200)
        }
        topCellArr[0].touchBlock = { str in
            let arr = str.split(separator: "-")
            let uid = String(arr[0])
            let x = Double(arr[1]) ?? 0
            let y = Double(arr[2]) ?? 0
            self.getUserStand(uid: uid,x: x,y: y)
        }
        
        topCellArr[2].rankNum = 3
        contentView.addSubview(topCellArr[2])
        topCellArr[2].snp.makeConstraints { make in
            make.bottom.equalTo(-12)
            make.width.equalTo(topCellWid)
            make.left.equalTo(topCellArr[0].snp.right).offset(cellSpace * 7)
            make.height.equalTo(190)
        }
        topCellArr[2].touchBlock = { str in
            let arr = str.split(separator: "-")
            let uid = String(arr[0])
            let x = Double(arr[1]) ?? 0
            let y = Double(arr[2]) ?? 0
            self.getUserStand(uid: uid,x: x,y: y)
        }
        
    }
    
    ///获取个人礼物
    func getUserStand(uid:String,x:Double,y:Double) {
//        let sendedView = GiftSendedListView()
//        sendedView.uid = uid
//        sendedView.sid = mainId
//        sendedView.sanJiaoX = x
//        sendedView.getNetInfo()
//        self.addSubview(sendedView)
//        sendedView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(225)
//            make.top.equalTo(y)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SSPersonPersongGiftRankListCell: UITableViewCell {
    
    var model : GiftUserModel? = nil{
        didSet{
            if model != nil{
                headImg.kf.setImage(with: URL.init(string: (model?.headImage)!),placeholder: UIImage.init(named: "gift_user"))
                nameLab.text = model?.name
                let num = Double(model!.points ?? 0)
                if num > 10000 {
                    numLab.text = "\(num / 10000.0)万"
                }else{
                    numLab.text = "\(num)"
                }

            }
        }
    }
    let cellBg = UIView()
    let whiteBg = UIView()
    let rankLab = UILabel.initSomeThing(title: "4", titleColor: .init(hex: "#999999"), font: .MediumFont(size: 18), ali: .left)
    let headImg = UIImageView.initWithName(imgName: "gift_user")
    let nameLab = UILabel.initSomeThing(title: "虚位以待", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 15), ali: .left)
    let meiIcon = UIImageView.initWithName(imgName: "meibi_icon")
    let numLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 12), ali: .left)
    
    let enterBtn = UIButton.initTitle(title: "回 礼", font: .MediumFont(size: 12), titleColor: .init(hex: "#FD8024"), bgColor: .white)
    let enterBtnBg = UIView()
    
    var needSend = true{
        didSet{
            self.enterBtn.isHidden = !needSend
            self.enterBtnBg.isHidden = !needSend
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        cellBg.backgroundColor = .clear
        cellBg.layer.cornerRadius = 8
        cellBg.layer.masksToBounds = true
        self.contentView.addSubview(cellBg)
        cellBg.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-4)
            make.top.equalTo(0)
        }
        
        whiteBg.layer.cornerRadius = 8
        whiteBg.layer.masksToBounds = true
        whiteBg.backgroundColor = .white
        self.contentView.addSubview(whiteBg)
        whiteBg.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-5)
            make.top.equalTo(1)
        }
        
        whiteBg.addSubview(rankLab)
        rankLab.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
        
        headImg.layer.cornerRadius = 23
        headImg.layer.masksToBounds = true
        whiteBg.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.left.equalTo(46)
            make.width.height.equalTo(46)
            make.centerY.equalToSuperview()
        }
        
        whiteBg.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.left.equalTo(headImg.snp.right).offset(12)
            make.right.equalTo(-80)
            make.top.equalTo(18.5)
        }
        
        whiteBg.addSubview(meiIcon)
        meiIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(nameLab)
            make.bottom.equalTo(-16.5)
        }
        
        whiteBg.addSubview(numLab)
        numLab.snp.makeConstraints { make in
            make.top.height.equalTo(meiIcon)
            make.left.equalTo(meiIcon.snp.right).offset(7.5)
            make.right.equalTo(nameLab)
        }
        
        enterBtnBg.layer.cornerRadius = 12
        enterBtnBg.layer.masksToBounds = true
        enterBtnBg.backgroundColor = .init(hex: "#FD8024")
        whiteBg.addSubview(enterBtnBg)
        enterBtnBg.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        
        enterBtn.layer.cornerRadius = 11
        enterBtn.layer.masksToBounds = true
        whiteBg.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.width.equalTo(66)
            make.height.equalTo(22)
            make.center.equalTo(enterBtnBg)
        }
        
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            ///上报事件
            HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":"个人主页礼物间",
                                                              "content_id":""])
            ///显示发送礼物界面
            let giftView = GiftListView()
            giftView.uid = self.model?.id ?? "-1"
            giftView.type = 8
            giftView.sendGiftBlock = {
                
            }
            HQGetTopVC()?.view.addSubview(giftView)
            giftView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
