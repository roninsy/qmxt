///
///  KeChengDetalisModel.swift
///  shensuo
///
///  Created by 陈鸿庆 on 2021/4/20.
///

import UIKit
import KakaJSON

struct CourseDetalisModel : Convertible {

///    applyTime    string($date-time)
///    申请提交时间
    let applyTime: String? = ""
///    buyTimes    integer($int32)
///    学习/购买人数
    let buyTimes: NSNumber? = 0
///    categoryId    integer($int64)
///    分类id
    let categoryId: NSNumber? = 0
///    collectTimes    integer($int32)
///    收藏次数
    let collectTimes: NSNumber? = 0
///    complainedTimes    integer($int32)
///    被投诉次数
    let complainedTimes: NSNumber? = 0
///    copyrightName    string
///    版权昵称
    let copyrightName: String? = ""
///    copyrightPic    string
///    版权头像
    let copyrightPic: String? = ""
///    copyrightShow    string
///    版权企业认证
    let copyrightShow: String? = ""
///    courseStepList    [...]
    var courseStepList: [CourseStepListModel]? = nil
///    deletedRemark    string
///    varchar(100) comment '删除原因说明，删除课程填写'
    let deletedRemark: String? = ""
///    deletedTime    string($date-time)
///    datetime comment '删除时间'
    let deletedTime: String? = ""
///    details    string
///    课程简介
    var details: String? = ""
///    detailsStatus    integer($int32)
///    int not null comment '简介审核状态，1待审核，2审核通过，3审核不通过'
    let detailsStatus: NSNumber? = 0
///    finishRatio    number($double)
///    完课率
    let finishRatio: NSNumber? = 0
///    finishTimes    integer($int32)
///    完课人数
    let finishTimes: NSNumber? = 0///    free    boolean
///    example: false
///    1免费，0付费
    let example: Bool? = false
///    handleResult    integer($int32)
///    内容处理情况，1不处理，2警告并要求修改，3删除
    let handleResult: NSNumber? = 0
///    handleStatus    integer($int32)
///    内容处理状态，1待处理，2已处理
    let handleStatus: NSNumber? = 0
///    headerImage    string
///    课程封面地址
    let headerImage: String? = ""
///    id    integer($int64)
    let id: String? = ""
///    introduce    string
///    课程一句话介绍
    let introduce: String? = ""
///    lastDetailsApplyTime    string($date-time)
///    datetime comment '简介最近申请时间'
    let lastDetailsApplyTime: String? = ""
///    lastPublishTime    string($date-time)
///    最近发布时间，也就是审核通过上架时间
    let lastPublishTime: String? = ""
///    lastVerifyTime    string($date-time)
///    最近审核时间
    let lastVerifyTime: String? = ""
///    likeTimes    integer($int32)
///    点赞次数
    let likeTimes: NSNumber? = 0
///    new    boolean
    var new: Bool? = false
///    planTarget    string
    var newest : Bool? =  false
///    课程归属目标
    let planTarget: String? = ""
///    postTimes    integer($int32)
///    评论次数
    let postTimes: NSNumber? = 0
///    price    number($bigdecimal)
///    市场价
    let price: NSNumber? = 0
///    refer    boolean
///    example: false
///    是否推荐
    let refer: Bool? = false
///    referSort    integer($int32)
///    推荐顺序，越大越前面
    let referSort: NSNumber? = 0
///    showCopyright    boolean
///    example: false
///    '显示版权 1显示，0不显示'
    let showCopyright: Bool? = false
///    status    integer($int32)
///    内容状态，0 草稿 1待审核，2审核通过，3审核不通过，4已删除
    let status: NSNumber? = 0
///    teacherUserId    integer($int64)
///    导师用户,t_user表用户id
    let teacherUserId: String? = ""
///    title    string
///    课程标题
    var title: String? = ""
///    totalCalorie    integer($int32)
///    总的消耗，单位千卡
    let totalCalorie: NSNumber? = 0
///    totalDays    integer($int32)
///    总天数，方案需要'
    let totalDays: NSNumber? = 0
///    已学天数
    let finishDays: NSNumber? = 0
///    totalIncome    number($bigdecimal)
///    购买总收入
    let totalIncome: NSNumber? = 0
///    totalMinutes    integer($int32)
///    总的分钟数
    let totalMinutes: NSNumber? = 0
///    totalStep    integer($int32)
///    总小节数
    let totalStep: NSNumber? = 0
///    tutorIntro    string
///    导师个人简介
    let tutorIntro: String? = ""
///    tutorName    string
///    导师昵称
    let tutorName: String? = ""
///    tutorPic    string
///    导师头像
    let tutorPic: String? = ""
///    tutorShow    string
///    导师个人认证
    let tutorShow: String? = ""
///    userId    integer($int64)
///    发布用户,t_user表用户id
    let userId: String? = ""
///    verifyTimes    integer($int32)
///    审核总次数
    let verifyTimes: NSNumber? = 0
///    viewTimes    integer($int32)
///    浏览次数
    let viewTimes: NSNumber? = 0
///    vipFree    boolean
///    example: false
///    1免费，0付费
    let vipFree: Bool? = false

