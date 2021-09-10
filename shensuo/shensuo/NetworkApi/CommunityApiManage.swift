//
//  CommunityApiManage.swift
//  shensuo
//
//  Created by yang on 2021/4/13.
//

import UIKit
import Moya

// 社区相关接口请求
let CommunityNetworkProvider = MoyaProvider<CommunityApiManage>(plugins: [
    VerbosePlugin(verbose: true)
])

enum CommunityApiManage {
    //图片提交相关
    case getSecretKey
    //美丽日记
    case dailyList(pageSize:Int, number:Int)
    //美丽相册
    case photoList(pageSize:Int, number:Int)
    //美丽相册详情
    case photoDetail(photoId:String,userId: String)
    //动态列表
    case noteList(pageNumber:Int, size:Int,userId:String)
    //收藏/取消收藏
    case addCollect(sourceId:String, type:Int)
    //点赞/取消点赞 点赞类型 1课程 2课程小节 3动态 4美丽日志 5美丽相册 6方案 7方案小节
    case addLike(sourceId:String, type:Int)
    //添加评论
    case addComment(content:String, createdTime:String, imageArray:Array<Any>, sourceId:String, type:Int, userId:String)
    //回复评论
    case addCommentReply(atUserId:String,content:String, commentId:String, createdTime:String, imageArray:Array<Any>, sourceId:String, type:Int, userId:String)
    //删除评论
    case deleteComment(id:String, type:Int)
    //删除回复评论
    case deleteReply(id:String, type:Int)
    ///查询评论列表
    case commentList(id:String,page:Int,pageSize:Int,type:Int)
    ///查询回复列表接口App
    case selectCourseReplyListApp(id:String,number:Int,pageSize:Int,type:Int)
    //动态收藏列表
    case collectNoteList(titleKeyword:String, userId:String, pageNumber:Int, size:Int)
    //美丽相册收藏列表
    case collectAlbum(number:Int, pageSize:Int,title: String)
    //美丽日记收藏列表
    case collectDailyRecord(number:Int, pageSize:Int,title: String)
    //动态详情
    //    case noteDetail
    //生成美丽日记相册
    case selectDatesVideo(id:String,userId: String)
    //美丽日记详情
    case selectDatesListApp(id:String)
    //美丽相册视频
    case selectAlbumImageVideo(id:String,userId: String)
    //美丽相册天数
    case selectImagesList(days:Int, id:String)
    //美丽日记天数
    case selectDatesAppDay(days:Int, id:String)
    //推荐关注列表
    case getSuggestedFollows(pageNumber:Int, pageSize:Int, userId:String,userType: String)
    //社区关注
    case attentionNote(pageNumber:Int, pageSize:Int, userId:String)
    //社区同城
    case localNote(pageNumber:Int, pageSize:Int, userId:String, city:String)
    //社区推荐
    case recommendNote(pageNumber:Int, pageSize:Int, userId:String)
    //社区推荐
    case addDailyRecord(birthday:String,bmi:CGFloat,bodyFat:CGFloat,city:String,girth:CGFloat,height:CGFloat,image:String,province:String,sex:Int,weight:CGFloat)
    ///查看美丽日记天数
    case dailyRecordSelectDays
    ///今天是否录入数据
    case checkAddDailyRecord
    
    //搜索用户
    case searchUser(pageNumber:Int, pageSize:Int, userId:String,keyWord: String,userType: String)
    
    
    
    ///查询收藏状态
    case whetherCollect(sourceId:String,type:Int)
    ///查询收藏状态
    case whetherLike(sourceId:String,type:Int)
    ///查询能否评论
    case commentCheck(sid:String)
    
    
    ///社区视频详情推荐列表"pageNumber":"当前页","pageSize":"页面大小","module":"1:推荐，2:关注，3:同城","noteType":"1:视频，2:图文","city":"城市（同城时必传）"} 返回参数说明：{[id列表]
    case upAndDownNote(pageNumber:Int,pageSize:Int,module:Int,noteType:Int,city:String,id:String)
    ///    我的草稿动态统计
    case draftCount
    ///查看他人美丽日记列表App端传用户id
    case selectDailyListForHer(userId:String,pageNum:Int,pageSize:Int) 
    
    ///查找他人相册列表app端传用户id
    case selectAlbumListAppForHer(userId:String,pageNum:Int,pageSize:Int)
    ///查询评论总数接口App
    case selectCommentCountApp(id:String,type:Int)
    ///新增美丽日记
    case createDailyRecord
    ///新增美丽相册
    case createAlbum
}

