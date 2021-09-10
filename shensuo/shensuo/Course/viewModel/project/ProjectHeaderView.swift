//
//  ProjectHeaderView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/18.
//

import UIKit

class ProjectHeaderView: UIView {
    let midView = MeiMeiView()
    let bannerWid = screenWid - 20
    ///轮播视图
    let bannerView = BannerView.init()
    let selView = CourseSelTitleListView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bannerView.layer.cornerRadius = 9
        bannerView.layer.masksToBounds = true
        self.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(10)
            make.width.equalTo(bannerWid)
            make.height.equalTo(bannerWid / 394 * 168)
        }
        self.addSubview(midView)
        midView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(bannerView.snp.bottom).offset(16)
            make.height.equalTo(169)
        }
        selView.setupLayer()
        resetSelView()
    }
    
    func resetSelView(){
        selView.needR()
        selView.removeFromSuperview()
        self.addSubview(selView)
        selView.snp.makeConstraints { (make) in
            make.top.equalTo(midView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(96)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}

