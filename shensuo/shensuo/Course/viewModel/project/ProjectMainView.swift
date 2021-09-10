//
//  ProjectMainView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/18.
//

import UIKit
import MBProgressHUD
import WebKit

class ProjectMainView: UIView, WKScriptMessageHandler, WKNavigationDelegate,UIScrollViewDelegate {
    ///正在加载中
    var inload = true
    //    签到视图
    let qianDaoV = QianDaoView()
    //    搜索逻辑
    let searchView = HQSearchView()
    
    ///轮播视图
    let bannerView = BannerView.init()
    let searchBG = UIView()
    var whiteBg = UIView()
    
    let bannerWid = screenWid - 24
    let bannerHei = (screenWid - 24) / 394 * 168
    
    var webview = WKWebView()
    
    var isHideBottom = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        searchBG.backgroundColor = .white
        self.addSubview(searchBG)
        searchBG.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.height.equalTo(62)
            make.right.equalTo(0)
            make.top.equalTo(NavStatusHei)
        }
        
        searchView.nameTf.text = "热门方案"
        searchView.selIndex = 1
        searchBG.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.height.equalTo(52)
            make.right.equalTo(-54)
            make.top.equalTo(0)
        }
        searchBG.addSubview(qianDaoV)
        qianDaoV.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(-11)
            make.centerY.equalTo(searchView)
        }
        
        let theConfiguration = WKWebViewConfiguration.init()
        theConfiguration.userContentController.add(self, name: "jsPushView")
        theConfiguration.userContentController.add(self, name: "jsHideHead")
        theConfiguration.userContentController.add(self, name: "jsHideBottom")
        theConfiguration.userContentController.add(self, name: "jsBackAction")
        self.webview = WKWebView.init(frame: CGRect(x: 0
                                                    , y: 0
                                                    , width: screenWid
                                                    , height: screenHei), configuration: theConfiguration)
        self.addSubview(webview)
        webview.snp.makeConstraints { make in
            make.top.equalTo(NavStatusHei + 62)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-(SafeBottomHei + 49))
        }
        webview.scrollView.contentInsetAdjustmentBehavior = .never
//        webview.scrollView.bounces = false
        webview.scrollView.delegate = self
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.navigationDelegate = self
        
        
        bannerView.layer.cornerRadius = 9
        bannerView.layer.masksToBounds = true
        
        whiteBg = UIView.init(frame: .init(x: 0, y: 0, width: screenWid, height: bannerHei + 10))
        whiteBg.backgroundColor = .white
        webview.scrollView.addSubview(whiteBg)
        whiteBg.backgroundColor = .white
        whiteBg.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(12)
            make.width.equalTo(bannerWid)
            make.height.equalTo(bannerHei)
        }
        bannerView.type = 3

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsPushView" {
            let dic = message.body as? NSDictionary
            if dic != nil {
                let type = dic!["type"] as? Int ?? 0
                if type == 3 {
                    let cid = dic!["id"] as? String ?? ""
                    let title = dic!["title"] as? String ?? ""
                    let parentId = dic!["parentId"] as? String ?? ""
                    ///跳转方案详情
                    let vc = ProjectDetalisVC()
                    vc.cid = cid
                    ///上报事件
                    HQPushActionWith(name: "click_course_detail", dic:  ["current_page":"方案瀑布流",
                                                                         "course_frstcate":parentId,
                                                                             "course_secondcate":"",
                                                                             "course_id":cid,
                                                                             "course_title":title])
                    HQPush(vc: vc, style: .lightContent)
                }else if type == 2{
                    ///跳转方案搜索
                    let vc = SearchCourseVC()
                    vc.mainView.viewType = 1
                    HQPush(vc: vc, style: .default)
                }else if type == 1{
                    ///跳转我的方案
                    GotoTypeVC(type: 19, cid: UserInfo.getSharedInstance().userId ?? "")
                }
            }
        }else if message.name == "jsHideHead" {
            let flag = message.body as? String ?? "false"
            self.whiteBg.isHidden = flag == "true"
            self.searchBG.isHidden = flag == "true"
            DispatchQueue.main.async {
                self.webview.snp.updateConstraints { make in
                    make.top.equalTo(flag == "true" ? 0 : NavStatusHei + 62)
                    make.bottom.equalTo(flag == "true" ? 0 : -(SafeBottomHei + 49))
                }
                HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = flag == "true"
                self.isHideBottom = flag == "true"
                self.webview.scrollView.isScrollEnabled = flag != "true"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.webview.scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
                }
            }
            
        }else if message.name == "jsHideBottom" {
            let flag = message.body as? String ?? "false"
            self.inload = flag == "true"
            DispatchQueue.main.async {
                self.webview.snp.updateConstraints { make in
                    make.top.equalTo(flag == "true" ? NavStatusHei : NavStatusHei + 62)
                    make.bottom.equalTo(flag == "true" ? 0 : -(SafeBottomHei + 49))
                }
                self.webview.scrollView.isScrollEnabled = true
                HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = flag == "true"
                self.isHideBottom = flag == "true"
                self.whiteBg.isHidden = flag == "true"
                self.searchBG.isHidden = flag == "true"
            }
            
        }else if message.name == "jsBackAction" {
            self.inload = false
            let dic = message.body as? NSDictionary
            if dic != nil {
                let type = dic!["type"] as? Int ?? 0
                if type == 1 {
                    var url = dic!["url"] as? String
                    if url == nil {
                        url = "\(ProjectHomeURL)?height=\(screenHei)&iosView=\(self.bannerHei)"
                    }
                    webview.load(.init(url: URL.init(string: url!)!))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let token = UserInfo.getSharedInstance().token ?? "error"
                        self.webview.evaluateJavaScript("isOpen('\(token)')") { (data, error) in
                            
                        }
                    }
                }
            }
        }
    }
    deinit {
        self.webview.configuration.userContentController.removeAllUserScripts()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.inload = false
        }
        
        let token = UserInfo.getSharedInstance().token ?? "error"
        self.webview.evaluateJavaScript("isOpen('\(token)')") { (data, error) in
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.inload {
            return
        }
        if scrollView.contentOffset.y < -100 {
            self.inload = true
            let url = "\(ProjectHomeURL)?height=\(screenHei)&iosView=\(bannerHei)"
            self.webview.load(.init(url: URL.init(string: url)!))
        }
    }
    
    
}
