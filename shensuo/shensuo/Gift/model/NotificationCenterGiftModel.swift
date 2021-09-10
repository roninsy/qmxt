//
//  NotiGiftModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/22.
//

import UIKit
import KakaJSON

struct NotificationCenterGiftModel : Convertible {
    ///动画地址
    let dynamicImage: String? = ""
    ///送礼人头像
    let giverHeadImage: String? = ""
    ///送礼人名称
    let giverName: String? = ""
    ///送礼人名称
    let receiverName: String? = ""
    ///礼物名称
    let giftName: String? = ""
    ///礼物图片
    let giftImage: String? = ""
    ///礼物数量
    let giftTimes: String? = ""
    ///链接id
    let contentId: String? = ""
    ///链接类型
    let linkType: String? = ""
    ///是否在首页显示
    let showHomePage: Bool? = false

}


struct NotificationCenterTypeModel : Convertible {
    var messageType : String? = ""
}


struct NotificationCenterContentModel : Convertible {
///    "type" 消息类型编码
    let type: String? = ""
///    "typeName" 消息类型名称
    let typeName: String? = ""
///    "title" 消息标题
    let title: String? = ""
///    "contentType" 内容类型
    let contentType: String? = ""
///    "content" 内容
    let content: String? = ""
///    "otherContent" 拓展内容
    let otherContent: NSDictionary? = nil
///    "publishedTime" 推送时间
    let publishedTime: String? = ""
}
