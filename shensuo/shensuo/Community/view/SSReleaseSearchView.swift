//
//  SSReleaseSearchView.swift
//  shensuo
//
//  Created by  yang on 2021/6/23.
//

import UIKit

class SSReleaseSearchView: UIView ,UITextFieldDelegate{
    
    let searchBtn = UIButton.init()
    let bgView = UIView()
    var logo: UIImageView!
    var searchTf = UITextField.init()
    let close = UIButton.init()
    var searchBlcok: stringBlock? = nil
    var cancleBlcok: voidBlock? = nil

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgView)
        bgView.layer.cornerRadius = 18
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .init(hex: "#EEEFF1")
        
        self.addSubview(searchBtn)
        searchBtn.setTitle("取消", for: .normal)
        searchBtn.setTitleColor(color33, for: .normal)
        searchBtn.titleLabel?.font = UIFont.MediumFont(size: 16)
        searchBtn.addTarget(self, action: #selector(cancleBtnAction), for: .touchUpInside)
        
        logo = UIImageView.initWithName(imgName: "searchicon")
        bgView.addSubview(logo)
        
        close.setImage(UIImage.init(named: "icon-shanchu"), for: .normal)
        bgView.addSubview(close)
        close.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        
        bgView.addSubview(searchTf)
        searchTf.textColor = color33
//        searchTf.clearButtonMode = .never
        searchTf.borderStyle = .none
        searchTf.delegate = self
        searchTf.placeholder = "请输入地点"
        searchTf.returnKeyType = .done
        
        
    }
    
   @objc func cancleBtnAction()  {
        
        cancleBlcok?()
    }
    
    @objc func closeBtnAction() {
        
        self.searchTf.text = ""
        searchBtnAction()
    }
    
     func searchBtnAction()  {
    
        searchBlcok?(searchTf.text ?? "")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        logger.info("搜索点击")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchBtnAction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.searchBtnAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(-11)
            make.centerY.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.centerY.equalTo(searchBtn)
            make.height.equalTo(36)
            make.trailing.equalTo(searchBtn.snp.leading).offset(-16)
            
        }
        
        logo.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        close.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        searchTf.snp.makeConstraints { (make) in
            make.leading.equalTo(logo.snp.trailing).offset(10)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(close.snp.leading).offset(-10)
        }
        
    }

}
