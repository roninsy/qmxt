//
//  ProjectDetalisVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/1.
//

import UIKit


class ProjectDetalisVC: HQBaseViewController {
    
    var cid : String = ""{
        didSet{
            if cid.length > 0 {
                self.getNetInfo()
            }
        }
    }
    let mainView = ProjectDetalisView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(upGiftRank), name: ProjectIsSendGiftNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addToProject), name: NeedToAddProjectNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        UserInfo.getSharedInstance().showSVGAMsg = true
        
    }
    func getNetInfo(){
        mainView.getNetInfo(cid: cid)
    }
    
    @objc func upGiftRank(){
        self.mainView.topView.giftView.getNetInfo()
    }
    
    @objc func addToProject(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mainView.botView.buyView.buyBlock?()
        }
    }
    
    deinit {
        UserInfo.getSharedInstance().showSVGAMsg = false
        UserInfo.getSharedInstance().tempObj = nil
        NotificationCenter.default.removeObserver(self.mainView.tableview)
        NotificationCenter.default.removeObserver(self.mainView)
        NotificationCenter.default.removeObserver(self)
    }
}
