//
//  SSPersonGiftController.swift
//  shensuo
//
//  Created by  yang on 2021/6/29.
//

import UIKit
import SnapKit
import JXPagingView
import Toast_Swift
import MJRefresh

class SSPersonGiftController: UITableViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var rankModels : GiftRankModel?
    var giftArr: [GiftUserModel]?
    var userInfoModel: SSUserInfoModel?
    var cellCount: Int = 5
    var giftSetting​s: [SSGiftSettingModel]?
    var oneself: Bool = false
    var lockBtnBlcok: voidBlock? = nil
    var giftEmptyView: SSCommonGiftEmptyView?
    //房间查看权限
    var roomOnlySelf: Bool = false{
        didSet{
            if roomOnlySelf == true {
                botUserView.isHidden = true
            }
        }
    }
    //礼物榜查看权限
    var rankOnlySelf: Bool = false{
        didSet{
            if rankOnlySelf == true {
                botUserView.isHidden = true
            }
        }
    }
    //礼物架查看权限
    var standOnlySelf: Bool = false
    
    let botUserView = GiftRankListViewBotView()
    
    var cid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.botUserView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.botUserView.isHidden = true
    }
    var currentUserModel: GiftUserModel?
    var isFromMyVC: Bool = false
    
    func buildUI()  {
        
        tableView?.dataSource = self
        tableView?.register(SSPersonGIftTopCellCell.self, forCellReuseIdentifier: String(describing: SSPersonGIftTopCellCell.self))
        tableView?.register(SSPersonGIftTitleCellCell.self, forCellReuseIdentifier: String(describing: SSPersonGIftTitleCellCell.self))
        tableView?.register(SSPersonGiftStandCell.self, forCellReuseIdentifier: String(describing: SSPersonGiftStandCell.self))
        tableView?.register(SSPersonPersongGiftRankTop3Cell.self, forCellReuseIdentifier: String(describing: SSPersonPersongGiftRankTop3Cell.self))
        tableView?.register(SSPersonGiftEmptyCell.self, forCellReuseIdentifier: String(describing: SSPersonGiftEmptyCell.self))
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        
        if cid == "" || cid == UserInfo.getSharedInstance().userId {
            loadRoomSetting()
        }else{
            self.loadGiftRankingData()
            self.getNetInfo()
            self.getRoomInfo()
            self.getUserRanking()
            HQGetTopVC()?.view.addSubview(botUserView)
            botUserView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(72)
                make.bottom.equalTo(0)
            }
            botUserView.enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                self.showSendGiftView()
            }
            let botView = UIView.init(frame: .init(x: 0, y: 0, width: screenWid, height: 72))
            self.tableView.tableFooterView = botView
        }
        
    }
    
    ///显示发送礼物界面
    func showSendGiftView(){

        // 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节 8：个人收礼
        let content_type = "个人主页礼物间"
    
        ///上报事件
        HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":content_type,
                                                          "content_id":""])
        
        let giftView = GiftListView()
        giftView.sid = ""
        giftView.uid = cid
        giftView.type = 8
        giftView.sendGiftBlock = { [weak self] in
            
            self?.getUserRanking()
        }
        HQGetTopVC()?.view.addSubview(giftView)
        giftView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !oneself && self.roomOnlySelf{
            return 1
        }
        return cellCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            if !oneself && self.roomOnlySelf{
                var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftOnlyOwerCell.self))
                if cell == nil {
                    
                    cell = SSPersonGiftOnlyOwerCell.init(style: .default, reuseIdentifier: String(describing: SSPersonGiftOnlyOwerCell.self))
                }
                return cell!
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGIftTopCellCell.self)) as! SSPersonGIftTopCellCell
            cell.lockBtn.isHidden = !oneself
            cell.lockImage.isHidden = !(oneself == true && roomOnlySelf == true)
            cell.lockBtn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] btn in
                
                self?.showActionWithTitle(oneStr: self?.roomOnlySelf == false ? "仅自己可见礼物间" : "所有人可见礼物间",
                                          oneHandle: { action in
                                            
                                            self!.loadUserGiftSettingData(name: (self?.giftSetting​s![0].name)!,index: 0)
                                            
                                          })
                
            }
            if cell.rankModel == nil {
                cell.rankModel = self.rankModels
                cell.selectionStyle = .none
            }
            return cell
        }else if(indexPath.row == 1 || indexPath.row == 3 ){
            
            let cell: SSPersonGIftTitleCellCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGIftTitleCellCell.self))! as! SSPersonGIftTitleCellCell
            cell.selectionStyle = .none
            cell.titleL.text = indexPath.row == 1 ? "礼物架" : "礼物榜"
            cell.subTitleL.text = indexPath.row == 1 ? "" : "查看榜单"
            cell.subTitleL.isHidden = roomOnlySelf == true || rankOnlySelf == true
            cell.arrowIcon.isHidden = indexPath.row == 1 || roomOnlySelf == true || rankOnlySelf == true
            
            cell.lockIocn.isUserInteractionEnabled = true
            if indexPath.row == 1 {
                cell.lockIocn.setImage(.init(named: self.standOnlySelf == false ? "my_gift_canlook" : "my_gift_dontlook"), for: .normal)
            }else{
                cell.lockIocn.setImage(.init(named: self.rankOnlySelf == false ? "my_gift_canlook" : "my_gift_dontlook"), for: .normal)
            }
            cell.lockIocn.tag = indexPath.row
            cell.lockIocn.isHidden = !oneself
            cell.lockIocn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                if btn.tag == 1{
                    self.showActionWithTitle(oneStr: self.standOnlySelf == false ? "仅自己可见礼物架" : "所有人可见礼物架",
                                              oneHandle: { action in
                                                
                                                self.loadUserGiftSettingData(name: self.giftSetting​s?[1].name ?? "", index: 1)
                                                
                                              })
                    
                }else{
                    self.showActionWithTitle(oneStr: self.rankOnlySelf == false ? "仅自己可见礼物榜" : "所有人可见礼物榜",
                                              oneHandle: { action in
                                                
                                                self.loadUserGiftSettingData(name: self.giftSetting​s?[2].name ?? "", index: 2)
                                                
                                              })
                }
            }
            return cell
        }else if(indexPath.row == 2){
            
            if !oneself && self.standOnlySelf{
                
                var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftOnlyOwerCell.self))
                if cell == nil {
                    
                    cell = SSPersonGiftOnlyOwerCell.init(style: .default, reuseIdentifier: String(describing: SSPersonGiftOnlyOwerCell.self))
                }
                return cell!
            }
            
            let cell: SSPersonGiftStandCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftStandCell.self))! as! SSPersonGiftStandCell
            cell.giftArr = self.giftArr
            
            if !oneself {
                
                if (self.giftSetting​s != nil && self.giftSetting​s![1].value == "2" && self.giftArr?.count ?? 0 > 0) {
                    
                    cell.emptyV.isHidden = true
                    
                }else{
                    
                    cell.emptyV.isHidden = false
                }
            }else{
                if self.rankModels?.gifts != nil && (self.rankModels?.gifts?.content?.count ?? 0) > 0  {
                    
                    cell.emptyV.isHidden = true
                    
                }else{
                    
                    cell.emptyV.isHidden = false
                    
                }
            }
            //            cell.emptyV.isHidden = (!oneself && (self.giftSetting​s != nil && self.giftSetting​s![1].value == "2"))
            cell.selectionStyle = .none
            return cell
        }else if(indexPath.row == 4){
            
            if !oneself && self.rankOnlySelf{
                
                var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftOnlyOwerCell.self))
                if cell == nil {
                    
                    cell = SSPersonGiftOnlyOwerCell.init(style: .default, reuseIdentifier: String(describing: SSPersonGiftOnlyOwerCell.self))
                }
                return cell!
            }
            if !oneself && rankOnlySelf {
                
                let cell: SSPersonGiftEmptyCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftEmptyCell.self))! as! SSPersonGiftEmptyCell
                return cell
            }
            
            let cell: SSPersonPersongGiftRankTop3Cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonPersongGiftRankTop3Cell.self))! as! SSPersonPersongGiftRankTop3Cell
            cell.userId = cid
            cell.giftArr = self.rankModels?.gifts?.content
            cell.backgroundColor = bgColor
            cell.selectionStyle = .none
            return cell
        }else if(cellCount > 5 && (indexPath.row == cellCount - 1) && oneself){
            
            var cell : GiftRankListViewCell? = tableView.dequeueReusableCell(withIdentifier: "GiftRankListViewCell") as? GiftRankListViewCell
            if cell == nil{
                cell = GiftRankListViewCell.init(style: .default, reuseIdentifier: "GiftRankListViewCell")
                
                cell?.needSend = self.oneself
            }
            //        cell?.model = gifts[indexPath.row]
            cell?.selectionStyle = .none
            cell?.rankLab.text = "\(indexPath.row - 1)"
            
            return cell!
        }
        var cell : GiftRankListViewCell? = tableView.dequeueReusableCell(withIdentifier: "GiftRankListViewCell") as? GiftRankListViewCell
        if cell == nil{
            cell = GiftRankListViewCell.init(style: .default, reuseIdentifier: "GiftRankListViewCell")
            
            cell?.needSend = self.oneself
        }

        let ind = indexPath.row - 2
        if (self.rankModels?.gifts?.content?.count ?? 0) > ind {
            cell?.model = self.rankModels?.gifts?.content?[ind]
        }
        
        cell?.selectionStyle = .none
        cell?.rankLab.text = "\(indexPath.row - 1)"
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !oneself && self.roomOnlySelf{
            return 380
        }
        if indexPath.row == 1 || indexPath.row == 3 {
            
            return 48
        }else if(indexPath.row == 2){
            
            return  252
            
        }else if(indexPath.row == 4){
            if !oneself && rankOnlySelf{
                
                return 380
            }
            return 224
        }else if(indexPath.row == 0){
            
            return 152
        }
        return 92
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            
            if indexPath.row == 3 && (roomOnlySelf == false && rankOnlySelf == false){
                
                let vc = GiftRankVC()
                vc.mainView.mainId = cid
                vc.mainView.type = 8
                vc.mainView.userId = cid
                vc.mainView.isSelf = self.oneself
                vc.mainView.titleText = "礼物榜"
                HQPush(vc: vc, style: .default)
            }
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.listViewDidScrollCallback!(scrollView)
        
    }
    
    
}

