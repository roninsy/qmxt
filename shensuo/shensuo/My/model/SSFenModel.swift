//
//  SSFenModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/23.
//

import UIKit
import KakaJSON


struct SSFansModel: Convertible {

    var userId: String?
    var nickName: String?
    var headImage: String?
    var vipStartDate: String?
    var vipEndDate: String?
    var vip: Bool = false
///    关注状态 false已关注，true未关注
    var focusType: Bool = false
    var focusUserType: Int = 0
    var fansNumber: Int = 0
    var introduce: String?
    
}

struct SSFocusPopModel: Convertible {
    var id: String?
    var userType: Int = 0
    var headImage: String?
    var nickName: String?
    var showWords: String?
    var vip: Bool = false
    var enterpriseSgs: String?
    var address: String?
    var fansNumber: String?
    var serviceNumber: String?
    var tutorNumber: String?
    var createTime: String?
    var giftNumber: String?
    var verify: String?
    var coinNumber: String?
    var winPraisenumber: String?
    var concernedNumber: String?
    var referUserID: String?
    var referCompanyId: String?
    var concernedList: String?
    var status: String?
    var companyId: String?
    var beFocusedList: String?
    var deleted: String?
    ///是否关注
    var focusType:Bool = false
    var concern:Bool = false
    
    var userId: String?
    var introduce: String?
    var type : Int? = 0
}
