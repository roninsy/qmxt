//
//  SSMessageViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/12.
//

import UIKit
import MBProgressHUD
/*
 消息类型：
  获得关注=subscribe
  取消关注=un_subscribe
  发布=content_publish
  加入学习=join_learning
  购买-普通付费=content_buy
  获得现金=cash_received
  获得点赞=like
  获得收藏=favorite
  收礼=gift_received
  获得评论=comment
  获得回复=reply
  VIP年卡会员到期=vip_expiration
  内容被删除=content_deletion
  被禁言=banned_talking
  被封号=account_block
  系统通知=system
  
*/
 
enum msgType : String {
    case gift_received = "gift_received" //收礼通知
    case vip_expiration = "vip_expiration" //VIP年卡会员到期通知
    case comment = "comment" //评论通知
    case content_buy = "content_buy" //购买付费课程通知
    case un_subscribe = "un_subscribe" //取消关注通知
    case subscribe = "subscribe" //获得关注
    case content_publish = "content_publish" //发布
    case like = "like" //获得点赞
    case favorite = "favorite" //获得收藏
    case reply = "reply" //获得回复
    case join_learning = "join_learning" //用户加入方案学习通知
    case cash_received = "cash_received" //获得现金通知
    case content_deletion = "content_deletion" //内容被删除
    case banned_talking = "banned_talking" //被禁言
    case account_block = "account_block" //被封号
    case system = "system" //系统通知
}


class SSMessageViewController: SSBaseViewController {

    let searchView = SSSearchView.init()
    let mainTableView = UITableView.init()
    var page = 1
    let pageSize = 10
    
    var totalNum = 0
    
    var clickModel:SSBillSelectModel? = nil
    var searchKey:String = ""
    var bUp:Bool = false
    
    ///筛选视图
    let selectView = SSMsgSelectView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
    
    let timeLabel = UILabel.initSomeThing(title: "2020-08-21至2020-10-21", fontSize: 16, titleColor: .init(hex: "#333333"))
    let timeView = UIView.init()
    
