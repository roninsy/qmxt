//
//  SSBillBoxModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/11.
//

import UIKit
import KakaJSON

/*{\"id\":\"203760086110633990\",\"createdTime\":1620459565000,\"updatedTime\":1620459565000,\"createdAdminId\":\"1\",\"updatedAdminId\":\"0\",\"name\":\"string\",\"image\":\"string\",\"type\":0,\"useCondition\":0,\"payMore\":0.0,\"discount\":0.0,\"needPoints\":\"0\",\"worth\":0.0,\"validDays\":0,\"onShelves\":true,\"frequency\":0}
*/
struct SSBillBoxModel: Convertible {

    var id : String?
    var createdTime : String?
    var updatedTime : String?
    var createdAdminId : String?
    var updatedAdminId : String?
    var name : String? //兑换物品名称
    var image : String?
    var type : Int?  //1抵扣券，2折扣券，3免费券
    var useCondition : Int? //使用条件，0无限制，1多少钱内可用，2会员费可用，3大于多少钱可有用
    var payMore : Double? //小于这个价格可以使用,useCondition = 1的时候起作用
    var discount : Double? //折扣,type = 2的时候起作用
    var needPoints : Double? //需要美币数
    var worth : Double? //值多少钱
    var validDays : Int? //有效天数
    var onShelves : Bool? //1上架，0下架
    var frequency : Int? //0无限制，1一天一次

}
