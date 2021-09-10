//
//  HQTools.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/15.
//

import UIKit
import Foundation
import SwiftyUserDefaults
import BSText
import WebKit
import SCLAlertView
import SensorsAnalyticsSDK
import SwiftyStoreKit
import MBProgressHUD

enum UserVipType {
    ///不是vip
    case notVip
    ///曾是vip
    case loseVip
    ///是vip
    case isVip
}

class HQTools: NSObject {
   
    
    
}
func HQLineColor(rgb:CGFloat) -> UIColor {
    return UIColor.init(red: rgb/255.0, green: rgb/255.0, blue: rgb/255.0, alpha: 1)
}

func HQColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

//显示被删除的view
func ShowNoContentView(){
    let view = ContentIsDelView()
    HQGetTopVC()?.view.addSubview(view)
    view.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
}

///上报事件
func HQPushActionWith(name:String,dic:NSDictionary){
    ///上报事件
    SensorsAnalyticsSDK.sharedInstance()?.track(name,withProperties: dic as? [AnyHashable : Any])
}

///将视图切圆，注意要先设置frame
func HQRoude(view:UIView,cs:UIRectCorner,cornerRadius:CGFloat) {
    
    let maskLayer = CAShapeLayer()
    
    maskLayer.path = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: cs, cornerRadii: CGSize(width:cornerRadius,height:cornerRadius)).cgPath
    
    view.layer.mask = maskLayer
    view.layoutIfNeeded()
}

func HQShowNoDataView(parentView:UIView, imageName:String, tips:String) -> SSNoDataView {
    let view = SSNoDataView.init().showNoDataView(imageName: imageName, notes: tips)
    parentView.addSubview(view)
    return view
}

///根据类型添加学习提醒页面
func AddStudyTipView(type:Int){
    if type == 3 {
        UserInfo.getSharedInstance().homeTipStudy = false
    }else if type == 1{
        UserInfo.getSharedInstance().projectTipStudy = false
    }else if type == 0{
        UserInfo.getSharedInstance().courseTipStudy = false
    }
    let view = TipStudyView()
    view.type = type
    HQGetTopVC()?.view.addSubview(view)
    view.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    view.getNetInfo()
}

/// 在所有页面弹出消息
func HQShowForAllMsg(model:NotificationCenterGiftModel){
    if UserIsLogin() == false {
        return
    }
    ///判断是否存在动画
    if model.dynamicImage != nil && model.dynamicImage!.length > 10{
        //    判断是否在课程页面
        let temp = UserInfo.getSharedInstance().tempObj
        if temp != nil{
            
            if UserInfo.getSharedInstance().showSVGAMsg {
                let temp2 = temp as! CourseDetalisModel
                if temp2.id == model.contentId {
                    ShowSVGAView(name: model.dynamicImage!)
                }
            }
        }
    }
    
    ///不显示礼物消息
    if UserInfo.getSharedInstance().noShowGiftMsg{
        return
    }
    let gv = GiftNotiView()
    gv.model = model
    HQGetTopVC()?.view.addSubview(gv)
    gv.isHidden = true
    gv.snp.makeConstraints { make in
        make.width.equalTo(gv.myWid)
        make.height.equalTo(40)
        make.top.equalTo(175)
        make.left.equalTo(16)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        gv.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            gv.removeFromSuperview()
        }
    }
}

///获取用户余额
func GetUserAc(){
    UserInfoNetworkProvider.request(.getUserAccount) { (result) in
        switch result {
        case let .success(moyaResponse):
            do {
                let code = moyaResponse.statusCode
                if code == 200{
                    let json = try moyaResponse.mapString()
                    let model = json.kj.model(ResultModel.self)
                    if model?.code == 0 {
                        let dic = model!.data
                        if dic != nil {
                            let points = dic!["points"] as? String
                            
                            UserInfo.getSharedInstance().points = points?.toInt ?? 0
                            UserInfo.getSharedInstance().balance = dic!["balance"] as? Double ?? 0
                            UserInfo.getSharedInstance().xtb = dic!["xtb"] as? Double ?? 0
                            NotificationCenter.default.post(name: PayCompletionNotification,object: nil,userInfo: nil)
                        }
                    }
                }
            } catch {
            }
        case let .failure(error):
            logger.error("error-----",error)
        }
    }
}

