//
//  SSCommunityVedioListVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/21.
//

import UIKit

class SSCommunityVedioListVC: HQBaseViewController{
    
    var reloadBlock : voidBlock? = nil
    ///被删除id
    var delId : String = ""
    
    var cells : [SSVedioListCell] = NSMutableArray() as! [SSVedioListCell]
    
    var needNewPage = false
    
    var needLoadData = true
    
    var selIndex = 0
    var nextIndex = 0
    
    let listView = UITableView()
    
    var models : [SSCommitModel] = NSMutableArray() as! [SSCommitModel]
    
    var pageNum = 1
    ///1:推荐，2:关注，3:同城
    var type = 1
    
    //城市名
    var city = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        listView.isPagingEnabled = true
        listView.backgroundColor = .black
        if #available(iOS 11.0, *) {
                   listView.contentInsetAdjustmentBehavior = .never
            } else {
                   automaticallyAdjustsScrollViewInsets = true;
            }
        listView.estimatedRowHeight = 0
        listView.showsVerticalScrollIndicator = false
        listView.separatorStyle = .none
//        listView.register(SSVedioListCell.self, forCellReuseIdentifier: "SSVedioListCell")
        self.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let model = self.models.count != 0 ? self.models[0] : SSCommitModel()
        ///上传事件
        HQPushActionWith(name: "content_view", dic: ["content_id":model.id ?? "",
                                         "content_type":"动态",
                                         "note_type":"视频",
                                         "editor_id":model.userId ?? "",
                                         "editor_name":model.nickName ?? "",
                                         "publish_time":model.createTime ?? ""])

    }
    
    deinit {
        for cell in cells{
            cell.player._avplayer.currentItem?.cancelPendingSeeks()
            cell.player._avplayer.currentItem?.asset.cancelLoading()
            cell.player._avplayer.replaceCurrentItem(with: nil)
            NotificationCenter.default.removeObserver(cell)
            for view in cell.subviews {
                view.removeFromSuperview()
            }
            cell.removeFromSuperview()
        }
        self.listView.removeFromSuperview()
        /// 移除通知
        NotificationCenter.default.removeObserver(self.listView)
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserInfo.getSharedInstance().inVedioListVC = true
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        if self.needLoadData {
            self.needLoadData = false
            self.listView.reloadData()
            self.getNetInfo()
        }
    }
    
    func getNetInfo() {
        CommunityNetworkProvider.request(.upAndDownNote(pageNumber: pageNum, pageSize: 5, module: type, noteType: 1, city: city,id: self.models.count != 0 ? (models[models.count - 1].id ?? "") : self.delId)) { [self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            for temp in dic!{
                                self.needNewPage = true
                                var model = SSCommitModel()
                                model.id = temp as? String ?? ""
                                self.models.append(model)
                            }
                            if self.models.count == 0 {
                                DispatchQueue.main.async {
                                    HQGetTopVC()?.view.makeToast("暂无数据")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                            }
                            self.listView.reloadData()
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserInfo.getSharedInstance().inVedioListVC = false
        let oldCell = listView.cellForRow(at: .init(row: selIndex, section: 0))
        (oldCell as? SSVedioListCell)?.player._avplayer.pause()
    }
    

}

extension SSCommunityVedioListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idf = "SSVedioListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: idf) as? SSVedioListCell
        if cell == nil {
            cell = SSVedioListCell.init(style: .default, reuseIdentifier: idf)
            cell?.reloadBlock = {[weak self] mid in
                self?.delId = mid
                DispatchQueue.main.async {
                    self?.models.removeAll()
                    self?.listView.reloadData()
                    self?.getNetInfo()
                    self?.reloadBlock?()
                }
            }
        }
        let tag = indexPath.row - selIndex
        cell?.progress.value = 0
//        cell?.player.view.isHidden = true
        cell?.dataModel = models[indexPath.row]
        cell?.autoPlay = indexPath.row == 0
        cell?.playBtn.isHidden = true
        cell?.timeView.isHidden = true
        if tag == 1 || tag == -1 {
            if nextIndex != indexPath.row {
                cell?.loadPlayData()
            }
            nextIndex = indexPath.row
        }else if indexPath.row == 0{
            cell?.loadData()
        }
        self.cells.append(cell!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHei
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            return
        }
        ///停止旧cell的播放，启动新cell的播放
        let index = Int(scrollView.contentOffset.y / screenHei)
        ///请求新数据
        if scrollView.contentOffset.y > (CGFloat((models.count - 2)) * screenHei){
            if needNewPage {
                print("index:\(index)")
                self.needNewPage = false
                self.pageNum += 1
                self.getNetInfo()
            }
        }
        if index == self.selIndex {
            return
        }
        let oldCell = listView.cellForRow(at: .init(row: selIndex, section: 0))
        (oldCell as? SSVedioListCell)?.player._avplayer.pause()
//        (oldCell as? SSVedioListCell)?.loadData()
        
        if self.selIndex > index {
            let cell = listView.cellForRow(at: .init(row: index, section: 0))
    //        (cell as? SSVedioListCell)?.reloadVedioUrl()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (cell as? SSVedioListCell)?.player._avplayer.play()
            }
        }else{
            let cell = listView.cellForRow(at: .init(row: index, section: 0))
    //        (cell as? SSVedioListCell)?.reloadVedioUrl()
            
            (cell as? SSVedioListCell)?.player._avplayer.play()
        }
//        启动新cell的播放
        self.selIndex = index
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            (cell as? SSVedioListCell)?.player.view.isHidden = false
//        }
        
//        let newCell = listView.cellForRow(at: .init(row: index + 1, section: 0))
//        (newCell as? SSVedioListCell)?.reloadVedioUrl()
//        (newCell as? SSVedioListCell)?.player._avplayer.play()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
//            (newCell as? SSVedioListCell)?.player._avplayer.pause()
//        }

    }
    
}
