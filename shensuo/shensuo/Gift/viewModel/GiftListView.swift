//
//  GiftListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/24.
//

import UIKit
import MBProgressHUD

class GiftListView: UIView {
    
    var sendGiftBlock : voidBlock? = nil
    ///正在送礼
    var inSend = false
    var buyMeiBiView = BuyMeiBiView()
    var listView : UICollectionView!
    
    var oid : String? = nil
    var payType : String? = nil
    let selBgColor = UIColor.init(hex: "#FD8024")
    let unSelBgColor = UIColor.init(hex: "#999999")
    let botView = UIView()
    let numBtns = [UIButton.initTitle(title: "1", fontSize: 15, titleColor: .init(hex: "#333333"), bgColor: .init(hex: "#FD8024")),
                   UIButton.initTitle(title: "10", fontSize: 15, titleColor: .init(hex: "#333333"), bgColor: .init(hex: "#999999")),
                   UIButton.initTitle(title: "20", fontSize: 15, titleColor: .init(hex: "#333333"), bgColor: .init(hex: "#999999")),
                   UIButton.initTitle(title: "66", fontSize: 15, titleColor: .init(hex: "#333333"), bgColor: .init(hex: "#999999")),
                   UIButton.initTitle(title: "99", fontSize: 15, titleColor: .init(hex: "#333333"), bgColor: .init(hex: "#999999"))]
    let inputNumBtn = UIButton.initTitle(title: "自定义数量", fontSize: 15, titleColor: .white, bgColor: .init(hex: "#221F25"))
    let inputNumBtnBG = UIView()
    
