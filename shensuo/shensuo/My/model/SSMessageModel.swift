//
//  SSMessageModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/10.
//

import UIKit
import KakaJSON

struct otherContentModel : Convertible {
    var contentId : String?
    var contentType : String?
    var personal : String?
    var contentTitle : String?
    var gift : String?
    var giver : String?
    var isConvertedUsd : Bool?
    var convertedTime : String?
    var cardNumber : String?
    var moneySaved : Double?
    var expirationTime : Double?
    var note : String?
    var commentDetail : String?
    var commentator : String?
    var plan : String?
    var course : String?
    var paymentType : String?
    var marketPrice : String?
    var tutor : String?
    var copyrightOwner : String?
    var buyer : String?
    var fansName : String?
    var joiner : String?
    var couponType : String?
    var cashAmount : String?
    var album : String?
    var diary : String?
      
}

//{"contentId":"1","contentType":"personal","contentTitle":"--","gift":"比心x3","giver":"石亚","isConvertedUsd":true,"convertedTime":1620352208576}tes
struct testModel : Convertible {
    var contentId : String?
    var contentType : String?
    var contentTitle : String?
    var gift : String?
    var giver : String?
    var isConvertedUsd : Bool?
    var convertedTime : String?
    
}

struct SSMessageModel: Convertible {

    var type : String? = ""
    var title : String? = ""
    var content : String? = ""
    var otherContent : NSDictionary? = nil
    var publishedTime : String? = ""
    var typeName : String? = ""
    var height : CGFloat? = 0
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        switch type {
            case "gift_received":
                self.height = 410
            case "vip_expiration":
                self.height = 270
            case "comment","reply":
                self.height = 340-50
            case "content_buy":
                self.height = 450
            case "un_subscribe":
                self.height = 230
            case "subscribe":
                self.height = 230
            case "content_publish","join_learning":
                self.height = 430
            case "like","favorite":
                self.height = 310
            case "cash_received":
                self.height = 448
            case "content_deletion","banned_talking","account_block": //内容被删除 /被禁言 /被封号
                self.height = 210
            case "system": //系统通知
                self.height = 340
            default:
                self.height = 400
        }
    }
    
    
//    mutating func kj_willConvertToModel(from json: [String : Any]) {
//        print("Car - kj_willConvertToModel")
//        let data = json.data(using: String.Encoding.utf8)
//        let dict = try? JSONSerialization.jsonObject(with: data!,
//                            options: .mutableContainers) as? [String : Any]
//        self.otherContent = dict
//    }
//
//    func kj_didConvertToJSON(json: [String : Any]) {
//        print("Car - kj_didConvertToModel")
//    }
    
   
}


