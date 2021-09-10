//
//  SSMyNewViewController.swift
//  shensuo
//
//  Created by  yang on 2021/6/2.
//

import UIKit
import swiftScan
import SwiftyUserDefaults
import MBProgressHUD

class SSMyNewViewController: HQBaseViewController, LBXScanViewControllerDelegate {

    var listTableView:UITableView? = nil
    
    let optionV = optionView()
    let personView = persionInfoView()
    let fourView = fourTipsView()
    let hyView = huiyunInfo()
    let hdImageView = UIImageView.initWithName(imgName: "my_newhd")
    let bgImageView = UIImageView.initWithName(imgName: "my_bg")
    var isSupportContinuous = false
    ///草稿箱未读消息数
    let drafCountLabel = UILabel.initSomeThing(title: "", isBold: false, fontSize: 9, textAlignment: .center, titleColor: .white)
    
    var userInfoModel:SSUserInfoModel? {
        didSet{
            if userInfoModel != nil {
                
                if userInfoModel!.vip {
                    hyView.hgImage.isHidden = true
                    hyView.timeLabel.isHidden = false
                    hyView.vip_icon.isHidden = false
                    hyView.num.isHidden = false
                    hyView.tipsLabel.isHidden = true
                    hyView.typeImageV.isHidden = false
                    hyView.timeLabel.text = "有效期至" + (userInfoModel!.vipEndDate ?? "")
                    hyView.num.text = userInfoModel!.vipNumber
                    hyView.hyBgImage.image = UIImage.init(named: "my_huiyunkabg")
                    hyView.buyButton.setTitle("立即续费", for: .normal)
                    hyView.buyButton.setTitleColor(.white, for: .normal)
                    hyView.buyButton.backgroundColor = .clear
                    hyView.buyButton.layer.borderWidth = 0.5
                    hyView.buyButton.layer.borderColor = color99.cgColor

                    hyView.title.snp.makeConstraints { make in
                        
                        make.leading.equalTo(77)
                    }
                } else {
                    hyView.num.isHidden = true
                    hyView.vip_icon.isHidden = true
                    hyView.hgImage.isHidden = false
                    hyView.timeLabel.isHidden = true
                    personView.hgImageView.isHidden = true
                    hyView.tipsLabel.isHidden = false
//                    hyView.hyBgImage.backgroundColor = .init(hex: "#191921")
                    hyView.layer.masksToBounds = true
                    hyView.layer.cornerRadius = 12
                    hyView.backgroundColor = UIColor.init(r: 25, g: 25, b: 33, a: 0.5)
                  
                }
                
                personView.headImageView.kf.setImage(with: URL.init(string: (userInfoModel!.headImage) ?? ""), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
                personView.nameLabel.text = userInfoModel!.nickName
                personView.sexImageView.image = userInfoModel!.sex == 2 ? UIImage(named: "nanxing") :  UIImage(named: "nvxing")
                personView.hjBtn.setTitle(String(format: "徽章%d", (userInfoModel!.badgeNumber ?? "")), for: .normal)
                personView.hjBtn.sizeToFit()
                let hjBtnWContentW = labelWidthFont(font: UIFont.systemFont(ofSize: 10), fixedWidth: 200, str: personView.hjBtn.currentTitle!)
                
                let hjBtnW: CGFloat = hjBtnWContentW + 30
                personView.hjBtn.snp.updateConstraints { make in

                    make.width.equalTo(hjBtnW)
                }
                
                fourView.fenContent.numLabel.text = String(userInfoModel!.fansNumber ?? 0)
                fourView.foceContent.numLabel.text = String(userInfoModel!.focusNumber ?? 0)
                fourView.tipContent.numLabel.text = String(userInfoModel!.likeTimes ?? 0)
                fourView.meiContent.numLabel.text = String(userInfoModel!.currentPoints ?? 0)  //userInfoModel?.currentPoints ?? ""
                
//                userInfoModel!.vip ? hyView.buyButton.setImage(UIImage.init(named: "my_sufei"), for: .normal) : hyView.buyButton.setImage(UIImage.init(named: "my_buyvip"), for: .normal)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        listTableView = UITableView()
        listTableView!.contentInsetAdjustmentBehavior = .never
        listTableView!.showsHorizontalScrollIndicator = false
        listTableView!.showsVerticalScrollIndicator = false
        listTableView!.delegate = self
        listTableView!.dataSource = self
        listTableView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listTableView!.tableHeaderView = tableHeaderView()
        listTableView!.separatorStyle = .none
        view.addSubview(listTableView!)
        listTableView!.snp.makeConstraints({ make in
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-(SafeBottomHei + 49))
        })
        
        let sendBtn = UIButton.init()
        view.insertSubview(sendBtn, at: 99)
        sendBtn.setImage(UIImage.init(named: "icon-fabu"), for: .normal)
        sendBtn.addTarget(self, action: #selector(jumpToReleaseVC), for: .touchUpInside)
        sendBtn.snp.makeConstraints { make in
            
            make.bottom.equalTo(-(60 + SafeBottomHei))
            make.trailing.equalTo(-18)
            make.height.width.equalTo(63)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userIsNotLogin() {
            return
        }
        
        self.tabBarController?.tabBar.isHidden = false
        MBProgressHUD.hide(for: self.view, animated: true)
        loadPersonInfo()
        self.getDraftCount()
        self.loadBgImageData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true

    }
    
    func loadPersonInfo() -> Void {
        
        UserInfoNetworkProvider.request(.userInfo(userId: (UserInfo.getSharedInstance().userId ?? ""))) { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            self?.userInfoModel = dic?.kj.model(SSUserInfoModel.self)
                            let userType = DefaultsKey<Int?>(userTypeKeyString)
                            Defaults[key: userType] = self?.userInfoModel?.userType
                            self?.listTableView?.reloadData()
                        }
                    }
                }
                catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func loadBgImageData() {
        
        UserInfoNetworkProvider.request(.bgImage(userId: (UserInfo.getSharedInstance().userId ?? ""))) { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultStringModel.self)
                        if model?.code == 0 {
                           
                            self?.bgImageView.kf.setImage(with: URL.init(string: model?.data ?? ""),placeholder: UIImage.init(named: "my_bg"))
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    func tableHeaderView() -> UIView {
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*486))
        
        
        let mainView = UIView()
        let mainTitle = UILabel.initSomeThing(title: "个人主页", isBold: true, fontSize: 18, textAlignment: .left, titleColor: .init(hex: "#333333"))
        
        let mainCont = UIControl.initWithImageAndTitle(imgName: "my_newmain", titleStr: "我的主页", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), imageWidth: screenWid/414*40)
        let giftCont = UIControl.initWithImageAndTitle(imgName: "my_newgift", titleStr: "我的礼物间", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), imageWidth: screenWid/414*40)
        let drafCont = UIControl.initWithImageAndTitleWithNum(imgName: "my_newcgx", titleStr: "草稿箱", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), imageWidth: screenWid/414*40, num: "")
                
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.layer.masksToBounds = true
        headView.addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*350)
        }
        
        
        bgImageView.addSubview(optionV)
        optionV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bgImageView.addSubview(personView)
        personView.snp.makeConstraints { (make) in
            make.top.equalTo(optionV.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        personView.hjBtn.reactive.controlEvents(.touchUpInside).observe({ _ in
            
            let vc = SSMyBadgeViewController()
            HQPush(vc: vc, style: .lightContent)
        })
        
        bgImageView.addSubview(fourView)
        fourView.snp.makeConstraints { (make) in
            make.top.equalTo(personView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bgImageView.addSubview(hyView)
        hyView.snp.makeConstraints { (make) in
            make.top.equalTo(fourView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(screenWid-32)
            make.bottom.equalToSuperview()
        }
        
        bgImageView.insertSubview(hdImageView, aboveSubview: hyView)
        hdImageView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        headView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainView.addSubview(mainTitle)
        mainTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.left.equalTo(30)
            make.height.equalTo(25)
        }
        
        mainView.addSubview(mainCont)
        mainCont.tag = 1000
        mainCont.addTarget(self, action: #selector(clickControl(conBtn:)), for: .touchUpInside)
        mainCont.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitle.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.width.height.equalTo(screenWid/3-30)
        }
        
        mainView.addSubview(giftCont)
        giftCont.tag = 2000
        giftCont.addTarget(self, action: #selector(clickControl(conBtn:)), for: .touchUpInside)
        giftCont.snp.makeConstraints { (make) in
            make.top.equalTo(mainCont)
            make.width.height.equalTo(screenWid/3-30)
            make.centerX.equalToSuperview()
        }
        
        mainView.addSubview(drafCont)
        drafCont.tag = 3000
        
        drafCont.addTarget(self, action: #selector(clickControl(conBtn:)), for: .touchUpInside)
        drafCont.snp.makeConstraints { (make) in
            make.top.equalTo(mainCont)
            make.width.height.equalTo(screenWid/3-30)
            make.right.equalTo(-30)
        }
        drafCountLabel.backgroundColor = .red
        drafCountLabel.layer.masksToBounds = true
        drafCountLabel.layer.cornerRadius = 5
        drafCont.addSubview(drafCountLabel)
        drafCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalToSuperview().offset(screenWid/414*40/2-5)
            make.width.equalTo(18)
            make.height.equalTo(12)
        }
        
        self.hyView.buyButton.addTarget(self, action: #selector(clickBuyBtn), for: .touchUpInside)
        self.personView.ewmBtn.addTarget(self, action: #selector(clickEwmBtn), for: .touchUpInside)
        self.optionV.setBtn.addTarget(self, action: #selector(clickSetBtn), for: .touchUpInside)
        self.optionV.sysBtn.addTarget(self, action: #selector(clickSysBtn), for: .touchUpInside)
        
        self.fourView.clickFenContentHander = {
            let listView = SSFocusListViewController.init()
            listView.type = .FriendList
            self.navigationController?.pushViewController(listView, animated: true)
        }
        
        self.fourView.clickFocusContentHander = {
            let listView = SSFocusListViewController.init()
            listView.type = .FocusList
            self.navigationController?.pushViewController(listView, animated: true)
        }
        
//                view.optionV.sysBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
//                    self.fitQRCode()
//
//                }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapPersionView))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.personView.addGestureRecognizer(tap)
        
        return headView
    }
    
    @objc func clickBuyBtn() -> Void {
        ///上报事件
        HQPushActionWith(name: "click_buy_vip", dic:  ["current_page":"我的页面"])
        let vc = SSMyVipViewController()
        vc.hidesBottomBarWhenPushed = true
        HQPush(vc: vc, style: .default)
    }
    
    @objc func clickEwmBtn() -> Void {
        let vc = ShareVC()
        vc.hidesBottomBarWhenPushed = true
        vc.setupMainView()
        HQPush(vc: vc, style: .default)
    }
    
    @objc func clickSetBtn() -> Void {
        HQPush(vc: SSMessageViewController(), style: .default)
    }
    
    @objc func clickSysBtn() -> Void {
        self.fitQRCode()
    }
    
    func fitQRCode() -> Void {
        //设置扫码区域参数
        var style = LBXScanViewStyle()

        style.centerUpOffset = 60
        style.xScanRetangleOffset = 30

        if UIScreen.main.bounds.size.height <= 480 {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40
            style.xScanRetangleOffset = 20
        }

        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)

        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2.0
        style.photoframeAngleW = 16
        style.photoframeAngleH = 16

        style.isNeedShowRetangle = false

        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_full_net")
        
        
        let vc = HWScanViewController()

//        vc.scanStyle = style
//        vc.isSupportContinuous = true;
//
//        isSupportContinuous = true
//        vc.scanResultDelegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func scanFinished(scanResult: LBXScanResult, error: String?) {
        NSLog("scanResult:\(scanResult)")
        
        
        
        if !isSupportContinuous {
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
//                let vc = ScanResultController()
//                vc.codeResult = scanResult
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
        
    }
    
    @objc func tapPersionView() -> Void {
        self.navigationController?.pushViewController(SSMyInfoViewController(), animated: true)
    }

    ///获取草稿箱消息数量
    func getDraftCount(){
        ///获取天数
        CommunityNetworkProvider.request(.draftCount) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            let count = model?.data ?? 0
                            self.drafCountLabel.text = "\(model?.data ?? 0)"
                            self.drafCountLabel.isHidden = count == 0
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    //跳转到发布动态页面
   @objc func jumpToReleaseVC() {
    ///上报事件
    HQPushActionWith(name: "click_publish_note", dic:  ["current_page":"我的"])
        let vc = SSReleaseNewsViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
   }
}

extension SSMyNewViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWid = screenWid < 414 ? 414 : screenWid
        if indexPath.section == 1 {
            return screenWid/414*525
        }
        return screenWid/414*152*2-50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screenWid2 = screenWid < 414 ? 414 : screenWid
        if indexPath.section == 0 {
            let cellView = UITableViewCell.init()
            cellView.selectionStyle = .none
            cellView.backgroundColor = .init(hex: "#F7F8F9")
        
            let contentView = UIView()
            contentView.backgroundColor = .init(hex: "#FFFFFF")
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 15
            cellView.contentView.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.width.equalTo(screenWid - 32)
                make.height.equalTo(screenWid2/414*152*2-50-16)
                make.top.left.equalTo(16)
            }
            
            let titleLabel = UILabel.initSomeThing(title: "我的专属", isBold: true, fontSize: 18, textAlignment: .left, titleColor: .init(hex: "#333333"))
            titleLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 25)
            contentView.addSubview(titleLabel)
            
            let imgArray = ["my_newkc","my_newfa","my_newmygift","my_newsc","my_newmbrw","my_newwdmb","my_xingtibei"]
            let titleArray = ["我的课程","我的方案","我的礼物","我的收藏","美币任务","我的美币","我的形体贝"]
            
            for index in 0 ... imgArray.count-1 {
                let contBtn = UIControl.initWithImageAndTitle(imgName: imgArray[index], titleStr: titleArray[index], titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 14), imageWidth: screenWid2/414*32)
                if index < 4 {
                    contBtn.frame = CGRect(x: (screenWid/4-8)*CGFloat(index), y: 50, width: screenWid/4-8, height: screenWid2/4-8)
                }else{
                    contBtn.frame = CGRect(x: (screenWid/4-8)*CGFloat(index-4), y: 50 + screenWid2/4 - 8, width: screenWid/4-8, height: screenWid2/4-8)
                }
               
                contBtn.tag = index
                contBtn.addTarget(self, action: #selector(clickControl(conBtn:)), for: .touchUpInside)
                contentView.addSubview(contBtn)
            }

            return cellView
        } else {
            let cellView = UITableViewCell.init()
            cellView.selectionStyle = .none
            cellView.backgroundColor = .init(hex: "#F7F8F9")
            
            
            let contentView = UIView.init(frame: CGRect(x: 16, y: 16, width: screenWid-32, height: screenWid2/414*515-16))
            contentView.backgroundColor = .init(hex: "#FFFFFF")
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 15
            cellView.contentView.addSubview(contentView)
            
            let imgArray = ["my_newzdmx","my_tixan_icon","my_newgrzl","my_newwyrz","my_newyqhy","my_intive_record","my_newaqzx","my_newsz"]
            let titleArray = ["账单明细","提现","个人资料","我要认证","邀请好友","邀请记录","安全中心","设置"]
            
            for index in 0 ... imgArray.count-1 {
                let titleStr = titleArray[index]
                let indexNum = index
                var contBtn : UIControl!
                if index == 1{
                    if (UserInfo.getSharedInstance().appVersion ?? 0) <= (UserInfo.getSharedInstance().version ?? 0) {
                        contBtn = UIControl.initWithIconAndTitle(imgName: imgArray[index], titleStr: titleStr)
                        contBtn.tag = index+100
                    }else{
                        contBtn = UIControl.initWithIconAndTitle(imgName: "my_newsz", titleStr: "个人设置")
                        contBtn.tag = 107
                    }
                }else{
                    contBtn = UIControl.initWithIconAndTitle(imgName: imgArray[index], titleStr: titleStr)
                    contBtn.tag = index+100
                }
                
                contBtn.frame = CGRect(x: 12, y: CGFloat(60 * indexNum), width: screenWid-56, height: screenWid2/414*60)
                
                
                
                contBtn.addTarget(self, action: #selector(clickControl(conBtn:)), for: .touchUpInside)
                contentView.addSubview(contBtn)
            }
            
            return cellView
        }
     
    }
    
    @objc func clickControl(conBtn:UIControl) -> Void {
        let clickControl = conBtn
        switch clickControl.tag {
            case 1000: //我的主页
                let persionDetailVC = SSPersionDetailViewController.init()
                persionDetailVC.cid = (UserInfo.getSharedInstance().userId ?? "")
//                persionDetailVC.selectIndex = 1
                self.navigationController?.pushViewController(persionDetailVC, animated: true)
                break
            case 2000: //我的礼物间
                let vc = SSPersionDetailViewController.init()
                vc.cid = UserInfo.getSharedInstance().userId ?? ""
                
                HQPush(vc: vc, style: .lightContent)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    vc.segmentedView.defaultSelectedIndex = 1
                    vc.segmentedView.reloadData()
                }
                break
            case 3000: //草稿箱
                self.navigationController?.pushViewController(SSMyDraftsViewController(), animated: true)
                break
            case 0: //我的课程
                jumpToVC(inType: 1, titles: ["全部","未完成","已完成"],title: "我的课程")
                break
            case 1: //我的方案
                jumpToVC(inType: 2, titles: ["全部","未完成","已完成"], title: "我的方案")
                break
            case 2://我的礼物
                jumpToVC(inType: 4, titles: ["全部","收礼","送礼"], title: "我的礼物")

//                self.navigationController?.pushViewController(SSGiftViewController(), animated: true)
                break
            case 3: //我的收藏
                self.navigationController?.pushViewController(SSMyCollectionViewController(), animated: true)
                break
            case 10: //美币魔盒
//                let billBoxVC = SSBeautiBillBoxViewController.init()
//                billBoxVC.point = self.userInfoModel?.currentPoints
//                billBoxVC.hidesBottomBarWhenPushed = true
//                HQPush(vc: billBoxVC, style: .lightContent)

                break
            case 4: //美币任务
                let vc = SSBeautiBillTaskViewController()
                vc.hidesBottomBarWhenPushed = true
                HQPush(vc: vc, style: .lightContent)
                
//                self.navigationController?.pushViewController(SSBeautiBillTaskViewController(), animated: true)
                break
            case 5: //我的美币
                let vc = SSBeautiBillDetailViewController()
                vc.hidesBottomBarWhenPushed = true
                HQPush(vc: vc, style: .default)
                break
            case 6:
                let vc = SSXingTiBeiVC()
                vc.hidesBottomBarWhenPushed = true
                HQPush(vc: vc, style: .default)
                break
            case 13: //我的兑换
                break
            case 100: //账单明细
                let vc = SSAccountDetailViewController()
                vc.hidesBottomBarWhenPushed = true
                HQPush(vc: vc, style: .default)
                break
            case 101: //提现
                
                let cashVC = SSMyCashOutViewController.init()
                HQPush(vc: cashVC, style: .default)

            case 102: //个人资料
                let vc = SSMyInfoViewController()
                vc.hidesBottomBarWhenPushed = true
                HQPush(vc: vc, style: .default)
                break
            case 103://我要认证
                let vc = SSMyProveSelectViewController()
                vc.hidesBottomBarWhenPushed = true
                HQPush(vc: vc, style: .default)
                break
            case 104: //邀请好友
                let vc = ShareVC()
                vc.type = 1
                vc.onlyShare = true
                vc.setupMainView()
                HQPush(vc: vc, style: .lightContent)
                break
            case 105: //邀请记录
                self.navigationController?.pushViewController(IntiveRecordListVC(), animated: true)
                break
            case 106: //安全中心
            self.navigationController?.pushViewController(SSSafeCenterViewController(), animated: true)
            break
            case 107: //设置
                self.navigationController?.pushViewController(SSMySetViewController(), animated: true)
                break
                
            default:
                break
        }
    }
    
    func jumpToVC(inType: Int, titles: [String],title: String)  {
        
        let vc = SSGiftViewController()
        vc.title = title
        vc.inType = inType
        vc.segTitles = titles
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
