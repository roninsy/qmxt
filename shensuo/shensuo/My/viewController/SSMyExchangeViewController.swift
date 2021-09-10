//
//  SSMyExchangeViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/16.
//

import UIKit
import JXSegmentedView

//我的兑换
class SSMyExchangeViewController: SSBaseViewController {
    
    
    let segTitles = ["未使用","已使用","已失效"]
    
    var page = 0
    var segmentedView: JXSegmentedView!
    var segmentedDataSourse: JXSegmentedTitleDataSource!
    var contentScrollView: UIScrollView!
    var listVcArray = [SSMyExchangeDataViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        layoutSubViews()
        self.loadData()
        navView.backBtnWithTitle(title: "我的兑换")
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
        
        for index in 0 ..< segmentedDataSourse.titles.count {
            let dataVc = SSMyExchangeDataViewController()
            if index == 0 {
                dataVc.type = .unUsed
            } else if index == 1 {
                dataVc.type = .didUsed
            } else {
                dataVc.type = .outTime
            }
            
            dataVc.delegate = self
            dataVc.navController = self.navigationController
            listVcArray.append(dataVc)
        }
        
//        listVcArray.first?.loadFirstData()
        
    }
    
    func layoutSubViews() -> Void {
        view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
        
        self.view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(50)
        }

        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(screenHei-NavBarHeight-50-statusHei)
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

extension SSMyExchangeViewController:exChangeDataDelegate
{
    func updateSegmentTitle(usedNum: Int, unUsedNum: Int, outTimeNum: Int) {
//        segmentedDataSourse.titles = [String(usedNum), String(unUsedNum), String(outTimeNum)]
        segmentedView.dataSource = segmentedDataSourse
    
    }
    
    
}

extension SSMyExchangeViewController:JXSegmentedViewDelegate
{
    
}
