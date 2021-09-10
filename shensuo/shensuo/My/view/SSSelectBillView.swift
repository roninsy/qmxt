//
//  SSSelectBillView.swift
//  shensuo
//
//  Created by  yang on 2021/5/13.
//

import UIKit

enum popType {
    case outMoney
    case msg
    case account
    case intive
    case xtb
}

class SSSelectBillView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var clickOKBlock:((String, String, String)->())?
    
    var clickModel:SSBillSelectModel? = nil
    
    
    var selectModels : [SSBillSelectModel]? = nil {
        didSet{
            if selectModels != nil {
                dataCollectionView.reloadData()
            }
        }
    }
    
    
    var dataCollectionView:UICollectionView!
    let botView = UIView.init()
    let resetButton = UIButton.initTitle(title: "重置", fontSize: 18, titleColor: .init(hex: "#333333"))
    let okButton = UIButton.initTitle(title: "确定", fontSize: 18, titleColor: .init(hex: "#FFFFFF"))
    
    let closeBtn = UIButton.init()
    let titleLabel = UILabel.initSomeThing(title: "筛选条件", isBold: true, fontSize: 18, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    var startDate:String = ""
    var endDate:String = ""
    var type:popType = .msg
    
    var outTypeArray:Array  = ["全部","待审核","审核不通过","审核通过"]
    var outType:String = ""
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
             
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screenWid/2-30, height: 45)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        layout.scrollDirection = .vertical
        dataCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 120, width: screenWid, height: screenHei-220), collectionViewLayout: layout)
        dataCollectionView.backgroundColor = .white
        dataCollectionView.register(selectBillCell.self, forCellWithReuseIdentifier: "selectBillCell")
        dataCollectionView.register(selectHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "selectHeaderReusableView")
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        self.addSubview(dataCollectionView)
//        dataCollectionView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(100)
//            make.bottom.equalTo(botView.snp.top)
//        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-01"
        startDate = formatter.string(from: Date())
        self.endDate = NSDate.nowDateString()
        
        self.buildUI()
        
    }
    
    func loadTypeDate(type:popType) -> Void {
        if type == .msg {
            self.loadData()
        } else if type == .account {
            self.loadAccountData()
        } else {
            self.loadData()
        }
    }
    
    func resetData() -> Void {
        if self.type == .msg || self.type == .account || self.type == .xtb{
            for index in 0...self.selectModels!.count-1 {
                self.selectModels![index].bSelect = false
            }
            self.dataCollectionView.reloadData()
        } else {
            
        }
        
    }
    
    func loadAccountData() -> Void {
        UserInfoNetworkProvider.request(.getAccountCategory) { (result) in
            switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                let arr = model?.data
                                if arr == nil {
                                    return
                                }
                                
                                self.selectModels = arr?.kj.modelArray(type: SSBillSelectModel.self) as? [SSBillSelectModel]
                                
                            }else{
                                
                            }
                            
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func loadData() -> Void {
        if type == .xtb {
            UserInfoNetworkProvider.request(.getXingtibeiCategory) { (result) in
                switch result{
                    case let .success(moyaResponse):
                        do {
                            let code = moyaResponse.statusCode
                            if code == 200{
                                let json = try moyaResponse.mapString()
                                let model = json.kj.model(ResultArrModel.self)
                                if model?.code == 0 {
                                    let arr = model?.data
                                    if arr == nil {
                                        return
                                    }
                                    self.selectModels = arr?.kj.modelArray(type: SSBillSelectModel.self) as? [SSBillSelectModel]
                                }
                            }
                            
                        } catch {
                            
                        }
                    case let .failure(error):
                        logger.error("error-----",error)
                    }
            }
        }else{
            UserInfoNetworkProvider.request(.getCategory) { (result) in
                switch result{
                    case let .success(moyaResponse):
                        do {
                            let code = moyaResponse.statusCode
                            if code == 200{
                                let json = try moyaResponse.mapString()
                                let model = json.kj.model(ResultArrModel.self)
                                if model?.code == 0 {
                                    let arr = model?.data
                                    if arr == nil {
                                        return
                                    }
                                    
                                    self.selectModels = arr?.kj.modelArray(type: SSBillSelectModel.self) as? [SSBillSelectModel]
                                    
                                }else{
                                    
                                }
                                
                            }
                            
                        } catch {
                            
                        }
                    case let .failure(error):
                        logger.error("error-----",error)
                    }
            }
        }
        
    }
    
    func buildUI() -> Void {

        self.addSubview(closeBtn)
        closeBtn.setImage(UIImage.init(named: "bt_close"), for: .normal)
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(NavBarHeight)
            make.width.height.equalTo(24)
        }
        
        closeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.isHidden = true
            self.removeFromSuperview()
        }

        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBtn)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        self.addSubview(botView)
        botView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        botView.addSubview(resetButton)
        resetButton.layer.masksToBounds = true
        resetButton.layer.cornerRadius = 20
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        resetButton.setTitleColor(.init(hex: "#333333"), for: .normal)
        resetButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.height.equalTo(45)
            make.width.equalTo(screenWid/2-30)
        }
        
        resetButton.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.resetData()
        }
        
        botView.addSubview(okButton)
        okButton.backgroundColor = .init(hex: "#FD8024")
        okButton.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
        okButton.layer.masksToBounds = true
        okButton.layer.cornerRadius = 20
        okButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.height.equalTo(45)
            make.width.equalTo(screenWid/2-30)
        }
        
        okButton.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            
            if self.type == .msg || self.type == .account || self.type == .xtb {
                if self.clickOKBlock != nil {
                    self.clickOKBlock!(self.startDate,self.endDate,self.clickModel?.id ?? "")
                }
            } else {
                self.clickOKBlock!(self.startDate,self.endDate,self.outType)
            }
            
            
            self.isHidden = true
            self.removeFromSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SSSelectBillView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.type == .intive {
            return 0
        }
        if self.type == .msg || self.type == .account || self.type == .xtb {
            return self.selectModels?.count ?? 0
        } else {
            return self.outTypeArray.count
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectBillCell", for: indexPath) as! selectBillCell
        
        if self.type == .msg || self.type == .account || self.type == .xtb {
            let model = (self.selectModels?[indexPath.row])! as SSBillSelectModel
            cell.typeLabel.text = model.name
            cell.billSelect(isSe: model.bSelect)
        } else {
            cell.typeLabel.text = self.outTypeArray[indexPath.row]
            cell.bSelect = false
            cell.billSelect(isSe: cell.bSelect)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! selectBillCell
        if self.type == .msg || self.type == .account || self.type == .xtb {
            self.clickModel = (self.selectModels?[indexPath.row])! as SSBillSelectModel
            for index in 0...self.selectModels!.count-1 {
                if self.selectModels![index].name == self.clickModel!.name {
                    self.selectModels![index].bSelect = !self.selectModels![index].bSelect
                } else {
                    self.selectModels![index].bSelect = false
                }

            }
            self.clickModel!.bSelect = !self.clickModel!.bSelect
            
            cell.billSelect(isSe: self.clickModel!.bSelect)
        } else {
            if cell.bSelect {
                
            }
            cell.bSelect = !cell.bSelect
            cell.billSelect(isSe: cell.bSelect)
            self.outType = self.outTypeArray[indexPath.row]
            
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWid, height: 180)
        }
        return CGSize(width: screenWid, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "selectHeaderReusableView", for: indexPath) as! selectHeaderReusableView
        view.type.isHidden = self.type == .intive
        view.startTimeBlock = {startTime in
            self.startDate = startTime
        }
        
        view.endTimeBlock = {endTime in
            self.endDate = endTime
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            return view
        }
        return UICollectionReusableView.init()
    }
}