///显示获得美币的提示
func ShowMeibiAddView(num:Int){
    DispatchQueue.main.async {
        let showView = UIView()
        showView.backgroundColor = .init(r: 0, g: 0, b: 0, a: 0.6)
        showView.layer.cornerRadius = 6
        showView.layer.masksToBounds = true
        let img = UIImageView.initWithName(imgName: "get_meibi")
        showView.addSubview(img)
        img.snp.makeConstraints { make in
            make.width.height.equalTo(79)
            make.top.equalTo(11)
            make.centerX.equalToSuperview()
        }
        
        let tipLab = UILabel.initSomeThing(title: "获得\(num)美币", titleColor: .white, font: .MediumFont(size: 18), ali: .center)
        showView.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
            make.top.equalTo(img.snp.bottom)
        }
        
        HQGetTopVC()?.view.addSubview(showView)
        showView.snp.makeConstraints { make in
            make.width.equalTo(132)
            make.height.equalTo(128)
            make.center.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showView.isHidden = true
            showView.removeFromSuperview()
        }
        
    }
    
    
}

///根据类型和内容跳转页面
func GotoTypeVC(type:Int,cid:String){
    if userIsNotLogin(){
        return
    }
    if type == 1 {///VIP(1, "VIP会员")
        let vc = SSMyVipViewController()
        HQPush(vc: vc, style: .lightContent)
    }else if type == 2 {//    COURSE(2, "课程详情"),
        let vc = CourseDetalisVC()
        vc.cid = cid
        HQPush(vc: vc, style: .lightContent)
    }else if type == 3 {//    PLAN(3, "方案详情"),
        let vc = ProjectDetalisVC()
        vc.cid = cid
        HQPush(vc: vc, style: .lightContent)
    }else if type == 4 {//    NOTE(4, "动态详情"),
        let vc = SSCommunityDetailViewController()
        vc.cid = cid
        var model = SSCommitModel()
        model.id = cid
        vc.dataModel = model
        HQPush(vc: vc, style: .default)
    }else if type == 5 {//    DAILY(5, "美丽日记详情"),
        let vc = SSBeautiDailyDetailViewController.init()
        vc.cid = cid
        HQPush(vc: vc, style: .default)
    }else if type == 6 {///ALBUM(6, "美丽相册详情")
        let vc = SSBeautiPhotosDetailViewController()
        vc.cid = cid
        HQPush(vc: vc, style: .default)
    }else if type == 7 {///TOP_QUALITY(7, "个人主页")
        let vc = SSPersionDetailViewController.init()
        vc.cid = cid
        HQPush(vc: vc, style: .lightContent)
    }else if type == 8 {///TOP_QUALITY(8, "优质机构榜")
        let vc = GoodMasterController()
        vc.setupWithType(type: 2)
        HQPush(vc: vc, style: .lightContent)
    }else if type == 9 {///TOP_QUALITY(7, "优质教师榜")
        let vc = GoodMasterController()
        vc.setupWithType(type: 1)
        HQPush(vc: vc, style: .lightContent)
    }else if type == 10{ //    PRETTY_CURRENCY_TASK(10, "美币任务"),
        HQPush(vc: SSBeautiBillTaskViewController(),style: UIStatusBarStyle.lightContent)
    }else if type == 11{//    PRETTY_CURRENCY_BOX(11, "美币魔盒"),
//        let vc = SSBeautiBillBoxViewController.init()
//        vc.point = UserInfo.getSharedInstance().points
//        HQPush(vc: vc,style: UIStatusBarStyle.lightContent)
    }else if type == 12{  //    PUBLISH_NOTE(12, "发布动态"),
        let vc = SSReleaseNewsViewController()
        HQPush(vc: vc,style: .default)
    }else if type == 13{ //    GIFT_ROOM(13, "礼物间"),
        let vc = SSMyGiftRoomController()
        HQPush(vc: vc, style: .default)
    }else if type == 14{ //    INDEX(14,"首页"),
        HQPushToRootIndex(index: 0)
    }else if type == 15{ //    SHARE(15,"分享"),
        let vc = ShareVC()
        vc.type = 1
        vc.onlyShare = true
        vc.setupMainView()
        HQPush(vc: vc, style: .lightContent)
    }else if type == 16{  //    COURSE_INDEX(16,"课程首页"),
        HQPushToRootIndex(index: 1)
    }else if type == 17{ //    PLAN_INDEX(17,"方案首页"),
        HQPushToRootIndex(index: 2)
    }else if type == 18{ //    MY_COURSE(18,"我的课程"),
        let vc = SSGiftViewController()
        vc.title = "我的课程"
        vc.inType = 1
        vc.segTitles = ["全部","未完成","已完成"]
        HQPush(vc: vc, style: .default)
    }else if type == 19{//    MY_PLAN(19,"我的方案"),
        let vc = SSGiftViewController()
        vc.title = "我的方案"
        vc.inType = 2
        vc.segTitles = ["全部","未完成","已完成"]
        HQPush(vc: vc, style: .default)
    }else if type == 99{//   个人主页
//        if cid == "-1" {
//            DispatchQueue.main.async {
//                HQGetTopVC()?.view.makeToast("无法查找此用户信息")
//            }
//            return
//        }
        let vc = SSPersionDetailViewController.init()
        vc.cid = cid
        HQPush(vc: vc, style: .lightContent)
    }else if type == 20{ //    NOTE_INDEX(20,"社区"),
        HQPushToRootIndex(index: 3)
    }else if type == 21{ //    BADGE(21,"我的徽章"),
        let vc = SSMyBadgeViewController()
        HQPush(vc: vc, style: .lightContent)
    }else if type == 22{  //    VERIFY(22,"我要认证"),
        let vc = SSMyProveSelectViewController()
        //不是tabbar就不传
        vc.hidesBottomBarWhenPushed = true
        HQPush(vc: vc, style: .default)
    }else if type == 23{ //    PUBLISH_COURSE_PLAN(23,"发布课程/方案"),
        let vc = SSMySendCourseController()
        //type 0: 发布课程 1: 发布方案
         vc.type = 0
         HQPush(vc: vc, style: .default)
    }else if type == 24{  //    SIGN(24,"签到页面")
        let qianDaoView = QianDaoDetalisView()
        HQGetTopVC()?.view.addSubview(qianDaoView)
        qianDaoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }else if type == 25{  //跳转到徽章墙
        let vc = SSMyBadgeViewController()
        HQPush(vc: vc, style: .lightContent)
    }
}


