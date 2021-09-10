//
//  SSIntiveRecordCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/10.
//

import UIKit

class SSIntiveRecordCell: UITableViewCell {

    
    let headImg = UIImageView()
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 17), ali: .left)
    
    let phoneLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 17), ali: .left)
    
    let timeLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 12), ali: .left)

    var model : SSIntiveRecordModel? = nil{
        didSet{
            self.headImg.kf.setImage(with: URL.init(string: model?.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
            self.nameLab.text = model?.nickName
            self.phoneLab.text = "手机号：\(model?.mobile ?? "")"
            self.timeLab.text = "注册时间：\(model?.createdTime ?? "")"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        
        let topLine = UIView()
        topLine.backgroundColor = .init(hex: "#F7F8F9")
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        headImg.layer.cornerRadius = 32
        headImg.layer.masksToBounds = true
        self.contentView.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(16)
            make.top.equalTo(33)
        }
        
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(88)
            make.right.equalTo(-16)
            make.top.equalTo(27)
        }
        
        self.contentView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(nameLab)
            make.right.equalTo(-16)
            make.top.equalTo(55)
        }
        
        self.contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(nameLab)
            make.right.equalTo(-16)
            make.top.equalTo(80)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
