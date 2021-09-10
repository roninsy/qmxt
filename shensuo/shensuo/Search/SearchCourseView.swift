//
//  SearchCourseView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/8.
//

import UIKit

class SearchCourseView: UIView {
    ///页面类型，0课程 1方案
    var viewType = 0{
        didSet{
            if viewType == 1 {
                self.topView.titleLab.text = "全部方案"
                self.topView.searchTF.placeholder = "搜索方案标题"
                self.pageNum = 1
                self.models.removeAll()
                self.getNetInfo()
            }
        }
    }
    ///选中的主类id
    var selMainId = ""
    
    ///选中的子类id
    var selSubCid = ""
    
    var mainCid = ""
    
    var subCid = ""
    var selIndex = 0
    var pageNum = 1
    
    var totalNum = 0
    var keyWords = ""

    let noDataView = SearchNoDataView()
    let topView = SearchCourseHeadView()
    var collectView : UICollectionView?
    var models : [PersonageListModel] = NSMutableArray() as! [PersonageListModel]
    
    var typeModels:[CourseTypeModel]? = nil{
        didSet{
            if typeModels != nil {
                var strArr : [String] = NSMutableArray() as! [String]
                strArr.append(self.viewType == 1 ? "全部方案" : "全部课程")
                var selI = 0
                var flag = true
                for type in typeModels!{
                    strArr.append(type.name ?? "默认")
                    if self.selMainId.length > 0 {
                        if flag {
                            selI += 1
                        }
                        if (type.id ?? "-1") == self.selMainId {
                            flag = false
                        }
                    }
                }
                self.selIndex = selI
                self.topView.snp.updateConstraints { make in
                    make.height.equalTo(self.topView.myHei + (self.selIndex != 0 ? self.topView.subSelHei : 0))
                }
                if self.selIndex != 0 {
                    self.mainCid = selMainId
                    let subModels = self.typeModels![self.selIndex - 1].childrens
                    var model = KechengChildTypeModel()
                    model.name = "全部"
                    model.id = ""
                    let arr = NSMutableArray.init(array: subModels ?? [])
                    arr.insert(model, at: 0)
                    
                    var subSelI = 0
                    var subFlag = true
                    if subModels != nil {
                        for type in subModels!{
                            strArr.append(type.name ?? "默认")
                            if self.selSubCid.length > 0 {
                                if subFlag {
                                    subSelI += 1
                                }
                                if (type.id ?? "-1") == self.selSubCid {
                                    subFlag = false
                                }
                            }
                        }
                        
                        self.topView.ds.data = arr as! [KechengChildTypeModel]
                        self.topView.subSelIndex = subSelI
                        self.topView.ds.reloadData()
                    }
                }
                self.topView.selView.dataSource.titles = strArr
                self.topView.selView.segmentedView.defaultSelectedIndex = selI
                self.topView.selView.segmentedView.reloadData()
                
            }
            self.getNetInfo()
        }
    }
    
