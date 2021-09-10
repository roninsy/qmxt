//
//  StepDetalisForPlayView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/24.
//

import UIKit
import WebKit

class StepDetalisForPlayView: UIView {
    var isAdd = false
    let stepNumView = StepNumForPlayView()
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .left)
    let botLab = UILabel.initSomeThing(title: "0/0", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .center)
    
    let lBtn = UIButton.initImgv(imgv: .initWithName(imgName: "arrow_left"))
    let rBtn = UIButton.initImgv(imgv: .initWithName(imgName: "arrow_right"))
    let webView = WKWebView()
    
    var selNum = 0{
        didSet{
            if models.count > selNum{
                let model = models[selNum]
                self.titleLab.text = model.title
                stepNumView.model = model
                let htmlStr = model.details ?? ""
                webView.loadHTMLString(htmlStr, baseURL: nil)
            }
            self.botLab.text = "\(selNum + 1)/\(models.count)"
        }
    }
    var models : [CourseStepListModel] = []{
        didSet{
            self.botLab.text = "\(selNum + 1)/\(models.count)"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#FFFFFF")
        
        self.addSubview(stepNumView)
        stepNumView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.top.equalTo(12)
            make.left.equalTo(20)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.right.equalTo(-20)
            make.top.equalTo(12)
            make.left.equalTo(stepNumView.snp.right).offset(7)
        }
        
        let sview = UIScrollView()
//        sview.layer.masksToBounds = true
        sview.showsVerticalScrollIndicator = false
        self.addSubview(sview)
        sview.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(23)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-55)
        }
        
        sview.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(358)
            make.height.equalTo(screenWid - 142)
        }
        
        self.addSubview(lBtn)
        lBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(18)
            make.bottom.equalTo(-13)
        }
        lBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.selNum > 0{
                if self.models.count >= self.selNum{
                    let model = self.models[self.selNum - 1]
                    if !self.isAdd && !(model.freeTry ?? false){
                        HQGetTopVC()?.view.makeToast("请先加入学习")
                        return
                    }
                    self.selNum = self.selNum - 1
                }
            }
        }
        
        self.addSubview(botLab)
        botLab.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.right.left.equalTo(0)
            make.centerY.equalTo(lBtn)
        }
        
        self.addSubview(rBtn)
        rBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(-18)
            make.bottom.equalTo(-13)
        }
        rBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.selNum < (self.models.count - 1){
                let model = self.models[self.selNum + 1]
                if !self.isAdd && !(model.freeTry ?? false){
                    HQGetTopVC()?.view.makeToast("请先加入学习")
                    return
                }
                self.selNum = self.selNum + 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
