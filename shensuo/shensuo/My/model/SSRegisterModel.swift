//
//  SSRegisterModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/29.
//

import UIKit
import KakaJSON

struct SSRegisterModel: Convertible {

    var userId: String?
    var headImageUrl: String?
    var registeredName: String?
    var addressBookName: String?
    var vip: Bool = false
    var focusType: Bool = false
    var fansNumber: String?
    var userName: String = ""
    var introduce: String = ""
    var showWords: String = ""
    var distance: String = ""
    var verified: Bool = false
    var verifiedType: Int = 0
    var registeredTime: String = ""
    var userHeadImage: String = ""
    
    
    
}
