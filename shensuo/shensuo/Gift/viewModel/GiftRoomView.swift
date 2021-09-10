//
//  GiftRoomView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/8.
//
//礼物间

import UIKit

class GiftRoomView: UIView {
    
    
    ///礼物榜model
    var rankModels : GiftRankModel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.getNetInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///礼物间信息
    func getNetInfo() {
        UserInfoNetworkProvider.request(.myGift(userId: UserInfo.getSharedInstance().userId ?? "")) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
        self.getRankList()
        self.getGiftStand()
    }
    ///获取礼物架
    func getGiftStand(){
        GiftNetworkProvider.request(.giftStand(userId: UserInfo.getSharedInstance().userId ?? "")) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{

                            }
                        }else{
                            
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    ///获取礼物榜
    func getRankList() {
        GiftNetworkProvider.request(.giftRanking(source: UserInfo.getSharedInstance().userId ?? "", type: "8", number: 1, pageSize: 10)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.rankModels = model!.data!.kj.model(type: GiftRankModel.self) as? GiftRankModel
                            }
                        }else{
                            
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