    //    "genre":"内容类型，0课程，1方案，3动态，4日记，5相册",
    var projectModels : [CourseDetalisModel]? = nil{
        didSet{
            if projectModels != nil && projectModels!.count > 0{
                ///课程模型转换
                for pm in projectModels! {
                    var dic = ["headerImage":pm.headerImage ?? "",
                               "userHeaderImage":pm.userHeaderImage ?? "",
                               "title":pm.title ?? "",
                               "nickName":pm.nickName ?? "",
                               "vipFree":pm.vipFree ?? false,
                               "isNew":pm.newest ?? false,
                               "free":pm.free ?? false,
                               "giftTimes":pm.giftTimes ?? "",
                               "genre":(self.viewType == 1 ? 6 : 1),
                               "buyTimes":pm.buyTimes ?? "",
                               "userType":pm.userType ?? "1",
                               "viewTimes":pm.viewTimes ?? "1",
                               "likeTimes":pm.likeTimes ?? "1",
                               "id":pm.id ?? ""
                    ] as [String : Any]
                    dic["newest"] = pm.newest ?? false
                    dic["totalStep"] = pm.totalStep ?? ""
                    dic["totalDays"] = pm.totalDays ?? ""
                    let pModel = dic.kj.model(PersonageListModel.self)
                    self.models.append(pModel)
                }
                self.collectView?.reloadData()
            }else{
                if pageNum == 1 {
                    if keyWords != "" {
                        self.noDataView.mainImg.image = UIImage.init(named: "search_nodata")
                        self.noDataView.tipLab.text = "抱歉，没有找到相关信息\n请换个关键字试试~"
                    }else{
                        self.noDataView.mainImg.image = UIImage.init(named: "my_nosc")
                        self.noDataView.tipLab.text = viewType == 0 ? "暂无课程" : "暂无方案"
                    }
                    
                    self.noDataView.isHidden = false
                }
                self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(topView.myHei)
        }
        
        topView.selView.selIndex = { index in
            self.selIndex = index
            self.models.removeAll()
            self.collectView?.reloadData()
            self.pageNum = 1
            
            self.topView.snp.updateConstraints { make in
                make.height.equalTo(self.topView.myHei + (self.selIndex != 0 ? self.topView.subSelHei : 0))
            }
            if self.selIndex != 0 {
                self.mainCid = self.typeModels![self.selIndex - 1].id ?? ""
                let subModels = self.typeModels![self.selIndex - 1].childrens
                var model = KechengChildTypeModel()
                model.name = "全部"
                model.id = ""
                self.subCid = ""
                let arr = NSMutableArray.init(array: subModels ?? [])
                arr.insert(model, at: 0)
                self.topView.ds.data = arr as! [KechengChildTypeModel]
                self.topView.subSelIndex = 0
                self.topView.ds.reloadData()
            }else{
                self.mainCid = ""
                self.subCid = ""
            }
            self.getNetInfo()
        }
        topView.searchBlock = { str in
            self.keyWords = str
            self.pageNum = 1
            self.getNetInfo()
        }
        topView.selSubBlock = { num in
            self.pageNum = 1
            self.subCid = num
            self.getNetInfo()
        }
        
        let layout = UICollectionViewFlowLayout.init()
        
        collectView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectView!.register(CourseInfoCell.self, forCellWithReuseIdentifier: "KeChengInfoCell")
        collectView?.register(CourseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "KeChengHeaderView")
        collectView?.showsVerticalScrollIndicator = false
        collectView?.dataSource = self
        collectView?.delegate = self
        
        self.addSubview(collectView!)
        collectView?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.bottom.equalTo(0)
        })
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        collectView!.backgroundColor = .init(hex: "#F7F8F9")
        collectView!.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNum += 1
            self.getNetInfo()
        })
        collectView?.mj_footer?.endRefreshingWithNoMoreData()
        collectView?.contentInsetAdjustmentBehavior = .never
        
        
        self.addSubview(noDataView)
        noDataView.snp.makeConstraints { make in
            make.top.equalTo(collectView!)
            make.left.right.equalToSuperview()
            make.height.equalTo(289)
        }
        noDataView.isHidden = true
        
        getTypeInfo()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
//        self.topView.tipView.isHidden = keyWords.length == 0
//        
//        self.topView.snp.updateConstraints { make in
//            make.height.equalTo(topView.myHei+(keyWords.length == 0 ? 0 : topView.tipHei))
//        }
        
        self.noDataView.isHidden = true
        if pageNum == 1 {
            self.models.removeAll()
            self.collectView?.reloadData()
        }
        self.searchProject()
    }
    
    ///搜索课程、方案
    func searchProject(){
        NetworkProvider.request(.serachCourseScheme(pageNumber: self.pageNum, pageSize: 10, keyWord: self.keyWords, contentType: self.viewType, firstCategoryId: self.mainCid, secondCategoryId: self.subCid)) { result in
            self.collectView?.mj_footer?.endRefreshing()
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let searchModel = model!.data?.kj.model(SearchListModel.self)
                            self.totalNum = searchModel?.totalElements ?? 0
                            self.projectModels = searchModel?.content?.kj.modelArray(CourseDetalisModel.self)
                            if self.keyWords.count != 0 {
                                ///上报事件
                                HQPushActionWith(name: "search_result", dic: ["keyword":self.keyWords,
                                                                              "search_type":self.viewType == 0 ? "课程" : "方案",
                                                                              "has_result":self.totalNum != 0,
                                                                              "is_history_word_used":false,
                                                                              "is_recommend_word_used":false,
                                                                              "result_quantity":self.totalNum])
                            }
                        }
                    }
                    
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(false)
    }
    
    
    func getTypeInfo(){
        CourseNetworkProvider.request(.coureseType) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            self.typeModels = model!.data?.kj.modelArray(type: CourseTypeModel.self)
                                as? [CourseTypeModel]
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
extension SearchCourseView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeChengInfoCell", for: indexPath) as! CourseInfoCell
        
        cell.mainView.model = self.models[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if totalNum <= models.count {
            self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
        }
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        var type = model.genre
        if type == 1 {
            type = 2
        }else if type == 6 {
            type = 3
        }else if type == 3 {
            type = 4
        }else if type == 4 {
            type = 5
        }else if type == 5 {
            type = 6
        }
        if type == 2 || type == 3 {
            let pageName = viewType == 0 ? "全部课程" : "全部方案"
            ///上报事件
            HQPushActionWith(name: "click_course_detail", dic:  ["current_page":pageName,
                                                                 "course_frstcate":"",
                                                                     "course_secondcate":"",
                                                                     "course_id":model.id ?? "",
                                                                     "course_title":model.title ?? ""])
        }
        GotoTypeVC(type: type, cid: model.id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = models[indexPath.row]
        return CGSize(width: model.wid, height: model.modelHei)
    }
    
}
