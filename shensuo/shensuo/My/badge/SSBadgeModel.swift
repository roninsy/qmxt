//
//  SSBadgeModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/27.
//

import UIKit
import KakaJSON

//{\"nickName\":\"全民形体平台\",\"headImage\":\"http://img.quanminxingti.com/ss/user_head_image.png\",\"type\":1,\"badgeNumber\":9,\"createdTime\":null,\"badgeCateGory\":[{\"id\":\"1\",\"categoryName\":\"累计训练天数\",\"categoryCode\":\"TOTAL_TRAINING\",\"current\":0,\"obtainImage\":\"http://img.quanminxingti.com/badge/notGet/%E7%B4%AF%E8%AE%A1%E8%AE%AD%E7%BB%8301.png\",\"badgeList\":null}]}

struct SSBadgeModel: Convertible {

    var nickName:String = ""
    var headImage:String = ""
    var type:Int = 0
    var badgeNumber:String = ""
    var createdTime:String = ""
    var badgeCateGory:[badgeCateGoryModel]? = nil

}

struct badgeCateGoryModel : Convertible {
    var id:String = ""
    var categoryName:String = ""
    var categoryCode:String = ""
    var current:Int = 0
    var obtainImage:String = ""
    var badgeList:String = ""
}
