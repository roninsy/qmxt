//
//  UserHeadBtn.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/27.
//

import UIKit

class UserHeadBtn: UIButton {

    let imgv = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgv)
        imgv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
