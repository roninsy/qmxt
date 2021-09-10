//
//  RegistView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/13.
//

import UIKit
import BSText
import SCLAlertView
import MBProgressHUD
import SwiftyUserDefaults
//import SensorsAnalyticsSDK

class RegistView: UIView {
    var countryDic : NSDictionary? = nil{
        didSet{
            if countryDic != nil {
                countryLab.text = String.init(format: "%@(+%@) >", countryDic!["name"] as? String ?? "",countryDic!["code"] as? String ?? "")
            }
        }
    }
    let agreeImg = UIImageView.initWithName(imgName: "login_disagree")
    var agreeBtn : UIButton = UIButton()
    let userProtocolLabel = BSLabel()
    let bgView = UIImageView.initWithName(imgName: "login_bg")
    
    let bgView2 = UIView()
    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "back_white"))
    
    let tipLab = UILabel.initSomeThing(title: "注册", titleColor: .white, font: .SemiboldFont(size: 26), ali: .left)
    
    let countryBG = UIImageView.initWithName(imgName: "login_phone_bg")
    let countryTip = UILabel.initSomeThing(title: "国家地区", titleColor: .white, font: .systemFont(ofSize: 20), ali: .left)
    let countryLab = UILabel.initSomeThing(title: "中国大陆(+86) >", titleColor: .white, font: .systemFont(ofSize: 20), ali: .right)
    let countryBtn = UIButton()
    
    let phoneBG = UIImageView.initWithName(imgName: "login_phone_bg")
    
    let sendCodeBtn = UIButton.initBGImgAndTitle(img: UIImage.init(named: "login_btn_bg")!, title: "获取验证码", font: .MediumFont(size: 18), titleColor: .white,space: 1.78)
    
    let phoneTF = UITextField()
    
    let regPhone = UIButton.initTitle(title: "手机号登录", fontSize: 16, titleColor: .init(hex: "#727B8B"))
    
    lazy var input : InputCodeView = { () -> InputCodeView in
        let input = InputCodeView()
        self.superview?.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        input.sendCodeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            if input.passTF.isHidden{
                self.endEditing(true)
                self.sendCode()
                
            }else{
                self.enterToRegist()
            }
           
        }
        return input
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgView2.backgroundColor = .black
        bgView2.alpha = 0.29
        self.addSubview(bgView2)
        self.bgView2.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        phoneBG.alpha = 0.25
       
        phoneTF.attributedPlaceholder = NSAttributedString(string: "请输入手机号码", attributes: [
            NSAttributedString.Key.foregroundColor: HQColor(r: 255, g: 255, b: 255, a: 0.6)
                ])
        phoneTF.textColor = .white
        phoneTF.font = .MediumFont(size: 20)
      
        phoneTF.keyboardType = .numberPad

        phoneTF.delegate = self
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(NavStatusHei + 20)
        }
        
        self.addSubview(tipLab)
        tipLab.snp.makeConstraints { (make) in
            make.left.equalTo(37)
            make.right.equalTo(-37)
            make.height.equalTo(37)
            make.top.equalTo(NavStatusHei  + 114)
        }
        
        ///选择地区相关--------start-----------
        countryBG.alpha = 0.25
        self.addSubview(countryBG)
        countryBG.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.height.equalTo(58)
            make.top.equalTo(tipLab.snp.bottom).offset(56)
        }
        self.addSubview(countryTip)
        countryTip.snp.makeConstraints { (make) in
            make.left.equalTo(countryBG).offset(24)
            make.width.equalTo(100)
            make.top.bottom.equalTo(countryBG)
        }
        
        self.addSubview(countryLab)
        countryLab.snp.makeConstraints { (make) in
            make.right.equalTo(countryBG).offset(-24)
            make.left.equalTo(countryTip.snp.right)
            make.top.bottom.equalTo(countryBG)
        }
        self.addSubview(countryBtn)
        countryBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(countryBG)
        }
        countryBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let selView = SelCountryNumView()
            self.addSubview(selView)
            selView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            selView.getNumListInfo()
            selView.selBlock = { index in
                self.countryDic = selView.dicArr[index]
                selView.isHidden = true
                selView.removeFromSuperview()
            }
        }
        ///选择地区相关--------end-----------
        
        self.addSubview(phoneBG)
        phoneBG.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.height.equalTo(58)
            make.top.equalTo(countryBG.snp.bottom).offset(32)
        }
        
        self.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBG).offset(24)
            make.right.equalTo(phoneBG).offset(-24)
            make.top.bottom.equalTo(phoneBG)
        }
        
        self.addSubview(sendCodeBtn)
        sendCodeBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.top.equalTo(phoneBG.snp.bottom).offset(47)
            make.height.equalTo(54)
        }
        
        
        regPhone.sizeToFit()
        self.addSubview(regPhone)
        regPhone.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(sendCodeBtn.snp.bottom).offset(24)
        }
        
        let protocolText = NSMutableAttributedString(string: "我已阅读并同意《全民形体用户协议》和《隐私政策》")
        userProtocolLabel.textColor = .init(hex: "#6A7587")
        protocolText.bs_set(color: .init(hex: "#6A7587"), range: NSRange.init(location: 0, length: 7))
        protocolText.bs_set(color: .white, range:  NSRange.init(location: 17, length: 1))
        protocolText.bs_set(textHighlightRange: NSRange.init(location: 7, length: 10), color: .orange, backgroundColor: .clear) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "全民形体用户协议"
            vc.url = userAgreementURL
            HQPush(vc: vc, style: .default)
        }
        
        protocolText.bs_set(textHighlightRange: NSRange.init(location: 18, length: 6), color: .init(hex: "#FD8024"), backgroundColor: .orange) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "隐私政策"
            vc.url = privacyPolicyURL
            HQPush(vc: vc, style: .default)
        }
        userProtocolLabel.attributedText = protocolText
        userProtocolLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(userProtocolLabel)
        userProtocolLabel.sizeToFit()
        userProtocolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(regPhone.snp.bottom).offset(24)
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
        
        self.btnClick()
        
