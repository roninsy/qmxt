//
//  SSCommonEmptyView.swift
//  shensuo
//
//  Created by  yang on 2021/6/30.
//

import UIKit

class SSCommonEmptyView: UIView {

   
    
    
}
class SSCommonGiftEmptyView: UIView {

    var titleL: UILabel!
    var icon: UIImageView = UIImageView.initWithName(imgName: "gift_nogift")
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(67)
            make.width.equalTo(118)
        }
        titleL = UILabel.initSomeThing(title: "暂无礼物", fontSize: 16, titleColor: color33)
        titleL.font = .MediumFont(size: 16)
        addSubview(titleL)
        titleL.snp.makeConstraints({ make in
            
            make.top.equalTo(icon.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
