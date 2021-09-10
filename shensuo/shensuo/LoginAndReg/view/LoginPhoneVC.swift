//
//  LoginPhoneVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/13.
//

import UIKit

class LoginPhoneVC: HQBaseViewController {
    let mainView = LoginPhoneView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
