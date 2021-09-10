//
//  SSBeautiBillDetailCell.swift
//  shensuo
//
//  Created by  yang on 2021/5/8.
//

import UIKit

class SSBeautiBillDetailCell: UITableViewCell {
    
    let bgView = UIView.init()
    let nameLabel = UILabel.initSomeThing(title: "兑换虚拟服务", isBold: true, fontSize: 17, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let pointLabel = UILabel.initSomeThing(title: "+50美币", isBold: false, fontSize: 13, textAlignment: .right, titleColor: .init(hex: "#333333"))
    let line = UIView.init()
    let orderLabel = UILabel.initSomeThing(title: "订单号:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let orderValue = UILabel.initSomeThing(title: "lwmx_00000000000000000001", fontSize: 16, titleColor: .init(hex: "#333333"))
    let serverLabel = UILabel.initSomeThing(title: "服务:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let serverValue = UILabel.initSomeThing(title: "用户[张小飞]送礼[比心]给课程/方案动态/美丽日记/美丽相册[XX标题]/[毛宇琳]", fontSize: 16, titleColor: .init(hex: "#333333"))
    let contentLabel = UILabel.initSomeThing(title: "内容所有:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentValue = UILabel.initSomeThing(title: "认证企业/个人昵称", fontSize: 16, titleColor: .init(hex: "#333333"))
    let timeLabel = UILabel.initSomeThing(title: "时间:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let timeValue = UILabel.initSomeThing(title: "2020-10-01 15:30", fontSize: 16, titleColor: .init(hex: "#333333"))
    
    var iconStr = "美币"
    
    var detailModel : SSBillDetailModel? = nil{
        didSet{
            if detailModel != nil {
                
                var num = NSMutableAttributedString.init()
                nameLabel.text = detailModel?.categoryName
                orderValue.text = detailModel?.id
                serverValue.text = detailModel?.remarks
                contentValue.text = detailModel?.contentOwner ?? " "
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#21D826")]
                let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#EF0B19")]
                let attrs3 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#333333")]
                
                if iconStr == "形体贝" {
                    num = NSMutableAttributedString(string:detailModel!.money.stringValue, attributes:attrs1)
                }else{
                    if detailModel!.points < 0 {
                        num = NSMutableAttributedString(string:String(detailModel!.points), attributes:attrs1)
                    } else {
                        num = NSMutableAttributedString(string:String(format: "+%d", detailModel!.points), attributes:attrs2)
                    }
                }
                
                let mb = NSMutableAttributedString(string:iconStr, attributes:attrs3)

                num.append(mb)
                
                pointLabel.attributedText = num

                timeValue.text = detailModel!.createdTime
                
            }
        }
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(12)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(pointLabel)
        pointLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(-10)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(line)
        line.backgroundColor = .init(hex: "#EEEFF0")
        line.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(screenWid-20)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line.snp.bottom).offset(16)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(orderValue)
        orderValue.numberOfLines = 0
        orderValue.snp.makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp.right)
            make.top.equalTo(orderLabel)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(serverLabel)
        serverLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(orderValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(serverValue)
        serverValue.numberOfLines = 0
        serverValue.snp.makeConstraints { (make) in
            make.left.equalTo(serverLabel.snp.right)
            make.top.equalTo(serverLabel)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(serverValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(contentValue)
        contentValue.numberOfLines = 0
        contentValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel.snp.right)
            make.top.equalTo(contentLabel)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(contentValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(timeValue)
        timeValue.numberOfLines = 0
        timeValue.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right)
            make.top.equalTo(timeLabel)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
