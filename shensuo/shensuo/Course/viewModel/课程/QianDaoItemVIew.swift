//
//  QianDaoItemVIew.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/10.
//

import UIKit

class QianDaoItemView: UIView {
    let whiteView = UIView()
    let topBGV = UIView()
    let botBGV = UIView()
    let viewWid = (screenWid - 90 - 46 - 24) / 4
    var viewHei : CGFloat!
    let mbIcon = UIImageView.initWithName(imgName: "qiandao_meibi")
    let finishIcon = UIImageView.initWithName(imgName: "qiandao_finish")
    let dayLab = UILabel.initSomeThing(title: "第一天", titleColor: .init(hex: "#FD8024"), font: .MediumFont(size: 13), ali: .center)
    let coinNumLab = UILabel.initSomeThing(title: "+5", titleColor: .init(hex: "#FD8024"), font: .boldSystemFont(ofSize: 14), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewHei = viewWid / 63 * 79
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.backgroundColor = .init(hex: "#FD8024")
        topBGV.backgroundColor = .init(hex: "#FDf2e8")
        botBGV.backgroundColor = .white
        topBGV.frame = .init(x: 1, y: 1, width: viewWid - 2, height: viewHei - 24)
        botBGV.frame = .init(x: 1, y: viewHei - 25, width: viewWid - 2, height: 24)
        self.addSubview(topBGV)
        self.addSubview(botBGV)
        HQRoude(view: topBGV, cs: [.topLeft,.topRight], cornerRadius: 4)
        HQRoude(view: botBGV, cs: [.bottomLeft,.bottomRight], cornerRadius: 4)
        
        topBGV.addSubview(mbIcon)
        mbIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(7)
        }
        
        botBGV.addSubview(finishIcon)
        finishIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        finishIcon.isHidden = true
        
        botBGV.addSubview(dayLab)
        dayLab.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        topBGV.addSubview(coinNumLab)
        coinNumLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-2)
        }
        
       
        whiteView.backgroundColor = .init(hex: "#FDF4EE")
        whiteView.alpha = 0.66
        self.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
