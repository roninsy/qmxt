//
//  addFriendViewController.swift
//  shensuo
//
//  Created by swin on 2021/3/23.
//

import Foundation
import SnapKit
import Toast_Swift
import JXSegmentedView
import MBProgressHUD
import JXPagingView

//MARK: 添加好友
class SSAddFriendViewController: SSBaseViewController {
    
    let whiteBG = UIView()
    
    let headView = UIImageView()
    
    var contentScrollView : UIScrollView = {
        let content = UIScrollView.init()
        content.isPagingEnabled = true
        content.showsVerticalScrollIndicator = false
        content.showsHorizontalScrollIndicator = false
        content.scrollsToTop = false
        content.bounces = false
        return content
    }()
    var selectIndex = 0
    
    var segmentView: JXSegmentedView!
    var segmentDataSource: JXSegmentedTitleDataSource!
    let segTitles = ["推荐","附近","认证企业","认证个人"]
    var listArrayVC = [SSFriendTableViewController]()
//    lazy var pagingView : JXPagingView = JXPagingView(delegate: self)
    
    let addFriend = SSAddFriendView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ishideBar = true
        if addFriend.clickControlHander == nil {
            addFriend.clickControlHander = self.clickControlBtn(btnControl:)
        }
        
        segmentView = JXSegmentedView()
        segmentDataSource = JXSegmentedTitleDataSource()
        segmentDataSource.titles = segTitles
        segmentDataSource.titleNormalColor = UIColor.init(hex: "#666666")
        segmentDataSource.titleSelectedColor = UIColor.init(hex: "#FD8024")
        segmentDataSource.titleNormalFont = .systemFont(ofSize: 18)
        segmentDataSource.isTitleColorGradientEnabled = true
        segmentView.delegate = self
        segmentView.dataSource = segmentDataSource
        segmentView.backgroundColor = .white
        segmentView.defaultSelectedIndex = 0
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = UIColor.init(hex: "#FD8024")
        segmentView.indicators = [indicator]
        
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        segmentView.contentScrollView = contentScrollView

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.buildUI()
        self.loadData()
        
        navView.backBtnWithTitle(title: "添加好友")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(segTitles.count), height: contentScrollView.bounds.size.height)

        for (index, vc) in listArrayVC.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
            contentScrollView.addSubview(vc.view)
        }
    }
    
    func loadData() {
        
        for vc in listArrayVC {
            vc.view.removeFromSuperview()
        }
        listArrayVC.removeAll()

        for index in 0 ..< segmentDataSource.titles.count {
            let dataVc = SSFriendTableViewController()
            dataVc.inType = index
            dataVc.navController = navigationController
            listArrayVC.append(dataVc)
        }
        listArrayVC.first?.loadSuggestedFollowsData()
    }
    
    func buildUI() {
        
        self.view.addSubview(addFriend)
        addFriend.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(8)
            make.left.width.equalToSuperview()
            make.height.equalTo(140)
        }
        
        self.view.addSubview(segmentView)
        segmentView.snp.makeConstraints { (make) in
            make.top.equalTo(addFriend.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.bottom.equalToSuperview()
        }
    }
    
    func clickControlBtn(btnControl: UIControl) {
//        self.view.makeToast(String.init(format: "点击了第%d Control", btnControl.tag))
        switch btnControl.tag {
        case 1001:
            let vc = SSTXLFriendViewController()
            vc.hidesBottomBarWhenPushed = true
            HQPush(vc: vc, style: .default)
            break
            case 1002:
                shareWithType(type: 1002)
                break
            case 1003:
                shareWithType(type: 1003)
                break
        default:
            break
        }
    }
}


extension SSAddFriendViewController : JXSegmentedViewDelegate
{

    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        selectIndex = index
        if index == 1 {
            
            listArrayVC[index].mapInfo()
        }else{
            
            listArrayVC[index].loadSuggestedFollowsData()
        }

    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
        selectIndex = index
        if index == 1 {
            
            listArrayVC[index].mapInfo()
            
        }else{
            
            listArrayVC[index].loadSuggestedFollowsData()
        }
        
    }
    
    ///1.微信好友，2.微信朋友圈 3.QQ好友 4.新浪微博
    func shareWithType(type:Int){
        let msg = JSHAREMessage()

        let imgV = UIImageView.init()
        
        imgV.kf.setImage(with: URL.init(string: UserInfo.getSharedInstance().headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
        if type == 1002 {
            msg.title = "[\(UserInfo.getSharedInstance().nickName ?? "")]邀请您加入全民形体学习"
            msg.text = "立挺美好人生，和我一起变美吧~"
            msg.url =  ShareRegisterURL

            msg.image =  imgV.image!.jpegData(compressionQuality: 0.8)
       
            msg.mediaType = .link
            msg.platform = .wechatSession
        }else if type == 1003 {
            msg.title = "[\(UserInfo.getSharedInstance().nickName ?? "")]邀请您加入全民形体学习"
            msg.text = "立挺美好人生，和我一起变美吧~"
            msg.url = ShareRegisterURL
            msg.image =  imgV.image!.jpegData(compressionQuality: 0.8)
            msg.mediaType = .link
            msg.platform = .QQ
        }
        
        var flag = true
        if type == 1002 {
            flag = CheckAppInstalled(type: 0)
        }else if type == 1003{
            flag = CheckAppInstalled(type: 2)
        }
        if !flag {
            return
        }
        JSHAREService .share(msg) { state, error in
            
        }
    }
    
}
