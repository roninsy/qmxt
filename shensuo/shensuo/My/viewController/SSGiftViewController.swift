//
//  SSGiftViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/28.
//

import UIKit
import JXSegmentedView

class SSGiftViewController: SSBaseViewController {
    
    let searchView = SSSearchView.init()
    //    let mainTableView = UITableView.init()
    var page = 1
    let pageSize = 10
    
    var searchKey:String! = ""
    
    var bUp:Bool = true
    //1: 我的课程 2: 我的方案 3: 我的礼物间 4:我的收藏
    var inType: Int! = 0 {
        
        didSet{
            
            if inType == 1 {
                
                type = 0
            }
            else if(inType == 2){
                
                type = 1
            }
        }
    }
    //1: "" 全部 "0" 收礼 未完成 "1" 送礼 已完成
    var finshType: String! = "0"
    //付费类型 0全部 1免费 2付费 3vip免费
    var paymentType: Int = 0
    //类型 0课程 1方案
    var type: Int = 0
    
    var segTitles: [String]!
    var segmentedView: JXSegmentedView!
    var segmentedDataSourse: JXSegmentedTitleDataSource!
    var contentScrollView: UIScrollView!
    var listVcArray = [giftDataView]()
    let checkBtn = UIButton.init()
    var searchTipsV: UIView?
    var searchTipsL: UILabel!
    var isSearch: Bool = false
    var curView:giftDataView? = nil
    var selectIndex = 0
    var tips = ""
    
    var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ishideBar = true
        navView.backBtnWithTitle(title: self.title ?? "")
        
        self.view.backgroundColor = .white
        
        self.buildUI()
        self.loadData()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(segTitles.count), height: contentScrollView.bounds.size.height)
        for (index, vc) in listVcArray.enumerated() {
            vc.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
            contentScrollView.addSubview(vc)
        }
        
    }
    
    fileprivate func extractedFunc() {
        curView?.listTableView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.curView?.number += 1
            if self.inType == 1 || self.inType == 2{
                self.curView?.loadMyCourseData(order: self.bUp == true ? 1 : 2, finshType: self.finshType, type: self.type, paymentType: self.paymentType, title: (self.searchKey)!)
            }else if self.inType == 3{
                self.curView?.loadGiftData(bup: true, giftType: self.finshType, searchKey: (self.searchKey)!)
            }
            
        })
    }
    
    func loadData() {
        
        for vc in listVcArray {
            vc.removeFromSuperview()
        }
        listVcArray.removeAll()
        
        for _ in 0 ..< segmentedDataSourse.titles.count {
            let dataVc = giftDataView()
            dataVc.inType  = inType
            listVcArray.append(dataVc)
        }
        listVcArray.first?.inType = inType
        
        self.curView = listVcArray.first
        self.curView?.reloadTopSearchDataBlcok = {[weak self] in
            
            self?.setSerchTitle()
        }
        if inType == 1 || inType == 2{
            
            self.curView?.loadMyCourseData(order: bUp == true ? 1 : 2, finshType: self.finshType, type: self.type, paymentType: self.paymentType, title: (self.searchKey)!)
        }else{
            if isFirst {
                self.finshType = ""
                self.isFirst = false
            }
            self.curView?.loadGiftData(bup: true, giftType: self.finshType, searchKey: (self.searchKey)!)
        }
        extractedFunc()
        
    }
    
}


extension SSGiftViewController : SSSearchViewDelegate {
    func searchDataWithKeyWord(key: String) {
        isSearch = true
        self.searchKey = key
        self.searchTipsV?.isHidden = false
        self.searchTipsV?.snp.updateConstraints({ make in
            
            make.height.equalTo(50)
        })
        curView?.number = 1
        if inType == 1 || inType == 2 {
            
            curView?.courseModels?.removeAll()
            self.curView?.loadMyCourseData(order: bUp == true ? 1 : 2, finshType: self.finshType, type: self.type, paymentType: self.paymentType, title: key)
        }else{
            
            curView?.giftModels?.removeAll()
            self.curView?.loadGiftData(bup: true, giftType: self.finshType, searchKey: key)
            
        }
        
    }
}

