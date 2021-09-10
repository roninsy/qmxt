//
//  SSTitleAlertView.swift
//  shensuo
//
//  Created by  yang on 2021/6/23.
//

import UIKit
//typealias btnInitBlock = (_ num : Int,_ cntent: String)->()

class SSTitleAlertView: UIView {

    
    let titleL = UILabel.initSomeThing(title: "输入标题", fontSize: 20, titleColor: color33)
    let cancleBtn = UIButton.init()
    let sureBtn = UIButton.init()
    let bottomV = UIView()
    let lineV = UIView.init()
    var btnBlcok: stringBlock? = nil
    
    var comTextView:UITextView = {
        let com = UITextView.init()
        var placeHolderLabel = UILabel.init()
        placeHolderLabel.text = "输入标题"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = color99
        placeHolderLabel.sizeToFit()
        com.addSubview(placeHolderLabel)
        com.font = .systemFont(ofSize: 18)
        placeHolderLabel.font = .systemFont(ofSize: 18)
        com.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        com.layer.masksToBounds = true;
        com.layer.borderWidth = 1.0;
        com.layer.cornerRadius = 4
        com.layer.borderColor = bgColor.cgColor
        
        return com
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI()  {
        
        addSubview(titleL)
        titleL.font = UIFont.MediumFont(size: 20)
        
        addSubview(bottomV)
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        bottomV.backgroundColor = bgColor
        
        setNormalBtn(textColor: color66, title: "取消", target: self, action: #selector(btnAction(btn:)), btn: cancleBtn, font: UIFont.systemFont(ofSize: 20),btnTag: 1)
        bottomV.addSubview(cancleBtn)
        
        
        setNormalBtn(textColor: btnColor, title: "确定", target: self, action: #selector(btnAction(btn:)), btn: sureBtn, font: UIFont.systemFont(ofSize: 20),btnTag: 2)
        bottomV.addSubview(sureBtn)
       
        addSubview(comTextView)
       
        lineV.backgroundColor = bgColor
        bottomV.addSubview(lineV)
        youtSubviews()
    }
    
    @objc func btnAction(btn: UIButton) {
       
        btnBlcok?(btn.tag == 1 ? "取消" : comTextView.text)
    }
    
    func setNormalBtn(textColor: UIColor,title: String,target: Any,action: Selector,btn: UIButton,font: UIFont,btnTag: Int) {
        
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(textColor, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.titleLabel?.font = font
        btn.tag = btnTag
        
    }
    
     func youtSubviews() {
//        super.layoutSubviews()
        titleL.snp.makeConstraints { make in
            
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
        }
        bottomV.snp.makeConstraints { make in
            
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        cancleBtn.snp.makeConstraints { make in
            
            make.leading.bottom.top.equalToSuperview()
            make.width.equalTo(self.ll_w / 2 - 0.25)
            
        }
        sureBtn.snp.makeConstraints { make in
            
            make.trailing.bottom.top.equalToSuperview()
            make.width.equalTo(cancleBtn)
            
        }
        lineV.snp.makeConstraints { make in
            
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        comTextView.snp.makeConstraints { make in
            
            make.height.equalTo(83)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.center.equalToSuperview()
            
        }
    }
    
}
