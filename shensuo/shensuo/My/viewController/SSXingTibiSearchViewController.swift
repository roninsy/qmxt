//
//  SSXingTibiSearchViewController.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/9/3.
//

import UIKit

class SSXingTibiSearchViewController: SSBaseViewController, SSSearchViewDelegate {
    
    
    let mainTableView = UITableView.init()
    
    let searchView = SSSearchView.init()
    var page = 1
    let pageNumber = 10
    
    var detailModes:[SSBillDetailModel]? = nil{
        didSet{
            if detailModes != nil {
                mainTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
        navView.backBtnWithTitle(title: "形体贝明细搜索")
        
        mainTableView.isHidden = true
        
        self.view.addSubview(searchView)
        searchView.delegate = self
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(NavBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(searchViewHeight)
        }
        // Do any additional setup after loading the view.
        
        self.view.addSubview(mainTableView)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(SSAccountBillDetailCell.self, forCellReuseIdentifier: "SSAccountBillDetailCell")
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    

    func searchDataWithKeyWord(key: String) {
        self.loadData(key: key)
    }
    
    func loadData(key:String) -> Void {
        var dataDict = Dictionary<String, String>()
        dataDict.updateValue("", forKey: "categoryId")
        dataDict.updateValue("", forKey: "createdTimeMax")
        dataDict.updateValue("", forKey: "createdTimeMini")
        dataDict.updateValue(key, forKey: "keyWords")
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
                                let total = dic?["totalElements"] as! String
                                if (total.toInt ?? 0) > 0 {
                                    self.mainTableView.isHidden = false
                                    let arr = dic?["content"] as! NSArray
                                    if self.page == 1 {
                                        self.detailModes = arr.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel]
                                    } else {
                                        self.detailModes! += (arr.kj.modelArray(type: SSBillDetailModel.self) as? [SSBillDetailModel])!
                                    }
                                    self.isHiddenFooter(model: self.detailModes as AnyObject)
                                }
                                
                             
                            }else{
                                self.mainTableView.mj_footer?.isHidden = true
                                HQShowNoDataView(parentView: self.view, imageName: "my_nosc", tips: "暂无明细")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSXingTibiSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.detailModes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSAccountBillDetailCell", for: indexPath) as! SSAccountBillDetailCell
        cell.iconStr = "形体贝"
        cell.detailModel = self.detailModes?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }


}

