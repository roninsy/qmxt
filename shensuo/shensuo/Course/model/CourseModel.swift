//
//  KeChengModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/1.
//

import UIKit
import KakaJSON

struct CourseModel : Convertible {
    
    let wid = screenWid / 2 - 15
    let imgHei = (screenWid / 2 - 15) / 193 * 257
    
//    "type": 3,
    let type: Int? = 0
//    "id": "94088371084992513",
    let id: String? = ""
//    "likeTimes": 4570,
    let likeTimes: Int? = 0
//    "viewTimes": 36372854,
    let viewTimes: Int? = 0
//    "headerImage": "https://qmxt-sh.oss-cn-shanghai.aliyuncs.com/index/8.png",
    let headerImage: String? = ""
//    "totalStep": 12,
    let totalStep: Int? = 0
//    "totalDays": 16,
    let totalDays: Int? = 0
//    "finishedTimes": 927,
    let finishedTimes: Int? = 0
//    "title": "标题：-1346421416",
//    "new": false
    let new: Bool = false
    
    
    var modelHei: CGFloat = 0
    
    var title: String? = ""
//    "nickName": "用户昵称：-1237546319",
    let nickName: String? = ""
//    "userHeadImage": "https://qmxt-sh.oss-cn-shanghai.aliyuncs.com/index/6.png",
    let userHeadImage: String? = ""
//    "totalGift": -6570184983793103000,
    let totalGift: Int? = 0
//    "price": 60.41087336814647,
    let price: Double? = 0
//    "free": true,
    let free: Bool? = false
//    "vipFree": false,
    let vipFree: Bool? = false
//    "vipType": 1,
    let vipType: Int? = 0

    ///0课程 1方案
    var contentType: Int? = 0
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        var hei : CGFloat = 21
        if title != nil{
            if new {
                self.title = "\t" + title!
            }
            hei = (title!.getHei(font: .boldSystemFont(ofSize: 15), lineHei: 21, wid: wid))
            
        }
        self.modelHei = imgHei + hei + 20 + 20 + 18 + 17
    }
}
