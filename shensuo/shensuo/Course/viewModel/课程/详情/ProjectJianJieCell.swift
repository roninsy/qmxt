//
//  ProjectJianJieCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/1.
//
import UIKit

class ProjectJianJieCell: UITableViewCell {
    ///0方案简介、1、方案目录
    var selType = 0{
        didSet{
            if selType == 1 {
                myHei = webHei
                self.webview.isHidden = false
                self.setpView.isHidden = true
            }else{
                myHei = setpView.myHei
                self.webview.isHidden = true
                self.setpView.isHidden = false
            }
        }
    }
    var myHei : CGFloat = 0
    var setupHei : CGFloat = 0
    var webHei :CGFloat = 0
    let webview = UILabel()
    let setpView = CourseSetupListView()
    let botLine = UIView()
    
    var htmlStr : String? = nil{
        didSet{
            if htmlStr != nil{
                do{
//                    let hs = htmlStr?.replacingOccurrences(of: "px", with: "pt")
                    let srtData = htmlStr!.data(using: String.Encoding.unicode, allowLossyConversion: true)!
                    let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]//Tips:Supported four types.
                    let attrStr = try NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
                    webview.attributedText = attrStr
                    let size = webview.sizeThatFits(.init(width: screenWid - 32, height: 100000))
                    webview.snp.updateConstraints { make in
                        make.height.equalTo(size.height)
                    }
                    
                    webHei = size.height + 20 + 22
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.backgroundColor = .clear
        
        webview.numberOfLines = 0
        webview.backgroundColor = .white
        webview.isUserInteractionEnabled = false
        self.contentView.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(20)
            make.width.equalTo(screenWid - 32)
            make.height.equalTo(100)
            make.bottom.equalTo(-22)
        }
        
        self.contentView.addSubview(setpView)
        setpView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-22)
        }
        
        botLine.backgroundColor = .init(hex: "#F7F8F9")
        self.contentView.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
