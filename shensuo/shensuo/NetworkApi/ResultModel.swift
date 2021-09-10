//
//  ResultModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/23.
//

import UIKit
import KakaJSON

struct ResultModel : Convertible {
    let code: Int? = 500
    let message: String? = ""
    let data: NSDictionary? = nil
}
