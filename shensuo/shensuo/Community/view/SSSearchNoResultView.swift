//
//  SSSearchNoResultView.swift
//  shensuo
//
//  Created by  yang on 2021/4/15.
//

import UIKit

class SSSearchNoResultView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var noResultimageV:UIImageView = {
        let noResultV = UIImageView.init()
        noResultV.image = UIImage.init(named: "noResult")
        return noResultV
    }()
    
    var tipLabel:UILabel = {
        let tip = UILabel.init()
        tip.textColor = UIColor.init(hex: "#333333")
        tip.numberOfLines = 0
        tip.textAlignment = .center
        tip.font = UIFont.systemFont(ofSize: 16)
        tip.text = "抱歉，没有找到相关信息\n请换个关键字试试~"
        return tip
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: "#FFFFFF")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(noResultimageV)
        noResultimageV.snp.makeConstraints { (make) in
            make.top.equalTo(24)
            make.left.equalTo(45)
            make.right.equalTo(-45)
            make.height.equalTo((screenWid-90)/324*177)
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noResultimageV.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(176)
            make.height.equalTo(44)
        }
    }

}
