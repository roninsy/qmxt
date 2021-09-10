//
//  SSOutMoneyModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/18.
//

import UIKit
import KakaJSON


//{\"id\":\"515\",\"withdrawAccount\":\"765723\",\"money\":\"67\",\"applyForTime\":\"2021-05-10 11:02:13\",\"verifyTime\":null,\"remarks\":\"4566\",\"arriveTime\":\"2021-05-10 11:02:16\"}
struct SSOutMoneyModel : Convertible{
    
    var id : String = ""
    var withdrawAccount : String = ""
    var money : Double = 0
    var applyForTime : String = ""
    var verifyTime : String = ""
    var remarks : String = ""
    var arriveTime : String = ""
    var fettle : Int = 0 //0代表待审核, 1审核通过, 2代表审核不通过
    
    var height : CGFloat = 0
    
    
    mutating func kj_willConvertToModel(from json: [String : Any]) {
        id = "a"
    }
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        id = "a"
        if fettle == 0 {
            height = screenWid/414*208 + 20
        } else if fettle == 1 {
            height = screenWid/414*276 + 20
        } else {
            height = screenWid/414*310 + 20
        }
        
    }
    
}
