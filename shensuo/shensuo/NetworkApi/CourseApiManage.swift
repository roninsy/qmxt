//
//  KeChengApiManage.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/13.
//

import UIKit
import Moya

// NetworkAPI就是一个遵循TargetType协议的枚举
let CourseNetworkProvider = MoyaProvider<CourseApiManage>( plugins: [
    VerbosePlugin(verbose: true)
])


enum CourseApiManage {
    // 查询课程详情接口
    case coureseDetails(cid:String)
    // 查询小节详情接口
    case selectCourseStepApp(cid:String)
    ///查询分类
    case coureseType
    
    case addUserCourse(cid:String)
    
    case checkUserCourse(cid:String)
    ///购买课程/方案app
    case buyCourse(cid:String,couponsId:String,paymentType:String)
    ///查询优惠后价格
    case useCoupons(cid:String,couponsId:String)
    ///购买回调
    case callback(cid:String,type:String)
    
    ///统一查询订单接口
    case queryPay(cid:String,type:String)
    ///查询小节音视频地址
    case selectCourseStepUrl(cid:String)
    ///获取格言
    case selectMottoForApp
    ///获取投诉分类
    case selectComplainCategoryList
    ///投诉
    case addComplain(commentType:String,complainCategoryId:String,content:String,contentType:String,sourceId:String)
    case test
    ///发布动态
    case publish(address:String,cityName:String,content:String,headImageName:String,imageNames:[String],musicUrl:String,noteType:String,title:String,videoName:String,id:String)
    ///草稿动态保存
    case draftSave(address:String,cityName:String,content:String,headImageName:String,imageNames:[String],musicUrl:String,noteType:String,title:String,videoName:String,id: String)
    //草稿动态发布
    case draftPublish(address:String,cityName:String,content:String,headImageName:String,imageNames:[String],musicUrl:String,noteType:String,title:String,videoName:String,id: String)
    ///搜索课程。方案
    case serachCourseScheme(pageNumber:Int,pageSize:Int,contentType:Int,firstCategoryId:String,secondCategoryId:String,keyWord:String)
    ///查询课程学习人数
    case courseLearningCount(cid:String)
    case selectLearningCountStep(cid:String)
    case selectCourseReferrerApp(firstCategoryId:String,type:Int,number:Int,pageSize:Int)
    ///新增学习完成
    case addTraining(courseId:String,courseStepId:String)
    ///新增学习感受
    case addTrainingFeel(commitType:Int,courseId:String,courseStepId:String,feelContent:String,feelType:Int)
    
    ///查询课程学习情况
    case selectMyCourseCondition(type:Int)
    
    case selectCourseForYouApp
    case selectMyCourseListApp(pageNumber:Int,pageSize:Int,finshType:Int,order:Int,paymentType:Int,title:String,type: Int)
    case selectCourseCollectListApp(pageNumber:Int,pageSize:Int,title:String,type: Int)
    ///学习提醒查询 0课程 1方案 首页传3
    case selectLearningRemind(type:Int)
    ///动态权限设置接口,是否私有，否则公开
    case notesPermission(noteId:String,isPrivate:Bool)
    ///删除动态
    case notesDelete(noteId:String)
    
    case iosPay(receipt:String,type:Int)
}

