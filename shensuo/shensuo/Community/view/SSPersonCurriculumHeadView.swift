//
//  SSPersonCurriculumHeadView.swift
//  shensuo
//
//  Created by  yang on 2021/7/3.
//

import UIKit
import JXPagingView

class
SSPersonCurriculumHeadView: UIView {

    let bannerWid = screenWid - 20
    ///轮播视图
    let selView = SSCurriculumSelTitleView()
    
//    let botImg = UIImageView.initWithName(imgName: "kecheng_botimg")
    
//    let botImgHei = (screenWid - 20) / 394 * 100
    override init(frame: CGRect) {
        super.init(frame: frame)
        
 
        selView.setupLayer()
        resetSelView()
        
//        let botWId = screenWid - 32
//        self.addSubview(botImg)
//        botImg.snp.makeConstraints { (make) in
//            make.left.equalTo(16)
//            make.width.equalTo(botWId)
//            make.height.equalTo(botImgHei)
//            make.bottom.equalTo(-10)
//        }
        
    }
    
    func resetSelView(){
        selView.needR()
        selView.removeFromSuperview()
        self.addSubview(selView)
        selView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(96 - 27)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}
