//
//  SSDataViewCell.swift
//  shensuo
//
//  Created by  yang on 2021/4/12.
//

import UIKit

class SSDataViewCell: UITableViewCell {

    var titleLabel: UILabel = {
        let title = UILabel.init()
        title.textAlignment = .left
        title.textColor = UIColor.init(hex: "#878889")
        title.font = UIFont.MediumFont(size: 16)
        return title
    }()
    
    var numLabel:UILabel = {
        let num = UILabel.init()
        num.textAlignment = .right
        return num
    }()
    
    var icon = UIImageView.initWithName(imgName: "meibi_icon")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.trailing.equalTo(numLabel.snp.leading).offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