extension CourseApiManage:TargetType{
    public var baseURL: URL{
        return URL(string: baseUrl)!
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .coureseDetails: return "/course-service/course/selectCourseApp"
        case .coureseType: return "/system-service/category/selectCategoryTree"
        case .test: return "/note-service/my/notes/test/list"
        case .addUserCourse: return "/course-service/course/addUserCourse"
        case .checkUserCourse: return "/course-service/course/checkUserCourse"
        case .buyCourse: return "/course-service/course/buyCoursePrepaymentAccount"
        case .useCoupons : return "/course-service/course/useCoupons"
        case .callback: return "/course-service/course/callback"
        case .selectCourseStepApp: return "/course-service/course/selectCourseStepApp"
        case .selectCourseStepUrl: return "/course-service/course/selectCourseStepUrl"
        case .selectMottoForApp: return "/system-service/motto/selectMottoForApp"
            
        case .selectComplainCategoryList: return "/system-service/complain/selectComplainCategoryList"
        case .addComplain: return "/system-service/complain/addComplain"
            
        case .publish: return "/note-service/notes/publish"
        case .draftSave: return "/note-service/notes/draft/save"
        case .draftPublish: return "/note-service/notes/draft/publish"
        case .serachCourseScheme: return "/data-service/course_scheme/serachCourseScheme"
        case .courseLearningCount: return "/course-service/course/selectLearningCount"
        case .selectCourseReferrerApp: return "/course-service/course/selectCourseReferrerApp"
        case .queryPay: return "/pay-service/pay/queryPay"
        case .addTraining: return "/course-service/training/addTraining"
        case .addTrainingFeel: return "/course-service/training/addTrainingFeel"
        case .selectMyCourseCondition: return "/course-service/course/selectMyCourseCondition"
        case .selectCourseForYouApp: return "/course-service/course/selectCourseForYouApp"
        case .selectMyCourseListApp: return "/course-service/course/selectMyCourseListApp"
        case .selectCourseCollectListApp: return "/course-service/course/selectCourseCollectListApp"
        case .selectLearningRemind: return "/course-service/course/selectLearningRemind"
        case .selectLearningCountStep: return "/course-service/course/selectLearningCountStep"
        case .notesPermission: return "/note-service/notes/permission"
        case .notesDelete: return "/note-service/notes/delete/my"
            
        case .iosPay: return "/pay-service/pay/iosPay"
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
        case .coureseDetails(let cid):
            parmeters = ["id":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectCourseStepApp(let cid):
            parmeters = ["id":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .coureseType:
            return .requestPlain
        case .addUserCourse(let cid):
            parmeters = ["id":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .test:
            let dic = ["address":"abc","content":"abc"]
            let dic2 = ["address":"abc","content":"abc"]
            let arr = [dic,dic2]
            //            let data : Data! = try? JSONSerialization.data(withJSONObject: arr, options: [])
            return .requestJSONEncodable(arr)
        case .checkUserCourse(let cid):
            parmeters = ["id":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .buyCourse(let cid, let couponsId,let paymentType):
            parmeters = ["courseId":cid,
                         "couponsId":couponsId,
                         "paymentType":paymentType] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .useCoupons(let cid, let couponsId):
            parmeters = ["id":cid,
                         "couponId":couponsId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .callback(let cid, let type):
            parmeters = ["orderId":cid,
                         "payChannel":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectCourseStepUrl(let cid):
            parmeters = ["id":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectMottoForApp:
            return .requestPlain
        case .selectComplainCategoryList:
            return .requestPlain
        case .addComplain(let commentType,let complainCategoryId,let content,let contentType,let sourceId):
            parmeters = ["commentType":commentType,
                         "complainCategoryId":complainCategoryId,
                         "content":content,
                         "contentType":contentType,
                         "sourceId":sourceId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .publish(let address,let cityName,let content,let headImageName,let imageNames,let musicUrl,let noteType,let title,let videoName,let id):
            parmeters = ["address":address,
                         "cityName":cityName,
                         "content":content,
                         "headImageName":headImageName,
                         "imageNames":imageNames,
                         "musicUrl":musicUrl,
                         "noteType":noteType,
                         "title":title,
                         "videoName":videoName,
                         "id":id] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .draftSave(let address,let cityName,let content,let headImageName,let imageNames,let musicUrl,let noteType,let title,let videoName,let id):
            parmeters = ["address":address,
                         "cityName":cityName,
                         "content":content,
                         "headImageName":headImageName,
                         "imageNames":imageNames,
                         "musicUrl":musicUrl,
                         "noteType":noteType,
                         "title":title,
                         "videoName":videoName,
                         "id": id
            ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .draftPublish(let address,let cityName,let content,let headImageName,let imageNames,let musicUrl,let noteType,let title,let videoName,let id):
            parmeters = ["address":address,
                         "cityName":cityName,
                         "content":content,
                         "headImageName":headImageName,
                         "imageNames":imageNames,
                         "musicUrl":musicUrl,
                         "noteType":noteType,
                         "title":title,
                         "videoName":videoName,
                         "id": id
            ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .serachCourseScheme(let pageNumber,let pageSize,let contentType,let firstCategoryId,let secondCategoryId,let keyWord):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "contentType":contentType,
                         "firstCategoryId":firstCategoryId,
                         "secondCategoryId":secondCategoryId,
                         "keyWord":keyWord] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .courseLearningCount(let cid):
            parmeters = ["courseId":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .selectLearningCountStep(let cid):
            parmeters = ["courseId":cid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .selectCourseReferrerApp(let firstCategoryId,let type,let number,let pageSize):
            let dic = ["firstCategoryId":firstCategoryId,
                       "type":type] as [String : Any]
            parmeters = ["data":dic,
                         "number":number,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .queryPay(let cid, let type):
            parmeters = ["orderId":cid,
                         "channel":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .addTraining(let courseId,let courseStepId):
            parmeters = ["courseId":courseId,
                         "courseStepId":courseStepId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .addTrainingFeel(let commitType,let courseId,let courseStepId,let feelContent,let feelType):
            parmeters = ["commitType":commitType,
                         "courseId":courseId,
                         "courseStepId":courseStepId,
                         "feelContent":feelContent,
                         "feelType":feelType] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectMyCourseCondition(let type):
            parmeters = ["type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectCourseForYouApp:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectMyCourseListApp(let pageNumber, let pageSize, let finshType, let order, let paymentType, let title, let type):
            let dic = ["finshType":finshType,
                       "order":order,
                       "paymentType":paymentType,
                       "title":title,
                       "type":type,
                       
            ] as [String : Any]
            parmeters = ["data":dic,
                         "number":pageNumber,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectCourseCollectListApp(let pageNumber, let pageSize,let title, let type):
            let dic = [
                "title":title,
                "type":type,
                
            ] as [String : Any]
            parmeters = ["data":dic,
                         "number":pageNumber,
                         "pageSize":pageSize] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectLearningRemind(let type):
            parmeters = ["type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .notesPermission(let noteId,let isPrivate):
            parmeters = ["noteId":noteId,
                         "isPrivate":isPrivate] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .notesDelete(let noteId):
            parmeters = ["noteId":noteId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .iosPay(let receipt,let type):
            parmeters = ["receipt":receipt,
                         "type":type] as [String : Any]
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
        return ["Content-Type": "application/json",
                "Authorization" : "Bearer " + (UserInfo.getSharedInstance().token ?? "")]
    }
    
    
    
}

