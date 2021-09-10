//
//  SSMyCashOutViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/17.
//

import UIKit
import SCLAlertView

//提现
class SSMyCashOutViewController: SSBaseViewController {

    var mainTableView = UITableView.init()
    var selImage:String = "bt_wx"
    var selTitle:String = "微信"
    
    var balance : Double = 0.0
    
    var outMoney : Double = 0.0
    var value : UITextField!
    var crash = UILabel.init()
    var checkBtn = UIButton.init()
    let noteLabel = UILabel.initWordSpace(title: " 1、提现金额每次最少30元，最多5000元。提现服务费为提现金额2%。\n2、提现申请提交成功之后，到账时间请以银行处理时间为准。\n3、同一时间只能发起一笔提现，此笔提现到账后方可发起下一笔。", titleColor: .init(hex: "#666666"), font: .RegularFont(size: 14), ali: .left, space: 0)
    
    var minNum : Double = 0
    
    var maxNum : Double = 0
    
    var model : SelectStringModel? = nil{
        didSet{
            self.minNum = model?.withdrawMin?.doubleValue ?? 30
            self.maxNum = model?.withdrawMax?.doubleValue ?? 5000
            noteLabel.text = " 1、提现金额每次最少\(minNum)元，最多\(maxNum)元。提现服务费为提现金额\(model?.withdrawRate?.doubleValue ?? 2)%。\n2、提现申请提交成功之后，到账时间请以银行处理时间为准。\n3、同一时间只能发起一笔提现，此笔提现到账后方可发起下一笔。"
            self.value.placeholder = "请输入\(minNum)-\(maxNum)之间的金额"
            noteLabel.changeLineSpace(space: 13)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
        navView.backWithTitleOptionBtn(title: "提现", option: "提现记录")
        navView.optionBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.pushViewController(SSMyCashOutListViewController(), animated: true)
        }
        mainTableView.frame = CGRect(x: 0, y: NavBarHeight, width: screenWid, height: screenHei-NavBarHeight)
        mainTableView.backgroundColor = .init(hex: "#F7F8F9")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.tableFooterView = self.tableFooterView()
        self.view.addSubview(mainTableView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSeting()
    }
    
    
    func tableFooterView() -> UIView {
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 380))
        footerView.isUserInteractionEnabled = true
        
        let titleLabal = UILabel.initWordSpace(title: "---------温馨提示---------", titleColor: .init(hex: "#666666"), font: .RegularFont(size: 16), ali: .center, space: 0)
        titleLabal.changeLineSpace(space: 16)
        titleLabal.textAlignment = .center
        footerView.addSubview(titleLabal)
        titleLabal.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
        
        
        noteLabel.numberOfLines = 0
        footerView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(titleLabal.snp.bottom)
            make.height.equalTo(200)
        }
        
        checkBtn = UIButton.init(frame: CGRect(x: 10, y: 0, width: screenWid-20, height: 45))
        checkBtn.setTitle("提现", for: .normal)
        checkBtn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
        checkBtn.backgroundColor = .init(hex: "#FD8024")
        checkBtn.layer.masksToBounds = true
        checkBtn.layer.cornerRadius = 20
        footerView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(45)
            make.top.equalTo(noteLabel.snp.bottom).offset(30)
        }
        
        checkBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.value.resignFirstResponder()
            self.doOutMoneyOption()
        }
        return footerView
    }
    
    @objc func popVc() -> Void {
        self.navigationController?.popViewController(animated: true)
    }

    func doOutMoneyOption() -> Void {
        if self.outMoney < minNum || self.outMoney > maxNum{
            self.view.makeToast("请输入\(minNum)-\(maxNum)之间提现金额！")
            return
        }
        if self.outMoney > UserInfo.getSharedInstance().balance {
            self.view.makeToast("当前余额：\(UserInfo.getSharedInstance().balance)元")
            return
        }
        
        UserInfoNetworkProvider.request(.doWithdraw(categoryId: 1, code: "WEIXIN", money: String.init(format: "%.2f", self.outMoney), name: "微信")) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                self.view.makeToast(model?.message ?? "申请提现成功")
                            }else{
                                self.view.makeToast(model?.message ?? "申请提现失败")
                                if model?.code == 3005 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.wechatAuth()
                                    }
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
    
    ///发起微信授权
    func wechatAuth(){
        ///判断是否安装微信
        if !WXApi.isWXAppInstalled() {
            SCLAlertView().showError("温馨提示", subTitle: "您的手机未安装微信APP，请前往苹果应用商店下载后分享")
            return
        }
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "shensuokeji"
        WXApi.send(req, completion: nil)
    }
    
    ///查找系统参数接口
    func getSeting(){
        NetworkProvider.request(.selectString) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            self.model = dic?.kj.model(type: SelectStringModel.self) as? SelectStringModel
                        }
                    }
                }catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSMyCashOutViewController:UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("----------%@-------", textField.text ?? "")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        outMoney = textField.text?.toDouble ?? 0
