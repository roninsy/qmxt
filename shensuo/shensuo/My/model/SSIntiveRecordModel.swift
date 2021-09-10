//
//  SSIntiveRecordModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/10.
//

import UIKit
import KakaJSON


struct SSIntiveRecordModel: Convertible {

//    createdTime    被邀请人注册时间    string
    var createdTime: String? = ""
//    headImage    用户头像    string
    var headImage: String? = ""
//    id    邀请号    integer(int64)
    var id: String? = ""
//    keyWord    关键字    string
    var keyWord: String? = ""
//    mobile    手机号    string
    var mobile: String? = ""
//    nickName    被邀请人名字    string
    var nickName: String? = ""
}
