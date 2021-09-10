//
//  SSMsgSelectView.swift
//  shensuo
//
//  Created by  yang on 2021/5/19.
//

import UIKit

class SSMsgSelectView: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var clickOKBlock:((Bool, Bool, SSBillSelectModel)->())?
    
    //按时间排序
    var bDown:Bool = true
    var bUp:Bool = false
    
    
    var clickModel:SSBillSelectModel = SSBillSelectModel()
    
    var selectModels : [SSBillSelectModel]? = nil {
        didSet{
            if selectModels != nil {
                dataCollectionView.reloadData()
            }
        }
    }
    
    var headView : msgHeaderReusableView!
    
    var dataCollectionView:UICollectionView!
    let botView = UIView.init()
    let resetButton = UIButton.initTitle(title: "重置", fontSize: 18, titleColor: .init(hex: "#333333"))
    let okButton = UIButton.initTitle(title: "确定", fontSize: 18, titleColor: .init(hex: "#FFFFFF"))
    
    let closeBtn = UIButton.init()
    let titleLabel = UILabel.initSomeThing(title: "筛选条件", isBold: true, fontSize: 18, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
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
        dataCollectionView.register(msgHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "msgHeaderReusableView")
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        self.addSubview(dataCollectionView)

        self.buildUI()
        self.loadData()
    }
    
    func loadData() -> Void {
        UserInfoNetworkProvider.request(.noticesTypes) { (result) in
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
    
    func resetData() -> Void {
        self.bDown = true
        self.bUp = false
        for index in 0...self.selectModels!.count-1 {
            self.selectModels![index].bSelect = false
        }
        self.clickModel.name = ""
        self.clickModel.type = ""
        self.clickModel.bSelect = false
        self.dataCollectionView.reloadData()

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
            if self.clickOKBlock != nil {
                self.clickOKBlock!(self.bUp,self.bDown,self.clickModel)
            }
            self.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SSMsgSelectView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectModels?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectBillCell", for: indexPath) as! selectBillCell
        let model = (self.selectModels?[indexPath.row])! as SSBillSelectModel
        cell.typeLabel.text = model.name
        cell.billSelect(isSe: model.bSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! selectBillCell
        cell.bSelect = !cell.bSelect
        self.clickModel = (self.selectModels?[indexPath.row])! as SSBillSelectModel
        for index in 0...self.selectModels!.count-1 {
            if self.selectModels![index].name == self.clickModel.name {
                self.selectModels![index].bSelect = !self.selectModels![index].bSelect
            } else {
                self.selectModels![index].bSelect = false
            }

        }
        self.clickModel.bSelect.toggle()
        cell.billSelect(isSe: self.clickModel.bSelect)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWid, height: 180)
        }
        return CGSize(width: screenWid, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if self.headView == nil {
            self.headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "msgHeaderReusableView", for: indexPath) as? msgHeaderReusableView
        }
        if self.bDown == true && headView.downCell.bSelect == false {
            headView.tapDowncell()
        }else if self.bUp == true && headView.upCell.bSelect == false{
            headView.tapUpcell()
        }
        headView.upDownTimeBlock = {bUpTime, bDownTime in
            self.bDown = bDownTime
            self.bUp = bUpTime
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            return headView
        }
        return UICollectionReusableView.init()
    }
}


class msgHeaderReusableView: UICollectionReusableView {
    
    var upDownTimeBlock:((Bool, Bool)->())? = nil
    
    
    let time = UILabel.initSomeThing(title: "通知时间", fontSize: 17, titleColor: .init(hex: "#333333"))
    let type = UILabel.initSomeThing(title: "类型", fontSize: 17, titleColor: .init(hex: "#333333"))
    
    let upCell = selectBillCell.init()
    let downCell = selectBillCell.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildUI()
    }
    
    @objc func tapUpcell() {
        upCell.bSelect = !upCell.bSelect
        if upCell.bSelect {
            downCell.billSelect(isSe: false)
            downCell.bSelect = false
        }
        upCell.billSelect(isSe: upCell.bSelect)
        
        if self.upDownTimeBlock != nil {
            self.upDownTimeBlock!(upCell.bSelect, downCell.bSelect)
        }
    }
    
    @objc func tapDowncell() {
        downCell.bSelect = !downCell.bSelect
        if downCell.bSelect {
            upCell.billSelect(isSe: false)
            upCell.bSelect = false
        }
        downCell.billSelect(isSe: downCell.bSelect)
        
        if self.upDownTimeBlock != nil {
            self.upDownTimeBlock!(upCell.bSelect, downCell.bSelect)
        }
    }
    
    func buildUI() -> Void {
        
        self.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.height.equalTo(24)
        }
        
        self.addSubview(upCell)
        upCell.typeLabel.text = "通知时间↑"
        upCell.snp.makeConstraints { (make) in
            make.top.equalTo(time.snp.bottom).offset(24)
            make.left.equalTo(10)
            make.height.equalTo(45)
            make.width.equalTo(screenWid/2-15)
        }
        let tapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapUpcell))
        tapGest.numberOfTapsRequired = 1
        tapGest.numberOfTouchesRequired = 1
        upCell.addGestureRecognizer(tapGest)
        
        self.addSubview(downCell)
        downCell.typeLabel.text = "通知时间↓"
        downCell.snp.makeConstraints { (make) in
            make.top.equalTo(time.snp.bottom).offset(24)
            make.right.equalTo(-10)
            make.height.equalTo(45)
            make.width.equalTo(screenWid/2-15)
        }
        
        let dtapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapDowncell))
        dtapGest.numberOfTapsRequired = 1
        dtapGest.numberOfTouchesRequired = 1
        downCell.addGestureRecognizer(dtapGest)
        
        self.addSubview(type)
        type.snp.makeConstraints { (make) in
            make.left.equalTo(time)
            make.top.equalTo(downCell.snp.bottom).offset(30)
            make.height.equalTo(24)
            make.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
