//
//  UserApiManage.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/13.
//

import UIKit
import Moya
import SwiftyUserDefaults

// NetworkAPI就是一个遵循TargetType协议的枚举
let UserNetworkProvider = MoyaProvider<UserApiManage>(plugins: [
    VerbosePlugin(verbose: true)
    ])

enum UserApiManage {
    // 用户登录
    case login(userName:String,password:String)
    case appleLogin(identityToken:String,authorizationCode:String,userID:String)
    case regist(areaCode:String,mobile:String,password:String,code:String)
    case checkCode(areaCode:String,mobile:String,code:String)
    case sendCode(areaCode:String,phone:String,isReg:Bool)
    case resetPass(areaCode:String,mobile:String,code:String,password:String)
    case loginWX(code:String)
    case vipInfo
    case areaCode
    ///签到
    case sign
    case signNow
    ///一键登录
    case CUCMLogin(accessToken:String,token:String)
    ///验证码登录
    case loginBySMS(areaCode:String,mobile:String,code:String)
    case vipCallback(oid:String)
    case getUserInfo
    case vipPrice(sid:String)
    case QRCode
    case setBgImage(bgImage:String)
    ///余额方式开通会员
    case balanceOpen(couponsId:String)
    ///ios游客登录
    case iosGuestLogin
}

extension UserApiManage:TargetType{
    public var baseURL: URL{
        return URL(string: baseUrl)!
//        return URL(string: "http://192.168.0.175:9000")!
//        switch self {
//        case .login,.homeBananer:
//
//        }
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .login: return "/user-service/login"
        case .appleLogin: return "/user-service/login/apple"
        case .resetPass: return "/user-service/reset/password"
        case .regist: return "/user-service/register/mobile"
        case .sendCode: return "/user-service/sms/sendAPP"
        case .checkCode: return "/user-service/sms/check"
        case .loginWX: return "/user-service/login/weixin"
        case .vipInfo: return "/user-service/user/vip/query/my/vipInfo"
        case .areaCode: return "/public-service/areaCode/list"
        case .sign: return "/user-service/user/sign/get"
        case .signNow: return "/user-service/user/sign"
        case .CUCMLogin: return "/user-service/login/oneClickLogin"
        case .loginBySMS: return "/user-service/login/loginBySMS"
        case .vipCallback: return "/user-service/vip/callback/callback"
        case .getUserInfo: return "/user-service/user/app/userInfo"
        case .vipPrice: return "/user-service/user/vip/query/discounted/money"
        case .QRCode: return "/user-service/user/app/getQRCode"
        case .setBgImage: return "/user-service/user/app/setBgImage"
        case .balanceOpen : return "/user-service/user/vip/operation/apple/open"
        case .iosGuestLogin : return "/user-service/login/iosGuestLogin"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        switch self {
            default:
                return .post
        }
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .login(let name,let pass):
            let rid = JPUSHService.registrationID()
            parmeters = ["mobile":name,
                         "password":pass,
                         "code":"123",
                         "device":rid ?? "124567"] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .loginWX(let code):
            let rid = JPUSHService.registrationID()
            parmeters = ["code":code,
                         "device":rid ?? "124567"] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .appleLogin(let identityToken,let authorizationCode,let userID):
            let rid = JPUSHService.registrationID()
            parmeters = ["authorizationCode":authorizationCode,
                         "identityToken":identityToken,
                         "userID":userID,
                         "device":rid ?? "00000000"] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .sendCode(let areaCode,let phone,let isReg):
            let key = sendCodeKey + phone
            parmeters = ["areaCode":areaCode,
                         "mobile":phone,
                         "register":(isReg ? 1 : 0),
                         "sign":key.md5] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .resetPass(let areaCode,let mobile,let code,let password):
            parmeters = ["areaCode":areaCode,
                         "mobile":mobile,
                         "password":password,
                         "code":code] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .checkCode(let areaCode,let mobile,let code):
            parmeters = ["areaCode":areaCode,
                         "mobile":mobile,
                         "code":code] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .regist(let areaCode,let mobile,let password,let code):
            parmeters = ["areaCode":areaCode,
                         "mobile":mobile,
                         "password":password,
                         "code":code] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .vipInfo:
            return .requestPlain
        case .areaCode:
            return .requestPlain
        case .sign:
            return .requestPlain
        case .signNow:
            return .requestPlain
        case .CUCMLogin(let accessToken,let token):
            let rid = JPUSHService.registrationID()
            parmeters = ["accessToken":accessToken,
                         "token":token,
                         "device":rid ?? "124567"] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .loginBySMS(let areaCode,let mobile,let code):
            let rid = JPUSHService.registrationID()
            parmeters = ["areaCode":areaCode,
                         "phone":mobile,
                         "code":code,
                         "device":rid ?? "124567"]as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .vipCallback(let oid):
            parmeters = ["orderId":oid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getUserInfo:
            parmeters = ["userId":UserInfo.getSharedInstance().userId ?? ""] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .vipPrice(let sid):
            parmeters = ["couponsId":sid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .QRCode:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .setBgImage(let bgImage):
            parmeters = ["bgImage":bgImage] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .balanceOpen(let couponsId):
            parmeters = ["couponsId":couponsId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .iosGuestLogin:
            let userTokenKey = DefaultsKey<String?>(userUUIDKeyString)
            var uuid = Defaults[key: userTokenKey] ?? ""
            if uuid == "" {
                uuid = UUID().uuidString
                Defaults[key: userTokenKey] = uuid
            }
            
            let rid = JPUSHService.registrationID() ?? ""
            let key = regCodeKey + uuid
            parmeters = ["uuid":uuid,
                         "device":rid,
                         "sign":key.md5] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        }
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求头
    public var headers: [String: String]? {
        switch self {
        case .areaCode,.sendCode,.regist,.resetPass,.login,.loginWX,.appleLogin,.checkCode,.CUCMLogin,.loginBySMS,.iosGuestLogin:
            return["Content-Type": "application/json"]
        case .vipInfo,.sign,.signNow,.vipCallback,.getUserInfo,.vipPrice,.QRCode,.setBgImage,.balanceOpen:
            return ["Content-Type": "application/json",
                    "Authorization" : "Bearer " + (UserInfo.getSharedInstance().token ?? "")]
        }
    }
}
