//
//  ApiManage.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/13.
//

import UIKit
import Moya
import MBProgressHUD

// NetworkAPI就是一个遵循TargetType协议的枚举
let NetworkProvider = MoyaProvider<ApiManage>( plugins: [
    VerbosePlugin(verbose: true)
])
struct VerbosePlugin: PluginType {
    let verbose: Bool
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        #if DEBUG
        if let body = request.httpBody,
           let str = String(data: body, encoding: .utf8) {
            if verbose {
                print("request to send: \(str))")
            }
        }
        #endif
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        if UserInfo.getSharedInstance().inVedioListVC == false && !HQGetTopVC()!.isKind(of: HomeController.self) && target.path.contains("signature") == false{
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: HQGetTopVC()!.view, animated: true)
            }
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: HQGetTopVC()!.view, animated: true)
        }
        
        switch result {
        case let .success(moyaResponse):
            do {
                let code = moyaResponse.statusCode
                if code == 200{
                    let json = try moyaResponse.mapString()
                    let model = json.kj.model(ResultDicModel.self)
                    if model?.code == -2 || model?.code == -1{
                        ///账号被其他设备登录
                        PushToLogin()
                    }
                    if model?.code == 90000 {
                        if UserInfo.getSharedInstance().inVedioListVC {
                            HQGetTopVC()?.view.makeToast("内容被删除")
                        }else{
                            ShowNoContentView()
                        }
                        return
                    }
                    if model?.code == 3099 || model?.code == 3098 {
                        if UserInfo.getSharedInstance().inVedioListVC {
                            HQGetTopVC()?.view.makeToast(model?.message ?? "")
                        }else{
                            //                        3099,"该用户已删除！"
                            let sealedView = SSCommonSealedView()
                            HQGetTopVC()?.view.addSubview(sealedView)
                            sealedView.snp.makeConstraints { make in
                                make.edges.equalToSuperview()
                            }
                            sealedView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                                sealedView.removeFromSuperview()
                                HQGetTopVC()?.navigationController?.popViewController(animated: true)
                            }
                            sealedView.leftBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                                sealedView.removeFromSuperview()
                                HQGetTopVC()?.navigationController?.popViewController(animated: true)
                            }
                            sealedView.tipesL.text = model?.message ?? ""
                            sealedView.nameL.text =  model?.code == 3098 ? "账号被封号" : "账号被删除"
                        }
                    }
                    if model?.code != 0 {
                        let msg = model?.message ?? "出现错误，请重试"
                        if msg != "无权访问" {
                            HQGetTopVC()?.view.makeToast(msg)
                        }
                    }
                }else if code == 500{
                    HQGetTopVC()?.view.makeToast("全民形体开了点小差，请休息下再重试哦！")
                }
            } catch {
                
            }
        case .failure(_):
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: HQGetTopVC()!.view, animated: false)
            }
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
        }
        
    }
}


enum ApiManage {
    case homeBananer
    case courseBananer
    case projectBananer
    case homeListData(cIndex:String,cStage:String,pIndex:String,pStage:String)
    ///获取机构排行榜
    case getOrganizationTop(pageNumber:Int,pageSize:Int,topType:Int)
    ///获取导师榜
    case getTutorTop(pageNumber:Int,pageSize:Int,topType:Int)
    case test
    case serachCourseScheme(pageNumber:Int,pageSize:Int,keyWord:String,contentType:Int,firstCategoryId:String,secondCategoryId:String)
    case serachAlbum(pageNumber:Int,pageSize:Int,keyWord:String)
    case searchUser(pageNumber:Int,pageSize:Int,keyWord:String)
    case serachNote(pageNumber:Int,pageSize:Int,keyWord:String)
    case serachDailyRecord(pageNumber:Int,pageSize:Int,keyWord:String)
    case appVersion
    ///分享徽章回调
    case shareBadge(badgeId:String)
    ///查找系统参数接口
    case selectString
    ///绑定微信
    case bindingWeixin(code:String)
}

extension ApiManage:TargetType{
    
    public var baseURL: URL{
        return URL(string: baseUrl)!
    }
    
    // 对应的不同API path
    var path: String {
        switch self {
        case .homeBananer: return "/system-service/ad/selectByPositionOnOne"
        case .courseBananer: return "/system-service/ad/selectByPositionOnTwo"
        case .projectBananer: return "/system-service/ad/selectByPositionOnThree"
        case .homeListData: return "/data-service/home/getData"
        case .test: return "/user-service/register"
        case .getOrganizationTop: return "/data-service/user/getOrganizationTop"
        case .getTutorTop: return "/data-service/user/getTutorTop"
        case .serachCourseScheme: return "/data-service/course_scheme/serachCourseScheme"
        case .serachAlbum: return "/data-service/album/serachAlbum"
        case .searchUser: return "/data-service/user/searchUser"
        case .serachNote: return "/data-service/note/serachNote"
        case .serachDailyRecord: return "/data-service/daily_record/serachDailyRecord"
        case .appVersion: return "/system-service/appVersion/selectPreviousVersionIos"
        case .shareBadge: return "/system-service/share/app/shareBadge"
        case .selectString: return "/system-service/setting/selectString"
        case .bindingWeixin: return "/user-service/binding/weixin"
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
        case .homeBananer:
            return .requestPlain
        case .homeListData(let cIndex,let cStage,let pIndex,let pStage):
            parmeters = ["cIndex":cIndex,
                         "cStage":cStage,
                         "pIndex":pIndex,
                         "pStage":pStage] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .test:
            parmeters = ["mobile":"page"] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .courseBananer:
            return .requestPlain
        case .projectBananer:
            return .requestPlain
            
        case .getOrganizationTop(let pageNumber,let pageSize,let topType):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "topType":topType] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .getTutorTop(let pageNumber,let pageSize,let topType):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "topType":topType] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .searchUser(let pageNumber,let pageSize,let keyWord):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "keyWord":keyWord] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .serachNote(let pageNumber,let pageSize,let keyWord):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "keyWord":keyWord] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .serachAlbum(let pageNumber,let pageSize,let keyWord):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "keyWord":keyWord] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .serachCourseScheme(let pageNumber,let pageSize,let keyWord,let contentType,let firstCategoryId,let secondCategoryId):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "keyWord":keyWord,
                         "contentType":contentType,
                         "firstCategoryId":firstCategoryId,
                         "secondCategoryId":secondCategoryId] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .serachDailyRecord(let pageNumber,let pageSize,let keyWord):
            parmeters = ["pageNumber":pageNumber,
                         "pageSize":pageSize,
                         "keyWord":keyWord] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        case .appVersion:
            return .requestPlain
        case .shareBadge(let badgeId):
            parmeters = ["badgeId":badgeId]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .selectString:
            return .requestPlain
        case .bindingWeixin(let code):
            parmeters = ["code":code]
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

