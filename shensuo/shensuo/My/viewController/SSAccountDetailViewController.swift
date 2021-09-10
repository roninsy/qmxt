//
//  SSAccountDetailViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/21.
//

import UIKit

class SSAccountDetailViewController: HQBaseViewController {
    
    let mainTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei+statusHei), style: .plain)

    var page = 1
    let pageNumber = 16
    var headerView = SSAmountDetailHeader.init()
    
    var balance:Double = 0.0
    
    var searchKey:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var checkId:String = ""
    
    var total = 0
    
    var detailModes:[SSBillDetailModel]?
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
        self.loadSumData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(payCallBack(notifi:)), name: PayCompletionNotification, object: nil)
        
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(SSAccountBillDetailCell.self, forCellReuseIdentifier: "SSAccountBillDetailCell")
        mainTableView.register(sectionAccountDetailView.self, forCellReuseIdentifier: "sectionAccountDetailView")
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.separatorStyle = .none
        mainTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadSearchData()
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
        self.loadSearchData()
        
    }
    
    func tableHeaderView() -> UIView {
        headerView.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*320)
        headerView.type = .account
        headerView.setTitle()
        headerView.navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        
        headerView.checkBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            
            let cashVC = SSMyCashOutViewController.init()
            cashVC.balance = self.balance
            self.navigationController?.pushViewController(cashVC, animated: true)
        }
        
