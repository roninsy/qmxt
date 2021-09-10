//
//  SSMLXCModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/15.
//

import UIKit
import KakaJSON

struct SSMLXCModel:Convertible {
    
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
}