extension CommunityApiManage:TargetType{
    public var baseURL: URL{
        return URL(string: baseUrl)!
        
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .getSecretKey: return "/public-service/signature/get"
        case .dailyList: return "/dailyrecord-service/dailyRecord/selectDailyList"
        case .photoList: return "/album-service/album/selectAlbumListApp"
        case .photoDetail: return "/album-service/album/selectAlbumImageListApp"
        case .noteList: return "/note-service/my/notes/published/list"
        case .addCollect: return "/clc-service/collect/addCollect"
        case .addLike: return "/clc-service/like/addLike"
        case .addComment: return "/clc-service/comment/addComment"
        case .addCommentReply: return "/clc-service/comment/addCommentReply"
        case .deleteComment: return "/clc-service/comment/deleteCommentAdmin"
        case .deleteReply: return "/clc-service/comment/deleteReplyAdmin"
        case .commentList: return "/clc-service/comment/selectCourseCommentListApp"
        case .collectNoteList: return "/note-service/my/notes/collected/list"
        case .collectAlbum: return "/album-service/album/collectAlbum"
        case .collectDailyRecord: return "/dailyrecord-service/dailyRecord/collectDailyRecord"
        case .selectDatesVideo: return "/dailyrecord-service/dailyRecord/selectDatesVideo"
        case .selectDatesListApp: return "/dailyrecord-service/dailyRecord/selectDatesListApp"
        case .selectAlbumImageVideo: return "/album-service/album/selectAlbumImageVideo"
        case .selectImagesList: return "/album-service/album/selectImagesListForApp"
        case .selectDatesAppDay: return "/dailyrecord-service/dailyRecord/selectDatesAppDay"
        case .getSuggestedFollows: return "/data-service/user/getSuggestedFollows"
        case .attentionNote: return "/data-service/note/attentionNote"
        case .localNote: return "/data-service/note/localNote"
        case .recommendNote: return "/data-service/note/recommendNote"
        case .addDailyRecord: return "/dailyrecord-service/dailyRecord/addDailyRecord"
        case .dailyRecordSelectDays: return "/dailyrecord-service/dailyRecord/selectDays"
        case .checkAddDailyRecord: return "/dailyrecord-service/dailyRecord/checkAddDailyRecord"
            
        case .searchUser: return "/data-service/user/searchUser"
        case .whetherCollect: return "/clc-service/collect/whetherCollect"
        case .whetherLike: return "/clc-service/like/whetherLike"
        case .commentCheck: return "/clc-service/comment/commentCheck"
            
        case .upAndDownNote: return "/data-service/note/upAndDownNote"
        case .draftCount: return "/note-service/my/notes/draft/count"
        case .selectDailyListForHer: return "/dailyrecord-service/dailyRecord/selectDailyListForHer"
        case .selectAlbumListAppForHer: return "/album-service/album/selectAlbumListAppForHer"
        case .selectCommentCountApp: return "/clc-service/comment/selectCommentCountApp"
        case .createDailyRecord: return "/dailyrecord-service/dailyRecord/createDailyRecord"
        case .createAlbum: return "/album-service/album/createAlbum"
        case .selectCourseReplyListApp: return "/clc-service/comment/selectCourseReplyListApp"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        switch self {
        case .getSecretKey:
            return .get
        default:
            return .post
        }
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .getSecretKey:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .dailyList(let pageSize, let number):
            parmeters = ["pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .photoList(let pageSize, let number):
            parmeters = ["pageSize":pageSize,
                         "number":number] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .photoDetail(let photoId,let userId):
            parmeters = ["id":photoId,"userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .noteList(let pageNumber, let size,let userId):
            parmeters = ["userId":userId,
                         "pageNumber":pageNumber,
                         "size":size] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .addCollect(let sourceId, let type):
            parmeters = ["sourceId":sourceId,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .addLike(let sourceId, let type):
            parmeters = ["sourceId":sourceId,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .addComment(let content, let createdTime, let imageArray, let sourceId, let type, let userId):
            parmeters = ["content":content,
                         "createdTime":createdTime,
                         "image01":imageArray.count > 0 ? imageArray[0] : "",
                         "image02":imageArray.count > 1 ? imageArray[1] : "",
                         "image03":imageArray.count > 2 ? imageArray[2] : "",
                         "image04":imageArray.count > 3 ? imageArray[3] : "",
                         "image05":imageArray.count > 4 ? imageArray[4] : "",
                         "image06":imageArray.count > 5 ? imageArray[5] : "",
                         "image07":imageArray.count > 6 ? imageArray[6] : "",
                         "image08":imageArray.count > 7 ? imageArray[7] : "",
                         "image09":imageArray.count > 8 ? imageArray[8] : "",
                         "sourceId":sourceId,
                         "type":type,
                         "userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .addCommentReply(let atUserId,let content, let commentId, let createdTime, let imageArray, let sourceId, let type, let userId):
            //                "image01":imageArray.count > 0 ? imageArray[0] : "",
            //                "image02":imageArray.count > 1 ? imageArray[1] : "",
            //                "image03":imageArray.count > 2 ? imageArray[2] : "",
            //                "image04":imageArray.count > 3 ? imageArray[3] : "",
            //                "image05":imageArray.count > 4 ? imageArray[4] : "",
            //                "image06":imageArray.count > 5 ? imageArray[5] : "",
            //                "image07":imageArray.count > 6 ? imageArray[6] : "",
            //                "image08":imageArray.count > 7 ? imageArray[7] : "",
            //                "image09":imageArray.count > 8 ? imageArray[8] : "",
            parmeters = ["atUserId":atUserId,
                         "content":content,
                         "commentId":commentId,
                         "createdTime":createdTime,
                         
                         "sourceId":sourceId,
                         "type":type,
                         "userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .deleteComment(let id, let type):
            parmeters = ["id":id,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .deleteReply(let id, let type):
            parmeters = ["id":id,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .commentList(let id,let page,let pageSize,let type):
            parmeters = ["id":id,
                         "number":page,
                         "pageSize":pageSize,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .collectAlbum(let number, let pageSize, let title):
            let dic = ["title": title]
            
            parmeters = ["number":number,
                         "pageSize":pageSize,"data" : dic] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .collectDailyRecord(let number, let pageSize, let title):
            let dic = ["title": title]
            
            parmeters = ["number":number,
                         "pageSize":pageSize,"data" : dic] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .collectNoteList(let titleKeyword, let userId, let pageNumber, let size):
            parmeters = ["titleKeyword":titleKeyword,
                         "userId":userId,
                         "pageNumber":pageNumber,
                         "size":size,] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
            
        case .selectDatesVideo(let id, let userId):
            parmeters = ["id":id,"userId": userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectDatesListApp(let id):
            parmeters = ["id":id] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectAlbumImageVideo(let id,let userId):
            parmeters = ["id":id,"userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectImagesList(let days, let id):
            parmeters = ["days":days,
                         "id":id] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .selectDatesAppDay(let days, let id):
            parmeters = ["days":days,
                         "id":id] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .getSuggestedFollows(let pageNumber, let pageSize, let userId, let userType):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "userId":userId,
                         "userType":userType
            ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .attentionNote(let pageNumber, let pageSize, let userId):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .localNote(let pageNumber, let pageSize, let userId, let city):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "userId":userId,
                         "city":city] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .recommendNote(let pageNumber, let pageSize, let userId):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "userId":userId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .addDailyRecord(let birthday,let bmi,let bodyFat,let city,let girth,let height,let image,let province,let sex,let weight):
            parmeters = ["birthday":"\(birthday) 00:00:00",
                         "bmi":String.init(format: "%.1f", bmi),
                         "bodyFat":String.init(format: "%.1f", bodyFat),
                         "city":city,
                         "girth":girth,
                         "height":height,
                         "image":image,
                         "province":province,
                         "sex":sex,
                         "weight":weight] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .dailyRecordSelectDays:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .checkAddDailyRecord:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .searchUser(let pageNumber, let pageSize, let userId, let keyWord, let userType):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         //                         "userId":userId,
                         "keyWord":keyWord,
                         "userType":userType,
            ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .whetherCollect(let sourceId, let type):
            parmeters = ["sourceId":sourceId,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .whetherLike(let sourceId, let type):
            parmeters = ["sourceId":sourceId,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .commentCheck(let sid):
            parmeters = ["userId":sid] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .upAndDownNote(let pageNumber,let pageSize,let module,let noteType,let city,let id):
            parmeters = ["pageSize":pageSize,
                         "module":module,
                         "noteType":noteType,
                         "city":city,
                         "id":id] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .draftCount:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectDailyListForHer(let userId,let pageNum,let pageSize):
            let data = ["id":userId]
            parmeters = ["pageSize":pageSize,
                         "number":pageNum,
                         "data":data] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .selectAlbumListAppForHer(let userId,let pageNum,let pageSize):
            let data = ["id":userId]
            parmeters = ["pageSize":pageSize,
                         "number":pageNum,
                         "data":data] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .selectCommentCountApp(let id, let type):
            parmeters = ["id":id,
                         "type":type] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .createDailyRecord:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .createAlbum:
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectCourseReplyListApp(let id,let number,let pageSize,let type):
            parmeters = ["id":id,
                         "number":number,
                         "pageSize":pageSize,
                         "type":type] as [String : Any]
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

