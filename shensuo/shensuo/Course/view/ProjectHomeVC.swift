//
//  ProjectHomeVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/18.
//方案首页

import UIKit
///方案首页
class ProjectHomeVC: HQBaseViewController {
    let mainView = ProjectMainView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalToSuperview()
        }

        let url = "\(ProjectHomeURL)?height=\(screenHei)&iosView=\(mainView.bannerHei)"
        mainView.webview.load(.init(url: URL.init(string: url)!))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = self.mainView.isHideBottom

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.mainView.bannerView.getNetInfo()
        if UserInfo.getSharedInstance().projectTipStudy && UserInfo.getSharedInstance().token != userDefultToken{
            AddStudyTipView(type: 1)
        }
        
    }
    

}
