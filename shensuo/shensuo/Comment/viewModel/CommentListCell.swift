//
//  CommentListCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/26.
//

import UIKit

class CommentListCell: UITableViewCell {
    
    var longTouchBlock : voidBlock? = nil
    
    let Ricon = UIImageView.initWithName(imgName: "r_icon")
    let labWid = screenWid - 71
    let imgList = ListImageView()
    let headImg = UserHeadBtn()
    let userName = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    
    let authLab = UILabel.initSomeThing(title: "作者", titleColor: .white, font: .systemFont(ofSize: 11), ali: .left)
    
    let timeLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 12), ali: .left)
    let subLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    
    let moreBtn = UIButton.initImgv(imgv: .initWithName(imgName: "more_gray"))
    let moreBigBtn = UIButton()
    let topLine = UIView()
    ///作者id
    var authId = ""
    
    var reLab = UILabel.initSomeThing(title: "回复", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    
    var model:CommentModel? = nil{
        didSet{
            if model == nil {
                return
            }
            Ricon.isHidden = model!.verify == 0
            subLab.text = model?.content
            subLab.changeLineSpace(space: 10)
            subLab.sizeToFit()
            headImg.imgv.kf.setImage(with: URL.init(string: model!.headImage ?? ""), placeholder: UIImage.init(named: "user_normal_icon"))
            userName.text = model!.nickName
            userName.sizeToFit()
            imgList.imgUrlArr = model!.imgArr
            let space = imgList.viewHei > 1 ? 12 : 0
            imgList.snp.updateConstraints { make in
                make.height.equalTo(imgList.viewHei)
            }
            print("图片数量：\(model!.imgArr.count),高度：\(imgList.viewHei)")
            imgList.isHidden = model!.imgArr.count == 0
            let font = UIFont.systemFont(ofSize: 16)
            var labHei = subLab.text!.ga_heightForComment(font:font , width: labWid, maxHeight: 1000)
            ///计算行数
            labHei += CGFloat((subLab.sizeThatFits(.init(width: labWid, height: CGFloat(MAXFLOAT))).height / subLab.font.lineHeight - 1) * 8)
            if model!.cellHei == 0 {
                model!.cellHei = model!.normalHei + Int(labHei) + Int(imgList.viewHei) + space
            }
            self.authLab.isHidden = model?.userId != authId
            self.authLab.snp.updateConstraints { make in
                make.width.equalTo(model?.userId != authId ? 0 : 25)
            }
            timeLab.text = model!.createdTime
//                model!.createdTime?.formatWithData(dateFormat: "YYYY/MM/dd HH:mm")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        imgList.leftSpace = 61
        imgList.rightSpace = 46
        imgList.imgSpace = 8
        self.contentView.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.top.equalTo(15)
            make.left.equalTo(16)
        }
        headImg.layer.cornerRadius = 17.5
        headImg.layer.masksToBounds = true
        
        self.contentView.addSubview(Ricon)
        Ricon.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.left.equalTo(headImg).offset(24)
            make.top.equalTo(headImg).offset(25)
        }
        
        self.contentView.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.left.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(headImg).offset(7)
        }
        
        authLab.backgroundColor = .init(hex: "#FD8024")
        self.contentView.addSubview(authLab)
        authLab.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(25)
            make.centerY.equalTo(userName)
            make.left.equalTo(userName.snp.right).offset(10)
        }
        
        let userBtn = UIButton()
        self.contentView.addSubview(userBtn)
        userBtn.snp.makeConstraints { make in
            make.left.equalTo(headImg)
            make.right.equalTo(userName)
            make.height.equalTo(headImg)
            make.top.equalTo(headImg)
        }
        userBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            GotoTypeVC(type: 99, cid: self.model?.userId ?? "")
        }
        
//        self.contentView.addSubview(moreBtn)
//        moreBtn.snp.makeConstraints { make in
//            make.width.equalTo(22)
//            make.height.equalTo(4)
//            make.centerY.equalTo(userName)
//            make.right.equalTo(-10)
//        }
//        
//        self.contentView.addSubview(moreBigBtn)
//        moreBigBtn.snp.makeConstraints { make in
//            make.width.height.equalTo(44)
//            make.center.equalTo(moreBtn)
//        }
        subLab.numberOfLines = 0
        self.contentView.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.left.equalTo(61)
            make.right.equalTo(-10)
            make.top.equalTo(userName.snp.bottom).offset(8)
        }
        
        self.contentView.addSubview(imgList)
        imgList.snp.makeConstraints { make in
            make.left.equalTo(61)
            make.right.equalTo(-46)
            make.height.equalTo(0)
            make.top.equalTo(subLab.snp.bottom).offset(12)
        }
        
        self.contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.bottom.equalTo(-24)
            make.left.equalTo(imgList)
        }
        
        timeLab.sizeToFit()
        
        self.contentView.addSubview(reLab)
        reLab.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.centerY.equalTo(timeLab)
            make.left.equalTo(timeLab.snp.right).offset(10)
        }
        
        topLine.backgroundColor = .init(hex: "#EEEFF0")
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(addLongPressGesture))
        // 长按手势最小触发时间
        longTap.minimumPressDuration = 1.0
        // 长按手势需要的同时敲击触碰数（手指数）
        longTap.numberOfTouchesRequired = 1
        // 长按有效移动范围（从点击开始，长按移动的允许范围 单位 px
        longTap.allowableMovement = 15
        self.addGestureRecognizer(longTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func addLongPressGesture(){
        self.longTouchBlock?()
    }
    
}
