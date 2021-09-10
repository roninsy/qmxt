//
//  SelPayTypeView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/13.
//

import UIKit

import MBProgressHUD

class SelPayTypeView: UIView,UITableViewDelegate,UITableViewDataSource {
    var selBlock:intBlock? = nil
    let listView = UITableView()
    let headView = UILabel.initSomeThing(title: "选择支付方式", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 20), ali: .center)
    var dicArr = ["微信支付","支付宝支付"]
    var selIndex = 0{
        didSet{
            self.listView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        headView.frame = .init(x: 0, y: 0, width: 354, height: 88)
        listView.tableHeaderView = headView
        listView.backgroundColor = .white
        listView.layer.cornerRadius = 12
        listView.layer.masksToBounds = true
        listView.separatorStyle = .none
        listView.delegate = self
        listView.dataSource = self
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.width.equalTo(352)
            make.centerX.equalToSuperview()
            make.height.equalTo(447)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dicArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : PayTypeSelCell? = tableView.dequeueReusableCell(withIdentifier: "PayTypeSelCell") as? PayTypeSelCell
        if cell == nil {
            cell = PayTypeSelCell.init(style: .default, reuseIdentifier: "PayTypeSelCell")
        }
        cell?.name = dicArr[indexPath.row]
        cell?.sel = indexPath.row == self.selIndex
        cell?.topLine.isHidden = indexPath.row == 0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selBlock?(indexPath.row)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHidden = true
        self.removeFromSuperview()
    }
}


class PayTypeSelCell: UITableViewCell {
    let selImg = UIImageView.initWithName(imgName: "login_disagree")
    let nameLab = UILabel.initSomeThing(title: "", fontSize: 16, titleColor: .init(hex: "#333333"))
    let topLine = UIView()
    var sel : Bool = false{
        didSet{
            selImg.image = sel ? UIImage.init(named: "login_agree") :  UIImage.init(named: "login_disagree")
        }
    }
    var name : String? = nil{
        didSet{
            if name != nil {
                self.nameLab.text = name
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.addSubview(selImg)
        selImg.snp.makeConstraints { make in
            make.width.height.equalTo(19)
            make.left.equalTo(24)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        topLine.backgroundColor = .init(hex: "#EEEFF0")
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.top.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
