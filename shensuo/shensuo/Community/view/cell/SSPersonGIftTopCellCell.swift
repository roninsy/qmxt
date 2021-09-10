//
//  SSPersonGIftTopCellCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/29.
//

import UIKit

class SSPersonGIftTopCellCell: UITableViewCell {
    
    var rankModel: GiftRankModel? = nil {
        
        didSet{
            
            if rankModel != nil {
                
                giftHomeNameL.text = "[\(rankModel?.name ?? "")]的礼物间"
                personNumL.text = "累计收到\(rankModel?.totalPeople ?? 0)人送的\(rankModel?.totalGifts ?? 0)件礼物"
//                dataL.text = "\(rankModel?.joinTime ?? "")"
                if rankModel?.joinTime != "" {
                    
                    dataL.text =  "\(rankModel?.joinTime ?? "")加入“全民形体”"
                }
            }
        }
    
    }
    
    
    
    var bgIcon = UIImageView.initWithName(imgName: "gift_banner_bg")
    var giftHomeNameL: UILabel!
    var personNumL: UILabel!
    var dataL: UILabel!
    var lockBtn: UIButton = UIButton.initBgImage(imgname: "my_more")
    
    var lockImage = UIImageView.initWithName(imgName: "lock")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgIcon)
        bgIcon.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        contentView.addSubview(lockBtn)
        lockBtn.snp.makeConstraints { make in
            
            make.height.width.equalTo(24)
            make.top.equalTo(12)
            make.trailing.equalTo(-12)
        }
        giftHomeNameL = UILabel.initSomeThing(title: "我的礼物间", fontSize: 18, titleColor: .white)
        giftHomeNameL.font = .MediumFont(size: 18)
        contentView.addSubview(giftHomeNameL)
        giftHomeNameL.snp.makeConstraints { make in
            
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(lockImage)
        lockImage.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(22)
            make.left.equalTo(giftHomeNameL.snp.right).offset(5)
            make.centerY.equalTo(giftHomeNameL)
        }
        
        personNumL = UILabel.initSomeThing(title: "累计多少人", fontSize: 14, titleColor: .init(hex: "#DFA1A1"))
        contentView.addSubview(personNumL)
        personNumL.snp.makeConstraints { make in
            
            make.top.equalTo(giftHomeNameL.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        dataL = UILabel.initSomeThing(title: "加入身所科技", fontSize: 10, titleColor: .init(hex: "#B47E7E"))
        contentView.addSubview(dataL)
        dataL.snp.makeConstraints { make in
            
            make.bottom.equalTo(-5)
            make.centerX.equalToSuperview()
        }
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SSPersonGIftTitleCellCell: UITableViewCell {
    
    var titleL: UILabel!
    var subTitleL: UILabel!
    var lockIocn: UIButton!
    let arrowIcon = UIImageView.initWithName(imgName: "arrow_right")
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleL = UILabel.initSomeThing(title: "礼物榜", fontSize: 16, titleColor: color33)
        titleL.font = .MediumFont(size: 16)
        contentView.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        lockIocn = UIButton.initBgImage(imgname: "my_gift_canlook")
        contentView.addSubview(lockIocn)
        lockIocn.snp.makeConstraints { make in
            make.left.equalTo(titleL.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        contentView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        subTitleL = UILabel.initSomeThing(title: "查看榜单", fontSize: 14, titleColor: color66)
        contentView.addSubview(subTitleL)
        subTitleL.snp.makeConstraints { make in
            
            make.trailing.equalTo(arrowIcon.snp.leading).offset(2)
            make.centerY.equalToSuperview()
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
