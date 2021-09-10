//
//  SSFocusTableViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/15.
//

import UIKit


enum listType {
    case FriendList
    case FocusList
    case BlackList
}

//关注列表/粉丝列表/黑名单
class SSFocusListViewController: SSBaseViewController {
    
    var type:listType?
    var page:Int = 0
    let pageSize:Int = 10
    var totalPerson = 0
    var searchKey = ""
    var searchTipsV: UIView?
    var searchTipsL: UILabel!
    var request:UserInfoApiManage?
    let totalsNumL = UILabel.initSomeThing(title: "关注人数: 0人", fontSize: 16, titleColor: color33)
    var isSearch = false
    var noDataView = SearchNoDataView()
    
    var models : [SSFocusPopModel]? = nil{
        didSet{
            if models != nil {
                if type == .FriendList{
                    totalsNumL.text = "粉丝人数: \(totalPerson)人"
                }else if(type == .FocusList){
                    
                    totalsNumL.text = "关注人数: \(totalPerson)人"
                }else{
                    
                    totalsNumL.text = "拉黑人数: \(totalPerson)人"
                }
                self.listTableView.reloadData()
            }
        }
    }
    
    var focusModels : [SSFocusPopModel]? = nil{
        didSet{
            if focusModels != nil {
                if type == .FriendList {
                    totalsNumL.text = "粉丝人数: \(totalPerson)人"
                }else if(type == .FocusList){
                    totalsNumL.text = "关注人数: \(totalPerson)人"
                }else{
                    totalsNumL.text = "拉黑人数: \(totalPerson)人"
                }
                self.listTableView.reloadData()
            }
        }
    }
    
    
    var searchView:SSSearchView = {
        let search = SSSearchView.init()
        return search
    }()
    
    var listTableView:UITableView = {
        let listTable = UITableView.init()
        return listTable
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .FocusList {
            loadData()
        }else{
            loadFansData()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layoutSubViews()
        page = 1
        var dataDict = Dictionary<String, String>()
        if type == .FocusList {
            navView.backBtnWithTitle(title: "关注列表")
//            dataDict.updateValue(UserInfo.getSharedInstance().userId!, forKey: "userId")
//            dataDict.updateValue(UserInfo.getSharedInstance().nickName!, forKey: "nickName")
            listTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                self.page += 1
                self.request = .focusList(data:dataDict as NSDictionary, pageSize: 10, number: self.page)
                self.loadData()
            })
            request = .focusList(data:dataDict as NSDictionary, pageSize: 10, number: self.page)
            loadData()
          
        } else if type == .FriendList {
            navView.backBtnWithTitle(title: "粉丝列表")
//            dataDict.updateValue(UserInfo.getSharedInstance().userId!, forKey: "userId")
//            dataDict.updateValue(UserInfo.getSharedInstance().nickName!, forKey: "nickName")
            request = .fansList(data:dataDict as NSDictionary, pageSize: 10, number: self.page)
            loadData()
            listTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                self.page += 1
                self.request = .fansList(data:dataDict as NSDictionary, pageSize: 10, number: self.page)
                self.loadData()
            })
           
        } else {
            navView.backBtnWithTitle(title: "黑名单")
            request = .blackList(data:searchKey, pageSize: 10, number: self.page)
            loadData()
            listTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                self.page += 1
                self.request = .blackList(data:self.searchKey, pageSize: 10, number: self.page)
                self.loadData()
            })
        }
        
        self.ishideBar = true
        searchView.delegate = self
        listTableView.delegate = self;
        listTableView.dataSource = self;
        listTableView.separatorStyle = .none
        listTableView.showsVerticalScrollIndicator = false
        listTableView.tableFooterView = UIView.init()
         
        listTableView.register(focusCell.self, forCellReuseIdentifier: "focusCell")
        
        self.view.addSubview(noDataView)
        noDataView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTipsV!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(289)
        }
        
    }
    
