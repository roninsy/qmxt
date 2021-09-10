//
//  SSBeautiBillTaskViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/4.
//

import UIKit
import JXPagingView
import JXSegmentedView

//美币任务
class SSBeautiBillTaskViewController: HQBaseViewController {
    
    var headerViewHeight : CGFloat = 300
    var headerInSectionHeight : CGFloat = 50
    
    var selectIndex:Int = 0
    
    lazy var pagingView : JXPagingView = JXPagingView(delegate: self)
    lazy var userHeaderView : SSBeautiHeaderView = {
        let headerView = SSBeautiHeaderView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: headerViewHeight))
        return headerView
    }()
    lazy var segmentedView : JXSegmentedView = {
        let segment = JXSegmentedView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: headerInSectionHeight))
        segment.layer.masksToBounds = true
        segment.layer.cornerRadius = 5
        return segment
    }()
    
    var segmentedDataSourse = JXSegmentedTitleDataSource()
    var segTitles = ["常规任务","认证企业/个人任务"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.view.addSubview(userHeaderView)
        userHeaderView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        self.view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.top.equalTo(userHeaderView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        segmentedView.listContainer = pagingView.listContainerView

        userHeaderView.navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        
        userHeaderView.navView.optionBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
//            let billBoxVC = SSBeautiBillBoxViewController.init()
//            billBoxVC.point = UserInfo.getSharedInstance().points
//            billBoxVC.hidesBottomBarWhenPushed = true
//            HQPush(vc: billBoxVC, style: .lightContent)
        }
        
        pagingView.backgroundColor = .init(hex: "#F7F8F9")

        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

extension SSBeautiBillTaskViewController : JXPagingViewDelegate
{
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 0
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return UIView()
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
        let dataVC = SSBeautiBillDataViewController.init()
        dataVC.index = index
        dataVC.updateBlanceBlock = { blance in
            self.userHeaderView.valueLabel.text = blance
        }
        return dataVC
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
       
    }
}

extension SSBeautiBillTaskViewController : JXSegmentedViewDelegate
{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
        
        
    }
    
    
}

