//
//  SSAddressController.swift
//  shensuo
//
//  Created by  yang on 2021/6/23.
//

import UIKit
import AMapSearchKit
import AMapLocationKit
typealias addressBackBlock = (_ str : String,_ cityName : String)->()
class SSAddressController: SSBaseViewController ,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource{

    let search = AMapSearchAPI()
    let request = AMapPOIAroundSearchRequest()
    let locationManager = AMapLocationManager.init()
    var poisArr = [AMapPOI]()
    let cellId = "poisArrCell"
    let tableView = UITableView.init()
    var selCell : PoiCell?
    let tipV = UIView()
    let marginV = UIView()
    var tipL: UILabel!
    var searchStr = ""
    var customLocation: CLLocation!
    var adressSelectBlock: addressBackBlock? = nil
    var currentStr: String!
    var cityName: String = ""
    
    
//    @objc var vc : PublishTrendViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func enterSel() {
        if selCell != nil {
//            vc?.poi = selCell?.poi
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        buildUI()
        mapInfo()
    }
    
    func buildUI() {
        
        let searchView = SSReleaseSearchView.init()
        self.navView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        searchView.searchBlcok = { [weak self] title in
            
            self?.searchStr = title
            self?.requestPOI(location: self?.customLocation ?? CLLocation.init(), name: title)
            self?.view.endEditing(true)

        }
        searchView.cancleBlcok = {[weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(tipV)
        tipV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.navView.snp.bottom)
            make.height.equalTo(0)
        }
        tipL = UILabel.initSomeThing(title: "", fontSize: 14, titleColor: .init(hex: "#B4B4B4"))
        tipV.addSubview(tipL)
        tipL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        marginV.backgroundColor = bgColor
        view.addSubview(marginV)
        marginV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(normalMarginHeight)
            make.top.equalTo(tipV.snp.bottom)
        }
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(marginV.snp.bottom)
        }
        tableView.separatorStyle = .none
        
    }
    
    func mapInfo() {
        
        ///设置搜索代理
        search?.delegate = self
        ///设置反地理位置和搜索精度（2s精度为100米左右，10s的时候精度为50米）
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        
        // 发起定位
        locationManager.requestLocation(withReGeocode: false, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let location = location {
                ///发起POI搜索
                var name = ""
                if let reGeocode = reGeocode {
                    NSLog("reGeocode:%@", reGeocode)
                    name = reGeocode.poiName
                }
                self?.requestPOI(location: location, name: name)
            }
            self?.customLocation = location
        })
    }
    
    ///发起检索传入定位location和关键字name
    func requestPOI(location : CLLocation,name : String) {
        self.request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
        self.request.keywords = name
        self.request.requireExtension = true
        request.sortrule = 0
        search!.aMapPOIAroundSearch(request)
    }
    
    ///检索周边poi回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.count > 0 {
//
//            return
            self.poisArr = response.pois

        }else{
            
            self.poisArr = []
        }
        NSLog("检索回调成功")
//        self.poisArr = response.pois
        DispatchQueue.main.async(execute: {
                            
            if self.poisArr.count > 0 && self.searchStr.length > 0 {
                self.tipL.isHidden = false
                self.tipL.text = "共搜到\(self.poisArr.count)个与“\(self.searchStr)”相关信息"
    
                let protocolText = NSMutableAttributedString(string: self.tipL!.text!)
        //        userProtocolLabel.textColor = .init(hex: "#6A7587")
                let range1: Range = self.tipL!.text!.range(of: "\(self.poisArr.count)")!
                let range: Range = self.tipL!.text!.range(of: self.searchStr)!
                let startLocation = self.tipL!.text!.distance(from: self.tipL!.text!.startIndex, to: range.lowerBound)
                let startLocation1 = self.tipL!.text!.distance(from: self.tipL!.text!.startIndex, to: range1.lowerBound)

                protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation, length: self.searchStr.length))
                protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation1, length: String(self.poisArr.count).length))
                self.tipL.attributedText = protocolText
                
                self.tipV.snp.updateConstraints { make in
                    
                    make.height.equalTo(40)
                }
            }else{
                
                self.tipV.snp.updateConstraints { make in
                    
                    make.height.equalTo(0)
                }
                self.tipL.isHidden = true
            }
                self.tableView.reloadData()

            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poisArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PoiCell
        if cell == nil {
            cell = PoiCell.init(style: .default, reuseIdentifier: cellId)
        }
        if indexPath.row == 0{
            cell?.title.isHidden = true
            cell?.subTitle.isHidden = true
            cell?.dontShow.isHidden = false
            cell?.poi = nil
            cell?.selImg.isHidden = currentStr.length == 0 ? false : true
        }else{
            cell?.title.isHidden = false
            cell?.subTitle.isHidden = false
            cell?.dontShow.isHidden = true
            let poi = poisArr[indexPath.row - 1]
//            cell?.title.text = poi.name
            cell?.subTitle.text = String.init(format: "%@%@%@%@", poi.province,poi.city,poi.district,poi.address)
            cell?.poi = poi
            cell?.selImg.isHidden = (poi.name == currentStr) ? false : true
            cell?.title.attributedText = setSearchStrColor(str: poi.name)
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func setSearchStrColor(str: String) -> NSMutableAttributedString{
        
        let protocolText = NSMutableAttributedString(string: str)
        if self.searchStr.length == 0 {
            
            return protocolText
        }
//        userProtocolLabel.textColor = .init(hex: "#6A7587")
        let range: Range = str.range(of: self.searchStr)!
        let startLocation = str.distance(from: str.startIndex, to: range.lowerBound)
        
        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation, length: searchStr.length))
        return protocolText
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        let cell = tableView.cellForRow(at: indexPath) as! PoiCell
//        if cell == selCell {
//            return
//        }
//        cell.isSelected = true
//        if selCell != nil {
//            selCell!.isSelected = false
//        }
//        self.selCell = cell
        var str: String = ""
        
        if indexPath.row == 0 {
            
            str = ""
            
        }else{
            let poi = poisArr[indexPath.row - 1]
            str = poi.name
            self.cityName = poi.city
        }
        self.adressSelectBlock?(str,self.cityName)
        self.navigationController?.popViewController(animated: true)
    }

}

