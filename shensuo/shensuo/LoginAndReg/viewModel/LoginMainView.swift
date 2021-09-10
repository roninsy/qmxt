//
//  LoginMainView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/16.
//

import UIKit
import BSText
import SCLAlertView
import RxCocoa
import RxSwift
import Toast_Swift
import SwiftyJSON
import KakaJSON
import MBProgressHUD
import SwiftyUserDefaults

class LoginMainView: UIView {
    let agreeImg = UIImageView.initWithName(imgName: "login_disagree")
    var agreeBtn : UIButton = UIButton()
    let appleSignBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "login_apple"))
    let phoneBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "login_phone"))
    let bgView = UIImageView.initWithName(imgName: "login_bg")
    
    let otherLoginLabel = UILabel.initSomeThing(title: "-----其他登录方式-----", fontSize: 15, titleColor: .white)
    let userProtocolLabel = BSLabel()
    let wechatBtn = UIButton.initBGImgAndTitle(img: UIImage.init(named: "login_btn_bg")!, title: "微信一键登录", font: .MediumFont(size: 18), titleColor: .white,space: 1.78)
   
    let appleBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "login_apple"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    初始化页面
    func setupUI() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let protocolText = NSMutableAttributedString(string: "我已阅读并同意《全民形体用户协议》和《隐私协议》")
        userProtocolLabel.textColor = .white
        protocolText.bs_set(color: .white, range: NSRange.init(location: 0, length: 7))
        protocolText.bs_set(color: .white, range:  NSRange.init(location: 17, length: 1))
        protocolText.bs_set(textHighlightRange: NSRange.init(location: 7, length: 10), color: .orange, backgroundColor: .clear) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "全民形体用户协议"
            vc.url = userAgreementURL
            HQPush(vc: vc, style: .default)
        }
        
        protocolText.bs_set(textHighlightRange: NSRange.init(location: 18, length: 6), color: .init(hex: "#FD8024"), backgroundColor: .orange) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "隐私协议"
            vc.url = "https://www.quanminxingti.com/h5/#/userAgreement?hidden=true"
            HQPush(vc: vc, style: .default)
        }
        userProtocolLabel.attributedText = protocolText
        protocolText.bs_font = UIFont.systemFont(ofSize: 13)
        self.addSubview(userProtocolLabel)
        userProtocolLabel.sizeToFit()
        userProtocolLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-74)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(agreeImg)
        agreeImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.right.equalTo(userProtocolLabel.snp.left).offset(-5)
            make.centerY.equalTo(userProtocolLabel)
        }
        
        self.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(54)
            make.center.equalTo(agreeImg)
        }
        
        let btnWid : CGFloat = 48
        self.addSubview(phoneBtn)
        if #available(iOS 13.0, *) {
            let space = (screenWid - btnWid * 2 - 24) / 2
            self.addSubview(appleBtn)
            appleBtn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWid)
                make.right.equalTo(-space)
                make.bottom.equalTo(userProtocolLabel.snp.top).offset(-25)
            }
            
            phoneBtn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWid)
                make.left.equalTo(space)
                make.bottom.equalTo(userProtocolLabel.snp.top).offset(-25)
            }
        }else{
            phoneBtn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWid)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(userProtocolLabel.snp.top).offset(-25)
            }
        }
        otherLoginLabel.textAlignment = .center
        self.addSubview(otherLoginLabel)
        otherLoginLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(phoneBtn.snp.top).offset(-25)
            make.left.right.equalToSuperview()
            make.height.equalTo(18)
        }
        
        wechatBtn.layer.cornerRadius = 29
        wechatBtn.layer.masksToBounds = true
        self.addSubview(wechatBtn)
        wechatBtn.snp.makeConstraints { (make) in
            make.left.equalTo(37)
            make.right.equalTo(-37)
            make.height.equalTo(54)
            make.bottom.equalTo(otherLoginLabel.snp.top).offset(-24)
        }
        ///检测微信是否安装
        if WXApi.isWXAppInstalled() {
            wechatBtn.isHidden = false
        }else{
            wechatBtn.isHidden = true
        }
        
        self.btnClick()
    }
    
    func btnClick(){
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.agreeImg.image = UIImage.init(named: btn.isSelected ? "login_agree" : "login_disagree")
        }
        
        phoneBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            HQPush(vc: LoginPhoneVC(), style: .lightContent)
            
        }
        appleBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            if self.agreeBtn.isSelected == false{
                self.makeToast("请先阅读并同意用户协议")
                return
            }
            if #available(iOS 13.0, *) {
                activityIndicatorView.startAnimating()
                SignWithApple.shared.loginInWithApple { (res, msg) in
                    if res == false{
                        self.makeToast(msg)
                    }
                }
            } else {
                
            }
        }
        
        wechatBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            if self.agreeBtn.isSelected{
               
            }else{
                self.makeToast(ReadTipString)
                return
            }
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "shensuokeji"
            WXApi.sendAuthReq(req, viewController: HQGetTopVC()!, delegate: nil) { (flag) in
                if flag{
                    print("授权成功")
                }
            }
        }
    }
}


