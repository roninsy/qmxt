//
//  SSExchangeModel.swift
//  shensuo
//
//  Created by  yang on 2021/5/8.
//

import UIKit
import KakaJSON


//{\"id\":\"5\",\"userId\":\"1\",\"createdTime\":1620460709000,\"name\":\"xx\",\"exchangeCouponsId\":\"203760086110633994\",\"type\":2,\"useCondition\":2,\"payMore\":2.0,\"discount\":1.0,\"worth\":1.0,\"startDate\":1620403200000,\"endDate\":1620835200000,\"used\":false,\"usedTime\":null,\"usedRemark\":null,\"courseId\":null,\"orderId\":null}],\"start\":0,\"totalPages\":\"1\"}}
    
struct SSExchangeModel: Convertible {

    var money: Double?
    var courseId: String?
    var createdTime: Double?
    var discount: String?
    var endDate: String?
    var id: String?
    var exchangeCouponsId: String?
    var name: String?
    var orderId: String?
    var payMore: String?
    var startDate: String?
    var type: Int?
    var useCondition: Int?
    let used: Bool = false
    let nice: Bool = false
    var usedRemark: String?
    var usedTime: String?
    var userId: String?
    var worth: String?
    var isOpen = false
    
    var remarkHei : CGFloat = 18
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        if self.usedRemark != nil && self.usedRemark != "" {
            let titleStr = "备注：\(self.usedRemark ?? "")"
            self.remarkHei = titleStr.ga_heightForComment(font: .systemFont(ofSize: 12), width: screenWid - 52, maxHeight: 80) + 10
            if remarkHei < 18 {
                remarkHei = 18
            }

        }
    }
}

