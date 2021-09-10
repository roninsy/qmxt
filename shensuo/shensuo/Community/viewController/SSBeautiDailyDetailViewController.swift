//
//  SSBeautiDailyDetailViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/7.
//

import UIKit


//美丽日记详情
class SSBeautiDailyDetailViewController: HQBaseViewController {
    var cid = ""
    let imageWidth:CGFloat = 106
    let dayBtnWidth:CGFloat = 64
    let dayBtnHeight:CGFloat = 27
    
    var array:Array? = []
    
    var dtModel:SSDongTaiModel? = nil
    var xcModel:MLRJModel? = nil{
        didSet{
            self.cid = xcModel?.id ?? ""
        }
    }
    
    var isShowBottomAlert = false
    
    var selectBtn:UIButton?
    
    var dayDataModel:SSVideoModel? = nil
    
    var userInfoModel : SSUserInfoModel?
    var isOwner:Bool = false

    //详情
    var xqModel:SSXCXQModel? = nil {
        didSet{
            if xqModel != nil {
                nameLabel.text = xqModel?.title
                ///上传事件
                HQPushActionWith(name: "content_view", dic: ["content_id":self.cid,
                                                 "content_type":"美丽日记",
                                                 "note_type":"图文",
                                                 "editor_id":self.xqModel?.userId ?? "",
                                                 "editor_name":self.xqModel?.nickName ?? "",
                                                 "publish_time":self.xqModel?.time ?? ""])
                self.mainTableView.authId = xqModel?.userId ?? ""
                self.mainTableView.sectionHead2.viewNum.text = "\(getNumString(num: xqModel?.viewTimes?.doubleValue ?? 0))阅读"
                self.botView.myModel = xqModel
            }
        }
    }
    
    var videoModels:[SSVideoModel]? = nil {
        didSet{
            
            if videoModels != nil {
                if videoModels!.count > 0 {
                    for index in 0...videoModels!.count-1 {
                        let model = videoModels?[index]
                        array?.append(model?.image ?? "")
                        self.xqModel?.images.append(model?.image ?? "")
                    }
                    headScroll.initImageScroll(images: array! as NSArray)
//                    self.loadImageListData()
                    
                }

            }
        }
    }
    

    var tableHeaderView : UIView = {
        let header = UIView.init()
        return header
    }()
    
    
    var mainTableView = OtherCommentListView()
    
    let botView = OtherCommentBotView()
    
    var navDetailView : SSDetaiNavView = {
        let nav = SSDetaiNavView.init()
        return nav
    }()
    
    
    var headScroll : SSDetailHeadView = {
        let head = SSDetailHeadView.init()
        return head
    }()
    
    var slibar = SSNumSlider.init()
    
    let dayView = UIScrollView.init()
    let popView = SSPopDataView.init()
    let navstatusView = UIView.init()
    var createTimeL = UILabel.initSomeThing(title: "2020-1", fontSize: 14, titleColor: .white)
//    let tipView = UIView.init()
    let nameLabel = UILabel.initSomeThing(title: "30天美丽相册,记录变美生活30天美丽相册-记录变美生活", fontSize: 18, titleColor: .init(hex: "#333333"))
    
