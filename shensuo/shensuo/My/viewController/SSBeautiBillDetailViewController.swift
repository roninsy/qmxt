//
//  SSBeautiBillDetailViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/4.
//

import UIKit

//美币明细
class SSBeautiBillDetailViewController: HQBaseViewController {

    let mainTableView = UITableView()

    var total = 0
    var page = 1
    let pageNumber = 10
    var headerView = SSBeautiBillDetailHeader.init()
    
    var balance:Double = 0.0
    var oid : String? = nil
    var payType : String? = nil
    
    var searchKey:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var checkId:String = ""
    
    let detailcell = SectionDetailView.init(style: .default, reuseIdentifier: "")
    var detailModes:[SSBillDetailModel]? = nil{
        didSet{
            if detailModes != nil {
                mainTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.loadSumData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(payCallBack(notifi:)), name: PayCompletionNotification, object: nil)
        self.view.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: screenWid, height: 352)
        headerView.setTitle()
        headerView.navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.addSubview(headerView)
        
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(SSBeautiBillDetailCell.self, forCellReuseIdentifier: "SSBeautiBillDetailCell")

        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.separatorStyle = .none
        
        mainTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData()
            
        })
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
        self.loadSunPointData()
        self.loadData()
        // Do any additional setup after loading the view.
        
        headerView.buyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            
            ///上报事件
            HQPushActionWith(name: "click_to_buy_coin", dic: ["current_page":"我的美币"])
            
            DispatchQueue.main.async {
                self.headerView.mainMeiBiView = UIView()
                HQGetTopVC()?.view.addSubview(self.headerView.mainMeiBiView)
                self.headerView.mainMeiBiView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                let botView = UIView()
                botView.backgroundColor = .init(hex: "#221F25")
                self.headerView.mainMeiBiView.addSubview(botView)
                botView.snp.makeConstraints { make in
                    make.height.equalTo(400 + SafeBottomHei)
                    make.bottom.left.right.equalToSuperview()
                }
                
                let buyMeiBiView = BuyMeiBiView()
                botView.addSubview(buyMeiBiView)
                buyMeiBiView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                buyMeiBiView.coinNumLab.text = "余额：\(UserInfo.getSharedInstance().points ?? 0)美币"
                
                let cancelBtn = UIButton()
                cancelBtn.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.headerView.mainMeiBiView.addSubview(cancelBtn)
                cancelBtn.snp.makeConstraints { make in
                    make.top.right.left.equalToSuperview()
                    make.bottom.equalTo(botView.snp.top)
                }
                cancelBtn.reactive.controlEvents(.touchUpInside)
                    .observeValues { btn in
                        self.headerView.mainMeiBiView.isHidden = true
                        self.headerView.mainMeiBiView.removeFromSuperview()
                    }
            }
            
        }
    }
    
    ///完成支付回调
    @objc func payCallBack(notifi : Notification){
        self.headerView.mainMeiBiView.removeFromSuperview()
        self.loadSumData()
        self.loadSunPointData()
        self.loadData()
    }
    
    func loadSumData() -> Void {
        UserInfoNetworkProvider.request(.myPoints) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                
                                self.headerView.valueLabel.text = dic?["points"] as? String
                                self.headerView.incomValue.text = dic?["totalIncomePoints"] as? String
                                self.headerView.outcomValue.text = dic?["totalPayPoints"] as? String
                                
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
    
    func loadSunPointData() -> Void {
        UserInfoNetworkProvider.request(.myPointsSum(categoryId: self.checkId, createdTimeMax: self.endTime + " 23:59:59", createdTimeMini: self.startTime + " 00:00:00", keyWords: self.searchKey)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                DispatchQueue.main.async {
                                    let dic = model?.data
                                    self.detailcell.outcom.text = "支出:  \(dic!["totalPayPoints"] as? Double ?? 0)"
                                    self.detailcell.incom.text = "收入: \(dic?["totalIncomePoints"] as? Double ?? 0)"
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
    

    func loadData() -> Void {
        var dataDict = Dictionary<String, String>()
        dataDict.updateValue(self.checkId, forKey: "categoryId")
        dataDict.updateValue(self.endTime + " 23:59:59", forKey: "createdTimeMax")
        dataDict.updateValue(self.startTime + " 00:00:00", forKey: "createdTimeMini")
        dataDict.updateValue(self.searchKey, forKey: "keyWords")
        dataDict.updateValue(UserInfo.getSharedInstance().userId!, forKey: "userId")
        
        UserInfoNetworkProvider.request(.getPointsDetail(data:dataDict as NSDictionary, pageSize: self.pageNumber, number: self.page)) { (result) in
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
                                let totalElements = dic?["totalElements"] as! String
                                self.total = totalElements.toInt ?? 0

                                    let arr = dic?["content"] as? NSArray
                                    if self.page == 1 {
                                        self.detailModes = arr?.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel]
                                    } else {
                                        self.detailModes! += (arr?.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel])!
                                    }
                                    self.isHiddenFooter(model: self.detailModes as AnyObject)
                                
                                
                             
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
    
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count >= self.total {
            self.mainTableView.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.mainTableView.mj_footer?.endRefreshing()
        }
    }
    
//    func loadSearchData() -> Void {
//        UserInfoNetworkProvider.request(.setPointsDetail) { (result) in
//            switch result{
//                case let .success(moyaResponse):
//                    do {
//                        let code = moyaResponse.statusCode
//                        if code == 200{
//                            let json = try moyaResponse.mapString()
//                            let model = json.kj.model(ResultArrModel.self)
//                            if model?.code == 0 {
//                                let dic = model?.data
//
//                                if dic == nil {
//                                    return
//                                }
//                                self.detailModes = dic?.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel]
//
//
//                            }else{
//
//                            }
//
//                        }
//
//                    } catch {
//
//                    }
//                case let .failure(error):
//                    logger.error("error-----",error)
//                }
//        }
//    }
    
    @objc func clickSelectBtn() -> Void {
        
        let selectView = SSSelectBillView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        selectView.type = .msg
        selectView.loadTypeDate(type: .msg)
        selectView.clickOKBlock = {startTime, endTime, dic in
            DispatchQueue.main.async {
                self.endTime = endTime
                self.startTime = startTime
                self.checkId = dic
                self.detailModes?.removeAll()
                self.page = 1
                self.loadSunPointData()
                self.loadData()
            }
        }
        self.view.addSubview(selectView)
    }
    
    @objc func clickSearchBtn() -> Void {
        self.navigationController?.pushViewController(SSBeautiBillSearchViewController(), animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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


extension SSBeautiBillDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.detailModes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 121
        } else {
            let model = self.detailModes?[indexPath.row]
            return 180 + (model?.height ?? 22) + 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            detailcell.isUserInteractionEnabled = true
            detailcell.timeBtn.setTitle(String(format: "%@至%@", startTime, endTime), for: .normal)
            detailcell.selectBtn.addTarget(self, action: #selector(clickSelectBtn), for: .touchUpInside)
            detailcell.searchBtn.addTarget(self, action: #selector(clickSearchBtn), for: .touchUpInside)
            detailcell.selectionStyle = .none
            return detailcell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSBeautiBillDetailCell", for: indexPath) as! SSBeautiBillDetailCell
        cell.detailModel = self.detailModes?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }


}


class SectionDetailView: UITableViewCell {
    
    let titleLabel = UILabel.initSomeThing(title: "美币明细", fontSize: 18, titleColor: .init(hex: "#FD8024"))
    let line = UIView.init()
    
    let searchBtn = UIButton.initBgImage(imgname: "bt_search")
    let selectBtn = UIButton.initBgImage(imgname: "bt_select")
    
    let timeBtn = UIButton.initTitle(title: "2021-08-21至2020-10-21", fontSize: 14, titleColor: .init(hex: "#666666"))
    let incom = UILabel.initSomeThing(title: "收入:", fontSize: 14, titleColor: .init(hex: "#666666"))
    let outcom = UILabel.initSomeThing(title: "支出:", fontSize: 14, titleColor: .init(hex: "#666666"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(32)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        contentView.addSubview(line)
        line.backgroundColor = .init(hex: "#FD8024")
        line.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(titleLabel)
            make.width.equalTo(21)
            make.height.equalTo(2)
        }
        contentView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
        }
        contentView.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.top.equalTo(selectBtn)
            make.right.equalTo(selectBtn.snp.left).offset(-25)
            make.width.height.equalTo(24)
        }
        
        
        contentView.addSubview(timeBtn)
        timeBtn.layer.masksToBounds = true
        timeBtn.layer.cornerRadius = 16
        timeBtn.backgroundColor = .init(hex: "#F7F8F9")
        timeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line.snp.bottom).offset(18)
            make.width.equalTo(200)
            make.height.equalTo(32)
        }
        
        incom.adjustsFontSizeToFitWidth = true
        contentView.addSubview(incom)
        incom.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(selectBtn.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        
        outcom.adjustsFontSizeToFitWidth = true
        contentView.addSubview(outcom)
        outcom.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(incom.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
