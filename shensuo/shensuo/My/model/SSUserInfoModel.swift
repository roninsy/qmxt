//
//  SSUserInfoModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/23.
//

import UIKit
import KakaJSON


//\"userId\":\"1\",\"oneSelf\":true,\"nickName\":\"全民形体官方\",\"headImage\":\"http://img.quanminxingti.com/1618627740769_u%3D2487474782%2C1423919571%26fm%3D26%26gp%3D0.jpg\",\"vipStartDate\":\"2021-05-03\",\"vipEndDate\":\"2021-05-05\",\"focusType\":true,\"vip\":true,\"userType\":1,\"fansNumber\":0,\"introduce\":null,\"badgeNumber\":0,\"focusNumber\":0,\"likeTimes\":0,\"sex\":1,\"province\":\"广东\",\"city\":\"广州\",\"showWords\":\"好好\",\"currentPoints\":11,\"vipNumber\":\"0871 0000 0000 0001 \"}

//{\"nickName\":\"全民形体平台\",\"headImage\":null,\"birthday\":null,\"province\":\"广东\",\"city\":\"广州\",\"provinceId\":null,\"cityId\":null,\"introduce\":null}

struct SSUserInfoModel: Convertible {
    
    var userId: String?
    var oneSelf: Bool = false
    var nickName: String?
    var headImage: String?
    var vipStartDate: String?
    var vipEndDate: String?
    var focusType: Bool = false
    var vip: Bool = false
    //用户类型 0普通用户，1企业认证用户，2个人认证用户
    var userType: Int = 0
    var fansNumber: Int?
    var introduce: String?
    var badgeNumber: Int?
    var focusNumber: Int?
    var likeTimes: Int?
    //0未知，1男，2女
    var sex: Int?
    var province: String?
    var city: String?
    var showWords: String?
    var currentPoints: Int?
    var vipNumber: String?
    var birthday:String?
    var provinceId:Int?
    var cityId:Int?
    var authenticationH: CGFloat!{
        
        get{
            
            return userType == 0 ? 0 : 40
        }
    }
    var introduceH: CGFloat! {
        
        get{
        
            return introduce == "" ? 0 : heightWithFont(fixedWidth: screenWid - 32, str: introduce ?? "ss")
        }
    }
    
    var headH: CGFloat! {
        
        get {
            
            return 244.0 + introduceH + authenticationH
        }
    }

    
}
