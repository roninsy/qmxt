//
//  SelTitleListView.swift
//  chengzishiping
//
//  Created by 陈鸿庆 on 2021/3/29.
//

import UIKit
import JXSegmentedView
import Hue

class SelTitleListView: UIView {
    var selIndex : intBlock?
    
    let indicator = JXSegmentedIndicatorLineView()
    var itemWid : CGFloat = 80
    var segmentedDataSource : JXSegmentedTitleDataSource? = nil
    let segmentedView = JXSegmentedView()
    var itemArr : [JXSegmentedBaseItemModel] = NSMutableArray() as! [JXSegmentedBaseItemModel]
    var titles : [String] = ["精选"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titleNormalFont = .systemFont(ofSize: 14)
        dataSource.titleNormalColor = .init(hex: "#CCCCCC")
        dataSource.titleSelectedFont = .boldSystemFont(ofSize: 18)
        dataSource.titleSelectedColor = UIColor.init(hex: "#4145F4")
        dataSource.titles = titles
        
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor =  UIColor.init(hex: "#6741F4")
        segmentedView.indicators = [indicator]
        segmentedDataSource = dataSource
        
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedDataSource
        self.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelTitleListView : JXSegmentedViewDelegate{
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        ///按钮被选中
        self.selIndex!(index)
    }
    
}
