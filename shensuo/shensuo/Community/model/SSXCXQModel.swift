//
//  SSXCXQModel.swift
//  shensuo
//
//  Created by  yang on 2021/4/22.
//

import UIKit
import KakaJSON

//{\"code\":0,\"message\":\"成功\",\"data\":{\"id\":\"1\",\"createdTime\":\"2021-05-20 17:33:51\",\"viewTimes\":4,\"time\":null,\"title\":\"2天美丽相册——记录变美生活\",\"nickName\":\"全民形体平台\",\"musicName\":null,\"dayNumber\":null,\"photoNumber\":null,\"days\":2,\"url\":null,\"images\":[\"http://img.quanminxingti.com/src=http___ouyang.jpg\",\"http://img.quanminxingti.com/src=http___ouyang.jpg\",\"http://img.quanminxingti.com/src=http___ouyang.jpg\",\"http://img.quanminxingti.com/002iRTdOly1gp9y656shqj62632n5hdt02.jpg\"]}}

//{\"id\":\"1\",\"viewTimes\":18,\"time\":null,\"title\":\"2天美丽相册——记录变美生活\",\"nickName\":\"全民形体平台\",\"musicName\":null,\"days\":2,\"url\":null}

struct SSXCXQModel: Convertible {

    var days: Int = 0
    var musicName: String?
    var nickName: String?
///    阅读次数
    var viewTimes: NSNumber? = 0
    var url: String?
    var dayNumber: String?
    var title: String?
    var createdTime: String?
    var images = [String]()
    var id: String?
    var photoNumber: String?
    var time : String?
    var userId : String?
///    点赞次数
    var likeTimes : NSNumber?
    ///        收藏次数
    var collectTimes : NSNumber?
}
