//
//  ResultDicModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/2.
//

import UIKit
import KakaJSON
import BSText

struct ResultDicModel : Convertible {
    let code: Int? = 500
    let message: String? = nil
    let data: NSDictionary? = nil
}

struct ResultBoolModel : Convertible {
    let code: Int? = 500
    let message: String? = nil
    let data: Bool? = false
}
struct ResultStringModel : Convertible {
    let code: Int? = 500
    let message: String? = nil
    let data: String? = ""
}

struct ResultIntModel : Convertible {
    let code: Int? = 500
    let message: String? = nil
    let data: Int? = 0
}

struct PersonageListModel : Convertible{
    let wid = (screenWid - 34) / 2
    let imgHei = (screenWid - 34) / 2 / 3 * 4
    var modelHei: CGFloat = 0
    
//    "id":"id",
    let id: String? = nil
//    "title":"标题",
    var title: String? = nil
//    "headerImage":"封面",
    let headerImage: String? = nil
//    "nickName":"用户名称",
    var nickName: String? = nil
    
///    copyRight    版权用户昵称
    var copyRight: String? = nil
    
//    "userHeaderImage":"用户头像",
    var userHeaderImage: String? = nil
    //    "userHeaderImage":"用户头像",
    let userHeadImage: String? = nil
//    "userType":"用户类型",
    let userType: Int? = 0
//    "isVip":"用户是否vip",
    let isVip: Bool? = false
//    "free":"是否免费",
    let free: Bool? = false
//    "vipFree":"vip免费",
    let vipFree: Bool? = false
//    "price":"价格",
    var price: Double = 0
//    "likeTimes":"点赞次数",
    let likeTimes: String? = nil
//    "buyTimes":"学习人数",
    var buyTimes: String? = nil
//    "totalDays":"方案天数",
    let totalDays: String? = nil
//    "totalStep":"小节数",
    let totalStep: String? = nil
//    "viewTimes":"浏览数",
    let viewTimes: String? = nil
//    "giftTimes":"礼物数",
    let giftTimes: String? = nil
//    "genre":"内容类型，1课程，6方案，3动态，4日记，5相册",
    let genre: Int = 1
//    "includeVideo":"动态是否有视频"
    var includeVideo: Bool = false

    var titleHei : CGFloat = 0
    //    "includeVideo":"动态是否有视频"
    var newest: Bool? = false
    
    let new: Bool? = false

    var studyCount : String? = nil
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        if new == true {
            self.newest = true
        }
        if self.studyCount != nil {
            self.buyTimes = self.studyCount
        }
        if self.userHeadImage != nil && self.userHeadImage!.length > 0 {
            self.userHeaderImage = self.userHeadImage
        }
        if self.copyRight != nil && self.copyRight!.length > 0 {
            self.nickName = self.copyRight
        }
        titleHei = 21
        if title != nil{
            if newest == true && self.title?.contains("\t") == false {
                self.title = "\t" + title!
            }
            let titleLab = BSLabel()
            let line = TextLinePositionSimpleModifier()
            line.fixedLineHeight = 21
            titleLab.text = self.title
            titleLab.linePositionModifier = line
            titleLab.font = .boldSystemFont(ofSize: 15)
            titleLab.numberOfLines = 0
            titleHei = titleLab.sizeThatFits(.init(width: screenWid / 2 - 17 - 20, height: 200)).height
        }
        self.modelHei = imgHei + titleHei + 20 + 20 + 10
        if self.genre == 1 || self.genre == 6 {
            self.modelHei += 20 + 12
        }
    }
}

///首页大数据返回模型
struct HomeListModel : Convertible{
//    "pRowNumber": 8,
    let pRowNumber: String? = nil
//        "pIndex": 8,
    let pIndex: String? = nil
//        "cIndex": 2,
    let cIndex: String? = nil
//        "cRowNumber": 2,
    let cRowNumber: String? = nil
//        "pStage": 3,
    let pStage: String? = nil
//        "cStage": 3,
    let cStage: String? = nil
//        "content":
    let content: [PersonageListModel]? = nil
}


struct SearchListModel : Convertible{
//    "pRowNumber": 8,
    let pageSize: Int? = 10
//        "pIndex": 8,
    let number: Int? = 1
//        "cIndex": 2,
    let totalElements: Int? = 0
//        "cRowNumber": 2,
    let keyWord: String? = nil

//        "content":
    let content: NSArray? = nil
}
