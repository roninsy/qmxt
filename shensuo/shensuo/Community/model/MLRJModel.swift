//
//  MLRJModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/12.
//

import UIKit
import KakaJSON

//{\"id\":\"242368852804378626\",\"createdTime\":\"2021-05-21 15:28:22\",\"title\":\"5天美丽日记——美丽蜕变，美不可挡\",\"likeTimes\":0,\"postTimes\":0,\"collectTimes\":0,\"viewTimes\":69,\"complainedTimes\":0,\"handleStatus\":0,\"handleResult\":0,\"giftTimes\":0,\"giftUserTimes\":0,\"giftIncome\":0.00,\"deleted\":false,\"personal\":false,\"nickName\":\"全民形体平台\",\"headImage\":\"http://img.quanminxingti.com/ss/user_head_image.png\",\"image\":\"http://img.quanminxingti.com/122.jpg\",\"type\":1,\"userId\":\"1\"}

//美丽日记model
struct MLRJModel: Convertible {

    var type: Int = 0
    var likeTimes: String?
    var giftIncome: String?
    var viewTimes: String?
    var createdTime: String?
    var image: String?
    var handleResult: Int = 0
    var nickName: String?
    var title: String?
    var headImage: String?
    var id: String?
    var giftUserTimes: String?
    var personal: Bool = false
    var postTimes: String?
    var giftTimes: String?
    var collectTimes: String?
    var complainedTimes: String?
    var deleted: Bool = false
    var handleStatus: Int = 0
    var userId:String?
    
    var headerImage: String?
    var userHeaderImage: String?
    var genre: Int?
    var userType: String?
    var newest: Bool? = false
}
