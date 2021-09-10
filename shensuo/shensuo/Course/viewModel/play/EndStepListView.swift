//
//  EndStepListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/22.
//

import UIKit

class EndStepListView: UIView {
    let itemWid = 42
    let lineWid = 19
    let lineHei = 7
    let sview = UIScrollView()
    
    var allWid : CGFloat = 0
    var finishStr = ""
    
    var models : [CourseStepListModel] = NSArray() as! [CourseStepListModel]{
        didSet{
            DispatchQueue.main.async {
                let itemNum = self.models.count
                let bgView = UIView()
                if itemNum > 1{
                    for i in 0...self.models.endIndex - 1 {
                        var model = self.models[i]
                        let numView = StepNumForPlayView()
                        numView.model = model
                        bgView.addSubview(numView)
                        numView.snp.makeConstraints { make in
                            make.width.height.equalTo(self.itemWid)
                            make.left.equalTo((self.itemWid + self.lineWid) * i)
                            make.top.equalToSuperview()
                        }
                        if i !=  (self.models.endIndex - 1){
                            let lineView = UIView()
                            bgView.addSubview(lineView)
                            lineView.backgroundColor = (model.finished ?? false) ? .init(hex: "#21D826") : .init(hex: "#FFFFFF")
                            lineView.snp.makeConstraints { make in
                                make.left.equalTo(numView.snp.right)
                                make.width.equalTo(self.lineWid)
                                make.height.equalTo(self.lineHei)
                                make.centerY.equalToSuperview()
                            }
                        }
                    }
                }else if itemNum == 1{
                    let model = self.models[0]
                    let numView = StepNumForPlayView()
                    numView.model = model
                    bgView.addSubview(numView)
                    numView.snp.makeConstraints { make in
                        make.width.height.equalTo(self.itemWid)
                        make.left.equalTo(0)
                        make.top.equalToSuperview()
                    }
                }else{
                    return
                }
                
                let wid = (self.itemWid + self.lineWid) * itemNum - self.lineWid
                
                self.sview.addSubview(bgView)
                bgView.snp.makeConstraints { make in
                    make.left.equalTo(0)
                    make.height.equalTo(42)
                    make.width.equalTo(wid)
                    make.top.equalTo(0)
                }
                
                self.sview.contentSize = .init(width: wid, height: 0)
                if wid < 200{
                    self.sview.snp.updateConstraints { make in
                        make.width.equalTo(wid)
                    }
                }
            }
        }
    }
    
    var finishDay = 0
    
    var dayMap : NSDictionary? = nil{
        didSet{
            if dayMap != nil {
                var keys = dayMap!.allKeys as? [String]
                if keys != nil && keys?.count != 0 {

                    keys!.sort { num1, num2 in
                        return Int(num1)! < Int(num2)!
                    }
                    let keysArr : [String] = NSMutableArray.init(array: keys!) as! [String]
                    for str in keysArr {
                        let dayView = projectDayView()
                        dayView.titleLab.text = "第\(str)天"
                        dayView.statusBtn.backgroundColor = (str.toInt ?? 0) <= self.finishDay ? .init(hex: "#21D826") : .init(hex: "#D8D8D8")
                        dayView.statusImg.image = (str.toInt ?? 0) <= self.finishDay ? UIImage.init(named: "project_day_finish") : UIImage.init(named: "project_day_unfinish") 
                        dayView.nextLine.backgroundColor = dayView.statusBtn.backgroundColor
                        self.sview.addSubview(dayView)
                        dayView.snp.makeConstraints { make in
                            make.width.equalTo(94)
                            make.height.equalTo(27)
                            make.top.equalTo(7.5)
                            make.left.equalTo(allWid)
                        }
                        self.allWid += 94
                        
                        ///添加小节
                        let temp = dayMap?[str] as? NSArray
                        if temp != nil && temp?.count != 0 {
                            let tempArr = temp!.kj.modelArray(CourseStepListModel.self)
                            let itemNum = tempArr.count
                            let bgView = UIView()
                            if itemNum > 1{
                                for i in 0...tempArr.endIndex - 1 {
                                    var model = tempArr[i]
                                    if self.finishStr.contains(String.init(format: "%@/%@", model.step!.stringValue,model.totalStep!.stringValue)) {
                                        model.finished = true
                                    }
                                    let numView = StepNumForPlayView()
                                    numView.model = model
                                    bgView.addSubview(numView)
                                    numView.snp.makeConstraints { make in
                                        make.width.height.equalTo(self.itemWid)
                                        make.left.equalTo((self.itemWid + self.lineWid) * i)
                                        make.top.equalToSuperview()
                                    }
                                    if i != (tempArr.endIndex - 1)
                                        || str != keysArr.last{
                                        let lineView = UIView()
                                        bgView.addSubview(lineView)
                                        lineView.backgroundColor = (model.finished ?? false) ? .init(hex: "#21D826") : .init(hex: "#FFFFFF")
                                        lineView.snp.makeConstraints { make in
                                            make.left.equalTo(numView.snp.right)
                                            make.width.equalTo(self.lineWid)
                                            make.height.equalTo(self.lineHei)
                                            make.centerY.equalToSuperview()
                                        }
                                    }
                                }
                            }else if itemNum == 1{
                                let model = tempArr[0]
                                let numView = StepNumForPlayView()
                                numView.model = model
                                bgView.addSubview(numView)
                                numView.snp.makeConstraints { make in
                                    make.width.height.equalTo(self.itemWid)
                                    make.left.equalTo(0)
                                    make.top.equalToSuperview()
                                }
                                if str != keysArr.last{
                                    let lineView = UIView()
                                    bgView.addSubview(lineView)
                                    lineView.backgroundColor = (model.finished ?? false) ? .init(hex: "#21D826") : .init(hex: "#FFFFFF")
                                    lineView.snp.makeConstraints { make in
                                        make.left.equalTo(numView.snp.right)
                                        make.width.equalTo(self.lineWid)
                                        make.height.equalTo(self.lineHei)
                                        make.centerY.equalToSuperview()
                                    }
                                }
                            }else{
                                return
                            }
                            
                            let wid = (self.itemWid + self.lineWid) * itemNum - (str != keys!.last ? 0 : self.lineWid)
                            
                            self.sview.addSubview(bgView)
                            bgView.snp.makeConstraints { make in
                                make.left.equalTo(allWid)
                                make.height.equalTo(42)
                                make.width.equalTo(wid)
                                make.top.equalTo(0)
                            }
                            self.allWid += CGFloat(wid)
                            
                            self.sview.contentSize = .init(width: self.allWid, height: 0)
                            if self.allWid < 200{
                                self.sview.snp.updateConstraints { make in
                                    make.width.equalTo(self.allWid)
                                }
                            }else{
                                self.sview.snp.updateConstraints { make in
                                    make.width.equalTo(screenHei / 2)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(sview)
        sview.showsHorizontalScrollIndicator = false
        sview.snp.makeConstraints { make in
            make.width.equalTo(screenHei / 2)
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
