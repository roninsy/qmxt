//
//  BuyInputView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/26.
//

import UIKit

class BuyInputView: UIView,UITextFieldDelegate {

    var isBuyMeiBi = false
    var enterNumBlock : intBlock? = nil
    let numTF = UITextField()
    let numTFBG = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        numTFBG.layer.cornerRadius = 18
        numTFBG.layer.masksToBounds = true
        numTFBG.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(numTFBG)
        numTFBG.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(36)
        }
        numTF.font = .systemFont(ofSize: 14)
        numTF.keyboardType = .numberPad
        numTF.textColor = .init(hex: "#333333")
        numTF.placeholder = "请输入赠送数量"
        self.addSubview(numTF)
        numTF.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.top.bottom.equalTo(numTFBG)
            make.right.equalTo(-18)
        }
        numTF.delegate = self
        numTF.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let num = textField.text?.toDouble
        if num != nil {
            if isBuyMeiBi {
                if num! > 50000 {
                    HQGetTopVC()?.view.makeToast("超出最大限制")
                    return
                }
                self.enterNumBlock?(Int(num! * 100.0))
            }else{
                if num! > 999 {
                    HQGetTopVC()?.view.makeToast("超出最大限制")
                    return
                }
                self.enterNumBlock?(Int(num!))
            }
            
        }
        self.isHidden = true
        self.removeFromSuperview()
    }
    
}
