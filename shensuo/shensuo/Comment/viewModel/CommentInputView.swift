//
//  CommentInputView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/4.
//

import UIKit

class CommentInputView: UIView {
    
    var needHideWithFinish = true
    
    var canCommentBlock : voidBlock? = nil
    
    var atText : String? = nil{
        didSet{
            if atText != nil{
                self.textView.text = atText
            }
        }
    }
    var refBlock : voidBlock? = nil
    ///1.课程 2.小节 3.动态 4.美丽日志，5美丽相册，6方案,7方案小节
    var type:Int = 0
    ///是否回复
    var isReCommnet = false
    var sourceId:String = ""
    var commentId:String = ""
    var atUserId:String = ""
    
    let textBg = UIView()
    let textView = UITextView()
    var placeHolderLabel = UILabel.initSomeThing(title: "请输入内容", titleColor: .lightGray, font: .systemFont(ofSize: 15), ali: .left)
    let sendBtn = UIButton.initTitle(title: "发布", font: .MediumFont(size: 16), titleColor: .init(hex: "#FD8024"), bgColor: .clear)
    
    let bgBtn = UIButton()
    
    let whiteBg = UIView()
    
    let textWid = screenWid - 68 - 10 - 32

    override init(frame: CGRect) {
        super.init(frame: frame)
        placeHolderLabel.sizeToFit()
        textView.addSubview(placeHolderLabel)
        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .init(hex: "#333333")
        textView.backgroundColor = .clear
        
        bgBtn.backgroundColor = .black
        bgBtn.alpha = 0.4
        self.addSubview(bgBtn)
        bgBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                self.endEditing(true)
                self.removeFromSuperview()
            }
        }
        
        whiteBg.backgroundColor = .white
        self.addSubview(whiteBg)
        whiteBg.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        textBg.layer.cornerRadius = 21
        textBg.layer.masksToBounds = true
        textBg.backgroundColor = .init(hex: "#EFEFEF")
        self.addSubview(textBg)
        textBg.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-68)
            make.height.equalTo(42)
            make.centerY.equalTo(whiteBg)
        }
        
        self.textView.isUserInteractionEnabled = false
        textView.returnKeyType = .send
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(textBg).offset(16)
            make.right.equalTo(textBg).offset(-16)
            make.height.equalTo(42)
            make.top.equalTo(textBg)
        }
        
        textView.reactive.continuousTextValues.observeValues { (str) in
            DispatchQueue.main.async {
                var hei = self.textView.text.ga_heightForComment(font: .systemFont(ofSize: 15), width: self.textWid, maxHeight: 200)
                if hei < 42{
                    hei = 42
                }else{
                    hei += 21
                }
                self.whiteBg.snp.updateConstraints { make in
                    make.height.equalTo(hei+14)
                }
                self.textBg.snp.updateConstraints { make in
                    make.height.equalTo(hei)
                }
                self.textView.snp.updateConstraints { make in
                    make.height.equalTo(hei)
                }
                if(self.textView.text.length > 0 ) {
                    let bottom = NSRange.init(location: self.textView.text.length - 1, length: 1)
                    self.textView.scrollRangeToVisible(bottom)
                }
            }
        }
        
        self.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.top.bottom.equalTo(whiteBg)
            make.right.equalToSuperview()
            make.width.equalTo(68)
        }
        
        sendBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.textView.text.length < 1{
                DispatchQueue.main.async {
                    self.endEditing(true)
                    self.removeFromSuperview()
                }
                return
            }
            self.send(comText: self.textView.text)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func send(comText:String) {
        self.endEditing(true)
        if isReCommnet{
            var comText2 = comText
            if self.atText != nil {
                comText2 = comText.replacingOccurrences(of: atText!, with: "")
            }
            CommunityNetworkProvider.request(.addCommentReply(atUserId :atUserId, content: comText2,commentId:commentId, createdTime: "", imageArray: [], sourceId: self.sourceId, type: self.type, userId: UserInfo.getSharedInstance().userId!)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                let pointsDic = model?.data?["completionJobResult"] as? NSDictionary
                                let points = pointsDic?["pointsSum"] as? String
                                if points != "0" && points != "" && points != nil {
                                    ///显示获得美币
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        ShowMeibiAddView(num: points?.toInt ?? 0)
                                    }
                                }
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: CommentCompletionNotification,object: nil,userInfo: nil)
                                    if self.needHideWithFinish{
                                        self.removeFromSuperview()
                                    }
                                    HQGetTopVC()?.view.makeToast("发布成功")
                                }
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
            return
        }
        
        CommunityNetworkProvider.request(.addComment(content: comText, createdTime: "", imageArray: [], sourceId: self.sourceId, type: self.type, userId: UserInfo.getSharedInstance().userId!)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: CommentCompletionNotification,object: nil,userInfo: nil)
                                if self.needHideWithFinish{
                                    self.removeFromSuperview()
                                }
                                HQGetTopVC()?.view.makeToast("发布成功")
                            }
                            let pointsDic = model?.data?["completionJobResult"] as? NSDictionary
                            let points = pointsDic?["pointsSum"] as? String
                            if points != "0" && points != "" && points != nil{
                                ///显示获得美币
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    ShowMeibiAddView(num: points?.toInt ?? 0)
                                }
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
    
    
    func commentCheck(){
        CommunityNetworkProvider.request(.commentCheck(sid: isReCommnet ? self.atUserId : (UserInfo.getSharedInstance().userId ?? ""))) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.textView.isUserInteractionEnabled = true
                            self.canCommentBlock?()
                        }
                    }else{
                        
                    }
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
}
