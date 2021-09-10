//
//  UserInfoApiManage.swift
//  shensuo
//
//  Created by  yang on 2021/4/22.
//

import UIKit
import Moya

// 个人相关接口请求
let UserInfoNetworkProvider = MoyaProvider<UserInfoApiManage>(plugins: [
    VerbosePlugin(verbose: true)
])

enum UserInfoApiManage {
    //个人信息
    case userInfo(userId:String)
    //粉丝列表
    case fansList(data:NSDictionary, pageSize:Int, number:Int)
    //关注列表
    case focusList(data:NSDictionary, pageSize:Int, number:Int)
    //黑名单
    case blackList(data:String, pageSize:Int, number:Int)
    //关注/取消关注
    case focusOption(focusUserId:String)
    //搜索关注lb
    case searchFocusList(nickName:String)
    //通讯录好友
    case addressBook(arrays:Array<Any>)
    //草稿箱列表
    case draftList(userId:String, pageNumber:Int, size:Int)
    //删除草稿
    case deletaDraft(noteId: String)
    //优惠券列表
    case selectMyExchanges(data:NSDictionary, pageNumber:Int, size:Int)
    //失效优惠券
    case selectMyExchangesEnd(pageNumber:Int, size:Int)
    case selectUsedExchange(money:Double,isVip:Bool)
    //消息列表
    case messageList(noticeType:String, pageSize:Int, number:Int, publishedTimeAsc:Bool, titleKeyword:String)
    //美币任务
    case getPointsJop
    //美币魔盒
    case selectExchanges
    //美币余额
    case selectMyPoints
    //美币明细
    case getPointsDetail(data:NSDictionary, pageSize:Int, number:Int)
    //美币明细分类筛选
    case getCategory
    //美币明细查询
    case setPointsDetail
    //统计账户余额
    case accountSum
    //修改用户信息
    case setUserOneselfUpdate(model: SSUserInfoModel)
    //获取省市区数据
    case provincesList
    //获取用户修改自己信息的页面
    case getUserOneselfUpdate
    //添加反馈
    case addFeedback(content: String, type: Int)
    //提现申请
    case doWithdraw(categoryId:Int, code:String, money:String, name:String)
    //提现记录
    case withdrawRecords(data:NSDictionary, pageSize:Int, number:Int)
    //提现分类
    case getWithdrawCategory
    //所有消息类型
    case noticesTypes
    //账户余额
    case userAccountSum
    //账户余额范围
    case myAccountSum(categoryId:String, createdTimeMax:String, createdTimeMini:String, keyWords:String)
    //账户明细
    case getAccountDetail(data:NSDictionary, pageSize:Int, number:Int)
    //账户明细分类
    case getAccountCategory
    //美币账户余额
    case myPoints
    //美币选择余额
    case myPointsSum(categoryId:String, createdTimeMax:String, createdTimeMini:String, keyWords:String)
    //企业认证明细
    case certificationsdetail(cid:String)
    //提交企业认证
    case applyCompany(proveModel: SSPersonModel)
    //个人认证明细
    case personalDetail(cid:String)
    //提交个人认证
    case applyPersonal(personModel:SSPersonModel)
    //我的徽章
    case getUserBadge
    //徽章详情
    case getBadgeDetailsList(id:String)
    //我的礼物
    case myGiftDetails(data:NSDictionary, number:Int, pageSize:Int)
    //开通会员
    case openVip(couponsId:String, paymentType:String)
    //上传位置信息
    case geoPost(latitude:Double, longitude:Double, userId:String)
    //动态详情
    case publishedDetail(noteId:String)
    //动态详情
    //    case noteDetail
    
    ///h5购买美币
    case h5BuyPoints(number:Int,payChannel:Int)
    ///获取美币数
    case findPoints
    //我的认证信息
    case myCertifications
    //附近用户
    case nearbyList
    ///礼物间
    case myGift(userId:String)
    ///兑换卷传卷id
    case buyExchanges(mId:String)
    //用户背景图
    case bgImage(userId:String)
    ///查看用户礼物间可见权限
    case giftSetting
    ///新增/修改用户礼物间可见权限
    case giftAddUserSetting(name:String)
    //app当前用户是否关注指定用户
    case isFocusUser(userId:String)
    //获取用户数据
    case getUserData(userId:String)
    //获取所有已认证企业
    case getCompanyList(title: String)
    //批量关注
    case getFocusBatch(integers: [String])
    //是否拉黑
    case getSelectBlack(blackUserId: String)
    //拉黑-解除传blackUserId
    case getAddUserBlack(blackUserId: String)
    ///邀请记录
    case myReferUser(data:NSDictionary, pageSize:Int, number:Int)
    ///获取用户余额
    case getUserAccount
    