func PayWithProductId(pid : String){
    DispatchQueue.main.async {
        let mainView = HQGetTopVC()?.view
        if mainView != nil{
            MBProgressHUD.showAdded(to: mainView!, animated: true)
            mainView!.makeToast("正在发起请求,请稍候")
        }
        
    }
    //通过product id 购买商品
    SwiftyStoreKit.purchaseProduct(pid, quantity: 1, atomically: false) { result in
        DispatchQueue.main.async {
            let mainView = HQGetTopVC()?.view
            if mainView != nil{
                MBProgressHUD.hide(for: mainView!, animated: true)
            }
        }
        switch result {
        case .success(let product):
            //atomically true 表示走服务器获取最后支付结果
//                if product.needsFinishTransaction {
//                    SwiftyStoreKit.finishTransaction(product.transaction)
//                }
            ///获取支付凭证
            let receiptURL = Bundle.main.appStoreReceiptURL
            let receiptData = NSData(contentsOf: receiptURL!)
            let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            if encodeStr?.length != 0 {
                let userTokenKey = DefaultsKey<String?>(ipaOrderKeyString)
                Defaults[key: userTokenKey] = encodeStr
                checkPayId(pid: encodeStr ?? "")
            }else{
                DispatchQueue.main.async {
                    let mainView = HQGetTopVC()?.view
                    if mainView != nil{
                        mainView!.makeToast("获取支付凭证失败")
                    }
                }
            }
            SwiftyStoreKit.finishTransaction(product.transaction)
            
        case .error(let error):
            switch error.code {
            case .unknown: print("Unknown error. Please contact support")
            case .clientInvalid: print("Not allowed to make the payment")
            case .paymentCancelled: break
            case .paymentInvalid: print("The purchase identifier was invalid")
            case .paymentNotAllowed: print("The device is not allowed to make the payment")
            case .storeProductNotAvailable: print("The product is not available in the current storefront")
            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
            case .privacyAcknowledgementRequired:
                print("privacyAcknowledgementRequired")
            case .unauthorizedRequestData:
                print("unauthorizedRequestData")
            case .invalidOfferIdentifier:
                print("invalidOfferIdentifier")
            case .invalidSignature:
                print("invalidSignature")
            case .missingOfferParams:
                print("missingOfferParams")
            case .invalidOfferPrice:
                print("invalidOfferPrice")
            case .overlayCancelled:
                print("overlayCancelled")
            case .overlayInvalidConfiguration:
                print("overlayInvalidConfiguration")
            case .overlayTimeout:
                print("overlayTimeout")
            case .ineligibleForOffer:
                print("ineligibleForOffer")
            case .unsupportedPlatform:
                print("unsupportedPlatform")
            case .overlayPresentedInBackgroundScene:
                print("overlayPresentedInBackgroundScene")
            @unknown default:
                print("privacyAcknowledgementRequired")
            }
        }
    }
}

