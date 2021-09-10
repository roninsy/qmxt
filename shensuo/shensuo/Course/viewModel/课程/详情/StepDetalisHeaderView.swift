//
//  StepDetalisHeaderView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/19.
//

import UIKit

class StepDetalisHeaderView: UIView {
    var upHeiBlock : intBlock? = nil
    
    ///1 课程 2方案
    var type = 1
    let playView = StepPlayView()
    let giftView = GiftTopView()
    let mainBg = UIView()
    ///状态图标
    let stateIcon = UIImageView.initWithName(imgName: "course_setup_finish")
    let titleLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 18), ali: .left, space: 0)
    let subLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 15), ali: .left, space: 0)
    let setupLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .center, space: 0)
    let stateLab = UILabel.initWordSpace(title: "", titleColor: .white, font: .systemFont(ofSize: 14), ali: .left, space: 0)
    let priceLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#EF0B19"), font: .systemFont(ofSize: 15), ali: .left, space: 0)
    let vipFree = UIImageView.initWithName(imgName:"vip_free")
    let numView = CourseDetalisNumView()
    var myHei : CGFloat = 0
    
    var model : CourseDetalisModel? = nil{
        didSet{
            if model != nil{
                self.giftView.userId = model?.userId ?? "-1"
                if myModel != nil {
                    if model?.free == true {
                        self.priceLab.isHidden = true
                        self.vipFree.image = UIImage.init(named: self.type == 2 ? "project_free" : "kecheng_free")
                        self.vipFree.snp.updateConstraints { make in
                            make.width.equalTo(60)
                        }
                    }else if model!.vipFree == true {
                        ///继续
                        priceLab.isHidden = false
                    }else{
                        ///付费课程
                        self.vipFree.image = UIImage.init(named: self.type == 2 ? "project_pay_icon" : "kecheng_pay_icon")
                        self.vipFree.snp.updateConstraints { make in
                            make.width.equalTo(60)
                        }
                        priceLab.isHidden = false
                    }
                    priceLab.text = String.init(format: "%.2f贝", (model?.price?.doubleValue ?? 0))
                    let wid = priceLab.sizeThatFits(.init(width: 120, height: 20)).width
                    priceLab.snp.updateConstraints { make in
                        make.width.equalTo(wid)
                    }
                    giftView.type = self.type == 1 ? 2 : 7
                    self.giftView.getNetInfo()
                }
            }
        }
    }
    
    var myModel : CourseStepListModel? = nil{
        didSet{
            if myModel != nil {
                self.playView.model = myModel
                self.playView.setupView()
                titleLab.text = myModel?.title
                setupLab.text = String.init(format: "%@/%@", myModel!.step!.stringValue,myModel!.totalStep!.stringValue)
                stateLab.text = myModel!.finished! ? "  已学" : "  待学"
                stateLab.backgroundColor = myModel!.finished! ? .init(hex: "#21D826") : .init(hex: "#7C7C7C")
                stateIcon.image = myModel!.finished! ? UIImage.init(named: "course_setup_finish") : UIImage.init(named: "course_setup_wait")

                numView.model = myModel
                giftView.mainId = myModel!.id!
                giftView.titleText = myModel?.title ?? ""
                giftView.type = self.type == 1 ? 2 : 7
                
                if myModel?.surfacePlot != nil && myModel!.surfacePlot!.count > 10 {
                    playView.vedioImg.kf.setImage(with: URL.init(string: (myModel?.surfacePlot)!))
                }
                playView.htmlStr = myModel?.details
                playView.snp.updateConstraints { make in
                    make.height.equalTo(self.playView.myHei)
                }
                
                self.upMyHei()
            }
            self.model = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        
        mainBg.backgroundColor = .white
        self.addSubview(mainBg)
        mainBg.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
            make.top.equalTo(10)
        }
        
        
        let layerView = UIView()
        // shadowCode
        layerView.layer.shadowColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 0.08).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        layerView.layer.shadowOpacity = 1
        layerView.layer.shadowRadius = 6
        // fill
        layerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        layerView.alpha = 1
        mainBg.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.width.height.equalTo(76)
            make.top.equalTo(31)
            make.left.equalTo(9)
        }
        
        setupLab.adjustsFontSizeToFitWidth = true
        mainBg.addSubview(setupLab)
        setupLab.snp.makeConstraints { make in
            make.left.right.equalTo(layerView)
            make.top.equalTo(layerView)
            make.height.equalTo(46)
        }
        
        stateLab.layer.cornerRadius = 4
        stateLab.layer.masksToBounds = true
        stateLab.backgroundColor = .init(hex: "#21D826")
        layerView.addSubview(stateLab)
        stateLab.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.bottom.equalTo(-4)
            make.height.equalTo(24)
        }
        
        layerView.addSubview(stateIcon)
        stateIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(stateLab)
            make.right.equalTo(-10)
        }
        
        mainBg.addSubview(titleLab)
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(layerView.snp.right).offset(22)
            make.right.equalTo(-10)
            make.top.equalTo(28)
            make.height.equalTo(55)
        }
        
        mainBg.addSubview(vipFree)
        vipFree.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(19)
            make.right.equalTo(-10)
            make.top.equalTo(titleLab.snp.bottom).offset(9)
        }
        
        mainBg.addSubview(priceLab)
        priceLab.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.right.equalTo(vipFree.snp.left).offset(-6)
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.height.equalTo(21)
        }
        
        mainBg.addSubview(numView)
        numView.snp.makeConstraints { (make) in
            make.height.equalTo(103)
            make.left.right.equalToSuperview()
            make.top.equalTo(vipFree.snp.bottom)
        }
        numView.type = 1
        
        playView.webFinishBlock = { [weak self] in
            self?.playView.snp.updateConstraints { make in
                make.height.equalTo(self?.playView.myHei ?? 0)
            }
            self?.upMyHei()
        }
        self.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainBg.snp.bottom).offset(10)
            make.height.equalTo(playView.myHei)
        }
        
        self.addSubview(giftView)
        giftView.snp.makeConstraints { (make) in
            make.top.equalTo(playView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(274)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func upMyHei() -> CGFloat {
        myHei = 220 + 10 + playView.myHei + 10 + 274 + 10 + 10 + 10
        self.upHeiBlock?(Int(myHei))
        return myHei
    }
    
}

