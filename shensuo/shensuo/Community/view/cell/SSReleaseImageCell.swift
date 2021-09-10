//
//  SSReleaseImageCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/23.
//

import UIKit

class SSReleaseImageCell: UICollectionViewCell {
    
    var image = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(image)
        image.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }
        image.contentMode = .scaleAspectFill
        HQRoude(view: contentView, cs: [.allCorners], cornerRadius: 6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        image.snp.makeConstraints { make in
//
//            make.edges.equalToSuperview()
//        }
//    }
    
}
