//
//  KechengTypeModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/16.
//

import UIKit
import KakaJSON

struct CourseTypeModel : Convertible {
    
//    "type": 3,
    var type: Int? = 0
//    "id": "94088371084992513",
    var id: String? = ""
    let parentId: String? = ""
    let level: Int? = 0
    var name : String? = ""
    let childrens: [KechengChildTypeModel]? = nil
    var logoImage : String? = ""
    let bannerImage : String? = ""
    var isLocal = false
}


struct KechengChildTypeModel : Convertible {
    
//    "type": 3,
    let type: Int? = 0
//    "id": "94088371084992513",
    var id: String? = ""
    let parentId: String? = ""
    let level: Int? = 0
    var name : String? = ""
    let childrens: NSArray? = nil
}
