//
//  SSCustomApi.swift
//  shensuo
//
//  Created by  yang on 2021/6/25.
//

import UIKit
import Moya
public typealias Completion = (_ result: Result<Moya.Response, MoyaError>) ->Void

class SSCommonApi: NSObject {

    
    class func laod(completion: @escaping Completion,releaseModel: SSReleaseModel) {
        
        CourseNetworkProvider.request(.publish(address: releaseModel.address, cityName: releaseModel.cityName, content: releaseModel.content, headImageName: releaseModel.headImageName, imageNames: releaseModel.imageNames, musicUrl: releaseModel.musicUrl, noteType: "\(releaseModel.noteType)", title: releaseModel.title, videoName: releaseModel.videoName,id:releaseModel.id), completion: completion)
    }
}
