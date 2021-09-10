//
//  SSCommunityListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/23.
//
///社区主页

import UIKit
import SnapKit
import JXPagingView
import AMapLocationKit

enum comDataType {
    case focus    //关注
    case recommend //推荐
    case sameCity //同城
}


//动态数据
class SSCommunityListView: UIView,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var setSameCityTitleBlcok: stringBlock?
    var noLocationObject: SSCommonNoLocationObject?
    var noDataObject: SSCommonNoDataObject?
    var dataCollectionView: UICollectionView!
    var navController: UINavigationController!
    var loadType:comDataType = .focus
    var locationManager = AMapLocationManager()
    var cityName = ""
    var page = 1
    var totalNum = 0
    
    var pageSize = 20
    var itemWidth : CGFloat = 0
    var models:[SSCommitModel]? = nil {
        didSet {
            if models != nil {
                if self.noDataObject != nil {
                    self.noDataObject!.noDataView.isHidden = true
                }
                self.dataCollectionView.reloadData()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        
        //        let itemMargin: CGFloat = 10
        itemWidth = floor((UIScreen.main.bounds.size.width - 12*3)/2)
        //        let layout = UICollectionViewFlowLayout.init()
        //        layout.itemSize = CGSize(width: itemWidth, height: itemWidth/193*322)
        //        layout.sectionInset = UIEdgeInsets.init(top: itemMargin, left: itemMargin, bottom: 0, right: itemMargin)
        dataCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(dataCollectionView)
        dataCollectionView.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-(SafeBottomHei + 49))
        }
        
        dataCollectionView.backgroundColor = UIColor.init(hex: "#FCFCFC")
        dataCollectionView.backgroundColor = bgColor
        dataCollectionView.register(SSComDataCellView.self, forCellWithReuseIdentifier: "SSComDataCellView")
        dataCollectionView.showsVerticalScrollIndicator = false
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        dataCollectionView.contentInsetAdjustmentBehavior = .never
        
        dataCollectionView.mj_header = MJRefreshHeader.init(refreshingBlock: {
            self.page = 1
            if self.loadType == .focus{
                self.loadFirstData()
            }else if self.loadType == .recommend{
                self.loadRecommendData()
            }else{
                self.loadSameCityData()
            }
        })
        
        dataCollectionView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            if self.loadType == .focus{
                self.loadFirstData()
            }else if self.loadType == .recommend{
                self.loadRecommendData()
            }else{
                self.loadSameCityData()
            }
        })
        dataCollectionView?.contentInsetAdjustmentBehavior = .never
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadSameCityData() -> Void {
        CommunityNetworkProvider.request(.localNote(pageNumber: self.page, pageSize: self.pageSize, userId: UserInfo.getSharedInstance().userId ?? "", city: self.cityName)) { (result) in
            self.dataCollectionView.mj_header?.endRefreshing()
            self.dataCollectionView.mj_footer?.endRefreshing()
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
                            //                                    self.dataCollectionView.reloadData()
                            
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func loadRecommendData() -> Void {
        
        CommunityNetworkProvider.request(.recommendNote(pageNumber: self.page, pageSize: self.pageSize, userId: UserInfo.getSharedInstance().userId ?? "")) { (result) in
            self.dataCollectionView.mj_header?.endRefreshing()
            self.dataCollectionView.mj_footer?.endRefreshing()
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
                            
                            //                                    self.dataCollectionView.reloadData()
                            
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
            self.dataCollectionView.mj_header?.endRefreshing()
            self.dataCollectionView.mj_footer?.endRefreshing()
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
                            //                                    self.dataCollectionView.reloadData()
                            
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = self.models?.count ?? 0
        if totalNum <= num {
            self.dataCollectionView.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.dataCollectionView.mj_footer?.endRefreshing()
        }
        return num
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
            vc.reloadBlock = { [weak self] in
                if self?.loadType == .focus{
                    self?.loadFirstData()
                }else if self?.loadType == .recommend{
                    self?.loadRecommendData()
                }else{
                    self?.loadSameCityData()
                }
            }
            vc.type = type
            vc.models.append(model ?? SSCommitModel())
            HQPush(vc: vc, style: .lightContent)
            return
        }
        
        let vc = SSCommunityDetailViewController()
        vc.dataModel = model
        HQPush(vc: vc, style: .default)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemWidth/193*322)
    }
}


