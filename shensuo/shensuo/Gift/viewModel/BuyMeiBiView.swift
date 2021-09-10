//
//  BuyMeiBiView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/25.
//

import UIKit
import BSText
import SCLAlertView
import MBProgressHUD

class BuyMeiBiView: UIView {
    
    ///不足的美币数量
    var otherNum = 0{
        didSet{
            self.title.text = "当前美币不足"
            self.coinNumLab.text = "\(self.coinNumLab.text ?? "")（还差\(otherNum)美币）"
            for i in 0...(numArr.count - 1){
                if numArr[i] >= otherNum {
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
    let selNumItems = [MeiBiItemView(),MeiBiItemView(),MeiBiItemView(),MeiBiItemView(),MeiBiItemView(),MeiBiItemView()]
    var payNum = 100
    
    var selNum = 0{
        didSet{
            self.payNum = numArr[selNum]
            enterBtn.setTitle("立即充值\(moneyArr[selNum])元", for: .normal)
        }
    }
    var numArr = [70,420,6860,69860,412860,454860]
    var moneyArr = [1,6,98,998,5898,6498]
    var productIdArr = ["ss_meibi_70","ss_meibi_420","ss_meibi_6860","ss_meibi_69860","ss_meibi_412860","ss_meibi_454860"]
    let coinNumLab = UILabel.initSomeThing(title: "余额：0美币", titleColor: .init(hex: "#888888"), font: .MediumFont(size: 14), ali: .left)
    let title = UILabel.initSomeThing(title: "购买美币", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(payCallBack(notifi:)), name: PayCompletionNotification, object: nil)
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(22)
            make.left.equalTo(30)
            make.height.equalTo(25)
            make.right.equalTo(-30)
        }
        
        self.addSubview(coinNumLab)
        coinNumLab.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.right.equalTo(-16)
            make.left.equalTo(16)
            make.top.equalTo(60)
        }
        
        for i in 0...5{
            let item = selNumItems[i]
            
            item.meiBiNum = numArr[i]
            item.rmbLab.text = "\(moneyArr[i])元"
            item.isSel = i == selNum
            let itemSpace = (screenWid - 360) / 4
            let line = i > 2 ? 1 : 0
            self.addSubview(item)
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
        self.addSubview(enterBtn)
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
        self.addSubview(userProtocolLabel)
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
        self.addSubview(agreeImg)
        agreeImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(19)
            make.right.equalTo(userProtocolLabel.snp.left).offset(-6)
            make.centerY.equalTo(userProtocolLabel)
        }
        
        self.addSubview(agreeBtn)
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


class MeiBiItemView : UIView{
    var selIndex : voidBlock? = nil
    let selBg = UIView()
    ///美币数文本
    let meiBiLab = BSLabel()
    ///人民币文本
    let rmbLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 12), ali: .center)
    
    var isSel = false{
        didSet{
            self.backgroundColor = isSel ? .init(hex: "#FD8024") : .init(hex: "#F7F8F9")
        }
    }
    
    var meiBiNum = 100{
        didSet{
            let protocolText = NSMutableAttributedString(string: "\(meiBiNum)美币")
            protocolText.bs_alignment = .center
            protocolText.bs_font = .MediumFont(size: 20)
            protocolText.bs_color = .init(hex: "#333333")
            protocolText.bs_set(font: .MediumFont(size: 12), range: .init(location: protocolText.length - 2, length: 2))
            
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
            make.height.equalTo(16)
            make.top.equalTo(21)
        }
        
        self.addSubview(rmbLab)
        rmbLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
            make.bottom.equalTo(-16)
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
