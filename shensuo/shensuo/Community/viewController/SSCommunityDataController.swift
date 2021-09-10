//
//  communityDataController.swift
//  shensuo
//
//  Created by swin on 2021/3/22.
//

import Foundation
import SnapKit
import JXPagingView
import AMapLocationKit

//动态数据
class SSCommunityDataController: HQBaseViewController {
    
    var setSameCityTitleBlcok: stringBlock?
    var noLocationObject: SSCommonNoLocationObject?
    var noDataObject: SSCommonNoDataObject?
    var dataCollectionView: UICollectionView!
    var navController: UINavigationController!
    var loadType:comDataType = .recommend
    var locationManager = AMapLocationManager()
    var cityName = ""
    var page = 1
    var totalNum = 0
    
    var pageSize = 10
    var models:[SSCommitModel]? = nil {
        didSet {
            if models != nil {
                self.dataCollectionView.reloadData()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
       
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        layout.scrollDirection = .vertical
        dataCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithFrame(frame: CGRect) {
        self.view.frame = frame
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(dataCollectionView)
        dataCollectionView.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-(SafeBottomHei + 49))
        }

        dataCollectionView.backgroundColor = UIColor.init(hex: "#FCFCFC")
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        dataCollectionView.showsVerticalScrollIndicator = true
        dataCollectionView.backgroundColor = bgColor
        dataCollectionView.register(SSComDataCellView.self, forCellWithReuseIdentifier: "SSComDataCellView")
        if loadType == .sameCity {
            
            NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        self.dataCollectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            
            if self.loadType == .focus{
                
                self.loadFirstData()
                
            }else if self.loadType == .recommend{
                
                self.loadRecommendData()
                
            }else{
                
                self.loadSameCityData()
            }
                
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
   @objc func becomeActive()  {
        
        mapInfo()
   }
    
    
    
    func loadSameCityData() -> Void {
        
        CommunityNetworkProvider.request(.localNote(pageNumber: self.page, pageSize: self.pageSize, userId: UserInfo.getSharedInstance().userId ?? "", city: self.cityName)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                let dic = model!.data
                                if dic == nil {
                                    self.setNoDataStr(str: "暂无数据")
                                    return
                                }
                                let total = dic?["totalElements"] as! String

                                if (total.toInt ?? 0) > 0 {
                                    let arr = dic?["content"] as! NSArray
                                    if self.page == 1 {
                                        self.models = arr.kj.modelArray(type: SSCommitModel.self)
                                            as? [SSCommitModel]
                                        
                                    }else{
                                        let models = arr.kj.modelArray(type: SSCommitModel.self)
                                            as? [SSCommitModel]
//
                                        self.models = (self.models ?? []) + (models ?? [])
                                    }
                                    self.isHiddenFooter(model: self.models as AnyObject,total: total.toInt ?? 0)
//                                    self.dataCollectionView.reloadData()
                                }else{
                                    self.dataCollectionView?.mj_footer?.endRefreshingWithNoMoreData()
                                }
                            }else{
                                if self.models != nil && self.models?.count ?? 0 > 0 {
                                        self.setNoDataStr(str: "暂无数据")

                                }
                                HQGetTopVC()?.view.makeToast(model?.message)

                            }
                        }
                    } catch {
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    func isHiddenFooter(model:AnyObject,total: Int) -> Void {
        if model.count <= total {
            self.dataCollectionView?.mj_footer?.isHidden = true
        }
    }
    func loadRecommendData() -> Void {

        CommunityNetworkProvider.request(.recommendNote(pageNumber: self.page, pageSize: self.pageSize, userId: UserInfo.getSharedInstance().userId ?? "")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                let dic = model!.data
                                if dic == nil {
                                    
                                    self.setNoDataStr(str: "暂无推荐")

                                    return
                                }
                                let total = dic?["totalElements"] as! String
                                self.totalNum = total.toInt ?? 0
                                if (total.toInt ?? 0) > 0 {
                                    let arr = dic?["content"] as! NSArray
                                    if self.page == 1 {
                                        self.models = arr.kj.modelArray(type: SSCommitModel.self)
                                            as? [SSCommitModel]
                                        
                                    }else{
                                        let models = arr.kj.modelArray(type: SSCommitModel.self)
                                            as? [SSCommitModel]
//
                                        self.models = (self.models ?? []) + (models ?? [])
                                    }
                                    
                                    self.isHiddenFooter(model: self.models as AnyObject,total: total.toInt ?? 0)
//                                    self.dataCollectionView.reloadData()
                                }else{
                                    self.dataCollectionView?.mj_footer?.endRefreshingWithNoMoreData()
                                    if self.models != nil && self.models?.count ?? 0 > 0 {
                                        
                                            self.setNoDataStr(str: "暂无推荐")

                                    }
                                }
                            }else{
                                
                                HQGetTopVC()?.view.makeToast(model?.message)
                            }
                        }
                    } catch {
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func loadFirstData() {
        
      
        CommunityNetworkProvider.request(.attentionNote(pageNumber: self.page, pageSize: self.pageSize, userId: UserInfo.getSharedInstance().userId ?? "")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                let dic = model!.data
                                if dic == nil {
                                    self.setNoDataStr(str: "暂无数据")
                                    return
                                }
                                let total = dic?["totalElements"] as! String
                                self.totalNum = total.toInt ?? 0
                                if (total.toInt ?? 0) > 0 {
                                    if self.noDataObject != nil {
                                        self.noDataObject!.noDataView.isHidden = true
                                    }
                                    let arr = dic?["content"] as! NSArray
                                    if self.page == 1 {
                                        self.models = arr.kj.modelArray(type: SSCommitModel.self)
                                            as? [SSCommitModel]
                                        
                                    }else{
                                        let models = arr.kj.modelArray(type: SSCommitModel.self)
                                            as? [SSCommitModel]
//
                                        self.models = (self.models ?? []) + (models ?? [])
                                    }
                                    self.isHiddenFooter(model: self.models as AnyObject,total: total.toInt ?? 0)
//                                    self.dataCollectionView.reloadData()
                                }else{
                                    self.dataCollectionView?.mj_footer?.endRefreshingWithNoMoreData()
                                    if self.models != nil && self.models?.count ?? 0 > 0 {
                                        
                                        self.setNoDataStr(str: "暂无数据")
                                    }
                                }
                            }else{
                                HQGetTopVC()?.view.makeToast(model?.message)

                            }
                        }
                    } catch {
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func setNoDataStr(str: String)  {
        
        if self.noDataObject == nil {
            
            self.noDataObject = SSShowNoDataView(parentView: self.dataCollectionView!, imageName: "my_nosc", tips: str)
        }else{
            
            self.noDataObject?.noDataView.isHidden = false
        }
    }
    
    //定位
    func mapInfo() -> String{
        
        let commonLocation = SSCommonLocation()
        
        let locStatus = commonLocation.loacationStatus()
        
        if !locStatus {
            
            setSameCityTitleBlcok?("同城")
            NSLog("去定位")
            if noLocationObject == nil {
                
                noLocationObject = SSShowNoLocationView(parentView: dataCollectionView, tips: "")
                noLocationObject?.noDataView.btn.reactive.controlEvents(.touchUpInside).observe({_ in
                    
                    let url = URL.init(string: UIApplication.openSettingsURLString)
                    
                    if UIApplication.shared.canOpenURL(url!){
                        
                        UIApplication.shared.openURL(url!)
                    }

                })
            }else{
                
                noLocationObject?.noDataView.isHidden = false
            }
            
        }else{
            
            if noLocationObject != nil {
                
                noLocationObject?.noDataView.isHidden = true
            }
          commonLocation.mapLoaction(mapLocation: { location  in
                NSLog("%@",location)

                
            }, mapReGeocode: {[weak self] reGeocode in
              
                self?.cityName = reGeocode.city ?? ""
                self?.loadSameCityData()
                self!.setSameCityTitleBlcok?(self?.cityName ?? "")

              //                NSLog("reGeocode:%@", reGeocode)
            }, locationManager: locationManager)
            
        }
        return self.cityName
    }
}



extension SSCommunityDataController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (screenWid - 20) / 2
        return CGSize(width: itemWidth, height: itemWidth/193*322)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "SSComDataCellView", for: indexPath) as! SSComDataCellView
        cellView.fouceModel = self.models?[indexPath.row]
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models?[indexPath.row]
        if model?.noteType == "1" {
            let vc = SSCommunityVedioListVC()
            var type = 1
            if self.loadType == .focus {
                type = 2
            }
            if self.loadType == .sameCity {
                type = 3
            }
            vc.type = type
            vc.models.append(model ?? SSCommitModel())
            HQPush(vc: vc, style: .lightContent)
            return
        }
        
        let vc = SSCommunityDetailViewController()
        vc.dataModel = model
        self.navController?.pushViewController(vc, animated: true)
    }
    
}

