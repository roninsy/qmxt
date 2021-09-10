//
//  SSMyHeadView.swift
//  shensuo
//
//  Created by  yang on 2021/3/31.
//

import Foundation

class SSMyHeadView: UICollectionReusableView {
    
    var headIcon = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = .gray
//        headIcon.backgroundColor = .brown
//        addSubview(headIcon)
//        headIcon.snp.makeConstraints { (make) in
//            make.top.left.right.bottom.equalToSuperview()
//        }
    }
    
    
}
