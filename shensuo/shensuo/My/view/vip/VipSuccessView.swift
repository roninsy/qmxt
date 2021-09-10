//
//  VipSuccessView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/13.
//

import UIKit

class VipSuccessView: UIView {

    let backBtn = UIButton.initWithBackBtn(isBlack: true)
    let titleLab = UILabel.initSomeThing(title: "开通成功", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    let topIMg = UIImageView.initWithName(imgName: "vip_success")
    let successLab = UILabel.initSomeThing(title: "开通成功", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 24), ali: .center)
    
    let timeLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 15), ali: .center)
    
    let shareBtn = UIButton.initTitle(title: "分享到动态", fontSize: 18, titleColor: .white)
    
    let backBtn2 = UIButton.initWithLineBtn(title: "返回", font: .systemFont(ofSize: 18), titleColor: .init(hex: "#333333"), bgColor: .white, lineColor: .init(hex: "#CBCCCD"), cr: 22)
    
    let shareView = ShareForVipView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(51)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
//            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        backBtn2.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
//            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalTo(backBtn)
        }
        
        self.addSubview(topIMg)
        topIMg.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(65 + NavStatusHei)
            make.height.equalTo(screenWid / 414 * 367)
        }
        
        self.addSubview(successLab)
        successLab.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topIMg).offset(224)
            make.height.equalTo(33)
        }
        
        self.addSubview(timeLab)
        timeLab.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topIMg).offset(265)
            make.height.equalTo(21)
        }
        
        shareBtn.layer.cornerRadius = 22
        shareBtn.layer.masksToBounds = true
        shareBtn.backgroundColor = .init(hex: "#FD8024")
        self.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { make in
            make.width.equalTo(297)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.top.equalTo(topIMg.snp.bottom).offset(-10)
        }
        shareBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.shareToImg()
        }
        
        self.addSubview(backBtn2)
        backBtn2.snp.makeConstraints { make in
            make.width.equalTo(297)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.top.equalTo(shareBtn.snp.bottom).offset(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shareToImg(){
        
        self.addSubview(shareView)
        shareView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let vc = SSReleaseNewsViewController()
            vc.shareImg = getImageFromView(view: self.shareView.whiteBG)
            vc.inType = 8
            HQPush(vc: vc, style: .default)
            self.removeFromSuperview()
        }
    }
}
