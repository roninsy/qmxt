//
//  SearchVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit
import MBProgressHUD

class SearchVC: HQBaseViewController {

    var mainView = SearchListView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.mainView.pageNum = 1
        self.mainView.getNetInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: false)
        }
    }
    
    deinit {
        mainView.removeFromSuperview()
    }
}
