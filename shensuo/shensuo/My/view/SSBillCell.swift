//
//  SSBillCell.swift
//  shensuo
//
//  Created by  yang on 2021/5/10.
//

import UIKit

//美币任务
class SSBillCell: UITableViewCell {
    
    var billModel : SSBillModel? = nil{
        didSet{
            if billModel != nil {
//                headImage.image = UIImage.init(named: "bt_rw")
                headImage.kf.setImage(with: URL.init(string: billModel?.image ?? ""), placeholder: UIImage.init(named: "bt_rw"), options: nil, completionHandler: nil)
                title.text = billModel?.titleStr
                title.snp.updateConstraints { make in
                    make.height.equalTo(billModel!.myHei)
                }
                if billModel!.finished! {
                    checkBtn.setTitle("已领取", for: .normal)
                    checkBtn.titleLabel?.font = UIFont.MediumFont(size: 13)
                    checkBtn.setTitleColor(.init(hex: "#CBCCCD"), for: .normal)
//                    checkBtn.setImage(UIImage.init(named: ""), for: .normal)
                    checkBtn.backgroundColor = .white
                    checkBtn.layer.borderWidth = 1
                 
                    checkBtn.layer.borderColor = UIColor.init(r: 203, g: 204, b: 205, a: 1).cgColor
                   
                    checkBtn.isEnabled = false
                } else {
                    checkBtn.setTitle("去完成", for: .normal)
                    checkBtn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
                    checkBtn.layer.borderColor = UIColor.clear.cgColor
                    checkBtn.backgroundColor = .init(hex: "#FD8024")
//                    checkBtn.setImage(UIImage.init(named: ""), for: .normal)
                }
                content.text = billModel?.showPoints
            }
        }
    }
    

    var headImage = UIImageView.initWithName(imgName: "bt_rw")
    var title = UILabel.initSomeThing(title: "每日签到", fontSize: 16, titleColor: .init(hex: "#333333"))
    var content = UILabel.initSomeThing(title: "+15美币", fontSize: 14, titleColor: .init(hex: "#999999"))
    var checkBtn = UIButton.init()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() -> Void {
        contentView.addSubview(headImage)
        headImage.layer.masksToBounds = true
        headImage.layer.cornerRadius = 15
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(45)
        }
        
        title.numberOfLines = 0
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(12)
            make.top.equalTo(headImage)
            make.right.equalTo(-165 + 72)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        checkBtn.isUserInteractionEnabled = false
        contentView.addSubview(checkBtn)
        checkBtn.layer.masksToBounds = true
        checkBtn.layer.cornerRadius = 15
        
        checkBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.equalTo(76)
            make.height.equalTo(32)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
