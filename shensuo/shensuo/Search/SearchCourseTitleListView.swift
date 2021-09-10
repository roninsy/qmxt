//
//  SearchCourseTitleListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/8.
//

import UIKit
import JXSegmentedView
import CollectionKit

class SearchCourseTitleListView: UIView {
    var selIndex : intBlock?
    var selSubIndex : voidBlock?
    let dataSource = JXSegmentedTitleDataSource()
    let indicator = JXSegmentedIndicatorLineView()
    var itemWid : CGFloat = 80
    var segmentedDataSource : JXSegmentedTitleDataSource? = nil
    let segmentedView = JXSegmentedView()
    var itemArr : [JXSegmentedBaseItemModel] = NSMutableArray() as! [JXSegmentedBaseItemModel]
    var titles : [String] = ["全部课程"]
    var subselIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataSource.titleNormalFont = .MediumFont(size: 16)
        dataSource.titleNormalColor = .init(hex: "#666666")
        dataSource.titleSelectedFont = .SemiboldFont(size: 18)
        dataSource.titleSelectedColor = UIColor.init(hex: "#FD8024")
        dataSource.titles = titles
        dataSource.widthForTitleClosure = { str in
            return CGFloat(str.length * 16 + 10)
        }
        
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor =  UIColor.init(hex: "#FD8024")
        indicator.indicatorHeight = 2
        segmentedView.indicators = [indicator]
        segmentedDataSource = dataSource
        
        segmentedView.backgroundColor = .white
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedDataSource
        self.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayer() {
        self.layer.shadowColor = HQColor(r: 152, g: 146, b: 159, a: 0.14).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.backgroundColor = .init(hex: "#F7F8F9")
    }
}
extension SearchCourseTitleListView : JXSegmentedViewDelegate{
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        ///按钮被选中
        self.selIndex?(index)
    }
    
}
