//
//  AppDelegate.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/11.
//

import UIKit
import Bugly
import IQKeyboardManagerSwift
import AMapLocationKit
import SensorsAnalyticsSDK
import SwiftyUserDefaults
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    ///是否已经上传定位
    var hasLocation = false
    
    var tabVC : BaseTabVC!
    
    var blockRotation: UIInterfaceOrientationMask = .portrait{
        didSet{
            let orientation = UIDevice.current.orientation
            if blockRotation.contains(.portrait){
                if orientation == .landscapeLeft{
                    //强制设置成竖屏
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }else{
                    //强制设置成竖屏
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
            }else{
                if orientation == .landscapeLeft{
                    //强制设置成横屏
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                }else{
                    //强制设置成横屏
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                }
            }
        }
    }
    
    let api = ImgUploadApi()
    var window: UIWindow?
    let aMapManage = AMapLocationManager.init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vid = weChatId
        let vss = weChatAppSecret
        
        // see notes below for the meaning of Atomic / Non-Atomic
        
        // MARK: 应用内购
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default: break
                    
                }
            }
        }
        
        
        // MARK: 腾讯Bugly
        Bugly.start(withAppId: "143fe5c7bc")
        
        
        // MARK: 极光Push
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = Int(UNAuthorizationOptions.alert.rawValue|UNAuthorizationOptions.badge.rawValue|UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        }else {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }
        
        
        // MARK: 神策分析SensorsAnalytics
        let options = SAConfigOptions.init(serverURL: "https://apidata.qmxingti.com/sa?project=default", launchOptions: launchOptions)
