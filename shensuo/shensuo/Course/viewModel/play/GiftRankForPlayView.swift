//
//  GiftRankForPlayView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/22.
//

import UIKit

class GiftRankForPlayView: UIView {
    
    var mainID = ""
    var type = 2

    let head1 = UserHeadRoudeView()
    let head2 = UserHeadRoudeView()
    let head3 = UserHeadRoudeView()
    
    let moreImg = UIImageView()
    let giftBtn = UIButton()
    
    var rankModels : GiftRankModel? = nil{
        didSet{
            if rankModels != nil{
                let num = rankModels?.gifts?.content?.count ?? 0
                self.isHidden = false
                if num == 3 {
                    self.moreImg.isHidden = true
                    self.snp.updateConstraints { make in
                        make.width.equalTo(120 - 16)
                    }
                }else if num == 2 {
                    self.moreImg.isHidden = true
                    self.head3.isHidden = true
                    self.snp.updateConstraints { make in
                        make.width.equalTo(120 - 16 - 12)
                    }
                }else if num == 1 {
                    self.moreImg.isHidden = true
                    self.head3.isHidden = true
                    self.head2.isHidden = true
                    self.snp.updateConstraints { make in
                        make.width.equalTo(120 - 16 - 12 - 12)
                    }
                }else if num == 0{
                    self.isHidden = true
                }else{
                    self.moreImg.isHidden = false
                    self.head3.isHidden = false
                    self.head2.isHidden = false
                    self.head1.isHidden = false
                    self.snp.updateConstraints { make in
                        make.width.equalTo(120)
                    }
                }
                
                for i in 0...2 {
                    if num > i{
                        let model = rankModels!.gifts!.content![i]
                        if i == 0 {
                            head1.headImg.kf.setImage(with: URL.init(string: model.headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                        }
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        moreImg.layer.cornerRadius = 12
        moreImg.layer.masksToBounds = true
        moreImg.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.16)
        self.addSubview(head1)
        head1.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(head2)
        head2.snp.makeConstraints { make in
            make.left.equalTo(4 + 12)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(head3)
        head3.snp.makeConstraints { make in
            make.left.equalTo(4 + 12 + 12)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        moreImg.image = UIImage.init(named: "more_white")
        self.addSubview(moreImg)
        moreImg.snp.makeConstraints { make in
            make.left.equalTo(4 + 12 + 12 + 16)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        self.bringSubviewToFront(head3)
        self.bringSubviewToFront(head2)
        self.bringSubviewToFront(head1)
        let line = UIView()
        line.backgroundColor = .white
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(13)
            make.right.equalTo(-42)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(giftBtn)
        giftBtn.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        let imgView = UIImageView()
        giftBtn.addSubview(imgView)
        imgView.image = UIImage.init(named: "gift_play")
        giftBtn.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///获取礼物排行榜
    func getNetInfo() {
        GiftNetworkProvider.request(.giftRanking(source: mainID, type: "\(type)", number: 1, pageSize: 4)) { result in
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
}
