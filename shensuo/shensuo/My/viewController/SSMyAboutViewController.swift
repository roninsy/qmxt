//
//  SSMyAboutViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/16.
//

import UIKit

//关于我们
class SSMyAboutViewController: SSBaseViewController {

    var dataTitleArray = ["运营公司","客服热线","地址"]
    var dataArray = ["广东身所文化发展有限公司","400-9909335","广州市海珠区新港东路51号北岛创意园B区4栋"]
    
    
    
    var listTable:UITableView = {
        let table = UITableView.init()
        table.backgroundColor = UIColor.init(hex: "#F7F8F9")
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
        listTable.delegate = self
        listTable.dataSource = self
        listTable.tableHeaderView = self.headerView()
        listTable.tableFooterView = UIView.init()
        listTable.register(tableCell.self, forCellReuseIdentifier: "tableCell")
        
        // Do any additional setup after loading the view.
        navView.backBtnWithTitle(title: "关于我们")
        
        self.buildUI()
    }
    
    func buildUI() -> Void {
        self.view.addSubview(listTable)
        listTable.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func headerView() -> UIView {
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*283))
        header.backgroundColor = UIColor.white
        let headIcon:UIImageView = {
            let head = UIImageView.init()
            head.image = UIImage.init(named: "my_icon")
            return head
        }()
        
        header.addSubview(headIcon)
        headIcon.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        let nameImage:UIImageView = {
            let name = UIImageView.init()
            return name
        }()
        header.addSubview(nameImage)
        nameImage.snp.makeConstraints { (make) in
            make.top.equalTo(headIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        
        let khLabel:UILabel = {
            let kh = UILabel.init()
            kh.font = .systemFont(ofSize: 16)
            kh.textAlignment = .center
            kh.textColor = .init(hex: "#999999")
            kh.text = "立挺美好人生"
            return kh
        }()
        
        header.addSubview(khLabel)
        khLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameImage.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        
        let noteLabel:UILabel = {
            let notes = UILabel.init()
            notes.font  = .systemFont(ofSize: 16)
            notes.textColor = .init(hex: "#333333")
            notes.text = "      打造中国第一款具有社交属性人工智能变美的形体仪态的教学工具。致力于科学变美、健康变美、优雅变美等一站式变美智能解决方案。"
            notes.numberOfLines = 0
            return notes
        }()
        
        header.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(khLabel.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(74)
        }
        
        return header
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

class tableCell: UITableViewCell {
    
    var titleLabel:UILabel = {
        let title = UILabel.init()
        title.textAlignment = .left
        title.textColor = .init(hex: "#878889")
        title.font = .systemFont(ofSize: 16)
        return title
    }()
    
    var contentLabel:UILabel = {
        let content = UILabel.init()
        content.textAlignment = .right
        content.textColor = .init(hex: "#333333")
        content.font = .systemFont(ofSize: 16)
        return content
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.numberOfLines = 2
        contentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.left.equalTo(titleLabel.snp.right).offset(6)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SSMyAboutViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headV = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 20))
        headV.backgroundColor = UIColor.init(hex: "#F7F8F9")
        return headV
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTitleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        cell.titleLabel.text = dataTitleArray[indexPath.row]
        cell.contentLabel.text = dataArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

}
