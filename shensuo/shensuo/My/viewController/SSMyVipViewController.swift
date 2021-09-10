//
//  SSMyVipViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/4.
//

import UIKit
import BSText
import SCLAlertView

class SSMyVipViewController: SSBaseViewController {

    var needShowSuccess = false
    
    var isVip = UserInfo.getSharedInstance().vip ?? false
    
    let mainView = VipDetalisView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = true
        self.getVipInfo()
        GetUserAc()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        self.view.addSubview(mainView)
        mainView.buyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.checkMoneyIsMore()
        }
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    ///判断优惠券价值是否溢出
    @objc func checkMoneyIsMore(){
        if (self.mainView.vipMidView.exchangeSelModel?.money ?? 0) > (self.mainView.vipPrice.toDouble ?? 0){
            self.cancleSureAlertAction(title: "抵扣券价值大于商品价值，您购买后将不设找零，您确认购买吗？", content: "") {[weak self] ac in
                self?.clickOpenBtn(cid: self?.mainView.vipMidView.exchangeSelModel?.id ?? "")
            }
        }else{
            self.clickOpenBtn(cid: self.mainView.vipMidView.exchangeSelModel?.id ?? "")
        }
    }
    
    @objc func clickOpenBtn(cid:String) {
        if self.mainView.agreeBtn.isSelected{
            UserNetworkProvider.request(.balanceOpen(couponsId: cid)) {[weak self] (result) in
                switch result {
                    case let .success(moyaResponse):
                        do {
                            let code = moyaResponse.statusCode
                            if code == 200{
                                let json = try moyaResponse.mapString()
                                let model = json.kj.model(ResultDicModel.self)
                                let data = model?.data
                                if model?.code == 0 {
                                    DispatchQueue.main.async {
                                        self?.view.makeToast("开通成功")
                                        self?.needShowSuccess = true
                                        self?.getVipInfo()
                                    }
                                }else{
                                    if model?.code == 3000{
                                        DispatchQueue.main.async {
                                            let num = model?.message?.toDouble ?? 0
                                            let buyView = BuyAmountView()
                                            buyView.coinNumLab.text = "账户余额：\(UserInfo.getSharedInstance().xtb)贝"
                                            buyView.otherNum = num
                                            HQGetTopVC()?.view.addSubview(buyView)
                                            buyView.snp.makeConstraints { make in
                                                make.edges.equalToSuperview()
                                            }
                                            HQGetTopVC()?.view.makeToast("当前余额不足，还差\(model?.message ?? "0")")
                                        }
                                    }
                                    
                                }
                            }
                        } catch {
                        }
                    case let .failure(error):
                        logger.error("error-----",error)
                    }
            }
        }else{
            self.view.makeToast(ReadTipString)
        }
        
        
    }

}

extension SSMyVipViewController {
   
    func getVipInfo() {
        UserNetworkProvider.request(.vipInfo) {[weak self] result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().vipInfo = model?.data as NSDictionary?
                            self?.reloadVipStatusInfo()
                            if self?.needShowSuccess == true {
                                self?.needShowSuccess = false
                                DispatchQueue.main.async {
                                    let sv = VipSuccessView()
                                    sv.successLab.text = "VIP年卡会员\(self?.isVip == true ? "续费" : "开通")成功"
                                    sv.timeLab.text = "有效期：\(UserInfo.getSharedInstance().startEffectiveDate ?? "")至\(UserInfo.getSharedInstance().endEffectiveDate ?? "")"
                                    HQGetTopVC()?.view.addSubview(sv)
                                    sv.snp.makeConstraints { make in
                                        make.edges.equalToSuperview()
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func reloadVipStatusInfo(){
        self.mainView.vipStatusView.type = (UserInfo.getSharedInstance().vip ?? false) ? 1 : 0
        self.mainView.vipStatusView.setupUI()
        self.mainView.reloadVipPrice()
        self.mainView.vipStatusView.snp.updateConstraints { make in
            make.height.equalTo((UserInfo.getSharedInstance().vip ?? false) ? 202 : 162)
        }
    }
}
