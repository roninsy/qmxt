//
//  SearchCourseVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/8.
//

import UIKit

class SearchCourseVC: HQBaseViewController {
    
    let mainView = SearchCourseView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
