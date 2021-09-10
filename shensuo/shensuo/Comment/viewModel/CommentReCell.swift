//
//  CommentReCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/17.
//

import UIKit
///回复cell
class CommentReCell: UITableViewCell {
    var reLab = UILabel.initSomeThing(title: "回复", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    
    var authId = ""
    
    var longTouchBlock : voidBlock? = nil
    
    let Ricon = UIImageView.initWithName(imgName: "r_icon")
    let labWid = screenWid - 108
    let imgList = ListImageView()
    let headImg = UserHeadBtn()
    
    
    let authLab = UILabel.initSomeThing(title: "作者", titleColor: .white, font: .systemFont(ofSize: 11), ali: .left)
    let userName = UILabel.initSomeThing(title: " ", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    let otherUserName = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    let timeLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 12), ali: .left)
    let subLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .left)
    
    let moreBtn = UIButton.initImgv(imgv: .initWithName(imgName: "more_gray"))
    let moreBigBtn = UIButton()
    
    var model:ReplyListModel? = nil{
        didSet{
            if model == nil {
                return
            }
            Ricon.isHidden = model!.verify == 0
            otherUserName.text = model?.atNickName
            subLab.text = model?.content
            subLab.sizeToFit()
            headImg.imgv.kf.setImage(with: URL.init(string: model!.headImage ?? ""), placeholder: UIImage.init(named: "user_normal_icon"))
            if (model?.nickName?.length ?? 0) > 7{
                userName.text = "\(model!.nickName!.subString(to: 6))…"
            }else{
                userName.text = model!.nickName
            }
            
            let uSize = userName.sizeThatFits(.init(width: 200, height: 20))
            userName.snp.updateConstraints { make in
                make.width.equalTo(uSize.width)
            }
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
            timeLab.text = model!.createdTime
            
            self.authLab.snp.updateConstraints { make in
                make.width.equalTo(model?.userId != authId ? 0 : 25)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        imgList.leftSpace = 98
        imgList.rightSpace = 46
        imgList.imgSpace = 6
        self.contentView.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(8)
            make.left.equalTo(57)
        }
        headImg.layer.cornerRadius = 15
        headImg.layer.masksToBounds = true
        
        self.contentView.addSubview(Ricon)
        Ricon.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.left.equalTo(headImg).offset(21)
            make.top.equalTo(headImg).offset(23)
        }
        
        self.contentView.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.left.equalTo(headImg.snp.right).offset(11)
            make.height.equalTo(20)
            make.top.equalTo(headImg).offset(3)
            make.width.equalTo(10)
        }
        
        authLab.backgroundColor = .init(hex: "#FD8024")
        self.contentView.addSubview(authLab)
        authLab.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(25)
            make.centerY.equalTo(userName)
            make.left.equalTo(userName.snp.right).offset(10)
        }
        
        let reIcon = UIImageView.initWithName(imgName: "recomment_row")
        self.contentView.addSubview(reIcon)
        reIcon.snp.makeConstraints { make in
            make.left.equalTo(authLab.snp.right).offset(10)
            make.width.equalTo(9)
            make.height.equalTo(11)
            make.centerY.equalTo(userName)
        }
        
        self.contentView.addSubview(otherUserName)
        otherUserName.snp.makeConstraints { make in
            make.left.equalTo(reIcon.snp.right).offset(12)
            make.height.equalTo(20)
            make.top.equalTo(userName)
            make.right.equalTo(-60)
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
            make.left.equalTo(98)
            make.right.equalTo(-10)
            make.top.equalTo(userName.snp.bottom).offset(9)
        }
        
        self.contentView.addSubview(imgList)
        imgList.snp.makeConstraints { make in
            make.left.equalTo(98)
            make.right.equalTo(-46)
            make.height.equalTo(0)
            make.top.equalTo(subLab.snp.bottom).offset(12)
        }
        
        self.contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.bottom.equalTo(-24)
            make.left.equalTo(imgList)
            make.right.equalTo(-10)
        }
        
        self.contentView.addSubview(reLab)
        reLab.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.centerY.equalTo(timeLab)
            make.left.equalTo(timeLab.snp.right).offset(10)
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

