//
//  ExchangeSelView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/12.
//

import UIKit
import MBProgressHUD

class ExchangeSelView: UIView,UITableViewDelegate,UITableViewDataSource {
    let noSelBtn = UIButton.initTitle(title: "暂不使用劵", fontSize: 16, titleColor: .init(hex: "#333333"))
    var selBlock:intBlock? = nil
    let listView = UITableView()
    let headView = UILabel.initSomeThing(title: "选择劵", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 20), ali: .center)
    var exchangeModels : NSArray = NSArray()
    var selIndex = 0
    
    var needBG = false{
        didSet{
            if needBG {
                self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//
        headView.frame = .init(x: 0, y: 0, width: screenWid, height: 88)
        listView.backgroundColor = .white
        listView.layer.cornerRadius = 12
        listView.layer.masksToBounds = true
        listView.separatorStyle = .none
        listView.delegate = self
        listView.dataSource = self
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.width.equalTo(354)
            make.centerX.equalToSuperview()
            make.height.equalTo(447)
            make.centerY.equalToSuperview()
        }
        noSelBtn.frame = .init(x: 0, y: 0, width: screenWid, height: 55)
        listView.tableFooterView = noSelBtn
        noSelBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.selBlock?(999)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ExchangeSelCell? = tableView.dequeueReusableCell(withIdentifier: "ExchangeSelCell") as? ExchangeSelCell
        if cell == nil {
            cell = ExchangeSelCell.init(style: .default, reuseIdentifier: "ExchangeSelCell")
        }
        let arr : [SSExchangeModel] = exchangeModels[indexPath.row] as! [SSExchangeModel]
        cell?.model = arr
        cell?.topLine.isHidden = indexPath.row == 0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var flag = false
        let model : [SSExchangeModel] = exchangeModels[indexPath.row] as! [SSExchangeModel]
        for model2 in model {
            if model2.used {
                flag = true
            }
        }
        if flag {
            self.selBlock?(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 88
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isHidden = true
//        self.removeFromSuperview()
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selBlock?(999)
    }
}


class ExchangeSelCell: UITableViewCell {
    
    let nameLab = UILabel.initSomeThing(title: "", fontSize: 16, titleColor: .init(hex: "#333333"))
    let topLine = UIView()
    
    var model : [SSExchangeModel]? = nil{
        didSet{
            if model != nil && model!.count > 0{
                var flag = false
                for model2 in model! {
                    if model2.used {
                        flag = true
                    }
                }
                self.nameLab.textColor = flag ? .init(hex: "#333333") : .init(hex: "#CBCCCD")
                self.nameLab.text = String.init(format: "%@(%d张)", model![0].name ?? "",model!.count)
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        nameLab.textAlignment = .center
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
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
