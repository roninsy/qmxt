//
//  GiftTopView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/23.
//

import UIKit

///礼物榜
class GiftTopView: UIView {
    var rankModels : GiftRankModel? = nil{
        didSet{
            if rankModels != nil{
                giftNumLab.text = String.init(format: "%d", rankModels?.totalGifts ?? 0)
                personNumLab.text = String.init(format: "%d", rankModels?.totalPeople ?? 0)
                let num = (rankModels?.gifts?.content?.count ?? 0)
                for i in 0...2 {
                    if num > i{
                        let model = rankModels!.gifts!.content![i]
                        userArr[i].bgImg.isHidden = false
                        userArr[i].headImg.kf.setImage(with: URL.init(string: model.headImage!),placeholder: UIImage.init(named: "user_normal_icon"))
                        let str = model.points! > 10000 ? String.init(format: "%.1f万", Double(model.points!) / 10000.0) : "\(model.points!)"
                        userArr[i].botLab.text = str
                    }
                }
            }
        }
    }
    // 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节 8：个人收礼
    var type = 1
    var mainId = ""
    var userId = ""
    var titleText = ""
    
    let giftLab = UILabel.initSomeThing(title: "礼物榜", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 17), ali: .left)
    
    let lookBtn = UIButton.initTitle(title: "查看榜单", fontSize: 14, titleColor: .init(hex: "#666666"))
    let rIcon = UIImageView.initWithName(imgName: "right_black")
    
    let userArr = [GiftUserView(),GiftUserView(),GiftUserView(),GiftUserView()]
    
    let giftNumLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 24), ali: .center)
    let giftNumTip = UILabel.initSomeThing(title: "礼物总数", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    
    let personNumLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 24), ali: .center)
    let personNumTip = UILabel.initSomeThing(title: "送礼人数", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(giftLab)
        giftLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(100)
            make.height.equalTo(24)
            make.top.equalTo(13)
        }
        
        self.addSubview(rIcon)
        rIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.width.height.equalTo(16)
            make.top.equalTo(22)
        }
        
        lookBtn.sizeToFit()
        self.addSubview(lookBtn)
        lookBtn.snp.makeConstraints { (make) in
            make.right.equalTo(rIcon.snp.left).offset(-4)
            make.centerY.equalTo(rIcon)
        }
        lookBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = GiftRankVC()
            vc.mainView.mainId = self.mainId
            vc.mainView.type = self.type
            vc.mainView.userId = self.userId
            vc.mainView.isSelf = self.userId == (UserInfo.getSharedInstance().userId ?? "")
            vc.mainView.titleText = self.titleText
            HQPush(vc: vc, style: .default)
        }
        
        let space = (screenWid - 72 * 4) / 6
        
        for i in 0...3{
            self.addSubview(userArr[i])
            
            switch i {
            case 0:
                userArr[i].bgImg.image = UIImage.init(named: "gift_top1")
                userArr[i].bgImg.isHidden = true
                userArr[i].RIcon.isHidden = true
                userArr[i].headImg.image = UIImage.init(named: "rank_num1_wait")
                userArr[i].botLab.text = "送礼上榜"
            case 1:
                userArr[i].bgImg.image = UIImage.init(named: "gift_top2")
                userArr[i].RIcon.isHidden = true
                userArr[i].bgImg.isHidden = true
                userArr[i].headImg.image = UIImage.init(named: "rank_num2_wait")
                userArr[i].botLab.text = "虚位以待"
            case 2:
                userArr[i].bgImg.image = UIImage.init(named: "gift_top3")
                userArr[i].bgImg.isHidden = true
                userArr[i].RIcon.isHidden = true
                userArr[i].headImg.image = UIImage.init(named: "rank_num2_wait")
                userArr[i].botLab.text = "虚位以待"
            case 3:
                userArr[i].bgImg.image = UIImage.init(named: "gift_top_normal")
                userArr[i].botLab.text = "送礼"
                userArr[i].clickIndex = {
                    self.test()
                }
            default:
                break
            }
            if i < 3 {
                userArr[i].snp.makeConstraints { (make) in
                    make.left.equalTo(space + (72 + space) * CGFloat(i))
                    make.top.equalTo(58)
                    make.height.equalTo(94)
                    make.width.equalTo(72)
                }

            }else{
                userArr[i].RIcon.isHidden = true
                userArr[i].snp.makeConstraints { (make) in
                    make.right.equalTo(-space)
                    make.top.equalTo(58)
                    make.height.equalTo(94)
                    make.width.equalTo(72)
                }
            }
            
            let line = UIView()
            line.backgroundColor = .init(hex: "#CBCCCD")
            self.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.right.equalTo(-(space * 2 + 72))
                make.width.equalTo(1)
                make.height.equalTo(13)
                make.top.equalTo(96)
            }
        }
        
        let botLine = UIView()
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(botLine)
        botLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(168)
        }
        
        self.addSubview(giftNumLab)
        giftNumLab.snp.makeConstraints { (make) in
            make.width.equalTo(screenWid / 2)
            make.left.equalTo(0)
            make.height.equalTo(33)
            make.top.equalTo(botLine).offset(12)
        }
        self.addSubview(giftNumTip)
        giftNumTip.snp.makeConstraints { (make) in
            make.width.equalTo(screenWid / 2)
            make.left.equalTo(0)
            make.height.equalTo(20)
            make.top.equalTo(giftNumLab.snp.bottom)
        }
        
        self.addSubview(personNumLab)
        personNumLab.snp.makeConstraints { (make) in
            make.width.equalTo(screenWid / 2)
            make.right.equalTo(0)
            make.height.equalTo(33)
            make.top.equalTo(botLine).offset(12)
        }
        self.addSubview(personNumTip)
        personNumTip.snp.makeConstraints { (make) in
            make.width.equalTo(screenWid / 2)
            make.right.equalTo(0)
            make.height.equalTo(20)
            make.top.equalTo(personNumLab.snp.bottom)
        }
        
        let botLine2 = UIView()
        botLine2.backgroundColor = .init(hex: "#CBCCCD")
        self.addSubview(botLine2)
        botLine2.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-39)
        }
        
        let rankBtn = UIButton()
        self.addSubview(rankBtn)
        rankBtn.snp.makeConstraints { make in
            make.left.top.equalTo(giftNumLab)
            make.right.bottom.equalTo(personNumTip)
        }
        rankBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            let vc = GiftRankVC()
            vc.mainView.mainId = self.mainId
            vc.mainView.type = self.type
            vc.mainView.userId = self.userId
            vc.mainView.isSelf = self.userId == (UserInfo.getSharedInstance().userId ?? "")
            vc.mainView.titleText = self.titleText
            HQPush(vc: vc, style: .default)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///获取礼物排行榜
    func getNetInfo() {
        GiftNetworkProvider.request(.giftRanking(source: mainId, type: "\(type)", number: 1, pageSize: 10)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.rankModels = model!.data!.kj.model(type: GiftRankModel.self) as? GiftRankModel
                            }
                        }else{
                            
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    
    func test(){

        let giftView = GiftListView()
        giftView.sid = mainId
        giftView.uid = userId
        giftView.type = type
        HQGetTopVC()?.view.addSubview(giftView)
        giftView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
