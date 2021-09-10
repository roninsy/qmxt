//
//  SSMyProveSelectViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/6.
//

import UIKit

class SSMyProveSelectViewController: HQBaseViewController {
    
    var listTableView: UITableView = {
        let tabView = UITableView(frame: CGRect(x: 0, y: -statusHei, width: screenWid, height: screenHei), style: .plain)
        tabView.backgroundColor = .white    
        return tabView
    }()
    
    let proveTypes = ["企业认证","个人认证"]
    let proceImages = ["my_qyrz","my_grrz"]
    let tips = ["认证成为发布课程方案的官方企业","认证成为官方企业旗下的导师/员工"]
    
    var proveModel:SSProveModel? = nil {
        didSet {
            if proveModel != nil {
                self.listTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.tableHeaderView = self.headView()
        listTableView.tableFooterView = self.footerView()
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(myProveCell.self, forCellReuseIdentifier: "myProveCell")
        
        view.addSubview(self.listTableView)
        
        loadData()
    }
    
    func loadData() {
        // 请求数据
        UserInfoNetworkProvider.request(.myCertifications) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data
                            if dic != nil {
                                self.proveModel = dic!.kj.model(type: SSProveModel.self) as? SSProveModel
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
    
    private func headView() -> UIView {
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*276))
        
        let bgImageView = UIImageView.initWithName(imgName: "my_provebg")
        bgImageView.isUserInteractionEnabled = true
        header.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(screenWid/414*221)
        }
        
        let backBtn = UIButton.initBgImage(imgname: "back_white")
        backBtn.frame = CGRect(x: 10, y: 40, width: 24, height: 24)
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        bgImageView.addSubview(backBtn)
        
        let titleLabel = UILabel.initSomeThing(title: "身份认证", isBold: true, fontSize: 24, textAlignment: .center, titleColor: .init(hex: "#FFFFFF"))
        bgImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(80)
            make.height.equalTo(33)
            make.width.equalTo(120)
        }
        
        let tipsLabel = UILabel.initSomeThing(title: "认证个人和企业，权威身份标识", fontSize: 16, titleColor: .init(hex: "#FFFFFF"))
        tipsLabel.textAlignment = .center
        bgImageView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalTo(screenWid)
            make.height.equalTo(22)
        }
        