//        headerView.payBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
//            DispatchQueue.main.async {
//                let buyView = BuyAmountView()
//                buyView.coinNumLab.text = "账户余额：\(UserInfo.getSharedInstance().balance)元"
//                HQGetTopVC()?.view.addSubview(buyView)
//                buyView.snp.makeConstraints { make in
//                    make.edges.equalToSuperview()
//                }
//            }
//        }
    
        return headerView
    }
    
    ///完成支付回调
    @objc func payCallBack(notifi : Notification){
        self.loadSumData()
        self.loadTimeData()
        self.loadSearchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadSumData() -> Void {
        UserInfoNetworkProvider.request(.userAccountSum) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                if dic == nil {
                                    return
                                }
                                
                                    
                                self.headerView.valueLabel.text = "￥\(dic!["balance"] as? Double ?? 0.00)"
//                                self.headerView.valueLabel.text = String(format: "%.2", self.headerView.valueLabel.text!)
                                self.headerView.incomValue.text = "￥\(dic!["totalIncomeBalance"] as? Double ?? 0.00)"
//                                self.headerView.incomValue.text = String(format: "%.2", self.headerView.incomValue.text!)
                                self.headerView.outcomValue.text = "￥\(dic!["totalPayBalance"] as? Double ?? 0.00)"
//                                self.headerView.incom.text = "\(dic!["totalIncomeBalance"] as? Double ?? 0.00)"
//                                self.headerView.outcom.text = "\(dic?["totalPayBalance"] as? Double ?? 0.00)"


//                                self.headerView.outcomValue.text = String(format: "%.02", self.headerView.outcomValue.text!)
//                                self.headerView.valueLabel.text =  as? String
//                                self.headerView.incomValue.text = dic?["totalIncomeBalance"] as? String
//                                self.headerView.outcomValue.text = String(format: "%.02f", self.balance)
                                
//                                guard dic?["balance"] is NSNull else {
//                                    self.balance = dic?["balance"] as! Double
//                                    break
//                                }
//                                guard dic?["totalIncomeBalance"] is NSNull else {
//                                    self.headerView.incomValue.text = "\(dic!["totalIncomeBalance"] as? Double ?? 0.00)"
//                                    break
//                                }
//                                guard dic?["totalPayBalance"] is NSNull else {
//                                    self.headerView.outcomValue.text = "\(dic?["totalPayBalance"] as? Double ?? 0.00)"
//                                    break
//                                }

//                                self.headerView.valueLabel.text = String(format: "%.02f", self.balance)

                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func loadTimeData() -> Void {
     
        UserInfoNetworkProvider.request(.myAccountSum(categoryId: self.checkId, createdTimeMax: "\(self.endTime) 23:59:59", createdTimeMini: "\(self.startTime) 00:00:00", keyWords: self.searchKey)) { (result) in
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
//                                let totalStr = dic?["totalElements"] as? String ?? "0"
//                                self.total = totalStr.toInt ?? 0
                                let cell = self.mainTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! sectionAccountDetailView
                                cell.outcom.text = "支出:  ￥\(dic!["totalPayBalance"] as? Double ?? 0.00)"
                                cell.incom.text = "收入: ￥\(dic?["totalIncomeBalance"] as? Double ?? 0.00)"
                                self.mainTableView.reloadData()
                             
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
        if model.count < page*pageNumber {
            self.mainTableView.mj_footer?.isHidden = true
        }
    }
    
    func loadSearchData() -> Void {

        UserInfoNetworkProvider.request(.getAccountDetail(data: ["categoryId":self.checkId,
                                                                 "createdTimeMax":"\(self.endTime) 23:59:59",
                                                                 "createdTimeMini":"\(self.startTime) 00:00:00",
                                                                 "keyWords":self.searchKey,
                                                                 "userId": UserInfo.getSharedInstance().userId ?? ""
                                                    ], pageSize: self.pageNumber, number: self.page)) { (result) in
            switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                
                                if dic == nil {
                                    return
                                }
                                let totalStr = dic?["totalElements"] as? String ?? "0"
                                self.total = totalStr.toInt ?? 0
                                let arr = dic?["content"] as? NSArray
                                if self.page == 1 {
                                    self.detailModes = arr?.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel]
                                }else{
                                    let arr = arr?.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel]
                                    self.detailModes = self.detailModes! + (arr ?? [])
                                }
                                
                                self.mainTableView.reloadData()
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
    
    @objc func clickSelectBtn() -> Void {
        
        let cell = mainTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! sectionAccountDetailView
        
        
        let selectView = SSSelectBillView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        selectView.type = .account
        selectView.loadTypeDate(type: .account)
        selectView.clickOKBlock = {startTime, endTime, id in
            DispatchQueue.main.async {
                self.startTime = startTime
                self.endTime = endTime
                self.checkId = id
                cell.timeBtn .setTitle(String(format: "%@至%@", startTime, endTime), for: .normal)
                self.page = 1
                self.detailModes?.removeAll()
                self.loadTimeData()
                self.loadSearchData()
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

extension SSAccountDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        let num = self.detailModes?.count ?? 0
        if num >= self.total {
            self.mainTableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return screenWid/414*121
        } else {
            if self.detailModes != nil {
                
                let model = self.detailModes![indexPath.row]
                let categoryNameH = labelHeightLineSpac(fixedWidth: screenWid - 137, str: model.remarks)
                let topH: CGFloat = 50
                let normalCellH: CGFloat = 40
                switch model.categoryId {
                    case 1:
                        return  categoryNameH > 25 ? (6 * normalCellH - 22
                            + topH + categoryNameH) : 6 * normalCellH + topH                        
                    case 2:
                        return categoryNameH > 25 ? (5 * normalCellH - 22
                            + topH + categoryNameH) : 5 * normalCellH + topH
                    case 3:
                        return 6 * normalCellH + topH
                        
                    case 4,10,6,12:
                        return 5 * normalCellH + topH
                        
                case 17:
                    return categoryNameH > 25 ? (5 * normalCellH - 22
                                                    + topH + categoryNameH) : 5 * normalCellH + topH
                    default:
                        return categoryNameH > 25 ? (5 * normalCellH - 22
                                                        + topH + categoryNameH) : 5 * normalCellH + topH
                        break
                }
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionAccountDetailView", for: indexPath) as! sectionAccountDetailView
            cell.isUserInteractionEnabled = true
            cell.selectBtn.addTarget(self, action: #selector(clickSelectBtn), for: .touchUpInside)
            cell.searchBtn.addTarget(self, action: #selector(clickSearchBtn), for: .touchUpInside)
            if self.startTime != "" {
                
                cell.timeBtn.setTitle("\(self.startTime)至\(self.endTime)", for: .normal)

            }
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSAccountBillDetailCell", for: indexPath) as! SSAccountBillDetailCell
        cell.detailModel = self.detailModes?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }


}


class sectionAccountDetailView: UITableViewCell {
    
    let titleLabel = UILabel.initSomeThing(title: "账户明细", fontSize: 18, titleColor: .init(hex: "#FD8024"))
    let line = UIView.init()
    
    let searchBtn = UIButton.initBgImage(imgname: "bt_search")
    let selectBtn = UIButton.initBgImage(imgname: "bt_select")
    
    let timeBtn = UIButton.initTitle(title: "2021-06-21至2021-07-20", fontSize: 14, titleColor: .init(hex: "#666666"))
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
            make.left.equalTo(16)
            make.top.equalTo(line.snp.bottom).offset(18)
            make.width.equalTo(200)
            make.height.equalTo(32)
        }
        
        contentView.addSubview(incom)
        incom.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(selectBtn.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(130)
        }
        
        contentView.addSubview(outcom)
        outcom.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(incom.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(130)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SSAccountBillDetailCell: UITableViewCell {
    
    let bgView = UIView.init()
    let nameLabel = UILabel.initSomeThing(title: "获得现金", isBold: true, fontSize: 17, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let pointLabel = UILabel.initSomeThing(title: "+50", isBold: false, fontSize: 13, textAlignment: .right, titleColor: .init(hex: "#333333"))
    let line = UIView.init()
    let orderLabel = UILabel.initSomeThing(title: "订单号:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let orderValue = UILabel.initSomeThing(title: "lwmx_00000000000000000001", fontSize: 16, titleColor: .init(hex: "#333333"))
    let serverLabel = UILabel.initSomeThing(title: "服务:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let serverValue = UILabel.initSomeThing(title: "用户[张小飞]送礼[比心]给课程/方案动态/美丽日记/美丽相册[XX标题]/[毛宇琳]", fontSize: 16, titleColor: .init(hex: "#333333"))
    let teachLabel = UILabel.initSomeThing(title: "导师:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let teachValue = UILabel.initSomeThing(title: "认证企业/个人昵称", fontSize: 16, titleColor: .init(hex: "#333333"))
    let copyrightLabel = UILabel.initSomeThing(title: "版权所有:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let copyrightValue = UILabel.initSomeThing(title: "认证企业/个人昵称", fontSize: 16, titleColor: .init(hex: "#333333"))
    let payLabel = UILabel.initSomeThing(title: "对方:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let payValue = UILabel.initSomeThing(title: "认证企业/个人昵称", fontSize: 16, titleColor: .init(hex: "#333333"))
    let serverMoneyLabel = UILabel.initSomeThing(title: "技术服务费:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let serverMoneyValue = UILabel.initSomeThing(title: "20%", fontSize: 16, titleColor: .init(hex: "#333333"))
    let timeLabel = UILabel.initSomeThing(title: "时间:", fontSize: 16, titleColor: .init(hex: "#878889"))
    let timeValue = UILabel.initSomeThing(title: "2020-16-01 15:30", fontSize: 16, titleColor: .init(hex: "#333333"))
    
    var iconStr = ""
    
    var detailModel : SSBillDetailModel? = nil{
        didSet{
            if detailModel != nil {
                
                var num = NSMutableAttributedString.init()
                nameLabel.text = detailModel?.categoryName
                orderValue.text = detailModel?.id
                serverValue.text = detailModel?.remarks
//                teachValue.text = detailModel?.teacherUserName ?? ""
//                copyrightValue.text = detailModel?.copyrightUserName
//                payValue.text = detailModel?.otherSideName
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#21D826")]
                let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#EF0B19")]
                let attrs3 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#333333")]
                
                if detailModel!.transactionType == 0 {
                    num = NSMutableAttributedString(string:"+\(detailModel!.money)", attributes:attrs2)
                }else if(detailModel?.transactionType == 1){
                    num = NSMutableAttributedString(string:detailModel!.money.stringValue, attributes:attrs1)
                }else if(detailModel?.transactionType == -1){
                    let add = detailModel!.money.doubleValue > 0
                    num = NSMutableAttributedString(string:"\(add ? "+" : "")\(detailModel!.money.stringValue)形体贝", attributes:attrs3)
                    let length = detailModel!.money.stringValue.length + (add ? 1 : 0)
                    num.bs_set(font: .MediumFont(size: 20), range: .init(location: 0, length: length))
                    num.bs_set(color: (add ? .init(hex: "#EF0B19") : .init(hex: "#21D826")), range: .init(location: 0, length: length))
                    
                }
                else {
                    num = NSMutableAttributedString(string:"-\(detailModel!.money)", attributes:attrs3)
                }
                
                
                pointLabel.attributedText = num

                timeValue.text = detailModel?.createdTime
    
                switch detailModel?.categoryId {
                    case 1:
                        teachLabel.text = "导师:"
                        teachValue.text = detailModel?.tutorUserName
                        copyrightLabel.text = "版权所有:"
                        copyrightValue.text = detailModel?.copyrightUserName
                        payLabel.text = "对方:"
                        payValue.text = detailModel?.otherSideName
                        serverMoneyLabel.text = "技术服务费:"
                        serverMoneyValue.text = serverMoneyWithModel(model: detailModel!)
                        serverMoneyValue.isHidden = false
                        serverMoneyLabel.isHidden = false
                        timeLabel.isHidden = false
                        timeValue.isHidden = false
                        
                        break
                    case 2:
                        teachLabel.text = "导师:"
                        teachValue.text = detailModel?.tutorUserName
                        copyrightLabel.text = "版权所有:"
                        copyrightValue.text = detailModel?.copyrightUserName
                        payLabel.text = "对方:"
                        payValue.text = detailModel?.otherSideName
                        serverMoneyLabel.text = "时间:"
                        serverMoneyValue.text = detailModel?.createdTime
                        serverMoneyValue.isHidden = false
                        serverMoneyLabel.isHidden = false
                        timeLabel.isHidden = true
                        timeValue.isHidden = true

                        break
                    case 3:
                        teachLabel.text = "对方:"
                        teachValue.text = detailModel?.otherSideName
                        copyrightLabel.text = "分成比例:"
                        copyrightValue.text = serverMoneyWithModel(model: detailModel!)
                        payLabel.text = "礼物价值:"
                        payValue.text = "\(detailModel?.valuePoints ?? "")美币"
                        serverMoneyLabel.text = "时间:"
                        serverMoneyValue.text = detailModel?.createdTime
                        serverMoneyValue.isHidden = false
                        serverMoneyLabel.isHidden = false
                        timeLabel.isHidden = true
                        timeValue.isHidden = true
                        break
                    case 6:
                        teachLabel.text = "对方:"
                        teachValue.text = detailModel?.otherSideName
                        copyrightLabel.text = "提现服务费:"
                        copyrightValue.text = serverMoneyWithModel(model: detailModel!)
                        payLabel.text = "时间:"
                        payValue.text = detailModel?.createdTime
                        serverMoneyValue.isHidden = true
                        serverMoneyLabel.isHidden = true
                        timeLabel.isHidden = true
                        timeValue.isHidden = true
                        break
                    case 4,10:
                        
                        teachLabel.text = "对方:"
                        teachValue.text = detailModel?.otherSideName
                        copyrightLabel.text = "支付方式:"
                        copyrightValue.text = payTypeWithPayChannel(payChannel: detailModel?.payChannel ?? 1)
                        payLabel.text = "时间:"
                        payValue.text = detailModel?.createdTime
                        serverMoneyValue.isHidden = true
                        serverMoneyLabel.isHidden = true
                        timeLabel.isHidden = true
                        timeValue.isHidden = true
                        break
                    case 12:
                        
                        teachLabel.text = "对方:"
                        teachValue.text = detailModel?.otherSideName
                        copyrightLabel.text = "回退提现服务费:"
                        copyrightValue.text = serverMoneyWithModel(model: detailModel!)
                        payLabel.text = "时间:"
                        payValue.text = detailModel?.createdTime
                        serverMoneyValue.isHidden = true
                        serverMoneyLabel.isHidden = true
                        timeLabel.isHidden = true
                        timeValue.isHidden = true
                        break
                    default:
                        if detailModel?.payChannel == 5 {
                            teachLabel.text = "对方:"
                            teachValue.text = detailModel?.otherSideName
                            copyrightLabel.text = "时间:"
                            copyrightValue.text = detailModel?.createdTime
                            payLabel.isHidden = true
                            payValue.isHidden = true
                            if detailModel?.transactionTime != nil && detailModel?.transactionTime != ""{
                                copyrightValue.text = detailModel?.transactionTime
                            }
                        }else{
                            payLabel.isHidden = false
                            payValue.isHidden = false
                            teachLabel.text = "对方:"
                            teachValue.text = detailModel?.otherSideName
                            copyrightLabel.text = "支付方式:"
                            copyrightValue.text = payTypeWithPayChannel(payChannel: detailModel?.payChannel ?? 1)
                            payLabel.text = "时间:"
                            payValue.text = detailModel?.createdTime
                            if detailModel?.transactionTime != nil && detailModel?.transactionTime != ""{
                                payValue.text = detailModel?.transactionTime
                            }
                        }
                        
                        serverMoneyValue.isHidden = true
                        serverMoneyLabel.isHidden = true
                        timeLabel.isHidden = true
                        timeValue.isHidden = true
                        break
                }
                
                
            }
        }
        
    }
    
    func serverMoneyWithModel(model: SSBillDetailModel) -> String {
        
        if model.categoryId == 1 {
            
            return "\(model.technologyServiceFee)%"
        }else if(model.categoryId == 3){
            return "\(model.shareRatio)%"
        }else if (model.categoryId == 6 || model.categoryId == 12){
            
            return "\(model.withdrawServiceFee)%"
        }
        return ""
    }
    
    func payTypeWithPayChannel(payChannel: Int) -> String {

        if payChannel == 3 {

            return "余额"
        }else if(payChannel == 1){

            return "支付宝"
        }else if(payChannel == 4){
            
            return "苹果内购"
        }else{

            return "微信"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(12)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(pointLabel)
        pointLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(-16)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(line)
        line.backgroundColor = .init(hex: "#EEEFF0")
        line.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(screenWid-20)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(line.snp.bottom).offset(16)
            make.height.equalTo(22)
            make.width.equalTo(90)
        }
        
        contentView.addSubview(orderValue)
        orderValue.numberOfLines = 0
        orderValue.snp.makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp.right)
            make.top.equalTo(orderLabel)
            make.right.equalTo(-16)
        }
        
        contentView.addSubview(serverLabel)
        serverLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(orderValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(90)
        }
        
        contentView.addSubview(serverValue)
        serverValue.numberOfLines = 0
        serverValue.snp.makeConstraints { (make) in
            make.left.equalTo(serverLabel.snp.right)
            make.centerY.equalTo(serverLabel)
            make.trailing.equalTo(-16)
        }
        
        contentView.addSubview(teachLabel)
        teachLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(serverValue.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(90)
        }
        
        contentView.addSubview(teachValue)
        teachValue.numberOfLines = 0
        teachValue.snp.makeConstraints { (make) in
            make.left.equalTo(teachLabel.snp.right)
            make.centerY.equalTo(teachLabel)
        }
        
        contentView.addSubview(copyrightLabel)
        copyrightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(teachLabel.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(90)
        }
        
        contentView.addSubview(copyrightValue)
        copyrightValue.numberOfLines = 0
        copyrightValue.snp.makeConstraints { (make) in
            make.left.equalTo(copyrightLabel.snp.right)
            make.centerY.equalTo(copyrightLabel)
        }
        
        contentView.addSubview(payLabel)
        payLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(copyrightLabel.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(90)
        }
        
        contentView.addSubview(payValue)
        payValue.numberOfLines = 0
        payValue.snp.makeConstraints { (make) in
            make.left.equalTo(payLabel.snp.right)
            make.centerY.equalTo(payLabel)
        }
        
        contentView.addSubview(serverMoneyLabel)
        serverMoneyLabel.snp.makeConstraints { make in
            
            make.leading.equalTo(orderLabel)
            make.top.equalTo(payLabel.snp.bottom).offset(12)
        }
        
        contentView.addSubview(serverMoneyValue)
        serverMoneyValue.snp.makeConstraints { make in
            
            make.leading.equalTo(orderValue)
            make.centerY.equalTo(serverMoneyLabel)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(serverMoneyLabel.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.width.equalTo(90)
        }
        
        contentView.addSubview(timeValue)
        timeValue.numberOfLines = 0
        timeValue.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right)
            make.centerY.equalTo(timeLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
