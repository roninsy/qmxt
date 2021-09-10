//
//  SSTitleWithContentView.swift
//  shensuo
//
//  Created by swin on 2021/3/27.
//

import Foundation
import SnapKit

//MARK: 
class SSTitleWithContentView: UIView {
    
    var titleLabel = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public func initTitleWithContent(title: String, placeHolder: String) -> Void {
        self.backgroundColor = .white
        let line = lineView.init()
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(screenWid)
        }
        
        titleLabel = createTitleLabel()
        titleLabel.text = title
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(screenWid/2)
            make.height.equalToSuperview()
        }
        
        let holder = createPlaceHolder()
        holder.placeholder = placeHolder
        addSubview(holder)
        
        holder.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right)
            make.width.equalTo(screenWid/2)
            make.height.equalToSuperview()
        }
        
        let botLine = lineView.init()
        addSubview(botLine)
        botLine.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
            make.width.equalTo(screenWid)
        }
        
    }
    
    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel.init()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font.withSize(14)
        titleLabel.backgroundColor = .white
        return titleLabel
    }
    
    func createPlaceHolder() -> UITextField {
        let textField = UITextField.init()
        textField.font?.withSize(14)
        textField.textColor = .black
        textField.endEditing(true)
        textField.backgroundColor = .white
        return textField
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


