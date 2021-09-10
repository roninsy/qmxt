//
//  SSCustomgGetSecurtKey.swift
//  shensuo
//
//  Created by  yang on 2021/6/24.
//

import UIKit

class SSCustomgGetSecurtKey: NSObject {
    
    var securityToken:String?
    var accessKeySecret:String?
    var accessKeyId:String?
    
    func getSecurtKey() -> Void {
        CommunityNetworkProvider.request(.getSecretKey) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200 {
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            let data = dic?["credentials"] as![String:Any]
                            self.accessKeyId = data["accessKeyId"] as? String
                            self.accessKeySecret = data["accessKeySecret"] as? String
                            self.securityToken = data["securityToken"] as? String
                        }else{
                            
                        }
                    }
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    deinit {
        ///待实现
        ///此类需要新增定时刷新方法
    }
}
