//
//  SSVideoModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/22.
//

import UIKit
import KakaJSON

//{\"id\":\"242368852804378627\",\"userId\":\"1\",\"dailyRecordId\":\"242368852804378626\",\"createdTime\":1621582102000,\"dayNumber\":1,\"image\":\"http://img.quanminxingti.com/122.jpg\",\"height\":175,\"weight\":55,\"girth\":36,\"bmi\":3.0,\"bmiConclusion\":2,\"bodyFat\":3.0,\"bodyFatConclusion\":0}

//{\"id\":\"1\",\"userId\":\"1\",\"albumId\":\"1\",\"image\":\"http://img.quanminxingti.com/src=http___ouyang.jpg\",\"dayNumber\":1,\"createdTime\":1621503231000}

struct SSVideoModel: Convertible {

    var id: String?
    var userId: String?
    var albumId: String?
    var createdTime: String?
    var dayNumber: String?
    var image: String?
    var dailyRecordId:String?
    var height: String?
    var weight: String?
    var girth: String?
    var bmi: String?
    var bmiConclusion: String?
    var bodyFat:String?
    var bodyFatConclusion: Bool = false
    
}
