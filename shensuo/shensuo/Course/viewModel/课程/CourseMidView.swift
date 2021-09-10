//
//  KeChengMidView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/7.
//

import UIKit
import CollectionKit

class CourseMidView: UIView {
    
    let listView = CollectionView()
    let userView = CourseUserView()
    let bgView = UIImageView.initWithName(imgName: "kecheng_mid_bg")
    let btnWid = (screenWid - 36 - 15 * 4) / 5
    var btnHei : CGFloat!
    let myHei = screenWid / 414 * 209
    
    var ds = ArrayDataSource<CourseTypeModel>()

    var models : [CourseTypeModel] = []{
        didSet{
            let tempArr = NSMutableArray.init(array: models)
            var model = CourseTypeModel()
            model.logoImage = "kecheng_all"
            model.name = "全部课程"
            model.id = ""
            model.isLocal = true
            tempArr.add(model)

            ds.data = tempArr as! [CourseTypeModel]
            ds.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        btnHei = btnWid + 20
        let topSpace = myHei / 209 * 27
        
        let viewSource = ClosureViewSource(viewUpdater: { (view: CourseTypeView, data: CourseTypeModel, index: Int) in
            view.model = data
        })
        let sizeSource = { (index: Int, data: CourseTypeModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: self.btnWid, height: self.btnHei)
        }
        
        
        let provider = BasicProvider(
          dataSource: ds,
          viewSource: viewSource,
          sizeSource: sizeSource
        )

        
        provider.layout = RowLayout.init("provider", spacing: 15, justifyContent: JustifyContent.start, alignItems: .start)
        provider.tapHandler = { hand in
            let model = hand.data
            let vc = SearchCourseVC()
            vc.mainView.selMainId = model.id ?? "0"
            HQPush(vc: vc, style: .default)
        }
        
        listView.provider = provider
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(btnHei)
            make.top.equalTo(topSpace)
        }
        
        self.addSubview(userView)
        userView.snp.makeConstraints { (make) in
            make.height.equalTo(46)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        self.userView.getNetInfo()
    }
}

class CourseTypeView:UIView{
    let btn = UIView()
    let img = UIImageView()
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 13), ali: .center)
    let btnWid = (screenWid - 36 - 15 * 4) / 5
    
    var model : CourseTypeModel? = nil{
        didSet{
            if model != nil{
                if model!.isLocal {
                    img.image = UIImage.init(named: model!.logoImage!)
                }else{
                    img.kf.setImage(with: URL.init(string: model?.logoImage ?? ""),placeholder: UIImage.init(named: "kecheng_all"))
                }
                titleLab.text = model!.name
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWid)
            make.top.left.equalToSuperview()
        }
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(img.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
