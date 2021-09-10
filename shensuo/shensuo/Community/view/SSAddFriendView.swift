//
//  addFriendView.swift
//  shensuo
//
//  Created by swin on 2021/3/23.
//

import Foundation


//添加好友
class SSAddFriendView: UIView {
    
    var clickControlHander: ((UIControl) -> Void)?
    
    var contentControl : btnContrl = {
        let content = btnContrl.init()
        content.setImageText(imageName: "tongxunlu", destext: "通讯录好友")
        content.addTarget(self, action: #selector(clickConBtn(conBtn:)), for: .touchUpInside)
        content.tag = 1001
        return content
    }()
    
    var weixinControl : btnContrl = {
        let weixin = btnContrl.init()
        weixin.setImageText(imageName: "weixin", destext: "微信邀请")
        weixin.addTarget(self, action: #selector(clickConBtn(conBtn:)), for: .touchUpInside)
        weixin.tag = 1002
        return weixin
    }()
    
    var QQControl : btnContrl = {
        let QQ = btnContrl.init()
        QQ.setImageText(imageName: "qq", destext: "QQ邀请")
        QQ.addTarget(self, action: #selector(clickConBtn(conBtn:)), for: .touchUpInside)
        QQ.tag = 1003
        return QQ
    }()
    
    
    let controlWid = (screenWid-40)/3
    let controlHei = 120
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hex: "#F7F8F9")
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(contentControl)
        contentControl.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.equalTo(controlWid)
            make.height.equalTo(controlHei)
        }
        
        addSubview(weixinControl)
        weixinControl.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(contentControl.snp.right).offset(10)
            make.width.equalTo(controlWid)
            make.height.equalTo(controlHei)
        }
        
        addSubview(QQControl)
        QQControl.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(weixinControl.snp.right).offset(10)
            make.width.equalTo(controlWid)
            make.height.equalTo(controlHei)
        }
        
    }
    
    @objc func clickConBtn(conBtn: UIControl) {
        let btn = conBtn
        clickControlHander!(btn)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class btnContrl: UIControl {
    
    var imageView: UIImageView!
    var desLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        imageView = UIImageView()
        desLabel = UILabel()
        
        desLabel.font = UIFont.systemFont(ofSize: 15)
        desLabel.textColor = UIColor.init(hex: "#333333")
        desLabel.textAlignment = .center
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.height.equalTo(45)
            make.centerX.equalToSuperview()
        
        }
        
        self.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
    }
    
    public func setImageText(imageName: String,  destext: String) {
        
        imageView.image = UIImage.init(named: imageName)
        desLabel.text = destext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
