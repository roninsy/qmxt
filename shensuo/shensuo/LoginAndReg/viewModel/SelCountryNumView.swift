//
//  SelCountryNumView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/10.
//

///区号选择
import UIKit
import MBProgressHUD


class SelCountryNumView: UIView,UITableViewDelegate,UITableViewDataSource {
    var selBlock:intBlock? = nil
    let listView = UITableView()
    let headView = UILabel.initSomeThing(title: "国家地区", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 20), ali: .center)
    var dicArr : [NSDictionary] = NSArray() as! [NSDictionary]{
        didSet{
            self.listView.snp.updateConstraints { make in
                make.height.equalTo(88 + 56 * dicArr.count + 22)
            }
            self.listView.reloadData()
        }
    }
    var selIndex = 0
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
            make.width.equalTo(354)
            make.centerX.equalToSuperview()
            make.height.equalTo(332)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNumListInfo() {
        
        UserNetworkProvider.request(.areaCode) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            self.dicArr = model?.data as? [NSDictionary] ?? []
                        }
                    }
                } catch {

                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dicArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CountryNumCell? = tableView.dequeueReusableCell(withIdentifier: "CountryNumCell") as? CountryNumCell
        if cell == nil {
            cell = CountryNumCell.init(style: .default, reuseIdentifier: "CountryNumCell")
        }
        cell?.model = dicArr[indexPath.row]
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


class CountryNumCell: UITableViewCell {
    let selImg = UIImageView.initWithName(imgName: "login_disagree")
    let nameLab = UILabel.initSomeThing(title: "", fontSize: 16, titleColor: .init(hex: "#333333"))
    let topLine = UIView()
    var sel : Bool = false{
        didSet{
            selImg.image = sel ? UIImage.init(named: "login_agree") :  UIImage.init(named: "login_disagree")
        }
    }
    var model : NSDictionary? = nil{
        didSet{
            if model != nil {
                self.nameLab.text = String.init(format: "%@(+%@)", model!["name"] as? String ?? "",model!["code"] as? String ?? "")
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
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
