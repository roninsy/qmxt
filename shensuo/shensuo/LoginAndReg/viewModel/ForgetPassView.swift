//
//  ForgetPassView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/15.
//

import UIKit
import BSText
import MBProgressHUD
import SCLAlertView

class ForgetPassView: UIView {
    var enterBlock: voidBlock? = nil
    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "login_back_btn"))
    
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
        input.needCheck = true
        self.superview?.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
        let phoneCode = self.phoneTF.text ?? ""
        input.subTitle.text = "已发送4位验证码至 +\(areaCode) \(phoneCode)"
        input.sendCodeBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if input.passTF.isHidden == false{
                self.endEditing(true)
                self.enterToReset()
            }
        }
        return input
    }()
    
    let bgView = UIImageView.initWithName(imgName: "begin_bg_gray")
    
    let mainTitleLab = UILabel.initSomeThing(title: "忘记密码", titleColor: .white, font: .SemiboldFont(size: 26), ali: .left)
    
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
        
        
        phoneBG.backgroundColor = .black
        phoneBG.layer.cornerRadius = 30
        phoneBG.layer.masksToBounds = true
        phoneBG.alpha = 0.3
        self.addSubview(phoneBG)
        phoneBG.snp.makeConstraints { (make) in
            make.left.right.equalTo(mainTitleLab)
            make.height.equalTo(60)
            make.top.equalTo(mainTitleLab.snp.bottom).offset(22)
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
            make.top.equalTo(phoneBG.snp.bottom).offset(60)
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
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.left.equalTo(32)
            make.top.equalTo(NavStatusHei + 20)
        }
        self.btnClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(){
        cleanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.phoneTF.text = ""
            btn.isHidden = true
        }
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.agreeImg.image = UIImage.init(named: btn.isSelected ? "login_agree" : "login_disagree")
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.isHidden = true
        }
        
        loginBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.sendCode()
        }
    }
    
    func sendCode() {
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"

        if !self.agreeBtn.isSelected{
            self.makeToast("请先同意用户协议")
            return
        }
        let phone = self.phoneTF.text ?? ""
        if phone.length < 1{
            self.makeToast("请输入正确的手机号")
            return
        }
        
        ///上报事件
        HQPushActionWith(name: "click_to_get_code", dic:  ["service_type":"忘记密码"])
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
    func enterToReset(){
        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
        
        UserNetworkProvider.request(.resetPass(areaCode:areaCode,mobile: phoneTF.text!, code: self.input.codeStr, password: self.input.passTF.text!)) {[weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self?.enterBlock?()
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

extension ForgetPassView : UITextFieldDelegate{
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
