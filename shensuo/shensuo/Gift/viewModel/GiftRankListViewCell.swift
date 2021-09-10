//
//  GiftRankListViewCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/29.
//

import UIKit

class GiftRankListViewCell: UITableViewCell {
    var model : GiftUserModel? = nil{
        didSet{
            if model != nil{
                headImg.kf.setImage(with: URL.init(string: (model?.headImage)!),placeholder: UIImage.init(named: "user_normal_icon"))
                nameLab.text = model?.name
                let num = Double(model!.points ?? 0)
                if num > 10000 {
                    numLab.text = "\(num / 10000.0)万"
                }else{
                    numLab.text = "\(num)"
                }
                
                self.enterBtn.isHidden = !needSend
                self.enterBtnBg.isHidden = !needSend
                
            }
        }
    }
    let cellBg = UIView()
    let whiteBg = UIView()
    let rankLab = UILabel.initSomeThing(title: "4", titleColor: .init(hex: "#999999"), font: .MediumFont(size: 18), ali: .left)
    let headImg = UIImageView.initWithName(imgName: "user_normal_icon")
    let nameLab = UILabel.initSomeThing(title: "虚位以待", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 15), ali: .left)
    let meiIcon = UIImageView.initWithName(imgName: "meibi_icon")
    let numLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 12), ali: .left)
    
    let enterBtn = UIButton.initTitle(title: "回 礼", font: .MediumFont(size: 12), titleColor: .init(hex: "#FD8024"), bgColor: .white)
    let enterBtnBg = UIView()
    
    var needSend = false
    
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
        let headBtn = UIButton()
        whiteBg.addSubview(headBtn)
        headBtn.snp.makeConstraints { make in
            make.edges.equalTo(headImg)
        }
        headBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let cid = self.model?.id ?? ""
            if cid.length != 0{
                GotoTypeVC(type: 99, cid: cid)
            }
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
        enterBtn.isHidden = true
        enterBtnBg.isHidden = true
        
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


class GiftRankListViewBotView: UIView {
    var model : GiftUserModel? = nil{
        didSet{
            if model != nil{
                headImg.kf.setImage(with: URL.init(string: (model?.headImage)!),placeholder: UIImage.init(named: "user_normal_icon"))
                nameLab.text = model?.name
                let num = Double(model!.points ?? 0)
                if num > 10000 {
                    numLab.text = "\(num / 10000.0)万"
                }else{
                    numLab.text = "\(num)"
                }
                let rank = model!.panking ?? 0
                self.rankLab.text = rank != 0 ? "\(rank)" : "--"
            }
        }
    }
    let rankLab = UILabel.initSomeThing(title: "--", titleColor: .init(hex: "#999999"), font: .MediumFont(size: 18), ali: .left)
    let headImg = UIImageView.initWithName(imgName: "user_normal_icon")
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 15), ali: .left)
    let meiIcon = UIImageView.initWithName(imgName: "meibi_icon")
    let numLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 12), ali: .left)
    
    let enterBtn = UIButton.initTitle(title: "送 礼", font: .MediumFont(size: 18), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        
        self.addSubview(rankLab)
        rankLab.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
        
        headImg.layer.cornerRadius = 23
        headImg.layer.masksToBounds = true
        self.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.left.equalTo(60)
            make.width.height.equalTo(46)
            make.centerY.equalToSuperview()
        }
        headImg.kf.setImage(with: URL.init(string: UserInfo.getSharedInstance().headImage ?? ""))
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.left.equalTo(headImg.snp.right).offset(12)
            make.right.equalTo(-120)
            make.top.equalTo(headImg)
        }
        nameLab.text = UserInfo.getSharedInstance().nickName
        
        self.addSubview(meiIcon)
        meiIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(6.5)
        }
        
        self.addSubview(numLab)
        numLab.snp.makeConstraints { make in
            make.top.height.equalTo(meiIcon)
            make.left.equalTo(meiIcon.snp.right).offset(7.5)
            make.right.equalTo(nameLab)
        }
        
        enterBtn.layer.cornerRadius = 18
        enterBtn.layer.masksToBounds = true
        self.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(36)
            make.centerY.equalTo(headImg)
            make.right.equalTo(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
