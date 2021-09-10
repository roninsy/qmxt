//
//  IntiveRecordListVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/10.
//邀请记录

import UIKit
import MBProgressHUD

class IntiveRecordListVC: SSBaseViewController {
    
    let mainTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei+statusHei), style: .plain)

    var page = 1
    let pageNumber = 10
    var headerView = SSIntiveRecordHeaderView.init()
    
    var balance:Double = 0.0
    
    var searchKey:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var checkId:String = ""
    
    var total = 0
    
    var detailModes:[SSIntiveRecordModel]?
//    var detailModes:[SSBillDetailModel]? = nil{
//        didSet{
//            if detailModes != nil {
//                mainTableView.reloadData()
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(SSIntiveRecordCell.self, forCellReuseIdentifier: "SSIntiveRecordCell")
        mainTableView.register(sectionAccountDetailView.self, forCellReuseIdentifier: "sectionAccountDetailView")
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.separatorStyle = .none
        mainTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadTimeData()
        })
        

        self.view.addSubview(tableHeaderView())
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        let date = Date()
        let sfm = DateFormatter()
        sfm.dateFormat = "YYYY-MM-01"
        self.startTime = sfm.string(from: date)
        sfm.dateFormat = "YYYY-MM-dd"
        self.endTime = sfm.string(from: date)
        self.loadTimeData()
        
    }
    
    func tableHeaderView() -> UIView {
        headerView.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*320)
        headerView.navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        return headerView
    }
    
    func loadTimeData() -> Void {
        var dataDict = Dictionary<String, String>()
        dataDict.updateValue(self.endTime == "" ? "" : "\(self.endTime) 23:59:59", forKey: "createdTimeEnd")
        dataDict.updateValue(self.startTime == "" ? "" : "\(self.startTime) 00:00:00", forKey: "createdTimeStart")
        dataDict.updateValue(self.searchKey, forKey: "keyWord")
        dataDict.updateValue(UserInfo.getSharedInstance().userId!, forKey: "userId")

        UserInfoNetworkProvider.request(.myReferUser(data:dataDict as NSDictionary, pageSize: self.page, number: self.pageNumber)) { (result) in
            self.mainTableView.mj_footer?.endRefreshing()
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
                                        self.detailModes = arr.kj.modelArray(type: SSIntiveRecordModel.self) as? [SSIntiveRecordModel]
                                    } else {
                                        self.detailModes! += (arr.kj.modelArray(type: SSIntiveRecordModel.self) as? [SSIntiveRecordModel])!
                                    }
                                    self.mainTableView.reloadData()
                                }
                                
                             
                            }else{
                                self.mainTableView.mj_footer?.isHidden = true
//                                HQShowNoDataView(parentView: self.view, imageName: "my_nosc", tips: "暂无明细")
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func loadSearchData() -> Void {
        UserInfoNetworkProvider.request(.setPointsDetail) { (result) in
            switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                
                                if dic == nil {
                                    return
                                }
                                self.detailModes = dic?.kj.modelArray(type: SSIntiveRecordModel.self) as? [SSIntiveRecordModel]
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    @objc func clickSelectBtn() -> Void {
        
        let cell = mainTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! sectionAccountDetailView
        
        
        let selectView = SSSelectBillView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        selectView.type = .intive
        selectView.loadTypeDate(type: .account)
        selectView.clickOKBlock = {startTime, endTime, id in
            DispatchQueue.main.async {
                self.startTime = startTime
                self.endTime = endTime
                self.checkId = id
                cell.timeBtn .setTitle(String(format: "%@至%@", startTime, endTime), for: .normal)
                
                self.detailModes?.removeAll()
                self.loadTimeData()
            }
        }
        self.view.addSubview(selectView)
    }
    
    @objc func clickSearchBtn() -> Void {
        self.navigationController?.pushViewController(SSBeautiBillSearchViewController(), animated: true)
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

extension IntiveRecordListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if (self.detailModes?.count ?? 0) >= self.total {
            self.mainTableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        return self.detailModes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return screenWid/414*121
        } else {
            return 115
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionAccountDetailView", for: indexPath) as! sectionAccountDetailView
            cell.incom.isHidden = true
            cell.outcom.isHidden = true
            cell.titleLabel.text = "邀请记录"
            cell.isUserInteractionEnabled = true
            cell.selectBtn.addTarget(self, action: #selector(clickSelectBtn), for: .touchUpInside)
            cell.searchBtn.addTarget(self, action: #selector(clickSearchBtn), for: .touchUpInside)
            if self.startTime != "" {
                
                cell.timeBtn.setTitle("\(self.startTime)至\(self.endTime)", for: .normal)

            }
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSIntiveRecordCell", for: indexPath) as! SSIntiveRecordCell
        cell.model = self.detailModes?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }


}
