//
//  SSFriendTableViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit
import AMapLocationKit
import JXPagingView
//推荐/附近/认证企业/认证个人
class SSFriendTableViewController: UITableViewController {

    var noLocationObject: SSCommonNoLocationObject?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var navController: UINavigationController!
//    var searchView:SSsearchView = {
//        let search = SSsearchView.init()
//        return search
//    }()
    var listModels: [SSRegisterModel]?
    var focusPopModels: [SSFocusPopModel]?
    //0: 推荐 1: 附近 2: 认证企业 3: 认证个人
    var inType = 0
    
    var locationManager = AMapLocationManager()
    var current_location: CLLocation?
    var number: Int = 1
    var pageSize = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        focusPopModels?.removeAll()
        if inType != 1 {
            
            self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                self.number += 1
                
                    
              self.loadSuggestedFollowsData()
                    
            })
        }
        tableView.register(focusCell.self, forCellReuseIdentifier: "focusCellID")
        tableView.tableFooterView = UIView.init()
        tableView.rowHeight = 103
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func becomeActive()  {
         
         mapInfo()
    }
    
    func loadData() -> Void {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        number = 1
        if self.focusPopModels != nil {
            
            focusPopModels?.removeAll()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.view.addSubview(searchView)
//        searchView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.left.equalToSuperview()
//            make.height.equalTo(54)
//        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inType != 1 {
            
            return focusPopModels?.count ?? 0
        }
        return self.listModels?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "focusCellID") as! focusCell
        if inType != 1 {
            
            cell.focusModel = focusPopModels?[indexPath.row]
            
        }else{
            
            cell.friendListModel =  listModels?[indexPath.row]
        }
        cell.selectionStyle = .none
        // Configure the cell...
        return cell
    }
    
    func loadFirstData() {
        
        UserInfoNetworkProvider.request(.nearbyList) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                let dic = model!.data
                                if dic == nil {
                                    return
                                }
                                self.listModels = model?.data?.kj.modelArray(SSRegisterModel.self)
                                self.tableView.reloadData()
//                                let total = dic?["totalElements"] as! String
//
//                                if (total.toInt ?? 0) > 0 {
//                                    let arr = dic?["content"] as! NSArray
//
//                                }else{
//    //                                self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
//                                }
                            }else{
                                
                            }
                        }
                    } catch {
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
        
        self.tableView.reloadData()
    }

    func loadLoactionData()  {
        UserInfoNetworkProvider.request(.geoPost(latitude: self.current_location?.coordinate.latitude ?? 0.0, longitude: self.current_location?.coordinate.longitude ?? 0.0, userId: UserInfo.getSharedInstance().userId ?? "")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
//                                self.loadsearchUserData()
                                self.loadFirstData()
                            }else{
                                
                            }
                        }
                    } catch {
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
        }
    
    func loadSuggestedFollowsData() -> Void {
        CommunityNetworkProvider.request(.getSuggestedFollows(pageNumber: number, pageSize: pageSize, userId: UserInfo.getSharedInstance().userId ?? "" ,userType: inType == 0 ? "" : (inType == 3 ? "1" : "2"))) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                if dic == nil {
                                    return
                                }
                                let total = dic?["totalElements"] as! String
                                if (total.toInt ?? 0) > 0 {
                                    let arr = dic?["content"] as! NSArray
                                    
                                    if self.number == 1 {
                                        self.focusPopModels = arr.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
                                    } else {
                                        self.focusPopModels! += (arr.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel])!
                                    }
                                    self.isHiddenFooter(model: self.focusPopModels as AnyObject)
                                    
                                }
                                self.tableView.reloadData()
                            }else{
                                
                                self.focusPopModels?.removeAll()
                                self.tableView.reloadData()
                                self.tableView.mj_footer?.isHidden = true

                            }

                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count < number*pageSize {
            self.tableView.mj_footer?.isHidden = true
        }
    }
//    func loadsearchUserData() -> Void {
//        CommunityNetworkProvider.request(.searchUser(pageNumber: number, pageSize: pageSize, userId: UserInfo.getSharedInstance().userId ?? "", keyWord: "", userType: "1")) { (result) in
//            switch result {
//                case let .success(moyaResponse):
//                    do {
//                        let code = moyaResponse.statusCode
//                        if code == 200{
//                            let json = try moyaResponse.mapString()
//                            let model = json.kj.model(ResultDicModel.self)
//                            if model?.code == 0 {
//                                let dic = model?.data
//                                if dic == nil {
//                                    return
//                                }
//                                let total = dic?["totalElements"] as! String
//                                if (total.toInt ?? 0) > 0 {
//                                    let arr = dic?["content"] as! NSArray
//
//                                    if self.number == 1 {
//                                        self.focusPopModels = arr.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
//                                    } else {
//                                        self.focusPopModels! += (arr.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel])!
//                                    }
//                                    self.isHiddenFooter(model: self.focusPopModels as AnyObject)
//
//                                }
//
//
//                            }else{
//                                self.tableView.mj_footer?.isHidden = true
//
//                            }
//                            self.tableView.reloadData()
//                        }
//
//                    } catch {
//
//                    }
//                case let .failure(error):
//                    logger.error("error-----",error)
//                }
//        }
//    }
    //定位
    func mapInfo(){

       
        let commonLocation = SSCommonLocation()
        
        let locStatus = commonLocation.loacationStatus()
        
        if !locStatus {
            AppDelegate().hasLocation = false
            NSLog("去定位")
            if noLocationObject == nil {
                
                noLocationObject = SSShowNoLocationView(parentView: tableView, tips: "")
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
            if AppDelegate().hasLocation {
                
                loadFirstData()
            }else{
                
                if noLocationObject != nil {
                    
                    noLocationObject?.noDataView.isHidden = true
                }
              commonLocation.mapLoaction(mapLocation: { location  in
                    NSLog("%@",location)

                self.current_location = location
                AppDelegate().hasLocation = true
                self.loadLoactionData()
                }, mapReGeocode: {[weak self] reGeocode in
                  
                  

                  //                NSLog("reGeocode:%@", reGeocode)
                }, locationManager: locationManager)
                
            }
            }
            
}
}
extension SSFriendTableViewController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView!
    }
    
}
