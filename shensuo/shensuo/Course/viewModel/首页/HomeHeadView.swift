//
//  HomeHeadView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/7.
//

import UIKit
import LLCycleScrollView
import CollectionKit
import WebKit

class HomeHeadView: UIView {
    
    let listView = CollectionView()
    var myHei : CGFloat = 0
    ///轮播视图
    let bannerView = BannerView.init()
    let midView = HomeMidView()
    let recommendLab = UILabel.initSomeThing(title: "为你推荐", fontSize: 18, titleColor: .init(hex: "#333333"))
    
    let homeBtnArr : [UIButton] = NSMutableArray() as! [UIButton]
    let homeBtnImg = ["home_top_icon1","home_top_icon2","home_top_icon3","home_top_icon4"]
    let homeBtnTitle = ["明星导师榜","优质机构榜","体态评估","更多课程"]
    
    let whiteBg = UIView()
    
    var ds = ArrayDataSource<KechengChildTypeModel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F4F5F6")
       
        bannerView.layer.cornerRadius = 9
        bannerView.layer.masksToBounds = true
        
        let bannerWid = screenWid - 24
        let bannerHei = bannerWid / 394 * 168
        
        self.addSubview(whiteBg)
        whiteBg.backgroundColor = .white
        whiteBg.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(bannerHei + 114)
        }
        self.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(12)
            make.width.equalTo(bannerWid)
            make.height.equalTo(bannerHei)
        }
        
        let btnBG = UIView()
        btnBG.backgroundColor = .white
        self.addSubview(btnBG)
        btnBG.snp.makeConstraints { make in
            make.height.equalTo(81)
            make.top.equalTo(bannerView.snp.bottom).offset(17)
            make.left.right.equalToSuperview()
        }
        
        let btnWid = screenWid  / 4
        for i in 0...3{
            let btn = UIButton.initTopImgBtn(imgName: homeBtnImg[i], titleStr: homeBtnTitle[i], titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), imgWid: 56)
            btn.tag = i
            btnBG.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.left.equalTo(btnWid * CGFloat(i))
                make.top.bottom.equalToSuperview()
                make.width.equalTo(btnWid)
            }
            btn.reactive.controlEvents(.touchUpInside).observeValues { btn1 in
                if btn1.tag == 2{
                    ///体态评估
                    let url = "\(ProjectScanURL)?type=only&height=\(screenHei)&token=\(UserInfo.getSharedInstance().token ?? "")"
                    print("url -- \(url)")
                    let webVC = HQWebVC()
                    webVC.url = url
                    webVC.isFullScreen = true
                    HQPush(vc: webVC, style: .lightContent)
                }else if btn1.tag == 1{
                    let vc = GoodMasterController()
                    vc.setupWithType(type: 2)
                    HQPush(vc: vc, style: .lightContent)
                }else if btn1.tag == 0{
                    let vc = GoodMasterController()
                    vc.setupWithType(type: 1)
                    HQPush(vc: vc, style: .lightContent)
                }else if btn1.tag == 3{
                    let vc = SearchCourseVC()
                    HQPush(vc: vc, style: .default)
                }
            }
        }
        
        self.addSubview(midView)
        midView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(whiteBg.snp.bottom).offset(59)
            make.height.equalTo(midView.myHei)
        }
        myHei += bannerHei + 114 + 59 + midView.myHei
        
        self.setupListView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupListView(){
        let viewWid = 72
        let viewHei = 36
        let viewSource = ClosureViewSource(viewUpdater: { (view: HomeTypeListCell, data: KechengChildTypeModel, index: Int) in
            view.model = data
        })
        let sizeSource = { (index: Int, data: KechengChildTypeModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: (data.name ?? "").length * 15 + 42, height: viewHei)
        }
        
        let provider = BasicProvider(
          dataSource: ds,
          viewSource: viewSource,
          sizeSource: sizeSource
        )

        
        provider.layout = RowLayout.init("provider", spacing: 12, justifyContent: JustifyContent.start, alignItems: .start)
        provider.tapHandler = { hand in
            let model = hand.data
            let vc = SearchCourseVC()
            vc.mainView.selMainId = model.parentId ?? "0"
            vc.mainView.selSubCid = model.id ?? "0"
            HQPush(vc: vc, style: .default)
        }
        
        listView.provider = provider
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-16)
            make.height.equalTo(viewHei)
            make.top.equalTo(whiteBg.snp.bottom).offset(12)
        }
    }
    
    func getNetInfo(){
        CourseNetworkProvider.request(.coureseType) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let typeModels = model!.data?.kj.modelArray(type: CourseTypeModel.self)
                                as? [CourseTypeModel]
                            if typeModels != nil{
                                let tempArr = NSMutableArray()
                                for model in typeModels!{
                                    if model.childrens != nil {
                                        for subModel in model.childrens!{
                                            if tempArr.count < 10 {
                                                tempArr.add(subModel)
                                            }else{
                                                break
                                            }
                                        }
                                    }
                                    
                                }
                                self.ds.data = tempArr as! [KechengChildTypeModel]
                                self.ds.reloadData()
                            }
                        }else{
                            
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
        
        if midView.model != nil {
            ///不更新首页推荐视频
            return
        }
        CourseNetworkProvider.request(.selectCourseForYouApp) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let stepModel = model?.data?.kj.model(CourseStepListModel.self) as? CourseStepListModel
                            self.midView.model = stepModel
                        }else{
                            
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }

    }
}

class HomeTypeListCell: UIView {
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .right)
    let rImg = UIImageView.initWithName(imgName: "home_icon_right")
    var model : KechengChildTypeModel? = nil{
        didSet{
            if model != nil {
                self.titleLab.text = model?.name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.addSubview(rImg)
        rImg.snp.makeConstraints { make in
            make.width.equalTo(7)
            make.height.equalTo(12)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(0)
            make.right.equalTo(-27)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
