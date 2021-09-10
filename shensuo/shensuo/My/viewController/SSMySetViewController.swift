//
//  SSMySetViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/16.
//

import UIKit

//设置页面
class SSMySetViewController: SSBaseViewController {

    var dataArray = [["客服中心","黑名单","用户反馈"],["用户协议","隐私政策","关于我们"]]
    
    
    var listTableView:UITableView = {
        let table = UITableView.init()
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ishideBar = true
        self.view.backgroundColor = .white //UIColor.init(hex: "#F7F8F9")
        self.layoutSubViews()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        listTableView.register(setCell.self, forCellReuseIdentifier: "setCell")
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = UIColor.init(hex: "#F7F8F9")
        listTableView.tableFooterView = self.footView()
        
    }
    
    func layoutSubViews() -> Void {
        self.view.addSubview(navView)
        navView.backBtnWithTitle(title: "设置")
        
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(screenHei-NavContentHeight)
        }
    }
    
    func footView() -> UIView {
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 200))
        footView.backgroundColor = .init(hex: "#F7F8F9")
        
        let logoutBtn = UIButton.init(frame: CGRect(x: 10, y: 60, width: screenWid-20, height: 45))
        logoutBtn.layer.masksToBounds = true
        logoutBtn.layer.cornerRadius = 23
        logoutBtn.backgroundColor = UIColor.init(hex: "#FFFFFF")
        logoutBtn.setTitle("注销账号", for: .normal)
        logoutBtn.titleLabel?.font = .systemFont(ofSize: 18)
        logoutBtn.setTitleColor(UIColor.init(hex: "#FD8024"), for: .normal)
        footView.addSubview(logoutBtn)
        
        logoutBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            HQPushToRootIndex(index: 0)
            PushToLogin()
        }
        
        return footView
    }


}

extension SSMySetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as! setCell
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = dataArray[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        if cell.titleLabel.text == "检测更新" {
            cell.versionLabel.isHidden = false
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            cell.versionLabel.text = "V"+appVersion
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 20))
        view.backgroundColor = UIColor.init(hex: "#F7F8F9")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
                case 0:
                    self.navigationController?.pushViewController(SSMyKefuViewController(), animated: true)
                    break
                case 1:
                    let listVc = SSFocusListViewController()
                    listVc.type = .BlackList
                    self.navigationController?.pushViewController(listVc, animated: true)
                    break
                case 2:
                    self.navigationController?.pushViewController(SSMyFeedbackViewController(), animated: true)
                    break
                default:
                    self.navigationController?.pushViewController(SSMyAboutViewController(), animated: true)
            }
        } else {
            if indexPath.row == 0 {
                let vc = HQWebVC()
                vc.titleLab.text = "全民形体用户协议"
                vc.url = privacyPolicyURL
                HQPush(vc: vc, style: .default)
            } else if indexPath.row == 1 {
                let vc = HQWebVC()
                vc.titleLab.text = "隐私协议"
                vc.url = userAgreementURL
                HQPush(vc: vc, style: .default)
            } else if indexPath.row == 2 {
                self.navigationController?.pushViewController(SSMyAboutViewController(), animated: true)
            }
            
        }
    }
    
}

class setCell: UITableViewCell {
    
    var titleLabel:UILabel = {
        let title = UILabel.init()
        title.font = .systemFont(ofSize: 16)
        title.textAlignment = .left
        title.textColor = UIColor.init(hex: "#333333")
        return title
    }()
    
    
    var versionLabel:UILabel = {
        let vLabel = UILabel.init()
        vLabel.font = .systemFont(ofSize: 16)
        vLabel.textAlignment = .right
        vLabel.textColor = UIColor.init(hex: "#878889")
        return vLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildSubviews()
    }
    
    func buildSubviews() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.isHidden = true
        versionLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-6)
            make.width.equalTo(60)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
