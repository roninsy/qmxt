//
//  myCell.swift
//  shensuo
//
//  Created by  yang on 2021/3/31.
//

import Foundation
import SnapKit

class SSmyCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var myLabel = UILabel()
    
    var numLabel = UILabel()
    
    
    var lineView = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        
        imageView.image = UIImage.init(named: "sousuo")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        myLabel.textAlignment = .center
        myLabel.textColor = .black
        myLabel.font = UIFont.systemFont(ofSize: 10)
        myLabel.text = "我的课程"
        self.addSubview(myLabel)
        myLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.addSubview(lineView)
        lineView.backgroundColor = UIColor.init(hex: "#F7F8F9")
        lineView.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }
}
