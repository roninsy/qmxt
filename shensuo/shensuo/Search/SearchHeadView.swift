//
//  SearchHeadView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit
import BSText

class SearchHeadView: UIView,UITextFieldDelegate {
    var searchBlock : stringBlock? = nil
    
    let backBtn = UIButton.initWithBackBtn(isBlack: true)
    
    let grayBG = UIView()
    
    let searchIcon = UIImageView.initWithName(imgName: "searchicon")
    
    let searchTF = UITextField()
    
    let cleanBtn = UIButton.initImgv(imgv: .initWithName(imgName: "search_clean"))
    
    let searchBtn = UIButton.initTitle(title: "搜索", font: .MediumFont(size: 16), titleColor: .init(hex: "#333333"), bgColor: .clear)
    
    let selView = SearchSelTitleListView()
    
    let tipView = BSLabel()
    
    var tipHei : CGFloat = 29
    var myHei : CGFloat = 103 + NavStatusHei
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(NavStatusHei + 15)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        grayBG.backgroundColor = .init(hex: "#EEEFF1")
        grayBG.layer.cornerRadius = 18
        grayBG.layer.masksToBounds = true
        
        self.addSubview(grayBG)
        grayBG.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.equalTo(39)
            make.centerY.equalTo(backBtn)
            make.right.equalTo(-64)
        }
        
        self.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(grayBG)
            make.left.equalTo(grayBG).offset(16)
        }
        
        searchTF.placeholder = "请输入关键词开始搜索"
        searchTF.returnKeyType = .search
        self.addSubview(searchTF)
        searchTF.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(grayBG)
            make.left.equalTo(grayBG).offset(39)
            make.right.equalTo(grayBG).offset(-39)
        }
        searchTF.delegate = self
        searchTF.reactive.controlEvents(.editingChanged).observeValues { tf in
            self.cleanBtn.isHidden = tf.text?.length == 0
        }
        
        self.addSubview(cleanBtn)
        cleanBtn.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalTo(grayBG).offset(-16)
            make.centerY.equalTo(grayBG)
        }
        cleanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.searchTF.text = ""
            btn.isHidden = true
        }
        cleanBtn.isHidden = true
        
        self.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(32)
            make.right.equalTo(0)
            make.centerY.equalTo(grayBG)
        }
        searchBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.searchBlock?(self.searchTF.text ?? "")
            self.tipView.text = "正在搜索"
            self.endEditing(false)
        }
        
        self.addSubview(selView)
        selView.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.left.right.equalToSuperview()
            make.top.equalTo(grayBG.snp.bottom).offset(4)
        }
        
        tipView.textColor = .init(hex: "#B4B4B4")
        tipView.font = .systemFont(ofSize: 14)
        tipView.text = "请输入关键词开始搜索"
        self.addSubview(tipView)
        tipView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(selView.snp.bottom)
        }
        
//        tipView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumAndKeyWord(num:String,keyWords:String){
        let protocolText = NSMutableAttributedString(string: "共搜到\(num)个与“\(keyWords)”相关信息")
        protocolText.bs_color = .init(hex: "#B4B4B4")
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 3, length: num.length))
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 6+num.length, length: keyWords.length))
        tipView.attributedText = protocolText
        tipView.isHidden = keyWords.length == 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBlock?(textField.text ?? "")
        self.tipView.text = "正在搜索"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.endEditing(false)
        }
        return true
    }
}
