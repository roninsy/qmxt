//
//  GiftRankVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/28.
//

import UIKit

class GiftRankVC: HQBaseViewController {
    
    let mainView = GiftRankListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getNetInfo), name: ProjectIsSendGiftNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainView.getNetInfo()
        self.mainView.getUserRanking()
    }
    
    @objc func getNetInfo(){
        self.mainView.page = 1
        self.mainView.getNetInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
