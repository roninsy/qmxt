//
//  ProjectDetalisView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/1.
//
import UIKit
import MBProgressHUD

class ProjectDetalisView: UIView {
    var topImg = UIImageView()
    var titleView = CourseTitleView()
    var oid : String? = nil
    var payType : String? = nil
    let botHei = 52 + (isFullScreen ? 20 : 0)
    ///是否加入学习
    var isAdd = false{
        didSet{
            self.tableview.isShowMore = isAdd
            self.botView.buyView.isHidden = isAdd
            self.botView.snp.updateConstraints { make in
                make.height.equalTo(isAdd ? botHei : 88)
            }
            if !isAdd {
                ///没加入课程
                if myModel != nil {
                    if myModel!.free ?? false {
                        self.botView.buyView.type = .free
                    }else if myModel!.vipFree! {
                        ///继续
                        self.botView.buyView.price = myModel?.price?.stringValue ?? "0"
                        self.botView.buyView.type = .vipFree
                    }else{
                        self.botView.buyView.price = myModel?.price?.stringValue ?? "0"
                        self.botView.buyView.type = .pay
                    }
                    self.botView.buyView.changgeWithType(type: self.botView.buyView.type)
                }
            }
            self.tableview.reloadData()
            var model = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
            model?.isAdd = self.isAdd
            UserInfo.getSharedInstance().tempObj = model
        }
    }
    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "back_white"))
    let moreBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "more_white"))
    let topView = ProjectDetailsHeadView()
    let tableview = CommentListView()
    let botView = CommentBotView()
    var myModel : CourseDetalisModel? = nil{
        didSet{
            
            if myModel!.vipFree ?? false {
                myModel?.priceType = .vipFree
            }else if myModel!.free ?? false{
                myModel?.priceType = .free
            }else{
                myModel?.priceType = .pay
            }
            ///存储临时变量
            UserInfo.getSharedInstance().tempObj = myModel
            topImg.kf.setImage(with: URL.init(string: myModel!.headerImage!),placeholder: UIImage.init(named: "goodmaster_bg"))
            
            topView.myModel = myModel
            self.topView.giftView.type = 6
            self.botView.type = 6
            self.tableview.type = 6
            self.tableview.myModel = self.myModel
            if !self.isAdd {
                ///继续
            }
            titleView.titleLab.text = myModel?.title
            self.botView.myModel = myModel
            self.tableview.jianJieCell.htmlStr = myModel?.details
            self.tableview.jianJieCell.setpView.type = 6
            self.tableview.jianJieCell.setpView.detalisModel = myModel
            
            self.tableview.teacherCell.myModel = myModel
            self.checkAdd(cid: myModel!.id!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableview.jianJieCell.selType = 0
                self.topView.frame = CGRect.init(x: 0, y: 0, width: Int(screenWid), height: self.topView.myHei)
                self.tableview.reloadData()
            }
            
        }
    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
//            .init(hex: "#F7F8F9")
        topView.frame = CGRect.init(x: 0, y: 0, width: Int(screenWid), height: topView.myHei)
        tableview.tableHeaderView = topView
        topView.numView.selToMenuBlock = {
            self.tableview.selView.segmentedView.defaultSelectedIndex = 0
            self.tableview.jianJieCell.selType = 0
            self.tableview.selView.segmentedView.reloadData()
            self.tableview.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.tableview.scrollToRow(at: .init(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
        
        tableview.refBlock = { flag in
            self.titleView.isHidden = flag == 1
            UIApplication.shared.statusBarStyle = flag == 1 ? .lightContent : .default
        }
        tableview.refMsgCount = { msg in
            self.botView.msgLab.text = getNumString(num: msg.toDouble ?? 0)
        }
        
        self.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(botHei)
        }
        
        topImg.contentMode = .scaleAspectFill
        self.addSubview(topImg)
        topImg.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(screenWid / 193 * 257)
        }
        let grayView = UIView()
        grayView.backgroundColor = .black
        grayView.alpha = 0.3
        topImg.addSubview(grayView)
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(botView.snp.top)
        }
        
        self.addTopBtn()
        self.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.height.equalTo(44 + NavStatusHei)
            make.left.right.top.equalToSuperview()
        }
        titleView.moreBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.showBottomAlert()
        }
        titleView.isHidden = true
    }
    
    func addTopBtn(){
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.top.equalTo(NavStatusHei + 20)
            make.left.equalTo(16)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
        self.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.top.equalTo(backBtn)
            make.left.equalTo(screenWid - 34)
        }
        moreBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.showBottomAlert()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(cid:String) {
        self.tableview.cid = cid
        self.tableview.type = 6
        self.tableview.getNetInfo()
        self.tableview.commentNumInfo()
        
        CourseNetworkProvider.request(.coureseDetails(cid: cid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.myModel = model!.data?.kj.model(CourseDetalisModel.self)
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
    
    func addCourse(cid:String) {
        
        CourseNetworkProvider.request(.addUserCourse(cid: cid)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.checkAdd(cid: cid)
                            let pointsDic = model?.data?["completionJobResult"] as? NSDictionary
                            let points = pointsDic?["pointsSum"] as? String
                            if points != "0" && points != "" && points != nil{
                                ///显示获得美币
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    ShowMeibiAddView(num: points?.toInt ?? 0)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                HQGetTopVC()?.view.makeToast("加入学习成功")
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
    
    func checkAdd(cid:String) {
        self.oid = nil
        self.payType = nil
        CourseNetworkProvider.request(.checkUserCourse(cid: cid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.isAdd = json.contains("true")
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
    
    func checkPay(cid:String) {
        if oid == nil {
            return
        }
        CourseNetworkProvider.request(.callback(cid: oid!, type: payType!)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            HQGetTopVC()?.view.makeToast("购买成功")
                            self.checkAdd(cid: self.myModel!.id!)
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
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")
        
        let share = UIAlertAction(title:"分享", style: .default)
        {
            action in
            let vc = ShareVC()
            vc.type = 10
            vc.model = self.myModel ?? CourseDetalisModel()
            vc.setupMainView()
            HQPush(vc: vc, style: .lightContent)
        }
        
        alertController.addAction(cancel)
        if UserInfo.getSharedInstance().type == 0 {
            if myModel?.userId != UserInfo.getSharedInstance().userId {
                let disAgree = UIAlertAction(title:"投诉", style: .default)
                {
                    action in
                    let cpView = ComplainView()
                    cpView.contentType = 3
                    cpView.sourceId = self.myModel?.id ?? ""
                    HQGetTopVC()?.view.addSubview(cpView)
                    cpView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                }
                alertController.addAction(disAgree)
            }
        }
        alertController.addAction(share)
        if UserInfo.getSharedInstance().type == 0 && !self.isAdd {
            let collect = UIAlertAction(title: self.botView.collectBtn.isSelected ? "取消收藏" : "收藏", style: .default)
            {
                action in
                self.botView.collectBtnClick()
            }
            alertController.addAction(collect)
        }
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
}
