//
//  LoginNewMainView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/12.
//

import UIKit
import SwiftyUserDefaults
import MBProgressHUD
import BSText
import SensorsAnalyticsSDK

class LoginNewMainView: UIView {
    
    var countryDic : NSDictionary? = nil{
        didSet{
            if countryDic != nil {
                qhCodeLab.text = String.init(format: "+ %@", countryDic!["code"] as? String ?? "")
            }
        }
    }
    
    ///验证码输入框
    lazy var input : InputCodeView = { () -> InputCodeView in
        let input = InputCodeView()
        self.superview?.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
        let phoneCode = self.phoneTF.text ?? ""
        input.subTitle.text = "已发送4位验证码至 +\(areaCode) \(phoneCode)"
        input.enterBlock = {
            self.endEditing(true)
            self.enterToRegist()
        }
        return input
    }()
    
    let bgView = UIImageView.initWithName(imgName: "begin_bg")
    
    let bgView2 = UIView()
    
    let numLoginBtn = UIButton.initTitle(title: "账户登录", fontSize: 16, titleColor: .init(hex: "#C8C8C8"))
    let userLoginBtn = UIButton.initTitle(title: "游客登录", fontSize: 16, titleColor: .init(hex: "#C8C8C8"))
    let mainTitleLab = UILabel.initSomeThing(title: "手机号登录", titleColor: .white, font: .SemiboldFont(size: 26), ali: .left)
    let subTitleLab = UILabel.initSomeThing(title: "认识更多好友，记录你的蜕变过程", titleColor: .init(hex: "#C8C8C8"), font: .MediumFont(size: 18), ali: .left)
    
    let phoneBG = UIImageView.initWithName(imgName: "login_phone_bg")
    
    let loginBtn = UIButton.initBGImgAndTitle(img: UIImage.init(named: "login_btn_bg")!, title: "获取验证码", font: .MediumFont(size: 18), titleColor: .white,space: 1.78)
    
    let phoneTF = UITextField()
    
    let userProtocolLabel = BSLabel()
    let agreeImg = UIImageView.initWithName(imgName: "login_dis")
    var agreeBtn : UIButton = UIButton()
    
    let cleanBtn = UIButton.initImgv(imgv: .initWithName(imgName: "input_clean"))
    
    let qhCodeLab = UILabel.initSomeThing(title: "+ 86", titleColor: .white, font: .systemFont(ofSize: 16), ali: .right)
    
    let qhImg = UIImageView.initWithName(imgName: "login_down_arrow")
    
    
    lazy var regView : UIView = {
        let view = RegistView()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    lazy var forgetView : UIView = {
        let view = ForgetPassView()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgView2.backgroundColor = .black
        bgView2.alpha = 0.3
        self.addSubview(bgView2)
        self.bgView2.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        numLoginBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let loginView = LoginPhoneView()
            HQGetTopVC()?.view.addSubview(loginView)
            loginView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        self.addSubview(numLoginBtn)
        numLoginBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(22)
            make.right.equalTo(-27)
            make.top.equalTo(53)
        }
        
        userLoginBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.enterToGuestLogin()
        }
        self.addSubview(userLoginBtn)
        userLoginBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(22)
            make.left.equalTo(27)
            make.top.equalTo(53)
        }
        
//        cleanBtn.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)

        phoneTF.attributedPlaceholder = NSAttributedString(string: "请输入手机号", attributes: [
            NSAttributedString.Key.foregroundColor: HQColor(r: 255, g: 255, b: 255, a: 0.6)
                ])
