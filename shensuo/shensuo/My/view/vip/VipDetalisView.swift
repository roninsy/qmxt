//
//  VuoDetalisView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/10.
//

import UIKit
import BSText

class VipDetalisView: UIView {
    
    let sview = UIScrollView()
    
    let topBg = UIImageView.initWithName(imgName: "vip_top_main_bg")
    
    let vipStatusView = VipStatusHeadView()
    
    let vipMidView = VipMidView()
    
    let vipBotView = VipBotView()
    
    var buyBtn : UIButton!
    
    let buyLab = UILabel.initSomeThing(title: (UserInfo.getSharedInstance().vip ?? false) ? "立即续费" : "立即开通", titleColor: .init(hex: "#F5CF9E"), font: .systemFont(ofSize: 18), ali: .center)
    
    let priceLab = BSLabel()
    let maketLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#353535"), font: .systemFont(ofSize: 12), ali: .right)
    
    var agreeBtn = UIButton()
    
    var agreeLab = BSLabel()
    
    var agreeImg = UIImageView.initWithName(imgName: "login_disagree")
    
    var vipPrice : String = "0"{
        didSet{
            let priceStr = self.vipPrice
            let protocolText = NSMutableAttributedString(string: "会员专享价 \(priceStr)贝/年")
            protocolText.bs_alignment = .right
            protocolText.bs_color = .init(hex: "#353535")
            protocolText.bs_font = .systemFont(ofSize: 12)
            protocolText.bs_set(font: .SemiboldFont(size: 18), range: NSRange.init(location: 6, length: priceStr.length))
            priceLab.attributedText = protocolText
            priceLab.sizeToFit()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        sview.showsVerticalScrollIndicator = false
        sview.contentInsetAdjustmentBehavior = .never
        self.addSubview(sview)
        sview.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-130)
        }
        self.setupSView()
        
