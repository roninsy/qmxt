//
//  CoureseLearnNumsVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/17.
//

import UIKit

class CoureseLearnNumsVC: HQBaseViewController {
    var cid : String = ""{
        didSet{
            if cid.count > 0 {
                mainView.cid = cid
            }
        }
    }
    let mainView = CourseLearnNumsView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
        self.mainView.getNetInfo()
    }

}
