//
//  SSBeautiReusableView.swift
//  shensuo
//
//  Created by  yang on 2021/5/5.
//

import UIKit

class SSBeautiReusableView: UICollectionReusableView {
    
    var navView:SSBaseNavView = {
        let nav = SSBaseNavView.init()
        return nav
    }()
    
    let bgImageView = UIImageView.initWithName(imgName: "bt_bg")
    let layerImage = UIImageView.initWithName(imgName:"bt_mh")
    
    var infoImageView:UIImageView = {
        let infoImage = UIImageView.init()
        infoImage.backgroundColor = .white
        infoImage.isUserInteractionEnabled = true
        infoImage.layer.masksToBounds = true
        infoImage.layer.cornerRadius = 5
        return infoImage
    }()
    
    let titleLabel = UILabel.initSomeThing(title: "美币余额", isBold: false, fontSize: 16, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    let valueLabel = UILabel.initSomeThing(title: "5000", isBold: true, fontSize: 36, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    let buyBtn = UIButton.init()
    
    var mainMeiBiView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
        navView.backWithTitleOptionBtn(title: "美币魔盒", option: "美币任务")
    }
    
    func buildUI() -> Void {
        addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*320)
        }
        
        bgImageView.addSubview(navView)
        navView.backgroundColor = .clear
        navView.backBtn.setImage(UIImage.init(named: "back_white"), for: .normal)
        navView.titleLabel.textColor = .white
        navView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(48)
            make.height.equalTo(44)
        }
        
        bgImageView.addSubview(layerImage)
        layerImage.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(screenWid/414*134)
        }
        
        bgImageView.addSubview(infoImageView)
        infoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-16)
        }
        
        infoImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
        
        infoImageView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        infoImageView.addSubview(buyBtn)
        buyBtn.setTitle("购买美币", for: .normal)
        buyBtn.setTitleColor(.init(hex: "#333333"), for: .normal)
        buyBtn.setImage(UIImage.init(named: "bt_buy"), for: .normal)
        buyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(22)
            make.bottom.equalTo(-15)
        }
        buyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            
            ///上报事件
            HQPushActionWith(name: "click_to_buy_coin", dic: ["current_page":"美币魔盒"])
            
            DispatchQueue.main.async {
                self.mainMeiBiView = UIView()
                HQGetTopVC()?.view.addSubview(self.mainMeiBiView)
                self.mainMeiBiView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                let botView = UIView()
                botView.backgroundColor = .init(hex: "#221F25")
                self.mainMeiBiView.addSubview(botView)
                botView.snp.makeConstraints { make in
                    make.height.equalTo(400 + SafeBottomHei)
                    make.bottom.left.right.equalToSuperview()
                }
                
                let buyMeiBiView = BuyMeiBiView()
                botView.addSubview(buyMeiBiView)
                buyMeiBiView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                buyMeiBiView.coinNumLab.text = "余额：\(UserInfo.getSharedInstance().points ?? 0)美币"
                
                let cancelBtn = UIButton()
                cancelBtn.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.mainMeiBiView.addSubview(cancelBtn)
                cancelBtn.snp.makeConstraints { make in
                    make.top.right.left.equalToSuperview()
                    make.bottom.equalTo(botView.snp.top)
                }
                cancelBtn.reactive.controlEvents(.touchUpInside)
                    .observeValues { btn in
                        self.mainMeiBiView.isHidden = true
                        self.mainMeiBiView.removeFromSuperview()
                    }
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
