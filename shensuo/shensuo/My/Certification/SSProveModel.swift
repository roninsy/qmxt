//
//  SSProveModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/24.
//

import UIKit
import KakaJSON

struct SSProveModel: Convertible {

    var businessLicenseImages:String = ""
    var certificateImages:String = ""
    var certificationId:Int = 0
    var cityName:String = ""
    var companyName:String = ""
    var creditCode:String = ""
    var detailAddress:String = ""
    var idimages:String = ""
    var operatorIDNumber:String = ""
    var operatorMobile:String = ""
    var operatorName:String = ""
    var provinceName:String = ""
    var showWords:String = ""
    var type = 0
    var status = 0
    var auditFailureReason: String = ""
    var nickName: String = ""
    var id: String = ""
    
    
    
}
struct SSCompanyIdModel: Convertible {

    var companyId:String = ""
    //企业名称
    var companyName:String = ""
    //社会信用代码
    var creditCode:String = ""
  
    var isSelectCell: Bool = false
    
}
