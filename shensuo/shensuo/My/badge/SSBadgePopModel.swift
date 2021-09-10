//
//  SSBadgePopModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/27.
//

import UIKit
import KakaJSON

//{\"id\":\"5\",\"categoryName\":null,\"categoryCode\":null,\"current\":0,\"obtainImage\":null,\"badgeList\":[{\"id\":\"210301939777445896\",\"name\":\"发布动态1次徽章\",\"type\":true,\"image\":\"http://img.quanminxingti.com/badge/get/%E6%88%91%E6%98%AF%E7%84%A6%E7%82%B9-01@1x.png\",\"conditionRemark\":\"发布动态1次\",\"createdTime\":\"2021-05-10\"}]}

struct SSBadgePopModel: Convertible {

    var id:String = ""
    var categoryName:String = ""
    var categoryCode:Int = 0
    var current:String = ""
    var obtainImage:String = ""
    var currentMessage:String = ""
    var badgeList:[badgeListModel]? = nil

}

struct badgeListModel: Convertible {

    var id:String = ""
    var name:String = ""
    var type:Bool = false
    var image:String = ""
    var conditionRemark:String = ""
    var createdTime:String = ""

}
