//
//  SignWithApple.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/10.
//

import UIKit
import AuthenticationServices
@available(iOS 13.0, *)
class SignWithApple: NSObject {
    
    static var shared = SignWithApple()
    
    private var callBack:((Bool,String)->Void)?
    
    //发起苹果登录
    func loginInWithApple(callBack:((Bool,String)->Void)?) {
        self.callBack = callBack
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        let appleIDProvide = ASAuthorizationAppleIDProvider()
        // 授权请求AppleID
        let appIDRequest = appleIDProvide.createRequest()
        // 在用户授权期间请求的联系信息
        appIDRequest.requestedScopes = [ASAuthorization.Scope.fullName,ASAuthorization.Scope.email]
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        let authorizationController = ASAuthorizationController.init(authorizationRequests: [appIDRequest])
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self
        // 在控制器初始化期间启动授权流
        authorizationController.performRequests()
    }
    
    // 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
    func perfomExistingAccountSetupFlows() {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        let appleIDProvide = ASAuthorizationAppleIDProvider()
        // 授权请求AppleID
        let appIDRequest = appleIDProvide.createRequest()
        // 为了执行钥匙串凭证分享生成请求的一种机制
        let passwordProvider = ASAuthorizationPasswordProvider()
        let passwordRequest = passwordProvider.createRequest()
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        let authorizationController = ASAuthorizationController.init(authorizationRequests: [appIDRequest,passwordRequest])
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self
        // 在控制器初始化期间启动授权流
        authorizationController.performRequests()
    }
    private func loginWithServer(user:String,token:String,code:String) {
        //向你的服务器验证 ,验证通过即可登录
    }
}


@available(iOS 13.0, *)
extension SignWithApple : ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    //授权成功地回调
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if authorization.credential.isKind(of: ASAuthorizationAppleIDCredential.classForCoder()) {
            // 用户登录使用ASAuthorizationAppleIDCredential
            let appleIDCredential = authorization.credential as! ASAuthorizationAppleIDCredential
            let user = appleIDCredential.user
            // 使用过授权的，可能获取不到以下三个参数
            let familyName = appleIDCredential.fullName?.familyName ?? ""
            let givenName = appleIDCredential.fullName?.givenName ?? ""
            let email = appleIDCredential.email ?? ""
            
            let identityToken = appleIDCredential.identityToken ?? Data()
            let authorizationCode = appleIDCredential.authorizationCode ?? Data()
            // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
            let realUserStatus = appleIDCredential.realUserStatus
            
            UserNetworkProvider.request(.appleLogin(identityToken: identityToken.base64EncodedString(), authorizationCode: authorizationCode.base64EncodedString(), userID: user)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                                HQGetTopVC()?.navigationController?.popViewController(animated: false)
                            }else{
                                
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
            // 服务器验证需要使用的参数
        }else if authorization.credential.isKind(of: ASPasswordCredential.classForCoder()) {
            // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
            // Sign in using an existing iCloud Keychain credential.
            // 用户登录使用现有的密码凭证
            let passworCreddential = authorization.credential as! ASPasswordCredential
            // 密码凭证对象的用户标识 用户的唯一标识
            let user = passworCreddential.user
            // 密码凭证对象的密码
            let password = passworCreddential.password
        }else{
            // "授权信息不符合"
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        var errorStr : String?
        switch (error as NSError).code {
        case ASAuthorizationError.canceled.rawValue :
            errorStr = "用户取消了授权请求"
        case ASAuthorizationError.failed.rawValue :
            errorStr = "授权请求失败"
        case ASAuthorizationError.invalidResponse.rawValue :
            errorStr = "授权请求无响应"
        case ASAuthorizationError.notHandled.rawValue :
            errorStr = "未能处理授权请求"
        case ASAuthorizationError.unknown.rawValue :
            errorStr = "授权请求失败原因未知"
        default:
            break
        }
        if let str = errorStr {
            callBack?(false,str)
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last ?? ASPresentationAnchor()
    }
}
