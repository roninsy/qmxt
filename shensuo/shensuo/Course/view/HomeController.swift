//
//  HomeView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/11.
//

import UIKit
import SwiftyUserDefaults
import SnapKit
import MBProgressHUD
import WebKit

class HomeController: HQBaseViewController {
    ///是否需要预加载方案首页
    var needLoadProjectHtml = true
    
    let mainView = HomeView()
    
    ///签到模型
    var signModel : SignModel? = nil{
        didSet{
            let count = (signModel!.signList?.count ?? 0)
            if count > 1{
                for i in 0...(count-1){
                    let md = signModel!.signList![i]
                    if md.today! {
                        UserInfo.getSharedInstance().todaySign =  md.sign!
                        if md.sign! == false && UserInfo.getSharedInstance().tipSign && UserInfo.getSharedInstance().token != userDefultToken{
                            ///只弹出一次签到提醒
                            UserInfo.getSharedInstance().tipSign = false
                            let qianDaoView = QianDaoDetalisView()
                            HQGetTopVC()?.view.addSubview(qianDaoView)
                            qianDaoView.snp.makeConstraints { (make) in
                                make.edges.equalToSuperview()
                            }
                            qianDaoView.closeBlock = {
                                ///关闭时检查学习提醒
                                if UserInfo.getSharedInstance().homeTipStudy && UserInfo.getSharedInstance().token != userDefultToken{
                                    AddStudyTipView(type: 3)
                                }
                            }
                        }else{
                            if UserInfo.getSharedInstance().homeTipStudy && UserInfo.getSharedInstance().token != userDefultToken{
                                AddStudyTipView(type: 3)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(NavStatusHei)
        }
        clearBrowserCache()
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        UserInfo.getSharedInstance().appVersion = appVersion.toDouble
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        ///用户是否登录
        let isLog = UserIsLogin()
        if isLog{
            getVersion()
            GetUserAc()
            self.mainView.getNetInfo()
            if self.needLoadProjectHtml{
                self.upVipInfo()
                self.needLoadProjectHtml = false
                let url = "\(ProjectHomeURL)?height=\(screenHei)"
                WKWebView().load(.init(url: URL.init(string: url)!))
            }
            if mainView.headView.midView.model != nil && self.mainView.isPlay == true {
                self.mainView.headView.midView.player.play()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
//            HQPush(vc: InputBodyInfoVC(), style: .default)
        }else{
            PushToLogin()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mainView.headView.midView.player.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkIpaOrder()
    }
    
    func upVipInfo(){
        ///获取签到信息
        UserNetworkProvider.request(.sign) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            if model?.data != nil {
                                let signModel : SignModel? = model!.data!.kj.model(type: SignModel.self) as? SignModel
                                self.signModel = signModel
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        }
                    }
                } catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }

        if UserInfo.getSharedInstance().mobile == nil || UserInfo.getSharedInstance().nickName == nil {
            UserNetworkProvider.request(.getUserInfo) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                UserInfo.getSharedInstance().userInfo = model?.data as NSDictionary?
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
        
        UserNetworkProvider.request(.vipInfo) { result in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().vipInfo = model?.data as NSDictionary?
                        }
                    }
                } catch {
                    
                }
                
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
        
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.startLocation()
    }
    
    func clearBrowserCache() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in
            for record in records{
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    print("清除成功\(record)")
                })
            }
        })
    }
    
    ///检查苹果内购是否有未校验订单
    func checkIpaOrder(){
        let userTokenKey = DefaultsKey<String?>(ipaOrderKeyString)
        let encodeStr = Defaults[key: userTokenKey]
        if encodeStr != nil && encodeStr?.count != 0 {
            ///存在未完成订单，向服务端发起校验
            checkPayId(pid: encodeStr!)
        }
    }
}
