//
//  SSOutMoneyCell.swift
//  shensuo
//
//  Created by  yang on 2021/5/18.
//

import UIKit

class SSOutMoneyCell: UITableViewCell {
    
    let bgView = UIView.init()
    let nameLabel = UILabel.initSomeThing(title: "提现申请", isBold: true, fontSize: 17, textAlignment: .left, titleColor: .init(hex: "#333333"))
//    let type = UILabel.initSomeThing(title: "待审核", isBold: false, fontSize: 13, textAlignment: .right, titleColor: .init(hex: "#333333"))
    
    let typeBtn = UIButton.init()
    
    
    let line = UIView.init()
    let orderLabel = UILabel.initSomeThing(title: "订单号:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let orderValue = UILabel.initSomeThing(title: "lwmx_00000000000000000001", fontSize: 16, titleColor: .init(hex: "#333333"))
    let serverLabel = UILabel.initSomeThing(title: "提现账户:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let serverValue = UILabel.initSomeThing(title: "bingo的微信钱包", fontSize: 16, titleColor: .init(hex: "#333333"))
    let contentLabel = UILabel.initSomeThing(title: "提现金额:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentValue = UILabel.initSomeThing(title: "50.00", fontSize: 16, titleColor: .init(hex: "#333333"))
    let timeLabel = UILabel.initSomeThing(title: "申请时间:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let timeValue = UILabel.initSomeThing(title: "2020-10-01 15:30", fontSize: 16, titleColor: .init(hex: "#333333"))
    let checkLabel = UILabel.initSomeThing(title: "审核时间:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let checkValue = UILabel.initSomeThing(title: "2020-10-01 15:30", fontSize: 16, titleColor: .init(hex: "#333333"))
    let noteLabel = UILabel.initSomeThing(title: "审核说明:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let noteValue = UILabel.initSomeThing(title: "涉嫌非法洗钱，不允许提现。", fontSize: 16, titleColor: .init(hex: "#333333"))
    let toReLabel = UILabel.initSomeThing(title: "到账时间:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let toReValue = UILabel.initSomeThing(title: "2020-10-01 15:30", fontSize: 16, titleColor: .init(hex: "#333333"))
    
    var detailModel : SSOutMoneyModel? = nil{
        didSet{
            if detailModel != nil {
                
                if detailModel?.fettle == 0 {
                    typeBtn.setTitle("待审核", for: .normal)
                    typeBtn.setTitleColor(.init(hex: "#333333"), for: .normal)
                    typeBtn.setImage(UIImage.init(named: "bt_shenhe"), for: .normal)
                    checkLabel.removeFromSuperview()
                    checkValue.removeFromSuperview()
                    noteLabel.removeFromSuperview()
                    noteValue.removeFromSuperview()
                    toReLabel.removeFromSuperview()
                    toReValue.removeFromSuperview()
                    
                } else if detailModel?.fettle == 1 {
                    typeBtn.setTitle("审核通过", for: .normal)
                    typeBtn.setTitleColor(.init(hex: "#21D826"), for: .normal)
                    typeBtn.setImage(UIImage.init(named: "bt_tgguo"), for: .normal)
                } else {
                    typeBtn.setTitle("审核不通过", for: .normal)
                    typeBtn.setTitleColor(.init(hex: "##EF0B19"), for: .normal)
                    typeBtn.setImage(UIImage.init(named: "bt_jujue"), for: .normal)
                    toReLabel.removeFromSuperview()
                    toReValue.removeFromSuperview()
                }
                
                orderValue.text = detailModel?.id
                serverValue.text = detailModel?.withdrawAccount
                contentValue.text = String(detailModel?.money ?? 0)
                timeValue.text = detailModel?.applyForTime
                checkValue.text = detailModel?.verifyTime
                noteValue.text = detailModel?.remarks
                toReValue.text = detailModel?.arriveTime
                
                
//                let date = NSDate.init(timeIntervalSince1970: detailModel!.createdTime/1000)
//                let dateFormat = DateFormatter.init()
//                dateFormat.dateStyle = .short
//                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
//                timeValue.text = dateFormat.string(from: date as Date)
                
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
        
        contentView.addSubview(typeBtn)
        typeBtn.titleLabel?.font = .systemFont(ofSize: 14)
        typeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(-10)
            make.width.equalTo(120)
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
        
        contentView.addSubview(checkLabel)
        checkLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(timeValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(checkValue)
        checkValue.numberOfLines = 0
        checkValue.snp.makeConstraints { (make) in
            make.left.equalTo(checkLabel.snp.right)
            make.top.equalTo(checkLabel)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(checkValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(noteValue)
        noteValue.numberOfLines = 0
        noteValue.snp.makeConstraints { (make) in
            make.left.equalTo(noteLabel.snp.right)
            make.top.equalTo(noteLabel)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(toReLabel)
        toReLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(noteValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(toReValue)
        toReValue.numberOfLines = 0
        toReValue.snp.makeConstraints { (make) in
            make.left.equalTo(toReLabel.snp.right)
            make.top.equalTo(toReLabel)
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
