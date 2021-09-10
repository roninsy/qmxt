//
//  ShareVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/2.
//

import UIKit

class ShareVC: HQBaseViewController {
    
    ///0 二维码名片 1.课程。10、方案 2。分享徽章 3.分享礼物间 4.动态 5.vip 6.徽章墙 7、美丽日记 8、美丽相册
    var type = 0
    
    var model = CourseDetalisModel()
    var giftModel = GiftRankModel()
    var notesModel = SSNotesDetaileModel()
    var xqModel:SSXCXQModel = SSXCXQModel()
    var medalModel = SSNotesBadgesModel()
    var onlyShare = false
    var medalModels : [badgeCateGoryModel] = NSArray() as! [badgeCateGoryModel]
    
    var medalGetNum = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    
    @objc func setupMainView(){
        var mainView = UIView()
        if type == 0 {
            mainView = ShareForInfoView()
        }else if type == 1 || type == 10{
            mainView = ShareForProjectView()
            (mainView as! ShareForProjectView).detalisModel = self.model
            (mainView as! ShareForProjectView).onlyShare = self.onlyShare
        }else if type == 2{
            mainView = ShareForMedalView()
            (mainView as! ShareForMedalView).medalModel = self.medalModel
        }else if type == 3{
            mainView = ShareForProjectView()
            (mainView as! ShareForProjectView).giftModel = self.giftModel
            (mainView as! ShareForProjectView).isGiftRoom = true
        }else if type == 4{
            mainView = ShareForProjectView()
            (mainView as! ShareForProjectView).notesModel = self.notesModel
        }else if type == 5{
            mainView = ShareForVipView()
        }else if type == 6{
            mainView = ShareForMedalListView()
            (mainView as! ShareForMedalListView).models = self.medalModels
            (mainView as! ShareForMedalListView).medalGetNum = self.medalGetNum
        }else if type == 7 || type == 8{
            mainView = ShareForProjectView()
            (mainView as! ShareForProjectView).type = self.type
            (mainView as! ShareForProjectView).xqModel = self.xqModel
        }
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
