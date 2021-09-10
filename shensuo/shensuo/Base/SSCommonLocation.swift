//
//  SSCommonLocation.swift
//  shensuo
//
//  Created by  yang on 2021/7/16.
//

import UIKit
import AMapLocationKit

typealias locationBlock = (_ location : CLLocation)->()
typealias reGeocodeBlock = (_ reGeocode : AMapLocationReGeocode)->()

class SSCommonLocation: NSObject {
    
//    var locBlock: locationBlock?
//    var regBlock: reGeocodeBlock?
    //locationManager: AMapLocationManager
    
    func loacationStatus() ->Bool {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            
            return true
            
        }else if(authorizationStatus == .notDetermined){
            
            return false
        }
        
        return false
    }
    
    func mapLoaction(mapLocation: @escaping locationBlock,mapReGeocode: @escaping reGeocodeBlock,locationManager: AMapLocationManager
) {
        
        
        ///设置搜索代理

        ///设置反地理位置和搜索精度（2s精度为100米左右，10s的时候精度为50米）
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        
        // 发起定位
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
                    
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
                NSLog("location:%@", location)
                mapLocation(location)
            }
            
            if let reGeocode = reGeocode {
              
                mapReGeocode(reGeocode)
//                mapReGeocode = self?.regBlock?(reGeocode)
            }
        })
        
       
    }
    
}
