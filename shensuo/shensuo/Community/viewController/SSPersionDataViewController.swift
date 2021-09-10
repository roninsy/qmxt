//
//  SSPersionDataViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/12.
//

import UIKit
import JXPagingView

class DataHeadView: UIView {
    
    var userDataModel: SSUserDataModel? = nil{
        
        didSet{
            
            if userDataModel != nil {
                
                ZTSView.numLabel.text = userDataModel?.days
                ZFZView.numLabel.text = userDataModel?.minutesTotal
                ZXHView.numLabel.text = "\(userDataModel?.courseCalorieTotal ?? "0")千卡"
            }
        }
    }
    
    var ZFZView: ZHView = {
        let zfz = ZHView.init()
        return zfz
    }()
    
    var ZXHView : ZHView = {
        let zxh = ZHView.init()
        return zxh
    }()
    
    var ZTSView:ZHView = {
        let zts = ZHView.init()
        return zts
    }()
    
    var lineView : UIImageView = {
        let line = UIImageView.init()
        line.backgroundColor = UIColor.init(hex: "#CBCCCD")
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ZFZView)
        ZFZView.setNumWithTitle(title: "总分钟", num: "5000")
        addSubview(lineView)
        addSubview(ZXHView)
        ZXHView.setNumWithTitle(title: "总消耗", num: "800千卡")
        addSubview(ZTSView)
        ZTSView.setNumWithTitle(title: "总天数", num: "1000")

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ZFZView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(72)
        }
       
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(ZFZView.snp.bottom).offset(30)
            make.width.equalTo(1)
            make.height.equalTo(21)
        }
        
        
        ZXHView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineView)
            make.right.equalTo(lineView.snp.left)
            make.width.equalTo(screenWid / 2)
            make.height.equalTo(72)
        }
        
       
        ZTSView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineView)
            make.left.equalTo(lineView.snp.right).offset(58)
            make.width.equalTo(screenWid / 2)
            make.height.equalTo(72)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZHView: UIView {
    
    var numLabel: UILabel = {
        let num = UILabel.init()
        num.textAlignment = .center
        num.textColor = UIColor.init(hex: "#333333")
        num.font = UIFont.boldSystemFont(ofSize: 24)
        return num
    }()
    
    var titleLabel:UILabel = {
        let title = UILabel.init()
        title.textAlignment = .center
        title.textColor = UIColor.init(hex: "#666666")
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numLabel.adjustsFontSizeToFitWidth = true
        addSubview(numLabel)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        numLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    func setNumWithTitle(title: NSString, num: NSString) -> Void {
        numLabel.text = num as String
        titleLabel.text = title as String
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SSPersionDataViewController: UITableViewController {

    var headerHeight : CGFloat = 200
    var userId = ""
    var userModel: SSUserDataModel?
    var isOnsef = true
    
    var titleArray = [["课程数据","学习课程总数","完成课程","未完成课程","完成小节","未完成小节","总分钟","总消耗"],["方案数据","学习方案总数","完成方案","未完成方案","完成小节","未完成小节","总分钟","总消耗"],["内容数据","动态","美丽日记","美丽相册","获关总数","获赞总数","获评总数","获藏总数"],
        ["礼物数据","收礼件数","收礼价值","送礼件数","送礼价值"]
    ]
    var titleContentArray: Array<Any>?
    
//    var sectionTitle = ["课程数据","方案数据","内容数据","礼物数据"]
    let headerView : DataHeadView = {
        let headerView = DataHeadView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 200))
        return headerView
    }()
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView.init()
        tableView.separatorStyle = .none
        tableView.register(SSDataViewCell.self, forCellReuseIdentifier: "SSDataViewCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userId != UserInfo.getSharedInstance().userId && userId.count != 0{
            
            self.isOnsef = false
            titleArray = [["课程数据","学习课程总数","总分钟","总消耗"],["方案数据","学习方案总数","总分钟","总消耗"],["内容数据","动态","美丽日记","美丽相册"],
            ]
        }
        loadUserData()
        headerView.userDataModel = userModel
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 12))
        headView.backgroundColor = UIColor.init(hex: "#F7F8F9")
        return headView
    }
  
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section]
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabcell = tableView.dequeueReusableCell(withIdentifier: "SSDataViewCell") as! SSDataViewCell
        if indexPath.row == 0 {
            tabcell.titleLabel.font = UIFont.MediumFont(size: 18)
            tabcell.titleLabel.textColor = color33
            tabcell.numLabel.text = ""

        }else{
            
            tabcell.titleLabel.font = UIFont.MediumFont(size: 16)
            tabcell.titleLabel.textColor = UIColor.hex(hexString: "#878889")
            if self.titleContentArray?.count ?? 0 > 0 {
                
                let array = titleContentArray![indexPath.section] as! Array<Any>
                tabcell.numLabel.text = array[indexPath.row] as? String

            }else{
                
                tabcell.numLabel.text = "0"

            }
        }
        
        tabcell.titleLabel.text = titleArray[indexPath.section][indexPath.row]
        if indexPath.section == titleArray.count - 1 && (indexPath.row == 1 || indexPath.row == 3 ) && isOnsef == true {
            
            tabcell.icon.isHidden = false
        }else{
            
            tabcell.icon.isHidden = true

        }
        return tabcell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
            self.listViewDidScrollCallback!(scrollView)
        
    }
    
}

extension SSPersionDataViewController{
    
    func loadUserData() {
        
        UserInfoNetworkProvider.request(.getUserData(userId: userId)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                 
                                self.userModel = model?.data?.kj.model(type: SSUserDataModel.self) as? SSUserDataModel
//                                self.headerView.ZTSView.titleLabel.text = self.userModel?.days
                                self.headerView.userDataModel = self.userModel
                                
                                if self.isOnsef == false {
                                    self.titleContentArray = [
                                        ["",self.userModel?.courseTotal,self.userModel?.minutesTotal,"\(self.userModel?.courseCalorieTotal ?? "0")千卡"],
                                        ["",self.userModel?.planTotal,self.userModel?.planMinutesTotal,"\(self.userModel?.planCalorieTotal ?? "0")千卡"],
                                        ["",self.userModel?.noteTotal,self.userModel?.dailyRecordTotal,self.userModel?.albumTotal],
                                    ]
                                }else{
                                    
                                    
                                    self.titleContentArray = [
                                        ["",self.userModel?.courseTotal,self.userModel?.courseFinish,self.userModel?.unCourseFinish,self.userModel?.courseStepFinish,self.userModel?.unCourseStepFinish,self.userModel?.minutesTotal,"\(self.userModel?.courseCalorieTotal ?? "0")千卡"],
                                        ["",self.userModel?.planTotal,self.userModel?.planFinish,self.userModel?.unPlanFinish,self.userModel?.planStepFinish,self.userModel?.courseStepFinish,self.userModel?.planMinutesTotal,"\(self.userModel?.planCalorieTotal ?? "0")千卡"],
                                        ["",self.userModel?.noteTotal,self.userModel?.dailyRecordTotal,self.userModel?.albumTotal,self.userModel?.focusTotal,self.userModel?.likeTotal,self.userModel?.commentTotal,self.userModel?.collectTotal],
                                        ["",self.userModel?.planTotal,self.userModel?.receiveGiftTotal,self.userModel?.sendGiftTotal,self.userModel?.sengGiftPoints]
                                    ]
                                }
                                self.tableView.reloadData()
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
}

extension SSPersionDataViewController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}