//    func isHiddenFooter(model:AnyObject) -> Void {
//        if model.count < page*pageSize {
//            self.listTableView.mj_footer?.isHidden = true
//        }
//    }
    
    
    func loadData() -> Void {
        if self.page == 1 {
            self.models?.removeAll()
            self.focusModels?.removeAll()
            self.listTableView.reloadData()
        }
        UserInfoNetworkProvider.request(request!) { [self] (result) in
            self.listTableView.mj_footer?.endRefreshing()
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
                            self.totalPerson = total.toInt ?? 0
                            let arr = dic?["content"] as? NSArray
                            if arr != nil {
                                if self.page == 1 {
                                    self.focusModels = arr!.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
                                        
                                }else{
                                    let models = arr!.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
                                        
                                    self.focusModels = self.focusModels! + (models ?? [])
                                }
                            }
                            
                            if self.isSearch {
                                
                                self.setSerchTitle()
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
    
    func loadFansData() -> Void {
        UserInfoNetworkProvider.request(request!) { [self] (result) in
            self.listTableView.mj_footer?.endRefreshing()
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
                            self.totalPerson = total.toInt ?? 0
                            let arr = dic?["content"] as? NSArray
                            if arr != nil {
                                if self.page == 1 {
                                    self.models = arr!.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
                                        
                                }else{
                                    let models = arr!.kj.modelArray(type: SSFocusPopModel.self) as? [SSFocusPopModel]
                                    self.models = self.models! + (models ?? [])
                                }

                            }
                            if self.isSearch {
                                self.setSerchTitle()
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

    func layoutSubViews() -> Void {
        
//        self.view.addSubview(navView)
//        navView.snp.makeConstraints { (make) in
//            make.top.equalTo(NavStatusHei)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(NavContentHeight)
//        }
        
        self.view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        searchView.backgroundColor = .white
        searchTipsV = UIView.init()
        searchTipsV?.backgroundColor = .white
        view.addSubview(searchTipsV!)
        searchTipsV!.isHidden = true
        searchTipsV?.snp.makeConstraints({ make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(searchView.snp.bottom)
        })
        searchTipsL = UILabel.initSomeThing(title: "搜索到", fontSize: 14, titleColor: .init(hex: "#B4B4B4"))
        searchTipsV!.addSubview(searchTipsL)
        searchTipsL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        view.addSubview(totalsNumL)
        totalsNumL.backgroundColor = bgColor
        totalsNumL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.top.equalTo(searchTipsV!.snp.bottom).offset(12)
        }
        
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(totalsNumL.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSFocusListViewController:SSSearchViewDelegate {
    func searchDataWithKeyWord(key: String) {
        self.searchKey = key
        self.isSearch = true
        self.searchTipsV?.isHidden = false
        self.searchTipsV?.snp.updateConstraints({ make in
            
            make.height.equalTo(50)
        })
        self.page = 1
        self.models?.removeAll()
        var dataDict = Dictionary<String, String>()
        if type ==  .FocusList{
            dataDict.updateValue(searchKey, forKey: "nickName")
            request = .focusList(data: dataDict as NSDictionary, pageSize: 10, number: self.page)
        }else if(type == .FriendList){
            dataDict.updateValue(searchKey, forKey: "nickName")
            self.request = .fansList(data: dataDict as NSDictionary, pageSize: 10, number: self.page)
        }else{
            self.request = .blackList(data:searchKey, pageSize: 10, number: self.page)
        }
        if type == .FocusList {
            loadData()
        }else{
            loadFansData()
        }
        
       
    }
}

extension SSFocusListViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.type == .BlackList {
            return 98
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        if type == .FocusList && focusModels != nil {
            num = focusModels!.count
            if (totalPerson <= self.focusModels?.count ?? 0) {
                self.listTableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        if (self.models != nil) {
            num = self.models!.count
            if (totalPerson <= self.models?.count ?? 0) {
                self.listTableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        if num == 0 {
            if self.isSearch == false{
                if self.type == .FocusList {
                    
                    self.totalsNumL.text = "粉丝人数: \(0)人"
                }else if(type == .FriendList){
                    
                    self.totalsNumL.text = "关注人数: \(0)人"
                }else{
                    self.totalsNumL.text = "拉黑人数: \(0)人"
                }
                self.noDataView.isHidden = false
            }
            self.noDataView.isHidden = false
        }else{
            self.noDataView.isHidden = true
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "focusCell") as! focusCell
        if cell.reloadBlock == nil {
            cell.reloadBlock = {[weak self] num in
                if self?.type == .FocusList{
                    self?.focusModels?[num].focusType.toggle()
                }else{
                    self?.models?[num].focusType.toggle()
                }
                self?.listTableView.reloadData()
            }
        }
//        if cell.reloadBlock == nil {
//            cell.reloadBlock = { [weak self] in
//                self?.loadFansData()
//            }
//        }
        if type == .FocusList{
            cell.focusModel = focusModels?[indexPath.row]
        }else if type == .BlackList{
            var bcell : BlackUserListCell? = tableView.dequeueReusableCell(withIdentifier: "BlackListCell") as? BlackUserListCell
            if bcell == nil {
                bcell = BlackUserListCell.init(style: .default, reuseIdentifier: "BlackListCell")
                bcell?.reloadBlock = {[weak self] in
                    self?.page = 1
                    self?.loadFansData()
                }
            }
            bcell?.model = models?[indexPath.row]
            return bcell!
        }else{
            cell.focusModel = self.models?[indexPath.row]
        }
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .FocusList{
            let model = focusModels?[indexPath.row]
            GotoTypeVC(type: 99, cid: model?.userId ?? "")
        }else if type == .BlackList{
            let model = models?[indexPath.row]
            GotoTypeVC(type: 99, cid: model?.id ?? "")
        }else{
            let model = self.models?[indexPath.row]
            GotoTypeVC(type: 99, cid: model?.userId ?? "")
        }
    }
    
    func setSerchTitle()  {
        if self.searchKey == "" {
            self.searchTipsL.isHidden = true
            self.searchTipsV?.isHidden = true
            self.searchTipsV?.snp.updateConstraints({ make in
                
                make.height.equalTo(0)
            })
            self.isSearch = true
            return
        }
        self.searchTipsL.isHidden = false
        self.searchTipsL.text = "共搜到\(self.models?.count ?? 0 )个与“\(self.searchKey )”相关信息"

        let protocolText = NSMutableAttributedString(string: self.searchTipsL!.text!)
//        userProtocolLabel.textColor = .init(hex: "#6A7587")
        let range1: Range = self.searchTipsL!.text!.range(of: "\(self.models?.count ?? 0)")!
        let range: Range = self.searchTipsL!.text!.range(of: self.searchKey)!
        let startLocation = self.searchTipsL!.text!.distance(from: self.searchTipsL!.text!.startIndex, to: range.lowerBound)
        let startLocation1 = self.searchTipsL!.text!.distance(from: self.searchTipsL!.text!.startIndex, to: range1.lowerBound)

        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation, length: self.searchKey.length))
        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation1, length: self.totalPerson))
        self.searchTipsL.attributedText = protocolText
    }
    
}
