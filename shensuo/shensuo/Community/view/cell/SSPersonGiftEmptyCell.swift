//
//  SSPersonGiftEmptyCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/30.
//

import UIKit

class SSPersonGiftEmptyCell: UITableViewCell {

    let sendGiftBtn = UIButton.initTitle(title: "立即送礼", fontSize: 18, titleColor: color99)
    
    let icon: UIImageView = UIImageView.initWithName(imgName: "gift_nogift")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(icon)
            icon.snp.makeConstraints { make in
                
                make.top.equalTo(60)
                make.centerX.equalToSuperview()
                make.height.equalTo(67)
                make.width.equalTo(118)
            }
        let titleL = UILabel.initSomeThing(title: "暂无礼物", fontSize: 16, titleColor: color33)
            titleL.font = .MediumFont(size: 16)
            contentView.addSubview(titleL)
            titleL.snp.makeConstraints({ make in
                
                make.top.equalTo(icon.snp.bottom).offset(12)
                make.centerX.equalToSuperview()
            })
        
        let subTitlelet = UILabel.initSomeThing(title: "送人玫瑰，手有余香，马上送礼支持Ta吧", fontSize: 12, titleColor: color33)
        contentView.addSubview(subTitlelet)
        subTitlelet.snp.makeConstraints({ make in
            
            make.top.equalTo(titleL.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        })
        
        contentView.addSubview(sendGiftBtn)
        sendGiftBtn.backgroundColor = btnColor
        sendGiftBtn.layer.cornerRadius = 24
        sendGiftBtn.layer.masksToBounds = true
        
        sendGiftBtn.snp.makeConstraints { make in
            
            make.top.equalTo(subTitlelet.snp.bottom).offset(20)
            make.width.equalTo(240)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SSPersonGiftOnlyOwerCell: UITableViewCell {

    var titleL: UILabel!
    var icon: UIImageView = UIImageView.initWithName(imgName: "lock")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        titleL = UILabel.initSomeThing(title: "仅主人可见", fontSize: 18, titleColor: color33)
//        titleL.font = .MediumFont(size: 18)
        addSubview(titleL)
        titleL.snp.makeConstraints({ make in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            
            make.trailing.equalTo(titleL.snp.leading).offset(-2)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(16)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



