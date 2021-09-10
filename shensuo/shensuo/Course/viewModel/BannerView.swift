//
//  BannerView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/13.
//

import UIKit
import Kingfisher
import Toast_Swift
import LLCycleScrollView

///首页轮播
class BannerView: UIView,LLCycleScrollViewDelegate {
    ///1首页、2课程、3方案
    var type = 0
    //
    let banner = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width: screenWid, height: screenWid / 2))
    var models : [BananerImageModel]? = nil{
        didSet{
            if models != nil {
                var imgArr : [String] = NSMutableArray() as! [String]
                for model in models!{
                    let str = model.image ?? ""
                    imgArr.append(str)
                }
                banner.imagePaths = imgArr
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        // 添加到view
        self.addSubview(banner)
        banner.delegate = self
        banner.backgroundColor = .init(hex: "#EAEAEA")
        banner.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        if type == 1 {
            self.homeData()
        }
        if type == 2 {
            self.courseData()
        }
        if type == 3 {
            self.projectData()
        }
    }
    
    func homeData(){
        NetworkProvider.request(.homeBananer) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let arr : NSArray = model!.data!
                            self.models = arr.kj.modelArray(type: BananerImageModel.self)
                                as? [BananerImageModel]
                        }
                    }
                    
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    func courseData(){
        NetworkProvider.request(.courseBananer) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let arr : NSArray = model!.data!
                            self.models = arr.kj.modelArray(type: BananerImageModel.self)
                                as? [BananerImageModel]
                        }
                    }
                    
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    func projectData(){
        NetworkProvider.request(.projectBananer) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let arr : NSArray = model!.data!
                            self.models = arr.kj.modelArray(type: BananerImageModel.self)
                                as? [BananerImageModel]
                        }
                    }
                    
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    func cycleScrollView(_ cycleScrollView: LLCycleScrollView, didSelectItemIndex index: NSInteger) {
        let model = self.models?[index]
        if model != nil {
            var pageName = ""
            if type == 1 {
                pageName = "首页广告位"
            }else if type == 2{
                pageName = "课程广告位"
            }else{
                pageName = "方案广告位"
            }
            if model?.type == 2 || model?.type == 3 || model?.type == 12{
                if model?.type == 12 {
                    ///上报事件
                    HQPushActionWith(name: "click_publish_note", dic:  ["current_page":pageName])
                }else{
                    ///上报事件
                    HQPushActionWith(name: "click_course_detail", dic:  ["current_page":pageName,
                                                                         "course_frstcate":"",
                                                                         "course_secondcate":""
                                                                         ,"course_id":model?.contentId ?? ""
                                                                         ,"course_title":""])
                }
                
            }
            ///上报事件
            HQPushActionWith(name: "bannerClick", dic:  ["current_page":pageName,
                                                                "banner_name":model?.name ?? "",
                                                                "banner_location":model?.sort ?? 0,
                                                                "banner_id":model?.id ?? "",
                                                                "type":GetPushTypeName(type: model?.type ?? 0)])
            
            GotoTypeVC(type: model?.type ?? 0, cid: model?.contentId ?? "")
        }
    }
}

