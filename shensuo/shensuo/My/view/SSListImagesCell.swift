//
//  SSListImagesCell.swift
//  shensuo
//
//  Created by  yang on 2021/7/9.
//

import UIKit

class SSListImagesCell: UICollectionViewCell {
    
    var closeBtn = UIButton.initBgImage(imgname: "TeacherTrend_ImgClose_icon")
    var image = UIImageView.initWithName(imgName: "check_addbtn_icon")
    var closeBtnBlock: intBlock?
    var imageContent: UIImage? = nil {
        
        didSet{
            
            if imageContent != nil {
                
                closeBtn.isHidden = closeBtnHidden == true ? true : false
                image.image = imageContent
            }
        }
    }
    
    var closeBtnHidden: Bool = true
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        image.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }
        
        HQRoude(view: contentView, cs: [.allCorners], cornerRadius: 6)
        
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            
            make.top.equalTo(-12)
            make.trailing.equalTo(12)
            make.height.width.equalTo(46)
        }
        closeBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.closeBtnBlock?(self!.index)
            
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
