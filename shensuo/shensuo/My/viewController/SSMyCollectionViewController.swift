//
//  SSMyCollectionViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/6.
//

import UIKit
import JXPagingView
import JXSegmentedView
import BSText

//我的收藏
class SSMyCollectionViewController: SSBaseViewController {

    var selectIndex:Int = 0
    var headerInSectionHeight : CGFloat = 50
    let searchView = SSSearchView.init()
    var headerViewHeight : CGFloat = 50
    
    let tipView = BSLabel()
    
    let currentVC:SSDataCollectionController? = nil
    
    lazy var pagingView : JXPagingView = JXPagingView(delegate: self)
    
    lazy var userHeaderView : UIView = {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: headerViewHeight))
        return headerView
    }()
    
    let headView = UIView()
    lazy var segmentedView : JXSegmentedView = {
        let segment = JXSegmentedView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: headerInSectionHeight))
        segment.layer.masksToBounds = true
        segment.layer.cornerRadius = 5
        return segment
    }()
    
    var segmentedDataSourse = JXSegmentedTitleDataSource()
    var segTitles = ["课程","方案","动态","美丽日记","美丽相册"]
    var dataType:[ComDataType] = [.kecheng, .fangan, .dongtai, .mlrj, .mlxc]
    var searchArrays = ["","","","",""]
    
    var searchKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ishideBar = true
        navView.backBtnWithTitle(title: "我的收藏")
       
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
        
        segmentedView.backgroundColor = .white
        segmentedView.indicators = [indicator]
        self.view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView

        
        pagingView.pinSectionHeaderVerticalOffset = Int(NavStatusHei)

        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        headView.backgroundColor = .init(hex: "#f6f6f6")
        self.headView.addSubview(segmentedView)
        self.headView.addSubview(tipView)
        tipView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(50)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.addSubview(pagingView)
        pagingView.snp.makeConstraints { (make) in
            make.top.equalTo(NavBarHeight)
            make.left.right.bottom.equalToSuperview()

        }
        self.view.insertSubview(searchView, aboveSubview: pagingView)
        searchView.delegate = self
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(NavBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(searchViewHeight)
        }
    }

    func setNumAndKeyWord(num:String,keyWords:String){
        let protocolText = NSMutableAttributedString(string: "共搜到\(num)个与“\(keyWords)”相关信息")
        protocolText.bs_color = .init(hex: "#B4B4B4")
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 3, length: num.length))
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 6+num.length, length: keyWords.length))
        tipView.attributedText = protocolText
        tipView.isHidden = keyWords.length == 0
    }
}

extension SSMyCollectionViewController : JXPagingViewDelegate
{
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        if self.searchKey != "" {
            return Int(headerViewHeight + 20 + 12)
        }
        return Int(headerViewHeight) + 12
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(headerInSectionHeight)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return headView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segTitles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        switch index {
        case 2,3,4:
            let dataController = SSDataCollectionController()
            dataController.type = dataType[index]
            dataController.currentIndex = index
            dataController.isCollection = true
            return dataController
            case 0,1:

                let vc = SSMyCollectionCourseController()
                if index == 0 {
                    
                    vc.inType = 0
                    vc.currentIndex = 0
                    vc.title = "我的课程"
                }else{
                    vc.title = "我的方案"
                    vc.inType = 1
                    vc.currentIndex = index
                }
                return vc
        default:
            return SSPersionDataViewController()
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
       
        
    }
    
    
}

extension SSMyCollectionViewController : JXSegmentedViewDelegate
{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
        searchView.searchTextField.text = searchArrays[index]
        selectIndex = index
        
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
        searchView.searchTextField.text = searchArrays[index]
        selectIndex = index
//        self.currentVC =
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
    
    
}

extension SSMyCollectionViewController: SSSearchViewDelegate {
    func searchDataWithKeyWord(key: String) {
        self.searchKey = key
        self.searchArrays[selectIndex] = key
        NotificationCenter.default.post(name: CollectionSearchCompletionNotification,object: nil,userInfo: ["currentIndex" : selectIndex,"searchKey" : key] as [String : Any])
    }
}
