//
//  SelTitleListView.swift
//  chengzishiping
//
//  Created by 陈鸿庆 on 2021/3/29.
//

import UIKit
import JXSegmentedView
import CollectionKit

class CourseSelTitleListView: UIView {
    var selIndex : intBlock?
    var selSubIndex : voidBlock?
    let dataSource = JXSegmentedTitleDataSource()
    let indicator = JXSegmentedIndicatorLineView()
    var itemWid : CGFloat = 80
    var segmentedDataSource : JXSegmentedTitleDataSource? = nil
    let segmentedView = JXSegmentedView()
    var itemArr : [JXSegmentedBaseItemModel] = NSMutableArray() as! [JXSegmentedBaseItemModel]
    var titles : [String] = ["全部"]
    let bgView = UIView()
    
//    var ds = ArrayDataSource<KechengChildTypeModel>()
//    let listView = CollectionView()
    var subselIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        
        bgView.backgroundColor = .white
        
//        self.bounds = .init(x: 0, y: 0, width: screenWid - 20, height: 52)
        bgView.frame = .init(x: 0, y: 0, width: screenWid - 20, height: 56)
        bgView.bounds = .init(x: 10, y: 0, width: screenWid - 20, height: 56)
        self.addSubview(bgView)
        
        dataSource.titleNormalFont = .systemFont(ofSize: 14)
        dataSource.titleNormalColor = .init(hex: "#666666")
        dataSource.titleSelectedFont = .boldSystemFont(ofSize: 16)
        dataSource.titleSelectedColor = UIColor.init(hex: "#FD8024")
        dataSource.titles = titles
        
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
            make.top.equalTo(9)
            make.height.equalTo(40)
            make.left.right.equalToSuperview()
        }
        
//        let viewSource = ClosureViewSource(viewUpdater: { (view: CourseTypeSelView, data: KechengChildTypeModel, index: Int) in
//            view.model = data
//            view.isSel = index == self.subselIndex
//        })
//        
//        let sizeSource = { (index: Int, data: KechengChildTypeModel, collectionSize: CGSize) -> CGSize in
//            return CGSize(width: 64, height: 27)
//        }
        
//        let provider = BasicProvider(
//          dataSource: ds,
//          viewSource: viewSource,
//          sizeSource: sizeSource
//        )
//
//        provider.layout = RowLayout.init("provider", spacing: 12, justifyContent: JustifyContent.start, alignItems: .start)
//
//        provider.tapHandler = { hand in
//            var model = hand.data
//            self.subselIndex = hand.index
//            self.ds.reloadData()
//            self.selSubIndex?()
//        }
//
//        listView.provider = provider
//        listView.showsVerticalScrollIndicator = false
//        listView.showsHorizontalScrollIndicator = false
//        self.addSubview(listView)
//        listView.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-10)
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.height.equalTo(27)
//        }
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
    
    func needR(){
        HQRoude(view: bgView, cs: [.topLeft,.topRight], cornerRadius: 6)
    }
}

extension CourseSelTitleListView : JXSegmentedViewDelegate{
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        ///按钮被选中
        self.selIndex?(index)
    }
    
}