//        if outMoney > 5000 {
//            self.crash.text = String("提现金额超过5000")
//            checkBtn.isEnabled = false
//            
//        } else {
//            checkBtn.isEnabled = true
//            self.crash.text = String(format: "提现服务费%.02f", outMoney*0.02)
//        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 68
        } else {
            return 198
        }
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.backgroundColor = .init(hex: "#F7F8F9")
        if indexPath.section == 0 {
            
            let cellView = UIView.init()
            cellView.backgroundColor = .white
            cellView.layer.masksToBounds = true
            cellView.layer.cornerRadius = 5
            cell.contentView.addSubview(cellView)
            cellView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
            }
            
            let titleLabel = UILabel.initSomeThing(title: "提现方式", isBold: true, fontSize: 17, textAlignment: .left, titleColor: .init(hex: "#333333"))
            cellView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(10)
                make.centerY.equalToSuperview()
                make.width.equalTo(200)
                make.height.equalTo(24)
            }
           
            let selectLabel = UILabel.initSomeThing(title: selTitle, fontSize: 16, titleColor: .init(hex: "#333333"))
            cellView.addSubview(selectLabel)
            selectLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel)
                make.right.equalTo(-10)
                make.height.equalTo(22)
                make.width.equalTo(50)
            }
            
            let imageView = UIImageView.initWithName(imgName: selImage)
            cellView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel)
                make.right.equalTo(selectLabel.snp.left)
                make.width.height.equalTo(24)
            }
            
        } else {
            let cellView = UIView.init()
            cellView.backgroundColor = .white
            cellView.layer.masksToBounds = true
            cellView.layer.cornerRadius = 5
            cell.contentView.addSubview(cellView)
            cellView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
            }
            
            let titleLabel = UILabel.initSomeThing(title: "提现金额", isBold: true, fontSize: 17, textAlignment: .left, titleColor: .init(hex: "#333333"))
            cellView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(10)
                make.height.equalTo(24)
            }
            
            let type = UILabel.initSomeThing(title: "¥", isBold: true, fontSize: 28, textAlignment: .left, titleColor: .init(hex: "#333333"))
            cellView.addSubview(type)
            type.snp.makeConstraints { (make) in
                make.left.equalTo(10)
                make.top.equalTo(84)
                make.width.equalTo(21)
                make.height.equalTo(40)
            }
            
            self.value = UITextField.init()
            self.value.font = .systemFont(ofSize: 16)
            self.value.textColor = .init(hex: "#999999")
            self.value.delegate = self
            self.value.keyboardType = .numberPad
            cellView.addSubview(self.value)
            self.value.snp.makeConstraints { (make) in
                make.left.equalTo(type.snp.right).offset(10)
                make.centerY.equalTo(type)
                make.height.equalTo(22)
                make.width.equalTo(250)
            }
            
            let allBtn = UIButton.initTitle(title: "全部", fontSize: 16, titleColor: .init(hex: "#FD8024"))
            cellView.addSubview(allBtn)
            allBtn.snp.makeConstraints { (make) in
                make.right.equalTo(-10)
                make.centerY.equalTo(value)
                make.height.equalTo(22)
                make.width.equalTo(40)
            }
            allBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
                self.value.text = String(UserInfo.getSharedInstance().balance)
                self.outMoney = UserInfo.getSharedInstance().balance
            }
            
            let line = UIView.init()
            line.backgroundColor = .init(hex: "#F7F8F9")
            cellView.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(type.snp.bottom).offset(11)
                make.height.equalTo(1)
            }
            
            crash = UILabel.initSomeThing(title: "提现服务费", fontSize: 14, titleColor: .init(hex: "#666666"))
            cellView.addSubview(crash)
            crash.snp.makeConstraints { (make) in
                make.left.equalTo(type)
                make.top.equalTo(line.snp.bottom).offset(16)
                make.height.equalTo(20)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
    }
    
}