//        SensorsAnalyticsSDK.sharedInstance()?.track("RegisterView", withProperties: ["page_title" : "login"])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(){
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.agreeImg.image = UIImage.init(named: btn.isSelected ? "login_agree" : "login_disagree")
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.isHidden = true
        }
        
        sendCodeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.endEditing(true)
            self.sendCode()
        }
    }
    func sendCode() {
        if !self.agreeBtn.isSelected{
            self.makeToast("请先同意用户协议")
            return
        }
        let phone = self.phoneTF.text ?? ""
//        if phone.length < 11{
//            self.makeToast("请输入正确的手机号")
//            return
//        }
        input.RACTimer()
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
        
        UserNetworkProvider.request(.sendCode(areaCode:areaCode,phone:phone,isReg:true)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.input.isHidden = false
                            self.input.mobile = phone
                            self.input.areaCode = areaCode
                            self.input.textFeildArr[0].becomeFirstResponder()
                        }else{
                            
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    ///用户确认注册
    func enterToRegist(){
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
        
        UserNetworkProvider.request(.regist(areaCode:areaCode,mobile: phoneTF.text!, password: self.input.passTF.text!, code: self.input.codeStr)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.makeToast("注册成功，正在登录")
                            let userNameKey = DefaultsKey<String?>(userNameKeyString)
                            let userPassKey = DefaultsKey<String?>(userPassKeyString)
                            Defaults[key: userNameKey] = self.phoneTF.text!
                            Defaults[key: userPassKey] = self.input.passTF.text!
                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                        }else{
                            
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
}

extension RegistView : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.length ?? 0) > 10 {
            if string.length > 0 {
                return false
            }
            return true
        }
        return true
    }
}
