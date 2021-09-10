//
//  ProjectDaySelView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/1.
//

import UIKit
import CollectionKit

class ProjectDaySelView: UIView {
    var selDayBlock : intBlock? = nil
    let listView = CollectionView()
    var finishDay = 0
    var dayStrArr : [String] = NSArray() as! [String]{
        didSet{
            self.ds.data = self.dayStrArr
            self.ds.reloadData()
        }
    }
    let btnWid = 75 + 30
    let btnHei = 27
    
    var ds = ArrayDataSource<String>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewSource = ClosureViewSource(viewUpdater: { (view: projectDayView, data: String, index: Int) in
            view.titleLab.text = "第\(data)天"
            view.statusBtn.backgroundColor = index < self.finishDay ? .init(hex: "#21D826") : .init(hex: "#D8D8D8")
            view.statusImg.image = index < self.finishDay ? UIImage.init(named: "project_day_finish") : UIImage.init(named: "project_day_unfinish")
            view.nextLine.backgroundColor = view.statusBtn.backgroundColor
        })
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            let wid = self.btnWid - (index < (self.dayStrArr.count - 1) ? 0 : 30)
            return CGSize(width: wid, height: self.btnHei)
        }
        
        
        let provider = BasicProvider(
          dataSource: ds,
          viewSource: viewSource,
          sizeSource: sizeSource
        )

        
        provider.layout = RowLayout.init("provider", spacing:0, justifyContent: JustifyContent.start, alignItems: .start)
        provider.tapHandler = { hand in
            self.selDayBlock?(hand.index)
        }
        
        listView.provider = provider
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(btnHei)
            make.top.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class projectDayView: UIView {
    
    let statusImg = UIImageView.initWithName(imgName: "project_day_unfinish")
    let titleLab = UILabel.initSomeThing(title: "第1天", titleColor: .init(hex: "#3A405D"), font: .systemFont(ofSize: 12), ali: .center)
    
    let statusBtn = UIButton.initWithLineBtn(title: "", font: .systemFont(ofSize: 12), titleColor: .clear, bgColor: .white, lineColor: .init(hex: "#D8D8D8"), cr: 13.5)
    
    let nextLine = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.addSubview(statusBtn)
        statusBtn.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.height.equalTo(27)
            make.left.equalTo(0)
            make.top.equalTo(0)
        }
        statusBtn.isEnabled = false
        
        self.addSubview(statusImg)
        statusImg.snp.makeConstraints { make in
            make.width.equalTo(27)
            make.height.equalTo(27)
            make.left.equalTo(0)
            make.top.equalTo(0)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.right.equalTo(statusBtn)
            make.height.equalTo(27)
            make.left.equalTo(27)
            make.top.equalTo(0)
        }
        
        self.addSubview(nextLine)
        nextLine.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(7)
            make.left.equalTo(statusBtn.snp.right)
            make.centerY.equalTo(statusBtn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
