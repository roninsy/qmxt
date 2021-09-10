//
//  HQSlider.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/24.
//

import UIKit

class HQSlider: UISlider {

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        
        var res = rect
        res.origin.y = rect.origin.y - 10
        res.size.height = rect.size.height + 20
        return super.thumbRect(forBounds: bounds, trackRect: res, value: value)
    }

}
