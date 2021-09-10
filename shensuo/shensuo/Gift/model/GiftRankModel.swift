//
//  GiftRankModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/15.
//

import UIKit
import KakaJSON

struct GiftRankModel : Convertible {

    let totalGifts: Int? = 0
    let id: String? = ""
    let parentId: String? = ""
    let totalPeople: Int? = 0
    let gifts: GiftPageModel? = nil
    let name: String? = ""
    let joinTime: String = ""
    
}

struct GiftPageModel : Convertible {
    let pageSize: Int? = 0
    let number: Int? = 0
    let totalElements: Int? = 0
    let content: [GiftUserModel]? = nil
}

struct GiftUserModel : Convertible {
    let headImage: String? = ""
    let id: String? = ""
    let parentId: String? = ""
    let total: Int? = 0
    let points: Int? = 0
    let name : String? = ""
    let panking: Int? = 0
    let image : String? = ""
}
