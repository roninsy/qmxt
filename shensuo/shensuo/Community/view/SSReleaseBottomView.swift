//
//  SSReleaseBottomView.swift
//  shensuo
//
//  Created by  yang on 2021/6/25.
//

import UIKit

class SSReleaseBottomView: UIView {
    
    let saveBtn = UIButton()
    let btn = UIButton.init()
    var titleL: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI(str: String,icon: String,iconW: CGFloat,topMargin: CGFloat,iconTopM: CGFloat)  {
        
        
        self.addSubview(saveBtn)
        saveBtn.frame = CGRect(x: normalMarginHeight, y: 10, width: 50, height: 60)

        let lineV = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 0.5))
        lineV.backgroundColor = .init(hex: "#EEEFF0")
        
        titleL = UILabel.initSomeThing(title: str, fontSize: 11.0, titleColor: color99)
        self.addSubview(titleL)
        titleL.frame = CGRect(x: normalMarginHeight, y: 53, width: 46, height: 16)
        
        let iconV = UIImageView.initWithName(imgName: icon)
        self.addSubview(iconV)
        iconV.ll_y = iconTopM
        iconV.ll_w = iconW
        iconV.ll_h = iconW
        iconV.center.x = titleL.center.x
        
       
        btn.setTitle("发布", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = .init(hex: "#FD8024")
        self.addSubview(btn)
        btn.frame = CGRect(x: titleL.frame.maxX + topMargin, y: 26, width: screenWid - 72 - normalMarginHeight, height: 45)
        HQRoude(view: btn, cs: [.allCorners], cornerRadius: 22.5)
    }
    
   

}
