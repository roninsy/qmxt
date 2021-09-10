//
//  SSBillDetailModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/13.
//

import UIKit
import KakaJSON

//{\"categoryName\":\"完成方案小节\",\"points\":\"-50\",\"id\":\"11223\",\"remarks\":\"Hai\",\"userName\":null,\"createdTime\":1620718991000}
//{\"categoryName\":\"获得现金\",\"money\":-20.00,\"id\":\"22\",\"remarks\":\"ghfh\",\"teacherUserName\":null,\"copyrightUserName\":null,\"payeeUserName\":\"全民形体平台\",\"createdTime\":\"2021-05-21 19:51:38\"}

struct SSBillDetailModel: Convertible {

    var transactionTime : String = ""
    var categoryName : String = ""
    var points : Int = 0
    var id : String = ""
    var remarks : String = ""
    var contentOwner : String = ""
    var userName : String = ""
    var createdTime : String? = ""
    var money : NSNumber = 0
    var teacherUserName : String = ""
    var copyrightUserName : String = ""
    var payeeUserName : String = ""
    var payerUserName: String = ""
    var payChannel: Int = 0
    var payId: String = ""
    var otherSideName: String = ""
    var categoryId = -1 
    //技术服务费
    var technologyServiceFee: String = ""
    //提现服务费比例
    var withdrawServiceFee: String = ""
    // 分成比例
    var shareRatio: String = ""
    //价值美币
    var valuePoints : String = ""

    var tutorUserName: String = ""
    //0位余额操作+，1位第三方支付操作不显示+- 2:-
    var transactionType: Int = -1
    
    var height : CGFloat = 0
    
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        let width = screenWid-100
        self.height = remarks.ga_heightForComment(font: .systemFont(ofSize: 16), width: width, maxHeight: 100)
    }
    
}