    let buyBtn = UIButton.initTitle(title: "购买美币", font: .MediumFont(size: 10), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    let coinNumLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#FD8024"), font: .MediumFont(size: 18), ali: .right)
    
    var selNum = 1
    var selBtnTag = 0
    
    var selCell = 0
    
    var nowPage = 0{
        didSet{
            pageFlagView.snp.updateConstraints { make in
                make.left.equalTo(nowPage * 30)
            }
        }
    }
    let pageFlagView = UIView()
    
    var giftArr : [GiftModel] = NSArray() as! [GiftModel]{
        didSet{
            self.listView.reloadData()
        }
    }
    
    ///源id
    var sid = "0"
    var uid = "0"
    var type = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(payCallBack(notifi:)), name: PayCompletionNotification, object: nil)
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        botView.backgroundColor = .init(hex: "#221F25")
        self.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.height.equalTo(400 + SafeBottomHei)
            make.bottom.left.right.equalToSuperview()
        }
        
        let numBtnSpace = 18.0
        let numBtnWid = 30.0
        let numBotSpace = 15.5 + SafeBottomHei
        for i in 0...(numBtns.count-1){
            self.addSubview(numBtns[i])
            numBtns[i].snp.makeConstraints { make in
                make.width.height.equalTo(numBtnWid)
                make.bottom.equalTo(-numBotSpace)
                make.left.equalTo(numBtnSpace + Double(i) * (numBtnWid + numBtnSpace))
            }
            numBtns[i].setTitleColor(.white, for: .selected)
            numBtns[i].layer.cornerRadius = CGFloat(numBtnWid / 2)
            numBtns[i].layer.masksToBounds = true
            numBtns[i].tag = i
            numBtns[i].reactive.controlEvents(.touchUpInside).observeValues { btn in
                if self.selBtnTag == -1{
                    self.inputNumBtn.setTitle("自定义数量", for: .normal)
                }else{
                    self.numBtns[self.selBtnTag].isSelected = false
                    self.numBtns[self.selBtnTag].backgroundColor = self.unSelBgColor
                }
                self.selBtnTag = btn.tag
                self.selNum = self.numBtns[self.selBtnTag].title(for: .normal)?.toInt ?? 1
                self.numBtns[self.selBtnTag].isSelected = true
                self.numBtns[self.selBtnTag].backgroundColor = self.selBgColor
            }
        }
        
        inputNumBtnBG.backgroundColor = .init(hex: "#FD8024")
        inputNumBtnBG.layer.cornerRadius = 15
        inputNumBtnBG.layer.masksToBounds = true
        self.addSubview(inputNumBtnBG)
        inputNumBtnBG.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.right.equalTo(-18)
            make.bottom.equalTo(-numBotSpace)
        }
        
        inputNumBtn.layer.cornerRadius = 14
        inputNumBtn.layer.masksToBounds = true
        self.addSubview(inputNumBtn)
        inputNumBtn.snp.makeConstraints { make in
            make.left.top.equalTo(inputNumBtnBG).offset(1)
            make.height.equalTo(28)
            make.width.equalTo(98)
        }
        inputNumBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            ///自定义数量方法
            let numView = BuyInputView()
            self.addSubview(numView)
            numView.snp.makeConstraints { make in
                make.edges.equalTo(self.botView)
            }
            numView.enterNumBlock = { num in
                if self.selBtnTag != -1{
                    self.numBtns[self.selBtnTag].isSelected = false
                    self.numBtns[self.selBtnTag].backgroundColor = self.unSelBgColor
                    self.selBtnTag = -1
                }
                self.selNum = num
                self.inputNumBtn.setTitle("\(num)", for: .normal)
            }
        }
        
        
        numBtns[0].isSelected = true
        let cancelBtn = UIButton()
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(botView.snp.top)
        }
        cancelBtn.reactive.controlEvents(.touchUpInside)
            .observeValues { btn in
                if self.buyMeiBiView.isHidden {
                    self.removeFromSuperview()
                }else{
                    self.buyMeiBiView.isHidden = true
                }
            }
        
        let title = UILabel.initSomeThing(title: "礼物", titleColor: .white, font: .MediumFont(size: 18), ali: .left)
        botView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(30)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#111111")
        botView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(title)
        }
        
        buyBtn.layer.cornerRadius = 12
        buyBtn.layer.masksToBounds = true
        botView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(24)
            make.centerY.equalTo(title)
            make.right.equalTo(-18)
        }
        
        buyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            // 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节 8：个人收礼
            var content_type = ""
            if self.type == 1 || self.type == 2{
                content_type = "课程"
            }else if self.type == 6 || self.type == 7{
                content_type = "方案"
            }else if self.type == 4{
                content_type = "美丽日记"
            }else if self.type == 5{
                content_type = "美丽相册"
            }else if self.type == 8{
                content_type = "个人主页礼物间"
            }else if self.type == 3{
                content_type = "动态"
            }
            ///上报事件
            HQPushActionWith(name: "click_to_buy_coin", dic: ["current_page":content_type])
            DispatchQueue.main.async {
                self.buyMeiBiView = BuyMeiBiView()
                self.addSubview(self.buyMeiBiView)
                self.buyMeiBiView.snp.makeConstraints { make in
                    make.edges.equalTo(self.botView)
                }
                self.buyMeiBiView.coinNumLab.text = "余额：\(UserInfo.getSharedInstance().points ?? 0)美币"
                self.buyMeiBiView.isHidden = false
            }
        }
        
        botView.addSubview(coinNumLab)
        coinNumLab.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.right.equalTo(buyBtn.snp.left).offset(-10)
            make.centerY.equalTo(title)
        }
        coinNumLab.sizeToFit()
        
        let meiBiIcon = UIImageView.initWithName(imgName: "meibi_icon")
        botView.addSubview(meiBiIcon)
        meiBiIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(title)
            make.right.equalTo(coinNumLab.snp.left).offset(-3.5)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: (screenWid - 22) / 4, height: 120)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        listView = UICollectionView.init(frame: .init(x: 0, y: 0, width: screenWid, height: 250), collectionViewLayout: layout)
        listView.backgroundColor = .clear
        listView.register(GiftListItemView.self, forCellWithReuseIdentifier: "GiftListItemView")
        botView.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(11)
            make.right.equalTo(-11)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.height.equalTo(250)
        }
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        listView.delegate = self
        listView.dataSource = self
        listView.isPagingEnabled = true
        
        let pageBG = UIView()
        pageBG.layer.cornerRadius = 1.5
        pageBG.layer.masksToBounds = true
        pageBG.backgroundColor = .init(hex: "#39363b")
        botView.addSubview(pageBG)
        pageBG.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(3)
            make.centerX.equalToSuperview()
            make.top.equalTo(listView.snp.bottom).offset(15)
        }
        
        pageFlagView.layer.cornerRadius = 1.5
        pageFlagView.layer.masksToBounds = true
        pageFlagView.backgroundColor = .init(hex: "#FD8024")
        pageBG.addSubview(pageFlagView)
        pageFlagView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(3)
            make.left.equalTo(0)
            make.top.equalToSuperview()
        }
        
        
        self.addSubview(buyMeiBiView)
        buyMeiBiView.snp.makeConstraints { make in
            make.edges.equalTo(botView)
        }
        buyMeiBiView.isHidden = true
        self.getListInfo()
        
        self.getPoints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getListInfo(){
        GiftNetworkProvider.request(.giftList) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model!.data
                            let dic2 = dic!["content"] as! NSArray
                            self.giftArr = dic2.kj.modelArray(type: GiftModel.self) as! [GiftModel]
                        }else{
                            
                        }
                    }
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
                HQGetTopVC()?.view.makeToast("网络好像不太给力，请稍后再试哦~")
            }
        }
    }
    
    ///送礼
    func sendGift() {
        if self.inSend {
            return
        }
        inSend = true
        let giftModel = giftArr[selCell]
        if type == 8{
            /// 个人送礼
            self.sid = self.uid
            self.uid = ""
        }
        GiftNetworkProvider.request(.sendGift(giftId: giftModel.id!, giftQuantity: selNum, receiveUserId: uid, sourceId: sid, type: "\(type)")) { result in
            self.inSend = false
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            if giftModel.dynamicImage != nil && giftModel.dynamicImage!.length > 10{
                                DispatchQueue.main.async {
                                    if UserInfo.getSharedInstance().tempObj == nil{
                                        ShowSVGAView(name: giftModel.dynamicImage!)
                                    }
                                    self.sendGiftBlock?()
                                    
                                }
                            }else{
                                self.superview!.makeToast("送礼成功")
                            }
                            self.removeFromSuperview()
                        }else{
                            if model?.code == 3000 {
                                self.showMeiBiView(num: model?.data ?? 100)
                            }
                        }
                    }
                }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
        self.uid = self.sid
    }
    
    ///获取美币数
    func getPoints() {
        UserInfoNetworkProvider.request(.findPoints) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().points = model?.data
                            self.coinNumLab.text = "\(model?.data ?? 0)"
                            self.coinNumLab.sizeToFit()
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
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    ///弹出美币页面并填入自定义金额
    func showMeiBiView(num:Int){
        // 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节 8：个人收礼
        var content_type = ""
        if self.type == 1 || self.type == 2{
            content_type = "课程"
        }else if self.type == 6 || self.type == 7{
            content_type = "方案"
        }else if self.type == 4{
            content_type = "美丽日记"
        }else if self.type == 5{
            content_type = "美丽相册"
        }else if self.type == 8{
            content_type = "个人主页礼物间"
        }else if self.type == 3{
            content_type = "动态"
        }
        ///上报事件
        HQPushActionWith(name: "click_to_buy_coin", dic: ["current_page":content_type])
        self.buyMeiBiView = BuyMeiBiView()
        self.buyMeiBiView.coinNumLab.text = "余额：\(UserInfo.getSharedInstance().points ?? 0)美币"
        self.buyMeiBiView.otherNum = num
        self.addSubview(self.buyMeiBiView)
        self.buyMeiBiView.snp.makeConstraints { make in
            make.edges.equalTo(self.botView)
        }
    }
    
    ///完成支付回调
    @objc func payCallBack(notifi : Notification){
        self.coinNumLab.text = "\(UserInfo.getSharedInstance().points ?? 0)"
    }
}


extension GiftListView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GiftListItemView = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListItemView", for: indexPath) as! GiftListItemView
        cell.sel = indexPath.row == self.selCell
        cell.sendBtn.tag = indexPath.row
        cell.sendBlock = {
            self.sendGift()
        }
        cell.model = giftArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selCell = indexPath.row
        self.listView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x : Int = Int(scrollView.contentOffset.x)
        if x > 0 {
            nowPage = x / Int(screenWid - 22) + ((x % Int(screenWid - 22) > 0) ? 1 : 0)
        }else if x <= 0{
            nowPage = 0
        }
    }
}
