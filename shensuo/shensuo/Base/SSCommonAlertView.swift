//
//  SSCustomAlertView.swift
//  shensuo
//
//  Created by  yang on 2021/6/25.
//

import UIKit

class SSCommonAlertView: UIView {

    var sureBtn = UIButton.initTitle(title: "确定", font: UIFont.MediumFont(size: 20), titleColor: btnColor, bgColor: .white)
    var bottmView = UIView()
    var contentL: UILabel!
    var bgView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        self.addSubview(bgView)
        bgView.backgroundColor = .white
        bgView.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(274)
            make.center.equalToSuperview()
            
        }
        
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        
        bgView.addSubview(bottmView)
        bottmView.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(51)
        }
        
        let lineView = UIView()
        bottmView.addSubview(lineView)
        lineView.backgroundColor = bgColor
        lineView.snp.makeConstraints { make in
            
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        bottmView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
        
        contentL = UILabel.initSomeThing(title: "", fontSize: 18, titleColor: color33)
        bgView.addSubview(contentL)
        contentL.numberOfLines = 0
        contentL.snp.makeConstraints { make in
            
            make.top.equalTo(32)
            make.leading.equalTo(34)
            make.trailing.equalTo(-34)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIViewController {
    
    func showActionWithTitle(oneStr: String, oneHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let oneAction = UIAlertAction.init(title: oneStr, style: .default, handler: oneHandle)
        

//        let emptyAction = UIAlertAction.init(title: "", style: .default) { (action) in
//
//        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(oneAction)
        alert.addAction(cancelAction)
        oneAction.setValue(color33, forKey: "_titleTextColor")

        self.present(alert, animated: true, completion: nil)
    }
        
    func onMySelfAction(oneStr: String,secondStr: String,threeStr: String,shareStr: String, oneHandle: ((UIAlertAction) -> Void)? = nil,secondHandle: ((UIAlertAction) -> Void)? = nil,threeHandle: ((UIAlertAction) -> Void)? = nil,shareHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let oneAction = UIAlertAction.init(title: oneStr, style: .default, handler: oneHandle)
        
        let secondAction = UIAlertAction.init(title:secondStr, style: .default,handler: secondHandle)
        let threeAction = UIAlertAction.init(title:threeStr, style: .default,handler: threeHandle)
        let shareAction = UIAlertAction.init(title: shareStr, style: .default,handler: shareHandle)
//        let emptyAction = UIAlertAction.init(title: "", style: .default) { (action) in
//
//        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(oneAction)
        alert.addAction(secondAction)
        alert.addAction(threeAction)
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        oneAction.setValue(color33, forKey: "_titleTextColor")
        secondAction.setValue(color33, forKey: "_titleTextColor")
        shareAction.setValue(btnColor, forKey: "_titleTextColor")
        threeAction.setValue(color33, forKey: "_titleTextColor")
    
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancleSureAlertAction(title: String,content: String,sureHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: title, message: content, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "确定", style: .default, handler: sureHandle)
    
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        sureAction.setValue(btnColor, forKey: "_titleTextColor")
        cancelAction.setValue(color99, forKey: "_titleTextColor")
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func commonSureAlertAction(sureStr: String,cancleStr: String, title: String,content: String,sureHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: title, message: content, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: sureStr, style: .default, handler: sureHandle)
    
        let cancelAction = UIAlertAction.init(title: cancleStr, style: .cancel) { (action) in
            
        }
        sureAction.setValue(btnColor, forKey: "_titleTextColor")
        cancelAction.setValue(color99, forKey: "_titleTextColor")
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

