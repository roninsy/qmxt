//
//  InputBodyInfoVCViewController.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/24.
//

import UIKit

class InputBodyInfoVC: HQBaseViewController {

    let mainView = InputBodyInfoView()
    ///
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        HQPushActionWith(name: "body_data_input_view", dic: ["":""])
    }
    

}
