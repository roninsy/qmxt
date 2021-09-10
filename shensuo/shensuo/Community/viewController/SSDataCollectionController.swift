//
//  SSDataCollectionController.swift
//  shensuo
//
//  Created by swin on 2021/4/10.
//

import Foundation
import SnapKit
import JXPagingView
import Toast_Swift
import MJRefresh
import BSText

enum ComDataType {
    case dongtai
    case gift
    case kecheng
    case fangan
    case mlrj
    case mlxc
    case data
}

//数据列表 美丽相册 美丽日记 动态 方案 数据 收藏......
class SSDataCollectionController: HQBaseViewController {
    
    let headView = UIView()
    let tipView = BSLabel()
    var nodataView : SSNoDataView? = nil
    
    var drafCount = 0
    var dataCollectionView: UICollectionView!
    var type: ComDataType!
    var currentIndex = 0
    
    var total = 0{
        didSet{
            if searchKey != "" {
                self.headView.snp.updateConstraints { make in
                    make.height.equalTo(30)
                }
                setNumAndKeyWord(num: "\(total)", keyWords: searchKey)
            }else{
                self.headView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
            if self.nodataView != nil {
                self.nodataView?.snp.remakeConstraints({ make in
                    make.top.equalTo(headView.snp.bottom).offset(10)
                    make.left.equalTo(0)
                    make.width.equalTo(screenWid)
                    make.height.equalTo(289)
                })
            }
        }
    }
    
    var rankModels : GiftRankModel? = nil{
        didSet{
            if rankModels != nil{
                //                giftNumLab.text = String.init(format: "%d", rankModels?.totalGifts ?? 0)
                //                personNumLab.text = String.init(format: "%d", rankModels?.totalPeople ?? 0)
                //                let num = (rankModels?.gifts?.content?.count ?? 0)
                //                for i in 0...2 {
                //                    if num > i{
                //                        let model = rankModels!.gifts!.content![i]
                //                        userArr[i].bgImg.isHidden = false
                //                        userArr[i].headImg.kf.setImage(with: URL.init(string: model.headImage!),placeholder: UIImage.init(named: "gift_user"))
                //                        let str = model.points! > 10000 ? String.init(format: "%.1f万", Double(model.points!) / 10000.0) : "\(model.points!)"
                //                        userArr[i].botLab.text = str
                //                    }
            }
        }
    }
    var userInfoModel: SSUserInfoModel?
    var isSelf = false
    var isCollection : Bool = false //是否收藏列表
    var requestType : CommunityApiManage!
    var giftRequest : GiftApiManage!
    var noteTips : String = ""
    var page = 1
    var pageSize = 10
    var mainId: String? = ""
    let itemMargin: CGFloat = 12
    let itemWidth = floor((UIScreen.main.bounds.size.width - 36)/2)
    var searchKey = ""
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    var zeroCell : MyMainViewZeroCell!
    
    var models : [MLRJModel]? = nil{
        didSet{
            if models != nil {
                self.dataCollectionView?.reloadData()
            }
        }
    }
    
    var dtModels:[SSDongTaiModel]? = nil {
        didSet{
            if dtModels != nil {

                self.dataCollectionView.reloadData()
                
            }
        }
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        
    }
    
    func initWithFrame(frame: CGRect) -> Void {
        self.view.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipView.textColor = .init(hex: "#B4B4B4")
        tipView.font = .systemFont(ofSize: 14)
        tipView.text = "请输入关键词开始搜索"
        tipView.frame = .init(x: 16, y: 0, width: screenWid, height: 30)
        self.headView.addSubview(tipView)
        self.headView.backgroundColor = .white
        
        self.view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalTo(0)
            make.width.equalTo(screenWid)
            make.top.equalTo(0)
        }

        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#f6f6f6")
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        
        let layout = WaterFallLayout(itemCount: 300,isSelf: isSelf)
        dataCollectionView = UICollectionView(frame:  CGRect(x: 12, y: 0, width: screenWid - 12, height: screenHei-NavStatusHei-50), collectionViewLayout: layout)
        dataCollectionView.backgroundColor = UIColor.init(hex: "#F7F8F9")
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        dataCollectionView.showsVerticalScrollIndicator = true
        dataCollectionView.register(SSComDataCellView.self, forCellWithReuseIdentifier: "SSComDataCellView")
        dataCollectionView.register(MyMainViewZeroCell.self, forCellWithReuseIdentifier: "MyMainViewZeroCell")
        
        
        dataCollectionView!.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadListData(keyword: "")
        })
        
        self.view.addSubview(dataCollectionView)
        dataCollectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(12)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchReload(not:)), name: CollectionSearchCompletionNotification, object: nil)
    }
    
    
    @objc func searchReload(not: Notification)  {
        
        let index = not.userInfo!["currentIndex"] as! Int
        self.searchKey = not.userInfo!["searchKey"] as! String
        
        if index == currentIndex {
            
            if index == 2 {
                
                requestType = .collectNoteList(titleKeyword:searchKey, userId: userInfoModel?.userId ?? "", pageNumber: self.page, size: pageSize)
                loadDongTaiData()
                
            }else if(index == 3){
                requestType = .collectAlbum(number: self.page, pageSize: self.pageSize,title: searchKey)
                loadMlrjData()
                
            }else if(index == 4){
                
                requestType = .collectDailyRecord(number: self.page, pageSize: self.pageSize,title: searchKey)
                loadMlxcData()
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.page = 1
        loadListData(keyword: "")
    }
    
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count < page*pageSize {
            self.dataCollectionView.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.dataCollectionView.mj_header?.endRefreshing()
        }
    }
    
    
    func loadListData(keyword: String) {
        
        switch type {
        case .dongtai:
            if isCollection {
                self.noteTips = "暂无动态"
                requestType = .collectNoteList(titleKeyword:keyword, userId: userInfoModel?.userId ?? "", pageNumber: self.page, size: pageSize)
            } else {
                self.noteTips = "暂无数据"
                requestType = .noteList(pageNumber: self.page, size: pageSize, userId: userInfoModel?.userId ?? "")
            }
            
            self.loadDongTaiData()
            break
        case .mlrj:
            if isCollection {
                self.noteTips = "暂无日记"
                requestType = .collectDailyRecord(number: self.page, pageSize: self.pageSize,title: keyword)
            } else {
                self.noteTips = "暂无数据"
                requestType = .selectDailyListForHer(userId: userInfoModel?.userId ?? "", pageNum: self.page, pageSize: self.pageSize)
            }
            self.loadMlrjData()
            break
            
        case .mlxc:
            if isCollection {
                self.noteTips = "暂无相册"
                requestType = .collectAlbum(number: self.page, pageSize: self.pageSize,title: keyword)
            } else {
                self.noteTips = "暂无数据"
                requestType = .selectAlbumListAppForHer(userId: userInfoModel?.userId ?? "", pageNum: self.page, pageSize: self.pageSize)
            }
            self.loadMlxcData()
            break
        case .gift:
            if isCollection {
                self.noteTips = "暂无数据"
            }else{
                giftRequest = .giftRanking(source: UserInfo.getSharedInstance().userId ?? "", type: "\(8)", number: 1, pageSize: 10)
                ///获取礼物排行榜
                GiftNetworkProvider.request(giftRequest) { result in
                    switch result{
                    case let .success(moyaResponse):
                        do {
                            let code = moyaResponse.statusCode
                            if code == 200{
                                let json = try moyaResponse.mapString()
                                let model = json.kj.model(ResultDicModel.self)
                                if model?.code == 0 {
                                    if model?.data != nil{
                                        self.rankModels = model!.data!.kj.model(type: GiftRankModel.self) as? GiftRankModel
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
                
                getNetInfo()
            }
            break
        default:
            break
        }
        
    }
    
    func loadDongTaiData()  {
        if self.page == 1 {
            self.dtModels?.removeAll()
            self.dataCollectionView.reloadData()
        }
        CommunityNetworkProvider.request(requestType) { result in
            self.dataCollectionView.mj_footer?.endRefreshing()
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        
                        if model?.code == 0 {
                            let dic = model?.data
                            let total = dic?["totalElements"] as? String
                            self.total = total?.toInt ?? 0
                            
                            let arr = dic?["content"] as? NSArray
                            if arr == nil {
                                return
                            }
                            if arr?.count == 0 {
                                
                                self.dataCollectionView.mj_footer?.isHidden = true
                                if self.nodataView == nil {
                                    self.nodataView = HQShowNoDataView(parentView: self.view, imageName: self.searchKey != "" ? "noResult" : "my_nosc", tips: self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips)
                                }else{
                                    
                                    self.nodataView?.tipsImageView.image = UIImage.init(named: self.searchKey != "" ? "noResult" : "my_nosc")
                                    self.nodataView?.tipsLabel.text = self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips
                                    
                                }

                                
                            }
                            if self.page == 1 {
                                self.dtModels = arr?.kj.modelArray(type: SSDongTaiModel.self)
                                    as? [SSDongTaiModel]
                                
                            }else{
                                let models = arr?.kj.modelArray(type: SSDongTaiModel.self)
                                    as? [SSDongTaiModel]
                                self.dtModels = self.dtModels! + (models ?? [])
                            }
                            self.isHiddenFooter(model: self.dtModels as AnyObject)
                            
                        }else{
                            self.dtModels?.removeAll()
                            self.dataCollectionView.reloadData()
                            self.dataCollectionView.mj_footer?.isHidden = true
                            if self.nodataView == nil {
                                self.nodataView = HQShowNoDataView(parentView: self.view, imageName: self.searchKey != "" ? "noResult" : "my_nosc", tips: self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips)
                            }else{
                                
                                self.nodataView?.tipsImageView.image = UIImage.init(named: self.searchKey != "" ? "noResult" : "my_nosc")
                                self.nodataView?.tipsLabel.text = self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips
                                
                            }
                             
                            //                                    self.dataCollectionView?.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func loadMlrjData() {
        
        CommunityNetworkProvider.request(requestType) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            let total = dic?["totalElements"] as! String
                            self.total = total.toInt ?? 0
                            if (total.toInt ?? 0) > 0 {
                                let arr = dic?["content"] as! NSArray
                                if self.page == 1 {
                                    self.models = arr.kj.modelArray(type: MLRJModel.self)
                                        as? [MLRJModel]
                                    
                                }else{
                                    let models = arr.kj.modelArray(type: MLRJModel.self)
                                        as? [MLRJModel]
                                    self.models = self.models! + (models ?? [])
                                }
                                self.isHiddenFooter(model: self.models as AnyObject)
                                
                            }else{
                                self.models?.removeAll()
                                self.dataCollectionView.reloadData()
                                self.dataCollectionView.mj_footer?.isHidden = true
                                if self.nodataView == nil {
                                    self.nodataView = HQShowNoDataView(parentView: self.view, imageName: self.searchKey != "" ? "noResult" : "my_nosc", tips: self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips)
                                }else{
                                    
                                    self.nodataView?.tipsImageView.image = UIImage.init(named: self.searchKey != "" ? "noResult" : "my_nosc")
                                    self.nodataView?.tipsLabel.text = self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips
                                    
                                }
                                //                                        self.dataCollectionView?.mj_footer?.endRefreshingWithNoMoreData()
                            }
                        }else{
                            
                        }
                        
                    }
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func loadMlxcData()  {
        
        CommunityNetworkProvider.request(requestType) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            let total = dic?["totalElements"] as! String
                            self.total = total.toInt ?? 0
                            if (total.toInt ?? 0) > 0 {
                                let arr = dic?["content"] as! NSArray
                                if self.page == 1 {
                                    self.models = arr.kj.modelArray(type: MLRJModel.self)
                                        as? [MLRJModel]
                                    
                                }else{
                                    let models = arr.kj.modelArray(type: MLRJModel.self)
                                        as? [MLRJModel]
                                    self.models = self.models! + (models ?? [])
                                }
                                self.isHiddenFooter(model: self.models as AnyObject)
                                
                            }else{
                                self.models?.removeAll()
                                self.dataCollectionView.reloadData()
                                self.dataCollectionView.mj_footer?.isHidden = true
                                if self.nodataView == nil {
                                    self.nodataView = HQShowNoDataView(parentView: self.view, imageName: self.searchKey != "" ? "noResult" : "my_nosc", tips: self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips)
                                }else{
                                    
                                    self.nodataView?.tipsImageView.image = UIImage.init(named: self.searchKey != "" ? "noResult" : "my_nosc")
                                    self.nodataView?.tipsLabel.text = self.searchKey != "" ? "抱歉，没有找到相关信息\n请换个关键字试试~" : self.noteTips
                                    
                                }
                            }
                        }else{
                            
                        }
                        
                    }
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    ///获取草稿箱消息数量
    func getDraftCount(){
        ///获取天数
        CommunityNetworkProvider.request(.draftCount) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            self.drafCount = model?.data ?? 0
                            self.dataCollectionView.reloadData()
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func getNetInfo() {
        GiftNetworkProvider.request(.giftStand(userId:UserInfo.getSharedInstance().userId ?? "")) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                //                                self.giftArr = model!.data!.kj.modelArray(GiftUserModel.self)
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
    }
    
    ///新增美丽相册
    func createDailyRecord(){
        ///获取天数
        CommunityNetworkProvider.request(.createDailyRecord) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                HQGetTopVC()?.view.makeToast(model?.message ?? "")
                            }
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    ///新增美丽相册
    func createAlbum(){
        ///获取天数
        CommunityNetworkProvider.request(.createAlbum) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                HQGetTopVC()?.view.makeToast(model?.message ?? "")
                            }
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
}

extension SSDataCollectionController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .mlrj, .mlxc:
            guard (self.models == nil) else {
                let count = self.models!.count
                return count == 0 ? 0 : (count + (isSelf ? 1 : 0))
            }
            break
        case .dongtai:
            guard self.dtModels == nil else {
                let count = self.dtModels!.count
                return count == 0 ? 0 : (count + (isSelf ? 1 : 0))
            }
            break
        case .gift:
            return 3
        default:
            return 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "SSComDataCellView", for: indexPath) as! SSComDataCellView
        cellView.isSelf = isSelf
        cellView.playImageView.isHidden = false
        if cellView.reloadBlock == nil {
            cellView.reloadBlock = {[weak self] in
                self?.page = 1
                self?.loadDongTaiData()
            }
        }
        
        switch type {
        case .mlrj,.mlxc:
            if indexPath.row == 0 && isSelf{
                zeroCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyMainViewZeroCell", for: indexPath) as? MyMainViewZeroCell
                if zeroCell.needSetup {
                    zeroCell.setupInfo(bgImgStr: "my_zero_bg1", topImgStr: type == .mlrj ? "my_zero_top2" : "my_zero_top3", titleStr: type == .mlrj ? "新启美丽日记" : "新启美丽相册", subTitle: "")
                }
                return zeroCell
            }
            guard (self.models == nil) else {
                cellView.model = self.models![indexPath.row - (isSelf ? 1 : 0)]
                cellView.playImageView.isHidden = true
                return cellView
            }
            break
        case .dongtai:
            if indexPath.row == 0 && isSelf {
                zeroCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyMainViewZeroCell", for: indexPath) as? MyMainViewZeroCell
                if zeroCell.needSetup {
                    zeroCell.setupInfo(bgImgStr: "my_zero_bg1", topImgStr: "my_zero_top1", titleStr: "草稿箱", subTitle: "\(self.drafCount)条待发布")
                }
                return zeroCell
            }
            guard (self.dtModels == nil) else {
                cellView.dtModel = self.dtModels![indexPath.row - (isSelf ? 1 : 0)]
                return cellView
            }
            break
        default:
            return cellView
        }
        
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch type {
        case .mlxc:
            if indexPath.row == 0 && isSelf {
                self.createAlbum()
                return
            }
            let detailVC = SSBeautiPhotosDetailViewController.init()
            detailVC.xcModel = self.models![indexPath.row - (isSelf ? 1 : 0)]
            self.navigationController?.pushViewController(detailVC, animated: true)
            break
        case .mlrj:
            if indexPath.row == 0 && isSelf{
                self.createDailyRecord()
                return
            }
            let detailVC = SSBeautiDailyDetailViewController.init()
            
            detailVC.xcModel = self.models![indexPath.row - (isSelf ? 1 : 0)]
            self.navigationController?.pushViewController(detailVC, animated: true)
            break
        case .dongtai:
            if indexPath.row == 0 && isSelf{
                HQPush(vc: SSMyDraftsViewController(), style: .default)
                return
            }
            let detailVC = SSCommunityDetailViewController()
            detailVC.isInFromPerson = true
            var commitModel = SSCommitModel()
            let model = self.dtModels![indexPath.row - (isSelf ? 1 : 0)]
            
            //                commitModel = model as SSCommitModel
            commitModel.id = model.id
            commitModel.userId = model.authorId
            commitModel.noteType = model.type
            commitModel.videoUrl = model.videoUrl
            commitModel.content = model.content
            commitModel.address = model.address
            commitModel.postTimes = model.postTimes
            commitModel.imageList = model.imageUrls
            commitModel.nickName = model.userName
            commitModel.userHeaderImage = model.headerImageUrl
            commitModel.title = model.title
            
            detailVC.dataModel = commitModel
            
            //                commitModel.content = model.
            //                detailVC.xcModel = self.models![indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            break
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if self.type == .dongtai{
            if indexPath.row == 0 && isSelf{
                return CGSize(width: itemWidth, height: 135)
            }
//        }
        return CGSize(width: itemWidth, height: itemWidth*1.6)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback!(scrollView)
    }
    
    func setNumAndKeyWord(num:String,keyWords:String){
        let protocolText = NSMutableAttributedString(string: "共搜到\(num)个与“\(keyWords)”相关信息")
        protocolText.bs_color = .init(hex: "#B4B4B4")
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 3, length: num.length))
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 6+num.length, length: keyWords.length))
        tipView.attributedText = protocolText
        tipView.isHidden = keyWords.length == 0
    }
}

extension SSDataCollectionController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return view
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    public func listScrollView() -> UIScrollView {
        return self.dataCollectionView
    }
}
