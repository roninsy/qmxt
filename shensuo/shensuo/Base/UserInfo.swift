//
//  UserInfo.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/23.
//

import UIKit
import SwiftyUserDefaults
import SensorsAnalyticsSDK

class UserInfo {
    private static var _sharedInstance: UserInfo?
    
    ///形体贝
    var xtb : Double = 0
    ///用户余额
    var balance : Double = 0
    
    var isInLoginVC = false
    ///今天是否签到
    var todaySign = true
    ///是否需要提示签到
    var tipSign = true
    ///是否需要提示关注
    var tipfocus = true
    ///首页是否需要提示学习
    var homeTipStudy = true
    ///方案是否需要提示学习
    var projectTipStudy = true
    ///课程是否需要提示学习
    var courseTipStudy = true
    
    var userId : String?
    ///用户类型，0普通用户，1企业认证用户，2个人认证用户")
    var type : Int = 0
    
//    "age": 0
    var age : Int? = 0
//    "sex": 0
    var sex : Int? = 0
    
    var nickName : String?
//    头像地址'
    var headImage : String?
    var token : String?
//    手机号码'"
    var mobile : String?
//    密码'
    var password : String?
//    最后登陆的设备
    var lastDevice : String?
    var lastToken : String?
//    最后登陆时间
    var lastLoginTime : String?
//    vip开始时间
    var vipStartDate : String?
    
//    endEffectiveDate    string($date-time)
//    有效期结束时间
    var endEffectiveDate : String?
//    startEffectiveDate    string($date-time)
//    有效期开始时间
    var startEffectiveDate : String?
//    thriftMoney    number($bigdecimal)
//    节省费用
    var thriftMoney : NSNumber?
//    vip    boolean
//    example: false
//    是否会员
    var vip : Bool? = false
//    vipDays    integer($int32)
//    成为会员天数
    var vipDays : Int? = 0
//    vipMarketPrice    number($bigdecimal)
//    市场价
    var vipMarketPrice : Double?
//    vipNumber    string
//    会员号
    var vipNumber : String?
//    vipPrice    number($bigdecimal)
//    优惠价
    var vipPrice : Double?
    
    //  当前版本号
    var version : Double?
    ///软件版本号
    var appVersion : Double?
    
//    costSavingsForCourse    成为会员可节省课程费用
    var costSavingsForCourse : NSNumber?
//    costSavingsForPlan    成为会员可节省方案费用
    var costSavingsForPlan : NSNumber?
//    costSavingsOfYears    成为会员每年可节省费用
    var costSavingsOfYears : NSNumber?
    
    var province : String?
//    生日
    var birthday : String?
    
    var points : Int?
    
    var noShowGiftMsg : Bool = false
    
    var showSVGAMsg : Bool = false
    
    var tempObj : Any? = nil
    
    ///在视频列表里面
    var inVedioListVC = false
    ///获赞总数
    var likeTimes : Int?
    ///粉丝数量
    var fansNumber : Int?
    ///用户美币余额
    var currentPoints : Int?
    ///       关注数
    var focusNumber : Int?
    
    var dicInfo : NSDictionary?{
        didSet{
            if dicInfo != nil {
                let dic = dicInfo?["user"] as? NSDictionary
                self.nickName = dic?["nickName"] as? String
                self.token = dicInfo?["token"] as? String
                self.userId = dic?["userId"] as? String
                self.headImage = dic?["headImage"] as? String
                self.mobile = dic?["mobile"] as? String
                self.type = dic?["type"] as? Int ?? 0
                self.fansNumber = dic?["fansNumber"] as? Int ?? 0
                self.currentPoints = dic?["currentPoints"] as? Int ?? 0
                self.focusNumber = dic?["focusNumber"] as? Int ?? 0
                self.likeTimes = dic?["likeTimes"] as? Int ?? 0
                
                let userTokenKey = DefaultsKey<String?>(userTokenKeyString)
                Defaults[key: userTokenKey] = self.token
                let userId = DefaultsKey<String?>(userIDKeyString)
                Defaults[key: userId] = self.userId
                let nameKey = DefaultsKey<String?>(nameKeyString)
                Defaults[key: nameKey] = self.nickName
                let headKey = DefaultsKey<String?>(headKeyString)
                Defaults[key: headKey] = self.headImage
                let userType = DefaultsKey<Int?>(userTypeKeyString)
                Defaults[key: userType] = self.type
                
                SensorsAnalyticsSDK.sharedInstance()?.login(self.userId ?? "")
                
                let userPhoneKey = DefaultsKey<String?>(userPhoneKeyString)
                Defaults[key: userPhoneKey] = self.mobile
            }
        }
    }
    
    var vipInfo : NSDictionary?{
        didSet{
            if vipInfo != nil {
                let dic = vipInfo!
                self.endEffectiveDate = dic["endEffectiveDate"] as? String
                self.startEffectiveDate = dic["startEffectiveDate"] as? String
                self.vip = dic["vip"] as? Bool
                self.thriftMoney = dic["thriftMoney"] as? NSNumber
                self.vipDays = dic["vipDays"] as? Int
                self.vipMarketPrice = dic["vipMarketPrice"] as? Double
                self.vipNumber = dic["vipNumber"] as? String
                self.vipPrice = dic["vipPrice"] as? Double
                self.costSavingsForCourse = dic["costSavingsForCourse"] as? NSNumber
                self.costSavingsForPlan = dic["costSavingsForPlan"] as? NSNumber
                self.costSavingsOfYears = dic["costSavingsOfYears"] as? NSNumber
            }
        }
    }
    
    var userInfo : NSDictionary?{
        didSet{
            if userInfo != nil {
                let dic = userInfo!
                self.age = dic["age"] as? Int
                self.sex = dic["sex"] as? Int
               
            }
        }
    }
     
    class func getSharedInstance() -> UserInfo {
        guard let instance = _sharedInstance else {
            _sharedInstance = UserInfo()
            return _sharedInstance!
        }
        return instance
    }
     
    private init() {} // 私有化init方法
     
    //销毁单例对象
    class func destroy() {
        _sharedInstance = nil
    }
}
 
