//
//  BuyAmountView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/24.
//

import UIKit
import UIKit
import BSText
import SCLAlertView
import MBProgressHUD

class BuyAmountView: UIView {
    
    ///不足的美币数量
    var otherNum : Double = 0{
        didSet{
            self.title.text = "当前余额不足"
            self.coinNumLab.text = "\(self.coinNumLab.text ?? "")（还差\(otherNum)贝）"
            for i in 0...(numArr.count - 1){
                if Double(numArr[i]) >= otherNum {
                    self.selNumItems[self.selNum].isSel = false
                    self.selNum = i
                    self.selNumItems[self.selNum].isSel = true
                    return
                }
            }
            self.selNumItems[self.selNum].isSel = false
            self.selNum = 5
            self.selNumItems[self.selNum].isSel = true
        }
    }
    
    ///协议同意按钮
    let agreeImg = UIImageView.initWithName(imgName: "login_agree")
    var agreeBtn : UIButton = UIButton()
    let userProtocolLabel = BSLabel()
    
    ///支付按钮
    let enterBtn = UIButton.initTitle(title: "立即充值1元", font: .MediumFont(size: 18), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    let selNumItems = [AmountItemView(),AmountItemView(),AmountItemView(),AmountItemView(),AmountItemView(),AmountItemView()]
    var payNum = 100
    
    var selNum = 0{
        didSet{
            self.payNum = numArr[selNum]
            enterBtn.setTitle("立即充值\(moneyArr[selNum])元", for: .normal)
        }
    }
    var numArr = [1,6,98,998,5898,6498]
    var moneyArr = [1,6,98,998,5898,6498]
    var productIdArr = ["ss_yue_1","ss_yue_6","ss_yue_98","ss_yue_998","ss_yue_5898","ss_yue_6498"]
    let coinNumLab = UILabel.initSomeThing(title: "账户余额：0贝", titleColor: .init(hex: "#888888"), font: .MediumFont(size: 14), ali: .left)
    let title = UILabel.initSomeThing(title: "购买形体贝", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    
    let botBG = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(payCallBack(notifi:)), name: PayCompletionNotification, object: nil)
        
        let hideBtn = UIButton()
        hideBtn.backgroundColor = .init(r: 0, g: 0, b: 0, a: 0.3)
        hideBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        self.addSubview(hideBtn)
        hideBtn.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-400)
        }
        
        botBG.backgroundColor = .white
        self.addSubview(botBG)
        botBG.snp.makeConstraints { make in
            make.top.equalTo(hideBtn.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        botBG.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(22)
            make.left.equalTo(30)
            make.height.equalTo(25)
            make.right.equalTo(-30)
        }
        
        botBG.addSubview(coinNumLab)
        coinNumLab.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.right.equalTo(-16)
            make.left.equalTo(16)
            make.top.equalTo(60)
        }
        
        for i in 0...5{
            let item = selNumItems[i]
            
            item.meiBiNum = numArr[i]
            item.isSel = i == selNum
            let itemSpace = (screenWid - 360) / 4
            let line = i > 2 ? 1 : 0
            botBG.addSubview(item)
            item.snp.makeConstraints { make in
                make.width.equalTo(120)
                make.height.equalTo(72)
                make.top.equalTo(coinNumLab.snp.bottom).offset(line * (72 + 12) + 20)
                make.left.equalTo(CGFloat(i % 3) * (itemSpace + 120) + itemSpace)
            }
            item.tag = i
            
            item.selIndex = {
                self.selNumItems[self.selNum].isSel = false
                self.selNum = item.tag
                self.selNumItems[self.selNum].isSel = true
            }
        }
        
        enterBtn.layer.cornerRadius = 25
        enterBtn.layer.masksToBounds = true
        botBG.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(301)
        }
        
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.agreeBtn.isSelected{
                self.getNetInfo()
            }else{
                self.makeToast(ReadTipString)
            }
        }
        
        
        let protocolText = NSMutableAttributedString(string: "我已阅读并同意《全民形体用户协议》《隐私政策》")
        protocolText.bs_set(color: .init(hex: "#666666"), range: NSRange.init(location: 0, length: 7))
        protocolText.bs_set(textHighlightRange: NSRange.init(location: 7, length: 10), color: .orange, backgroundColor: .clear) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "全民形体用户协议"
            vc.url = userAgreementURL
            HQPush(vc: vc, style: .default)
        }
        
        protocolText.bs_set(textHighlightRange: NSRange.init(location: 17, length: 6), color: .orange, backgroundColor: .clear) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "隐私政策"
            vc.url = privacyPolicyURL
            HQPush(vc: vc, style: .default)
        }
        protocolText.bs_font = UIFont.systemFont(ofSize: 12)
        userProtocolLabel.attributedText = protocolText
        botBG.addSubview(userProtocolLabel)
        userProtocolLabel.sizeToFit()
        userProtocolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(enterBtn.snp.bottom).offset(13)
            //            make.width.equalTo(283)
            make.centerX.equalToSuperview()
            //            make.height.equalTo(12)
        }
        
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.agreeImg.image = UIImage.init(named: btn.isSelected ? "login_agree" : "login_disagree")
        }
        botBG.addSubview(agreeImg)
        agreeImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(19)
            make.right.equalTo(userProtocolLabel.snp.left).offset(-6)
            make.centerY.equalTo(userProtocolLabel)
        }
        
        botBG.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(54)
            make.center.equalTo(agreeImg)
        }
        agreeBtn.isSelected = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///生成支付订单
    func getNetInfo() {
        PayWithProductId(pid: productIdArr[selNum])
    }
    ///完成支付回调
    @objc func payCallBack(notifi : Notification){
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
}


class AmountItemView : UIView{
    var selIndex : voidBlock? = nil
    let selBg = UIView()
    ///美币数文本
    let meiBiLab = BSLabel()
    
    var isSel = false{
        didSet{
            self.backgroundColor = isSel ? .init(hex: "#FD8024") : .init(hex: "#F7F8F9")
        }
    }
    
    var meiBiNum = 100{
        didSet{
            let protocolText = NSMutableAttributedString(string: "\(meiBiNum)贝")
            protocolText.bs_alignment = .center
            protocolText.bs_font = .boldSystemFont(ofSize: 21)
            protocolText.bs_color = .init(hex: "#333333")
            protocolText.bs_set(font: .boldSystemFont(ofSize: 14), range: .init(location: protocolText.length - 1, length: 1))
            
            meiBiLab.attributedText = protocolText

        }
    }
    
    let tipLab = UILabel.initSomeThing(title: "自定义金额", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 15), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = .init(hex: "#F7F8F9")
        selBg.backgroundColor = .init(hex: "#F7F8F9")
        selBg.layer.cornerRadius = 8
        selBg.layer.masksToBounds = true
        self.addSubview(selBg)
        selBg.snp.makeConstraints { make in
            make.width.equalTo(116)
            make.height.equalTo(68)
            make.top.left.equalTo(2)
        }
        
        self.addSubview(meiBiLab)
        meiBiLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(29)
            make.top.equalTo(21)
        }
        
        self.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tipLab.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selIndex?()
    }
}
