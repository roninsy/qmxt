//
//  SSBillModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/10.
//

import UIKit
import KakaJSON

/**{\"id\":\"1\",\"name\":\"每日签到\",\"code\":\"DAILY_SIGN\",\"showPoints\":\"+5~15美币\",\"finishedTimes\":0,\"times\":1,\"verifyJob\":false,\"once\":false,\"finished\":false,\"image\":\"https://qmxt-sh.oss-cn-shanghai.aliyuncs.com/icon-.png\",\"type\":12},*/


struct SSBillModel: Convertible {

    var id : Int?
    //任务名字
    var name : String?
    //任务代码
    var code : String?
    //任务完成描述
    var showPoints : String?
    //任务当前完成状态
    var finishedTimes : Int?
    //任务最大完成次数
    var times : Int?
    //是否认证用户任务
    var verifyJob : Bool?
    //是否一次性任务
    var once : Bool?
    //是否完成该任务
    var finished : Bool?
    //图片路径
    var image : String?
    //跳转路径 0：首页，1：分享页面，2：课程首页，3：方案首页，4：我的课程，5我的方案，" +"6:vip页面，7：发布动态拍视频，8:社区，9：我的徽章，10：我要认证，11：发布课程方案，12：签到
    var type : Int?
    
    var titleStr : String?
    
    var myHei : CGFloat = 22
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        self.titleStr = String(format: "%@(%d/%d)", self.name ?? "", self.finishedTimes ?? 0,self.times ?? 0)
        self.myHei = self.titleStr?.ga_heightForComment(font: .systemFont(ofSize: 16), width: screenWid - 165, maxHeight: 80) ?? 22
        if myHei < 22 {
            myHei = 22
        }
    }
    
}
