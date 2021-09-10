//
//  SSMessageCell.swift
//  shensuo
//
//  Created by  yang on 2021/4/12.
//

import UIKit

enum messageType {
    case pushMessage
    
}

public let TitleWidth = 100

//取消关注
class SSUnLikeMessageCell : UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "取消关注通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有一个取消关注", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let typeContent = UILabel.initSomeThing(title: "取关粉丝：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let type = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let typeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    var cid = ""
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content
                typeValue.text = model?.typeName
                let dict = model?.otherContent
                
                self.cid = dict?["fansId"] as? String ?? ""
                contentValue.text = dict?["fansName"] as? String
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() -> Void {
        
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
        }
        
        contentView.addSubview(typeContent)
        typeContent.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentValue)
        contentValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeContent)
            make.left.equalTo(typeContent.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
            
        }
        
        contentView.addSubview(type)
        type.snp.makeConstraints { (make) in
            make.top.equalTo(typeContent.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(typeValue)
        typeValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(type)
            make.left.equalTo(type.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(type.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                GotoTypeVC(type: 99, cid: self.cid)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//关注/新粉丝/取消关注
class SSMessageCell: UITableViewCell {
    ///0新粉丝 1取消关注
    var pushType = 0
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "新粉丝通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有一个新粉丝", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let typeContent = UILabel.initSomeThing(title: "粉丝：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let type = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let typeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content
                typeValue.text = model?.typeName
                let dict = model?.otherContent
                
                contentValue.text = dict?["fansName"] as? String
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() -> Void {
        
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
        }
        
        contentView.addSubview(typeContent)
        typeContent.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentValue)
        contentValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeContent)
            make.left.equalTo(typeContent.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
            
        }
        
        contentView.addSubview(type)
        type.snp.makeConstraints { (make) in
            make.top.equalTo(typeContent.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(typeValue)
        typeValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(type)
            make.left.equalTo(type.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(type.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                let vc = SSFocusListViewController.init()
                vc.type = .FriendList
                HQPush(vc: vc, style: .default)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//用户加入课程
class SSJoinMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "新动态/课程/方案通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有一个新动态", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let contentType = UILabel.initSomeThing(title: "内容类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let typeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "内容标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let titleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let payType = UILabel.initSomeThing(title: "付费类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let payValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let price = UILabel.initSomeThing(title: "市场价：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let priceValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let join = UILabel.initSomeThing(title: "加入者：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let joinValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let teacher = UILabel.initSomeThing(title: "导师：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let teacherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let copyRight = UILabel.initSomeThing(title: "版权所有：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let copyRightValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var type = 0
    var cid = ""
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content
                
                let dict = model?.otherContent
                self.cid = dict?["contentId"] as? String ?? ""
                typeValue.text = self.contentTypeNameWithType(type: dict?["contentType"] as? String ?? "")
                titleValue.text = dict?["contentTitle"] as? String
                payValue.text = dict?["paymentType"] as? String
                priceValue.text = dict?["marketPrice"] as? String
                joinValue.text = dict?["joiner"] as? String
                teacherValue.text = dict?["tutor"] as? String
                copyRightValue.text = dict?["copyrightOwner"] as? String
                messageTypeValue.text = model?.typeName
            }
        }
    }
    
    func contentTypeNameWithType(type:String)->String{
//        NOTE("note", "动态"),
        if type == "note" {
            self.type = 4
            return "动态"
        }
//            COURSE("course", "课程"),
        if type == "course" {
            self.type = 2
            return "课程"
        }
//            COURSE_SECTION("course_section", "课程小节"),
        if type == "course_section" {
            self.type = 2
            return "课程小节"
        }
//            PLAN("plan", "方案"),
        if type == "plan" {
            self.type = 3
            return "方案"
        }
//            PLAN_SECTION("plan_section", "方案小节"),
        if type == "plan_section" {
            self.type = 3
            return "方案小节"
        }
//            DIARY("diary", "美丽日记"),
        if type == "diary" {
            self.type = 5
            return "美丽日记"
        }
//            ALBUM("album", "美丽相册"),
        if type == "album" {
            self.type = 6
            return "美丽相册"
        }
//            PERSONAL("personal", "个人"),
        if type == "personal" {
            self.type = -1
            return "个人"
        }
//            COMMENT("comment", "评论"),
        if type == "comment" {
            
            return "评论"
        }
        return ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            
        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(typeValue)
        typeValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentType)
            make.left.equalTo(contentType.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
            
        }
        contentView.addSubview(titleValue)
        titleValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentTitle)
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(payType)
        payType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(payValue)
        payValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(payType)
            make.left.equalTo(payType.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(payType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(priceValue)
        priceValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(price)
            make.left.equalTo(price.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(join)
        join.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(price.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(joinValue)
        joinValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(join)
            make.left.equalTo(join.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(teacher)
        teacher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(join.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(teacherValue)
        teacherValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(teacher)
            make.left.equalTo(teacher.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(copyRight)
        copyRight.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(teacher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(copyRightValue)
        copyRightValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(copyRight)
            make.left.equalTo(copyRight.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(copyRight.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(messageType)
            make.left.equalTo(messageType.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageType.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = CoureseLearnNumsVC()
            vc.cid = self.cid
            HQPush(vc: vc, style: .default)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//获得现金通知
class SSCrashMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "获得现金通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有一个新动态", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentType = UILabel.initSomeThing(title: "内容类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "内容标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let price = UILabel.initSomeThing(title: "市场价：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let priceValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let crash = UILabel.initSomeThing(title: "获得现金：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let crashValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let buyer = UILabel.initSomeThing(title: "购买者：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let buyerValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let teacher = UILabel.initSomeThing(title: "导师：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let teacherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let copyRight = UILabel.initSomeThing(title: "版权所有：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let copyRightValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content

                let dict = model?.otherContent
                contentTypeValue.text = dict?["contentType"] as? String
                contentTitleValue.text = dict?["contentTitle"] as? String
                priceValue.text = dict?["marketPrice"] as? String
                crashValue.text = dict?["cashAmount"] as? String
                buyerValue.text = dict?["buyers"] as? String
                teacherValue.text = dict?["tutor"] as? String
                copyRightValue.text = dict?["copyrightOwner"] as? String
                teacherValue.text = dict?["tutor"] as? String
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            
        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTypeValue)
        contentTypeValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentType)
            make.left.equalTo(contentType.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
            
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentTitle)
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(priceValue)
        priceValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(price)
            make.left.equalTo(price.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(crash)
        crash.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(price.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(crashValue)
        crashValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(crash)
            make.left.equalTo(crash.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }

        contentView.addSubview(buyer)
        buyer.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(crash.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(buyerValue)
        buyerValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(buyer)
            make.left.equalTo(buyer.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }

        contentView.addSubview(teacher)
        teacher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(buyer.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(teacherValue)
        teacherValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(teacher)
            make.left.equalTo(teacher.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(copyRight)
        copyRight.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(teacher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(copyRightValue)
        copyRightValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(copyRight)
            make.left.equalTo(copyRight.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(copyRight.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(messageType)
            make.left.equalTo(messageType.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageTypeValue.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = SSAccountDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            HQPush(vc: vc, style: .default)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//购买付费课程
class SSBuyMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "购买付费课程", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有一个新动态", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentType = UILabel.initSomeThing(title: "内容类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "内容标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let payType = UILabel.initSomeThing(title: "付费类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let payTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let price = UILabel.initSomeThing(title: "市场价：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let priceValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let buyer = UILabel.initSomeThing(title: "购买者：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let buyerValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let teacher = UILabel.initSomeThing(title: "导师：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let teacherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let copyRight = UILabel.initSomeThing(title: "版权所有：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let copyRightValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content

                let dict = model?.otherContent
                contentTypeValue.text = dict?["contentType"] as? String
                contentTitleValue.text = dict?["contentTitle"] as? String
                payTypeValue.text = dict?["paymentType"] as? String
                priceValue.text = dict?["marketPrice"] as? String
                teacherValue.text = dict?["tutor"] as? String
                copyRightValue.text = dict?["copyrightOwner"] as? String
                contentTypeValue.text = dict?["contentType"] as? String
                buyerValue.text = dict?["buyer"] as? String
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            
        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTypeValue)
        contentTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentType.snp.right).offset(8)
            make.centerY.equalTo(contentType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
            
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.centerY.equalTo(contentTitle)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(payType)
        payType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(payTypeValue)
        payTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(payType.snp.right).offset(8)
            make.centerY.equalTo(payType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(payType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(priceValue)
        priceValue.snp.makeConstraints { (make) in
            make.left.equalTo(price.snp.right).offset(8)
            make.centerY.equalTo(price)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(buyer)
        buyer.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(price.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(buyerValue)
        buyerValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(buyer)
            make.left.equalTo(buyer.snp.right).offset(8)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(teacher)
        teacher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(buyer.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(teacherValue)
        teacherValue.snp.makeConstraints { (make) in
            make.left.equalTo(teacher.snp.right).offset(8)
            make.centerY.equalTo(teacher)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(copyRight)
        copyRight.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(teacher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(copyRightValue)
        copyRightValue.snp.makeConstraints { (make) in
            make.left.equalTo(copyRight.snp.right).offset(8)
            make.centerY.equalTo(copyRight)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(copyRight.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageType.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = SSAccountDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            HQPush(vc: vc, style: .default)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//我的礼物
class SSMyGiftMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "收礼", fontSize: 17, titleColor: .init(hex: "#333333"))
    let point = UILabel.initSomeThing(title: "+500美币", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    
//    let content = UILabel.initSomeThing(title: "有一个新动态", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentType = UILabel.initSomeThing(title: "订单号：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "服务：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outher = UILabel.initSomeThing(title: "礼物：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let outherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let receive = UILabel.initSomeThing(title: "收礼方：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let receiveValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let giver = UILabel.initSomeThing(title: "送礼方：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let giverValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "时间：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let ischeck = UILabel.initSomeThing(title: "是否已转账户余额：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let ischeckValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let checkTime = UILabel.initSomeThing(title: "转化时间：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let checkTimeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var model:SSGiftMessageModel? = nil{
        didSet{
            if model != nil {
                if model?.type == 0 {
                    title.text = "收礼"
                    giver.text = "送礼方："
                    giverValue.text = model?.payer
                } else {
                    title.text = "送礼"
                    giver.text = "收礼方："
                    giverValue.text = model?.payee
                }
                
                point.text = "\(model?.points ?? "")美币"
                contentTypeValue.text = model?.id
                contentTitleValue.text = model?.remarks
                outherValue.text = model?.giftNameAndQuantity
                receiveValue.text = model?.payee
                messageTypeValue.text = model?.giftTime
                ischeckValue.text =  "是"
                checkTimeValue.text = model?.giftTime
                checkTime.isHidden = model?.type == 0 ? false : true
                ischeckValue.isHidden = model?.type == 0 ? false : true
                ischeck.isHidden = model?.type == 0 ? false : true
                checkTimeValue.isHidden = model?.type == 0 ? false : true
                
//                let endDate = NSDate.init(timeIntervalSince1970: (dict?["convertedTime"] as? Double)!/1000)
//                let dateFormat = DateFormatter.init()
//                dateFormat.dateStyle = .short
//                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
//                checkTimeValue.text = dateFormat.string(from: endDate as Date)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.font = UIFont.SemiboldFont(size: 17)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(point)
        point.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
//        contentView.addSubview(content)
//        content.numberOfLines = 0
//        content.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(firstLine.snp.bottom).offset(16)
//
//        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTypeValue)
        contentTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentType.snp.right).offset(8)
            make.centerY.equalTo(contentType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.centerY.equalTo(contentTitle)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(outher)
        outher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(outherValue)
        outherValue.snp.makeConstraints { (make) in
            make.left.equalTo(outher.snp.right).offset(8)
            make.centerY.equalTo(outher)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(giver)
        giver.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(outher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(giverValue)
        giverValue.snp.makeConstraints { (make) in
            make.left.equalTo(giver.snp.right).offset(8)
            make.centerY.equalTo(giver)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(giver.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(ischeck)
        ischeck.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(150)
            make.top.equalTo(messageType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(ischeckValue)
        ischeckValue.snp.makeConstraints { (make) in
            make.left.equalTo(ischeck.snp.right).offset(8)
            make.centerY.equalTo(ischeck)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(checkTime)
        checkTime.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(ischeck.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(checkTimeValue)
        checkTimeValue.snp.makeConstraints { (make) in
            make.left.equalTo(checkTime.snp.right).offset(8)
            make.centerY.equalTo(checkTime)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
//        contentView.addSubview(secLine)
//        secLine.backgroundColor = .init(hex: "#EEEFF0")
//        secLine.snp.makeConstraints { (make) in
//            make.top.equalTo(checkTimeValue.snp.bottom).offset(16)
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.height.equalTo(1)
//        }
//        contentView.addSubview(detailBtn)
//        detailBtn.setTitle("详情", for: .normal)
//        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
//        detailBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(secLine.snp.bottom).offset(16)
//            make.left.equalTo(10)
//            make.width.equalTo(40)
//            make.height.equalTo(18)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//收礼通知
class SSGiftMessageCell: UITableViewCell {
    var type = 99
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "收礼通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    
    let content = UILabel.initSomeThing(title: "有一个新动态", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentType = UILabel.initSomeThing(title: "内容类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "内容标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outher = UILabel.initSomeThing(title: "礼物：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let outherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let giver = UILabel.initSomeThing(title: "送礼方：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let giverValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let ischeck = UILabel.initSomeThing(title: "是否已转账户余额：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let ischeckValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let checkTime = UILabel.initSomeThing(title: "转化时间：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let checkTimeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    var cid = ""
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime

//                let data = model?.otherContent?.data(using: String.Encoding.utf8)
                let dict = model?.otherContent
           
                contentTypeValue.text = self.contentTypeNameWithType(type: dict?["contentType"] as? String ?? "")
                contentTitleValue.text = dict?["contentTitle"] as? String
                outherValue.text = dict?["gift"] as? String
                giverValue.text = dict?["giver"] as? String
                messageTypeValue.text = model?.typeName
                ischeckValue.text = ((dict?["isConvertedUsd"] as? Bool)!) ? "是":"否"
                
                self.cid = dict?["contentId"] as? String ?? ""
                let timeStr = dict?["convertedTime"] as? String ?? "0"
                
                let endDate = NSDate.init(timeIntervalSince1970: TimeInterval((timeStr.toDouble ?? 0) / 1000.0))
                let dateFormat = DateFormatter.init()
                dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
                checkTimeValue.text = dateFormat.string(from: endDate as Date)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func contentTypeNameWithType(type:String)->String{
//        NOTE("note", "动态"),
        if type == "note" {
            self.type = 4
            return "动态"
        }
//            COURSE("course", "课程"),
        if type == "course" {
            self.type = 2
            return "课程"
        }
//            COURSE_SECTION("course_section", "课程小节"),
        if type == "course_section" {
            self.type = 2
            return "课程小节"
        }
//            PLAN("plan", "方案"),
        if type == "plan" {
            self.type = 3
            return "方案"
        }
//            PLAN_SECTION("plan_section", "方案小节"),
        if type == "plan_section" {
            self.type = 3
            return "方案小节"
        }
//            DIARY("diary", "美丽日记"),
        if type == "diary" {
            self.type = 5
            return "美丽日记"
        }
//            ALBUM("album", "美丽相册"),
        if type == "album" {
            self.type = 6
            return "美丽相册"
        }
//            PERSONAL("personal", "个人"),
        if type == "personal" {
            self.type = -1
            return "个人"
        }
//            COMMENT("comment", "评论"),
        if type == "comment" {
            
            return "评论"
        }
        return ""
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            
        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTypeValue)
        contentTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentType.snp.right).offset(8)
            make.centerY.equalTo(contentType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.centerY.equalTo(contentTitle)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(outher)
        outher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(outherValue)
        outherValue.snp.makeConstraints { (make) in
            make.left.equalTo(outher.snp.right).offset(8)
            make.centerY.equalTo(outher)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(giver)
        giver.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(outher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(giverValue)
        giverValue.snp.makeConstraints { (make) in
            make.left.equalTo(giver.snp.right).offset(8)
            make.centerY.equalTo(giver)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(giver.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(ischeck)
        ischeck.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(150)
            make.top.equalTo(messageType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(ischeckValue)
        ischeckValue.snp.makeConstraints { (make) in
            make.left.equalTo(ischeck.snp.right).offset(8)
            make.centerY.equalTo(ischeck)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(checkTime)
        checkTime.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(ischeck.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(checkTimeValue)
        checkTimeValue.snp.makeConstraints { (make) in
            make.left.equalTo(checkTime.snp.right).offset(8)
            make.centerY.equalTo(checkTime)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(checkTimeValue.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            ///如果有内容id，则跳转到对应详情页，否则跳转到个人礼物间
            if self.type == -1{
                let vc = SSMyGiftRoomController()
                HQPush(vc: vc, style: .default)
            }else{
                GotoTypeVC(type: self.type, cid: self.cid)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//评论/回复通知
class SSReplayMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "评论/回复通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有新评论/回复", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentType = UILabel.initSomeThing(title: "内容类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "内容标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outher = UILabel.initSomeThing(title: "评论/回复：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let outherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let person = UILabel.initSomeThing(title: "评论人：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let personValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    var type = 0
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                if model?.type == "reply" {
                    title.text = "回复通知"
                    content.text = "有新回复"
                }else{
                    title.text = "评论通知"
                    content.text = "有新评论"
                }
                title.text = model?.title
                time.text = model?.publishedTime

                contentTypeValue.text = self.contentTypeNameWithType(type: model?.otherContent?["contentType"] as? String ?? "")
                let titleStr = model?.otherContent?["contentTitle"] as? String
                contentTitleValue.text = titleStr
                outherValue.text = model?.otherContent?[model?.type == "reply" ? "replyDetail" : "commentDetail"] as? String
                personValue.text = model?.otherContent?[model?.type == "reply" ? "responder" : "commentator"] as? String
                messageTypeValue.text = model?.typeName
            }
        }
    }
    
    func contentTypeNameWithType(type:String)->String{
//        NOTE("note", "动态"),
        if type == "note" {
            self.type = 4
            return "动态"
        }
//            COURSE("course", "课程"),
        if type == "course" {
            self.type = 2
            return "课程"
        }
//            COURSE_SECTION("course_section", "课程小节"),
        if type == "course_section" {
            self.type = 2
            return "课程小节"
        }
//            PLAN("plan", "方案"),
        if type == "plan" {
            self.type = 3
            return "方案"
        }
//            PLAN_SECTION("plan_section", "方案小节"),
        if type == "plan_section" {
            self.type = 3
            return "方案小节"
        }
//            DIARY("diary", "美丽日记"),
        if type == "diary" {
            self.type = 5
            return "美丽日记"
        }
//            ALBUM("album", "美丽相册"),
        if type == "album" {
            self.type = 6
            return "美丽相册"
        }
//            PERSONAL("personal", "个人"),
        if type == "personal" {
            self.type = -1
            return "个人"
        }
//            COMMENT("comment", "评论"),
        if type == "comment" {
            
            return "评论"
        }
        return ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            
        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTypeValue)
        contentTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentType.snp.right).offset(8)
            make.centerY.equalTo(contentType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.centerY.equalTo(contentTitle)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(outher)
        outher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(outherValue)
        outherValue.snp.makeConstraints { (make) in
            make.left.equalTo(outher.snp.right).offset(8)
            make.centerY.equalTo(outher)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(person)
        person.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(outher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(personValue)
        personValue.snp.makeConstraints { (make) in
            make.left.equalTo(person.snp.right).offset(8)
            make.centerY.equalTo(person)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(person.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
//        contentView.addSubview(secLine)
//        secLine.backgroundColor = .init(hex: "#EEEFF0")
//        secLine.snp.makeConstraints { (make) in
//            make.top.equalTo(messageType.snp.bottom).offset(16)
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.height.equalTo(1)
//        }
//        contentView.addSubview(detailBtn)
//        detailBtn.setTitle("详情", for: .normal)
//        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
//        detailBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(secLine.snp.bottom).offset(16)
//            make.left.equalTo(10)
//            make.width.equalTo(40)
//            make.height.equalTo(18)
//        }
//        detailBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//点赞/通知消息
class SSCollectionMessageCell: UITableViewCell {
    
    var type = 0
    var cid = ""
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "点赞/收藏通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    let content = UILabel.initSomeThing(title: "有用户点赞", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentType = UILabel.initSomeThing(title: "内容类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let contentTitle = UILabel.initSomeThing(title: "内容标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outher = UILabel.initSomeThing(title: "点赞/收藏者：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let outherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    ///0点赞 1收藏
    var cellType = 0
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                cellType = model?.type == "like" ? 0: 1
                let dict = model?.otherContent
                title.text = model?.title
                time.text = model?.publishedTime
                messageTypeValue.text = model?.typeName
                content.text = model?.content
                contentTitleValue.text = dict?["contentTitle"] as? String
                if cellType == 0{
                    outherValue.text = dict?["liker"] as? String
                }else{
                    outherValue.text = dict?["collector"] as? String
                }
                self.cid = dict?["contentId"] as? String ?? ""
                contentTypeValue.text = self.contentTypeNameWithType(type: dict?["contentType"] as? String ?? "")
            }
        }
    }
    
    func contentTypeNameWithType(type:String)->String{
//        NOTE("note", "动态"),
        if type == "note" {
            self.type = 4
            return "动态"
        }
//            COURSE("course", "课程"),
        if type == "course" {
            self.type = 2
            return "课程"
        }
//            COURSE_SECTION("course_section", "课程小节"),
        if type == "course_section" {
            self.type = 2
            return "课程小节"
        }
//            PLAN("plan", "方案"),
        if type == "plan" {
            self.type = 3
            return "方案"
        }
//            PLAN_SECTION("plan_section", "方案小节"),
        if type == "plan_section" {
            self.type = 3
            return "方案小节"
        }
//            DIARY("diary", "美丽日记"),
        if type == "diary" {
            self.type = 5
            return "美丽日记"
        }
//            ALBUM("album", "美丽相册"),
        if type == "album" {
            self.type = 6
            return "美丽相册"
        }
//            PERSONAL("personal", "个人"),
        if type == "personal" {
            self.type = -1
            return "个人"
        }
//            COMMENT("comment", "评论"),
        if type == "comment" {
            
            return "评论"
        }
        return ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(16)
            
        }
        contentView.addSubview(contentType)
        contentType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTypeValue)
        contentTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentType.snp.right).offset(8)
            make.centerY.equalTo(contentType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentType.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.centerY.equalTo(contentTitle)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(outher)
        outher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(outherValue)
        outherValue.snp.makeConstraints { (make) in
            make.left.equalTo(outher.snp.right).offset(8)
            make.centerY.equalTo(outher)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(outher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageType.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            GotoTypeVC(type: self.type, cid: self.cid)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//vip年卡会员到期
class SSVipOuttimeMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "点赞/收藏通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    
    let content = UILabel.initSomeThing(title: "vip年卡已到期", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))

    let num = UILabel.initSomeThing(title: "会员号：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let numValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let free = UILabel.initSomeThing(title: "本年度为您节省：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let freeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outTime = UILabel.initSomeThing(title: "到期时间：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let outTimeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content
                let dict = model?.otherContent
                
                
                numValue.text = dict?["cardNumber"] as? String
                freeValue.text = dict?["moneySaved"] as? String
                let endDate = NSDate.init(timeIntervalSince1970: (dict?["expirationTime"] as? Double)!/1000)
                let dateFormat = DateFormatter.init()
                dateFormat.dateStyle = .short
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                outTimeValue.text = dateFormat.string(from: endDate as Date)
                
//                messageType.text = dict?["messageType"] as? String
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(num)
        num.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(firstLine.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(numValue)
        numValue.snp.makeConstraints { (make) in
            make.left.equalTo(num.snp.right).offset(8)
            make.centerY.equalTo(num)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(free)
        free.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(140)
            make.top.equalTo(num.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(freeValue)
        freeValue.snp.makeConstraints { (make) in
            make.left.equalTo(free.snp.right).offset(8)
            make.centerY.equalTo(free)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(outTime)
        outTime.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.top.equalTo(free.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(outTimeValue)
        outTimeValue.snp.makeConstraints { (make) in
            make.left.equalTo(outTime.snp.right).offset(8)
            make.centerY.equalTo(outTime)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(outTime.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageType.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            GotoTypeVC(type: 1, cid: "")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//内容被删除通知/被禁言/被封号
class SSDeleteMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "内容被删除通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    
    let content = UILabel.initSomeThing(title: "您的动态/课程/课程小节/方案/方案小节/评论[文字文字文字其他", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let userName = UILabel.initSomeThing(title: "用户名：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let userNameValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content
                let dict = model?.otherContent
                userNameValue.text = dict?["accountOwner"] as? String
                messageTypeValue.text = model?.typeName
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
       
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(12)
            
            
        }
        contentView.addSubview(userName)
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(userNameValue)
        userNameValue.snp.makeConstraints { (make) in
            make.left.equalTo(userName.snp.right).offset(8)
            make.centerY.equalTo(userName)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(userName.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageType.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        secLine.isHidden = true
        detailBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//系统通知
class SSCompMessageCell: UITableViewCell {
    
    let bgView = UIView.init()
    let title = UILabel.initSomeThing(title: "系统通知", fontSize: 17, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020-10-08 14:30", fontSize: 13, titleColor: .init(hex: "#666666"))
    
    let firstLine = UIView.init()
    
    let content = UILabel.initSomeThing(title: "身所周年庆，红包送不停！", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let contentTitle = UILabel.initSomeThing(title: "标题：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let contentTitleValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let detail = UILabel.initSomeThing(title: "内容：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let detailValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let outher = UILabel.initSomeThing(title: "作者：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let outherValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let messageType = UILabel.initSomeThing(title: "消息类型：", fontSize: 16, titleColor: .init(hex: "#878889"))
    let messageTypeValue = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let secLine = UIView.init()
    let detailBtn = UIButton.init()
    
    var linkType = 0
    var cid = ""
    
    var model:SSMessageModel? = nil{
        didSet{
            if model != nil {
                title.text = model?.title
                time.text = model?.publishedTime
                content.text = model?.content

                let dict = model?.otherContent
                self.linkType = dict?["linkType"] as? Int ?? 0
                self.cid = dict?["contentId"] as? String ?? ""
                messageType.text = dict?["messageType"] as? String
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(bgView)
        bgView.backgroundColor = .init(hex: "#F7F8F9")
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.height.equalTo(24)
        }
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.right.equalTo(-10)
        }
        contentView.addSubview(firstLine)
        firstLine.backgroundColor = .init(hex: "#EEEFF0")
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(content)
        content.numberOfLines = 0
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(firstLine.snp.bottom).offset(12)
        }
        
        contentView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(contentTitleValue)
        contentTitleValue.snp.makeConstraints { (make) in
            make.left.equalTo(contentTitle.snp.right).offset(8)
            make.centerY.equalTo(contentTitle)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(detail)
        content.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
        }
        contentView.addSubview(detailValue)
        detailValue.numberOfLines = 0
        detailValue.snp.makeConstraints { (make) in
            make.left.equalTo(detail.snp.right).offset(8)
            make.centerY.equalTo(detail)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(outher)
        outher.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(content.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(outherValue)
        outherValue.snp.makeConstraints { (make) in
            make.left.equalTo(outher.snp.right).offset(8)
            make.centerY.equalTo(outher)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageType)
        messageType.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(TitleWidth)
            make.top.equalTo(outher.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        contentView.addSubview(messageTypeValue)
        messageTypeValue.snp.makeConstraints { (make) in
            make.left.equalTo(messageType.snp.right).offset(8)
            make.centerY.equalTo(messageType)
            make.right.equalTo(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(secLine)
        secLine.backgroundColor = .init(hex: "#EEEFF0")
        secLine.snp.makeConstraints { (make) in
            make.top.equalTo(messageType.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        contentView.addSubview(detailBtn)
        detailBtn.setTitle("详情", for: .normal)
        detailBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secLine.snp.bottom).offset(16)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        detailBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                GotoTypeVC(type: self.linkType, cid: self.cid)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
