//
//  SSSearchView.swift
//  shensuo
//
//  Created by  yang on 2021/4/15.
//

import UIKit

public protocol SSSearchViewDelegate{
    func searchDataWithKeyWord(key:String) -> Void
}


class SSSearchView: UIView,UITextFieldDelegate {
    
    var delegate:SSSearchViewDelegate?
    
    var bgView:UIImageView = {
        let bg = UIImageView.init()
        bg.image = UIImage.init(named: "sousukuang")
        return bg
    }()
    
    
    var searchTextField : UITextField = {
        let search = UITextField.init()
        search.clearButtonMode = .whileEditing
        search.returnKeyType = .join
//        search.rightViewMode = .whileEditing
//        search.becomeFirstResponder()
        return search
    }()
    
    var searchBtn : UIButton = {
        let sBtn = UIButton.init()
        sBtn.setTitle("搜索", for: .normal)
        sBtn.setTitleColor(UIColor.init(hex: "#333333"), for: .normal)
        sBtn.titleLabel?.font = .systemFont(ofSize: 16)
        return sBtn
    }()
    
    var clearBlock: voidBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchBtn.reactive.controlEvents(.touchUpInside).observeValues { [self] (btn) in
            self.searchTextField.resignFirstResponder()
            delegate!.searchDataWithKeyWord(key: searchTextField.text!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(searchBtn)
        
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
//            make.width.equalTo(52)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        addSubview(bgView)
        bgView.isUserInteractionEnabled = true
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.equalTo(36)
            make.right.equalTo(searchBtn.snp.left).offset(-16)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 46, height: 36))
        let searchImage = UIImageView.init(frame: CGRect(x: 20, y: 10, width: 16, height: 16))
        searchImage.image = UIImage.init(named: "searchicon")
        leftView.addSubview(searchImage)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = leftView
        searchTextField.delegate = self
        
//        let rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
//        let closeImage = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 16, height: 16))
//        closeImage.image = UIImage.init(named: "close")
//        rightView.addSubview(closeImage)
//        searchTextField.rightViewMode = .unlessEditing
//        searchTextField.rightView = rightView
        
//        closeImage.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clearTextField))
//        closeImage.addGestureRecognizer(tap)
        
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        clearBlock?()
        return true
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
