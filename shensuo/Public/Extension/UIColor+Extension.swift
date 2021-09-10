//
//  UIColor+Extension.swift
//  MuslimUmmah
//
//  Created by RSY on 2019/6/18.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation

extension UIColor {
    
    // hexColor
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat((hex & 0x0000FF)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// 16进制
    convenience init(hexRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: hexRed/0xFF, green: green/0xFF, blue: blue/0xFF, alpha: alpha)
    }
    
    /// 随机色函数(alpha值)
    public class func random(alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: alpha)
    }
    
    /// create a image with pure color
    /// 纯色图片
    ///
    /// 由颜色生成图片
    ///
    func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(size)                                           // 开始绘制
        let context = UIGraphicsGetCurrentContext()                                 // 读取上下文
        context?.setFillColor(self.cgColor)                                         // 设置填充色
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))   // 进行填充
        let image = UIGraphicsGetImageFromCurrentImageContext()                     // 转为image格式
        UIGraphicsEndImageContext()                                                 // 结束绘制
        return image
    }
}
