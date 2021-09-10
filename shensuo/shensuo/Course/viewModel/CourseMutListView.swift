//
//  courseMutListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/15.
//

import UIKit
import JXSegmentedView
import TangramKit
import RxSwift
import RxCocoa

class CourseMutListView: UIView {
    
    let disposeBag = DisposeBag()
    
    ///课程栏目
    let courseListView = TGFlowLayout(.vert,arrangedCount: 5)
    let courseTitles = ["形体课程", "仪态课程", "旗袍课程","其他课程","全部课程"]
    let courseImgNames = ["course_icon_0", "course_icon_0", "course_icon_0","course_icon_0","course_icon_0"]
    
    var segmentedViewDataSource = JXSegmentedDotDataSource()
    var segmentedView: JXSegmentedView!
    let titles = ["形体课程", "仪态课程", "旗袍课程","其他课程"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///初始化界面信息
    func setupUI() {
        setupCourseListView()
        
        segmentedView = JXSegmentedView()
        segmentedViewDataSource.titles = titles
        segmentedView.dataSource = segmentedViewDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
        segmentedView.delegate = self
        self.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(courseListView.snp.bottom)
            make.height.equalTo(50)
        }
    }
    
//    初始化课程按钮·列表
    func setupCourseListView() {
        courseListView.tg_height.equal(.wrap)
        courseListView.tg_width.equal(screenWid)
        courseListView.tg_padding = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        courseListView.tg_gravity = TGGravity.horz.fill
        courseListView.tg_space = 10
        
        for i in 0...4{
            let btn = UIButton.initImgAndTitle(img: UIImage.init(named: "kecheng_qipao")!, title: courseTitles[i], fontSize: 16, titleColor: .black, imgSize: CGSize.init(width: 50, height: 50), textHei: 30, topSpace: 20)
            btn.tg_height.equal(100)
            btn.tag = i
            
            ///按钮点击方法
            btn.rx.tap.subscribe(onNext: {
                logger.debug("btn-tag:",self.courseTitles[btn.tag])
                }).disposed(by: disposeBag)
            
            courseListView.addSubview(btn)
        }
        
        self.addSubview(courseListView)
        courseListView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(100)
        }
    }
    
}

extension CourseMutListView : JXSegmentedViewDelegate{
    //点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        logger.debug("JXSegmentedView, didSelectedItemAt--",titles[index])
    }
    // 点击选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {}
    // 滚动选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {}
    // 正在滚动中的回调
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {}
}

