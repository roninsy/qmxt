//
//  HQSearchView.swift
//  chengzishiping
//
//  Created by 陈鸿庆 on 2021/3/28.
//

import UIKit

class HQSearchView: UIView {
    var selIndex = 0
    let bgView = UIImageView.initWithName(imgName: "home_search_bg")
    var enterSearch : stringBlock? = nil
    let logo = UIImageView.initWithName(imgName: "home_search")
    let nameTf = UILabel.initSomeThing(title: "搜索", fontSize: 14, titleColor: .init(hex: "#666666"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(nameTf)
        nameTf.snp.makeConstraints { (make) in
            make.left.equalTo(logo.snp.right).offset(10)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = SearchVC()
        vc.mainView.selIndex = self.selIndex
        vc.mainView.pageNum = 1
        vc.mainView.topView.selView.segmentedView.defaultSelectedIndex = self.selIndex
        vc.mainView.topView.selView.segmentedView.reloadData()
       
        vc.mainView.topView.tipView.text = "请输入关键词开始搜索"
        vc.hidesBottomBarWhenPushed = true

        HQPush(vc: vc, style: .default)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