    var messageModels:[SSMessageModel]? = nil {
        didSet{
            if messageModels != nil {
                if messageModels!.count > 0 {
                    mainTableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page = 1
        self.messageModels?.removeAll()
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ishideBar = true
        navView.backBtnWithTitle(title: "我的消息")
        self.view.backgroundColor = .white
        searchView.searchTextField.placeholder = "礼物"
        // Do any additional setup after loading the view.
        mainTableView.backgroundColor = .init(hex: "#F7F8F9")
        mainTableView.register(SSUnLikeMessageCell.self, forCellReuseIdentifier: "SSUnLikeMessageCell")
        mainTableView.register(SSMessageCell.self, forCellReuseIdentifier: "SSMessageCell")
        mainTableView.register(SSBuyMessageCell.self, forCellReuseIdentifier: "SSBuyMessageCell")
        mainTableView.register(SSGiftMessageCell.self, forCellReuseIdentifier: "SSGiftMessageCell")
        mainTableView.register(SSCollectionMessageCell.self, forCellReuseIdentifier: "SSCollectionMessageCell")
        mainTableView.register(SSVipOuttimeMessageCell.self, forCellReuseIdentifier: "SSVipOuttimeMessageCell")
        mainTableView.register(SSDeleteMessageCell.self, forCellReuseIdentifier: "SSDeleteMessageCell")
        mainTableView.register(SSCompMessageCell.self, forCellReuseIdentifier: "SSCompMessageCell")
        mainTableView.register(SSReplayMessageCell.self, forCellReuseIdentifier: "SSReplayMessageCell")
        mainTableView.register(SSJoinMessageCell.self, forCellReuseIdentifier: "SSJoinMessageCell")
        mainTableView.register(SSCrashMessageCell.self, forCellReuseIdentifier: "SSCrashMessageCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData()
        })
        self.buildUI()
    }
    
    
//    func loadSelectData() -> Void {
//        UserInfoNetworkProvider.request(.messageList(page: <#T##Int#>, size: <#T##Int#>), completion: <#T##Completion##Completion##(Result<Response, MoyaError>) -> Void#>)
//    }
    
    func loadData() -> Void {
        
        UserInfoNetworkProvider.request(.messageList(noticeType: self.clickModel?.type ?? "", pageSize: self.pageSize, number: self.page, publishedTimeAsc: self.bUp, titleKeyword: self.searchKey)) { (result) in
            self.mainTableView.mj_footer?.endRefreshing()
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                let arr = dic?["content"] as? NSArray
                                let total = dic?["totalElements"] as? String ?? "0"
                                self.totalNum = total.toInt ?? 0
                                if arr == nil || (arr?.count ?? 0 == 0){
                                    self.mainTableView.mj_footer?.endRefreshingWithNoMoreData()
                                    self.messageModels?.removeAll()
                                    self.page = 1
                                    self.mainTableView.reloadData()
                                    return
                                }
    
                                if self.page == 1 {
                                    self.messageModels = arr?.kj.modelArray(type: SSMessageModel.self)
                                        as? [SSMessageModel]
                                } else {
                                    let models = arr?.kj.modelArray(type: SSMessageModel.self)
                                        as? [SSMessageModel]
                                    self.messageModels = self.messageModels! + (models ?? [])
                                    
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
    
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count < page*pageSize {
            self.mainTableView.mj_footer?.isHidden = true
        }
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
        
        let noteLabel = UILabel.initSomeThing(title: "通知", titleColor: .init(hex: "#FD8024"), font: .SemiboldFont(size: 18), ali: .center)
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
            self.selectView.isHidden.toggle()
        }
        
        let label = UILabel.initSomeThing(title: "筛选", fontSize: 14, titleColor: .init(hex: "#999999"))
        topView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.equalTo(selBtn.snp.left).offset(-4)
            make.centerY.equalTo(selBtn)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
//        timeView.backgroundColor = .init(hex: "#F7F8F9")
//        timeView.isHidden = true
//        self.view.addSubview(timeView)
//        timeView.snp.makeConstraints { (make) in
//            make.top.equalTo(topView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(60)
//        }
//
//        timeView.addSubview(timeLabel)
//        timeLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(10)
//            make.height.equalTo(22)
//        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        selectView.clickOKBlock = {bUp, bDown, modex in
            self.bUp = bUp
            self.clickModel = modex
            self.messageModels?.removeAll()
            self.page = 1
            self.loadData()
        }
        self.view.addSubview(selectView)
        selectView.isHidden = true
    }


}

extension SSMessageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.messageModels![indexPath.row]
        return model.height ?? 0
        
//        switch model.type{
//            case "gift_received":
//                return screenWid/414*410+12
//            case "vip_expiration":
//                return screenWid/414*270+12
//            case "comment":
//                return screenWid/414*340+12
//            case "content_buy":
//                return screenWid/414*450+12
//            case "un_subscribe":
//                return screenWid/414*230+12
//            case "subscribe":
//                return screenWid/414*230+12
//            case "content_publish","join_learning":
//                return screenWid/414*420+12
//            case "like","favorite":
//                return screenWid/414*340+12
//            case "reply":
//                return screenWid/414*340+12
//            case "cash_received":
//                return screenWid/414*448+12
//            case "content_deletion","banned_talking","account_block": //内容被删除 /被禁言 /被封号
//                return screenWid/414*340+12
//            case "system": //系统通知
//                return screenWid/414*340+12
//            default:
//                return screenWid/414*400+12
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = self.messageModels?.count ?? 0
        if num >= self.totalNum {
            self.mainTableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.messageModels![indexPath.row]
        switch model.type {
            case "gift_received": //收礼通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSGiftMessageCell", for: indexPath) as! SSGiftMessageCell
                cell.selectionStyle = .none
                cell.model = model
                return cell
            case "vip_expiration": //VIP年卡会员到期通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSVipOuttimeMessageCell", for: indexPath) as! SSVipOuttimeMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
            case "comment","reply": //评论通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSReplayMessageCell", for: indexPath) as! SSReplayMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
            case "content_buy": //购买付费课程通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSBuyMessageCell", for: indexPath) as! SSBuyMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
            case "un_subscribe": //取消关注通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSUnLikeMessageCell", for: indexPath) as! SSUnLikeMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
            case "subscribe": //获得关注
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSMessageCell", for: indexPath) as! SSMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
            case "content_publish","join_learning": //发布 SSJoinMessageCell 用户加入方案学习通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSJoinMessageCell", for: indexPath) as! SSJoinMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell

            case "like","favorite": //获得点赞 /获得收藏 SSCollectionMessageCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSCollectionMessageCell", for: indexPath) as! SSCollectionMessageCell
                if model.type == "like" {
                    cell.title.text = "点赞通知："
                    cell.outher.text = "点赞者："
                }else{
                    cell.title.text = "收藏通知："
                    cell.outher.text = "收藏者："
                }
                cell.model = model
                cell.selectionStyle = .none
                return cell
            case "cash_received": //获得现金通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSCrashMessageCell", for: indexPath) as! SSCrashMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
                
            case "content_deletion","banned_talking","account_block": //内容被删除 /被禁言 /被封号
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSDeleteMessageCell", for: indexPath) as! SSDeleteMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
                
            case "system": //系统通知
                let cell = tableView.dequeueReusableCell(withIdentifier: "SSCompMessageCell", for: indexPath) as! SSCompMessageCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
                 
            default:
                break
                
        }
        return UITableViewCell.init()
    }
    
    
}

extension SSMessageViewController : SSSearchViewDelegate {
    func searchDataWithKeyWord(key: String) {
        self.searchKey = key
        self.loadData()
    }
    
    
}
