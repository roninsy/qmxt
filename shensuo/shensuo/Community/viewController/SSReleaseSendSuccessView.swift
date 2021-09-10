//
//  SSReleaseSendSuccessView.swift
//  shensuo
//
//  Created by  yang on 2021/6/25.
//

import UIKit

class SSReleaseSendSuccessView: SSBaseViewController {

    var badges: SSNotesBadgesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    
        // Do any additional setup after loading the view.
    }
    
    func buildUI() {
        let topBgV = UIImageView.initWithName(imgName: "send_success_bg")
        view.insertSubview(topBgV, belowSubview: navView)
        topBgV.backgroundColor = bgColor
        let bgH: CGFloat = screenWid / 414 * 257
        
        topBgV.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(bgH)
        }
        navView.backBtnWithTitle(title: "")

        navView.backgroundColor = .clear
        navView.backBtn.setImage(UIImage.init(named: "back_write"), for: .normal)
        self.dontBack = true
        self.navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }

       let tipB = UIButton.initTitle(title: "动态发布成功", fontSize: 28, titleColor: .white)
        tipB.titleLabel?.font = .MediumFont(size: 28)
        topBgV.addSubview(tipB)
        tipB.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            
        }
        
        let tipIcon = UIImageView.initWithName(imgName: "send_success")
        
        topBgV.addSubview(tipIcon)
        tipIcon.snp.makeConstraints { make in
            
            make.trailing.equalTo(tipB.snp.leading).offset(-10)
            make.centerY.equalTo(tipB)
        }
        
        
        
        let badgeV = UIView.init()

        badgeV.backgroundColor = .white
        view.addSubview(badgeV)
        badgeV.layer.cornerRadius = 6
        badgeV.layer.masksToBounds = true
        badgeV.snp.makeConstraints { make in
            
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(316)
            make.top.equalTo(topBgV.snp.bottom).offset(-30)
        }
        
        let titleL = UILabel.initSomeThing(title: "恭喜您获得1枚徽章", fontSize: 16, titleColor: color33)
        badgeV.addSubview(titleL)
        titleL.font = UIFont.MediumFont(size: 16)
        titleL.snp.makeConstraints { make in
            
            make.leading.top.equalTo(16)
        }
        
        let badgeIcon = UIImageView.init()
        badgeV.addSubview(badgeIcon)
        badgeIcon.kf.setImage(with: URL(string: badges?.badgeImageUrl ?? ""))
        badgeIcon.snp.makeConstraints { make in
            
            make.height.equalTo(152)
            make.width.equalTo(167)
            make.center.equalToSuperview()
        }
        
        let badgeName = UILabel.initSomeThing(title: badges?.badgeTypeName ?? "", fontSize: 14, titleColor: color33)
        badgeV.addSubview(badgeName)
        badgeName.snp.makeConstraints { make in
            
            make.top.equalTo(badgeIcon.snp.bottom).offset(14)
            make.centerY.equalToSuperview()
        }
        
        let goMy = UIButton.init()
        goMy.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                let vc = SSPersionDetailViewController.init()
                vc.cid = UserInfo.getSharedInstance().userId ?? ""
                self.navigationController?.popToRootViewController(animated: false)
                HQPush(vc: vc, style: .lightContent)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    vc.segmentedView.defaultSelectedIndex = 0
                    vc.segmentedView.reloadData()
                }
            }
        }
        commonBtn(btn: goMy, title: "返回我的主页", titleColor: .white, bordColor: btnColor, bgColor: btnColor)
        view.addSubview(goMy)
        
        goMy.snp.makeConstraints { make in
            
            make.leading.equalTo(badgeV)
            make.top.equalTo(badgeV.snp.bottom).offset(24)
            make.width.equalTo((screenWid - 85)/2)
            make.height.equalTo(45)
        }
        
        let shareBtn = UIButton.init()
        commonBtn(btn: shareBtn, title: "分享", titleColor: color33, bordColor: color33, bgColor: .white)
        view.addSubview(shareBtn)
        
        shareBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(badgeV)
            make.width.top.height.equalTo(goMy)
        }
        
        goMy.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            self?.tabBarController?.tabBar.isHidden = false
            self?.tabBarController?.selectedIndex = 4
        })
        
        shareBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            
        let vc = ShareVC()
        vc.type = 2
            vc.medalModel = self?.badges ?? SSNotesBadgesModel()
        vc.setupMainView()
        HQPush(vc: vc, style: .lightContent)
            
        })
        
    }
    
    func commonBtn(btn: UIButton,title: String,titleColor: UIColor,bordColor: UIColor,bgColor: UIColor) {
        
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = bgColor
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = bordColor.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    }


}
