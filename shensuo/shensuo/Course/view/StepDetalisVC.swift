//
//  StepDetalisVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/20.
//

import UIKit

class StepDetalisVC: HQBaseViewController {
    var isPlaying = false
    var appearNum = 0
    var cid : String = ""
    let mainView = StepDetalisView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willInBack), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upGiftRank), name: ProjectIsSendGiftNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willBeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func upGiftRank(){
        self.mainView.topView.giftView.getNetInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        ///禁止滑动返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.getNetInfo()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    func getNetInfo(){
        mainView.getNetInfo(cid: cid)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func willInBack(){
        self.appearNum += 1
        self.isPlaying = self.mainView.topView.playView.playerVC?.isPlaying ?? false
    }
    
    @objc func willBeActive(){
        if self.mainView.topView.playView.playerVC?.playerLayer != nil && self.isPlaying{
            self.mainView.topView.playView.reSeek =  self.mainView.topView.playView.playerVC?.avPlayer?.currentTime().seconds ?? 0
            self.mainView.topView.playView.upPlayUrl()
        }
    }
}