///向后台发起订单校验
func checkPayId(pid:String) {
    let isSanbox = (UserInfo.getSharedInstance().version ?? 0) < (UserInfo.getSharedInstance().appVersion ?? 0)
    CourseNetworkProvider.request(.iosPay(receipt: pid, type: isSanbox ? 0 : 1)) { result in
        switch result {
        case let .success(moyaResponse):
            do {
                let code = moyaResponse.statusCode
                if code == 200{
                    let json = try moyaResponse.mapString()
                    let model = json.kj.model(ResultBoolModel.self)
                    if model?.code == 0 {
                        ///删除本地凭证
                        let userTokenKey = DefaultsKey<String?>(ipaOrderKeyString)
                        Defaults[key: userTokenKey] = ""
                        DispatchQueue.main.async {
                            let mainView = HQGetTopVC()?.view
                            if mainView != nil{
                                mainView!.makeToast("充值完成")
                            }
                        }
                        GetUserAc()
                    }
                }
            } catch {
                
            }
        case let .failure(error):
            logger.error("error-----",error)
        }
    }
}

///根据类型和内容跳转页面
func GetPushTypeName(type:Int)-> String{
    if type == 1 {///VIP(1, "VIP会员")
        return "VIP会员"
    }else if type == 2 {//    COURSE(2, "课程详情"),
        return "课程"
    }else if type == 3 {//    PLAN(3, "方案详情"),
        return "方案"
    }else if type == 4 {//    NOTE(4, "动态详情"),
        return "动态"
    }else if type == 5 {//    DAILY(5, "美丽日记详情"),
        return "美丽日记"
    }else if type == 6 {///ALBUM(6, "美丽相册详情")
        return "美丽相册"
    }else if type == 7 {///TOP_QUALITY(7, "个人主页")
        return "个人主页"
    }else if type == 8 {///TOP_QUALITY(8, "优质机构榜")
        return "优质机构榜"
    }else if type == 9 {///TOP_QUALITY(7, "优质教师榜")
        return "优质教师榜"
    }else if type == 10{ //    PRETTY_CURRENCY_TASK(10, "美币任务"),
        return "美币任务"
    }else if type == 11{//    PRETTY_CURRENCY_BOX(11, "美币魔盒"),
        return "美币魔盒"
    }else if type == 12{  //    PUBLISH_NOTE(12, "发布动态"),
        return "发布动态"
    }else if type == 13{ //    GIFT_ROOM(13, "礼物间"),
        return "礼物间"
    }else if type == 14{ //    INDEX(14,"首页"),
        return "首页"
    }else if type == 15{ //    SHARE(15,"分享"),
        return "分享"
    }else if type == 16{  //    COURSE_INDEX(16,"课程首页"),
        return "课程首页"
    }else if type == 17{ //    PLAN_INDEX(17,"方案首页"),
        return "方案首页"
    }else if type == 18{ //    MY_COURSE(18,"我的课程"),
        return "我的课程"
    }else if type == 19{//    MY_PLAN(19,"我的方案"),
        return "我的方案"
    }else if type == 99{//   个人主页
        return "个人主页"
    }else if type == 20{ //    NOTE_INDEX(20,"社区"),
        return "社区"
    }else if type == 21{ //    BADGE(21,"我的徽章"),
        return "我的徽章"
    }else if type == 22{  //    VERIFY(22,"我要认证"),
        return "我要认证"
    }else if type == 23{ //    PUBLISH_COURSE_PLAN(23,"发布课程/方案"),
        return "发布课程/方案"
    }else if type == 24{  //    SIGN(24,"签到页面")
        return "签到页面"
    }
    return "未知"
}

///是否安装软件
///0微信 1支付宝 2QQ
func CheckAppInstalled(type:Int)->Bool{
    
    if type == 0 {
        ///判断是否安装微信
        if !WXApi.isWXAppInstalled() {
            SCLAlertView().showError("温馨提示", subTitle: "您的手机未安装微信APP，请前往苹果应用商店下载后分享")
            return false
        }
    }
    if type == 1 {

    }
    if type == 2 {
        if !UIApplication.shared.canOpenURL(URL.init(string: "mqq://")!) {
            SCLAlertView().showError("温馨提示", subTitle: "您的手机未安装QQAPP，请前往苹果应用商店下载后分享")
            return false
        }
    }
    return true
}

