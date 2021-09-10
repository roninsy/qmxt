//
//  SSSSProveSuccessController.swift
//  shensuo
//
//  Created by  yang on 2021/7/9.
//

import UIKit

class SSProveSuccessController: SSBaseViewController {

    //1: 提交认证成功 2; 认证成功 审核不通过 3: 我的个人认证 4:我的企业认证
    var inType: Int = 0
    var currentTitle: String = ""
    var btnBottomV = UIView.init()
    var bottomBackBtn: UIButton?
    var sureBtn: UIButton?
    var bottomTipsView = UIView()
    var tableView: UITableView!
    var proveModel: SSProveModel?
    var personModel: SSPersonModel?
    var proveSelectModel: SSProveSelectModel?
    ///认证主表id
    var cid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navView.backBtnWithTitle(title: currentTitle)
        navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues({ btn in
            self.navigationController?.popViewController(animated: true)
        })
        
        if inType == 1 || inType == 2 {
            
            buildUI()
        }else{
            
            tableView = UITableView.init(frame: CGRect.zero, style: .plain)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SSProveSuccessCell")
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                
                make.leading.bottom.trailing.equalToSuperview()
                make.top.equalTo(NavBarHeight)
                
            }
            tableView.showsVerticalScrollIndicator = false
            tableView.rowHeight = inType == 3 ? 800 : 1200
            tableView.dataSource = self
            tableView.delegate = self
            self.loadData()

        
//            buildMyProveUI(cell: ce, index: <#T##Int#>)
        }
    }

}

extension SSProveSuccessController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSProveSuccessCell")
        self.buildMyProveUI(cell: cell!, index: indexPath.row)
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    
}

extension SSProveSuccessController{
    
