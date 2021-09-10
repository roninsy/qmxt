//
//  SSDraftsCell.swift
//  shensuo
//
//  Created by  yang on 2021/5/6.
//

import UIKit

class SSDraftsCell: UICollectionViewCell {
    
    let imageView = UIImageView.initWithName(imgName: "Image01")
    let playImage = UIImageView.initWithName(imgName: "my_play")
    let titleLabel = UILabel.initSomeThing(title: "唤醒女人柔软天性,零础修炼气质雅姿", isBold: true, fontSize: 15, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let timeLabel = UILabel.initSomeThing(title: "2021-04-12 23.40", fontSize: 13, titleColor: .init(hex: "#B4B4B4"))
    let deleteBtn = UIButton.initBgImage(imgname: "my_delete")
    
    var draftModel: SSDraftModel? = nil {
        didSet{
            imageView.kf.setImage(with: URL.init(string: (draftModel?.headerImageUrl) ?? ""), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
            

            playImage.isHidden = draftModel?.type == "1" ? false : true
            titleLabel.text = draftModel?.title ?? ""
            if draftModel?.createdTime != nil && draftModel?.createdTime != "" {
                
                timeLabel.text = draftModel?.createdTime?.subString(to: 16)
                
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        imageView.frame = CGRect(x: 0, y: 0, width: screenWid/2-17, height: (screenWid/2-17)/193*230)
        HQRoude(view: imageView, cs: [.topLeft,.topRight], cornerRadius: 5)
        buildUI()
    }
    
    func buildUI() -> Void {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo((screenWid/2-17)/193*230)
        }
        
        imageView.addSubview(playImage)
        playImage.isHidden = true
        playImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.left.equalTo(6)
            make.right.equalTo(-6)
//            make.height.equalTo(42)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.equalTo(6)
            make.right.equalTo(-40)
            make.height.equalTo(18)
        }
        
        addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.right.equalTo(-10)
            make.width.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
