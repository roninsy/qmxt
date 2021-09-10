//
//  TeachInfoCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/30.
//

import UIKit

class TeachInfoCell: UITableViewCell {
    let botLine = UIView()
    var myHei : CGFloat = 0
    let topLab = UILabel.initSomeThing(title: "导师简介", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 17), ali: .left)
    
    let midBg = UIView()
    let headImg = UIImageView.initWithName(imgName: "user_normal_icon")
    let RIcon = UIImageView.initWithName(imgName: "r_icon")
    
    let nameLab = UILabel.initSomeThing(title: "毛宇琳导师", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 17), ali: .left)
    
    let VipIcon = UIImageView.initWithName(imgName: "home_vip")
    
    let checkIcon = UIImageView.initWithName(imgName: "check_person_search")
    
    let subLab = UILabel.initSomeThing(title: "国际高级礼仪培训师", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 12), ali: .left)
    
    let detalisLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    
    let companyLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 15), ali: .left)
    
    let linkIcon = UIImageView.initWithName(imgName: "com_link_icon")
    
    let linkBtn = UIButton()
    
    var teacherId = ""
    
    var companyId = ""
    
    var myModel : CourseDetalisModel? = nil{
        didSet{
            if myModel != nil {
                teacherId = self.myModel?.teacherUserId ?? ""
                if myModel?.teacherUserId == nil || (myModel?.teacherUserId?.length ?? 0) < 1{
                    myHei = 16
                    for view in self.contentView.subviews {
                        view.isHidden = true
                    }
                }else{
                    myHei = 173 + 44
                    nameLab.text = myModel?.tutorName
                    let wid = screenWid - 250
                    let nameWid = nameLab.sizeThatFits(.init(width: wid, height: 24)).width
                    nameLab.snp.updateConstraints { make in
                        make.width.equalTo(nameWid > wid ? wid : nameWid)
                    }
                    subLab.text = myModel?.tutorShow
                    headImg.kf.setImage(with: URL.init(string: myModel!.tutorPic ?? ""), placeholder: UIImage.init(named: "user_normal_icon"))
                    
                    RIcon.isHidden = checkIcon.isHidden
                    detalisLab.text = myModel?.tutorIntro
                    if (detalisLab.text?.length ?? 0) > 0{
                        detalisLab.changeLineSpace(space: 13)
                        let detalisHei = detalisLab.sizeThatFits(.init(width: screenWid - 16 * 4, height: 1000)).height
                        self.detalisLab.snp.updateConstraints { make in
                            make.height.equalTo(detalisHei)
                        }
                        myHei += detalisHei
                        midBg.snp.updateConstraints { make in
                            make.height.equalTo(115 + 16 + detalisHei)
                        }
                    }
                }
                if myModel?.copyrightName != nil && myModel?.showCopyright == true {
                    companyLab.text = "所属机构：\(myModel?.copyrightName ?? "")"
                    let wid = companyLab.sizeThatFits(.init(width: screenWid - 82, height: 25))
                    companyLab.snp.updateConstraints { make in
                        make.width.equalTo(wid)
                    }
                    self.companyLab.isHidden = false
                    self.linkIcon.isHidden = false
                    self.linkBtn.isHidden = false
                    myHei += 21 + 16
                }else{
                    self.companyLab.isHidden = true
                    self.linkIcon.isHidden = true
                    self.linkBtn.isHidden = true
                    ///没有所属机构
                }
                botLine.isHidden = false
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(topLab)
        topLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.height.equalTo(24)
            make.top.equalTo(16)
            make.right.equalTo(0)
        }
        
        midBg.layer.cornerRadius = 8
        midBg.layer.masksToBounds = true
        midBg.backgroundColor = .init(hex: "#FAFAFA")
        self.contentView.addSubview(midBg)
        midBg.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.height.equalTo(200)
            make.top.equalTo(topLab.snp.bottom).offset(18)
            make.right.equalTo(-16)
        }
        
        midBg.addSubview(headImg)
        headImg.layer.cornerRadius = 32
        headImg.layer.masksToBounds = true
        headImg.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.height.equalTo(64)
            make.top.equalTo(16)
        }
        
        let headBtn = UIButton()
        midBg.addSubview(headBtn)
        headBtn.snp.makeConstraints { make in
            make.edges.equalTo(headImg)
        }
        headBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.teacherId == ""{
                return
            }
            print("teacherId:\(self.teacherId)")
            GotoTypeVC(type: 99, cid: self.teacherId)
        }
        
        midBg.addSubview(RIcon)
        RIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(headImg).offset(-4)
            make.bottom.equalTo(headImg)
        }
        
        midBg.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.left.equalTo(headImg.snp.right).offset(15)
            make.top.equalTo(27)
            make.width.equalTo(20)
        }
        
        midBg.addSubview(VipIcon)
        VipIcon.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.left.equalTo(nameLab.snp.right).offset(10)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(18)
        }
        
        midBg.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.left.equalTo(VipIcon.snp.right).offset(12)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(72)
        }
        
        midBg.addSubview(subLab)
        subLab.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.top.equalTo(nameLab.snp.bottom).offset(4)
            make.left.equalTo(nameLab)
            make.right.equalTo(-16)
        }
        
        let midLine = UIView()
        midLine.backgroundColor = .init(hex: "#EEEFF0")
        midBg.addSubview(midLine)
        midLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.equalTo(headImg.snp.bottom).offset(19)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        ///说明文本以上高度+以下
        myHei = 173 + 44
        detalisLab.numberOfLines = 0
        midBg.addSubview(detalisLab)
        detalisLab.snp.makeConstraints { (make) in
            make.top.equalTo(midLine.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(20)
        }
        
        midBg.snp.updateConstraints { make in
            make.height.equalTo(115 + 16)
        }
        
        self.contentView.addSubview(companyLab)
        companyLab.snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.height.equalTo(21)
            make.left.equalTo(16)
            make.width.equalTo(100)
        }
        
        self.contentView.addSubview(linkIcon)
        linkIcon.snp.makeConstraints { make in
            make.left.equalTo(companyLab.snp.right).offset(4)
            make.width.height.equalTo(16)
            make.centerY.equalTo(companyLab)
        }
        
        self.contentView.addSubview(linkBtn)
        linkBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(companyLab)
        }
        linkBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            GotoTypeVC(type: 99, cid: self.companyId)
        }
        
        
        botLine.backgroundColor = .init(hex: "#F7F8F9")
        self.contentView.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(12)
        }
        
        self.contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
