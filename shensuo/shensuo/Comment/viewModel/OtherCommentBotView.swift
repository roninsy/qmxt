//
//  OtherCommentBotView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/20.
//

import UIKit

class OtherCommentBotView: UIView {
    
    var sourceId = ""
    
    var type = 4{
        didSet{
            self.courseBtn = UIButton.initTopImgBtn(imgName: "bottom_home", titleStr: "主页", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 11), imgWid: 28)
            self.courseBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                HQPushToRootIndex(index: 0)
            }
            self.addSubview(courseBtn)
            self.courseBtn.snp.makeConstraints { make in
                make.width.equalTo(28)
                make.height.equalTo(44)
                make.top.equalTo(4)
                make.left.equalTo(16)
            }
        }
    }
    var courseBtn = UIButton()
    let msgBtn = UIButton.initImgv(imgv: .initWithName(imgName: "comment_bot_icon"))
    
    let msgLab = UILabel.initSomeThing(title: "0", fontSize: 11, titleColor: .init(hex: "#666666"))
    
    let collectBtn = UserHeadBtn()
    let collectNumLab = UILabel.initSomeThing(title: "0", fontSize: 11, titleColor: .init(hex: "#666666"))
    let likeNumLab = UILabel.initSomeThing(title: "0", fontSize: 11, titleColor: .init(hex: "#666666"))
    let likeBtn = UserHeadBtn()
    let giftBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "gift_play"))
    
    var myModel : SSXCXQModel? = nil{
        didSet{
            self.sourceId = myModel?.id ?? "0"
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.likeNumLab.text = getNumString(num: self.myModel?.likeTimes?.doubleValue ?? 0)
                self.collectNumLab.text = getNumString(num: self.myModel?.collectTimes?.doubleValue ?? 0)
            }
            self.checkCollect()
            self.checkLike()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.shadowColor = HQColor(r: 7, g: 7, b: 7, a: 0.25).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        
        collectBtn.imgv.image = UIImage.init(named: "noshoucan")
        likeBtn.imgv.image = UIImage.init(named: "unlike")
        
        self.addSubview(msgLab)
        msgLab.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(16)
            make.top.equalTo(10)
            make.right.equalTo(-52)
        }
        
        self.addSubview(msgBtn)
        msgBtn.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.top.equalTo(14)
            make.right.equalTo(-100)
        }
        
        ///发表评论按钮
        msgBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let view = CommentInputView()
            view.type = self.type
            view.sourceId = self.sourceId
            view.commentCheck()
            view.canCommentBlock = {
                DispatchQueue.main.async {
                    HQGetTopVC()?.view.addSubview(view)
                    view.snp.makeConstraints {  make in
                        make.edges.equalToSuperview()
                    }
                    view.textView.becomeFirstResponder()
                }
            }
            
        }
        
        self.addSubview(collectNumLab)
        collectNumLab.snp.makeConstraints { make in
            make.right.equalTo(msgBtn.snp.left).offset(-7)
            make.height.equalTo(16)
            make.top.equalTo(10)
            make.width.equalTo(48)
        }
        
        self.addSubview(collectBtn)
        collectBtn.snp.makeConstraints { make in
            make.width.height.equalTo(23)
            make.right.equalTo(collectNumLab.snp.left)
            make.top.equalTo(20)
        }
        self.addSubview(likeNumLab)
        likeNumLab.snp.makeConstraints { make in
            make.right.equalTo(collectBtn.snp.left).offset(-7)
            make.height.equalTo(16)
            make.top.equalTo(10)
            make.width.equalTo(48)
        }
        
        self.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(23)
            make.right.equalTo(likeNumLab.snp.left)
            make.top.equalTo(20)
        }
        
        self.addSubview(giftBtn)
        giftBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(-16)
            make.top.equalTo(14)
        }
        
        giftBtn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] btn in
            ///上报事件
            HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":self?.type == 1 ? "课程" : "方案",
                                                              "content_id":self?.myModel?.id ?? ""])
            let giftView = GiftListView()
            giftView.sid = self!.sourceId
            giftView.uid = ""
            giftView.type = self!.type
            HQGetTopVC()?.view.addSubview(giftView)
            giftView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        self.btnClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func btnClick(){
        likeBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            CommunityNetworkProvider.request(.addLike(sourceId: self.sourceId, type: self.type)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                self.likeBtn.isSelected = !self.likeBtn.isSelected
                                self.likeBtn.imgv.image = self.likeBtn.isSelected ? UIImage.init(named: "like") : UIImage.init(named: "unlike")
                                
                                var num = Int(self.likeNumLab.text!) ?? 0
                                num = num + (self.likeBtn.isSelected ? 1 : -1)
                                if num < 0{
                                    num = 0
                                }
                                self.likeNumLab.text = getNumString(num: Double(num))
                                if self.likeBtn.isSelected{
                                    HQGetTopVC()?.view.makeToast("点赞成功")
                                }else{
                                    HQGetTopVC()?.view.makeToast("取消点赞")
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
        
        collectBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.collectBtnClick()
        }
        
        
    }
    
    func collectBtnClick(){
        CommunityNetworkProvider.request(.addCollect(sourceId: self.sourceId, type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.collectBtn.isSelected = !self.collectBtn.isSelected
                            self.collectBtn.imgv.image = self.collectBtn.isSelected ? UIImage.init(named: "shoucan") : UIImage.init(named: "noshoucan")
                            var num = Int(self.collectNumLab.text!) ?? 0
                            num = num + (self.collectBtn.isSelected ? 1 : -1)
                            if num < 0{
                                num = 0
                            }
                            self.collectNumLab.text = getNumString(num: Double(num))
                            if self.collectBtn.isSelected{
                                HQGetTopVC()?.view.makeToast("收藏成功")
                            }else{
                                HQGetTopVC()?.view.makeToast("取消收藏")
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
    
    func checkCollect(){
        CommunityNetworkProvider.request(.whetherCollect(sourceId: self.sourceId, type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultBoolModel.self)
                        if model?.code == 0 {
                            self.collectBtn.isSelected = model?.data ?? false
                            self.collectBtn.imgv.image = self.collectBtn.isSelected ? UIImage.init(named: "shoucan") : UIImage.init(named: "noshoucan")
                        }
                    }
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func checkLike(){
        CommunityNetworkProvider.request(.whetherLike(sourceId: self.sourceId, type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultBoolModel.self)
                        if model?.code == 0 {
                            self.likeBtn.isSelected = model?.data ?? false
                            self.likeBtn.imgv.image = self.likeBtn.isSelected ? UIImage.init(named: "like") : UIImage.init(named: "unlike")
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