    var imageScrollList:UIScrollView = {
        let imageScroll = UIScrollView.init()
        return imageScroll
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    var models : [CommentModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                }
            }
        }
    }
    
    var page = 1
    ///cell是否显示更多按钮
    var isShowMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layoutSubviews()
        
        self.loadData()
        self.loadVideoData()
        
        navDetailView.titleLabel.text = xcModel?.nickName ?? ""
        
        if UserInfo.getSharedInstance().userId == xcModel?.userId {
            navDetailView.focusBtn.setTitle("编辑", for: .normal)
            self.isOwner = true
        } else {
            self.loadPersonInfo()
        }
        
        navDetailView.headImage.kf.setImage(with: URL.init(string: (xcModel?.headImage) ?? ""), placeholder: UIImage.init(named: "PlaceHolder"), options: nil, completionHandler: nil)
        navDetailView.backBlock = {
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
        
        navDetailView.shareBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.showBottomAlert()
        }
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickHeadImage))
        navDetailView.headImage.addGestureRecognizer(tap)
        
        mainTableView.tableHeaderView = tableHeaderView
        mainTableView.tableHeaderView?.frame.size.height = screenWid/414*546+30+420+80+20
        
        navDetailView.clickFocusBtnHandler = { button in
            if !self.isOwner {
                UserInfoNetworkProvider.request(.focusOption(focusUserId: (self.xqModel?.userId ?? ""))) { (result) in
                    switch result {
                        case let .success(moyaResponse):
                            do {
                                let code = moyaResponse.statusCode
                                if code == 200{
                                    let json = try moyaResponse.mapString()
                                    let model = json.kj.model(ResultModel.self)
                                    if model?.code == 0 {
                                        let dic = model?.data
                                        let flag = dic?["type"] as? Bool ?? true
                                        if (!flag) {
                                            HQGetTopVC()?.view.makeToast("取消成功")
                                            button.setTitle("关注", for: .normal)
                                        }else{
                                            HQGetTopVC()?.view.makeToast("关注成功")
                                            button.setTitle("已关注", for: .normal)
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
            } else {
                
            }

        }
        
        
       
    }
    
    func loadCommitData() -> Void {
        CommunityNetworkProvider.request(.commentList(id: self.xqModel?.id ?? "", page: 1, pageSize: 10, type: 1)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            let total = dic["totalElements"] as! String
                            
                            if (total.toInt ?? 0) > 0 {
                                let arr = dic["content"] as! NSArray
                                if self.page == 1 {
                                    self.models = arr.kj.modelArray(type: CommentModel.self)
                                        as? [CommentModel]
                                    
                                }else{
                                    let models = arr.kj.modelArray(type: CommentModel.self)
                                        as? [CommentModel]
                                   
                                    self.models = (self.models ?? []) + (models ?? [])
                                }
                                self.mainTableView.reloadData()
                            }else{
//                                self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
                            }
                        }else{
                            
                        }
                    }
                } catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func loadPersonInfo() -> Void {
        UserInfoNetworkProvider.request(.userInfo(userId: (UserInfo.getSharedInstance().userId ?? ""))) { [self] result in
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
                            self.userInfoModel = dic?.kj.model(SSUserInfoModel.self)
                            if self.userInfoModel?.focusType == true {
                                navDetailView.focusBtn.setTitle("已关注", for: .normal)
                            } else {
                                navDetailView.focusBtn.setTitle("关注", for: .normal)
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
    
    
    func buildListDataView() -> UIView {
        let dataView = UIView.init()
        let listTableView = UITableView.init()
        
        dataView.addSubview(listTableView)
        return dataView
    }
    
    func loadDaysData(days:Int, btn:UIButton) -> Void {
        CommunityNetworkProvider.request(.selectDatesAppDay(days: days, id: (cid))) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                if dic == nil {
                                    return
                                }
                                
                                self.dayDataModel = dic?.kj.model(type: SSVideoModel.self) as? SSVideoModel
                                self.loadDayDataView(btn)
                                
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
 
    func loadDayDataView(_ sender: UIButton) -> Void {
        
//        let options: [PopoverViewOption] = [.type(.down), .showBlackOverlay(false),.showShadowy(true),.arrowPositionRatio(24 / 123.0),.arrowSize(CGSize(width: 12, height: 16)),.color(.brown)]
//        let pop = PrincekinPopoverView.init(options: options)
//
//        popView.dayDataModel = self.dayDataModel
//        popView.dataTableView.reloadData()
//        pop.contentView = popView
//        pop.show(pop.contentView, fromView: sender)
        
        popView.dayDataModel = self.dayDataModel
        popView.dataTableView.reloadData()
        
    }
    
    func loadVideoData() -> Void {
        CommunityNetworkProvider.request(.selectDatesVideo(id: (cid),userId: xcModel?.userId ?? "")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                
                                let array = model?.data
                                self.videoModels = array?.kj.modelArray(type: SSVideoModel.self) as? [SSVideoModel]
                                self.slibar.maximumValue = Float(self.videoModels?.count ?? 0)
                                self.slibar.videoModels = self.videoModels
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
    
    func loadImageListData() -> Void {
        for index in 0...self.array!.count-1 {
            let imageView = UIImageView.init(frame: CGRect(x:(10+imageWidth)*CGFloat(index), y: 0, width: imageWidth, height: imageWidth))
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 6
            imageView.kf.setImage(with: URL.init(string: (self.array![index]) as! String), placeholder: UIImage.init(named: "PlaceHolder"), options: nil, completionHandler: nil)
            imageScrollList.addSubview(imageView)
        }
        
        imageScrollList.contentSize = CGSize(width: (10+Int(imageWidth))*self.array!.count, height: 100)
    }
    
    func loadDayList() -> Void {
        for index in 0...self.xqModel!.days - 1 {
            let dayBtn = UIButton.init(frame: CGRect(x: (10+dayBtnWidth)*CGFloat(index), y: 2, width: dayBtnWidth, height: dayBtnHeight))
            dayBtn.setTitle(String.init(format: "第%d天", arguments: [index+1]), for: .normal)
            dayBtn.setTitleColor(.black, for: .normal)
            dayBtn.setTitleColor(.init(hex: "#FD8024"), for: .selected)
            dayBtn.setBackgroundImage(UIImage.init(named: "bt_daynormal"), for: .normal)
            dayBtn.setBackgroundImage(UIImage.init(named: "bt_dayselect"), for: .selected)
            dayBtn.titleLabel?.font = .systemFont(ofSize: 12)
            dayBtn.layer.masksToBounds = true
            dayBtn.layer.cornerRadius = 10
            dayBtn.tag = index
            dayBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
                if self.selectBtn?.isSelected == true {
                    self.selectBtn?.isSelected = false
                }
                self.selectBtn = btn
                btn.isSelected = true
                self.loadDaysData(days: (btn.tag+1), btn:dayBtn)
                
            }
            
            if index == 0 {
                self.selectBtn = dayBtn
                dayBtn.isSelected = true
                self.loadDaysData(days: 1,  btn:dayBtn)
            }
            dayView.addSubview(dayBtn)
        }
        
        dayView.contentSize = CGSize(width: (10+dayBtnWidth)*6, height: dayBtnHeight)
    }
    
    func loadData() -> Void {
        CommunityNetworkProvider.request(.selectDatesListApp(id: cid)) { [self] result in
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
                            self.xqModel = dic?.kj.model(SSXCXQModel.self)
                            self.loadDayList()
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    
        self.mainTableView.cid = self.cid
        self.mainTableView.type = 4
        self.mainTableView.getNetInfo()
        self.mainTableView.commentNumInfo()
    }
    
    
    @objc func clickHeadImage(){
        self.navigationController?.pushViewController(SSPersionDetailViewController.init(), animated: true)
    }
    
    @objc func clickSlidebar(_ sender: UISlider) -> Void {
        
        headScroll.timer.invalidate()
        let sli = sender
        self.headScroll.headScrollView.setContentOffset(CGPoint(x: NSInteger(sli.value)*(Int(screenWid)), y: 0), animated: false)
        NSLog(String.init(format: "#########%.0f", sli.value))
//        tipLabel.text = String.init(format: "第%.0f天", sli.value)
        
        
    }
    
    func layoutSubviews() -> Void {
         
        self.view.addSubview(navstatusView)
        navstatusView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(NavStatusHei)
        }
        
        self.view.addSubview(navDetailView)
        navDetailView.backgroundColor = .white
        navDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(navstatusView.snp.bottom)
            make.left.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
        
        self.botView.type = 4
        self.view.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(isFullScreen ?  59 : 49)
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navDetailView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(botView.snp.top)
        }
        
        mainTableView.refMsgCount = { msg in
            self.botView.msgLab.text = getNumString(num: msg.toDouble ?? 0)
        }
        
        tableHeaderView.addSubview(headScroll)
        headScroll.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(screenWid/414*546)
        }
        tableHeaderView.addSubview(createTimeL)
        createTimeL.textAlignment = .center
        createTimeL.layer.cornerRadius = 12.5
        createTimeL.layer.masksToBounds = true
        createTimeL.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.5)
        createTimeL.snp.makeConstraints { make in
            
            make.trailing.equalTo(headScroll).offset(-16)
            make.bottom.equalTo(headScroll).offset(-50)
            make.width.equalTo(110)
            make.height.equalTo(25)
            
        }
//        tipView.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*80)
//        tipView.layer.masksToBounds = true
//        tipView.layer.cornerRadius = 12
////        HQRoude(view: tipView, cs: [.topLeft,.topRight], cornerRadius: 12)
//
//        tableHeaderView.insertSubview(tipView, aboveSubview: headScroll)
//        tipView.snp.makeConstraints { (make) in
//            make.top.equalTo(headScroll.snp.bottom).offset(-12)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(80)
//        }
//
//        tipView.addSubview(nameLabel)
//        nameLabel.numberOfLines = 0
//        nameLabel.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        }
        
        tableHeaderView.addSubview(slibar)
        slibar.parentView = tableHeaderView
        slibar.minimumValue = 0
        slibar.addTarget(self, action: #selector(clickSlidebar(_:)), for: .valueChanged)
        slibar.snp.makeConstraints { (make) in
            make.top.equalTo(headScroll.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
//        slibar = UISlider.init(frame: CGRect(x: 10, y: scrollView.frame.maxY+10, width: screenWid-20, height: 200))
//        slibar.minimumValue = 0
//        slibar.maximumValue = Float(imagesArray.count-1)
//
//        view.addSubview(slibar)
        
        tableHeaderView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(slibar.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        tableHeaderView.addSubview(dayView)
        dayView.showsVerticalScrollIndicator = false
        dayView.showsHorizontalScrollIndicator = false
        dayView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableHeaderView.addSubview(popView)
        popView.snp.makeConstraints { (make) in
            make.top.equalTo(dayView.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(440)
        }
        
        tableHeaderView.addSubview(imageScrollList)
        imageScrollList.snp.makeConstraints { (make) in
            make.top.equalTo(dayView.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(116)
        }
        
                
    }

    /// 屏幕底部弹出的Alert
    func showBottomAlert(){
        if self.isShowBottomAlert {
            return
        }
        self.isShowBottomAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowBottomAlert = false
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        let disAgree = UIAlertAction(title:"投诉", style: .default)
        {
            action in
            let cpView = ComplainView()
            cpView.contentType = 6
            cpView.sourceId = self.xqModel?.id ?? ""
            HQGetTopVC()?.view.addSubview(cpView)
            cpView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        alertController.addAction(cancel)

        let share = UIAlertAction(title:"分享", style: .default)
        {
            action in
            let vc = ShareVC()
            vc.type = 7
            vc.xqModel = self.xqModel ?? SSXCXQModel()
            vc.setupMainView()
            HQPush(vc: vc, style: .lightContent)
        }
        alertController.addAction(share)
        alertController.addAction(disAgree)
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }

}



