//
//  SearchUserListCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit

class SearchUserListCell: UITableViewCell {

    let headView = UIImageView()
    let Ricon = UIImageView.initWithName(imgName: "r_icon")
    
    let nameLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 17), ali: .left)
    
    let vipIcon = UIImageView.initWithName(imgName: "my_newisvip")
    
    let checkIcon = UIImageView()
    let subLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 13), ali: .left)
    
    let focusBtn = UIButton.initTitle(title: "关注", font: .MediumFont(size: 13), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    let focusBtn2 = UIButton.initWithLineBtn(title: "已关注", font: .MediumFont(size: 13), titleColor: .init(hex: "#CBCCCD"), bgColor: .white, lineColor: .init(hex: "#CBCCCD"), cr: 16)
    
    let detalisLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .left)
    
    let botLine = UIView()
    
    var model : SSFocusPopModel? = nil{
        didSet{
            if model != nil {
                self.headView.kf.setImage(with: URL.init(string: model!.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                self.Ricon.isHidden = (model?.userType ?? 0) == 0
                self.nameLab.text = model?.nickName
                let maxWid = screenWid - 230
                var wid = nameLab.sizeThatFits(.init(width: (maxWid), height: 24)).width
                if wid > maxWid{
                    wid = maxWid
                }
                nameLab.snp.updateConstraints { make in
                    make.width.equalTo(wid)
                }
                
                self.vipIcon.isHidden = !(model?.vip ?? false)
                self.checkIcon.isHidden = (model?.userType ?? 0) == 0
                self.checkIcon.image = UIImage.init(named: (model?.userType ?? 0) == 2 ? "check_person_search" : "check_com_search")
                self.subLab.isHidden = self.checkIcon.isHidden
                if (model?.userType ?? 0) == 2 {
                    self.subLab.text = model?.showWords
                }else{
                    self.subLab.text = model?.enterpriseSgs
                }
                
                self.detalisLab.isHidden = (model?.userType ?? 0) != 0
                self.detalisLab.text = model?.introduce
                self.focusBtn.isHidden = model?.concern ?? false
                self.focusBtn2.isHidden = !self.focusBtn.isHidden
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "reuseIdentifier")
        self.selectionStyle = .none
        headView.layer.cornerRadius = 32
        headView.layer.masksToBounds = true
        self.contentView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(Ricon)
        Ricon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.right.bottom.equalTo(headView)
        }
        
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(headView.snp.right).offset(12)
            make.top.equalTo(22)
            make.width.equalTo(30)
        }
        
        self.contentView.addSubview(vipIcon)
        vipIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(nameLab.snp.right).offset(4)
            make.centerY.equalTo(nameLab)
        }
        
        self.contentView.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(72)
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(4)
        }
        
        self.contentView.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(checkIcon.snp.right).offset(4)
            make.centerY.equalTo(checkIcon)
            make.right.equalTo(-90)
        }
        
        self.contentView.addSubview(detalisLab)
        detalisLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalTo(nameLab)
            make.centerY.equalTo(checkIcon)
            make.right.equalTo(-90)
        }
        
        focusBtn.layer.cornerRadius = 16
        focusBtn.layer.masksToBounds = true
        self.addSubview(focusBtn)
        focusBtn.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(32)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(focusBtn2)
        focusBtn2.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(32)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        focusBtn2.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.focusBtnClick()
        }
        focusBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.focusBtnClick()
        }
        
        botLine.backgroundColor = .init(hex: "#EEEFF1")
        self.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
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
                                let flag = dic?["type"] as? Bool ?? true
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
