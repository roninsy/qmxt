//
//  SSCurriculumSelTitleView.swift
//  shensuo
//
//  Created by  yang on 2021/7/3.
//

import UIKit
import JXSegmentedView
import CollectionKit

class SSCurriculumSelTitleView: UIView {
    var selIndex : intBlock?
    var selSubIndex : voidBlock?
    let dataSource = JXSegmentedTitleDataSource()
//    let indicator = JXSegmentedIndicatorLineView()
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
        bgView.frame = .init(x: 0, y: 0, width: screenWid, height: 50)
        bgView.bounds = .init(x: 10, y: 0, width: screenWid, height: 50)
        self.addSubview(bgView)
        
        dataSource.titleNormalFont = .systemFont(ofSize: 14)
        dataSource.titleNormalColor = .init(hex: "#333333")
        dataSource.titleSelectedFont = .boldSystemFont(ofSize: 12)
        dataSource.titleSelectedColor = UIColor.init(hex: "#FD8024")
        dataSource.titles = titles
        
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

extension SSCurriculumSelTitleView : JXSegmentedViewDelegate{
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        ///按钮被选中
//        segmentedView.layer.cornerRadius = 20
//        segmentedView.layer.masksToBounds = true
//        segmentedView.layer.borderWidth = 0.5
//        segmentedView.layer.borderColor = UIColor.hex(hexString: "#FD8024").cgColor
//        segmentedView.backgroundColor = UIColor.init(r: 253, g: 128, b: 36, a: 0.15)
        self.selIndex?(index)
    }
    
}
