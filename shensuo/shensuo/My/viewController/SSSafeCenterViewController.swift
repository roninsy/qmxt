//
//  SSSafeCenterViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/15.
//

import UIKit

class SSSafeCenterViewController: SSBaseViewController {

    
    
    var passView : ForgetPassView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.ishideBar = true
        
        let mainTableView = UITableView.init(frame: CGRect(x: 0, y: NavBarHeight, width: screenWid, height: screenHei-NavBarHeight), style: .plain)
        mainTableView.backgroundColor = .init(hex: "#F7F8F9")
        mainTableView.separatorStyle = .none
        mainTableView.tableHeaderView = self.headView()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.view.addSubview(mainTableView)
        navView.backBtnWithTitle(title: "安全中心")
        // Do any additional setup after loading the view.
    }
    
    func headView() -> UIView {
        let head = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 12))
        head.backgroundColor = .init(hex: "#F7F8F9")
        return head
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

extension SSSafeCenterViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        let title = UILabel.initSomeThing(title: "忘记密码", fontSize: 16, titleColor: .init(hex: "#333333"))
        title.frame = CGRect(x: 10, y: 17, width: 100, height: 22)
        cell.contentView.addSubview(title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(SSForgetPwdViewController(), animated: true)
        passView = ForgetPassView()
        self.view.addSubview(passView)
        passView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
    
        }
        
        passView.enterBlock = { [weak self] in
            self!.view.endEditing(true)
            self?.passView.input.removeFromSuperview()
            self!.passView.isHidden = true
            self?.passView.removeFromSuperview()
            self?.passView = nil
            self?.tabBarController?.selectedIndex = 0
//                        HQGetTopVC()?.view.makeToast("重置成功，请登录")
                    }
    }
    
}
