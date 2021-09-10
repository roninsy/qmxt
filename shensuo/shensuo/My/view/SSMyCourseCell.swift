//
//  SSMyCourseCell.swift
//  shensuo
//
//  Created by  yang on 2021/7/6.
//

import UIKit

class SSMyCourseCell: UITableViewCell {
    
    var isCollection = false
    
    var courseModel: CourseDetalisModel? = nil {
        didSet {
            if courseModel != nil {
                iconV.kf.setImage(with: URL(string: courseModel?.picUrl ?? ""), placeholder: UIImage.init(named: "user_normal_icon"))
                headerImageV.kf.setImage(with: URL(string: courseModel?.headerImage ?? ""), placeholder: UIImage.init(named: "big_normal_v"))
                detailsL.text = courseModel?.new == true ? "     \(courseModel?.title ?? "")" : courseModel?.title
                isNewV.isHidden = courseModel?.new == true ? false : true
                introduceL.text = courseModel?.introduce
                if courseModel?.createdTime == "" {
                    
                    joinRemarkL.text = ""
                }else{
                    joinRemarkL.text = "\(courseModel?.createdTime?.subString(to: 10) ?? "")\(isCollection ? "收藏" : (courseModel?.paymentType ==  "免费" ? "加入" : "购买") )"
                }
                nickNameL.text = "\(courseModel?.nickName ?? "")导师"
                finishStepL.text = "已学\(courseModel?.finishStep ?? "")/\(courseModel?.totalStep ?? 0)节"
                
                priceL.text = "\(courseModel?.price ?? 0)贝"
                self.priceL.snp.updateConstraints { make in
                    make.width.equalTo(self.priceL.sizeThatFits(.init(width: 120, height: 20)).width)
                }
                totalL.text = courseModel?.type == 1 ? "共\(courseModel?.totalDays ?? 0)天" : "共\(courseModel?.totalStep ?? 0)节"
                
                if courseModel?.paymentType ==  "免费" {
                        self.priceL.snp.updateConstraints { make in
                            make.width.equalTo(0)
                        }
                        if courseModel?.type == 0 {
                            
                            
                            courseTypeV.image = UIImage.init(named: "free_course")
                        }else{
                            courseTypeV.image = UIImage.init(named: "free_programme")
                            
                        }
                }else if courseModel?.vipFree == true {
                    
                    courseTypeV.image = UIImage.init(named: "vip_free")
                    
                }else{
                    if courseModel?.type == 0 {
                        
                        
                        courseTypeV.image = UIImage.init(named: "pay_course")
                    }else{
                        courseTypeV.image = UIImage.init(named: "pay_programme")
                        
                    }
                }
                //                courseTypeV.image = 
            }
        }
    }
    var headerImageV: UIImageView = UIImageView.initWithName(imgName: "big_normal_v")
    var detailsL: UILabel! = UILabel.initSomeThing(title: "      唤醒女人柔软天性，零基础修气质雅姿", fontSize: 16, titleColor: color33)
    var introduceL: UILabel! = UILabel.initSomeThing(title: "优雅丽人修炼2天班2.0", fontSize: 14, titleColor: color66)
    var joinRemarkL: UILabel! = UILabel.initSomeThing(title: "2020-10-22购买", fontSize: 13, titleColor: color66)
    var iconV: UIImageView! = UIImageView.initWithName(imgName: "user_normal_icon")
    var nickNameL: UILabel! = UILabel.initSomeThing(title: "毛宇琳导师", fontSize: 13, titleColor: color66)
    var isNewV: UIImageView = UIImageView.initWithName(imgName: "new_course")
    var finishStepL: UILabel! = UILabel.initSomeThing(title: "已学20/20节", fontSize: 13, titleColor: color33)
    var priceL: UILabel! = UILabel.initSomeThing(title: "300", fontSize: 15, titleColor: UIColor.hex(hexString: "#EF0B19"))
    var courseTypeV: UIImageView = UIImageView.initWithName(imgName: "user_normal_icon")
    var totalL: UILabel! = UILabel.initSomeThing(title: "共20节", fontSize: 12, titleColor: .white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let topMaginV = UIView.init()
        contentView.addSubview(topMaginV)
        topMaginV.backgroundColor = bgColor
        topMaginV.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(10)
        }
        
        contentView.addSubview(headerImageV)
        headerImageV.contentMode = .scaleToFill
        headerImageV.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.bottom.equalTo(-16)
            make.top.equalTo(topMaginV.snp.bottom).offset(16)
            make.width.equalTo(110)
        }
        headerImageV.layer.cornerRadius = 4
        headerImageV.layer.masksToBounds = true
        headerImageV.addSubview(totalL)
        totalL.textAlignment = .center
        totalL.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.37)
        totalL.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalTo(headerImageV)
            make.height.equalTo(22)
        }
        
        //        HQRoude(view: totalL, cs: [.bottomLeft,.bottomRight], cornerRadius: 4)
        
        contentView.addSubview(detailsL)
        detailsL.font = UIFont.SemiboldFont(size: 16)
        detailsL.numberOfLines = 2
        detailsL.snp.makeConstraints { make in
            
            make.leading.equalTo(headerImageV.snp.trailing).offset(16)
            make.top.equalTo(headerImageV)
            make.trailing.equalTo(-16)
        }
        
        contentView.addSubview(isNewV)
        isNewV.snp.makeConstraints { make in
            
            make.leading.equalTo(headerImageV.snp.trailing).offset(16)
            make.top.equalTo(headerImageV)
        }
        
        contentView.addSubview(introduceL)
        introduceL.snp.makeConstraints { make in
            
            make.leading.trailing.equalTo(detailsL)
            make.top.equalTo(detailsL.snp.bottom).offset(8)
        }
        
        contentView.addSubview(joinRemarkL)
        joinRemarkL.snp.makeConstraints { make in
            
            make.leading.equalTo(detailsL)
            make.top.equalTo(introduceL.snp.bottom).offset(12)
            
        }
        
        contentView.addSubview(finishStepL)
        finishStepL.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.centerY.equalTo(joinRemarkL)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = bgColor
        contentView.addSubview(lineV)
        lineV.snp.makeConstraints { make in
            
            make.leading.trailing.equalTo(detailsL)
            make.height.equalTo(0.5)
            make.top.equalTo(joinRemarkL.snp.bottom).offset(16)
        }
        
        iconV.layer.cornerRadius = 12
        iconV.layer.masksToBounds = true
        contentView.addSubview(iconV)
        iconV.snp.makeConstraints { make in
            make.leading.equalTo(detailsL)
            make.bottom.equalTo(headerImageV)
            make.height.width.equalTo(24)
        }
        
        contentView.addSubview(courseTypeV)
        courseTypeV.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.centerY.equalTo(iconV)
        }
        
        contentView.addSubview(priceL)
        priceL.font = UIFont.MediumFont(size: 15)
        priceL.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.right.equalTo(courseTypeV.snp.left).offset(-6)
            make.centerY.equalTo(iconV)
            make.width.equalTo(10)
        }
        
        contentView.addSubview(nickNameL)
        nickNameL.snp.makeConstraints { make in
            make.right.equalTo(priceL.snp.left).offset(-5)
            make.left.equalTo(iconV.snp.right).offset(5)
            make.centerY.equalTo(iconV)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
