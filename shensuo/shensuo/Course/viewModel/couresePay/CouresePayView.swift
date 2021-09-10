//
//  CouresePayView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/10.
//

import UIKit
import BSText
import MBProgressHUD
import SCLAlertView

class CouresePayView: UIView {
    var payFinishBlock : voidBlock? = nil
    var payType = "3"
    var exchangeModels : [[SSExchangeModel]] = NSArray() as! [[SSExchangeModel]]{
        didSet{
            for models in exchangeModels {
                for model in models{
                    if model.nice{
                        self.exchangeSelModel = model
                        return
                    }
                }
            }
        }
    }
    var exchangeSelModel : SSExchangeModel? = nil{
        didSet{
            if exchangeSelModel != nil{
                self.juanLab.text = "\(exchangeSelModel!.name!)1张 >"
                self.getPrice()
            }else{
                self.juanLab.text = "暂不使用劵 >"
            }
        }
    }
    ///协议同意按钮
    let agreeImg = UIImageView.initWithName(imgName: "login_agree")
    var agreeBtn : UIButton = UIButton()
    var model : CourseDetalisModel? = nil{
        didSet{
            if model != nil {
                self.getExchanggesInfo()
                titleLab.text = model!.title
                priceLab.text = String.init(format: "%.2f贝", model!.price?.doubleValue ?? 0)
                
            }
        }
    }
    
    ///课程标题
    let titleLab = UILabel.initSomeThing(title: "课程名称", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 18), ali: .center)
    ///课程价格
    let priceLab = UILabel.initSomeThing(title: "0贝", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 24), ali: .center)
    
    let juanTip = UILabel.initSomeThing(title: "支付方式", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .left)
    ///优惠券
    let juanLab = UILabel.initSomeThing(title: "形体贝支付", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .right)
    
    ///优惠券
    let tipLab = UILabel.initSomeThing(title: "您即将购买的是虚拟知识服务，一旦购买即代表您已经学习，将不提供退款。", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 15), ali: .left)
    
    let cancelBtn = UIButton.initTitle(title: "取消", fontSize: 20, titleColor: .init(hex: "#666666"))
    let buyBtn = UIButton.initTitle(title: "立即购买", fontSize: 20, titleColor: .init(hex: "#FD8024"))
    
    let userProtocolLabel = BSLabel()
    
    let whiteBG = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 12
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.width.equalTo(354)
            make.height.equalTo(450)
            make.centerX.centerY.equalToSuperview()
        }
        
        whiteBG.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(25)
            make.top.equalTo(32)
        }
        
        whiteBG.addSubview(priceLab)
        priceLab.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(33)
            make.top.equalTo(titleLab.snp.bottom).offset(17)
        }
        
        let line1 = UIView()
        line1.backgroundColor = .init(hex: "#EEEFF0")
        whiteBG.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(priceLab.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
        }
        
        whiteBG.addSubview(juanTip)
        juanTip.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.width.equalTo(100)
            make.top.equalTo(line1)
            make.height.equalTo(57)
        }
        
        whiteBG.addSubview(juanLab)
        juanLab.snp.makeConstraints { make in
            make.right.equalTo(-24)
            make.left.equalTo(130)
            make.top.equalTo(line1)
            make.height.equalTo(57)
        }
        
