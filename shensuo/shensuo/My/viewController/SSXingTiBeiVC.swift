//
//  SSXingTiBeiVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/9/3.
//

import UIKit

class SSXingTiBeiVC: HQBaseViewController {

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
    
    let detailcell = XingTiBeiDetailView.init(style: .default, reuseIdentifier: "")
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
        mainTableView.register(SSAccountBillDetailCell.self, forCellReuseIdentifier: "SSAccountBillDetailCell")

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
        
        headerView.titleLabel.text = "形体贝"
        headerView.navView.backWithTitleOptionBtn(title: "我的形体贝", option: "")
        headerView.checkBtn.isHidden = true
        headerView.buyBtn.setTitle("充值形体贝", for: .normal)
        headerView.buyBtn.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(22)
            make.bottom.equalTo(-15)
        }
        headerView.buyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                let buyView = BuyAmountView()
                buyView.coinNumLab.text = "账户余额：\(UserInfo.getSharedInstance().xtb)贝"
    
                HQGetTopVC()?.view.addSubview(buyView)
                buyView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
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
        UserInfoNetworkProvider.request(.xingtibeiSum) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                
                                self.headerView.valueLabel.text = "\(dic?["xtb"] as? Double ?? 0)"
                                self.headerView.incomValue.text = "\(dic?["totalIncomeXtb"] as? Double ?? 0)"
                                self.headerView.outcomValue.text = "\(dic?["totalPayXtb"] as? Double ?? 0)"
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
        UserInfoNetworkProvider.request(.myXingTiBeiSum(categoryId: self.checkId, createdTimeMax: self.endTime + " 23:59:59", createdTimeMini: self.startTime + " 00:00:00", keyWords: self.searchKey)) { (result) in
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
                                    self.detailcell.outcom.text = "支出:  \(dic!["totalPayXtb"] as? Double ?? 0)"
                                    self.detailcell.incom.text = "收入: \(dic?["totalIncomeXtb"] as? Double ?? 0)"
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
        
        UserInfoNetworkProvider.request(.getXingtibeiDetail(data:dataDict as NSDictionary, pageSize: self.pageNumber, number: self.page)) { (result) in
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
        selectView.type = .xtb
        selectView.loadTypeDate(type: .xtb)
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
        self.navigationController?.pushViewController(SSXingTibiSearchViewController(), animated: true)
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

extension SSXingTiBeiVC : UITableViewDelegate, UITableViewDataSource {
    
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
            let categoryNameH = labelHeightLineSpac(fixedWidth: screenWid - 137, str: model?.remarks ?? "")
            let topH: CGFloat = 50
            let normalCellH: CGFloat = 40
            let lineNum : CGFloat = model?.payChannel == 4 ? 5 : 4
            var lineHei = lineNum * normalCellH + topH
            if categoryNameH > 25{
                lineHei = (lineNum * normalCellH - 22
                            + topH + categoryNameH)
            }
            return lineHei
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSAccountBillDetailCell", for: indexPath) as! SSAccountBillDetailCell
        cell.iconStr = "形体贝"
        cell.detailModel = self.detailModes?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

class XingTiBeiDetailView: UITableViewCell {
    
    let titleLabel = UILabel.initSomeThing(title: "形体贝明细", fontSize: 18, titleColor: .init(hex: "#FD8024"))
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
            make.width.equalTo(100)
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
