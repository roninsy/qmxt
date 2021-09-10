//
//  SSMyCashOutListViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/17.
//

import UIKit

//提现记录
class SSMyCashOutListViewController: SSBaseViewController {

    let searchView = SSSearchView.init()
    let mainTableView = UITableView.init()
    var page = 1
    let pageSize = 10
    
    let timeLabel = UILabel.initSomeThing(title: "2020-08-21至2020-10-21", fontSize: 16, titleColor: .init(hex: "#333333"))
    let timeView = UIView.init()
    
    var searchKey:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var checkId:String = ""
    
    var listModels : [SSOutMoneyModel]? = nil {
        didSet {
            if listModels != nil {
                self.mainTableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
        navView.backBtnWithTitle(title: "提现记录")
        // Do any additional setup after loading the view.
        
        self.mainTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadlistData()
        })
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.register(SSOutMoneyCell.self, forCellReuseIdentifier: "SSOutMoneyCell")
        
        
        self.buildUI()
        self.loadlistData()
    }
    
    func buildUI() -> Void {
        self.view.addSubview(searchView)
        searchView.delegate = self
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(NavBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(searchViewHeight)
        }
        
        let topView = UIView.init()
        topView.backgroundColor = .white
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        let noteLabel = UILabel.initSomeThing(title: "提现记录", titleColor: .init(hex: "#FD8024"), font: .SemiboldFont(size: 18), ali: .center)
        topView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.height.equalTo(25)
            make.width.equalTo(80)
        }
        
        let noteLine = UIView.init()
        noteLine.backgroundColor = .init(hex: "#FD8024")
        topView.addSubview(noteLine)
        noteLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(noteLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(20)
        }
        
        let selBtn = UIButton.init()
        selBtn.setImage(UIImage.init(named: "bt_select"), for: .normal)
        topView.addSubview(selBtn)
        selBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(noteLabel)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(24)
        }
        
        selBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            let selectView = SSSelectBillView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
            selectView.type = .outMoney
            selectView.loadTypeDate(type: .outMoney)
            selectView.clickOKBlock = {startTime, endTime, dic in
                self.startTime = startTime
                self.endTime = endTime
                self.checkId = dic
                self.timeView.isHidden = false
                self.mainTableView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.timeView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                self.loadlistData()
            }
            self.view.addSubview(selectView)
        }
        
        let label = UILabel.initSomeThing(title: "筛选", fontSize: 14, titleColor: .init(hex: "#999999"))
        topView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.equalTo(selBtn.snp.left).offset(-4)
            make.centerY.equalTo(selBtn)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        
        timeView.backgroundColor = .init(hex: "#F7F8F9")
        timeView.isHidden = true
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        timeView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.height.equalTo(22)
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    
    func loadlistData() -> Void {
        var dataDict = Dictionary<String, String>()
        dataDict.updateValue(self.endTime, forKey: "applyForTimeEnd")
        dataDict.updateValue(self.startTime, forKey: "applyForTimeStart")
        dataDict.updateValue(self.checkId, forKey: "fettle")
        dataDict.updateValue(self.searchKey, forKey: "keyWords")
        UserInfoNetworkProvider.request(.withdrawRecords(data: dataDict as NSDictionary, pageSize: self.pageSize, number: self.page)) { (result) in
            switch result {
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
                                if (total.toInt ?? 0) > 0 {
                                    let arr = dic?["content"] as! NSArray
                                    if self.page == 1 {
                                        self.listModels = arr.kj.modelArray(type: SSOutMoneyModel.self) as? [SSOutMoneyModel]
                                    } else {
                                        self.listModels! += (arr.kj.modelArray(type: SSOutMoneyModel.self) as? [SSOutMoneyModel])!
                                    }
                                    self.isHiddenFooter(model: self.listModels as AnyObject)
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
    
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count < page*pageSize {
            self.mainTableView.mj_footer?.isHidden = true
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


extension SSMyCashOutListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSOutMoneyCell", for: indexPath) as! SSOutMoneyCell
        cell.detailModel = self.listModels![indexPath.row] as SSOutMoneyModel
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.listModels![indexPath.row] as SSOutMoneyModel
        return model.height
    }
    
}

extension SSMyCashOutListViewController : SSSearchViewDelegate {
    func searchDataWithKeyWord(key: String) {
        
    }

}