func HQPushToRootIndex(index:Int){
    HQGetTopVC()?.navigationController?.tabBarController?.selectedIndex = index
    HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
}

func isFirstOpen()-> Bool{
    //判断是否第一次启动
    let isFristKey = DefaultsKey<String?>(isFristKeyString)
    let isFrist = Defaults[key: isFristKey]
    if isFrist == nil{
        ///隐藏底部拦
        HQGetTopVC()?.tabBarController?.tabBar.isHidden = true
        let imgArray = ["guide_img1","guide_img2","guide_img3"]
        let guideView = GuidePageView.init(frame: UIScreen.main.bounds, images: imgArray, isHiddenSkipBtn: true, isHiddenStartBtn: false) {
            
        } startCompletion: {
            let vc : LoginController? = HQGetTopVC() as? LoginController
            if vc != nil{
                vc?.setupCUCMLogin()
            }
        }
        
        HQGetTopVC()?.view.addSubview(guideView)
        return true
    }
    return false
}
///用户是否登录
func UserIsLogin()->Bool{
    let userTokenKey = DefaultsKey<String?>(userTokenKeyString)
    let userToken = Defaults[key: userTokenKey]
    
    //    return true
    if userToken == nil || userToken!.length<1{
        return false
    }else{
        UserInfo.getSharedInstance().token = userToken
        let userIDKey = DefaultsKey<String?>(userIDKeyString)
        let userID = Defaults[key: userIDKey]
        let nameKey = DefaultsKey<String?>(nameKeyString)
        let name = Defaults[key: nameKey]
        let headKey = DefaultsKey<String?>(headKeyString)
        let head = Defaults[key: headKey]
        let userTypeKey = DefaultsKey<Int?>(userTypeKeyString)
        let userType = Defaults[key: userTypeKey]
        let userPhoneKey = DefaultsKey<String?>(userPhoneKeyString)
        let userPhone = Defaults[key: userPhoneKey]
        UserInfo.getSharedInstance().userId = userID
        UserInfo.getSharedInstance().nickName = name
        UserInfo.getSharedInstance().headImage = head
        UserInfo.getSharedInstance().mobile = userPhone
        UserInfo.getSharedInstance().type = userType ?? 0
        SensorsAnalyticsSDK.sharedInstance()?.login(userPhone ?? "")
    }
    return true
}

///判断是否为游客模式，如果是，进入登录页面
func userIsNotLogin()->Bool{
    if UserInfo.getSharedInstance().token == userDefultToken{
        HQPushToRootIndex(index: 0)
        PushToLogin()
        return true
    }
    return false
}

func ShowSVGAView(name:String){
    let player = SVGAPlayer()
    player.backgroundColor = .clear
    HQGetTopVC()?.view.addSubview(player)
    player.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    player.delegate = UIApplication.shared.delegate as! AppDelegate
    player.loops = 1
    player.clearsAfterStop = true
    let parser = SVGAParser.init()
    
    ///播放网络动画
    parser.parse(with: URL.init(string: name)!, completionBlock: { videoItem in
        if videoItem != nil{
            player.videoItem = videoItem
            player.startAnimation()
        }else{
            print("无法开始动画")
        }
        
    },failureBlock: nil)
    
    let closeBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "gift_close"))
    player.addSubview(closeBtn)
    closeBtn.snp.makeConstraints { make in
        make.width.height.equalTo(48)
        make.right.equalTo(-16)
        make.top.equalTo(88)
    }
    closeBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
        player.stopAnimation()
        closeBtn.removeFromSuperview()
        player.removeFromSuperview()
    }
    ///发送收到礼物通知
    NotificationCenter.default.post(name: ProjectIsSendGiftNotification,object: nil,userInfo: nil)
}

///用户会员状态
func UserVipState()->UserVipType{
    if UserInfo.getSharedInstance().vip!{
        return .isVip
    }else if (UserInfo.getSharedInstance().vipDays ?? 0) > 0{
        return .loseVip
    }
    return .notVip
}

///将view 转换成图像
func getImageFromView(view:UIView) ->UIImage{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)

        view.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
}

