//
//  MyShareModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/2.
//

import UIKit
import KakaJSON

struct MyShareModel : Convertible {
//    训练总消耗/卡路里    object
    let calorieTotal : String? = nil
//    daysTotal    用户总注册天数    object
    let daysTotal : String? = nil
//    headImage    用户头像    object
    let headImage : String? = nil
//    id    用户ID    object
    let id : String? = nil
//    minutesTotal    训练总消耗时间/分钟    object
    let minutesTotal : String? = nil
//    nickName    用户名字    object
    let nickName : String? = nil
//    qrcode        string
    let qrCodeUrl : String? = nil
//    showWords    认证用户对外展示    object
    let showWords : String? = nil
//    type    用户类型 0普通用户，1认证企业，2认证个人    object
    let type : String? = nil
//    vip    是否vip false不是，true是    object
    let vip : Bool = false
}
