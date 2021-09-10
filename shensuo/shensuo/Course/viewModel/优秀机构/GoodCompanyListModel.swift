//
//  GoodCompanyListModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/6.
//

import UIKit
import KakaJSON

struct GoodCompanyListModel : Convertible {

//    content.serviceNumber    string    服务人数
    let serviceNumber : String? = ""
//    content.address    string    地址
    let address : String? = ""
//    content.finishTimes    string    完课人数
    let finishTimes : String? = ""
//    content.tutorNumber    string    导师人数
    let tutorNumber : String? = ""
//    content.totalGift    string    总礼物
    let totalGift : String? = ""
//    content.nickName    string    昵称
    let nickName : String? = ""
//    content.headImage    string    头像
    let headImage : String? = ""
//    content.enterpriseSgs    string    企业名称
    let enterpriseSgs : String? = ""
//    content.contentNumber    string    内容数
    let contentNumber : String? = ""
//    content.concern    string    关注
    let concern : Bool? = false
//    content.likeTimes    string    点赞数
    let likeTimes : String? = ""
//    content.fansNumber    string    粉丝数
    let fansNumber : String? = ""
//    content.showWords    string    对外认证展示说明
    let showWords : String? = ""
//    content.serviceTotal    string    服务总数
    let serviceTotal : String? = ""
//    content.id    string    id
    let id : String? = ""
//    content.userType    string    用户类型
    let userType : String? = ""
//    content.vip    string    是否vip
    let vip : Bool? = false
//    content.giftNumber    string    礼物量
    let giftNumber : String? = ""
}