        let backBtn = UIButton.initWithBackBtn(isBlack: true)
        sview.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.top.equalTo(50)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        let titleLab = UILabel.initSomeThing(title: "VIP会员", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 18), ali: .center)
        sview.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(25)
            make.centerY.equalTo(backBtn)
        }
        
        
        let imgV = UIImageView.initWithName(imgName: "vip_buy_btn")
        imgV.contentMode = .scaleToFill
        imgV.layer.masksToBounds = true
        self.addSubview(imgV)
        imgV.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(57)
            make.bottom.equalTo(-27)
        }
        buyBtn = UIButton()
        
        self.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(57)
            make.bottom.equalTo(-27)
        }
        
        self.addSubview(buyLab)
        buyLab.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.right.equalTo(buyBtn)
            make.height.equalTo(57)
            make.top.equalTo(buyBtn)
        }
        
        
        
        self.addSubview(maketLab)
        maketLab.text = "\(UserInfo.getSharedInstance().vipMarketPrice ?? 1500)贝/年"
        let maketSize = maketLab.sizeThatFits(.init(width: 120, height: 15))
        maketLab.snp.makeConstraints { make in
            make.right.equalTo(-150)
            make.height.equalTo(17)
            make.centerY.equalTo(buyBtn)
            make.width.equalTo(maketSize.width)
        }
        
        
        let line = UIView()
        line.backgroundColor = .init(hex: "#353535")
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(maketLab)
            make.right.equalTo(maketLab)
            make.centerY.equalTo(maketLab)
        }
        
        let priceStr = String(UserInfo.getSharedInstance().vipPrice ?? 365)
        let protocolText = NSMutableAttributedString(string: "会员专享价 \(priceStr)贝/年")
        protocolText.bs_alignment = .right
        protocolText.bs_color = .init(hex: "#353535")
        protocolText.bs_font = .systemFont(ofSize: 12)
        protocolText.bs_set(font: .SemiboldFont(size: 18), range: NSRange.init(location: 6, length: priceStr.length))
        priceLab.attributedText = protocolText
        self.addSubview(priceLab)
        priceLab.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.left.equalTo(16)
            make.centerY.equalTo(buyBtn)
            make.right.equalTo(maketLab.snp.left).offset(-4)
        }
        
        let protocolText2 = NSMutableAttributedString(string: "我已阅读并同意《全民形体用户协议》《隐私政策》")
        protocolText2.bs_set(color: .init(hex: "#666666"), range: NSRange.init(location: 0, length: 7))
        protocolText2.bs_set(textHighlightRange: NSRange.init(location: 7, length: 10), color: .orange, backgroundColor: .clear) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "全民形体用户协议"
            vc.url = userAgreementURL
            HQPush(vc: vc, style: .default)
        }
        
        protocolText2.bs_set(textHighlightRange: NSRange.init(location: 17, length: 6), color: .orange, backgroundColor: .clear) { (view, str, range, rece) in
            let vc = HQWebVC()
            vc.titleLab.text = "隐私政策"
            vc.url = privacyPolicyURL
            HQPush(vc: vc, style: .default)
        }
        protocolText2.bs_font = UIFont.systemFont(ofSize: 12)
        agreeLab.attributedText = protocolText2
        self.addSubview(agreeLab)
        agreeLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(buyBtn.snp.top).offset(-16)
            make.width.equalTo(283)
            make.left.equalTo(42)
            make.height.equalTo(17)
        }
        
        self.addSubview(agreeImg)
        agreeImg.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(16)
            make.centerY.equalTo(agreeLab)
        }
        
        self.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalTo(agreeImg)
        }
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.agreeBtn.isSelected = !self.agreeBtn.isSelected
            self.agreeImg.image = self.agreeBtn.isSelected ? UIImage.init(named: "login_agree") : UIImage.init(named: "login_disagree")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSView(){
        sview.addSubview(topBg)
        topBg.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(screenWid / 414 * 182)
        }
        
        let stateBg = UIImageView.initWithName(imgName: "vip_top_main_bg_bot")
        sview.addSubview(stateBg)
        stateBg.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(175)
            make.width.equalTo(screenWid)
            make.height.equalTo(120)
        }
        
        vipStatusView.type = (UserInfo.getSharedInstance().vip ?? false) ? 1 : 0
        vipStatusView.setupUI()
        sview.addSubview(vipStatusView)
        vipStatusView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(97)
            make.width.equalTo(screenWid - 40)
            make.height.equalTo((UserInfo.getSharedInstance().vip ?? false) ? 202 : 162)
        }
        
        vipMidView.exchangeSelBlock = {[weak self] str in
            self?.getPrice(sid: str)
        }
        sview.addSubview(vipMidView)
        vipMidView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(screenWid)
            make.top.equalTo(vipStatusView.snp.bottom).offset(32)
            make.height.equalTo(304)
        }
        
        let midLine = UIView()
        sview.addSubview(midLine)
        midLine.backgroundColor = .init(hex: "#EEEFF0")
        midLine.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(vipMidView.snp.bottom)
            make.height.equalTo(12)
            make.width.equalTo(screenWid)
        }
        
        sview.addSubview(vipBotView)
        vipBotView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(screenWid)
            make.top.equalTo(midLine.snp.bottom)
            make.height.equalTo(278)
            make.bottom.equalToSuperview()
        }
    }
    
    ///获取使用优惠券后价格
    func getPrice(sid:String){
        UserNetworkProvider.request(.vipPrice(sid: sid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultStringModel.self)
                        if model?.code == 0 {
                            self.vipPrice = model?.data ?? "365"
                        }
                    }
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    
    func reloadVipPrice(){
        maketLab.text = "\(UserInfo.getSharedInstance().vipMarketPrice ?? 1500)贝/年"
        maketLab.sizeToFit()
        
        let priceStr = String(UserInfo.getSharedInstance().vipPrice ?? 365)
        let protocolText = NSMutableAttributedString(string: "会员专享价 \(priceStr)贝/年")
        protocolText.bs_alignment = .right
        protocolText.bs_color = .init(hex: "#353535")
        protocolText.bs_font = .systemFont(ofSize: 12)
        protocolText.bs_set(font: .SemiboldFont(size: 18), range: NSRange.init(location: 6, length: priceStr.length))
        priceLab.attributedText = protocolText
        
        buyLab.text = (UserInfo.getSharedInstance().vip ?? false) ? "立即续费" : "立即开通"
    }
}
