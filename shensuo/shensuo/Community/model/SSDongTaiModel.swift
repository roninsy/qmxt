//
//  SSDongTaiModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/20.
//

import UIKit
import KakaJSON

struct SSDongTaiModel: Convertible {

    var id: String?
    var userName: String?
    var createdTime: String?
    var title: String?
    var content: String?
    var address: String?
    var likeTimes: Int?
    var postTimes: String?
    var collectTimes: Int?
    var viewTimes: String?
    var videoUrl: String?
    var imageUrls:[String]?
    ///是否仅自己可见
    var personal: Bool = false
    var type: String?
    var headerImageUrl: String?
    var giftTimes:String?
    var giftUserTimes:String?
    var blike:Bool = false
    var bsc:Bool = false
    var authorId: String?
    var userHeadImage: String?
    var musicUrl: String?
    
    
    
}
