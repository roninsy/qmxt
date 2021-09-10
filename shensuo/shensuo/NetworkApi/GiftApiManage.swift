//
//  GiftApiManage.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/13.
//

import UIKit
import Moya

// NetworkAPI就是一个遵循TargetType协议的枚举
let GiftNetworkProvider = MoyaProvider<GiftApiManage>(plugins: [
    VerbosePlugin(verbose: true)
    ])

enum GiftApiManage {
    // // 0个人,1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节
    case giftRanking(source:String,type:String,number:Int,pageSize:Int)
    case userRanking(source:String,type:String)
    case giftList
    case sendGift(giftId:String,giftQuantity:Int,receiveUserId:String,sourceId:String,type:String)
    ///查看礼物架
    case giftStand(userId:String)

}

extension GiftApiManage:TargetType{
    public var baseURL: URL{
        return URL(string: baseUrl)!
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .giftRanking: return "/gift-service/gift/app/giftRanking"
        case .giftList: return "/gift-service/gift/selectGiftForApp"
        case .sendGift: return "/gift-service/gift/gift"
        case .userRanking: return "/gift-service/gift/app/userRanking"
        case .giftStand: return "/gift-service/gift/app/giftStand"
    
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .post
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var parmeters: [String : Any] = [:]
        
        switch self {
        case .giftRanking(let source,let type,let number,let pageSize):
            let dic2 = ["sourceId":source,
                        "type":type]
            parmeters = ["data":dic2,
                         "number":number,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .giftList:
            parmeters = ["number":1,
                         "pageSize":100] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .sendGift(let giftId,let  giftQuantity,let receiveUserId,let sourceId,let type):
            parmeters = ["giftId":giftId,
                         "giftQuantity":giftQuantity,
                         "receiveUserId":receiveUserId,
                         "sourceId":sourceId,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .userRanking(let source,let type):
            parmeters = ["sourceId":source,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .giftStand(let userId):
            parmeters = ["userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
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
        return ["Content-Type": "application/json",
                "Authorization" : "Bearer " + (UserInfo.getSharedInstance().token ?? "")]
    }
}

