//
//  HQWebVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/26.
//

import UIKit
import WebKit

class HQWebVC: HQBaseViewController,WKScriptMessageHandler {

    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    var url = ""
    var webView = WKWebView()
    var isFullScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let theConfiguration = WKWebViewConfiguration.init()
        theConfiguration.userContentController.add(self, name: "jsPushView")
        theConfiguration.userContentController.add(self, name: "jsHideHead")
        theConfiguration.userContentController.add(self, name: "jsHideBottom")
        theConfiguration.userContentController.add(self, name: "jsBackAction")
        self.webView = WKWebView.init(frame: CGRect(x: 0
                                                    , y: 0
                                                    , width: screenWid
                                                    , height: screenHei), configuration: theConfiguration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.bounces = false
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.top.equalTo(NavStatusHei + 40)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
        
        self.view.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalTo(backBtn)
            make.height.equalTo(24)
        }
        
        self.view.addSubview(webView)
        webView.snp.remakeConstraints { (make) in
            make.top.equalTo(backBtn.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFullScreen {
            backBtn.isHidden = true
            self.titleLab.isHidden = true
            webView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        webView.load(URLRequest.init(url: URL.init(string: url)!))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsPushView" {
            let dic = message.body as? NSDictionary
            if dic != nil {
                let type = dic!["type"] as? Int ?? 0
                if type == 3 {
                    let cid = dic!["id"] as? String ?? ""
                    ///跳转方案详情
                    let vc = ProjectDetalisVC()
                    vc.cid = cid
                    HQPush(vc: vc, style: .lightContent)
                }
            }
        }else if message.name == "jsHideHead" {
            let flag = message.body as? String ?? "false"
            DispatchQueue.main.async {
                self.webView.snp.updateConstraints { make in
                    make.top.equalTo(flag == "true" ? 0 : NavStatusHei)
                }
                HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = flag == "true"
                self.webView.scrollView.isScrollEnabled = flag != "true"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.webView.scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
                }
            }
            
        }else if message.name == "jsHideBottom" {
            let flag = message.body as? String ?? "false"
            DispatchQueue.main.async {
                self.webView.snp.updateConstraints { make in
                    make.top.equalTo(NavStatusHei)
                    make.bottom.equalTo(flag == "true" ? 0 : -(SafeBottomHei + 49))
                }
                self.webView.scrollView.isScrollEnabled = true
                HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = flag == "true"
            }
            
        }else if message.name == "jsBackAction" {
            let dic = message.body as? NSDictionary
            if dic != nil {
                let type = dic!["type"] as? Int ?? 0
                if type == 1 {
                    var url = dic!["url"] as? String
                    if url == nil {
                        url = "\(ProjectHomeURL)?height=\(screenHei)"
                    }
                    webView.load(.init(url: URL.init(string: url!)!))
                    
                }else if type == 2 {
                    HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    deinit {
        self.webView.configuration.userContentController.removeAllUserScripts()
    }
    

}
