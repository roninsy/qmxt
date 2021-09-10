//
//  SSpersionDetailViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/9.
//

import UIKit
import JXPagingView
import JXSegmentedView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}


class SSPersionDetailViewController: SSBaseViewController {
    var sendBtn: UIButton?
    var headerViewHeight : CGFloat = 300
    var headerInSectionHeight : CGFloat = 50
    var selectIndex:Int = 0
    var userInfoModel: SSUserInfoModel?
    @objc var cid: String = ""

    //是否拉黑
    var isSlectBlack = false
    let giftVC = SSPersonGiftController()
    lazy var pagingView : JXPagingView = JXPagingView(delegate: self)
    lazy var userHeaderView : SSPersionHeaderView = {
        let headerView = SSPersionHeaderView.init()
        return headerView
    }()
    lazy var segmentedView : JXSegmentedView = {
        let segment = JXSegmentedView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: headerInSectionHeight))
        segment.layer.masksToBounds = true
        segment.layer.cornerRadius = 5
        return segment
    }()
    
    var segmentedDataSourse = JXSegmentedTitleDataSource()
    var segTitles = ["动态","礼物间","美丽日记","美丽相册","数据"]
    var dataType:[ComDataType] = [.dongtai, .gift, .mlrj, .mlxc, .data]
    var lockRload: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(userHeaderView)
        userHeaderView.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        
        if self.userInfoModel?.userId != UserInfo.getSharedInstance().userId ?? "" {
            
            loadSlectBlack()
            
        }
        userHeaderView.moreBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.tabBarController?.tabBar.isHidden = true
            self?.navigationController?.popViewController(animated: true)

        })
        
        userHeaderView.navView.clickSearchBtnBlock = {[weak self] in
            if self?.userInfoModel?.oneSelf == true {
                let vc = ShareVC()
                vc.setupMainView()
                HQPush(vc: vc, style: .default)
            }else{
                
                self?.onMySelfAction(oneStr: self!.isSlectBlack ? "解除拉黑" : "拉黑", secondStr: "推荐给好友",
                                     threeStr: "投诉",
                                     shareStr: "",
                                     oneHandle: { action in
                                        
                                        self?.commonSureAlertAction(sureStr: "确定", cancleStr: "取消", title: "", content: self?.isSlectBlack == true ? "解除拉黑后，Ta与您的所有互动功能均会恢复。您确定解除拉黑吗?" : "拉黑后，Ta将无法无法学习/购买您的课程/方案，也无法对您进行关注/点赞/评论/收藏/送礼。您确定把Ta拉黑吗", sureHandle: { result in
                                             
                                            self?.loadAddUserBlack()
                                        })

                }, secondHandle: { action in
                    
                    let vc = ShareVC()
                    vc.type = 0
                    vc.setupMainView()
                    HQPush(vc: vc, style: .lightContent)
                    
                },threeHandle: { action in
                    
                    let cpView = ComplainView()
                    cpView.contentType = 10
                    cpView.sourceId = self?.cid ?? ""
                    HQGetTopVC()?.view.addSubview(cpView)
                    cpView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                },
                shareHandle: { action in
  
                })

        
            }
            
        }
        
        userHeaderView.navView.clickAddBtnBlock = {
            let vc = ShareVC()
            vc.type = 1
            vc.onlyShare = true
            vc.setupMainView()
            HQPush(vc: vc, style: .lightContent)
            
        }
        
        userHeaderView.pView.followOrDataBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            if self?.userInfoModel?.oneSelf == true {
                
                self?.navigationController?.pushViewController(SSMyInfoViewController(), animated: true)
            }else{
                
                
                HQGetTopVC()?.view.makeToast("更多")
            }
        })
        
        userHeaderView.pBottonView.clickFenContentHander = {
            let listView = SSFocusListViewController.init()
            listView.type = .FriendList
            self.navigationController?.pushViewController(listView, animated: true)
        }
        
        userHeaderView.pBottonView.clickFocusContentHander = {
            let listView = SSFocusListViewController.init()
            listView.type = .FocusList
            self.navigationController?.pushViewController(listView, animated: true)
        }
        
        
        loadBgImageData()
    }
    
    func buildSegmentedUI() {
        
        segmentedDataSourse.titles = segTitles
        segmentedDataSourse.isTitleColorGradientEnabled = true
        segmentedDataSourse.titleNormalColor = UIColor.init(hex: "#666666")
        segmentedDataSourse.titleSelectedColor = UIColor.init(hex: "#FD8024")
        segmentedView.dataSource = segmentedDataSourse
        segmentedView.delegate = self
        
        segmentedView.defaultSelectedIndex = selectIndex
        
        
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = UIColor.init(hex: "#FD8024")
        
        segmentedView.indicators = [indicator]
        
        self.view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView

        
        pagingView.pinSectionHeaderVerticalOffset = Int(NavStatusHei)

        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.tabBarController?.tabBar.isHidden = true
        if userInfoModel == nil {
            loadPersonInfo()
        }
        
        if (cid == UserInfo.getSharedInstance().userId || cid.count == 0) && sendBtn == nil {
            
            sendBtn = UIButton.init()
            self.view.insertSubview(sendBtn!, at: 99)
            sendBtn!.setImage(UIImage.init(named: "icon-fabu"), for: .normal)
            sendBtn!.addTarget(self, action: #selector(jumpToReleaseVC), for: .touchUpInside)
            sendBtn!.snp.makeConstraints { make in
                make.bottom.equalTo(-(60 + SafeBottomHei))
                make.trailing.equalTo(-18)
                make.height.width.equalTo(63)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.bringSubviewToFront(self.sendBtn!)
            }
        }
        
    }
    
    //跳转到发布动态页面
   @objc func jumpToReleaseVC() {
    ///上报事件
    HQPushActionWith(name: "click_publish_note", dic:  ["current_page":"我的主页"])
        let vc = SSReleaseNewsViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
   }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }

    func loadPersonInfo() -> Void {
        giftVC.cid = cid
        UserInfoNetworkProvider.request(.userInfo(userId: cid)) { [self] result in
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
                            
                            let model = dic?.kj.model(SSUserInfoModel.self)
                            self.userInfoModel = model
                            
                            if self.lockRload == true{
                                self.lockRload = false
                                giftVC.oneself = self.userInfoModel?.oneSelf ?? false
                                giftVC.userInfoModel = self.userInfoModel
                                
                            }else{
                                
                                self.segTitles = model?.userType == 0 ?  ["动态","礼物间","美丽日记","美丽相册","数据"] : ["动态","礼物间","课程","方案","美丽日记","美丽相册","数据"]
                                self.dataType = model?.userType == 0 ? [.dongtai, .gift, .mlrj, .mlxc, .data] : [.dongtai,.gift,.kecheng,.fangan,.mlrj, .mlxc, .data]
                                self.segmentedDataSourse.titles = segTitles
                                self.userHeaderView.userInfoModel = model
                                self.headerViewHeight = model?.headH! ?? 0
                                self.userHeaderView.snp.updateConstraints { make in
                                    
                                    make.height.equalTo(self.headerViewHeight)
                                }
                                self.userHeaderView.snp.updateConstraints { make in
                                    
                                    make.height.equalTo(self.headerViewHeight)
                                }
                                self.buildSegmentedUI()
                                self.pagingView.reloadData()
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
    func loadBgImageData() {
        
        UserInfoNetworkProvider.request(.bgImage(userId: (UserInfo.getSharedInstance().userId ?? ""))) { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultStringModel.self)
                        if model?.code == 0 {
                            self?.userHeaderView.bgImg = model?.data ?? ""
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
    
    func loadSlectBlack()  {
                    
        UserInfoNetworkProvider.request(.getSelectBlack(blackUserId: cid)) { [weak self] result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultStringModel.self)
                            if model?.code == 0 {
                                
                                if model?.data != nil {
                                    
                                    if model?.data == "0" {
                                        self?.isSlectBlack = false
                                    }else{
                                        
                                        self?.isSlectBlack = true

                                    }
//                                    self?.isSlectBlack = model!.data == "false" ? false : true
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
    
    
    func loadAddUserBlack()  {
                    
        UserInfoNetworkProvider.request(.getAddUserBlack(blackUserId: cid)) { [weak self] result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultStringModel.self)
                            if model?.code == 0 {
                                
                                if self?.isSlectBlack == false {
                                    
                                    HQGetTopVC()?.view.makeToast("拉黑成功")
                                }else{
                                    
                                    HQGetTopVC()?.view.makeToast("解除拉黑成功")
                                }
                                self?.isSlectBlack = !self!.isSlectBlack
                                
                               
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


extension SSPersionDetailViewController : JXPagingViewDelegate
{
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(headerViewHeight)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(headerInSectionHeight)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segTitles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        switch index {
        case 0,4,5:
            if index == 4 && self.userInfoModel?.userType == 0{
                    
                    let vc = SSPersionDataViewController()
                    vc.userId = userInfoModel?.oneSelf == true ? "" : userInfoModel?.userId ?? ""
                    return vc
            }
            let dataController = SSDataCollectionController()
            if index == 0 {
                dataController.getDraftCount()
            }
            dataController.isSelf = self.cid == UserInfo.getSharedInstance().userId
            dataController.userInfoModel = self.userInfoModel
            dataController.type = dataType[index]
            dataController.isCollection = false
            return dataController
        case 1:
           
            giftVC.oneself = self.userInfoModel?.oneSelf ?? false
            giftVC.userInfoModel = self.userInfoModel
            giftVC.lockBtnBlcok = {[weak self] in
                
                self?.lockRload = true
            }
            return giftVC
            case 2,3:
            
                if self.userInfoModel?.userType != 0 {
                    let vc = SSPersonCurriculumController()
                    vc.type = index == 2 ? 0 : 1
                    
                    return vc

                }else{

                    let dataController = SSDataCollectionController()
                    dataController.userInfoModel = self.userInfoModel
                    dataController.type = dataType[index]
                    dataController.isCollection = false
                    dataController.isSelf = cid == UserInfo.getSharedInstance().userId
                    return dataController
                }
        default:
            let vc = SSPersionDataViewController()
            vc.userId = userInfoModel?.oneSelf == true ? "" : userInfoModel?.userId ?? ""
            return vc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
       
    }
    
    
}

extension SSPersionDetailViewController : JXSegmentedViewDelegate
{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
    
    
}
