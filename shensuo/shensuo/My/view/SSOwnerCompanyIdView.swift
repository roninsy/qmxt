//
//  SSOwnerCompanyIdView.swift
//  shensuo
//
//  Created by  yang on 2021/7/8.
//

import UIKit

class SSOwnerCompanyIdView: UIView, UITableViewDataSource ,UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSOwnerCompanyIdCell.self)) as! SSOwnerCompanyIdCell
        cell.model = listArray?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath) as! SSOwnerCompanyIdCell
        if selectCell != nil && selectCell == cell {
            
            return;
        }
        if selectCell != nil {
            
            selectCell?.isSelected = false
        }
        cell.isSelected = true
//        model. = true
        selectCell = cell
        selectIndex = indexPath.row
    }
    
    var listArray: [SSCompanyIdModel]? = nil {
        
        didSet {
            
            if listArray != nil {
                
                self.tableView.reloadData()
            }
        }
    }
    
    var bgV = UIView()
    var tableView: UITableView!
    var searchBgV = UIView()
    var searchTf: UITextField!
    let searchBtn = UIButton.initTitle(title: "搜索", fontSize: 16, titleColor: color33)
    let sureBtn = UIButton.initTitle(title: "确定", fontSize: 16, titleColor: color33)
    var selectCell: SSOwnerCompanyIdCell?
    var selectIndex: Int?
    var sureBlock: intBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgV)
        bgV.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo((screenHei - 312/(screenWid - 32) * 512)/2)
            make.height.equalTo(312/(screenWid - 32) * 512)
        }
        bgV.layer.cornerRadius = 10
        bgV.layer.masksToBounds = true
        let titleL = UILabel.initSomeThing(title: "选择所属认证企业", fontSize: 20, titleColor: color33)
        titleL.font = .MediumFont(size: 20)
        bgV.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(33)
        }
        
        bgV.backgroundColor = .white
        
        bgV.addSubview(searchBtn)
        searchBtn.titleLabel?.font = .MediumFont(size: 16)
        searchBtn.snp.makeConstraints { make in
            
            make.trailing.equalTo(-16)
            make.top.equalTo(titleL.snp.bottom).offset(40)
            make.width.equalTo(40)
        }
        
        bgV.addSubview(searchBgV)
        searchBgV.layer.cornerRadius = 16
        searchBgV.layer.masksToBounds = true
        searchBgV.backgroundColor = .hex(hexString: "#EEEFF1")
        searchBgV.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.trailing.equalTo(searchBtn.snp.leading).offset(-16)
            make.height.equalTo(32)
            make.centerY.equalTo(searchBtn)
            
        }
        
        let searchIcon = UIImageView.initWithName(imgName: "searchicon")
        searchBgV.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            
            make.width.height.equalTo(16)
            make.leading.equalTo(16)
            make.centerY.equalTo(searchBtn)
        }
        
        searchTf = UITextField.init()
        searchTf.borderStyle = .none
        searchBgV.addSubview(searchTf)
        searchTf.snp.makeConstraints { make in
            
            make.leading.equalTo(searchIcon.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(-5)
        }
    
        let bottomV = UIView()
        bgV.addSubview(bottomV)
        bottomV.snp.makeConstraints { make in
            
            make.bottom.trailing.leading.equalToSuperview()
            make.height.equalTo( 57)
        }
        
        let linV = UIView.init()
        linV.backgroundColor = bgColor
        bottomV.addSubview(linV)
        linV.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        bottomV.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(linV.snp.bottom)
        }
        sureBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            
            self?.sureBlock?(self?.selectIndex ?? 0)
        })
        
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        bgV.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.rowHeight = 56
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomV.snp.top)
            make.top.equalTo(searchBgV.snp.bottom).offset(16)
        }
        tableView.register(SSOwnerCompanyIdCell.self, forCellReuseIdentifier: String(describing: SSOwnerCompanyIdCell.self))
            

}
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SSOwnerCompanyIdCell: UITableViewCell {
    
    var model : SSCompanyIdModel? = nil {
        
        didSet {
            
            if model != nil {
                
                nameL.text = model?.companyName
                
            }
        }
    }
    
    var iconV = UIImageView.initWithName(imgName: "my_btnSelect")
    
    var nameL = UILabel.initSomeThing(title: "五大没好大的", fontSize: 16, titleColor: color33)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconV)
        
        
        let linV = UIView.init()
        linV.backgroundColor = bgColor
        addSubview(linV)
        iconV.snp.makeConstraints { make in
            
            make.width.height.equalTo(19)
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        
        linV.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        contentView.addSubview(nameL)
        nameL.numberOfLines = 1
        nameL.snp.makeConstraints { make in
            
            make.leading.equalTo(iconV.snp.trailing).offset(3)
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            
            iconV.image = UIImage.init(named: "my_btnSelect")
        }else{
            
            iconV.image = UIImage.init(named: "my_btnNormal")
        }
        // Configure the view for the selected state
    }
    
}
