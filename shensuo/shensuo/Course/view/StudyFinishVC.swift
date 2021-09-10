//
//  StudyFinishView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/29.
//

import UIKit

class StudyFinishVC: HQBaseViewController {
    let mainView = StudyFinishView()
    
    let mainView2 = StudyUnfinishView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    ///显示中途退出页面
    func showUnfinish(){
        self.mainView.removeFromSuperview()
        self.view.addSubview(mainView2)
        
        mainView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
