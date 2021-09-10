//
//  VipMidView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/10.
//

import UIKit

class VipMidView: UIView {
    
    var exchangeSelBlock : stringBlock? = nil
    
    let titleLab = UILabel.initSomeThing(title: "会员专享特权", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 17), ali: .center)
    
    let zunGuiBtn = UIButton.initTopImgBtn(imgName: "会员_尊贵标识", titleStr: "尊贵标识", titleColor: .black, font: .MediumFont(size: 14), imgWid: 52)
    let freeBtn = UIButton.initTopImgBtn(imgName: "会员_免费课程", titleStr: "免费课程", titleColor: .black, font: .MediumFont(size: 14), imgWid: 52)
    let free2Btn = UIButton.initTopImgBtn(imgName: "会员_免费方案", titleStr: "免费方案", titleColor: .black, font: .MediumFont(size: 14), imgWid: 52)
    let maxBtn = UIButton.initTopImgBtn(imgName: "会员_优先接待", titleStr: "优先接待", titleColor: .black, font: .MediumFont(size: 14), imgWid: 52)
    let waitBtn = UIButton.initTopImgBtn(imgName: "会员_敬请期待", titleStr: "敬请期待", titleColor: .black, font: .MediumFont(size: 14), imgWid: 52)

    
    let quanLab = UILabel.initSomeThing(title: "选择优惠券", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .right)
    
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
                self.quanLab.text = exchangeSelModel!.name
                self.exchangeSelBlock?(exchangeSelModel?.id ?? "")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
        }
        titleLab.sizeToFit()
        
        let leftImg = UIImageView.initWithName(imgName: "vip_title_left")
        self.addSubview(leftImg)
        leftImg.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(38)
            make.right.equalTo(titleLab.snp.left).offset(-7)
        }
        
        let rightImg = UIImageView.initWithName(imgName: "vip_title_right")
        self.addSubview(rightImg)
        rightImg.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(38)
            make.left.equalTo(titleLab.snp.right).offset(7)
        }
        
        let btnHei = 80
        let btnWid = screenWid / 3
        self.addSubview(zunGuiBtn)
        zunGuiBtn.snp.makeConstraints { make in
            make.height.equalTo(btnHei)
            make.left.equalTo(0)
            make.width.equalTo(btnWid)
            make.top.equalTo(44)
        }
        
        self.addSubview(freeBtn)
        freeBtn.snp.makeConstraints { make in
            make.height.equalTo(btnHei)
            make.left.equalTo(btnWid)
            make.width.equalTo(btnWid)
            make.top.equalTo(zunGuiBtn)
        }
        
        self.addSubview(free2Btn)
        free2Btn.snp.makeConstraints { make in
            make.height.equalTo(btnHei)
            make.right.equalTo(0)
            make.width.equalTo(btnWid)
            make.top.equalTo(zunGuiBtn)
        }
        
        self.addSubview(maxBtn)
        maxBtn.snp.makeConstraints { make in
            make.height.equalTo(btnHei)
            make.left.equalTo(0)
            make.width.equalTo(btnWid)
            make.top.equalTo(zunGuiBtn.snp.bottom).offset(23)
        }
        
        self.addSubview(waitBtn)
        waitBtn.snp.makeConstraints { make in
            make.height.equalTo(btnHei)
            make.left.equalTo(btnWid)
            make.width.equalTo(btnWid)
            make.top.equalTo(maxBtn)
        }
        
        self.addSubview(quanLab)
        quanLab.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.right.equalTo(-16)
            make.left.equalTo(100)
            make.bottom.equalTo(-16)
        }
        
//        let rIcon1 = UIImageView.initWithName(imgName: "right_black_nobg")
//        self.addSubview(rIcon1)
//        rIcon1.snp.makeConstraints { make in
//            make.width.height.equalTo(16)
//            make.right.equalTo(-16)
//            make.centerY.equalTo(quanLab)
//        }
        
        let quanTip = UILabel.initSomeThing(title: "支付方式", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
        self.addSubview(quanTip)
        quanTip.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(80)
            make.centerY.equalTo(quanLab)
            make.left.equalTo(16)
        }
        
        self.quanLab.text = "形体贝支付"
        
//        let quanBtn = UIButton()
//        self.addSubview(quanBtn)
//        quanBtn.snp.makeConstraints { make in
//            make.bottom.equalTo(0)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(54)
//        }
//        quanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
//            let selView = ExchangeSelView()
//            selView.needBG = true
//            selView.exchangeModels = self.exchangeModels as NSArray
//            HQGetTopVC()?.view.addSubview(selView)
//            selView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//            selView.selBlock = {[weak self] index in
//                if index == 999{
//                    self?.quanLab.text = "暂不使用券"
//                    self?.exchangeSelModel = nil
//                    selView.removeFromSuperview()
//                    return
//                }
//                let arr = self?.exchangeModels[index]
//                if arr != nil{
//                    for model in arr!{
//                        if model.used {
//                            self?.exchangeSelModel = model
//                            selView.removeFromSuperview()
//                            return
//                        }
//                    }
//                }
//                
//                selView.removeFromSuperview()
//            }
//        }
//        
//        self.getExchanggesInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///查询优惠券
    func getExchanggesInfo(){
        self.exchangeModels.removeAll()
        UserInfoNetworkProvider.request(.selectUsedExchange(money: Double(UserInfo.getSharedInstance().vipPrice ?? 0), isVip: true)) { [self] result in
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
}
