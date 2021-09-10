//
//  TipStudyModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/9.
//

import UIKit
import KakaJSON

struct TipStudyModel: Convertible {

//    courseCount    integer($int32)
//    课程数
    let courseCount : String? = ""
//  [...]学习提醒数组
    let learningReminds : [learningRemind]? = nil
//    planCount    integer($int32)
//    方案数
    let planCount : String? = ""
}

struct learningRemind: Convertible {

//courseId    integer($int64)
//关联id
    let courseId : String? = ""
//finishDays    integer($int32)
//已学天数
    let finishDays : String? = ""
//finishStep    integer($int32)
//已学小节数
    let finishStep : String? = ""
//title    string
//标题
    let title : String? = ""
//totalDays    integer($int32)
//总天数
    let totalDays : String? = ""
//totalStep    integer($int32)
//总小节数
    let totalStep : String? = ""
//type    integer($int32)
//类型 0课程，1方案
    let type : String? = ""
}
