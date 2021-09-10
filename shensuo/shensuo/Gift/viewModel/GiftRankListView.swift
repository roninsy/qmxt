//
//  GiftRankListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/29.
//

import UIKit

class GiftRankListView: UIView {
    var titleText = ""{
        didSet{
            self.navTitleView.titleLab.text = titleText
        }
    }
    
    var isSelf = false{
        didSet{
            if isSelf {
                self.botUserView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                botUserView.isHidden = true
            }else{
                listHeadView.frame = .init(x: 0, y: 0, width: screenWid, height: 190)
                topCellArr[0].snp.updateConstraints { make in
                    make.height.equalTo(160)
                }
                topCellArr[1].snp.updateConstraints { make in
                    make.height.equalTo(150)
                }
                topCellArr[2].snp.updateConstraints { make in
                    make.height.equalTo(150)
                }
            }
        }
    }
    
    let botUserView = GiftRankListViewBotView()
    
    var gifts: [GiftUserModel] = NSMutableArray() as! [GiftUserModel]
    
    let noDataView = UIView()
    
    var rankModels : GiftRankModel? = nil{
        didSet{
            if rankModels != nil{
                giftNumsLab.text = String.init(format: "%d", rankModels?.totalGifts ?? 0)
                personNumLab.text = String.init(format: "%d", rankModels?.totalPeople ?? 0)
                let num = (rankModels?.gifts?.content?.count ?? 0)
                if num > 0 || isSelf {
                    self.noDataView.isHidden = true
                }
                
                if page == 1 {
                    for i in 0...2 {
                        if num > i{
                            let model = rankModels!.gifts!.content![i]
                            topCellArr[i].model = model
                        }
                    }
                    gifts.removeAll()
                    if num > 3{
                        var arr = rankModels!.gifts!.content!
                        arr.removeFirst()
                        arr.removeFirst()
                        arr.removeFirst()
                        self.gifts = arr
                    }
                }else{
                    if num > 0{
                        let arr = rankModels!.gifts!.content!
                        let arr2 = NSMutableArray.init(array: gifts)
                        arr2.addObjects(from: arr)
                        gifts = arr2 as! [GiftUserModel]
                        
                    }
                }
                if (rankModels!.gifts!.totalElements ?? 0) <= ((rankModels!.gifts!.pageSize ?? 0) * (rankModels!.gifts!.number ?? 0)) {
//                    if self.gifts.count > 3 {
                        self.listView.mj_footer?.endRefreshingWithNoMoreData()
//                    }
                }
                self.listView.reloadData()
            }
        }
    }
    
    var mainId : String = ""
    var type : Int = 1
    var userId : String = ""
    var page = 1
    ///顶部导航
    let navTitleView = CourseTitleView()
    
    let topCellWid = 120.0
    let topNumView = UIView()
    
    let giftNumsLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#FD8024"), font: .MediumFont(size: 12), ali: .left)
    let personNumLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#FD8024"), font: .MediumFont(size: 12), ali: .left)
    
    let topCellArr = [GiftTop3Cell(),GiftTop3Cell(),GiftTop3Cell()]
    let listHeadView = UIView()
    let listView = UITableView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .init(hex: "#F7F8F9")
        
        navTitleView.moreBtn.isHidden = true
        navTitleView.titleLab.text = "礼物榜"
        self.addSubview(navTitleView)
        navTitleView.snp.makeConstraints { make in
            make.height.equalTo(60 + NavStatusHei)
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
        }
        
