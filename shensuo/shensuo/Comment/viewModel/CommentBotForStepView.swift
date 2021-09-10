//
//  CommentBotForStepView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/24.
//

import UIKit

class CommentBotForStepView: UIView {
    var sourceId = ""
    var type = 2{
        didSet{
            self.courseBtn = UIButton.initTopImgBtn(imgName: self.type == 2 ? "bottom_kecheng" : "course_bottom_fangan", titleStr: self.type == 2 ? "课程" : "方案", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 11), imgWid: 28)
            buyView.isProject = self.type != 2
            let model = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
            if model != nil {
                buyView.changgeWithType(type: model!.priceType)
            }
            self.courseBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                GotoTypeVC(type: self.type == 2 ? 16 : 17, cid: "")
            }
            self.addSubview(self.courseBtn)
            self.courseBtn.snp.makeConstraints { make in
                make.width.equalTo(28)
                make.height.equalTo(44)
                make.top.equalTo(4)
                make.left.equalTo(16)
            }
            self.bringSubviewToFront(self.buyView)
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
    
    var myModel : CourseStepListModel? = nil{
        didSet{
            self.sourceId = myModel?.id ?? "0"
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.likeNumLab.text = getNumString(num: self.myModel?.likeTimes?.doubleValue ?? 0)
            }
            self.checkLike()
        }
    }
    
    let model : CourseDetalisModel? = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
    
    let buyView = CourseBotBuyView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowColor = HQColor(r: 7, g: 7, b: 7, a: 0.25).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        
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
        
        self.addSubview(likeNumLab)
        likeNumLab.snp.makeConstraints { make in
            make.right.equalTo(msgBtn.snp.left).offset(-7)
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
            HQPushActionWith(name: "click_gifts_course", dic:  ["content_type":self?.type == 2 ? "课程" : "方案",
                                                              "content_id":self?.model?.id ?? ""])
            let giftView = GiftListView()
            giftView.sid = self!.sourceId
            giftView.uid = ""
            giftView.type = self!.type
            HQGetTopVC()?.view.addSubview(giftView)
            giftView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        buyView.isProject = self.type != 2
        buyView.isStep = true
        self.addSubview(buyView)
        buyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        buyView.buyBlock = { [weak self] in
            var freeType = self?.buyView.type == .pay ? "付费" : "免费"
            if self?.buyView.type == .vipFree{
                freeType = "vip免费"
            }
            ///上报事件
            HQPushActionWith(name: "click_buy_course", dic:  ["course_type":self?.type == 1 ? "课程" : "方案",
                                                              "course_frstcate":"",
                                                                     "course_secondcate":"",
                                                                     "course_id":self?.model?.id ?? "",
                                                                     "course_title":self?.model?.title ?? "",
                                                                     "course_rates":freeType,
                                                                     "current_price":self?.model?.price?.doubleValue ?? 0,
                                                                     "institution_id":self?.model?.userId ?? "",
                                                                     "institution_name":self?.model?.copyrightName ?? "",
                                                                     "teacher_id":self?.model?.teacherUserId ?? "",
                                                                     "teacher_name":self?.model?.tutorName ?? "",
                                                                     "total_minutes":(self?.model?.totalMinutes?.doubleValue ?? 0) * 60,
                                                                     "total_calorie":self?.model?.totalCalorie?.doubleValue ?? 0,
                                                                     "total_days":self?.model?.totalDays ?? 0,
                                                                     "total_step":self?.model?.totalStep ?? 0])
            if self?.buyView.type != .free {
                HQGetTopVC()?.navigationController?.popViewController(animated: false)
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let sv = self?.superview as? StepDetalisView
                    let model = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
                    sv?.checkAdd(cid: model?.id ?? "")
                }
            }
        }
        self.btnClick()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(){
        
        courseBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            GotoTypeVC(type: 18, cid: "")
        }
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
                                
                                var num = self.myModel?.likeTimes?.intValue ?? 0
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
                            }else{
                                
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