class selectBillCell: UICollectionViewCell {
    
    var bSelect:Bool = false
    
    var typeLabel = UILabel.initSomeThing(title: "全部", fontSize: 15, titleColor: .init(hex: "#666666"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        self.backgroundColor = .init(hex: "#EEEFF1")
        
        self.addSubview(typeLabel)
        typeLabel.textAlignment = .center
        typeLabel.textColor = .init(hex: "#666666")
        typeLabel.font = .systemFont(ofSize: 15)
        typeLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func billSelect(isSe:Bool) -> Void {
        
        if isSe {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 6
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(red: 0.99, green: 0.5, blue: 0.14, alpha: 1).cgColor
            self.backgroundColor = UIColor(red: 0.99, green: 0.5, blue: 0.14, alpha: 0.2)
            self.typeLabel.textColor = .init(hex: "#FD8024")
        } else {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 6
            self.backgroundColor = .init(hex: "#EEEFF1")
            self.layer.borderWidth = 0
            self.typeLabel.textColor = .init(hex: "#666666")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class selectHeaderReusableView: UICollectionReusableView {
    
    var startTimeBlock:stringBlock? = nil
    var endTimeBlock:stringBlock? = nil
    
    
    let time = UILabel.initSomeThing(title: "时间", fontSize: 17, titleColor: .init(hex: "#333333"))
    let type = UILabel.initSomeThing(title: "明细分类", fontSize: 17, titleColor: .init(hex: "#333333"))
    
    let startView = UIView.init()
    let startTime = UILabel.initSomeThing(title: NSDate.nowDateString(), fontSize: 15, titleColor: .init(hex: "#666666"))
    let startBtn = UIButton.init()
    let startImage = UIImageView.initWithName(imgName: "bt_rl")
    let cenlabel = UILabel.initSomeThing(title: "至", isBold: true, fontSize: 17, textAlignment: .center, titleColor: .init(hex: "#333333"))
    let endView = UIView.init()
    let endTime = UILabel.initSomeThing(title: NSDate.nowDateString(), fontSize: 15, titleColor: .init(hex: "#666666"))
    let endBtn = UIButton.init()
    let endImage = UIImageView.initWithName(imgName: "bt_rl")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildUI()
    }
    
    func buildUI() -> Void {
        self.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.height.equalTo(24)
        }
        
        self.addSubview(startView)
        startView.layer.masksToBounds = true
        startView.layer.borderWidth = 1
        startView.layer.borderColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1).cgColor
        startView.layer.cornerRadius = 3
        startView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(time.snp.bottom).offset(20)
            make.width.equalTo(156)
            make.height.equalTo(45)
        }
        startView.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-01"
        startTime.text = formatter.string(from: Date())
        startView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(12)
            make.height.equalTo(21)
            make.width.equalTo(90)
        }
        
        startView.addSubview(startImage)
        startImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(startTime)
            make.left.equalTo(startTime.snp.right)
            make.width.height.equalTo(24)
        }
        
        startBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
            dateView.buildDatePicker()
            dateView.titleLabel.text = "请选择开始日期"
            dateView.selectDateBlock = {date in
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.startTime.text = formatter.string(from: date)
                
                if(!NSDate.compareStartDateEndDate(startDate: self.startTime.text ?? "", endDate: self.endTime.text ?? "")) {
                    HQGetTopVC()?.view.makeToast("开始时间必须要小于结束时间")
                } else {
                    
                    if self.startTimeBlock != nil {
                        self.startTimeBlock!(self.startTime.text ?? "")
                    }
                }
                
            }
            HQGetTopVC()?.view.addSubview(dateView)
            
        }
        
        self.addSubview(cenlabel)
        cenlabel.snp.makeConstraints { (make) in
            make.left.equalTo(startView.snp.right).offset(14)
            make.width.equalTo(17)
            make.height.equalTo(24)
            make.centerY.equalTo(startView)
        }
        
        self.addSubview(endView)
        endView.layer.masksToBounds = true
        endView.layer.borderWidth = 1
        endView.layer.borderColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1).cgColor
        endView.layer.cornerRadius = 3
        endView.snp.makeConstraints { (make) in
            make.left.equalTo(cenlabel.snp.right).offset(14)
            make.centerY.equalTo(startView)
            make.width.equalTo(156)
            make.height.equalTo(45)
        }
        
        endView.addSubview(endBtn)
        endBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        endBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
            dateView.buildDatePicker()
            dateView.titleLabel.text = "请选择结束日期"
            dateView.selectDateBlock = { date in
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.endTime.text = formatter.string(from: date)
                if(!NSDate.compareStartDateEndDate(startDate: self.startTime.text ?? "", endDate: self.endTime.text ?? "")) {
                    HQGetTopVC()?.view.makeToast("结束时间必须要大于开始时间")
                } else {
                    
                    if self.endTimeBlock != nil {
                        self.endTimeBlock!(self.endTime.text ?? "")
                    }
                }
            }
            HQGetTopVC()?.view.addSubview(dateView)
        }
        
        endView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(12)
            make.height.equalTo(21)
            make.width.equalTo(90)
        }
        
        endView.addSubview(endImage)
        endImage.snp.makeConstraints { (make) in
            make.left.equalTo(endTime.snp.right)
            make.centerY.equalTo(endTime)
            make.width.height.equalTo(24)
        }
        
        self.addSubview(type)
        type.snp.makeConstraints { (make) in
            make.left.equalTo(time)
            make.top.equalTo(startView.snp.bottom).offset(30)
            make.height.equalTo(24)
            make.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
