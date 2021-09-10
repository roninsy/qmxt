//
//  SSNotesDetaileModel.swift
//  shensuo
//
//  Created by  yang on 2021/7/1.
//

import UIKit
import KakaJSON

struct SSNotesDetaileModel: Convertible {

    var userName: String?
    var userHeadImage: String?
    var musicUrl: String?
    var content: String?
    var title: String?
    var address: String?
    var videoUrl: String?
    var referCompanyUserId: String?
    var headerImageUrl: String?
    var createdTime: String?
    var id: String?
    var authorId: String?
    var userVerifyType: String?
    var likeTimes: String?
    var postTimes: Int?
    var collectTimes: String?
    var viewTimes: NSNumber?
    var giftTimes: String?
    var giftUserTimes: String?
    var complainedTimes: String?
    var giftIncome: String?
    var type: Int?
    var personal: Bool?
    var iliked: Bool = false
    var icollected: Bool?
    var imageUrls: [String]?
    

}
