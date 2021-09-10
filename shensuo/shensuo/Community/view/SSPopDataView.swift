//
//  SSPopDataView.swift
//  shensuo
//
//  Created by  yang on 2021/5/24.
//

import UIKit

class SSPopDataView: UIView, UITableViewDelegate, UITableViewDataSource {
   

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var dataTableView = UITableView.init()
    var dayDataModel:SSVideoModel? = nil
    
    var dataTitle:NSArray = ["身高","体重","腰围","BMI","BMI","体脂率","体脂率"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 0.29).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        dataTableView.frame = CGRect(x: 4, y: 10, width: screenWid-28, height: 420)
        dataTableView.delegate = self
        dataTableView.dataSource = self
        dataTableView.register(listDataCell.self, forCellReuseIdentifier: "listDataCell")
        self.addSubview(dataTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listDataCell", for: indexPath) as! listDataCell
        cell.titleLabel.text = self.dataTitle[indexPath.row] as? String
        cell.selectionStyle = .none
        switch indexPath.row {
            case 0:
                cell.valueLabel.text = self.dayDataModel?.height?.appending("CM")
                break
            case 1:
                cell.valueLabel.text = self.dayDataModel?.weight?.appending("KG")
                break
            case 2:
                cell.valueLabel.text = self.dayDataModel?.girth?.appending("CM")
                break
            case 3:
                cell.valueLabel.text = self.dayDataModel?.bmi
                break
            case 4:
                cell.valueLabel.isHidden = true
                cell.tipImage.isHidden = false
                let bmi:Float = self.dayDataModel?.bmi?.toFloat ?? 0
                if bmi <= 18.4 {
                    cell.tipImage.image = UIImage.init(named: "bt_pianshou")
                } else if (bmi > 18.4 && bmi <= 23.9) {
                    cell.tipImage.image = UIImage.init(named: "bt_zhengchang")
                } else if (bmi > 23.9 && bmi <= 27.9) {
                    cell.tipImage.image = UIImage.init(named: "bt_guozhong")
                } else {
                    cell.tipImage.image = UIImage.init(named: "bt_feipang")
                }
                    
                break
            case 5:
                cell.valueLabel.text = self.dayDataModel?.bodyFat
                break
            case 6:
                cell.valueLabel.isHidden = true
                cell.tipImage.isHidden = false
                let bodyFat:Float = self.dayDataModel?.bodyFat?.toFloat ?? 0
                if bodyFat <= 10 {
                    cell.tipImage.image = UIImage.init(named: "bt_pianshou")
                } else if (bodyFat > 10 && bodyFat <= 21) {
                    cell.tipImage.image = UIImage.init(named: "bt_zhengchang")
                } else if (bodyFat > 21 && bodyFat <= 26) {
                    cell.tipImage.image = UIImage.init(named: "bt_guozhong")
                } else {
                    cell.tipImage.image = UIImage.init(named: "bt_feipang")
                }
                break
            default:
                break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class listDataCell: UITableViewCell {
    
    var titleLabel = UILabel.initSomeThing(title: "身高", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .left)
    var valueLabel = UITextField.init()
    var tipImage = UIImageView.init()
    
    
//    var valueLabel = UILabel.initSomeThing(title: "168CM", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .right)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.textAlignment = .right
        valueLabel.textColor = .init(hex: "#333333")
        valueLabel.font = .MediumFont(size: 16)
//        valueLabel.isEnabled = false
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(80)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(tipImage)
        tipImage.isHidden = true
        tipImage.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(135)
            make.height.equalTo(26)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
