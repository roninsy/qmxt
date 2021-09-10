//
//  SSDetailNotesView.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit

//MARK：介绍详情
class SSDetailNotesView: UIView {
    
    var detailHeight : CGFloat = 0
    
    var titleHeight : CGFloat = 0
    
    var timeLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 14), ali: .left)
    
    var titleLabel : UILabel = {
        let title = UILabel.init()
        title.textAlignment = .left
        title.textColor = UIColor.init(hex: "#333333")
        title.font = UIFont.systemFont(ofSize: 18)
        title.text = "让言辞如春风般舒适温暖，让爱人和孩子的欢声笑语随之处处出现，阵阵而来。"
        title.numberOfLines = 0
        return title
    }()
    
    var detailLabel : UILabel = {
        let detail = UILabel.init()
        detail.numberOfLines = 0
        detail.textAlignment = .left
        detail.textColor = UIColor.init(hex: "#333333")
        detail.font = UIFont.systemFont(ofSize: 14)
        detail.text = "柔软，是女厉。"
        
        return detail
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(detailLabel)
        detailLabel.numberOfLines = 0
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(timeLab)
        timeLab.numberOfLines = 1
        timeLab.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
