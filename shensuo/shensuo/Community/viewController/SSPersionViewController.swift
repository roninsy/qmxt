//
//  SSPersionViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/9.
//

import UIKit
import SnapKit
import JXSegmentedView

class SSPersionViewController: SSBaseViewController {

    var scrollView : UIScrollView = {
        let mainScroll = UIScrollView.init()
        return mainScroll
    }()
    
    
    var headView : UIView = {
        let head = UIView.init()
        head.backgroundColor = .gray
        return head
    }()
    
    let segTitles = ["动态","礼物间","美丽日记","美丽相册","数据"]
    
    var segmentedView: JXSegmentedView!
    var segmentedDataSourse: JXSegmentedTitleDataSource!
    var contentScrollView: UIScrollView!
    var listVcArray = [SSCommunityDataController]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedView = JXSegmentedView()
        
        segmentedDataSourse = JXSegmentedTitleDataSource()
        segmentedDataSourse.titles = segTitles
        segmentedDataSourse.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSourse
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        
        indicator.indicatorColor = .red
        segmentedView.indicators = [indicator]
        
        contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.scrollsToTop = false
        contentScrollView.bounces = false
        
        contentScrollView.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        segmentedView.contentScrollView = contentScrollView
        
        segmentedView.delegate = self
        
        segmentedView.backgroundColor = .white
        
        self.setupSubviews()
        self.loadData()

        setupSubviews()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(segTitles.count), height: contentScrollView.bounds.size.height)
        for (index, vc) in listVcArray.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
            contentScrollView.addSubview(vc.view)
        }
        
    }
    
    func loadData() {
        
        for vc in listVcArray {
            vc.view.removeFromSuperview()
        }
        listVcArray.removeAll()
        
        for _ in 0 ..< segmentedDataSourse.titles.count {
            let dataVc = SSCommunityDataController()
            listVcArray.append(dataVc)
        }
        listVcArray.first?.loadFirstData()
    }
    
    func setupSubviews() -> Void {
        
        
//        self.view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//
////        scrollView.addSubview(navView)
////        navView.snp.makeConstraints { (make) in
////            make.top.left.equalTo(0)
////            make.width.equalToSuperview()
////            make.height.equalTo(NavBarHeight+100)
////        }
//
//        scrollView.addSubview(segmentedView)
//        segmentedView.snp.makeConstraints { (make) in
//            make.top.equalTo(200)
//            make.left.right.equalToSuperview()
//            make.width.equalTo(screenWid)
//            make.height.equalTo(50)
//        }
//
//        scrollView.addSubview(contentScrollView)
//        contentScrollView.snp.makeConstraints { (make) in
//            make.top.equalTo(segmentedView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.width.equalTo(screenWid)
//            make.height.equalTo(screenHei-50)
//        }
        
        self.view.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(50)
        }

        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(screenHei-300)
        }
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

extension SSPersionViewController : JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
}
