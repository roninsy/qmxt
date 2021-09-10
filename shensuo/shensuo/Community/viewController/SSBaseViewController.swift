//
//  SSBaseViewController.swift
//  shensuo
//
//  Created by  yang on 2021/3/30.
//

import Foundation

class SSBaseViewController: HQBaseViewController {
    
    var ishideBar:Bool = false  //是否显示底部导航栏
    
    ///返回按钮不响应
    var dontBack = false
    
    var navView:SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
        
        navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            if self.dontBack{
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.ishideBar {
            self.tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.ishideBar {
            self.tabBarController?.tabBar.isHidden = false
        }
        
    }
    
    
    
}
