//
//  SSGiftMessageModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/29.
//

import UIKit
import KakaJSON

//{\"id\":\"257180167783866380\",\"type\":0,\"points\":\"1000\",\"remarks\":\"用户问问送礼给美丽相册2天美丽相册——记录变美生活\",\"giftNameAndQuantity\":\"\",\"payer\":\"h2b\",\"payee\":\"全民形体平台\",\"payeeId\":\"1\",\"giftTime\":\"2021-05-26 15:09:29\"}

struct SSGiftMessageModel: Convertible {

    var id:String = ""
    var type:Int = 0
    var points:String = ""
    var remarks:String = ""
    var giftNameAndQuantity:String = ""
    var payer:String = ""
    var payee:String = ""
    var payeeId:Int = 0
    var giftTime:String = ""

}
