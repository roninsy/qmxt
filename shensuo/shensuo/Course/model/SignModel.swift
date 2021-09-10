//
//  SignModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/24.
//

import UIKit
import KakaJSON

struct SignModel : Convertible {
    
//    "type": 3,
    let signPoints: Int? = 0
//    "id": "94088371084992513",
    let remark: String? = ""
//    "likeTimes": 4570,
    let signDay: String? = ""
//    "viewTimes": 36372854,
    let signList: [SignDayModel]? = nil

}

struct SignDayModel : Convertible {
    
//    "type": 3,
    let day: Int? = 0
//    "id": "94088371084992513",
    let points: String? = ""
//    "likeTimes": 4570,
    let sign: Bool? = false
//    "viewTimes": 36372854,
    let needSign: Bool? = false
    //    "viewTimes": 36372854,
    let today: Bool? = false
}