    //形体贝账户余额
    case xingtibeiSum
    //形体贝选择余额
    case myXingTiBeiSum(categoryId:String, createdTimeMax:String, createdTimeMini:String, keyWords:String)
    //形体贝选择余额
    case getXingtibeiDetail(data:NSDictionary,pageSize:Int, number:Int)
    ///形体贝分类
    case getXingtibeiCategory
}

extension UserInfoApiManage:TargetType{
    public var baseURL: URL{
        return URL(string: baseUrl)!
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .userInfo: return "/user-service/user/app/userInfo"
        case .fansList: return "/user-service/fans/app/list"
        case .focusList: return "/user-service/focus/app/list"
        case .focusOption: return "/user-service/focus/app/focus"
        case .addressBook: return "/user-service/user/addressBook/list"
        case .draftList: return "/note-service/my/notes/draft/list"
        case .deletaDraft: return "/note-service/notes/delete/my"
        case .selectMyExchanges: return "/user-service/exchange/selectMyExchanges"
        case .selectMyExchangesEnd: return "/user-service/exchange/selectMyExchangesEnd"
        case .selectUsedExchange: return "/user-service/exchange/selectUsedExchange"
        case .messageList: return "/message-service/my/notices/list"
        case .getPointsJop: return "/user-service/user/app/getPointsJop"
        case .blackList: return "/user-service/userBlack/selectUserBlack"
        case .searchFocusList: return "/user-service/focus/app/searchList"
        case .selectExchanges: return "/user-service/exchange/selectExchanges"
        case .selectMyPoints: return "/user-service/exchange/selectMyPoints"
        case .getPointsDetail: return "/account-service/pointsdetail/app/getPointsDetail"
        case .getCategory: return "/account-service/pointsdetail/app/getCategory"
        case .setPointsDetail: return "/account-service/pointsdetail/setPointsDetail"
        case .accountSum: return "/account-service/account/accountSum"
        case .setUserOneselfUpdate: return "/user-service/user/app/setUserOneselfUpdate"
        case .getUserOneselfUpdate: return "/user-service/user/app/getUserOneselfUpdate"
        case .provincesList: return "/public-service/provinces/tree/list"
        case .addFeedback: return "/system-service/feedback/addFeedback"
        case .doWithdraw: return "/account-service/withdrawal/app/doWithdraw"
        case .withdrawRecords: return "/account-service/withdrawal/app/withdrawRecords"
        case .getWithdrawCategory: return "/account-service/withdrawal/app/getWithdrawCategory"
        case .noticesTypes: return "/message-service/my/notices/types"
        case .getAccountCategory: return "/account-service/account/app/getAccountCategory"
        case .myAccountSum: return "/account-service/account/app/myAccountSum"
        case .userAccountSum: return "/account-service/account/app/userAccountSum"
        case .getAccountDetail: return "/account-service/account/app/getAccountDetail"
        case .myPoints: return "/account-service/pointsdetail/app/myPoints"
        case .myPointsSum: return "/account-service/pointsdetail/app/myPointsSum"
        case .certificationsdetail: return "/user-service/certification/app/company/certifications/detail"
        case .applyCompany: return "/user-service/certification/apply/company"
        case .personalDetail: return "/user-service/certification/app/personal/certifications/detail"
        case .applyPersonal: return "/user-service/certification/apply/personal"
        case .getUserBadge: return "/system-service/badge/app/getUserBadge"
        case .getBadgeDetailsList: return "/system-service/badge/app/getBadgeDetailsList"
        case .myGiftDetails: return "/gift-service/gift/app/myGiftDetails"
        case .openVip: return "/user-service/user/vip/operation/h5/open"
        case .geoPost: return "/user-service/user/geo/post"
        case .publishedDetail: return "/note-service/my/notes/published/detail"
        case .h5BuyPoints: return "/account-service/point/app/h5BuyPoints"
        case .findPoints: return "/account-service/point/app/findPoints"
        case .myCertifications: return "/user-service/certification/app/my/certifications"
        case .nearbyList: return "/user-service/user/geo/nearby/list"
        case .myGift: return "/gift-service/gift/app/myGift"
        case .buyExchanges: return "/user-service/exchange/buyExchanges"
        case .bgImage: return "/user-service/user/app/getBgImage"
        case .giftSetting: return "/user-service/userGiftSetting/selectUserGiftSetting"
        case .giftAddUserSetting: return "/user-service/userGiftSetting/addUserGiftSetting"
        case .isFocusUser: return "/user-service/focus/app/getFocusType"
        case .getUserData: return "user-service/user/app/getUserData"
        case .getCompanyList: return "/user-service/certification/certified/company/list"
        case .getFocusBatch: return "/user-service/focus/app/focusBatch"
        case .getSelectBlack: return "/user-service/userBlack/selectBlack"
        case .getAddUserBlack: return "/user-service/userBlack/addUserBlack"
        case .myReferUser: return "/user-service/refer/app/myReferUser"
        case .getUserAccount: return "/account-service/userAccount/getUserAccount"
        case .myXingTiBeiSum: return "/account-service/xingtibeiDetail/app/myXingtibeiSum"
        case .getXingtibeiDetail: return "/account-service/xingtibeiDetail/app/getXingtibeiDetail"
        case .xingtibeiSum: return "/account-service/xingtibeiDetail/app/xingtibeiSum"
        case .getXingtibeiCategory : return "/account-service/xingtibeiDetail/getXingtibeiCategory"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        switch self {
        case .provincesList:
            return .get
        default:
            return .post
        }
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .userInfo(let userId):
            parmeters = ["userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .fansList(let data, let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .focusList(let data, let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .searchFocusList(let nickName):
            parmeters = ["nickName":nickName] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .blackList(let data, let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .focusOption(let focusUserId):
            parmeters = ["focusUserId":focusUserId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .addressBook(let arrays):
            parmeters = ["arrays":arrays] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .draftList(let userId, let pageNumber, let size):
            parmeters = ["userId":userId,
                         "pageNumber":pageNumber,
                         "size":size] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .deletaDraft(let noteId):
            parmeters = ["noteId":noteId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .selectMyExchanges(let data, let number, let pageSize):
            parmeters = ["data":data,
                         "number":number,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .selectMyExchangesEnd(let pageNumber, let size):
            parmeters = ["pageNumber":pageNumber,
                         "size":size] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .selectUsedExchange(let money,let isVip):
            parmeters = ["money":money,
                         "type":isVip] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .messageList(let noticeType, let pageSize, let number, let publishedTimeAsc, let titleKeyword):
            parmeters = ["noticeType":noticeType,
                         "pageSize":pageSize,
                         "number":number,
                         "publishedTimeAsc":publishedTimeAsc,
                         "titleKeyword":titleKeyword] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .getPointsJop:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .selectExchanges:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .selectMyPoints:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .getPointsDetail(let data,let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .getCategory:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .setPointsDetail:
            return .requestPlain
            
        case .accountSum:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .setUserOneselfUpdate(let model):
            parmeters = ["birthday":model.birthday ?? 0,
                         "city":model.city ?? "",
                         "cityId":model.cityId ?? 0,
                         "headImage":model.headImage ?? "",
                         "introduce":model.introduce ?? "",
                         "nickName":model.nickName ?? "",
                         "province":model.province ?? "",
                         "provinceId":model.provinceId ?? 0,
                         "sex":model.sex ?? 0] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .provincesList:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getUserOneselfUpdate:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .addFeedback(let content, let type):
            parmeters = ["content":content,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .doWithdraw(let categoryId, let code, let money, let name):
            parmeters = ["categoryId":categoryId,
                         "code":code,
                         "money":money,
                         "name":name] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .withdrawRecords(let data,let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .getWithdrawCategory:
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .noticesTypes:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getAccountCategory:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .myAccountSum(let categoryId, let createdTimeMax, let createdTimeMini, let keyWords):
            parmeters = ["categoryId":categoryId,
                         "createdTimeMax":createdTimeMax,
                         "createdTimeMini":createdTimeMini,
                         "keyWords":keyWords,
                         "userId": UserInfo.getSharedInstance().userId ?? ""
            ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .userAccountSum:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getAccountDetail(let data, let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .myPoints:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .myPointsSum(let categoryId, let createdTimeMax, let createdTimeMini, let keyWords):
            parmeters = ["categoryId":categoryId,
                         "createdTimeMax":createdTimeMax,
                         "createdTimeMini":createdTimeMini,
                         "keyWords":keyWords] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .certificationsdetail(let cid):
            parmeters = ["certificationId":cid]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .applyCompany(let proveModel):
            parmeters["businessLicenseImages"] = proveModel.businessLicenseImages
            parmeters["certificateImages"] = proveModel.certificateImages
            parmeters["certificationId"]=proveModel.certificationId
            parmeters["areaCode"]=proveModel.areaCode
            parmeters["cityName"]=proveModel.cityName
            parmeters["companyName"]=proveModel.companyName
            parmeters["creditCode"]=proveModel.creditCode
            parmeters["detailAddress"]=proveModel.detailAddress
            parmeters["idimages"]=proveModel.idimages
            parmeters["operatorIDNumber"]=proveModel.operatorIDNumber
            parmeters["mobile"]=proveModel.operatorMobile
            parmeters["operatorName"]=proveModel.operatorName
            parmeters["provinceName"]=proveModel.provinceName
            parmeters["checkCode"]=proveModel.checkCode
            parmeters["showWords"]=proveModel.showWords
//            parmeters = ["businessLicenseImages":proveModel.businessLicenseImages,
//                         "certificateImages":proveModel.certificateImages,
//                         "certificationId":proveModel.certificationId,
//                         "cityName":proveModel.cityName,
//                         "companyName":proveModel.companyName,
//                         "creditCode":proveModel.creditCode,
//                         "detailAddress":proveModel.detailAddress,
//                         "idimages":proveModel.idimages,
//                         "operatorIDNumber":proveModel.operatorIDNumber,
//                         "operatorMobile":proveModel.operatorMobile,
//                         "operatorName":proveModel.operatorName,
//                         "provinceName":proveModel.provinceName,
//                         "creditCode":proveModel.creditCode,
//                         "showWords":proveModel.showWords] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .personalDetail(let cid):
            parmeters = ["certificationId":cid]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .applyPersonal(let personModel):
            parmeters = ["certificationId":personModel.certificationId,
                         "certificateImages":personModel.certificateImages,
                         "idimages":personModel.idimages,
                         "idname":personModel.idname,
                         "idnumber":personModel.idnumber,
                         "mobile":personModel.mobile,
                         "ownerCompanyId":personModel.ownerCompanyId,
                         "showWords":personModel.showWords] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .getUserBadge:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getBadgeDetailsList(let id):
            parmeters = ["id":id] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .myGiftDetails(let data, let number, let pageSize):
            parmeters = ["data":data,
                         "number":number,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .openVip(let couponsId, let paymentType):
            parmeters = ["couponsId":couponsId,
                         "paymentType":paymentType] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .geoPost(let latitude, let longitude, let userId):
            parmeters = ["latitude":latitude,
                         "longitude":longitude,
                         "userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .publishedDetail(let noteId):
            parmeters = ["noteId":noteId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .h5BuyPoints(let number,let payChannel):
            parmeters = ["number":number,
                         "payChannel":payChannel] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .findPoints:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .myCertifications:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .nearbyList:
            //                parmeters = ["number":1,
            //                             "pageSize":10] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .myGift(let userId):
            parmeters = ["userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .buyExchanges(let mId):
            parmeters = ["id":mId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .bgImage(let userId):
            parmeters = ["userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .giftSetting:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .giftAddUserSetting(let name):
            parmeters = ["name":name] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .isFocusUser(let userId):
            parmeters = ["userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getUserData(let userId):
            parmeters = ["userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .getCompanyList(let title):
            parmeters = ["companyName":title] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .getFocusBatch(let integers):
            parmeters = ["integers":""] as [String : Any]
            let jsonData = try! JSONSerialization.data(withJSONObject: integers, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: jsonData, urlParameters: parmeters)
            
        case .getSelectBlack(let blackUserId):
            parmeters = ["blackUserId":blackUserId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .getAddUserBlack(let blackUserId):
            parmeters = ["blackUserId":blackUserId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        //        return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .myReferUser(let data, let number, let pageSize):
            parmeters = ["data":data,
                         "number":number,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .getUserAccount:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getXingtibeiDetail(let data, let pageSize, let number):
            parmeters = ["data":data,
                         "pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .myXingTiBeiSum(let categoryId, let createdTimeMax, let createdTimeMini, let keyWords):
            parmeters = ["categoryId":categoryId,
                         "createdTimeMax":createdTimeMax,
                         "createdTimeMini":createdTimeMini,
                         "keyWords":keyWords] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .xingtibeiSum:
            return .requestPlain
        case .getXingtibeiCategory:
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

