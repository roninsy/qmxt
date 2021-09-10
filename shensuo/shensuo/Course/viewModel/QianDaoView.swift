//
//  QianDaoVIew.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/31.
//

import UIKit

class QianDaoView: UIView {
    let imgV = UIImageView.initWithName(imgName: "home_qiandao")
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
//        // 添加到view
        self.layer.shadowColor = UIColor.init(red: 142/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1).cgColor
        self.layer.shadowOffset = .init(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let qianDaoView = QianDaoDetalisView()
        HQGetTopVC()?.view.addSubview(qianDaoView)
        qianDaoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
//        PayWithProductId(pid: "ss_meibi_70")

    }
}
