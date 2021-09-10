//
//  GoodCompanyListCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/6.
//

import UIKit

class GoodCompanyListCell: UITableViewCell {

    let whiteBg = UIView()
    
    let bgImg = UIImageView.initWithName(imgName: "company_cell_bg")
    
    let headImg = UIImageView()
    
    let rIcon = UIImageView.initWithName(imgName: "r_icon")
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .MediumFont(size: 17), ali: .left)
    
    let vipIcon = UIImageView.initWithName(imgName: "my_newisvip")
    
    let checkIcon = UIImageView.initWithName(imgName: "company_cell_check")
    
    let subLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .systemFont(ofSize: 13), ali: .left)
    
    let focusBtn = UIButton.initWithLineBtn(title: "关注", font: .systemFont(ofSize: 13), titleColor: .white, bgColor: .clear, lineColor: .init(hex: "#FD8024"), cr: 13)
    
    let focusBtn2 = UIButton.initImgv(imgv: .initWithName(imgName: "company_cell_focus"))
    
    let localImg = UIImageView.initWithName(imgName: "company_local_icon")
    
    let localLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 13), ali: .left)
    
    var model : GoodCompanyListModel? = nil{
        didSet{
            if model != nil {
                self.headImg.kf.setImage(with: URL.init(string: model?.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.nameLab.text = model?.nickName
                self.nameLab.sizeToFit()
                self.vipIcon.isHidden = !(model?.vip ?? false)
                self.subLab.text = model?.showWords
                self.localLab.text = model?.address
                self.focusBtn.isHidden = (model?.concern ?? false)
                self.focusBtn2.isHidden = !self.focusBtn.isHidden
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .init(hex: "#F7F8F9")
        self.selectionStyle = .none
        
        whiteBg.layer.cornerRadius = 16
        whiteBg.layer.masksToBounds = true
        whiteBg.backgroundColor = .white
        self.contentView.addSubview(whiteBg)
        whiteBg.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(168)
            make.top.equalToSuperview()
        }
        
        whiteBg.addSubview(bgImg)
        bgImg.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(118)
        }
        
        let headBG = UIView()
        headBG.backgroundColor = .white
        headBG.layer.cornerRadius = 33
        headBG.layer.masksToBounds = true
        whiteBg.addSubview(headBG)
        headBG.snp.makeConstraints { make in
            make.width.height.equalTo(66)
            make.left.equalTo(11)
            make.centerY.equalTo(bgImg)
        }
        
        headImg.layer.cornerRadius = 32
        headImg.layer.masksToBounds = true
        whiteBg.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.center.equalTo(headBG)
        }
        
        whiteBg.addSubview(rIcon)
        rIcon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.right.bottom.equalTo(headBG)
        }
        
        whiteBg.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(headBG.snp.right).offset(8)
            make.top.equalTo(32)
        }
        nameLab.sizeToFit()
        
        whiteBg.addSubview(vipIcon)
        vipIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(nameLab.snp.right).offset(4)
            make.centerY.equalTo(nameLab)
        }
        
        whiteBg.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(24)
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab).offset(30)
        }
        
        whiteBg.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.right.equalTo(-71)
            make.left.equalTo(checkIcon.snp.right).offset(8)
            make.centerY.equalTo(checkIcon)
        }
        
        whiteBg.addSubview(focusBtn)
        whiteBg.addSubview(focusBtn2)
        focusBtn.snp.makeConstraints { make in
            make.width.equalTo(62)
            make.height.equalTo(28)
            make.centerY.equalTo(bgImg)
            make.right.equalTo(-11)
        }
        
        focusBtn2.snp.makeConstraints { make in
            make.width.equalTo(62)
            make.height.equalTo(28)
            make.centerY.equalTo(bgImg)
            make.right.equalTo(-11)
        }
        focusBtn2.isHidden = true
        
        focusBtn2.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.focusBtnClick()
        }
        focusBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.focusBtnClick()
        }
        
        whiteBg.addSubview(localImg)
        localImg.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalTo(-13)
            make.left.equalTo(6)
        }
        
        whiteBg.addSubview(localLab)
        localLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.right.equalTo(-11)
            make.left.equalTo(29)
            make.bottom.equalTo(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func focusBtnClick(){
        UserInfoNetworkProvider.request(.focusOption(focusUserId: model?.id ?? "")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                let flag = dic?["type"] as? Bool ?? false
                                if (!flag) {
                                    HQGetTopVC()?.view.makeToast("取消成功")
                                    self.focusBtn2.isHidden = true
                                    self.focusBtn.isHidden = false
                                }else{
                                    HQGetTopVC()?.view.makeToast("关注成功")
                                    self.focusBtn2.isHidden = false
                                    self.focusBtn.isHidden = true
                                }
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
