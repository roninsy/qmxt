//
//  SSProveSelectModel.swift
//  shensuo
//
//  Created by  yang on 2021/6/3.
//

import UIKit
import KakaJSON

//{\"nickName\":\"全民形体平台\",\"idNumber\":\"123456789123456789\",\"mobile\":\"全民形体平台\",\"vip\":false,\"type\":1,\"id\":\"1\",\"companyName\":\"身所4\",\"creditCode\":\"123456789123456781\",\"province\":\"广东省\",\"city\":\"广州市\",\"detailAddress\":\"北岛\",\"operationName\":\"moli\",\"showWords\":\"女神世界3\",\"status\":2,\"verifyTimes\":3,\"hasOwnerCompany\":false,\"ownerCompanyId\":null,\"ownerCompanyName\":\"\",\"ownerCompanyShowWords\":\"\",\"headImageUrl\":\"http://img.quanminxingti.com/1622270374751P10519-111742.jpg\",\"auditFailureReason\":\"\"}

struct SSProveSelectModel: Convertible {
    
    var nickName:String = ""
    var idnumber:String = ""
    var idname:String = ""
    var operatorIDNumber:String = ""
    var operatorMobile:String = ""
    var operatorName:String = ""
    var provinceName:String = ""
    var mobile:String = ""
    var vip:Bool = false
    var type:Int = 0
    var id:String = ""
    var companyName:String = ""
    var creditCode:String = ""
    var province:String = ""
    var cityName:String = ""
    var detailAddress:String = ""
    var operationName:String = ""
    var showWords:String = ""
    var status:Int = 0
    var verifyTimes:Int = 0
    var hasOwnerCompany:String = ""
    var ownerCompanyId:String = ""
    var ownerCompanyName:String = ""
    var ownerCompanyShowWords:String = ""
    var headImageUrl:String = ""
    var auditFailureReason:String = ""
}
