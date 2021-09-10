//
//  GiftTop3Cell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/28.
//

import UIKit

class GiftTop3Cell: UIView {
    var touchBlock : stringBlock? = nil
    
    var model : GiftUserModel? = nil{
        didSet{
            if model != nil{
                headImg.kf.setImage(with: URL.init(string: (model?.headImage)!),placeholder: UIImage.init(named: "user_normal_icon"))
                nameLab.text = model?.name
                let num = Double(model!.points ?? 0)
                if num > 10000 {
                    numLab.text = String.init(format: "%.2f万", num / 10000.0)
                }else{
                    numLab.text = "\(num)"
                }
                meiIcon.isHidden = false
                numLab.isHidden = false
                enterBtn.isHidden = !isSelf
                enterBtnBg.isHidden = !isSelf
            }
        }
    }

    ///排名
    var rankNum = 1{
        didSet{
            if rankNum == 1 {
                self.headBg.backgroundColor = .init(hex: "#FFE68E")
                self.topLogo.image = UIImage.init(named: "rank_top1")
                self.rankLogo.image = UIImage.init(named: "gift_rank_1")
            }
            if rankNum == 2 {
                self.headBg.backgroundColor = .init(hex: "#E2E8F4")
                self.topLogo.image = UIImage.init(named: "rank_top2")
                self.rankLogo.image = UIImage.init(named: "gift_rank_2")
                self.nameLab.snp.updateConstraints { make in
                    make.top.equalTo(93)
                }
            }
            if rankNum == 3 {
                self.headBg.backgroundColor = .init(hex: "#FCDED2")
                self.topLogo.image = UIImage.init(named: "rank_top3")
                self.rankLogo.image = UIImage.init(named: "gift_rank_3")
                self.nameLab.snp.updateConstraints { make in
                    make.top.equalTo(93)
                }
            }
        }
    }
    var isSel = false{
        didSet{
            self.backgroundColor = isSel ? .init(hex: "#FD8024") : .clear
        }
    }
    let bgView = UIView()
    let topLogo = UIImageView.initWithName(imgName: "rank_top1")
    let headBg = UIView()
    let headImg = UIImageView.initWithName(imgName: "gift_top3_normal")
    
    let rankLogo = UIImageView.initWithName(imgName: "gift_rank_1")
    
    let nameLab = UILabel.initSomeThing(title: "虚位以待", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 15), ali: .center)
    let meiIcon = UIImageView.initWithName(imgName: "meibi_icon")
    let numLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 12), ali: .left)
    
    let enterBtn = UIButton.initTitle(title: "回 礼", font: .MediumFont(size: 12), titleColor: .init(hex: "#FD8024"), bgColor: .white)
    let enterBtnBg = UIView()
    
    var isSelf = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.top.equalTo(2)
            make.right.bottom.equalTo(-2)
        }
        
        bgView.addSubview(topLogo)
        topLogo.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(73)
            make.right.top.equalToSuperview()
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(103)
            make.left.right.equalToSuperview()
        }
        
        headBg.layer.cornerRadius = 30
        headBg.layer.masksToBounds = true
        headBg.backgroundColor = .init(hex: "#FFE68E")
        bgView.addSubview(headBg)
        headBg.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.equalTo(nameLab.snp.top).offset(-14)
            make.centerX.equalToSuperview()
        }
        
        bgView.addSubview(rankLogo)
        rankLogo.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(16)
            make.centerX.equalTo(headBg)
            make.bottom.equalTo(headBg.snp.top).offset(1)
        }
        
        headImg.layer.cornerRadius = 28
        headImg.layer.masksToBounds = true
        bgView.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.center.equalTo(headBg)
        }
        
        let headBtn = UIButton()
        bgView.addSubview(headBtn)
        headBtn.snp.makeConstraints { make in
            make.edges.equalTo(headImg)
        }
        headBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let cid = self.model?.id ?? ""
            if cid.length != 0{
                GotoTypeVC(type: 99, cid: cid)
            }
        }
        
        bgView.addSubview(meiIcon)
        meiIcon.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.top.equalTo(nameLab.snp.bottom).offset(8.5)
            make.left.equalTo(27)
        }
        
        bgView.addSubview(numLab)
        numLab.snp.makeConstraints { make in
            make.height.equalTo(11)
            make.centerY.equalTo(meiIcon)
            make.left.equalTo(meiIcon.snp.right).offset(8)
            make.right.equalTo(-5)
        }
        
        meiIcon.isHidden = true
        numLab.isHidden = true
        
        enterBtnBg.layer.cornerRadius = 12
        enterBtnBg.layer.masksToBounds = true
        enterBtnBg.backgroundColor = .init(hex: "#FD8024")
        
        bgView.addSubview(enterBtnBg)
        enterBtnBg.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(68)
            make.centerX.equalToSuperview()
            make.top.equalTo(numLab.snp.bottom).offset(17)
        }
        
        enterBtn.layer.cornerRadius = 11
        enterBtn.layer.masksToBounds = true
        bgView.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(66)
            make.center.equalTo(enterBtnBg)
        }
        enterBtn.isHidden = true
        enterBtnBg.isHidden = true
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            ///显示发送礼物界面
            let giftView = GiftListView()
            giftView.uid = self.model?.id ?? "-1"
            giftView.type = 8
            // 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节 8：个人收礼
            ///上报事件
            HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":"个人主页礼物间",
                                                              "content_id":""])
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isSel = !isSel
//        let y = touches.first!.location(in: nil).y
//        let mid = model?.id ?? "0"
//        self.touchBlock?("\(mid)-\(touches.first!.location(in: nil).x)-\(y)")
    }
    
}
