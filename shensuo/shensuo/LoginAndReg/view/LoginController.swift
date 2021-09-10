//
//  LoginController.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/16.
//  登录主页面

import UIKit
import MBProgressHUD
import SwiftyUserDefaults
import SensorsAnalyticsSDK

class LoginController: HQBaseViewController {
    var needPush = true
    let mainView = LoginNewMainView.init()
    ///本机登录SDK
    let manager = NTESQuickLoginManager.sharedInstance()
    
    var loginModel : NTESQuickLoginModel = NTESQuickLoginModel()
    
    var token = ""
    var assToken = ""
    var securityPhone = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let flag = isFirstOpen()
        if !flag {
            ///能否一键登录
            self.setupCUCMLogin()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(pushToNameAndPass), name: NSNotification.Name(rawValue: pushToPassNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushToUserDefult), name: NSNotification.Name(rawValue: pushToUserDefultNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserInfo.getSharedInstance().isInLoginVC = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    deinit {
        UserInfo.getSharedInstance().isInLoginVC = false
//        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
//    /**  微信通知 登录 */
//    @objc func WXLoginSuccess(notification:Notification){
//        let code = notification.object as! String
//        UserNetworkProvider.request(.loginWX(code: code)) { result in
//            switch result{
//            case let .success(moyaResponse):
//                do {
//                    let code = moyaResponse.statusCode
//                    if code == 200{
//                        let json = try moyaResponse.mapString()
//                        let model = json.kj.model(ResultModel.self)
//                        if model?.code == 0 {
//                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
//                            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
//                        }else{
//
//                        }
//                    }
//
//                }catch {
//
//                }
//            case .failure(_):
//                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
//
//            }
//        }
//    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    ///初始化一键登录
    func setupCUCMLogin(){
        let canQuickLogin = manager.shouldQuickLogin()
        if canQuickLogin {
            //            可以使用快捷登录
            manager.register(withBusinessID: CUCMKey)
            manager.getPhoneNumberCompletion { [weak self] resultDic in
                let boolNum = resultDic["success"] as? NSNumber
                let success = boolNum?.boolValue ?? false
                if success{
                    self?.token = resultDic["token"] as? String ?? ""
                    self?.securityPhone = resultDic["securityPhone"] as? String ?? ""
                    if self?.needPush == true {
                        self?.needPush = false
                        DispatchQueue.main.async {
                            self!.enterToCUCMLogin()
                        }
                    }
                    
                }else{
                    //                    "获取脱敏手机号失败"
                }
            }
        }else{
            //            "不可以使用快捷登录"
        }
    }
    
    func enterToCUCMLogin(){
        self.loginModel = NTESQLHomePageCustomUIModel.getInstance().configCustomUIModel(0, withType: 0, face: .portrait)
        self.loginModel.currentVC = self

        self.manager.setupModel(self.loginModel)
        
        self.manager.cucmctAuthorizeLoginCompletion { [weak self] resultDic in
            let boolNum = resultDic["success"] as? NSNumber
            let success = boolNum?.boolValue ?? false
            if success{
                self?.assToken = resultDic["accessToken"] as? String ?? ""
                self?.requestLogin()
            }else {
            }
        }
    }
    
    func requestLogin(){
        UserNetworkProvider.request(.CUCMLogin(accessToken: self.assToken, token: self.token)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            
                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                            NTESQuickLoginManager.sharedInstance().closeAuthController {
 
                            }
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            self.setupCUCMLogin()
                        }
                    }else{
                        self.setupCUCMLogin()
                    }
                } catch {
                    
                }
            case .failure(_):
                break
            }
        }
    }
    
    @objc func pushToNameAndPass(){
            let loginView = LoginPhoneView()
            HQGetTopVC()?.view.addSubview(loginView)
            loginView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        
    }
    
    @objc func pushToUserDefult(){
        self.enterToGuestLogin()
    }
    
    ///用户游客登录
    func enterToGuestLogin(){
        
        
        ///上报事件
//        HQPushActionWith(name: "click_to_get_code", dic:  ["service_type":"登录"])
    
        UserNetworkProvider.request(.iosGuestLogin) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                            let userTokenKey = DefaultsKey<String?>(userUUIDKeyString)

                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                            NTESQuickLoginManager.sharedInstance().closeAuthController {
 
                            }
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
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
