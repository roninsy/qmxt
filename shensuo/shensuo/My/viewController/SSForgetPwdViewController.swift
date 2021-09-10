//
//  SSForgetPwdViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/15.
//

import UIKit
import MBProgressHUD
import SwiftyUserDefaults
import BSText
import SensorsAnalyticsSDK

class SSForgetPwdViewController: SSBaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
        self.view.backgroundColor = .init(hex: "#F7F8F9")
        navView.backBtnWithTitle(title: "忘记密码")
        navView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        
        let forgetView = SSForgetView.init()
        self.view.addSubview(forgetView)
        forgetView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navView.snp.bottom).offset(30)
            make.height.equalTo(350)
        }
        
        forgetView.countryView.countryBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in


            let selView = SelCountryNumView()
            selView.isUserInteractionEnabled = true
//            selView.listView.isUserInteractionEnabled = true
            HQGetTopVC()?.view.addSubview(selView)
            selView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            selView.getNumListInfo()
            selView.selBlock = { index in
//                self.countryDic = selView.dicArr[index]
                selView.isHidden = true
                selView.removeFromSuperview()
            }

        }

        
        
        let nextBtn = UIButton()
        self.view.addSubview(nextBtn)
        nextBtn.backgroundColor = .init(hex: "#FD8024")
        nextBtn.isEnabled = false
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 20)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 30
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-29)
            make.height.equalTo(58)
            make.top.equalTo(forgetView.snp.bottom).offset(30)
            
        }
        nextBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            
        })
    }
    
    @objc func tapbg(tapGestureRecognizer: UITapGestureRecognizer) {
//        bgView.isHidden = true
        let view = tapGestureRecognizer.view
        view?.isHidden = true
        view?.removeFromSuperview()
//        self.bgView.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class SSForgetView : UIView {
    
    let nameLabel = UILabel.initSomeThing(title: "忘记密码", isBold: true, fontSize: 32, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let countryView = SSBgInputView.init()
    let phoneView = SSBgInputView.init()
    let codeView = SSBgInputView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(29)
            make.height.equalTo(45)
            make.top.equalToSuperview()
        }
        
        self.addSubview(countryView)
        countryView.buildCountry()
        countryView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-29)
            make.top.equalTo(nameLabel.snp.bottom).offset(34)
            make.height.equalTo(58)
        }
                
        self.addSubview(phoneView)
        phoneView.buildPhoneNum()
        phoneView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(countryView)
            make.top.equalTo(countryView.snp.bottom).offset(32)
        }
        
        self.addSubview(codeView)
        codeView.buildCode()
        codeView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(countryView)
            make.top.equalTo(phoneView.snp.bottom).offset(32)
        }
    
    codeView.codeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
        self.sendCode()
    }
    }
func sendCode() -> Void {
    
    let phone = self.phoneView.phoneTF.text ?? ""
    if phone.length < 11{
        self.makeToast("请输入正确的手机号")
        return
    }
//        let areaCode = self.countryDic == nil ? "86" : self.countryDic!["code"] as? String ?? "86"
    
    SensorsAnalyticsSDK.sharedInstance()?.login(phone)
    ///上报事件
    HQPushActionWith(name: "click_to_get_code", dic:  ["service_type":"忘记密码"])
    UserNetworkProvider.request(.sendCode(areaCode:"86",phone:phone,isReg:true)) { result in
        switch result{
        case let .success(moyaResponse):
            do {
                let code = moyaResponse.statusCode
                if code == 200{
                    let json = try moyaResponse.mapString()
                    let model = json.kj.model(ResultModel.self)
                    if model?.code == 0 {
                        self.codeView.code.becomeFirstResponder()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SSBgInputView : UIView {
    
    let phoneBG = UIView()
    let countryTip = UILabel.initSomeThing(title: "国家地区", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 20), ali: .left)
    let countryLab = UILabel.initSomeThing(title: "中国大陆(+86) >", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 20), ali: .right)
    let countryBtn = UIButton()
    
    var countryDic : NSDictionary? = nil
    
    let phoneTF = UITextField()
    
    let code = UITextField()
    let codeBtn = UIButton.initTitle(title: "|获取验证码", fontSize: 18, titleColor: .init(hex: "#FD8024"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(phoneBG)
        phoneBG.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func buildCountry() -> Void {
        self.addSubview(countryTip)
        countryTip.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBG).offset(24)
            make.width.equalTo(100)
            make.top.bottom.equalTo(phoneBG)
        }
        
        self.addSubview(countryLab)
        countryLab.snp.makeConstraints { (make) in
            make.right.equalTo(phoneBG).offset(-24)
            make.left.equalTo(countryTip.snp.right)
            make.top.bottom.equalTo(phoneBG)
        }
        
        self.addSubview(countryBtn)
        countryBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(phoneBG)
        }
        
//        countryBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
//            let selView = SelCountryNumView()
//            selView.isUserInteractionEnabled = true
//            selView.backgroundColor = .white
//            self.addSubview(selView)
//            selView.snp.makeConstraints { make in
//                make.center.equalToSuperview()
//            }
//            selView.getNumListInfo()
//            selView.selBlock = { index in
////                self.countryDic = selView.dicArr[index]
//                selView.isHidden = true
//                selView.removeFromSuperview()
//            }
//        }
        
    }
    
    func buildPhoneNum() -> Void {
        phoneTF.placeholder = "请输入手机号码"
        phoneTF.textColor = .init(hex: "#898989")
        phoneTF.font = .systemFont(ofSize: 20)
        phoneTF.clearButtonMode = .whileEditing
        phoneTF.keyboardType = .numberPad
        phoneTF.delegate = self
        phoneTF.tag = 1000
        self.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBG).offset(24)
            make.right.equalTo(phoneBG).offset(-24)
            make.top.bottom.equalTo(phoneBG)
        }
    }
    
    func buildCode() -> Void {
        code.placeholder = "请输入验证码"
        code.textColor = .init(hex: "#898989")
        code.font = .systemFont(ofSize: 20)
        code.keyboardType = .numberPad
        code.tag = 1001
        code.delegate = self
        self.addSubview(code)
        code.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBG).offset(24)
            make.width.equalTo(150)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(phoneBG).offset(-24)
            make.top.bottom.equalTo(phoneBG)
            make.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SSBgInputView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
            case 1000:
                if (textField.text?.length ?? 0) > 10 {
//                    if string.length > 0 {
//                        return false
//                    }
                    textField.text = textField.text?.subString(to: 10)
                    return true
                }
            case 1001:
                if (textField.text?.length ?? 0) > 5 {
//                    if string.length > 0 {
//                        return false
//                    }
                    textField.text = textField.text?.subString(to: 5)

                    return true
                }
            default:
                return true
        }

        return true
    }
}
