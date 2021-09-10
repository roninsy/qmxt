//
//  QianDaoDetalisView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/9.
//

import UIKit
import BSText
import MBProgressHUD

class QianDaoDetalisView: UIView {
    var closeBlock : voidBlock? = nil
    let numLabel = BSLabel()
    let topImg = UIImageView.initWithName(imgName: "qiandao_top")
    let viewWid = screenWid - 90
    let viewHei = (screenWid - 90) / 325 * 394
    let bgView = UIView()
    let closeBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "qiandao_close"))
    let tipTitle = UILabel.initSomeThing(title: "说明：", fontSize: 14, titleColor: .init(hex: "#999999"))
    let enterBtn = UIButton.initTitle(title: "立即签到", fontSize: 16, titleColor: .white, bgColor: .init(hex: "#FD8024"))
    var items : [QianDaoItemView] = NSMutableArray() as! [QianDaoItemView]
    var model : SignModel? = nil{
        didSet{
            self.tipTitle.text = model?.remark
            self.tipTitle.sizeToFit()
            var isToday = false
            let count = (model!.signList?.count ?? 0)
            if count > 1{
                for i in 0...(count-1){
                    let it = items[i]
                    let md = model!.signList![i]
                    it.coinNumLab.text = "+\(md.points!)"
                    if md.sign! {
                        it.finishIcon.isHidden = false
                        it.dayLab.isHidden = true
                    }else{
                        it.dayLab.text = self.getDayText(isToday: isToday, num: i)
                        isToday = false
                    }
                    if md.today! {
                        it.whiteView.isHidden = true
                        isToday = true
                        if md.sign! {
                            self.enterBtn.setTitle("已签到", for: .normal)
                            self.enterBtn.isEnabled = false
                        }
                    }
                }
            }
            let str = model?.signDay
            if str != nil && str!.length > 6{
                let protocolText = NSMutableAttributedString(string: str!)
                numLabel.textColor = .init(hex: "#333333")
                numLabel.font = .systemFont(ofSize: 15)
                protocolText.bs_set(color: .init(hex: "#EF0B19"), range: NSRange.init(location: str!.length - 2, length: 1))
                protocolText.bs_font = .systemFont(ofSize: 15)
                numLabel.attributedText = protocolText
                numLabel.sizeToFit()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HQColor(r: 0, g: 0, b: 0, a: 0.41)
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo((screenHei - viewHei) * 0.4)
            make.width.equalTo(viewWid)
            make.height.equalTo(viewHei)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(topImg)
        topImg.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.top).offset(30)
            make.width.equalTo(240)
            make.height.equalTo(74)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(45)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        closeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.closeBlock?()
            HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = false
            self.removeFromSuperview()
        }
        

        self.bgView.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topImg.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        numLabel.sizeToFit()
        
        let imgv = UIImageView.initWithName(imgName: "qiandao_all")
        self.bgView.addSubview(imgv)
        imgv.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.right.equalTo(numLabel.snp.left).offset(-4)
            make.centerY.equalTo(numLabel)
        }
        
        for i in 0...6 {
            let item = QianDaoItemView()
            self.bgView.addSubview(item)
            if i < 4 {
                item.snp.makeConstraints { (make) in
                    make.width.equalTo(item.viewWid)
                    make.height.equalTo(item.viewHei)
                    make.left.equalTo(23 + i * (Int(item.viewWid) + 8))
                    make.top.equalTo(topImg.snp.bottom).offset(34)
                }
            }else{
                item.snp.makeConstraints { (make) in
                    make.width.equalTo(item.viewWid)
                    make.height.equalTo(item.viewHei)
                    make.left.equalTo(23 + item.viewWid * 0.5 + (CGFloat(i) - 4) * (item.viewWid + 8))
                    make.top.equalTo(topImg.snp.bottom).offset(34 + 9 + item.viewHei)
                }
            }
            items.append(item)
            
        }
        
        
        
        enterBtn.layer.cornerRadius = 22.5
        enterBtn.layer.masksToBounds = true
        self.bgView.addSubview(self.enterBtn)
        self.enterBtn.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(45)
            make.bottom.equalTo(-16)
        }
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.signNow()
        }
        
        tipTitle.numberOfLines = 0
        self.bgView.addSubview(tipTitle)
        tipTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(enterBtn.snp.top).offset(-20)
            make.left.right.equalTo(enterBtn)
        }
        tipTitle.sizeToFit()
        
        self.upInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func upInfo(){
        
        UserNetworkProvider.request(.sign) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            if model?.data != nil {
                                let signModel : SignModel? = model!.data!.kj.model(type: SignModel.self) as? SignModel
                                self.model = signModel
                            }
                        }else{

                        }
                    }
                } catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func signNow(){
        UserNetworkProvider.request(.signNow) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultBoolModel.self)
                        if model?.code == 0 {
                            self.upInfo()
                        }
                    }
                } catch {

                }
            
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func getDayText(isToday:Bool,num:Int)->String{
        if isToday{
            return "明天"
        }else{
            var day = ""
            if num == 0 {
                day = "一"
            }
            if num == 1 {
                day = "二"
            }
            if num == 2 {
                day = "三"
            }
            if num == 3 {
                day = "四"
            }
            if num == 4 {
                day = "五"
            }
            if num == 5 {
                day = "六"
            }
            if num == 6 {
                day = "七"
            }
            return "第\(day)天"
        }
    }
}
