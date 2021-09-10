//
//  SSMyCollectionCourseController.swift
//  shensuo
//
//  Created by  yang on 2021/7/7.
//

import UIKit
import JXPagingView
import MBProgressHUD
import BSText

class SSMyCollectionCourseController: HQBaseViewController {
    let headView = UIView()
    let tipView = BSLabel()
    var total = 0{
        didSet{
            if searchKey != "" {
                setNumAndKeyWord(num: "\(total)", keyWords: searchKey)
            }
        }
    }
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    //类型 0课程 1方案
    var inType: Int! = 0
    //付费类型 0全部 1免费 2付费 3vip免费
    var listTableView:UITableView?
    var currentIndex = 0    
    var number = 1
    var pageSize = 10
    var searchKey = ""
    
    var courseModels: [CourseDetalisModel]? = nil{
        
        didSet{
            
            if courseModels != nil {
                
                self.listTableView?.reloadData()
            }
        }
    }
    
    var noDataObject: SSCommonNoDataObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.listTableView?.delegate = self
        self.listTableView?.dataSource = self
        self.listTableView?.separatorStyle = .none
        self.listTableView?.backgroundColor = bgColor
        self.listTableView?.register(SSMyCourseCell.self, forCellReuseIdentifier: String(describing: SSMyCourseCell.self))
        
        self.listTableView?.register(SSMyGiftMessageCell.self, forCellReuseIdentifier: "SSMyGiftMessageCell")
        
        view.addSubview(self.listTableView!)
        self.listTableView?.snp.makeConstraints({ make in
            
            make.edges.equalToSuperview()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(searchReload(not:)), name: CollectionSearchCompletionNotification, object: nil)
        loadMyCourseData()
        self.listTableView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.number += 1
            
            self.loadMyCourseData()
            
        })
        
        tipView.textColor = .init(hex: "#B4B4B4")
        tipView.font = .systemFont(ofSize: 14)
        tipView.text = "请输入关键词开始搜索"
        tipView.frame = .init(x: 16, y: 0, width: screenWid, height: 30)
        self.headView.addSubview(tipView)
        self.headView.backgroundColor = .white
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#f6f6f6")
        headView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.left.right.bottom.equalToSuperview()
        }
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: false)
        }
    }
    
    @objc func searchReload(not: Notification)  {
        
        let index = not.userInfo!["currentIndex"] as! Int
        self.searchKey = not.userInfo!["searchKey"] as! String
        
        if index == currentIndex {
            
            loadMyCourseData()
            
        }
        
    }
    
    func loadMyCourseData()  {
        
        CourseNetworkProvider.request(.selectCourseCollectListApp(pageNumber: self.number, pageSize: self.pageSize,title: searchKey, type: inType)) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            let totalElements = dic["totalElements"] as! String
                            self.total = totalElements.toInt ?? 0
                            
                            let arr = dic["content"] as? NSArray
                            if self.number == 1 {
                                self.courseModels = arr?.kj.modelArray(type: CourseDetalisModel.self)
                                    as? [CourseDetalisModel]
                                
                            }else{
                                let models = arr?.kj.modelArray(type: CourseDetalisModel.self)
                                    as? [CourseDetalisModel]
                                //
                                self.courseModels = (self.courseModels ?? []) + (models ?? [])
                            }
                            //                                        self.listTableView?.reloadData()
                            
                        }
                    }
                    
                    
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    func isHiddenFooter() -> Void {
        if (self.courseModels?.count ?? 0) >= total {
            if self.courseModels == nil || self.courseModels?.count == 0 {
                if self.noDataObject == nil {
                    
                    self.noDataObject = SSShowNoDataView(parentView: self.listTableView!, imageName: "my_nosc", tips: self.inType == 0 ? "暂无课程" : "暂无方案")
                }else{
                    
                    self.noDataObject?.noDataView.isHidden = false
                }
            }
            self.listTableView?.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.listTableView?.mj_footer?.endRefreshing()
        }
    }
}

extension SSMyCollectionCourseController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = self.courseModels?.count ?? 0
            if self.noDataObject == nil {
                
                self.noDataObject = SSShowNoDataView(parentView: self.listTableView!, imageName: "my_nosc", tips: self.inType == 0 ? "暂无课程" : "暂无方案")
            }else{
                
                self.noDataObject?.noDataView.isHidden = false
            }
        
        self.noDataObject!.noDataView.isHidden = num != 0
        if self.noDataObject?.noDataView.isHidden == false{
            if searchKey == "" {
                self.noDataObject?.noDataView.icon.image = UIImage.init(named: "my_nosc")
                self.noDataObject?.noDataView.titleL.text = self.inType == 0 ? "暂无课程" : "暂无方案"
            }else{
                self.noDataObject?.noDataView.icon.image = UIImage.init(named: "noResult")
                self.noDataObject?.noDataView.titleL.text = "抱歉，没有找到相关信息\n请换个关键字试试~"
            }
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SSMyCourseCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSMyCourseCell.self)) as! SSMyCourseCell
                                                          
        cell.courseModel = courseModels?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let model = courseModels![indexPath.row]
        let titH = labelHeightLineSpac(fixedWidth: screenWid - 158, str: model.title ?? " ")
        if titH > 30 {
            return 190
        }
        return 175
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = courseModels![indexPath.row] as CourseDetalisModel
        GotoTypeVC(type: inType == 0 ? 2 : 3, cid: model.id ?? "")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchKey != "" {
            return headView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchKey != "" {
            if self.noDataObject?.noDataView != nil {
                self.noDataObject?.noDataView.snp.remakeConstraints({ make in
                    make.top.equalTo(30)
                    make.left.equalTo(0)
                    make.width.equalTo(screenWid)
                    make.height.equalTo(289)
                })
            }
            return 40
        }
        if self.noDataObject?.noDataView != nil {
            self.noDataObject?.noDataView.snp.remakeConstraints({ make in
                make.top.equalTo(10)
                make.left.equalTo(0)
                make.width.equalTo(screenWid)
                make.height.equalTo(289)
            })
        }
        return 0
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

extension SSMyCollectionCourseController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return view
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    public func listScrollView() -> UIScrollView {
        return self.listTableView!
    }
}