extension SSPersonGiftController{
    
    func loadGiftRankingData() {
        
        ///获取礼物排行榜
        GiftNetworkProvider.request(.giftRanking(source: cid, type: "8", number: 1, pageSize: 10)) { result in
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
                                
                                if self.rankModels != nil && self.rankModels?.gifts != nil && self.rankModels?.gifts?.content != nil {
                                    let totalCount = (self.rankModels?.gifts?.content!.count)!
                                    if self.oneself {
                                        
                                        for index in 0..<totalCount {
                                            
                                            let userModel = self.rankModels?.gifts?.content![index]
                                            if userModel?.id == UserInfo.getSharedInstance().userId {
                                                
                                                self.currentUserModel = userModel
                                            }
                                            
                                        }
                                    }
                                    
                                    if totalCount > 3 && totalCount < 6{
                                        
                                        self.cellCount = 5 + totalCount - 3
                                        
                                    }else if(totalCount <= 3 && totalCount > 0){
                                        
                                        self.cellCount = 5
                                    }
                                    else if(totalCount > 5){
                                        
                                        self.cellCount = 9
                                    }
                                    if (self.userInfoModel?.oneSelf == true) {
                                        
                                        self.cellCount = self.cellCount > 5 ? self.cellCount - 1 : self.cellCount
                                    }
                                    self.tableView.reloadData()
                                }
                                
                                
                            }
                        }else{
                            if model?.code == 2000 {
                                self.rankOnlySelf = true
                                self.tableView.reloadData()
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
    
    ///获取礼物排行榜
    func getUserRanking() {
        GiftNetworkProvider.request(.userRanking(source: cid, type: "8")) { result in
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
                        }
                    }
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    ///礼物间信息
    func getRoomInfo() {
        UserInfoNetworkProvider.request(.myGift(userId:cid)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            
                            self.rankModels = model?.data?.kj.model(GiftRankModel.self)
                            self.tableView.reloadData()
                        }else if model?.code == 2000{
                            self.roomOnlySelf = true
                            self.tableView.reloadData()
                        }
                    }
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    func getNetInfo() {
        GiftNetworkProvider.request(.giftStand(userId:cid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            self.giftEmptyView?.isHidden = true
                            if model?.data != nil{
                                self.giftArr = model!.data!.kj.modelArray(GiftUserModel.self)
                                self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
                            }
                        }else{
                            if model?.code == 2000{
                                self.standOnlySelf = true
                                self.tableView.reloadData()
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
    
    func loadRoomSetting()  {
        
        UserInfoNetworkProvider.request(.giftSetting) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.giftSetting​s = model!.data!.kj.modelArray(SSGiftSettingModel.self)
                                if self.giftSetting​s?.count ?? 0 > 0 {
                                    
                                    self.roomOnlySelf = self.giftSetting​s![0].value == "1" ? true : false
                                    self.standOnlySelf = self.giftSetting​s![1].value == "1" ? true : false
                                    self.rankOnlySelf = self.giftSetting​s![2].value == "1" ? true : false
                                    
                                    if self.rankOnlySelf && !self.oneself{
                                        
                                        self.giftEmptyView = SSCommonGiftEmptyView()
                                        self.view.insertSubview(self.giftEmptyView!, at: 99)
                                        self.giftEmptyView?.snp.makeConstraints({ make in
                                            
                                            make.top.equalToSuperview()
                                            make.height.equalTo(400)
                                            make.width.equalTo(screenWid)
                                            make.leading.equalToSuperview()
                                            
                                        })
                                        self.giftEmptyView?.backgroundColor = .white
                                        self.giftEmptyView?.isHidden = false
                                        self.tableView.isScrollEnabled = false
                                        
                                        
                                        
                                    }
                                    else{
                                        self.tableView.isHidden = false
                                        self.giftEmptyView?.isHidden = true
                                        self.tableView.isScrollEnabled = true
                                        self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0),IndexPath.init(row: 3, section: 0)], with: .none)
                                    }
                                }
                                
                                
                            }
                            self.loadGiftRankingData()
                            self.getNetInfo()
                            self.getRoomInfo()
                            
                            
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
    
    func loadUserGiftSettingData(name: String,index: Int) {
        
        UserInfoNetworkProvider.request(.giftAddUserSetting(name: name)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                HQGetTopVC()?.view.makeToast("修改成功")
                            }
                            if model?.data != nil{
                                self.giftSetting​s?[index] = model!.data!.kj.model(SSGiftSettingModel.self) ?? SSGiftSettingModel()
                                if self.giftSetting​s?.count ?? 0 > 0 {
                                    self.roomOnlySelf = self.giftSetting​s![0].value == "1" ? true : false
                                    self.standOnlySelf = self.giftSetting​s![1].value == "1" ? true : false
                                    self.rankOnlySelf = self.giftSetting​s![2].value == "1" ? true : false
                                    
                                    if self.rankOnlySelf && !self.oneself{
                                        
                                        self.giftEmptyView = SSCommonGiftEmptyView()
                                        self.view.insertSubview(self.giftEmptyView!, at: 99)
                                        self.giftEmptyView?.snp.makeConstraints({ make in
                                            
                                            make.top.equalToSuperview()
                                            make.height.equalTo(400)
                                            make.width.equalTo(screenWid)
                                            make.leading.equalToSuperview()
                                            
                                        })
                                        self.giftEmptyView?.backgroundColor = .white
                                        self.giftEmptyView?.isHidden = false
                                        self.tableView.isScrollEnabled = false
                                        
                                    }else{
                                        self.tableView.isHidden = false
                                        self.giftEmptyView?.isHidden = true
                                        self.tableView.isScrollEnabled = true
                                        self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0),IndexPath.init(row: 3, section: 0)], with: .none)
                                    }
                                }
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
    
}

extension SSPersonGiftController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return view
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    public func listScrollView() -> UIScrollView {
        return self.tableView!
    }
    
}