extension SSGiftViewController : JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        segmentLoadData(index: index)
        
    }
    
    func segmentLoadData(index: Int)  {
        
        if index == 0 {
            
            if inType == 1 || inType == 2 {
                
                self.finshType = "0"
                
            }else{
                
                self.finshType = ""
            }
        }else if(index == 1){
            
            if inType == 1 || inType == 2 {
                
                self.finshType = "1"
                
            }else{
                
                self.finshType = "0"
            }
        }else{
            
            if inType == 1 || inType == 2 {
                
                self.finshType = "2"
                
            }else{
                
                self.finshType = "1"
            }
        }
        self.curView = listVcArray[index]
        self.curView?.reloadTopSearchDataBlcok = {[weak self] in
            
            self?.setSerchTitle()
        }
        if inType == 1 || inType == 2{
            
            self.curView?.loadMyCourseData(order: bUp == true ? 1 : 2, finshType: self.finshType, type: self.type, paymentType: self.paymentType, title:searchKey)
        }else{
            
            self.curView?.loadGiftData(bup: true, giftType: self.finshType, searchKey:searchKey)
            
        }
    }
    
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        segmentLoadData(index: index)
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
}

class giftDataView: UIView, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    var searchKey = ""
    var total = 0
    var noDataObject: SSCommonNoDataObject?
    var number = 1
    var pageSize = 10
    //1: 我的课程 2: 我的方案 3: 我的礼物间 4:我的收藏
    var inType: Int! = 0
    var listTableView:UITableView?
    var reloadTopSearchDataBlcok: voidBlock?
    
    var giftModels:[SSGiftMessageModel]? = nil {
        didSet {
            if giftModels != nil {
                self.listTableView?.reloadData()
            }
            
        }
    }
    
    var courseModels: [CourseDetalisModel]? = nil{
        
        didSet{
            
            if courseModels != nil {
                
                self.listTableView?.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        HQShowNoDataView(parentView: self, imageName: "my_nosc", tips: self.inType == 1 ? "暂无课程" : "暂无方案")
        
        self.listTableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.listTableView?.delegate = self
        self.listTableView?.dataSource = self
        self.listTableView?.separatorStyle = .none
        self.listTableView?.backgroundColor = bgColor
        
        self.listTableView?.register(SSMyCourseCell.self, forCellReuseIdentifier: String(describing: SSMyCourseCell.self))
        
        self.listTableView?.register(SSMyGiftMessageCell.self, forCellReuseIdentifier: "SSMyGiftMessageCell")
        
        self.addSubview(self.listTableView!)
        self.listTableView?.snp.makeConstraints({ make in
            
            make.edges.equalToSuperview()
        })
        //        self.loadGiftData()
    }
    
    func loadMyCourseData(order:Int, finshType:String, type:Int, paymentType:Int, title:String)  {
        self.searchKey = title
        CourseNetworkProvider.request(.selectMyCourseListApp(pageNumber: self.number, pageSize: self.pageSize, finshType: finshType.toInt!, order:order , paymentType: paymentType, title: title, type: type)) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            
                            if self.noDataObject != nil {
                                
                                self.noDataObject?.noDataView.isHidden = true
                            }
                            if model!.data != nil {
                                let dic = model!.data!
                                let totalElements = dic["totalElements"] as! String
                                self.total = totalElements.toInt ?? 0
                                

                                    let arr = dic["content"] as! NSArray
                                    if self.number == 1 {
                                        self.courseModels = arr.kj.modelArray(type: CourseDetalisModel.self)
                                            as? [CourseDetalisModel]
                                        
                                    }else{
                                        let models = arr.kj.modelArray(type: CourseDetalisModel.self)
                                            as? [CourseDetalisModel]
                                        //
                                        self.courseModels = (self.courseModels ?? []) + (models ?? [])
                                    }
                                    self.isHiddenFooter(model: self.courseModels as AnyObject)
                                
                                
                            }else{
                                
                                if self.noDataObject == nil {
                                    
                                    self.noDataObject = SSShowNoDataView(parentView: self.listTableView!, imageName: "my_nosc", tips: self.inType == 1 ? "暂无课程" : "暂无方案")
                                }else{
                                    
                                    self.noDataObject?.noDataView.isHidden = false
                                }
                                self.courseModels?.removeAll()
                                self.listTableView?.reloadData()
                                self.listTableView?.mj_footer?.isHidden = true
                                
                            }
                        }else{
                            //
                        }
                    }
                    
                    self.reloadTopSearchDataBlcok?()
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count >= total {
            self.listTableView?.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.listTableView?.mj_footer?.endRefreshing()
        }
    }
    func loadGiftData(bup:Bool, giftType:String, searchKey:String) -> Void {
        
        var dataDict = Dictionary<String, String>()
        dataDict.updateValue(searchKey, forKey: "keyWords")
        dataDict.updateValue(bup == true ? "1" : "0", forKey: "order")
        dataDict.updateValue(giftType, forKey: "type")
        
        UserInfoNetworkProvider.request(.myGiftDetails(data: dataDict as NSDictionary, number: self.number, pageSize: self.pageSize)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 && model?.data != nil{
                            let dic = model!.data!
                            let totalElements = dic["totalElements"] as! String
                            self.total = totalElements.toInt ?? 0
                            if self.total > 0 {
                                if self.noDataObject == nil {
                                    
                                    self.noDataObject?.noDataView.isHidden = true
                                }
                                let arr = dic["content"] as! NSArray
                                if self.number == 1 {
                                    self.giftModels = arr.kj.modelArray(type: SSGiftMessageModel.self)
                                        as? [SSGiftMessageModel]
                                    
                                }else{
                                    let models = arr.kj.modelArray(type: SSGiftMessageModel.self)
                                        as? [SSGiftMessageModel]
                                    //
                                    self.giftModels = (self.giftModels ?? []) + (models ?? [])
                                }
                                self.isHiddenFooter(model: self.giftModels as AnyObject)
                                
                                //                                        self.listTableView?.reloadData()
                            }else{
                                if self.giftModels != nil {
                                    
                                    self.giftModels?.removeAll()
                                    self.listTableView?.reloadData()
                                }
                                self.listTableView?.mj_footer?.isHidden = true
                                
                                if self.noDataObject == nil {
                                    
                                    self.noDataObject = SSShowNoDataView(parentView: self.listTableView!, imageName: "my_nosc", tips: "暂无礼物")
                                }else{
                                    
                                    self.noDataObject?.noDataView.isHidden = false
                                }
                                
                            }
                        }else{
                            //
                        }
                    }
                    self.reloadTopSearchDataBlcok?()
                    
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noDataObject == nil {
            self.noDataObject = SSShowNoDataView(parentView: self.listTableView!, imageName: "my_nosc", tips: self.inType == 1 ? "暂无课程" : "暂无方案")
        }
        if inType == 1 {
            noDataObject?.noDataView.titleL.text = "暂无课程"
        }else if inType == 2 {
            noDataObject?.noDataView.titleL.text = "暂无方案"
        }else if inType == 4 {
            noDataObject?.noDataView.titleL.text = "暂无礼物"
        }else if inType == 3 {
            noDataObject?.noDataView.titleL.text = "暂无收藏"
        }
        if searchKey != "" {
            self.noDataObject?.noDataView.icon.image = UIImage.init(named: "noResult")
            self.noDataObject?.noDataView.titleL.text = "抱歉，没有找到相关信息\n请换个关键字试试~"
        }
        if inType == 1 || inType == 2 {
            let num = self.courseModels?.count ?? 0
            self.noDataObject?.noDataView.isHidden = num != 0
            return num
        }
        let num = self.giftModels?.count ?? 0
        self.noDataObject?.noDataView.isHidden = num != 0
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if inType == 1 || inType == 2 {
            
            let cell: SSMyCourseCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSMyCourseCell.self)) as! SSMyCourseCell
            
            cell.courseModel = courseModels?[indexPath.row]
            cell.selectionStyle = .none
            return cell
            
        }
        
        else if(inType == 4){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SSMyGiftMessageCell", for: indexPath) as! SSMyGiftMessageCell
            cell.model = self.giftModels?[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if inType == 1 || inType == 2 {
            
            let model = courseModels![indexPath.row]
            let titH = labelHeightLineSpac(fixedWidth: screenWid - 158, str: model.title ?? " ")
            if titH > 30 {
                
                return 190
            }
            
            return 175
        }
        if giftModels == nil {
            
            return 0
        }
        let model = giftModels![indexPath.row] as SSGiftMessageModel
        return model.type == 1 ? screenWid/414*280 : screenWid/414*347
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if inType == 1 || inType == 2 {
            
            let model = courseModels![indexPath.row] as CourseDetalisModel
            GotoTypeVC(type: inType == 1 ? 2 : 3, cid: model.id ?? "")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



extension SSGiftViewController{
    
    func buildUI()  {
        
        if UserInfo.getSharedInstance().type != 0 {
            
            let sendBtn = UIButton.initTitle(title: inType == 4 ? "礼物间" : (inType == 1 ? "发布课程" : "发布方案"), fontSize: 13, titleColor: .white)
            sendBtn.titleLabel?.font = UIFont.MediumFont(size: 13)
            sendBtn.backgroundColor = btnColor
            navView.addSubview(sendBtn)
            sendBtn.layer.cornerRadius = 16
            sendBtn.layer.masksToBounds = true
            sendBtn.snp.makeConstraints { make in
                
                make.trailing.equalTo(-16)
                make.height.equalTo(32)
                make.width.equalTo(76)
                make.centerY.equalToSuperview()
            }
            
            sendBtn.reactive.controlEvents(.touchUpInside).observe({_ in
                
                if self.inType == 1 || self.inType == 2{
                    let vc = SSMySendCourseController()
                    vc.type = self.inType - 1
                    self.navigationController?.navigationBar.isHidden = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    
                    let giftVC = SSMyGiftRoomController()
                    self.navigationController?.pushViewController(giftVC, animated: true)
                }
                
            })
        }
        
        searchView.searchTextField.placeholder = "搜索"
        // Do any additional setup after loading the view.
        searchView.clearBlock = {[weak self] in
            
            self?.searchView.searchTextField.text = ""
            self?.isSearch = false
            self?.listVcArray.first?.loadGiftData(bup: self?.bUp ?? true, giftType: (self?.finshType)!, searchKey: (self?.searchKey)!)
            
        }
        segmentedView = JXSegmentedView()
        
        segmentedDataSourse = JXSegmentedTitleDataSource()
        segmentedDataSourse.titles = segTitles
        segmentedDataSourse.isTitleColorGradientEnabled = true
        segmentedDataSourse.titleNormalColor = UIColor.init(hex: "#666666")
        segmentedDataSourse.titleSelectedColor = UIColor.init(hex: "#FD8024")
        segmentedView.dataSource = segmentedDataSourse
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        
        indicator.indicatorColor = UIColor.init(hex: "#FD8024")
        segmentedView.indicators = [indicator]
        
        contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.scrollsToTop = false
        contentScrollView.bounces = false
        
        contentScrollView.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        segmentedView.contentScrollView = contentScrollView
        
        segmentedView.delegate = self
        
        segmentedView.backgroundColor = .white
        
        self.view.addSubview(searchView)
        searchView.delegate = self
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(NavBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(searchViewHeight)
        }
        
        
        self.view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(screenWid*0.75)
            make.height.equalTo(50)
        }
        
        searchTipsV = UIView.init()
        searchTipsV?.backgroundColor = .white
        view.addSubview(searchTipsV!)
        searchTipsV!.isHidden = true
        searchTipsV?.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(segmentedView.snp.bottom)
        })
        searchTipsL = UILabel.initSomeThing(title: "搜索到", fontSize: 14, titleColor: .init(hex: "#B4B4B4"))
        searchTipsV!.addSubview(searchTipsL)
        searchTipsL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(checkBtn)
        checkBtn.setTitle("筛选", for: .normal)
        checkBtn.setImage(UIImage.init(named: "bt_select"), for: .normal)
        checkBtn.setTitleColor(.init(hex: "#999999"), for: .normal)
        checkBtn.titleLabel?.font = .systemFont(ofSize: 14)
        checkBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -25)
        checkBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 25)
        checkBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(segmentedView)
            make.height.equalTo(50)
            make.right.equalToSuperview()
            make.width.equalTo(screenWid*0.25)
        }
        
        checkBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            let selectView = SSGiftSelectView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
            selectView.order = self.bUp == true ? 1 : 2
            if self.paymentType == 1{
                selectView.paymentType = 2
            }else if self.paymentType == 2{
                selectView.paymentType = 1
            }else{
                selectView.paymentType = self.paymentType
            }
            if self.inType == 1 || self.inType == 2{
                
                selectView.payContents = self.inType == 1 ? ["全部","付费课程","免费课程","vip免费"] : ["全部","付费方案","免费方案","vip免费"]
            }else{
                
                selectView.payContents = nil
            }
            selectView.sureBtnBlock = {[weak self] (order,paymentType) in
                self?.bUp = order == 1 ? true : false
                self?.curView?.number = 1
                if self?.inType == 1 || self?.inType == 2{
                    if paymentType == 1 {
                        self?.paymentType = 2
                    }else if paymentType == 2 {
                        self?.paymentType = 1
                    }else{
                        self?.paymentType = paymentType
                    }
                    self?.curView?.courseModels?.removeAll()
                    self?.curView?.loadMyCourseData(order: order, finshType: self?.finshType ?? "0", type: self?.type ?? 1, paymentType: self?.paymentType ?? 0, title: (self?.searchKey)!)
                    
                }else{
                    
                    
                    //                self.clickModel = modex
                    //                self.loadData()
                    self?.curView?.giftModels?.removeAll()
                    self?.isSearch = false
                    self?.curView?.loadGiftData(bup: self?.bUp ?? false, giftType: self?.finshType ?? "", searchKey: (self?.searchKey)!)
                }
            }
            selectView.clickOKBlock = {bUp, bDown, modex in
                self.bUp = bUp
                //                self.clickModel = modex
                //                self.loadData()
                self.isSearch = false
                self.curView?.loadGiftData(bup: self.bUp, giftType: self.finshType, searchKey: self.searchKey)
                
            }
            self.view.addSubview(selectView)
        }
        
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTipsV!.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.bottom.equalToSuperview()
            //            make.height.equalTo(screenHei-NavBarHeight-50-statusHei)
        }
        
    }
    
    func setSerchTitle()  {
        
        if self.searchKey == "" {
            self.searchTipsL.isHidden = true
            self.searchTipsV?.isHidden = true
            self.searchTipsV?.snp.updateConstraints({ make in
                
                make.height.equalTo(0)
            })
            return
        }
        self.searchTipsL.isHidden = false
        self.searchTipsL.text = "共搜到\(self.inType == 4 ? self.curView?.giftModels?.count ?? 0 : self.curView?.courseModels?.count ?? 0 )个与“\(self.searchKey ?? "")”相关信息"
        
        let protocolText = NSMutableAttributedString(string: self.searchTipsL!.text!)
        //        userProtocolLabel.textColor = .init(hex: "#6A7587")
        let range1: Range = self.searchTipsL!.text!.range(of: "\(self.inType == 4 ? self.curView?.giftModels?.count ?? 0 : self.curView?.courseModels?.count ?? 0)")!
        let range: Range = self.searchTipsL!.text!.range(of: self.searchKey)!
        let startLocation = self.searchTipsL!.text!.distance(from: self.searchTipsL!.text!.startIndex, to: range.lowerBound)
        let startLocation1 = self.searchTipsL!.text!.distance(from: self.searchTipsL!.text!.startIndex, to: range1.lowerBound)
        
        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation, length: self.searchKey.length))
        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation1, length: String(self.inType == 4 ? self.curView?.giftModels?.count ?? 0 : self.curView?.courseModels?.count ?? 0).length))
        self.searchTipsL.attributedText = protocolText
    }
    
}
