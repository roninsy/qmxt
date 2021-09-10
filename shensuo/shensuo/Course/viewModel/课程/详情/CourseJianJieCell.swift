//
//  KeChengJianJieCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/26.
//

import UIKit
import WebKit

class CourseJianJieCell: UITableViewCell,WKNavigationDelegate {
    ///0\课程简介、1、课程目录
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
    let webview = WKWebView()
    let setpView = CourseSetupListView()
    let botLine = UIView()
    
    var webFinishBlock : voidBlock?
    var htmlStr : String? = nil{
        didSet{
            if htmlStr != nil{
                webview.loadHTMLString(htmlStr!, baseURL: nil)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.backgroundColor = .clear
        
        webview.frame = .init(x: 16, y: 10, width: screenWid - 32, height: 100)
        webview.navigationDelegate = self
        webview.backgroundColor = .white
//        webview.isUserInteractionEnabled = false
        self.contentView.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(10)
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var webheight = 0.0
        self.webview.scrollView.isScrollEnabled = true
        // 获取内容实际高度
        self.webview.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
                webview.snp.updateConstraints { make in
                    make.height.equalTo(webheight)
                }
                let moreHei : Double = tempHeight > 500 ? 10 : 0
                self.webHei = CGFloat(webheight + 10 + 22 + moreHei)
                self.webFinishBlock?()
            }
        }
    }
}
