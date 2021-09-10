//
//  SSCityModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/14.
//

import UIKit
import KakaJSON

//{\"id\":\"1\",\"code\":\"100000\",\"name\":\"北京\",\"parentId\":\"0\",\"cityList\":[{\"id\":\"2\",\"code\":\"110000\",\"name\":\"北京市\",\"parentId\":\"1\",\"cityList\":null}]}
struct SSProvinceModel : Convertible{
    var id : Int = 0
    var code : Int = 0
    var name : String = ""
    var parentId : Int = 0
    var cityList : [SSCityModel]?
}

struct SSCityModel : Convertible {

    
    var id : Int = 0
    var code : Int = 0
    var name : String = ""
    var parentId : Int = 0
    var cityList : String = ""

}
