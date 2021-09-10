//
//  SearchListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit

class SearchListView: UIView {
    var selIndex = 0
    var pageNum = 1
    
    var totalNum = 0
    var keyWords = ""
    
    let noDataView = SearchNoDataView()
    let topView = SearchHeadView()
    var collectView : UICollectionView?
    var userListView = SearchUserListView()
    var models : [PersonageListModel] = NSMutableArray() as! [PersonageListModel]
    
    //    "genre":"内容类型，0课程，1方案，3动态，4日记，5相册",
    var projectModels : [CourseDetalisModel]? = nil{
        didSet{
            if projectModels != nil && projectModels!.count > 0{
                ///课程模型转换
                for pm in projectModels! {
                    let dic = ["headerImage":pm.headerImage ?? "",
                               "userHeaderImage":pm.userHeaderImage ?? "",
                               "title":pm.title ?? "",
                               "nickName":pm.nickName ?? "",
                               "free":pm.free ?? false,
                               "newest":pm.newest ?? false,
                               "vipFree":pm.vipFree ?? false,
                               "giftTimes":pm.giftTimes ?? "",
                               "genre":self.selIndex == 0 ? 1 : 6,
                               "buyTimes":pm.buyTimes ?? "",
                               "totalStep":pm.totalStep ?? "0",
                               "totalDays":pm.totalDays,
                               "userType":pm.userType ?? "1",
                               "viewTimes":pm.viewTimes ?? "1",
                               "likeTimes":pm.likeTimes ?? "1",
                               "id":pm.id ?? ""
                    ] as [String : Any]
                    let pModel = dic.kj.model(PersonageListModel.self)
                    self.models.append(pModel)
                }
                self.collectView?.reloadData()
            }else{
                if pageNum == 1 {
                    self.noDataView.isHidden = false
                }
            }
        }
    }
    
    ///动态列表
    var commitModels : [SSCommitModel]? = nil{
        didSet{
            if commitModels != nil && commitModels!.count > 0{
                ///课程模型转换
                for pm in commitModels! {
                    let dic = ["headerImage":pm.headerImage ?? "",
                               "userHeaderImage":pm.userHeaderImage ?? "",
                               "title":pm.title ?? "",
                               "nickName":pm.nickName ?? "",
                               "isNew":pm.newest ?? false,
                               "giftTimes":pm.giftTimes ?? "",
                               "genre":pm.genre ?? 3,
                               "userType":pm.userType ?? "1",
                               "viewTimes":pm.viewTimes ?? "1",
                               "likeTimes":pm.likeTimes ?? "1",
                               "id":pm.id ?? ""
                    ] as [String : Any]
                    let pModel = dic.kj.model(PersonageListModel.self)
                    self.models.append(pModel)
                }
                self.collectView?.reloadData()
            }else{
                if pageNum == 1 {
                    self.noDataView.isHidden = false
                }
            }
        }
    }
    
