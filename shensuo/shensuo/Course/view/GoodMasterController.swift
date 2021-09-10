//
//  GoodMasterController.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/7.
//

import UIKit

class GoodMasterController: HQBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    ///根据类型初始化页 1.导师 2.机构
    func setupWithType(type:Int){
        if type == 1 {
            let mainView = GoodMasterListView()
            self.view.addSubview(mainView)
            mainView.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.left.right.bottom.equalToSuperview()
            }
        }else{
            let mainView = GoodCompanyListView()
            self.view.addSubview(mainView)
            mainView.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
}
