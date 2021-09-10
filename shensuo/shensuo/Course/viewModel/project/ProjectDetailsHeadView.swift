//
//  ProjectDetailsHeadView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/1.
//
import UIKit

class ProjectDetailsHeadView: UIView {
    let newImg = UIImageView.initWithName(imgName: "new_course")
    let giftView = GiftTopView()
    let topImg = UIView()
    let mainBg = UIView()
    let titleLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 18), ali: .left, space: 0)
    let subLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 15), ali: .left, space: 0)
    let priceLab = UILabel.initWordSpace(title: "", titleColor: .init(hex: "#EF0B19"), font: .systemFont(ofSize: 15), ali: .right, space: 0)
    let vipFree = UIImageView.initWithName(imgName:"vip_free")
    let numView = ProjectDetalisNumView()
    
    let topImgHei = screenWid / 414 * 380 + 70
    var myHei = 0
    
    let daysIcon = UIImageView.initWithName(imgName: "project_day_icon")
    let daysLab = UILabel.initSomeThing(title: "0/0", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    
    var myModel : CourseDetalisModel? = nil{
        didSet{
            if myModel != nil {
                titleLab.text = myModel?.title
                subLab.text = myModel?.introduce
                numView.myModel = myModel
//                teacherView.myModel = myModel
                newImg.isHidden = myModel?.new == false
                giftView.mainId = myModel!.id!
                giftView.userId = myModel!.userId ?? ""
                giftView.titleText = myModel?.title ?? ""
                giftView.type = 6
                giftView.getNetInfo()
                self.daysLab.text = "\(myModel?.finishDays?.intValue ?? 0)/\(myModel?.totalDays?.intValue ?? 0)天"
                if myModel!.free ?? false {
                    self.priceLab.isHidden = true
                    self.vipFree.image = UIImage.init(named: "project_free")
                    self.vipFree.snp.updateConstraints { make in
                        make.width.equalTo(56)
                    }
                }else if myModel!.vipFree! {
                    ///继续
                    priceLab.isHidden = false

                }else{
                    ///付费课程
                    self.vipFree.image = UIImage.init(named: "project_pay_icon")
                    self.vipFree.snp.updateConstraints { make in
                        make.width.equalTo(60)
                    }
                    priceLab.isHidden = false
                }
                priceLab.text = String.init(format: "%.2f贝", (myModel?.price?.doubleValue ?? 0))
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
//            .init(hex: "#F7F8F9")
        self.addSubview(topImg)
        topImg.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(topImgHei)
        }
        
//        let topGray = UIView()
//        topGray.backgroundColor = .black
//        topGray.alpha = 0.3
//        self.addSubview(topGray)
//        topGray.snp.makeConstraints { (make) in
//            make.edges.equalTo(topImg)
//        }
        
        myHei = Int((topImgHei / 380 * 293) + 196 + 12 + 286 + 12) - 25 + 37
        mainBg.frame = CGRect.init(x: 0, y: (topImgHei / 380 * 293), width: screenWid, height: 196 + 57)
        mainBg.backgroundColor = .white
        self.addSubview(mainBg)
        HQRoude(view: mainBg, cs: [.topLeft,.topRight], cornerRadius: 16)
        
        titleLab.numberOfLines = 0
        self.addSubview(titleLab)
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(mainBg).offset(16)
            make.height.equalTo(50)
        }
        
        self.addSubview(newImg)
        newImg.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.equalTo(23)
            make.height.equalTo(16)
            make.top.equalTo(titleLab).offset(17)
        }
        newImg.isHidden = true
        
        self.addSubview(vipFree)
        vipFree.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(19)
            make.right.equalTo(-16)
            make.top.equalTo(titleLab.snp.bottom).offset(9)
        }
        
        self.addSubview(priceLab)
        priceLab.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.right.equalTo(vipFree.snp.left).offset(-6)
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.height.equalTo(21)
        }
        
        self.addSubview(subLab)
        self.subLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(priceLab.snp.left).offset(-6)
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.height.equalTo(21)
        }
        
        let vipLine = UIView()
        vipLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(vipLine)
        vipLine.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(vipFree.snp.bottom).offset(18)
            make.height.equalTo(0.5)
        }
        
        self.addSubview(daysIcon)
        daysIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.top.equalTo(vipLine).offset(14)
            make.left.equalTo(16)
        }
        
        self.addSubview(daysLab)
        daysLab.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(daysIcon.snp.right).offset(2)
            make.width.equalTo(200)
            make.centerY.equalTo(daysIcon)
        }
        
        self.addSubview(numView)
        numView.snp.makeConstraints { (make) in
            make.height.equalTo(103)
            make.left.right.equalToSuperview()
            make.top.equalTo(daysIcon.snp.bottom)
        }
        let numLine = UIView()
        numLine.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(numLine)
        numLine.snp.makeConstraints { (make) in
            make.top.equalTo(numView.snp.bottom).offset(-1)
            make.left.right.equalToSuperview()
            make.height.equalTo(13)
        }
        self.addSubview(giftView)
        giftView.snp.makeConstraints { (make) in
            make.top.equalTo(numView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(249)
            make.bottom.equalTo(-12)
        }
        let giftLine = UIView()
        giftLine.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(giftLine)
        giftLine.snp.makeConstraints { (make) in
            make.top.equalTo(giftView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
//        self.addSubview(teacherView)
//        teacherView.snp.makeConstraints { (make) in
//            make.left.equalTo(0)
//            make.top.equalTo(giftView.snp.bottom).offset(12)
//            make.bottom.equalTo(-12)
//            make.width.equalTo(screenWid)
//        }
//        let teacherLine = UIView()
//        teacherLine.backgroundColor = .init(hex: "#F7F8F9")
//        self.addSubview(teacherLine)
//        teacherLine.snp.makeConstraints { (make) in
//            make.top.equalTo(teacherView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(12)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