//        phoneTF.rightView = cleanBtn
//        phoneTF.rightViewMode = .whileEditing

        phoneTF.keyboardType = .numberPad
        phoneTF.textColor = .white
        phoneTF.textColor = .white
        phoneTF.reactive.continuousTextValues.observeValues { (str) in
            ///文本被改变
//            self.loginBtn.isEnabled = str.length > 0
            self.cleanBtn.isHidden = str.length < 1
        }
        
        phoneTF.font = .boldSystemFont(ofSize: 16)

        
        self.addSubview(mainTitleLab)
        mainTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-37)
            make.height.equalTo(42)
            make.top.equalTo(156)
        }
        self.addSubview(subTitleLab)
        subTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(mainTitleLab)
            make.right.equalTo(-37)
            make.height.equalTo(25)
            make.top.equalTo(mainTitleLab.snp.bottom).offset(10)
        }
        
        phoneBG.backgroundColor = .black
        phoneBG.layer.cornerRadius = 30
        phoneBG.layer.masksToBounds = true
        phoneBG.alpha = 0.3
        self.addSubview(phoneBG)
        phoneBG.snp.makeConstraints { (make) in
            make.left.right.equalTo(mainTitleLab)
            make.height.equalTo(60)
            make.top.equalTo(subTitleLab.snp.bottom).offset(56)
        }
        
        self.addSubview(qhImg)
        qhImg.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(13)
            make.centerY.equalTo(phoneBG)
            make.left.equalTo(phoneBG).offset(62)
        }
        
        self.addSubview(qhCodeLab)
        qhCodeLab.snp.makeConstraints { make in
            make.right.equalTo(qhImg.snp.left).offset(-7)
            make.left.equalTo(phoneBG)
            make.height.equalTo(20)
            make.centerY.equalTo(phoneBG)
        }
        
        let qhBtn = UIButton()
        self.addSubview(qhBtn)
        qhBtn.snp.makeConstraints { make in
            make.left.equalTo(qhCodeLab)
            make.right.equalTo(qhImg)
            make.top.bottom.equalTo(phoneBG)
        }
        qhBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
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
        
        self.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBG).offset(96)
            make.right.equalTo(phoneBG).offset(-50)
            make.top.bottom.equalTo(phoneBG)
        }
        
        self.addSubview(cleanBtn)
        cleanBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(phoneBG)
            make.right.equalTo(phoneBG).offset(-22)
        }
        cleanBtn.isHidden = true
       
        self.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(mainTitleLab)
            make.top.equalTo(phoneBG.snp.bottom).offset(36)
            make.height.equalTo(54)
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
        protocolText.bs_font = UIFont.systemFont(ofSize: 14)

        userProtocolLabel.attributedText = protocolText
        self.addSubview(userProtocolLabel)
        userProtocolLabel.sizeToFit()
        userProtocolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(10)
            make.centerX.equalToSuperview().offset(7)
        }
        
        self.addSubview(agreeImg)
        agreeImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.right.equalTo(userProtocolLabel.snp.left).offset(-5)
            make.centerY.equalTo(userProtocolLabel)
        }
        
        agreeBtn.isSelected = false
        self.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(54)
            make.center.equalTo(agreeImg)
        }
        
        self.btnClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func btnClick(){
        cleanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.phoneTF.text = ""
            btn.isHidden = true
        }
        
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.agreeImg.image = UIImage.init(named: btn.isSelected ? "login_agree" : "login_dis")
        }

        
        loginBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.sendCode()
        }
    }
    
    func sendCode() {
        self.endEditing(true)
        if !self.agreeBtn.isSelected{
            self.makeToast("请先同意用户协议")
            return
        }
        let phone = self.phoneTF.text ?? ""
        if phone.length < 1{
            self.makeToast("请输入正确的手机号")
            return
        }
        input.RACTimer()
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
        
        
        ///上报事件
        HQPushActionWith(name: "click_to_get_code", dic:  ["service_type":"登录"])
        UserNetworkProvider.request(.sendCode(areaCode:areaCode,phone:phone,isReg:false)) { result in
            
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
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    
    ///用户游客登录
    func enterToGuestLogin(){
        
        self.endEditing(true)
        if !self.agreeBtn.isSelected{
            self.makeToast("请先同意用户协议")
            return
        }
        
        ///上报事件
//        HQPushActionWith(name: "click_to_get_code", dic:  ["service_type":"登录"])
    
        UserNetworkProvider.request(.iosGuestLogin) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                            let userTokenKey = DefaultsKey<String?>(userUUIDKeyString)
                            SensorsAnalyticsSDK.sharedInstance()?.login(Defaults[key: userTokenKey] ?? "")
                            
                            NTESQuickLoginManager.sharedInstance().closeAuthController {
 
                            }
                            DispatchQueue.main.async {
                                HQGetTopVC()?.navigationController?.popViewController(animated: true)
                                HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                            }
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
//        regist(areaCode:areaCode,mobile: phoneTF.text!, password: self.input.passTF.text!, code: self.input.codeStr)
        
        ///上报事件
//        HQPushActionWith(name: "click_to_get_code", dic:  ["service_type":"登录"])
    
        UserNetworkProvider.request(.loginBySMS(areaCode: areaCode, mobile: phoneTF.text!, code: self.input.codeStr)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                        }else{
                            self.input.endEditing(true)
                            
                            for i in 0...3{
                                self.input.textFeildArr[i].text = ""
                            }
//                            self.input.textFeildArr[0].becomeFirstResponder()
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

extension LoginNewMainView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 999 {
            self.loginBtn.sendActions(for: .touchUpInside)
        }
        return true
    }
}
