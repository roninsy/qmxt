//
//  KeChengDetalisSelView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/26.
//

import UIKit
import JXSegmentedView

class CourseDetalisSelView: UIView {
    var selIndex : intBlock?
    var selSubIndex : voidBlock?
    let dataSource = JXSegmentedTitleDataSource()
    let indicator = JXSegmentedIndicatorLineView()
    var itemWid : CGFloat = 80
    var segmentedDataSource : JXSegmentedTitleDataSource? = nil
    let segmentedView = JXSegmentedView()
    var itemArr : [JXSegmentedBaseItemModel] = NSMutableArray() as! [JXSegmentedBaseItemModel]
    var titles : [String] = ["课程目录","课程简介"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        dataSource.titleNormalFont = .systemFont(ofSize: 14)
        dataSource.titleNormalColor = .init(hex: "#666666")
        dataSource.titleSelectedFont = .boldSystemFont(ofSize: 16)
        dataSource.titleSelectedColor = UIColor.init(hex: "#FD8024")
        dataSource.titles = titles
        
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor =  UIColor.init(hex: "#FD8024")
        indicator.indicatorHeight = 2
        dataSource.itemSpacing = 10
        segmentedView.indicators = [indicator]
        segmentedDataSource = dataSource
        
        
        segmentedView.backgroundColor = .white
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedDataSource
        self.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(9)
            make.height.equalTo(40)
            make.left.equalTo(0)
            make.width.equalTo(180)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CourseDetalisSelView : JXSegmentedViewDelegate{
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        ///按钮被选中
        self.selIndex?(index)
    }
    
}
