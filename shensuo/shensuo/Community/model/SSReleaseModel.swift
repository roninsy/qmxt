//
//  SSReleaseModel.swift
//  shensuo
//
//  Created by  yang on 2021/6/25.
//

import UIKit
import KakaJSON

struct SSReleaseModel: Convertible {

    var address: String = ""
    var content: String = ""
    var headImageName: String = ""
    var title: String = ""
    var cityName: String = ""
    var imageNames: [String] = []
    var musicUrl: String = ""
    var noteType:Int = 2
    var videoName: String = ""
    var locationVideo: URL?
    var locationImg: UIImage?
    var locationImgs: [UIImage] = []
    var id: String = ""
    var shareImg: UIImage?
    
}


struct SSNotesSuccessModel: Convertible {
    
    var points: String? = ""
    let badges: [SSNotesBadgesModel]? = nil
}
struct SSNotesBadgesModel: Convertible {
    
    var badgeImageUrl: String? = ""
    var badgeTypeName: String? = ""
    var creatTime : String? = ""
    var id : String? = ""
    
}