//        开启 Crash 信息的自动采集
        options.enableTrackAppCrash = true
            //开启全埋点
        options.autoTrackEventType = [.eventTypeAppStart, .eventTypeAppEnd, .eventTypeAppClick, .eventTypeAppViewScreen]
        //
        //            //开启log
        //        options.enableLog = true
        //
        //        // 设置触发间隔，默认 15 * 1000 毫秒
        options.flushInterval = 10 * 1000
        //
        //        // 设置触发条数，默认 100 条
        options.flushBulkSize = 1
        //
        SensorsAnalyticsSDK.start(configOptions: options)
        //
        //        //设置上报网络策略，默认 3G、4G、5G、WiFi，注意需要初始化 SDK 之后设置
        SensorsAnalyticsSDK.sharedInstance()?.setFlushNetworkPolicy(SensorsAnalyticsNetworkType.typeALL)
        
        //Production:false表示开发测试环境 正式发布改为true
        JPUSHService.setup(withOption: launchOptions, appKey: JPushKey, channel: "app store", apsForProduction: false)
        
        
        // MARK: 极光分享
        let config = JSHARELaunchConfig.init()
        config.appKey = "cefa17a8a9b085ee269a0939"
        config.sinaWeiboAppKey = "374535501"
        config.sinaWeiboAppSecret = "baccd12c166f1df96736b51ffbf600a2"
        config.sinaRedirectUri = "https://www.jiguang.cn"
        config.qqAppId = "101960472"
        config.qqAppKey = "b4f9e411fb00cf05237550b0b4fedcb9"
        config.weChatAppId = vid
        config.weChatAppSecret = vss
        
        JSHAREService.setup(with: config)
        JSHAREService.setDebug(false)
        
        WXApi.registerApp(vid, universalLink: "https://app.quanminxingti.com/")
        
        
        // MARK: 高德地图
        AMapServices.shared()?.apiKey = AMapKey
        
        
        // MARK: app window
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        tabVC = BaseTabVC()
        self.window?.rootViewController = tabVC
        
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)), name: .jpfNetworkDidReceiveMessage, object: nil)
        
        
        let userTokenKey = DefaultsKey<String?>(userTokenKeyString)
        let userToken = Defaults[key: userTokenKey]
        if userToken == nil || userToken!.length<1{
            ///设置游客token
            Defaults[key: userTokenKey] = userDefultToken
        }
        
        
        return true
    }
    
    ///开始请求定位
    func startLocation(){
        if UserIsLogin() {
            aMapManage.requestLocation(withReGeocode: true) { (location, reGeocode, error) in
                if location != nil {
                    let lat = location?.coordinate.latitude
                    let log = location?.coordinate.longitude
                    self.updateLocation(latit: lat ?? 0, longit: log ?? 0)
                }
            }
        }
    }
    
    func updateLocation(latit:Double, longit:Double) -> Void {
        UserInfoNetworkProvider.request(.geoPost(latitude: latit, longitude: longit, userId: UserInfo.getSharedInstance().userId ?? "")) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.hasLocation = true
                        }
                    }
                } catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    @objc func networkDidReceiveMessage(notification:NSNotification){
        let userINfo = notification.userInfo
        let content : String? = userINfo?["content"] as? String
        let extras : NSDictionary? = userINfo?["extras"] as? NSDictionary
        ///礼物推送
        if content != nil && (extras == nil || extras?.allKeys.count == 0) {
            let model : NotificationCenterGiftModel? = content!.kj.model(type: NotificationCenterGiftModel.self) as? NotificationCenterGiftModel
            if model != nil && model?.giftName != nil{
                HQShowForAllMsg(model: model!)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
}

// MARK: - 微信代理
extension AppDelegate: WXApiDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        WXApi.handleOpen(url, delegate: self)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }

    func application(_application:UIApplication, open url:URL, sourceApplication:String?, annotation:Any) ->Bool{
//        if SensorsAnalyticsSDK.sharedInstance()?.handleSchemeUrl(url) ?? false{
//                   return true
//        }
        WXApi.handleOpen(url, delegate:self)
        return true
    }

    func onReq(_ req: BaseReq) {
        
    }

    func onResp(_ resp: BaseResp) {
        if resp.errCode == 0 && resp.type == 0 {//授权成功
            let response = resp as? SendAuthResp
            if response != nil {

                NetworkProvider.request(.bindingWeixin(code: response?.code ?? "")) { result in
                    switch result{
                    case let .success(moyaResponse):
                        do {
                            let code = moyaResponse.statusCode
                            if code == 200{
                                let json = try moyaResponse.mapString()
                                let model = json.kj.model(ResultModel.self)
                                if model?.code == 0 {
                                    DispatchQueue.main.async {
                                        HQGetTopVC()?.view.makeToast("绑定成功")
                                    }
                                }
                            }
                        }catch {
                        }
                    case .failure(_):
                        HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                    }
                }
            }
        }
    }
}

// MARK: - 极光推送代理
extension AppDelegate: JPUSHRegisterDelegate {
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        //        let userINfo = notification.request.content.userInfo
        //        let content : String? = userINfo["content"] as? String
        //        if content != nil {
        //            let model : NotificationCenterGiftModel? = content!.kj.model(type: NotificationCenterGiftModel.self) as? NotificationCenterGiftModel
        //            if model != nil && model?.giftName != nil{
        //                HQShowForAllMsg(model: model!)
        //            }
        //        }
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        //        let userINfo = response.notification.request.content.userInfo
        //        let content : String? = userINfo["content"] as? String
        //        if content != nil {
        //            let model : NotificationCenterGiftModel? = content!.kj.model(type: NotificationCenterGiftModel.self) as? NotificationCenterGiftModel
        //            if model != nil && model?.giftName != nil{
        //                HQShowForAllMsg(model: model!)
        //            }
        //        }
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        //        let userINfo = notification.request.content.userInfo
        //        let content : String? = userINfo["content"] as? String
        //        if content != nil {
        //            let model : NotificationCenterGiftModel? = content!.kj.model(type: NotificationCenterGiftModel.self) as? NotificationCenterGiftModel
        //            if model != nil && model?.giftName != nil{
        //                HQShowForAllMsg(model: model!)
        //            }
        //        }
    }
}

// MARK: - SVGA代理 SVGAPlayer
extension AppDelegate: SVGAPlayerDelegate {
    
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        player.stopAnimation()
        player.removeFromSuperview()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return blockRotation
    }
}
