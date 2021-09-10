//
//  SSReleaseBottomCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/22.
//

import UIKit
typealias editBlock = (_ str : String,_ isEdit: Bool)->()
class SSReleaseBottomCell: SSBaseCell, UITextViewDelegate {

    var isVideo = false{
        didSet{
            if isVideo {
                if self.comTextView.text.length > 60 {
                    self.comTextView.text = self.comTextView.text.subString(to: 60)
                }
                self.shareNumL.text = "\(comTextView.text.length)/60"
            }else{
                self.shareNumL.text = "\(comTextView.text.length)/1000"
            }
        }
    }
    var moveView = UIView()
    var marginView = UIView()
    var moveTitleL: UILabel!
    var lineV = UIView()
    var shareV = UIView()
//    var shareL: UILabel!
    var shareNumL: UILabel!
    var shareLineV = UIView()
    var comTfEditBlcok: editBlock? = nil
    var comTextView:UITextView = {
        let com = UITextView.init()
        var placeHolderLabel = UILabel.init()
        placeHolderLabel.text = "添加正文"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        com.addSubview(placeHolderLabel)
        com.font = .systemFont(ofSize: 13)
        placeHolderLabel.font = .systemFont(ofSize: 13)
        com.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        return com
    }()

    var addAddreeV = UIView()
    var addressIcon: UIImageView!
    var addressL: UILabel!
    var arrowIcon: UIImageView!
    var addreeLineV = UIView()
    var preView = UIView()
    var preIcon: UIImageView!
    var preTitleL: UILabel!
    //1 地址 2: 预览
    var jumpTapBlock: intBlock? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    func reloadImageData(detalisModel: SSReleaseModel,
                         stepList: [CourseStepListModel],inType: Int,noteType: Int,title: String,showTitle: Bool) {
        
        if showTitle {
            
            comTextView.text = title
            
        }else{
            
            switch inType {
                case 0:
                    break
                case 1:
                    
                    comTextView.text = "我已完成课程\(detalisModel.title)您也来试试吧~"
                    break
                case 2:
                    comTextView.text = "我已完成课程小节\(detalisModel.title)您也来试试吧~"
                    break
                case 3:
                    comTextView.text = "我已开通VIP年卡会员，尊享四大特权您也来试试吧~"
                    break
                case 4:
                    comTextView.text = "我已完成方案\(detalisModel.title)您也来试试吧~"
                    break
                case 5:
                    comTextView.text = "我已完成当天方案\(detalisModel.title)您也来试试吧~"
                    break
                case 6,7:
                    comTextView.text = detalisModel.content
                    break
                case 8:
                    comTextView.text = "我已开通VIP年卡会员，尊享四大特权您也来试试吧~"
                    break
                default:
                    break
            }
        }
        
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        comTfEditBlcok?(textView.text,true)
    }
    
    func buildUI() {
        
        contentView.addSubview(moveView)
        
        contentView.addSubview(marginView)
        marginView.backgroundColor = bgColor
        
        moveTitleL = UILabel.initSomeThing(title: "动态详情", fontSize: 16, titleColor: color33)
        moveView.addSubview(moveTitleL)
        
        lineV(superV: moveView, subV: lineV)
        
        contentView.addSubview(shareV)
        
        
        shareV.addSubview(comTextView)
        comTextView.delegate = self
        
        shareNumL = UILabel.initSomeThing(title: "0/1000", fontSize: 16, titleColor: .init(hex: "#878889"))
        shareV.addSubview(shareNumL)
        
        lineV(superV: shareV, subV: shareLineV)
        
        contentView.addSubview(addAddreeV)
        
        addressIcon = UIImageView.initWithName(imgName: "address_icon")
        addAddreeV.addSubview(addressIcon)
        
        addressL = UILabel.initSomeThing(title: "添加地点", fontSize: 16, titleColor: .init(hex: "#333333"))
        addAddreeV.addSubview(addressL)
        
        arrowIcon = UIImageView.initWithName(imgName: "arrow_right")
        addAddreeV.addSubview(arrowIcon)
        addAddreeV.isUserInteractionEnabled = true
        let addressTap = UITapGestureRecognizer.init(target: self, action: #selector(addressTapAction))
        addAddreeV.addGestureRecognizer(addressTap)
        
        
        lineV(superV: addAddreeV, subV: addreeLineV)
        
        contentView.addSubview(preView)
        preView.layer.cornerRadius = 16.0
        preView.layer.masksToBounds = true
        preView.backgroundColor = .init(hex: "#F8F8F8")
        
        preIcon = UIImageView.initWithName(imgName: "icon-yulan")
        preView.addSubview(preIcon)
        
        preTitleL = UILabel.initSomeThing(title: "预览动态", fontSize: 13, titleColor: color33)
        preView.addSubview(preTitleL)
        comTextView.delegate = self
        
        customTap(target: self, action: #selector(jumpToPreview), view: preView)
    }
    
   @objc func jumpToPreview()  {
        
    self.jumpTapBlock?(2)
    }
    
   @objc func addressTapAction() {
        
    self.jumpTapBlock?(1)

   }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if isVideo {
            if textView.text.length > 60 {
                textView.text = textView.text.subString(to: 60)
            }
            shareNumL.text = "\(textView.text.length)/60"
        }else{
            if textView.text.length > 1000 {
                
                textView.text = textView.text.subString(to: 1000)
            }
            shareNumL.text = "\(textView.text.length)/1000"
        }
    }
    
    func lineV(superV: UIView,subV: UIView) {
        
        superV.addSubview(subV)
        subV.backgroundColor = bgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        marginView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
//        moveView.snp.makeConstraints { make in
//
//            make.top.equalTo(marginView.snp.bottom)
//            make.trailing.leading.equalToSuperview()
//            make.height.equalTo(60)
//        }
//
//        moveTitleL.snp.makeConstraints { make in
//
//            make.leading.equalTo(16)
//            make.centerY.equalToSuperview()
//        }
//
//        lineV.snp.makeConstraints { make in
//
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(0.5)
//
//        }
        
        shareV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marginView.snp.bottom)
            make.height.equalTo(170)
            
        }
        
        shareNumL.snp.makeConstraints { make in
            
            make.trailing.equalTo(-normalMarginHeight)
            make.bottom.equalTo(-normalMarginHeight)
            
        }
        
        shareLineV.snp.makeConstraints { make in
            
            make.trailing.equalTo(11)
            make.leading.equalTo(-9)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        
        comTextView.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.leading.equalTo(11)
            make.bottom.equalTo(shareNumL.snp.top).offset(normalMarginHeight)
            make.top.equalTo(normalMarginHeight)
        }
        
        addAddreeV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(shareV.snp.bottom)
        }
        
        addressIcon.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        addressL.snp.makeConstraints { make in
            
            make.leading.equalTo(addressIcon.snp.trailing).offset(4)
            make.centerY.equalTo(addressIcon)
            
        }
        
        arrowIcon.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.centerY.equalTo(addressIcon)
            make.height.width.equalTo(24.0)
            
        }
        
        addreeLineV.snp.makeConstraints { make in
            
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.leading.equalTo(11)
            make.trailing.equalTo(9)
        }
        
        preView.snp.makeConstraints { make in
            
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(32)
            make.width.equalTo(110)
            make.top.equalTo(addAddreeV.snp.bottom).offset(36)
        }
        
        preIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        preTitleL.snp.makeConstraints { make in
            
            make.leading.equalTo(preIcon.snp.trailing)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
