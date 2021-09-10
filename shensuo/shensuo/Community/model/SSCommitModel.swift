//
//  SSCommitModel.swift
//  shensuo
//
//  Created by  yang on 2021/6/1.
//

import UIKit
import KakaJSON

//{\"postTimes\":0,\"referUserID\":1,\"musicUrl\":\"\",\"activeVal\":0.0,\"title\":\"所有帖子已经客户.\",\"content\":\"的是相关应该阅读.分析虽然更多.需要音乐大家销售.\",\"userIsVip\":0,\"referCompanyUserId\":0,\"cityName\":\"广州市\",\"giftTimes\":0,\"videoUrl\":\"\",\"headerImage\":\"http://img.quanminxingti.com/122.jpg\",\"arrivalTime\":\"1622714369266\",\"id\":\"280637801685344282\",\"newest\":1,\"address\":\"广州市\",\"nickName\":\"刘德华\",\"personal\":0,\"userId\":\"278798043854307404\",\"likeTimes\":0,\"companyId\":0,\"noteType\":2,\"deleted\":0,\"createTime\":1622714359,\"userHeaderImage\":\"http://img.quanminxingti.com/1622273071961_%E7%BB%84%206972.png\",\"location\":\"\",\"viewTimes\":0,\"imageList\":[\"http://img.quanminxingti.com/122.jpg\",\"http://img.quanminxingti.com/122.jpg\",\"http://img.quanminxingti.com/122.jpg\",\"http://img.quanminxingti.com/002VTQLVgy1gpa0agcvchj60u0192e7q02.jpg\",\"http://img.quanminxingti.com/1618302136801_花.png\",\"http://img.quanminxingti.com/1618387804623_u=2487474782,1423919571&fm=26&gp=0.jpg\",\"http://img.quanminxingti.com/1619507967713.png\",\"http://img.quanminxingti.com/1617171376989_2222.png\",\"http://img.quanminxingti.com/1619510431047.png\"],\"sevenDays\":1}

struct SSCommitModel: Convertible {

    var postTimes: String?
    var referUserID: String?
    var musicUrl: String?
    var activeVal: String?
    var title: String?
    var content: String?
    var userIsVip: String?
    var referCompanyUserId: String?
    var cityName: String?
    var giftTimes:String?
    var videoUrl: String?
    var headerImage: String?
    var arrivalTime:String?
    var id: String?
    var newest: String?
    var address: String?
    var nickName: String?
    var personal: String?
    var userId: String?
    var likeTimes: String?
    var companyId: String?
    //动态类型:1视频，2图片
    var noteType: String?
    var deleted: Bool?
    var createTime: String?
    var userHeaderImage: String?
    var location: String?
    var viewTimes: String?
    var imageList: [String]?
    var sevenDays:String?
    
    
    var genre: Int? = 0
    var userType: Int? = 0
}
