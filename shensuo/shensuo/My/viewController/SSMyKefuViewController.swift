//
//  SSMyKefuViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/16.
//

import UIKit

class SSMyKefuViewController: SSBaseViewController {

    var dataArray = [["客服QQ：23428989"],["客服电话：400 990 6666"],["客服微信：46656545"]]
    
    
    var listTableView:UITableView = {
        let listTab = UITableView.init()
        return listTab
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ishideBar = true
        navView.backBtnWithTitle(title: "客服中心")
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(cellView.self, forCellReuseIdentifier: "cellView")
        listTableView.backgroundColor = .init(hex: "#F7F8F9")
        listTableView.tableFooterView = UIView.init()
        self.buildUI()
    }
    
    func buildUI() -> Void {
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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

extension SSMyKefuViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 12))
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellView", for: indexPath) as! cellView
        cell.updateLabel(labelText: dataArray[indexPath.section][indexPath.row])
        cell.copyBtn.reactive.controlEvents(.touchUpInside).observeValues { [self] (btn) in
            let pasteBoard = UIPasteboard.init()
            pasteBoard.string = dataArray[indexPath.section][indexPath.row].subString(from: 5)
            self.view.makeToast("复制成功")
        }
        return cell
    }
    
}

class cellView: UITableViewCell {
    
    var titleLabel:UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.textColor = .init(hex: "#333333")
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    var copyBtn:UIButton = {
        let copy = UIButton.init()
        copy.layer.masksToBounds = true
        copy.layer.cornerRadius = 2
        copy.layer.borderWidth = 0.5
        copy.layer.borderColor = UIColor.init(hex: "#999999").cgColor
        copy.setTitle("复制", for: .normal)
        copy.setTitleColor(.init(hex: "#666666"), for: .normal)
        copy.titleLabel?.font = .systemFont(ofSize: 12)
        return copy
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        contentView.addSubview(copyBtn)
        copyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.width.equalTo(32)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateLabel(labelText: String){
        titleLabel.text = labelText
        titleLabel.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
