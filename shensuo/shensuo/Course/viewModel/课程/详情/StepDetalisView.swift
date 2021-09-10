//
//  SetpDetalisView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/19.
//

import UIKit
import MBProgressHUD

class StepDetalisView: UIView {
    ///1 课程 2方案
    var type = 1{
        didSet{
            self.topView.type = type
        }
    }
    
    var titleView = CourseTitleView()
    let botHei = 52 + (isFullScreen ? 20 : 0)
    ///是否加入学习
    var isAdd = false{
        didSet{
            self.topView.playView.isAdd = isAdd
            self.tableview.isShowMore = isAdd
            self.botView.buyView.isHidden = isAdd
            self.botView.snp.updateConstraints { make in
                make.height.equalTo(isAdd ? botHei : 88)
            }
            if !isAdd {

            }
            self.tableview.reloadData()
        }
    }
    let topView = StepDetalisHeaderView()
    let tableview = StepCommentListView()
    let botView = CommentBotForStepView()
    
    var myModel : CourseStepListModel? = nil{
        didSet{
            if topView.myModel == nil {
                topView.myModel = myModel
            }
            self.tableview.stepModel = myModel
            self.botView.type = self.type == 1 ? 2 : 7
            self.botView.sourceId = myModel?.id ?? ""
            
            let model = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
            self.checkAdd(cid: model?.id ?? "")
            self.tableview.myModel = model
            self.botView.myModel = myModel
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                self.tableview.reloadData()
//            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        titleView.titleLab.text = "小节详情"
        self.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.height.equalTo(44 + NavStatusHei)
            make.left.right.top.equalToSuperview()
        }
        
        tableview.refMsgCount = { msg in
            self.botView.msgLab.text = getNumString(num: msg.toDouble ?? 0)
        }
        
        topView.frame = CGRect.init(x: 0, y: 0, width: Int(screenWid), height: Int(topView.upMyHei()))
        tableview.tableHeaderView = topView
        topView.upHeiBlock = { hei in
            self.topView.frame = CGRect.init(x: 0, y: 0, width: Int(screenWid), height:hei)
            self.tableview.reloadData()
        }
        
        self.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalTo(-botHei)
        }
        
        self.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(botHei)
        }
        
        self.titleView.moreBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.showBottomAlert()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(cid:String) {
        self.tableview.cid = cid
        self.tableview.type = self.type == 1 ? 2 : 7
        self.tableview.getNetInfo()
        self.tableview.commentNumInfo()
        
        CourseNetworkProvider.request(.selectCourseStepApp(cid: cid)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.myModel = model!.data?.kj.model(CourseStepListModel.self)
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
                            self.makeToast("加入成功")
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
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        
        alertController.addAction(cancel)
        let share = UIAlertAction(title:"分享", style: .default)
        {
            action in
            let vc = ShareVC()
            vc.type = 1
            vc.model = self.topView.model ?? CourseDetalisModel()
            vc.setupMainView()
            HQPush(vc: vc, style: .lightContent)
        }
        alertController.addAction(share)
        if UserInfo.getSharedInstance().type == 0 {
            let disAgree = UIAlertAction(title:"投诉", style: .default)
            {
                action in
                let cpView = ComplainView()
                cpView.contentType = self.type == 1 ? 2 : 4
                cpView.sourceId = self.myModel?.id ?? ""
                HQGetTopVC()?.view.addSubview(cpView)
                cpView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            alertController.addAction(disAgree)
        }
        
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
}
