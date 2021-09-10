//
//  KeChengHeaderView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/5.
//

import UIKit

class CourseHeaderView: UIView {
    let midView = CourseMidView()
    let bannerWid = screenWid - 20
    ///轮播视图
    let bannerView = BannerView.init()
    let selView = CourseSelTitleListView()
    
    let botImg = UIImageView.initWithName(imgName: "kecheng_botimg")
    
    let botImgHei = (screenWid - 20) / 394 * 100
    override init(frame: CGRect) {
        super.init(frame: frame)
        bannerView.layer.cornerRadius = 9
        bannerView.layer.masksToBounds = true
        self.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(16)
            make.width.equalTo(bannerWid)
            make.height.equalTo(bannerWid / 394 * 168)
        }
        self.addSubview(midView)
        midView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bannerView.snp.bottom)
            make.height.equalTo(midView.myHei)
        }
        selView.setupLayer()
        resetSelView()
        
        let botWId = screenWid - 32
        self.addSubview(botImg)
        botImg.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(botWId)
            make.height.equalTo(botImgHei)
            make.bottom.equalTo(-10)
        }
        botImg.isHidden = true
    }
    
    func resetSelView(){
        selView.needR()
        selView.removeFromSuperview()
        self.addSubview(selView)
        selView.snp.makeConstraints { (make) in
            make.top.equalTo(midView.snp.bottom)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(96 - 27)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}