    func loadData() -> Void {
        if inType == 3 {
            ///个人认证
            UserInfoNetworkProvider.request(.personalDetail(cid: cid)) { (result) in
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
                                    self.proveSelectModel = dic?.kj.model(SSProveSelectModel.self)
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                        } catch {
                            
                        }
                    case let .failure(error):
                        logger.error("error-----",error)
                    }
            }
        }else{
            UserInfoNetworkProvider.request(.certificationsdetail(cid: cid)) { (result) in
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
                                    self.proveSelectModel = dic?.kj.model(SSProveSelectModel.self)
                                    self.tableView.reloadData()
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
}

extension SSProveSuccessController{
    
    func buildMyProveUI(cell: UITableViewCell,index: Int) {
        
      
        let topV = UIView.init()
        cell.addSubview(topV)
        topV.snp.makeConstraints { make in
            
            make.top.equalTo(0)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
        }
        
        let titleL = UILabel.initSomeThing(title: inType == 3 ? "个人认证" : "企业认证", fontSize: 17, titleColor: color33)
        topV.addSubview(titleL)
        titleL.font = UIFont.MediumFont(size: 17)
        titleL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = bgColor
        topV.addSubview(lineV)
        lineV.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        let passL = UILabel.initSomeThing(title: "认证通过", fontSize: 14, titleColor: .hex(hexString: "#21D826"))
        topV.addSubview(passL)
        passL.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
            
        }
        
        let passIcon = UIImageView.initWithName(imgName: "project_day_finish")
        topV.addSubview(passIcon)
        passIcon.snp.makeConstraints { make in
            
            make.height.width.equalTo(24)
            make.trailing.equalTo(passL.snp.leading).offset(-3)
            make.centerY.equalToSuperview()
        }

        if inType == 3{
            
            let nameL = setCustomV(leftStr: "真实姓名:", rightStr: proveSelectModel?.idname ?? "", referenceV: topV,cell: cell)
            let idCradV = setCustomV(leftStr: "身份证号:", rightStr: proveSelectModel?.idnumber ?? "", referenceV: nameL,cell: cell)
            let mobileL = setCustomV(leftStr: "手机号:", rightStr: proveSelectModel?.mobile ?? "", referenceV: idCradV,cell: cell)
            let commanyV = setCustomV(leftStr: "所属认证企业：", rightStr: proveSelectModel?.ownerCompanyName ?? "", referenceV: mobileL,cell: cell)
            let outL = UILabel.initSomeThing(title: "对外认证展示", fontSize: 16, titleColor: color66)
            cell.addSubview(outL)
            outL.snp.makeConstraints { make in
                
                make.leading.equalTo(16)
                make.top.equalTo(commanyV.snp.bottom).offset(16)
            }
            
            userUI(referenceV: outL,cell: cell)
            buildTipsV(referenceV: btnBottomV,cell: cell)
            
        }else{
            
            let commpanyL = setCustomV(leftStr: "企业名称：", rightStr: proveSelectModel?.companyName ?? "", referenceV: topV,cell: cell)
            let idCradV1 = setCustomV(leftStr: "社会信用代码：", rightStr: proveSelectModel?.creditCode ?? "", referenceV: commpanyL,cell: cell)
            let adderessL = setCustomV(leftStr: "所在省市：", rightStr: "\(proveSelectModel?.provinceName ?? "")\(proveSelectModel?.cityName ?? "")", referenceV: idCradV1,cell: cell)
            let detaileAdderessL = setCustomV(leftStr: "详细地址：", rightStr: proveSelectModel?.detailAddress ?? "", referenceV: adderessL,cell: cell)
          
            let nameL = setCustomV(leftStr: "运营者姓名：", rightStr: proveSelectModel?.operatorName ?? "", referenceV: detaileAdderessL,cell: cell)
            let idCradV = setCustomV(leftStr: "身份证号:", rightStr: proveSelectModel?.operatorIDNumber ?? "", referenceV: nameL,cell: cell)
            let mobileL = setCustomV(leftStr: "手机号:", rightStr: proveSelectModel?.operatorMobile ?? "", referenceV: idCradV,cell: cell)
            let outL = UILabel.initSomeThing(title: "对外认证展示", fontSize: 16, titleColor: color66)
            cell.addSubview(outL)
            outL.snp.makeConstraints { make in
                
                make.leading.equalTo(16)
                make.top.equalTo(mobileL.snp.bottom).offset(16)
            }
            
            userUI(referenceV: outL,cell: cell)
            buildTipsV(referenceV: btnBottomV,cell: cell)
        }
   
//        scrollView.contentSize = CGSize(width: screenWid, height: 1000 + 200)
        
    }
    
    func userUI(referenceV: UIView,cell: UITableViewCell)  {
        
        let bgV = UIView.init()
        cell.addSubview(bgV)
        bgV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(referenceV.snp.bottom).offset(16)
        }
        bgV.backgroundColor = .hex(hexString: "#FDFAF0")
        let iconV = UIImageView.initWithName(imgName: "user_normal_icon")
        bgV.addSubview(iconV)
        iconV.layer.cornerRadius = 32
        iconV.layer.masksToBounds = true
        iconV.snp.makeConstraints { make in
            
            make.height.width.equalTo(64)
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
        iconV.kf.setImage(with: URL.init(string: UserInfo.getSharedInstance().headImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
        
        let nameL = UILabel.initSomeThing(title: self.proveSelectModel?.nickName ?? "", fontSize: 17, titleColor: color33)
        nameL.font = UIFont.MediumFont(size: 17)
        bgV.addSubview(nameL)
        nameL.snp.makeConstraints { make in
            
            make.leading.equalTo(iconV.snp.trailing).offset(16)
            make.top.equalTo(iconV).offset(6)
        }
        
        let VipIcon = UIImageView.initWithName(imgName: "home_vip")
        bgV.addSubview(VipIcon)
        VipIcon.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.left.equalTo(nameL.snp.right).offset(10)
            make.centerY.equalTo(nameL)
            make.width.equalTo(18)
        }
        VipIcon.isHidden = UserInfo.getSharedInstance().vip == false
        
        let proveIcon = UIImageView.initWithName(imgName: "check_com")
        bgV.addSubview(proveIcon)
        proveIcon.snp.makeConstraints { make in
            make.width.equalTo(63)
            make.height.equalTo(17)
            make.leading.equalTo(nameL)
            make.top.equalTo(nameL.snp.bottom).offset(16)
        }
        
        let proveL = UILabel.initSomeThing(title: self.proveSelectModel?.showWords ?? "", fontSize: 13, titleColor: color33)
        bgV.addSubview(proveL)
        proveL.snp.makeConstraints { make in
            make.leading.equalTo(proveIcon.snp.trailing).offset(3)
            make.centerY.equalTo(proveIcon)
            make.right.equalTo(-16)
            make.height.equalTo(18)
        }
        
        buildBtnBgView(referenceV: bgV,cell: cell)
    }
    
    func setCustomV(leftStr: String,rightStr: String,referenceV: UIView,cell: UITableViewCell) -> UIView {
        
        let bgV = UIView.init()
        cell.addSubview(bgV)
        bgV.snp.makeConstraints { make in
            
            make.top.equalTo(referenceV.snp.bottom)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
        }
        
        let leftL = UILabel.initSomeThing(title: leftStr, fontSize: 16, titleColor: color33)
        bgV.addSubview(leftL)
        leftL.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.width.equalTo(124)
            make.centerY.equalToSuperview()
        }
        let rightL = UILabel.initSomeThing(title: rightStr, fontSize: 16, titleColor: color33)
        bgV.addSubview(rightL)
        rightL.snp.makeConstraints { make in
            
            make.leading.equalTo(leftL.snp.trailing)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        return bgV
    }

    func buildTipsV(referenceV: UIView,cell: UITableViewCell)  {
        
        cell.addSubview(bottomTipsView)
        bottomTipsView.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
            make.top.equalTo(referenceV.snp.bottom).offset(20)
        }
        
        let titleL = UILabel.initSomeThing(title: "温馨提示", fontSize: 16, titleColor: color66)
        bottomTipsView.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            
            make.top.equalTo(6)
            make.centerX.equalToSuperview()
        }
        
        let line1 = UIView()
        line1.backgroundColor = bgColor
        bottomTipsView.addSubview(line1)
        line1.snp.makeConstraints { make in
            
            make.centerY.equalTo(titleL)
            make.height.equalTo(1)
            make.width.equalTo(81)
            make.trailing.equalTo(titleL.snp.leading).offset(-6)
        }
        let line2 = UIView()
        line2.backgroundColor = bgColor
        bottomTipsView.addSubview(line2)
        line2.snp.makeConstraints { make in
            
            make.height.centerY.width.equalTo(line1)
            make.leading.equalTo(titleL.snp.trailing).offset(6)
        }
        
        let l1 = UILabel.initSomeThing(title: "     您可电脑登录全民形体认证企业/个人PC客户端：", fontSize: 14, titleColor: color66)
        bottomTipsView.addSubview(l1)
        l1.snp.makeConstraints { make in
            
            make.top.equalTo(titleL.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        let l2 = UILabel.initSomeThing(title: "http://www.qmxt.com/client发布课程/方案。", fontSize: 14, titleColor: color66)
        bottomTipsView.addSubview(l2)
        l2.snp.makeConstraints { make in
            
            make.top.equalTo(l1.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    //intype 1,2
    func buildUI() {
        
        let iconV = UIImageView.initWithName(imgName: "project_day_finish")
        view.addSubview(iconV)
        iconV.snp.makeConstraints { make in
            
            make.top.equalTo(navView.snp.bottom).offset(70)
            make.height.width.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        let titleL = UILabel.initSomeThing(title: inType == 1 ? "提交认证成功" : "认证审核不通过" , fontSize: 18, titleColor: color33)
        view.addSubview(titleL)
        titleL.font = .MediumFont(size: 18)
        titleL.snp.makeConstraints { make in
            
            make.top.equalTo(iconV.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        let tipL = UILabel.initSomeThing(title: "", fontSize: 13, titleColor: color33)
        view.addSubview(tipL)
        tipL.snp.makeConstraints { make in
            
            make.top.equalTo(titleL.snp.bottom).offset(12)
        }
        
        if inType == 1 {
            
            tipL.text = "我们将在7个工作日内给您反馈，请耐心等待！"
            tipL.snp.makeConstraints { make in
                
                make.centerX.equalToSuperview()
            }
            
            buildBtnBgView(referenceV: tipL,cell: UITableViewCell())
        }else{
            
            tipL.text = "尊敬的\(self.proveModel?.status == 1 ? self.proveModel?.operatorName ?? "" : self.proveModel?.nickName ?? "")，您好:"
            tipL.snp.makeConstraints { make in
                
                make.leading.equalTo(8)
                make.top.equalTo(tipL.snp.bottom).offset(20)
            }
            let contenL = UILabel.initSomeThing(title: "     您的企业/个人认证资料我们已经认真审查，有部分资料不符合本平台企业/个人认证标准，所以我们暂时无法通过您的企业/个人认证申请。", fontSize: 14, titleColor: color66)
            view.addSubview(contenL)
            contenL.numberOfLines = 0
            contenL.snp.makeConstraints { make in
                
                make.leading.equalTo(8)
                make.trailing.equalTo(-12)
                make.top.equalTo(tipL.snp.bottom).offset(8)
            }
            
            let noPassL = UILabel.initSomeThing(title: "    您的企业/个人认证审核不通过原因是:", fontSize: 14, titleColor: color66)
            view.addSubview(noPassL)
            noPassL.snp.makeConstraints { make in
                
                make.leading.trailing.equalTo(contenL)
                make.top.equalTo(contenL.snp.bottom).offset(3)
            }
            let noPassReasonL = UILabel.initSomeThing(title: self.proveModel?.auditFailureReason ?? "", fontSize: 14, titleColor: color33)
            view.addSubview(noPassReasonL)
            noPassReasonL.snp.makeConstraints { make in
                
                make.leading.trailing.equalTo(contenL)
                make.top.equalTo(noPassL.snp.bottom).offset(3)
            }
            

            buildBtnBgView(referenceV: noPassReasonL,cell: UITableViewCell())

        }
            
    }
    
    func buildBtnBgView(referenceV: UIView,cell: UITableViewCell) {
        
        if inType == 1 || inType == 2 {
            
            view.addSubview(btnBottomV)
            
        }else{
            
            cell.addSubview(btnBottomV)

        }
        btnBottomV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
            make.top.equalTo(referenceV.snp.bottom).offset(40)
        }
        
        sureBtn = UIButton.initTitle(title: inType == 1 ? "返回" : "重新认证", fontSize: 18, titleColor: .white)
        sureBtn?.backgroundColor = btnColor
        btnBottomV.addSubview(sureBtn!)
        sureBtn?.snp.makeConstraints({ make in
            
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(screenWid / 414 * 300)
        })
        
        sureBtn?.titleLabel?.font = .MediumFont(size: 18)
        sureBtn?.layer.cornerRadius = 22.5
        sureBtn?.layer.masksToBounds = true
        sureBtn?.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            if self?.inType == 1{
                
                self?.navigationController?.popViewController(animated: true)
            }else if(self?.inType == 3){
                
                let vc = SSMyPersonalProveViewController()
                vc.cid = self?.cid ?? ""
                vc.type = 1
                HQPush(vc: vc, style: .default)
                
            }
            else if(self?.inType == 4){
                
                let vc = SSMyCompanyProveViewController()
                vc.cid = self?.cid ?? ""
                vc.type = 1
                HQPush(vc: vc, style: .default)
                
            }
        })
        if inType != 1 {
            
            bottomBackBtn = UIButton.initTitle(title: "返回", fontSize: 18, titleColor: color33)
            btnBottomV.addSubview(bottomBackBtn!)
            bottomBackBtn?.snp.makeConstraints({ make in
                
                make.leading.width.height.equalTo(sureBtn!)
                make.top.equalTo(sureBtn!.snp.bottom).offset(24)
            })
            
            bottomBackBtn?.titleLabel?.font = .MediumFont(size: 18)
            bottomBackBtn?.layer.cornerRadius = 22.5
            bottomBackBtn?.layer.masksToBounds = true
            bottomBackBtn?.layer.borderWidth = 1
            bottomBackBtn?.layer.borderColor = bgColor.cgColor
            bottomBackBtn?.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
    }
    
    
}
