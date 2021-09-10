//
//  SSPersonModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/24.
//

import UIKit
import KakaJSON

struct SSPersonModel: Convertible {

    var certificateImages:[String]?
    var idimages:[String]?
    var ownerCompanyId:String = ""
    var ownerCompanyName:String = ""
    var idname:String = ""
    var idnumber:String = ""
    var mobile:String = ""
    var showWords:String = ""
    var companyName:String = ""
    var areaCode:String? = ""
    var businessLicenseImages:[String] = []
    var certificationId:String = ""
    var checkCode:String = ""
    var cityName:String = ""
    var creditCode:String = ""
    var detailAddress:String = ""
    var operatorIDNumber:String = ""
    var operatorName:String = ""
    var provinceName:String = ""
    var operationName: String = ""
    var operatorMobile:String = ""
    
}

