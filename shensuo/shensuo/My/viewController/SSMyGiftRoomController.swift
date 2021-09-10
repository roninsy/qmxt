//
//  SSMyGiftRoomController.swift
//  shensuo
//
//  Created by  yang on 2021/7/7.
//

import UIKit

class SSMyGiftRoomController: SSBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var rankModels : GiftRankModel?
    var giftArr: [GiftUserModel]?
    var rankModel: GiftRankModel?
    var cellCount: Int = 5
    var giftSetting​s: [SSGiftSettingModel]?
    var lockBtnBlcok: voidBlock? = nil
    var giftEmptyView: SSCommonGiftEmptyView?
    //房间查看权限
    var roomOnlySelf: Bool = false
    //礼物榜查看权限
    var rankOnlySelf: Bool = false
    //礼物架查看权限
    var standOnlySelf: Bool = false
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.backBtnWithTitle(title: "我的礼物间")
        buildUI()
        
    }
    
    var currentUserModel: GiftUserModel?
    
    func buildUI()  {
        
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navView.snp.bottom)
        }
        tableView?.dataSource = self
        tableView?.register(SSPersonGIftTopCellCell.self, forCellReuseIdentifier: String(describing: SSPersonGIftTopCellCell.self))
        tableView?.register(SSPersonGIftTitleCellCell.self, forCellReuseIdentifier: String(describing: SSPersonGIftTitleCellCell.self))
        tableView?.register(SSPersonGiftStandCell.self, forCellReuseIdentifier: String(describing: SSPersonGiftStandCell.self))
        tableView?.register(SSPersonPersongGiftRankTop3Cell.self, forCellReuseIdentifier: String(describing: SSPersonPersongGiftRankTop3Cell.self))
        tableView?.register(SSPersonGiftEmptyCell.self, forCellReuseIdentifier: String(describing: SSPersonGiftEmptyCell.self))
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        
        loadRoomSetting()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return cellCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGIftTopCellCell.self)) as! SSPersonGIftTopCellCell
            cell.lockBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
                
                self?.onMySelfAction(oneStr: "仅自己可见礼物间/所有人可见礼物间", secondStr: "仅自己可见礼物架/所有人可见礼物架",
                                     threeStr: "仅自己可见礼物榜/所有人可见礼物榜",
                                     shareStr: "分享",
                                     oneHandle: { action in
                                        
                                        self!.loadUserGiftSettingData(name: (self?.giftSetting​s![0].name)!)
                                        
                                     }, secondHandle: { action in
                                        if self?.giftSetting​s != nil{
                                            
                                            self!.loadUserGiftSettingData(name: (self?.giftSetting​s![1].name)!)
                                        }
                                     },threeHandle: { action in
                                        
                                        if self?.giftSetting​s != nil{
                                            
                                            self!.loadUserGiftSettingData(name: (self?.giftSetting​s![2].name)!)
                                        }
                                     },
                                     shareHandle: { action in
                                        let vc = ShareVC()
                                        vc.type = 3
                                        vc.giftModel = self?.rankModel ?? GiftRankModel()
                                        vc.setupMainView()
                                        HQPush(vc: vc, style: .lightContent)
                                        
                                     })
                
            })
            cell.rankModel = self.rankModel
            cell.selectionStyle = .none
            return cell
        }else if(indexPath.row == 1 || indexPath.row == 3 ){
            
            let cell: SSPersonGIftTitleCellCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGIftTitleCellCell.self))! as! SSPersonGIftTitleCellCell
            cell.selectionStyle = .none
            cell.titleL.text = indexPath.row == 1 ? "礼物架" : "礼物榜"
            cell.subTitleL.text = indexPath.row == 1 ? "" : "查看榜单"
            cell.arrowIcon.isHidden = indexPath.row == 1
            cell.lockIocn.isUserInteractionEnabled = true
            return cell
        }else if(indexPath.row == 2){
            
            
            let cell: SSPersonGiftStandCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftStandCell.self))! as! SSPersonGiftStandCell
            cell.giftArr = self.giftArr
            
            
            if self.rankModels?.gifts != nil && (self.rankModels?.gifts?.content?.count ?? 0) > 0  {
                
                cell.emptyV.isHidden = true
                
            }else{
                
                cell.emptyV.isHidden = false
                
            }
            cell.selectionStyle = .none
            return cell
        }else if(indexPath.row == 4){
            
            
            //            if !oneself && rankOnlySelf {
            //
            //                let cell: SSPersonGiftEmptyCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonGiftEmptyCell.self))! as! SSPersonGiftEmptyCell
            //                return cell
            //            }
            
            let cell: SSPersonPersongGiftRankTop3Cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSPersonPersongGiftRankTop3Cell.self))! as! SSPersonPersongGiftRankTop3Cell
            cell.userId = UserInfo.getSharedInstance().userId ?? ""
            cell.giftArr = self.rankModels?.gifts?.content
            cell.backgroundColor = bgColor
            cell.selectionStyle = .none
            return cell
        }else if(cellCount > 5 && (indexPath.row == cellCount - 1)){
            
            var cell : GiftRankListViewCell? = tableView.dequeueReusableCell(withIdentifier: "GiftRankListViewCell") as? GiftRankListViewCell
            if cell == nil{
                cell = GiftRankListViewCell.init(style: .default, reuseIdentifier: "GiftRankListViewCell")
                
                cell?.needSend = true
            }
            //        cell?.model = gifts[indexPath.row]
            cell?.selectionStyle = .none
            cell?.rankLab.text = "\(indexPath.row - 1)"
            
            return cell!
        }
        var cell : GiftRankListViewCell? = tableView.dequeueReusableCell(withIdentifier: "GiftRankListViewCell") as? GiftRankListViewCell
        if cell == nil{
            cell = GiftRankListViewCell.init(style: .default, reuseIdentifier: "GiftRankListViewCell")
            
            cell?.needSend = true
        }
        //        cell?.model = gifts[indexPath.row]
        cell?.selectionStyle = .none
        cell?.rankLab.text = "\(indexPath.row - 1)"
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 3 {
            
            return 48
        }else if(indexPath.row == 2){
            
            return  252
            
        }else if(indexPath.row == 4){
            
            return 224
        }else if(indexPath.row == 0){
            
            return 152
        }
        return 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let vc = GiftRankVC()
            let uid = UserInfo.getSharedInstance().userId ?? ""
            vc.mainView.mainId = uid
            vc.mainView.type = 8
            vc.mainView.userId = uid
            vc.mainView.isSelf = true
            vc.mainView.titleText = "礼物榜"
            HQPush(vc: vc, style: .default)
        }
    }
}

