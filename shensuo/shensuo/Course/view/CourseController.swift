//
//  KeChengController.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/5.
//

import UIKit
import MBProgressHUD

class CourseController: HQBaseViewController {
    let mainView = CourseView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.right.bottom.equalToSuperview()
        }
        mainView.getNetInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .default
        if UserInfo.getSharedInstance().courseTipStudy && UserInfo.getSharedInstance().token != userDefultToken{
            AddStudyTipView(type: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    

}