//        let juanBtn = UIButton()
//        whiteBG.addSubview(juanBtn)
//        juanBtn.snp.makeConstraints { make in
//            make.edges.equalTo(juanLab)
//        }
//        juanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
//            let selView = ExchangeSelView()
//            selView.exchangeModels = self.exchangeModels as NSArray
//            self.addSubview(selView)
//            selView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//            selView.selBlock = { index in
//                if index == 999{
//                    self.priceLab.text = String.init(format: "%.2f贝", self.model!.price?.doubleValue ?? 0)
//                    ///不使用劵
//                    self.exchangeSelModel = nil
//                    selView.removeFromSuperview()
//                    return
//                }
//                let arr = self.exchangeModels[index]
//                for model in arr{
//                    if model.used {
//                        self.exchangeSelModel = model
//                        selView.removeFromSuperview()
//                        return
//                    }
//                }
//                selView.removeFromSuperview()
//            }
//        }
        
        let line3 = UIView()
        line3.backgroundColor = .init(hex: "#EEEFF0")
        whiteBG.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(juanLab.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        tipLab.numberOfLines = 0
        whiteBG.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.bottom.equalTo(-116)
        }
        tipLab.sizeToFit()
        
        let protocolText = NSMutableAttributedString(string: "我已阅读并同意《全民形体用户协议》《隐私政策》")
        protocolText.bs_set(color: .init(hex: "#333333"), range: NSRange.init(location: 0, length: 7))
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
        protocolText.bs_font = UIFont.systemFont(ofSize: 13)
        userProtocolLabel.attributedText = protocolText
        whiteBG.addSubview(userProtocolLabel)
        userProtocolLabel.sizeToFit()
        userProtocolLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-85)
            make.left.equalTo(46)
        }
        
        agreeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.agreeImg.image = UIImage.init(named: btn.isSelected ? "login_agree" : "login_disagree")
        }
        whiteBG.addSubview(agreeImg)
        agreeImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.left.equalTo(23)
            make.centerY.equalTo(userProtocolLabel)
        }
        
        whiteBG.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(54)
            make.center.equalTo(agreeImg)
        }
        agreeBtn.isSelected = true
        
        whiteBG.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.width.equalTo(354 / 2)
            make.height.equalTo(51)
            make.left.bottom.equalToSuperview()
        }
        cancelBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.isHidden = true
            self.removeFromSuperview()
        }
        
        whiteBG.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.width.equalTo(354 / 2)
            make.height.equalTo(51)
            make.right.bottom.equalToSuperview()
        }
        
        buyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.agreeBtn.isSelected{
                self.checkMoneyIsMore()
            }else{
                self.makeToast(ReadTipString)
            }
            
        }
        
        let midLine = UIView()
        midLine.backgroundColor = .init(hex: "#EEEFF0")
        whiteBG.addSubview(midLine)
        midLine.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.left.bottom.top.equalTo(buyBtn)
        }
        let botLine = UIView()
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        whiteBG.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(buyBtn)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///查询优惠券
    func getExchanggesInfo(){
        self.exchangeModels.removeAll()
        UserInfoNetworkProvider.request(.selectUsedExchange(money: self.model?.price?.doubleValue ?? 0, isVip: false)) { [self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let arr = model!.data
                            if arr != nil {
                                let mutArr = NSMutableArray()
                                for arr2 in arr!{
                                    let arr3 = arr2 as! NSArray
                                    let arr4 = arr3.kj.modelArray(SSExchangeModel.self)
                                    mutArr.add(arr4)
                                }
                                if mutArr.count > 0 {
                                    self.exchangeModels = mutArr as! [[SSExchangeModel]]
                                }
                                
                            }
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
    
    ///判断优惠券价值是否溢出
    func checkMoneyIsMore(){
        if (self.exchangeSelModel?.money ?? 0) > (self.model?.price?.doubleValue ?? 0){
            self.cancleSureAlertAction(title: "抵扣券价值大于商品价值，您购买后将不设找零，您确认购买吗？", content: "") { ac in
                self.getNetInfo(cid: self.model!.id!)
            }
        }else{
            self.getNetInfo(cid: self.model!.id!)
        }
    }
    
    func cancleSureAlertAction(title: String,content: String,sureHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: title, message: content, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "确认购买", style: .default, handler: sureHandle)
    
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        sureAction.setValue(btnColor, forKey: "_titleTextColor")
        cancelAction.setValue(color99, forKey: "_titleTextColor")
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        HQGetTopVC()?.present(alert, animated: true, completion: nil)
    }
    
    ///
    func getNetInfo(cid:String) {
        
        CourseNetworkProvider.request(.buyCourse(cid: cid, couponsId: (exchangeSelModel == nil ? "" : exchangeSelModel!.id)!, paymentType: payType)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                HQGetTopVC()?.view.makeToast("购买成功")
                            }
                            let pointsDic = model?.data?["completionJobResult"] as? NSDictionary
                            let points = pointsDic?["pointsSum"] as? String
                            if points != "0" && points != "" && points != nil{
                                ///显示获得美币
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    ShowMeibiAddView(num: points?.toInt ?? 0)
                                }
                            }
                            self.payFinishBlock?()
                            self.removeFromSuperview()
                        }else{
                            DispatchQueue.main.async {
                                let num = model?.message?.toDouble ?? 0
                                let buyView = BuyAmountView()
                                buyView.coinNumLab.text = "账户余额：\(UserInfo.getSharedInstance().xtb)贝"
                                buyView.otherNum = num
                                HQGetTopVC()?.view.addSubview(buyView)
                                buyView.snp.makeConstraints { make in
                                    make.edges.equalToSuperview()
                                }
                                HQGetTopVC()?.view.makeToast("当前余额不足，还差\(model?.message ?? "0")")
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
    
    
    func getPrice() {
        
        CourseNetworkProvider.request(.useCoupons(cid: model!.id!, couponsId: exchangeSelModel!.id!)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let price = model?.data?["useCouponsPrice"] as? Double
                            self.priceLab.text = String.init(format: "%.2f贝", price ?? 0)
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
