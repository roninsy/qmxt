//
//  InputCodeView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/13.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import MBProgressHUD

class InputCodeView: UIView {
    var needCheck = false
    var enterBlock : voidBlock? = nil
    
    let bgView = UIImageView.initWithName(imgName: "begin_bg_gray")
    
    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "login_back_btn"))
    
    let tipLab = UILabel.initSomeThing(title: "输入4位验证码", titleColor: .white, font: .boldSystemFont(ofSize: 30), ali: .left)
     
    let subTitle = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#C8C8C8"), font: .MediumFont(size: 18), ali: .left)
    
    let sendCodeBtn = UIButton.initBGImgAndTitle(img: UIImage.init(named: "login_btn_bg")!, title: "获取验证码", font: .MediumFont(size: 18), titleColor: .white,space: 1.78)
    
    let secondLab = UILabel.initWordSpace(title: "60秒后重新发送", titleColor: .init(hex: "#999999"), font: .MediumFont(size: 18), ali: .center, space: 1.78)
    
    let secondTip = UILabel.initSomeThing(title: "没有收到验证码？倒计时结束后可重新获取", titleColor: HQColor(r: 255, g: 255, b: 255, a: 0.66), font: .MediumFont(size: 12), ali: .center)
    
    ///验证码输入相关
    let textFeildBgArr = [UIImageView.initWithName(imgName: "code_input"),UIImageView.initWithName(imgName: "code_input"),UIImageView.initWithName(imgName: "code_input"),UIImageView.initWithName(imgName: "code_input")]
    var textFeildArr = [UITextFieldKeybordDelete(),UITextFieldKeybordDelete(),UITextFieldKeybordDelete(),UITextFieldKeybordDelete()]
    let tfView = UIView()
    var codeStr = ""
    
    ////倒计时秒数
    var second = 60
    
    ///密码输入相关
    let passBG = UIView()
    
    let passTF = UITextField()
    
    var mobile = ""
    var areaCode = "86"
    var tagNum = 0
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.left.equalTo(32)
            make.top.equalTo(NavStatusHei + 20)
        }
        
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
            self.isHidden = true
        }
        
        self.addSubview(tipLab)
        tipLab.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.height.equalTo(42)
            make.top.equalTo(NavStatusHei  + 114)
        }
        
        subTitle.adjustsFontSizeToFitWidth = true
        self.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.height.equalTo(25)
            make.top.equalTo(tipLab.snp.bottom).offset(10)
        }
        
        let btnWid : CGFloat = 60
        let btnHei : CGFloat = 60
        let space = (screenWid - 32 * 2 - btnWid * 4) / 3
        
        self.addSubview(tfView)
        tfView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(btnHei)
            make.top.equalTo(tipLab.snp.bottom).offset(48)
        }
        
        for i in 0...3 {
            let img = textFeildBgArr[i]
            tfView.addSubview(img)
            img.snp.makeConstraints { (make) in
                make.left.equalTo(32.0 + (btnWid + space) * CGFloat(i))
                make.width.equalTo(btnWid)
                make.height.equalTo(btnHei)
                make.top.equalTo(0)
            }
            
            let tf = textFeildArr[i]
            tf.keyboardType = .numberPad
            tf.tag = i
            tf.delegate = self
            tf.keyInputDelegate = self
            tf.textAlignment = .center
            tf.textColor = .white
            tf.tintColor = .white
            tf.font = .MediumFont(size: 36)
            tfView.addSubview(tf)
            tf.snp.makeConstraints { (make) in
                make.edges.equalTo(img)
            }
        }
        
