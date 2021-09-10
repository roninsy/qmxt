//
//  SSNavigationBar.swift
//  shensuo
//
//  Created by  yang on 2021/4/6.
//

import UIKit

class SSNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackgroud") {
                subview.frame = self.bounds
            } else if stringFromClass.contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0, y: NavStatusHei, width: screenWid, height: 44)
            }
        }
    }

}