        let type = UILabel.initSomeThing(title: "认证类型", isBold: true, fontSize: 17, textAlignment: .left, titleColor: .init(hex: "#333333"))
        header.addSubview(type)
        type.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(bgImageView.snp.bottom).offset(16)
            make.height.equalTo(24)
            make.width.equalTo(100)
        }
        
        return header
    }
    
    private func footerView() -> UIView {
        
        let text : String = "身份认证好处\n\n1.身份标识：彰显权威身份，让您的身份和内容更可信。\n2.优先展示：让您的账号和内容更快被发现。\n3.发布权限：认证企业/个人具备发布课程方案的权限，为您获取更多用户青睐和变现机会。\n4.优先推荐：认证企业/导师/员工推荐注册的用户，将优先推荐该认证企业/导师/员工的课程/方案/动态/美丽日记/美丽相册给该用户。\n\n身份认证条件\n\n企业认证条件：\n1.续存期内正规经营无法律风险的合规企业或机构。\n2.具备成熟的形体仪态行业课程体系。\n3.提供企业营业执照、运营者身份证正反面、运营者工作证明。\n\n个人认证条件：\n1.已认证企业的导师、员工。\n2.能向社区用户提供专业知识，无所属企业形体仪态行业的专业/权威人士。（若无所属企业，在申请认证选择所属认证企业时，请选择“全民形体平台”。）\n3.提供身份证正反面、职位/资质/称号证明。"
        
        let footer = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*672))
        let bgImageView = UIImageView.initWithName(imgName: "my_footbg")
        footer.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(16)
            make.right.equalTo(-10)
            make.height.equalTo((screenWid-20)/394*576)
        }
        
        let titleLabel = UILabel.initSomeThing(title: "认证说明", isBold: true, fontSize: 17, textAlignment: .center, titleColor: .init(hex: "#333333"))
        bgImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.width.equalTo(78)
            make.height.equalTo(24)
        }
        
        let leftImage = UIImageView.initWithName(imgName: "my_footleft")
        bgImageView.addSubview(leftImage)
        leftImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(titleLabel.snp.left).offset(-8)
            make.width.equalTo(37)
            make.height.equalTo(10)
        }
        
        let rightImage = UIImageView.initWithName(imgName: "my_footright")
        bgImageView.addSubview(rightImage)
        rightImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.width.equalTo(37)
            make.height.equalTo(10)
        }
        
        let textLabel = UILabel.initSomeThing(title: text, fontSize: 14, titleColor: .init(hex: "#666666"))
        textLabel.numberOfLines = 0
        bgImageView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        textLabel.sizeToFit()
        
        return footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension SSMyProveSelectViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 20))
        view.backgroundColor = .init(hex: "#F7F8F9")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 20))
        view.backgroundColor = .init(hex: "#F7F8F9")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.proveTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProveCell", for: indexPath) as! myProveCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.headImage.image = UIImage.init(named: proceImages[indexPath.row])
        cell.typeLabel.text = proveTypes[indexPath.row]
        cell.tipslabel.text = tips[indexPath.row]
        
        //        if indexPath.row == 0 {
        if self.proveModel?.type == 1 {
            if indexPath.row == 0 {
                if self.proveModel?.status == 1 {
                    cell.checkBtn.setTitle("审核中", for: .normal)
                } else if self.proveModel?.status == 2 {
                    cell.checkBtn.setTitle("审核通过", for: .normal)
                } else if self.proveModel?.status == 3 {
                    cell.checkBtn.setTitle("审核不通过", for: .normal)
                } else {
                    cell.checkBtn.setTitle("申请认证", for: .normal)
                    cell.checkBtn.isUserInteractionEnabled = false
                }
            } else {
                cell.checkBtn.isHidden = true
            }
            
        } else if self.proveModel?.type == 2 {
            if indexPath.row == 1 {
                if self.proveModel?.status == 1 {
                    cell.checkBtn.setTitle("审核中", for: .normal)
                } else if self.proveModel?.status == 2 {
                    cell.checkBtn.setTitle("审核通过", for: .normal)
                } else if self.proveModel?.status == 3 {
                    cell.checkBtn.setTitle("审核不通过", for: .normal)
                } else {
                    cell.checkBtn.setTitle("申请认证", for: .normal)
                }
            } else {
                cell.checkBtn.isHidden = true
            }
            
        } else {
            cell.checkBtn.setTitle("申请认证", for: .normal)
            
        }
        //}
        //        cell.checkBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
        //            if cell.index == 1 {
        //
        //                let vc = SSMyPersonalProveViewController()
        //                vc.type = 0
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            } else {
        //                self.navigationController?.pushViewController(SSMyCompanyProveViewController(), animated: true)
        //            }
        //        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let status = proveModel?.status else {
                #if DEBUG
                // 企业认证入口
                let vc = SSMyCompanyProveViewController()
                vc.cid = self.proveModel?.id ?? ""
                vc.type = 0
                HQPush(vc: vc, style: .default)
                #endif
                return
            }
            switch status {
            case 1:
                return
            case 2:
                let vc = SSProveSuccessController()
                vc.inType = 4
                vc.cid = self.proveModel?.id ?? ""
                vc.currentTitle = "我的企业认证"
                HQPush(vc: vc, style: .default)
            case 3:
                let vc = SSProveSuccessController()
                vc.inType = 2
                vc.cid = self.proveModel?.id ?? ""
                vc.currentTitle = "认证提交成功"
                vc.proveModel = self.proveModel
                HQPush(vc: vc, style: .default)
            default:
                // 企业认证入口
                let vc = SSMyCompanyProveViewController()
                vc.cid = self.proveModel?.id ?? ""
                vc.type = 0
                HQPush(vc: vc, style: .default)
            }
        case 1:
            guard let status = proveModel?.status else {
                #if DEBUG
                // 个人认证入口
                let vc = SSMyPersonalProveViewController()
                vc.type = 0
                HQPush(vc: vc, style: .default)
                #endif
                return
            }
            switch status {
            case 1:
                return
            case 2:
                let vc = SSProveSuccessController()
                vc.cid = self.proveModel?.id ?? ""
                vc.inType = 3
                vc.currentTitle = "个人认证通过"
                HQPush(vc: vc, style: .default)
            case 3:
                let vc = SSProveSuccessController()
                vc.cid = self.proveModel?.id ?? ""
                vc.inType = 2
                vc.proveModel = self.proveModel
                HQPush(vc: vc, style: .default)
            default:
                // 个人认证入口
                let vc = SSMyPersonalProveViewController()
                vc.type = 0
                HQPush(vc: vc, style: .default)
            }
        default:
            return
        }
    }
    
}

class myProveCell: UITableViewCell {
    
    let headImage = UIImageView.initWithName(imgName: "my_qyrz")
    let typeLabel = UILabel.initSomeThing(title: "企业认证", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let tipslabel = UILabel.initSomeThing(title: "认证", fontSize: 12, titleColor: .init(hex: "#666666"))
    let checkBtn = UIButton.init()
    var index = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI(){
        contentView.addSubview(headImage)
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(66)
        }
        
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(5)
            make.top.equalTo(12)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(tipslabel)
        tipslabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel)
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
            make.height.equalTo(17)
            make.width.equalTo(200)
        }
        
        contentView.addSubview(checkBtn)
        checkBtn.layer.masksToBounds = true
        checkBtn.layer.cornerRadius = 13
        checkBtn.backgroundColor = .init(hex: "#FD8024")
        checkBtn.titleLabel?.font = .systemFont(ofSize: 10)
        checkBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(71)
            make.height.equalTo(26)
        }
        
        checkBtn.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