    ///动态列表
    var dailyModels : [MLRJModel]? = nil{
        didSet{
            if dailyModels != nil && dailyModels!.count > 0{
                ///课程模型转换
                for pm in dailyModels! {
                    let dic = ["headerImage":pm.headerImage ?? "",
                               "userHeaderImage":pm.userHeaderImage ?? "",
                               "title":pm.title ?? "",
                               "nickName":pm.nickName ?? "",
                               "isNew":pm.newest ?? false,
                               "giftTimes":pm.giftTimes ?? "",
                               "genre":pm.genre ?? 3,
                               "userType":pm.userType ?? "1",
                               "viewTimes":pm.viewTimes ?? "1",
                               "likeTimes":pm.likeTimes ?? "1",
                               "id":pm.id ?? ""
                    ] as [String : Any]
                    let pModel = dic.kj.model(PersonageListModel.self)
                    self.models.append(pModel)
                }
                self.collectView?.reloadData()
            }else{
                if pageNum == 1 {
                    self.noDataView.isHidden = false
                }
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
            self.topView.tipView.text = "请输入关键词开始搜索"
            self.models.removeAll()
            self.collectView?.reloadData()
            
            self.collectView?.isHidden = self.selIndex == 5
            self.userListView.isHidden = self.selIndex != 5
            self.pageNum = 1
            self.getNetInfo()
        }
        topView.searchBlock = { [weak self] str in
            self?.keyWords = str
            self?.pageNum = 1
            self?.getNetInfo()
            
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
        
        
        self.addSubview(userListView)
        userListView.snp.makeConstraints({ (make) in
            make.edges.equalTo(collectView!)
        })
        userListView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNum += 1
            self.getNetInfo()
        })
        userListView.mj_footer?.endRefreshingWithNoMoreData()
        userListView.contentInsetAdjustmentBehavior = .never
        userListView.isHidden = true
        
        self.addSubview(noDataView)
        noDataView.snp.makeConstraints { make in
            make.top.equalTo(collectView!)
            make.left.right.equalToSuperview()
            make.height.equalTo(289)
        }
        noDataView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadWithIndex(index:Int){
        self.topView.selView.segmentedView.defaultSelectedIndex = index
        self.topView.selView.segmentedView.reloadData()
        self.selIndex = index
        self.topView.tipView.text = "请输入关键词开始搜索"
        self.models.removeAll()
        self.collectView?.reloadData()
        
        self.collectView?.isHidden = self.selIndex == 5
        self.userListView.isHidden = self.selIndex != 5
        self.pageNum = 1
        
    }
    
    func getNetInfo(){
        
        self.topView.tipView.isHidden = keyWords.length == 0
        
        self.topView.snp.updateConstraints { make in
            make.height.equalTo(topView.myHei+(keyWords.length == 0 ? 0 : topView.tipHei))
        }
        self.noDataView.isHidden = true
        if pageNum == 1 {
            self.models.removeAll()
            self.userListView.models?.removeAll()
            self.collectView?.reloadData()
        }
        if self.selIndex == 0 || self.selIndex == 1 {
            self.searchProject()
        }else if self.selIndex == 2{
            self.searchCommit()
        }else if self.selIndex == 3{
            self.serachDailyRecord()
        }else if self.selIndex == 4{
            self.serachAlbum()
        }else{
            self.searchUser()
        }
    }
    
    ///搜索课程、方案
    func searchProject(){
        NetworkProvider.request(.serachCourseScheme(pageNumber: self.pageNum, pageSize: 10, keyWord: self.keyWords, contentType: self.selIndex, firstCategoryId: "", secondCategoryId: "")) { result in
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
                            self.topView.setNumAndKeyWord(num: String(self.totalNum), keyWords: self.keyWords)
                            self.projectModels = searchModel?.content?.kj.modelArray(CourseDetalisModel.self)
                            if self.keyWords.length != 0 {
                                self.uploadSearchAction(hasResult: self.totalNum > 0, totalNum: self.totalNum)
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
    
    ///搜索动态
    func searchCommit(){
        NetworkProvider.request(.serachNote(pageNumber: self.pageNum, pageSize: 10, keyWord: self.keyWords)) { result in
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
                            self.topView.setNumAndKeyWord(num: String(self.totalNum), keyWords: self.keyWords)
                            self.commitModels = searchModel?.content?.kj.modelArray(SSCommitModel.self)
                            if self.keyWords.length != 0 {
                                self.uploadSearchAction(hasResult: self.totalNum > 0, totalNum: self.totalNum)
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
    
    ///搜索美丽日记
    func serachDailyRecord(){
        NetworkProvider.request(.serachDailyRecord(pageNumber: self.pageNum, pageSize: 10, keyWord: self.keyWords)) { result in
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
                            self.topView.setNumAndKeyWord(num: String(self.totalNum), keyWords: self.keyWords)
                            self.dailyModels = searchModel?.content?.kj.modelArray(MLRJModel.self)
                            if self.keyWords.length != 0 {
                                self.uploadSearchAction(hasResult: self.totalNum > 0, totalNum: self.totalNum)
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
    
    ///搜索美丽相册
    func serachAlbum(){
        NetworkProvider.request(.serachAlbum(pageNumber: self.pageNum, pageSize: 10, keyWord: self.keyWords)) { result in
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
                            self.topView.setNumAndKeyWord(num: String(self.totalNum), keyWords: self.keyWords)
                            self.dailyModels = searchModel?.content?.kj.modelArray(MLRJModel.self)
                            if self.keyWords.length != 0 {
                                self.uploadSearchAction(hasResult: self.totalNum > 0, totalNum: self.totalNum)
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
    
    ///搜索美丽日记、相册
    func searchUser(){
        NetworkProvider.request(.searchUser(pageNumber: self.pageNum, pageSize: 10, keyWord: self.keyWords)) { result in
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
                            self.userListView.totalNum = self.totalNum
                            self.topView.setNumAndKeyWord(num: String(self.totalNum), keyWords: self.keyWords)
                            let personModels = searchModel?.content?.kj.modelArray(SSFocusPopModel.self)
                            self.userListView.models = (self.userListView.models ?? []) + (personModels ?? [])
                            if self.keyWords.length != 0 {
                                self.uploadSearchAction(hasResult: self.totalNum > 0, totalNum: self.totalNum)
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
    
    ///上报搜索事件
    func uploadSearchAction(hasResult:Bool,totalNum:Int){
        var search_type = ""
        if self.selIndex == 0 || self.selIndex == 1 {
            search_type = self.selIndex == 0 ? "课程" : "方案"
        }else if self.selIndex == 2{
            search_type = "动态"
        }else if self.selIndex == 3 || self.selIndex == 4{
            search_type = self.selIndex == 3 ? "美丽日记" : "美丽相册"
        }else{
            search_type = "用户"
        }
        ///上报事件
        HQPushActionWith(name: "search_result", dic: ["keyword":self.keyWords,
                                                      "search_type":search_type,
                                                      "has_result":hasResult,
                                                      "is_history_word_used":false,
                                                      "is_recommend_word_used":false,
                                                      "result_quantity":totalNum])
    }
    
}
extension SearchListView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
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
        }else{
            self.collectView?.mj_footer?.resetNoMoreData()
            self.collectView?.mj_footer?.endRefreshing()
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
            ///上报事件
            HQPushActionWith(name: "click_course_detail", dic:  ["current_page":"搜索列表页",
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