/// 退出并跳转登录页面
func PushToLogin(){
    if UserInfo.getSharedInstance().isInLoginVC == true {
        return
    }
    UserInfo.getSharedInstance().isInLoginVC = true
    let userNameKey = DefaultsKey<String?>(userNameKeyString)
    Defaults[key: userNameKey] = ""
    let userPassKey = DefaultsKey<String?>(userPassKeyString)
    Defaults[key: userPassKey] = ""
    let userTokenKey = DefaultsKey<String?>(userTokenKeyString)
    Defaults[key: userTokenKey] = userDefultToken
    let vc = LoginController()
    vc.hidesBottomBarWhenPushed = true
    HQGetTopVC()?.navigationController?.pushViewController(vc, animated: true)
}

func HQPush(vc:UIViewController,style:UIStatusBarStyle){
    DispatchQueue.main.async {
        if userIsNotLogin(){
            return
        }
        vc.hidesBottomBarWhenPushed = true
        UIApplication.shared.statusBarStyle = style
        HQGetTopVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

///获取版本号
func getVersion(){
    NetworkProvider.request(.appVersion) { result in
        switch result{
        case let .success(moyaResponse):
            do {
                let code = moyaResponse.statusCode
                if code == 200{
                    let json = try moyaResponse.mapString()
                    let model = json.kj.model(ResultModel.self)
                    if model?.code == 0 {
                        let dic = model?.data
                        let version = dic?["version"] as? String
                        UserInfo.getSharedInstance().version = version?.toDouble
                    }   
                }
            }catch {
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
        }
    }
}

func getNumString(num : Double) -> String {
    var str = "0"
    if num >= 100000{
        str = "10万+"
    }else if num > 10000 {
        str = String.init(format: "%.1f万",num / 10000.0 )
    }else{
        str = String.init(format: "%.0f",num)
    }
    return str
}

func HQGetTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    //是否为当前显示的window
    if window?.windowLevel != UIWindow.Level.normal{
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal{
                window = windowTemp
                break
            }
        }
    }
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}

///根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    if VC == nil {
        print("🌶： 找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    }else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}

extension UIImageView{
    class func initWithName(imgName:String)->UIImageView{
        let imgV = UIImageView.init(image: UIImage.init(named: imgName))
        return imgV
    }
}

extension String{
    func formatWithData(dateFormat:String)->String{
        if self.length == 0 {
            return ""
        }
        let fm = DateFormatter()
        fm.dateFormat = dateFormat
        return fm.string(from: Date.init(timeIntervalSince1970: TimeInterval.init(self)! / 1000))
    }
    /**
     *   解码
     */
    func base64Decoding()->String{
        let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
    public func getHei(font:UIFont,lineHei:CGFloat,wid:CGFloat) -> CGFloat{
        let bs = BSLabel()
        let line = TextLinePositionSimpleModifier()
        line.fixedLineHeight = lineHei
        bs.text = self
        bs.linePositionModifier = line
        bs.font = font
        bs.numberOfLines = 0
        bs.snp.makeConstraints { (make) in
            make.width.equalTo(wid)
        }
        bs.sizeToFit()
        return bs.bounds.size.height
    }
    
    func ga_heightForComment(font: UIFont, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    
    //    生成二维码图片
    public func creatQRImage(size: CGFloat) -> UIImage? {
        let strData = self.data(using: .utf8, allowLossyConversion: false)
        // 创建一个二维码的滤镜
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(strData, forKey: "inputMessage")
        qrFilter.setValue(size <= 150 ? "L" : "H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter.outputImage
        // 创建一个颜色滤镜,黑白色
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.black, forKey: "inputColor0")
        colorFilter.setValue(CIColor.white, forKey: "inputColor1")
        
        guard let outputImage = colorFilter.outputImage else { return nil }
        let scale = size / outputImage.extent.size.width
        let image_tr = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let qrImage = UIImage(ciImage: image_tr)
        return qrImage
    }
}

extension UILabel{
    class func initSomeThing(title:String,fontSize:CGFloat,titleColor:UIColor)->UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = UIFont.systemFont(ofSize: fontSize)
        lab.textColor = titleColor
        return lab
    }
    
    class func initSomeThing(title:String,isBold:Bool,fontSize:CGFloat,textAlignment:NSTextAlignment,titleColor:UIColor)->UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.textAlignment = textAlignment
        lab.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        lab.textColor = titleColor
        return lab
    }
    
    class func initSomeThing(title:String,titleColor:UIColor,font:UIFont,ali:NSTextAlignment)->UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = font
        lab.textColor = titleColor
        lab.textAlignment = ali
        return lab
    }
    
    class func initWordSpace(title:String,titleColor:UIColor,font:UIFont,ali:NSTextAlignment,space:CGFloat)->UILabel{
        let lab = UILabel.init()
        lab.text = title
        lab.font = font
        lab.changeWordSpace(space: space)
        lab.textColor = titleColor
        lab.textAlignment = ali
        return lab
    }
    
    /**  改变行间距  */
    func changeLineSpace(space:CGFloat) {
        if self.text == nil || self.text == "" {
            return
        }
        let text = self.text
        let attributedString = NSMutableAttributedString.init(string: text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: (text?.length)!))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    
    /**  改变字间距  */
    func changeWordSpace(space:CGFloat) {
        if self.text == nil || self.text == "" {
            return
        }
        let text = self.text
        let attributedString = NSMutableAttributedString.init(string: text!, attributes: [NSAttributedString.Key.kern:space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: (text?.length)!))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    
    /**  改变字间距和行间距  */
    func changeSpace(lineSpace:CGFloat, wordSpace:CGFloat) {
        if self.text == nil || self.text == "" {
            return
        }
        let text = self.text
        let attributedString = NSMutableAttributedString.init(string: text!, attributes: [NSAttributedString.Key.kern:wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: (text?.length)!))
        self.attributedText = attributedString
        self.sizeToFit()
        
    }
}

extension UIControl {
    
    class func initWithImageAndTitleWithNum(imgName:String, titleStr:String, titleColor:UIColor, font:UIFont, imageWidth:CGFloat, num:String) -> UIControl {
        let control = UIControl.init()
        let image = UIImageView.initWithName(imgName: imgName)
        control.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageWidth)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        let titleLab = UILabel.initSomeThing(title: titleStr, titleColor: titleColor, font: font, ali: .center)
        control.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(image.snp.bottom).offset(5)
        }
        
        let noteLabel = UILabel.initSomeThing(title: num, isBold: false, fontSize: 9, textAlignment: .center, titleColor: .white)
        noteLabel.backgroundColor = .red
        noteLabel.layer.masksToBounds = true
        noteLabel.layer.cornerRadius = 5
        control.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(image.snp.top).offset(-5)
            make.right.equalTo(image.snp.right).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(12)
        }
        noteLabel.isHidden = true
        return control
    }
    
    class func initWithImageAndTitle(imgName:String, titleStr:String, titleColor:UIColor, font:UIFont, imageWidth:CGFloat) -> UIControl {
        let control = UIControl.init()
        let image = UIImageView.initWithName(imgName: imgName)
        control.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageWidth)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        let titleLab = UILabel.initSomeThing(title: titleStr, titleColor: titleColor, font: font, ali: .center)
        control.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(image.snp.bottom).offset(5)
        }
        
        return control
    }
    
    class func initWithIconAndTitle(imgName:String, titleStr:String) -> UIControl {
        let control = UIControl.init()
        let image = UIImageView.initWithName(imgName: imgName)
        control.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.left.equalTo(10)
        }
        
        let titleLab = UILabel.initSomeThing(title: titleStr, titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), ali: .left)
        control.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(image.snp.right).offset(12)
            make.height.equalTo(20)
        }
        
        let iceImage = UIImageView.initWithName(imgName: "my_newice")
        control.addSubview(iceImage)
        iceImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        let line = UIImageView.init()
        line.backgroundColor = .init(hex: "#EEEFF0")
        control.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
        return control
    }
    
}