extension SSMyGiftRoomController{
    
    func loadGiftRankingData() {
        
        ///获取礼物排行榜
        GiftNetworkProvider.request(.giftRanking(source: UserInfo.getSharedInstance().userId ?? "", type: "8", number: 1, pageSize: 10)) { result in
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
                                    
                                    for index in 0..<totalCount {
                                        
                                        let userModel = self.rankModels?.gifts?.content![index]
                                        if userModel?.id == UserInfo.getSharedInstance().userId {
                                            
                                            self.currentUserModel = userModel
                                        }
                                        
                                    }
                                    
                                    if totalCount > 3 && totalCount < 6{
                                        
                                        self.cellCount = 6 + totalCount - 3
                                        
                                    }else if(totalCount <= 3 && totalCount > 0){
                                        
                                        self.cellCount = 6
                                    }
                                    else if(totalCount > 5){
                                        
                                        self.cellCount = 9
                                    }
                                    
                                    
                                    self.cellCount = self.cellCount > 5 ? self.cellCount - 1 : self.cellCount
                                    
                                    self.tableView.reloadData()
                                }
                                
                                
                            }
                        }else if model?.code == 2000{
                            self.rankOnlySelf = true
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
        GiftNetworkProvider.request(.userRanking(source: UserInfo.getSharedInstance().userId ?? "", type: "8")) { result in
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
                                //                                self.botUserView.model = model
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
    
    ///礼物间信息
    func getRoomInfo() {
        UserInfoNetworkProvider.request(.myGift(userId:UserInfo.getSharedInstance().userId ?? "")) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            
                            self.rankModel = model?.data?.kj.model(GiftRankModel.self)
                            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
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
        GiftNetworkProvider.request(.giftStand(userId:UserInfo.getSharedInstance().userId ?? "")) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.giftArr = model!.data!.kj.modelArray(GiftUserModel.self)
                                self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
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
                                    
                                    self.tableView.isHidden = false
                                    self.giftEmptyView?.isHidden = true
                                    self.tableView.isScrollEnabled = true
                                    self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0),IndexPath.init(row: 3, section: 0)], with: .none)
                                    
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
    
    func loadUserGiftSettingData(name: String) {
        
        UserInfoNetworkProvider.request(.giftAddUserSetting(name: name)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                
                                self.lockBtnBlcok?()
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
