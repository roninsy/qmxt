//
//  DefineKeys.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/13.
//

import UIKit
import Log
import RxSwift
import RxCocoa
import NVActivityIndicatorView

public let CUCMKey = "bfddf7140cfd4d8fb3047de72b41af12"
//极光推送
public let JPushKey = "cefa17a8a9b085ee269a0939"
//高德地图
public let AMapKey = "bf1eb01028fbcd04cc6c8b3c970f8a18"

public let ossUrl = "oss-accelerate.aliyuncs.com"

public let weChatId = "wxb5369d99a36db280"
public let weChatAppSecret = "76cc52ae8f16fb595465e37e5ab71e9b"
public let sendCodeKey = "2A61B52EB3554E4EAC015B8A5B22F92C"
public let regCodeKey = "105CFD2E1BDE4561926C2B5672301A0E"
///判断是否第一次打开软件
public let isFristKeyString = "isFrist"
public let userNameKeyString = "QMXT_userName"
public let userPassKeyString = "QMXT_userPass"
public let userTokenKeyString = "QMXT_token"
public let userUUIDKeyString = "QMXT_UUID"
public let ipaOrderKeyString = "QMXT_ipa_order"
public let notiMsgString = "QMXT_noti_msg"
public let userTypeKeyString = "QMXT_userType"
public let userPhoneKeyString = "QMXT_userPhone"
public let userIDKeyString = "QMXT_userID"
public let nameKeyString = "QMXT_name"
public let headKeyString = "QMXT_head"
public let weChatLoginNotification = "qmxtWeChatLogin"

///跳转到账户密码登录通知
public let pushToPassNotification = "pushToPassNotification"
///游客登录通知
public let pushToUserDefultNotification = "pushToUserDefultNotification"

///隐私协议
public let privacyPolicyURL = "https://www.quanminxingti.com/h5/#/privacyPolicy?hidden=true"
///用户协议
public let userAgreementURL = "https://www.quanminxingti.com/h5/#/userAgreement?hidden=true"

///--------------生产------------------
//阿里云
public let baseUrl = "https://appapi.qmxingti.com"
///体态评估
public let ProjectScanURL = "https://app.qmxingti.com/#/scan"
///方案首页
public let ProjectHomeURL = "https://app.qmxingti.com/#/scheme"
///对外购买链接
public let buyURL = "https://app.qmxingti.com/#/buy"
///游客token
public let userDefultToken = ""
///--------------生产结束------------------

///--------------预生产------------------
/////对外
//public let baseUrl = "http://192.168.0.40:9000"
/////体态评估
//public let ProjectScanURL = "http://office.quanminxingti.com:8082/h5text/#/scan"
/////方案首页
//public let ProjectHomeURL = "http://office.quanminxingti.com:8082/h5text/#/scheme"
/////对外购买链接
//public let buyURL = "http://office.quanminxingti.com:8082/h5text/#/buy"
//public let userDefultToken = ""
///--------------预生产结束------------------

///--------------测试------------------
///////测试
//public let baseUrl = "https://app.qmshape.com:449"
/////方案首页
//public let ProjectHomeURL = "http://ceshi.quanminxingti.com:81/h5/#/scheme"
/////测试购买链接
//public let buyURL = "http://ceshi.quanminxingti.com:81/h5/#/buy"
/////体态评估
//public let ProjectScanURL = "http://ceshi.quanminxingti.com:81/h5/#/scan"
/////游客token
//public let userDefultToken = ""
///--------------测试结束------------------

///--------------三火------------------
/////测试
//public let baseUrl = "192.168.0.186:8013"
/////方案首页
//public let ProjectHomeURL = "http://ceshi.quanminxingti.com:81/h5/#/scheme"
/////体态评估
//public let ProjectScanURL = "http://ceshi.quanminxingti.com:81/h5/#/scan"
//public let userDefultToken = ""
///--------------三火结束------------------

///分享链接
public let ShareRegisterURL = "http://ceshi.quanminxingti.com:81/h5/#/register"



///支付完成通知
public let PayCompletionNotification: Notification.Name =
    Notification.Name(rawValue: "PayCompletionNotification")
///支付完成通知
public let PayVipCompletionNotification: Notification.Name =
    Notification.Name(rawValue: "PayCompletionNotification")
///评论完成通知
public let CommentCompletionNotification: Notification.Name =
    Notification.Name(rawValue: "CommentCompletionNotification")

///课程收到礼物通知
public let ProjectIsSendGiftNotification: Notification.Name =
    Notification.Name(rawValue: "ProjectIsSendGiftNotification")
///需要加入课程通知
public let NeedToAddProjectNotification: Notification.Name =
    Notification.Name(rawValue: "NeedToAddProjectNotification")

///收藏搜索
public let CollectionSearchCompletionNotification: Notification.Name =
    Notification.Name(rawValue: "CollectionSearchCompletionNotification")

///是否全面屏
public let isFullScreen = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0

public let NavStatusHei:CGFloat = isFullScreen ? 44 : 20

public let SafeBottomHei:CGFloat = isFullScreen ? 34 : 0

public let screenWid = UIScreen.main.bounds.size.width

public let screenHei = UIScreen.main.bounds.size.height

public let statusHei = UIApplication.shared.statusBarFrame.height

public let NavContentHeight:CGFloat = 44

public let isBigScreen = screenHei > 800

public let searchViewHeight:CGFloat = 44
public let normalMarginHeight:CGFloat = 12.0

public let NavBarHeight = NavStatusHei + NavContentHeight

public let logger = Logger()

public let disposeBag = DisposeBag()

public let ReadTipString = "请阅读并同意相关协议"

public let activityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: screenWid, height: screenHei), type: .ballTrianglePath, color: .white, padding: 10)
//Block
typealias intBlock = (_ num : Int)->()
typealias stringBlock = (_ str : String)->()
typealias numBlock = (_ num : NSNumber)->()
typealias arrBlock = (_ arr : NSArray)->()
typealias voidBlock = ()->()

class DefineKeys: NSObject {

}

