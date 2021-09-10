//
//  communityViewController.swift
//  shensuo
//
//  Created by swin on 2021/3/22.
//

import Foundation
import SnapKit
import JXSegmentedView
import MBProgressHUD
import SwiftyUserDefaults


public let enterFrist = "enterFrist"

//MARK: 社区首页
class SSCommunityViewController: HQBaseViewController {
    
    
    var segTitles = ["关注","推荐","同城"]
    
    var navView : SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
    var sendBtn: UIButton!
    var page = 0
    var segmentedView: JXSegmentedView!
    var segmentedDataSourse: JXSegmentedTitleDataSource!
    var listVc = SSCommunityListView()
    var searchBarButtonItem = UIBarButtonItem.init()
    var addBarButtonItem = UIBarButtonItem.init()
    
    var popView : SSMyPopFocusView? = nil

    
    lazy var naviItem = UINavigationItem()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.tabBarController?.tabBar.isHidden == true {
            
            self.tabBarController?.tabBar.isHidden = false
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
//        let window = UIApplication.shared.keyWindow
//        popView = SSMyPopFocusView.init()
//        window?.windowLevel = .normal
//        window?.addSubview(popView!)
        

        
        
        segmentedView = JXSegmentedView()
        
        segmentedDataSourse = JXSegmentedTitleDataSource()
        segmentedDataSourse.titles = segTitles
        segmentedDataSourse.isTitleColorGradientEnabled = true
        segmentedDataSourse.titleNormalColor = UIColor.init(hex: "#666666")
        segmentedDataSourse.titleSelectedColor = UIColor.init(hex: "#FD8024")
        segmentedView.dataSource = segmentedDataSourse
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        
        indicator.indicatorColor = UIColor.init(hex: "#FD8024")
        segmentedView.indicators = [indicator]
        segmentedView.defaultSelectedIndex = 1
        segmentedView.delegate = self
        
        segmentedView.backgroundColor = .white
        
        self.view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }

        self.view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(50)
        }

        self.view.addSubview(listVc)
        listVc.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sendBtn = UIButton.init()
        self.view.insertSubview(sendBtn, at: 99)
        sendBtn.setImage(UIImage.init(named: "icon-fabu"), for: .normal)
        sendBtn.addTarget(self, action: #selector(jumpToReleaseVC), for: .touchUpInside)
        sendBtn.snp.makeConstraints { make in
            
            make.bottom.equalTo(-(60 + SafeBottomHei))
            make.trailing.equalTo(-18)
            make.height.width.equalTo(63)
        }
        
        navView.titleWithOpentionBtn(title: "社区")
        
        navView.clickSearchBtnBlock = {
            let vc = SearchVC()
                    vc.hidesBottomBarWhenPushed = true
                    vc.mainView.reloadWithIndex(index: 2)
                    HQPush(vc: vc, style: .default)
//            self.navigationController?.pushViewController(SSSendCommentViewController.init(), animated: true)
        }
        
        navView.clickAddBtnBlock = {
            self.navigationController?.pushViewController(SSAddFriendViewController.init(), animated: true)
        }
        
        if UserInfo.getSharedInstance().tipfocus {
            popView = SSMyPopFocusView.init()
            HQGetTopVC()?.view.addSubview(popView!)
            popView?.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
            UserInfo.getSharedInstance().tipfocus = false
        }
        
        self.loadData()
    }
    
    //跳转到发布动态页面
   @objc func jumpToReleaseVC() {
    ///上报事件
    HQPushActionWith(name: "click_publish_note", dic:  ["current_page":"社区首页"])
        let vc = SSReleaseNewsViewController()
        vc.hidesBottomBarWhenPushed = true
        HQPush(vc: vc, style: .default)
   }

    
    @objc func clickSearchBarButton() {
        
    }
    
    @objc func clickAddBarButton() {
        HQPush(vc: SSAddFriendViewController.init(), style: .default)
    }
    
    @objc func clickAddFriendBtn(btn: UIButton){
        HQPush(vc: SSAddFriendViewController.init(), style: .default)
    }
    
    func loadData() {
        listVc.loadType = .recommend
//        for index in 0 ..< segmentedDataSourse.titles.count {
//
//            if index == 2 {
//
//                listVc.loadType = .sameCity
//            }else if(index == 1){
//
//                listVc.loadType = .recommend
//            }else{
//                listVc.loadType = .focus
//            }
//
//        }
        listVc.setSameCityTitleBlcok = {[weak self] str in
            self?.segTitles[2] = str
            self?.segmentedDataSourse.titles = self!.segTitles
            self?.segmentedView.reloadData()
        }
        listVc.page = 1
        listVc.loadRecommendData()

    }
    
}

extension SSCommunityViewController : JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        reloadDataWithIndex(index: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
        
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
        reloadDataWithIndex(index: index)

    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
    
    func reloadDataWithIndex(index: Int)  {
        listVc.page = 1
        switch index {
            case 0:
                listVc.loadType = .focus
                listVc.models?.removeAll()
                listVc.loadFirstData()
                break
            case 1:
                listVc.models?.removeAll()
                listVc.loadType = .recommend
                listVc.loadRecommendData()
                break
            case 2:
            
                listVc.models?.removeAll()
                listVc.loadType = .sameCity
                listVc.loadSameCityData()
                break
            default:
                break
        }
       
    }
}