//        let noTouchView = UIView()
//        tfView.addSubview(noTouchView)
//        noTouchView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        let img = textFeildBgArr[0]
        secondLab.backgroundColor = .white
        secondLab.layer.cornerRadius = 27
        secondLab.layer.masksToBounds = true
        self.addSubview(secondLab)
        secondLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipLab)
            make.height.equalTo(54)
            make.top.equalTo(img.snp.bottom).offset(36)
        }
        
        self.addSubview(sendCodeBtn)
        sendCodeBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(secondLab)
        }
        sendCodeBtn.isHidden = true
        
        self.addSubview(secondTip)
        secondTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(secondLab)
            make.height.equalTo(17)
            make.top.equalTo(secondLab.snp.bottom).offset(16)
        }
        
        
        RACTimer()
    }
    
    
    func changgeToInput(){
        
    }
    ///切换为设置密码
    func changgeToSetPassword(){
        self.subTitle.isHidden = true
        self.sendCodeBtn.alpha = 0.5
        passBG.backgroundColor = .black
        passBG.alpha = 0.2
        passBG.layer.cornerRadius = 30
        passBG.layer.masksToBounds = true
        passTF.attributedPlaceholder = NSAttributedString(string: "请输入6-20位新密码", attributes: [
            NSAttributedString.Key.foregroundColor: HQColor(r: 255, g: 255, b: 255, a: 0.6)
                ])
        self.tipLab.text = "重置密码"
        passTF.textColor = .white
        passTF.font = .boldSystemFont(ofSize: 16)
        passTF.tintColor = .white
        self.addSubview(passBG)
        passBG.snp.makeConstraints { (make) in
            make.top.equalTo(tipLab.snp.bottom).offset(22)
            make.left.right.equalTo(tipLab)
            make.height.equalTo(60)
        }
        
        self.addSubview(passTF)
        passTF.snp.makeConstraints { (make) in
            make.left.equalTo(passBG).offset(24)
            make.right.equalTo(passBG).offset(-24)
            make.top.bottom.equalTo(passBG)
        }
        passTF.reactive.continuousTextValues.observeValues { (str) in
            if str.length > 5 && str.length < 21{

                self.sendCodeBtn.alpha = 1
            }else{
                self.sendCodeBtn.alpha = 0.5
            }
        }
       
        MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
        self.sendCodeBtn.setTitle("完成", for: .normal)
        self.sendCodeBtn.snp.remakeConstraints { make in
            make.left.right.equalTo(passBG)
            make.height.equalTo(60)
            make.top.equalTo(passBG.snp.bottom).offset(60)
        }
        self.tfView.isHidden = true
        self.secondLab.isHidden = true
        self.sendCodeBtn.isHidden = false
        self.secondTip.isHidden = true
        self.passTF.becomeFirstResponder()
    }
    
    func RACTimer() {
        self.sendCodeBtn.setTitle("获取验证码", for: .normal)
        self.second = 60
        self.sendCodeBtn.isHidden = true
        self.secondLab.isHidden = false
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "GCDTimer", timeInterval: 1, queue: .main, repeats: true) {
            if self.second > 0{
                self.second -= 1
                self.secondLab.text = "\(self.second)秒后重新发送"
            }else{
                MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
                self.sendCodeBtn.isHidden = false
                self.secondLab.isHidden = true
            }
        }
    }
    

}

extension InputCodeView : UITextFieldDelegate,keyInputTextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        tagNum = textField.tag
        
        if string.length > 0{
            textField.text = string
            if tagNum == 3{
                self.codeStr = textFeildArr[0].text! + textFeildArr[1].text! +  textFeildArr[2].text! + textFeildArr[3].text!
                if needCheck {
                                    UserNetworkProvider.request(.checkCode(areaCode:areaCode,mobile: self.mobile, code: self.codeStr)) { result in
                    
                                        switch result{
                                        case let .success(moyaResponse):
                                            do {
                                                let code = moyaResponse.statusCode
                                                if code == 200{
                                                    let json = try moyaResponse.mapString()
                                                    let model = json.kj.model(ResultModel.self)
                                                    if model?.code == 0 {
                                                        self.changgeToSetPassword()
                                                    }else{
                                                        HQGetTopVC()?.view.makeToast(model?.message ?? "错误，请重试")
                                                    }
                                                }
                    
                                            } catch {
                    
                                            }
                                        case let .failure(error):
                                            logger.error("error-----",error)
                                        }
                                    }
                }else{
                    self.enterBlock?()
                }
            }
            if tagNum < 3 {
                tagNum += 1
//                self.endEditing(false)
                self.textFeildArr[tagNum].becomeFirstResponder()
                
            }

        }else{
            textField.text = ""
//            if tagNum > 0{
//                tagNum -= 1
//                self.textFeildArr[tag].becomeFirstResponder()
//
//            }
        }
        
        return false
    }
    
    func deleteBackward() {
        self.textFeildArr[tagNum].text = ""
        if tagNum > 0{
            tagNum -= 1
            self.textFeildArr[tagNum].text = ""
            self.textFeildArr[tagNum].becomeFirstResponder()
        }
    }
}
