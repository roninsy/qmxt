//
//  SelectStringModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/24.
//

import UIKit
import KakaJSON


struct SelectStringModel: Convertible {

//    courseVerifyDays    课程方案审核时间，天    integer(int32)    integer(int32)
    let courseVerifyDays : NSNumber? = nil
//    giftShow    首页/课程/方案/社区礼物特效展示多少美币以上展示    integer(int32)    integer(int32)
    let giftShow : NSNumber? = nil
//    giftToBalanceRate    礼物美币转账户余额服务费费率，百分比，比如5%，填5    number(bigdecimal)    number(bigdecimal)
    let giftToBalanceRate : NSNumber? = nil
//    id    id    integer(int64)    integer(int64)
//    let courseVerifyDays : NSNumber? = nil
//    pointsChange    美币兑换人民币汇率设置,1元兑换多少美币    integer(int32)    integer(int32)
    let pointsChange : NSNumber? = nil
//    techniqueRate    技术服务费费率，百分比，比如5%，填    number(bigdecimal)    number(bigdecimal)
    let techniqueRate : NSNumber? = nil
//    userVerifyDays    认证用户企业审核时间，天    integer(int32)    integer(int32)
    let userVerifyDays : NSNumber? = nil
//    vipCourseMoney    专享会员免费课程每年可省    number(bigdecimal)    number(bigdecimal)
    let vipCourseMoney : NSNumber? = nil
//    vipMarketPrice    vip年卡市场价    number(bigdecimal)    number(bigdecimal)
    let vipMarketPrice : NSNumber? = nil
//    vipPrice    vip年卡优惠价    number(bigdecimal)    number(bigdecimal)
    let vipPrice : NSNumber? = nil
//    vipProgramMoney    专享会员免费方案每年可省    number(bigdecimal)
//    number(bigdecimal)
    let vipProgramMoney : NSNumber? = nil
//    vipYearMoney    会员平均每年可省    number(bigdecimal)    number(bigdecimal)
    let vipYearMoney : NSNumber? = nil
//    withdrawMax    提现最大金额    number(bigdecimal)    number(bigdecimal)
    let withdrawMax : NSNumber? = nil
//    withdrawMin    提现最小金额    number(bigdecimal)    number(bigdecimal)
    let withdrawMin : NSNumber? = nil
//    withdrawRate    提现服务费费率，百分比，比如5%，填5    number(bigdecimal)    number(bigdecimal)
    let withdrawRate : NSNumber? = nil
//    withdrawVerifyDays    提现审核时间，天
    let withdrawVerifyDays : NSNumber? = nil
}