    ///    1免费，0付费
    let free: Bool? = false
///   已学总数
    let finishStep: String? = ""
    
    var priceType : CourseBuyType = .free
    
//    secondCategory    string
//    二级分类id'
    let secondCategory: String? = ""
//    firstCategory    string
//    一级分类id'
    let firstCategory: String? = ""
    
//    type    integer($int32)
//    类型 0课程，1方案'
    let type : Int = 0
    ///是否加入课程
    var isAdd = false
    
    var userHeaderImage :String? = ""
    
    var picUrl :String? = ""
    ///方案小节 dayMap
    let dayMap: NSDictionary? = nil
    //付费类型
    let paymentType: String? = ""
    //是否认证用户 0未认证 1个人认证 2企业认证
    let verify: Int = 0
    ///    courseId    integer($int64)课程id
    let courseId: String? = ""
    //创建时间
    let createdTime: String? = ""
    //昵称
    let nickName: String? = ""
    ///礼物值
    let giftTimes: String? = ""
    //    "userType":"用户类型",
        let userType: String? = nil
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        if new == true {
            self.newest = true
        }
        
        if newest == true {
            self.title = "\t" + (title ?? "")
        }
        
        let headerS = "<html lang=\"zh-cn\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, nickName-scalable=no\"></meta><style>img{max-width: 100%; width:100%; height:auto;}</style></head><body>"
        let endS = "</body></html>"
        
        self.details = headerS + (self.details ?? "") + endS
    }
}


struct CourseStepListModel : Convertible {
    
//    surfacePlot    string
//    音视频封面图'
    let surfacePlot: String? = ""
    ///学习人数
    let studyTimes: String? = ""
    
    ///分钟数
    let minutes: String? = ""
///    小节消耗，单位千卡'
    let calorie: NSNumber? = 0
///    courseId    integer($int64)
    let courseId: String? = ""
///    day    integer($int32)'第几天，方案需要'")

    let day: NSNumber? = 0
    let step: NSNumber? = 0
///    t '1删除，0正常
    let deleted: Bool? = false
    let deletedRemark: String? = ""
///  小节详情
    var details: String? = ""
///   1已学，0待学'")
    var finished: Bool? = false
///   是否免费试学,1是，0否'
    let freeTry: Bool? = false
///    id    integer($int64)
    let id: String? = ""
///    lastApplyTime    string($date-time)
    let lastApplyTime: String? = ""
///    lastVerifyTime    string($date-time)
    let lastVerifyTime: String? = ""
///   评论次数'
    let postTimes: NSNumber? = 0
///   '视频或者音频地址
    let productionUrl: String? = ""
///    sort    integer($int32)
    let type: NSNumber? = 0
///   '审核状态，1待审核，2审核通过，3审核不通过'
    let status: NSNumber? = 0
///  小节标题'"
    let title: String? = ""
///   总小节数
    let totalStep: NSNumber? = 0
///    verifyTimes    integer($int32)
    let verifyTimes: NSNumber? = 0
///    '1视频，0音频'
    var video: Bool = false
    
    ///    点赞次数
    let likeTimes: NSNumber? = 0
    
    ///    浏览次数'
    let viewTimes: NSNumber? = 0
    
///------------- 首页为您推荐字段 ---------------
//    collect    boolean 是否收藏
    var collect: Bool = false
//    canPlay    boolean
//    example: false
//    可播放类型 false为1分钟 true为全部
    var canPlay: Bool = false
//    headerImage    string
//    课程封面地址

    ///学习人数
    let headerImage: String? = ""
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        let headerS = "<html lang=\"zh-cn\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, nickName-scalable=no\"></meta><style>img{max-width: 100%; width:100%; height:auto;}</style></head><body>"
        let endS = "</body></html>"
        
        self.details = headerS + (self.details ?? "") + endS
    }
}