extension UIButton{
    ///生成返回按钮
    class func initWithBackBtn(isBlack:Bool)->UIButton{
        return UIButton.initImgv(imgv: .initWithName(imgName: isBlack ? "back_black" : "back_white"))
    }
    
    class func initTopImgBtn(imgName:String,titleStr:String,titleColor:UIColor,font:UIFont,imgWid:CGFloat)->UIButton{
        let btn = UIButton.init()
        let img = UIImageView.initWithName(imgName: imgName)
        btn.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.width.height.equalTo(imgWid)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        let titleLab = UILabel.initSomeThing(title: titleStr, titleColor: titleColor, font: font, ali: .center)
        titleLab.adjustsFontSizeToFitWidth = true
        btn.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.bottom.equalTo(0)
        }
        return btn
    }
    
    class func initRightImg(imgName:String,titleStr:String,titleColor:UIColor,font:UIFont,imgWid:CGFloat)->UIButton{
        let btn = UIButton.init()
        let img = UIImageView.initWithName(imgName: imgName)
        btn.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.width.height.equalTo(imgWid)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        let titleLab = UILabel.initSomeThing(title: titleStr, titleColor: titleColor, font: font, ali: .left)
        btn.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(img.snp.left)
            make.top.equalTo(0)
        }
        return btn
    }
    ///根据标题文本生成按钮
    class func initImgv(imgv : UIImageView)->UIButton{
        let btn = UIButton.init()
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        return btn
    }
    ///根据标题文本生成按钮
    class func initTitle(title:String,fontSize:CGFloat,titleColor:UIColor)->UIButton{
        let btn = UIButton.init()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(titleColor, for: .normal)
        return btn
    }
    
    ///根据标题文本生成按钮
    class func initTitle(title:String,font:UIFont,titleColor:UIColor,bgColor:UIColor)->UIButton{
        let btn = UIButton.init()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = font
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = bgColor
        return btn
    }
    
    ///根据标题文本生成按钮
    class func initTitle(title:String,fontSize:CGFloat,titleColor:UIColor,bgColor:UIColor)->UIButton{
        let btn = UIButton.init()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = bgColor
        return btn
    }
    
    ///返回顶部为图片底部为文字的按钮
    class func initImgAndTitle(img:UIImage,title:String,fontSize:CGFloat,titleColor:UIColor,imgSize:CGSize,textHei:CGFloat,topSpace:CGFloat) -> UIButton{
        let btn = UIButton.init()
        let imgV = UIImageView.init(image: img)
        btn.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.width.equalTo(imgSize.width)
            make.height.equalTo(imgSize.height)
            make.centerX.equalToSuperview()
            make.top.equalTo(topSpace)
        }
        
        
        
        let lab = UILabel.initSomeThing(title: title, fontSize: fontSize, titleColor: titleColor)
        btn.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(textHei)
        }
        return btn
    }
    class func initBGImgAndTitle(img:UIImage,title:String,font:UIFont,titleColor:UIColor,space:CGFloat) -> UIButton{
        let btn = UIButton.init()
        let imgV = UIImageView.init(image: img)
        btn.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        btn.titleLabel?.font = font
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.textColor = titleColor
        btn.titleLabel?.changeWordSpace(space: space)
        btn.titleLabel?.textAlignment = .center
        return btn
    }
    
    class func initBgImage(imgname: String)->UIButton{
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: imgname), for: .normal)
        return btn
    }
    
    class func initBackgroudImage(imgname: String)->UIButton{
        let btn = UIButton.init()
        btn.setBackgroundImage(UIImage.init(named: imgname), for: .normal)
        return btn
    }
    
    ///根据标题文本生成按钮
    class func initWithLineBtn(title:String,font:UIFont,titleColor:UIColor,bgColor:UIColor,lineColor:UIColor,cr:CGFloat)->UIButton{
        let btn = UIButton.init()
        btn.backgroundColor = lineColor
        btn.layer.cornerRadius = cr
        btn.layer.masksToBounds = true
        let titleLab = UILabel.initSomeThing(title: title, titleColor: titleColor, font: font, ali: .center)
        titleLab.backgroundColor = bgColor
        titleLab.layer.cornerRadius = cr - 2
        titleLab.layer.masksToBounds = true
        btn.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.top.equalTo(1)
            make.bottom.right.equalTo(-1)
        }
        return btn
    }
}

extension UIFont {
    class func MediumFont(size:CGFloat)->UIFont{
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight(rawValue: 0.23))
    }
    
    class func SemiboldFont(size:CGFloat)->UIFont{
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight(rawValue: 0.3))
    }
    
    class func RegularFont(size:CGFloat)->UIFont{
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight(rawValue: 0))
    }
}


extension WKWebView{
    class func initHtmlStr(str:String)->WKWebView{
        let wk = WKWebView()
        wk.loadHTMLString(str, baseURL: nil)
        return wk
    }
}

extension NSDate {
    class func compareStartDateEndDate(startDate:String, endDate:String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let sDate:Date = formatter.date(from: startDate)!
        let eDate:Date = formatter.date(from: endDate)!
        
        let result:ComparisonResult = sDate.compare(eDate)
        if result == ComparisonResult.orderedAscending{
            return true
        } else {
            return false
        }
    }
    
    class func nowDateString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        return dateformatter.string(from: Date())
    }
}

