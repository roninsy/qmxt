//
//  KeChengInfoCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/5.
//

import UIKit

class CourseInfoCell: UICollectionViewCell {
    let mainView = CourseInfoView()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.layer.cornerRadius = 6
//        self.contentView.layer.masksToBounds = true
        self.contentView.layer.shadowColor = HQLineColor(rgb: 185).cgColor
        self.contentView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.contentView.layer.shadowRadius = 6
        self.contentView.layer.shadowOpacity = 1
        self.contentView.addSubview(mainView)
        mainView.layer.cornerRadius = 6
        mainView.layer.masksToBounds = true
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
