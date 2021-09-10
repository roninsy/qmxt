//
//  HQBaseViewController.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/16.
//

import UIKit
import MBProgressHUD

class HQBaseViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MBProgressHUD.hide(for: HQGetTopVC()!.view, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let sview = HQGetTopVC()?.view
        if sview != nil {
            MBProgressHUD.hide(for: sview!, animated: true)
        }
        
    }
}
