//
//  LoginPhoneView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/16.
//

import UIKit
import SwiftyUserDefaults
import MBProgressHUD

class LoginPhoneView: UIView {
    let bgView = UIImageView.initWithName(imgName: "begin_bg_gray")

    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "login_back_btn"))
    
    let tipLab = UILabel.initSomeThing(title: "账号登录", titleColor: .white, font: .boldSystemFont(ofSize: 30), ali: .left)
    
    let phoneBG = UIView()
    
    let passBG =  UIView()
    
    let loginBtn = UIButton.initBGImgAndTitle(img: UIImage.init(named: "login_btn_bg")!, title: "立即登录", font: .MediumFont(size: 18), titleColor: .white,space: 1.78)
    
    let phoneTF = UITextField()
    
    let passTF = UITextField()
    
    let forget = UIButton.initTitle(title: "忘记密码？", fontSize: 14, titleColor: .white)
    let cleanBtn = UIButton.initImgv(imgv: .initWithName(imgName: "input_clean"))
    
    let seeBtn = UIButton()
    lazy var regView : UIView = {
        let view = RegistView()
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
        
        phoneBG.alpha = 0.2
        passBG.alpha = 0.2
        phoneBG.backgroundColor = .black
        passBG.backgroundColor = .black
        phoneTF.attributedPlaceholder = NSAttributedString(string: "请输入账号", attributes: [
            NSAttributedString.Key.foregroundColor: HQColor(r: 255, g: 255, b: 255, a: 0.6)
                ])
        passTF.attributedPlaceholder = NSAttributedString(string: "请输入密码", attributes: [
            NSAttributedString.Key.foregroundColor: HQColor(r: 255, g: 255, b: 255, a: 0.6)
                ])
        phoneTF.textColor = .white
        phoneTF.textColor = .white
//        phoneTF.reactive.continuousTextValues.observeValues { (str) in
//            ///文本被改变
//        }
        
        phoneTF.font = .MediumFont(size: 16)
        passTF.font = .MediumFont(size: 16)
        passTF.textColor = .white
        phoneTF.textColor = .white
        phoneTF.keyboardType = .numberPad
        passTF.keyboardType = .emailAddress
        passTF.isSecureTextEntry = true
        phoneTF.delegate = self
        passTF.delegate = self
        passTF.tag = 999
//        passTF.isUserInteractionEnabled = false
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.left.equalTo(32)
            make.top.equalTo(NavStatusHei + 20)
        }
        
        self.addSubview(tipLab)
        tipLab.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.height.equalTo(42)
            make.top.equalTo(NavStatusHei  + 156)
        }
        
        phoneBG.layer.cornerRadius = 30
        phoneBG.layer.masksToBounds = true
        self.addSubview(phoneBG)
        phoneBG.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.height.equalTo(60)
            make.top.equalTo(tipLab.snp.bottom).offset(56)
        }
        
        self.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBG).offset(96)
            make.right.equalTo(phoneBG).offset(-50)
            make.top.bottom.equalTo(phoneBG)
        }
        
        phoneTF.reactive.continuousTextValues.observeValues { (str) in
            ///文本被改变
//            self.loginBtn.isEnabled = str.length > 0
            self.cleanBtn.isHidden = str.length < 1
        }
        
        self.addSubview(cleanBtn)
        cleanBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(phoneBG)
            make.right.equalTo(phoneBG).offset(-22)
        }
        cleanBtn.isHidden = true
        
        
        
        passBG.layer.cornerRadius = 30
        passBG.layer.masksToBounds = true
        self.addSubview(passBG)
        passBG.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.height.equalTo(60)
            make.top.equalTo(phoneTF.snp.bottom).offset(32)
        }
        
        self.addSubview(passTF)
        passTF.snp.makeConstraints { (make) in
            make.left.equalTo(passBG).offset(96)
            make.right.equalTo(passBG).offset(-50)
            make.top.bottom.equalTo(passBG)
        }
        
        seeBtn .setImage(UIImage.init(named: "pass_no"), for: .normal)
        seeBtn .setImage(UIImage.init(named: "pass_see"), for: .selected)
        self.addSubview(seeBtn)
        seeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(passBG)
            make.right.equalTo(passBG).offset(-22)
        }
        seeBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            btn.isSelected.toggle()
            self.passTF.isSecureTextEntry = !btn.isSelected
        }
        
        let nameTipLab = UILabel.initSomeThing(title: "账  户", titleColor: .white, font: .systemFont(ofSize: 16), ali: .left)
        self.addSubview(nameTipLab)
        nameTipLab.snp.makeConstraints { make in
            make.left.equalTo(phoneBG).offset(22)
            make.width.equalTo(48)
            make.height.equalTo(22)
            make.centerY.equalTo(phoneBG)
        }
        
        let passTipLab = UILabel.initSomeThing(title: "密  码", titleColor: .white, font: .systemFont(ofSize: 16), ali: .left)
        self.addSubview(passTipLab)
        passTipLab.snp.makeConstraints { make in
            make.left.equalTo(passBG).offset(22)
            make.width.equalTo(48)
            make.height.equalTo(22)
            make.centerY.equalTo(passBG)
        }
        
        self.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.top.equalTo(passBG.snp.bottom).offset(60)
            make.height.equalTo(54)
        }
        
        forget.sizeToFit()
        self.addSubview(forget)
        forget.snp.makeConstraints { (make) in
            make.right.equalTo(tipLab)
            make.top.equalTo(loginBtn.snp.bottom).offset(24)
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
        
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.removeFromSuperview()
        }
        
        forget.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            let view = ForgetPassView()
            self.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            view.enterBlock = { [weak self] in
                self!.endEditing(true)
                view.isHidden = true
                view.removeFromSuperview()
                HQGetTopVC()?.view.makeToast("重置成功，请登录")
            }
        }
        
        loginBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.endEditing(true)
            let phone = self.phoneTF.text ?? ""
            let pass = self.passTF.text ?? ""
            if phone.length < 1 || pass.length < 6 || pass.length > 20{
                self.makeToast("请输入正确的账号密码")
                return
            }
           
            UserNetworkProvider.request(.login(userName: phone, password: pass)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {

                                UserInfo.getSharedInstance().dicInfo = model?.data as NSDictionary?
                                NTESQuickLoginManager.sharedInstance().closeAuthController {
                                    
                                    
                                }
                                DispatchQueue.main.async {
                                    HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                            }else{
                                
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
        }
    }
}

extension LoginPhoneView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 999 {
            self.loginBtn.sendActions(for: .touchUpInside)
        }
        return true
    }
}