        self.addSubview(botUserView)
        botUserView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(72)
            make.bottom.equalTo(0)
        }
        botUserView.enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.showSendGiftView()
        }
        
        self.setupTopNumView()
        self.setupListHeadView()
        listView.showsVerticalScrollIndicator = false
        listView.backgroundColor = .clear
        listView.separatorStyle = .none
        listView.delegate = self
        listView.dataSource = self
        listView.tableHeaderView = listHeadView
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(botUserView.snp.top)
            make.top.equalTo(navTitleView.snp.bottom).offset(55)
        }
        
        listView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.getNetInfo()
        })
        
        self.bringSubviewToFront(botUserView)
        
        noDataView.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(noDataView)
        noDataView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(navTitleView.snp.bottom)
        }
        
        let cell = SSPersonGiftEmptyCell()
        cell.contentView.removeFromSuperview()
        noDataView.addSubview(cell.contentView)
        cell.icon.snp.updateConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(146)
        }
        cell.sendGiftBtn.snp.updateConstraints { make in
            make.width.equalTo(screenWid - 57 * 2)
            make.height.equalTo(50)
        }
        cell.sendGiftBtn.setTitleColor(.white, for: .normal)
        cell.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cell.sendGiftBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.showSendGiftView()
        }
        noDataView.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTopNumView(){
        let layerView = UIView()
        layerView.frame = CGRect(x: -15, y: 0, width: 215, height: 30)
        // shadowCode
        layerView.layer.shadowColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.3).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        layerView.layer.shadowOpacity = 0.3
        layerView.layer.shadowRadius = 4
        // layerFillCode
        let layer = CALayer()
        layer.frame = layerView.bounds
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layerView.layer.addSublayer(layer)
        layerView.layer.cornerRadius = 15
        layerView.layer.masksToBounds = true
        topNumView.addSubview(layerView)
        self.addSubview(topNumView)
        topNumView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(navTitleView.snp.bottom).offset(15)
        }
        
        let tip1 = UILabel.initSomeThing(title: "礼物总数：", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 10), ali: .left)
        tip1.sizeToFit()
        topNumView.addSubview(tip1)
        tip1.snp.makeConstraints { make in
            make.top.equalTo(8.5)
            make.left.equalTo(10)
        }
        
        topNumView.addSubview(giftNumsLab)
        giftNumsLab.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerY.equalTo(tip1)
            make.width.equalTo(40)
            make.left.equalTo(tip1.snp.right)
        }
        
        let tip2 = UILabel.initSomeThing(title: "送礼人数：", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 10), ali: .left)
        tip2.sizeToFit()
        topNumView.addSubview(tip2)
        tip2.snp.makeConstraints { make in
            make.top.equalTo(8.5)
            make.left.equalTo(giftNumsLab.snp.right)
        }
        
        topNumView.addSubview(personNumLab)
        personNumLab.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerY.equalTo(tip2)
            make.width.equalTo(40)
            make.left.equalTo(tip2.snp.right)
        }
    }
    
    func setupListHeadView(){
        listHeadView.frame = .init(x: 0, y: 0, width: screenWid, height: 220)
        
        let cellSpace = (Double(screenWid) - topCellWid * 3) / 54.0
        
        topCellArr[1].isSelf = userId == UserInfo.getSharedInstance().userId
        topCellArr[1].rankNum = 2
        listHeadView.addSubview(topCellArr[1])
        topCellArr[1].snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.width.equalTo(topCellWid)
            make.left.equalTo(cellSpace * 20)
            make.height.equalTo(190)
        }
        
        topCellArr[1].touchBlock = { str in
            let arr = str.split(separator: "-")
            let uid = String(arr[0])
            let x = Double(arr[1]) ?? 0
            let y = Double(arr[2]) ?? 0
            self.getUserStand(uid: uid,x: x,y: y)
        }
        
        topCellArr[0].isSelf = userId == UserInfo.getSharedInstance().userId
        topCellArr[0].rankNum = 1
        listHeadView.addSubview(topCellArr[0])
        topCellArr[0].snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.width.equalTo(topCellWid)
            make.left.equalTo(topCellArr[1].snp.right).offset(cellSpace * 7)
            make.height.equalTo(200)
        }
        topCellArr[0].touchBlock = { str in
            let arr = str.split(separator: "-")
            let uid = String(arr[0])
            let x = Double(arr[1]) ?? 0
            let y = Double(arr[2]) ?? 0
            self.getUserStand(uid: uid,x: x,y: y)
        }
        
        topCellArr[2].isSelf = userId == UserInfo.getSharedInstance().userId
        topCellArr[2].rankNum = 3
        listHeadView.addSubview(topCellArr[2])
        topCellArr[2].snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.width.equalTo(topCellWid)
            make.left.equalTo(topCellArr[0].snp.right).offset(cellSpace * 7)
            make.height.equalTo(190)
        }
        topCellArr[2].touchBlock = { str in
            let arr = str.split(separator: "-")
            let uid = String(arr[0])
            let x = Double(arr[1]) ?? 0
            let y = Double(arr[2]) ?? 0
            self.getUserStand(uid: uid,x: x,y: y)
        }
    }
    
    ///获取礼物排行榜
    func getNetInfo() {
        GiftNetworkProvider.request(.giftRanking(source: mainId, type: "\(type)", number: page, pageSize: 10)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.rankModels = model!.data!.kj.model(type: GiftRankModel.self) as? GiftRankModel
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
    
    ///获取礼物排行榜
    func getUserRanking() {
        GiftNetworkProvider.request(.userRanking(source: mainId, type: "\(type)")) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                let model = model!.data!.kj.model(type: GiftUserModel.self) as? GiftUserModel
                                self.botUserView.model = model
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
    
    ///获取个人礼物
    func getUserStand(uid:String,x:Double,y:Double) {
//        let sendedView = GiftSendedListView()
//        sendedView.uid = uid
//        sendedView.sid = mainId
//        sendedView.sanJiaoX = x
//        sendedView.getNetInfo()
//        self.addSubview(sendedView)
//        sendedView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(225)
//            make.top.equalTo(y)
//        }
        
    }
    
    ///显示发送礼物界面
    func showSendGiftView(){
        
        // 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节 8：个人收礼
        var content_type = ""
        if self.type == 1 || self.type == 2{
            content_type = "课程"
        }else if self.type == 6 || self.type == 7{
            content_type = "方案"
        }else if self.type == 4{
            content_type = "美丽日记"
        }else if self.type == 5{
            content_type = "美丽相册"
        }else if self.type == 8{
            content_type = "个人主页礼物间"
        }else if self.type == 3{
            content_type = "动态"
        }
        ///上报事件
        HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":content_type,
                                                          "content_id":""])
        
        let giftView = GiftListView()
        giftView.sid = mainId
        giftView.uid = userId
        giftView.type = type
        giftView.sendGiftBlock = {[weak self] in
            ///送礼回调，刷新数据
            self?.page = 1
            self?.getNetInfo()
            self?.getUserRanking()
        }
        HQGetTopVC()?.view.addSubview(giftView)
        giftView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension GiftRankListView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : GiftRankListViewCell? = tableView.dequeueReusableCell(withIdentifier: "GiftRankListViewCell") as? GiftRankListViewCell
        if cell == nil{
            cell = GiftRankListViewCell.init(style: .default, reuseIdentifier: "GiftRankListViewCell")
            cell?.needSend = self.isSelf
        }
        cell?.model = gifts[indexPath.row]
        cell?.rankLab.text = "\(indexPath.row + 4)"
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = gifts[indexPath.row]
        self.getUserStand(uid: model.id ?? "0",x: 0,y: 0)
    }
}
