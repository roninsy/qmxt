//
//  SSGiftSettingModel.swift
//  shensuo
//
//  Created by  yang on 2021/6/30.
//

import UIKit
import KakaJSON

struct SSGiftSettingModel: Convertible {

    var id: String = ""
    var userId: String = ""
    //礼物间GIFT_ROOM，礼物架GIFT_SHELF，礼物榜GIFT_TOP
    var name: String = ""
    //1仅自己可见2所有人可见
    var value: String = ""
    
}
