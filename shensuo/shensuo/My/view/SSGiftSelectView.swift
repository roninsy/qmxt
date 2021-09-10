//
//  SSGiftSelectView.swift
//  shensuo
//
//  Created by  yang on 2021/5/31.
//

import UIKit

class SSGiftSelectView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var sureBtnBlock:((Int, Int)->())? = nil
    
    var clickOKBlock:((Bool, Bool, SSBillSelectModel)->())?
    var order: Int = 1
    var paymentType: Int = 0
    
    //按时间排序
    var bDown:Bool = false
    var bUp:Bool = false
    
    var contentView = UIView.init()
    let botView = UIView.init()
    let resetButton = UIButton.initTitle(title: "重置", fontSize: 18, titleColor: .init(hex: "#333333"))
    let okButton = UIButton.initTitle(title: "确定", fontSize: 18, titleColor: .init(hex: "#FFFFFF"))
    
    let closeBtn = UIButton.init()
    let titleLabel = UILabel.initSomeThing(title: "筛选条件", isBold: true, fontSize: 18, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    let time = UILabel.initSomeThing(title: "时间", fontSize: 17, titleColor: .init(hex: "#333333"))
    let payType = UILabel.initSomeThing(title: "付费免费", fontSize: 17, titleColor: .init(hex: "#333333"))
    let payTypeV = UIView.init()
    let upCell = selectBillCell.init()
    let downCell = selectBillCell.init()
    let allCell = selectBillCell.init()
    let payCell = selectBillCell.init()
    let freeCell = selectBillCell.init()
    let vipFreeCell = selectBillCell.init()
    var payContents: [String]? = nil {
        
        didSet{
            if order == 1 {
                
                upCell.billSelect(isSe: true)
                
            }else{
                
                downCell.billSelect(isSe: true)

            }
            if payContents == nil {
                
                payTypeV.isHidden = true
                contentView.snp.updateConstraints { make in
                    
                    make.height.equalTo(screenWid/414*409)
                }
                

                
            }else{
                
                payTypeV.isHidden = false
                contentView.snp.updateConstraints { make in
                    
                    make.height.equalTo(screenWid/414*409 + 180)

                }
                payCell.typeLabel.text = payContents![1]
                freeCell.typeLabel.text = payContents![2]
                switch paymentType {
                    case 0:
                        allCell.billSelect(isSe: true)
                        break
                    case 1:
                        payCell.billSelect(isSe: true)
                        break
                    case 2:
                        freeCell.billSelect(isSe: true)
                        break
                    case 3:
                        vipFreeCell.billSelect(isSe: true)
                        break
                    default:
                        return
                }

            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        self.buildUI()
        
    }
    
    @objc func tapUpcell() {
        upCell.bSelect = !upCell.bSelect
        order = 1
        if upCell.bSelect {
            downCell.billSelect(isSe: false)
            downCell.bSelect = false
        }
        upCell.billSelect(isSe: upCell.bSelect)
        
       
    }
    
    @objc func tapDowncell() {
        
        downCell.bSelect = !downCell.bSelect
        order = downCell.bSelect == true ? 2 : 1
        if downCell.bSelect {
            upCell.billSelect(isSe: false)
            upCell.bSelect = false
        }
        downCell.billSelect(isSe: downCell.bSelect)
        
//        if self.upDownTimeBlock != nil {
//            self.upDownTimeBlock!(upCell.bSelect, downCell.bSelect)
//        }
    }
    @objc func tapAllcell() {
        
        allCell.bSelect = !allCell.bSelect
        
        paymentType = 0
        if allCell.bSelect {
            payCell.billSelect(isSe: false)
            payCell.bSelect = false
            freeCell.billSelect(isSe: false)
            freeCell.bSelect = false
            vipFreeCell.billSelect(isSe: false)
            vipFreeCell.bSelect = false
        }
        allCell.billSelect(isSe: allCell.bSelect)
    
    }
    @objc func tapPaycell() {
        payCell.bSelect = !payCell.bSelect
        paymentType = payCell.bSelect == true ? 1 : 0
        if payCell.bSelect {
            allCell.billSelect(isSe: false)
            allCell.bSelect = false
            freeCell.billSelect(isSe: false)
            freeCell.bSelect = false
            vipFreeCell.billSelect(isSe: false)
            vipFreeCell.bSelect = false
        }
        payCell.billSelect(isSe: payCell.bSelect)
        
    }
    @objc func tapfreecell() {
        freeCell.bSelect = !freeCell.bSelect
        paymentType = freeCell.bSelect == true ? 2 : 0

        if freeCell.bSelect {
            allCell.billSelect(isSe: false)
            allCell.bSelect = false
            payCell.billSelect(isSe: false)
            payCell.bSelect = false
            vipFreeCell.billSelect(isSe: false)
            vipFreeCell.bSelect = false
        }
        freeCell.billSelect(isSe: freeCell.bSelect)

    }
    
    @objc func vipfreetapGest() {
        vipFreeCell.bSelect = !vipFreeCell.bSelect
        paymentType = vipFreeCell.bSelect == true ? 3 : 0

        if vipFreeCell.bSelect {
            allCell.billSelect(isSe: false)
            allCell.bSelect = false
            freeCell.billSelect(isSe: false)
            freeCell.bSelect = false
            payCell.billSelect(isSe: false)
            payCell.bSelect = false
        }
        vipFreeCell.billSelect(isSe: vipFreeCell.bSelect)
        
    }
    
    func buildUI() -> Void {

        self.addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(screenWid/414*409 + 180)
        }
        
        contentView.addSubview(closeBtn)
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

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBtn)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        self.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.height.equalTo(24)
        }
        
        self.addSubview(upCell)
        upCell.typeLabel.text = "时间↑"
        upCell.snp.makeConstraints { (make) in
            make.top.equalTo(time.snp.bottom).offset(24)
            make.left.equalTo(16)
            make.height.equalTo(45)
            make.width.equalTo(screenWid/2-24)
        }
        let tapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapUpcell))
        tapGest.numberOfTapsRequired = 1
        tapGest.numberOfTouchesRequired = 1
        upCell.addGestureRecognizer(tapGest)
        
        self.addSubview(downCell)
        downCell.typeLabel.text = "时间↓"
        downCell.snp.makeConstraints { (make) in
            make.top.equalTo(time.snp.bottom).offset(24)
            make.right.equalTo(-16)
            make.width.height.equalTo(upCell)
        }
        
        let dtapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapDowncell))
        dtapGest.numberOfTapsRequired = 1
        dtapGest.numberOfTouchesRequired = 1
        downCell.addGestureRecognizer(dtapGest)
        
        addSubview(payTypeV)
        payTypeV.backgroundColor = .white
        payTypeV.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(downCell.snp.bottom).offset(36)
        }
        
        payTypeV.addSubview(payType)
        payType.snp.makeConstraints { make in
            
            make.leading.equalTo(16)
            make.top.equalToSuperview()
        }
        
        payTypeV.addSubview(allCell)
        allCell.typeLabel.text = "全部"
        allCell.snp.makeConstraints { (make) in
            make.top.equalTo(payType.snp.bottom).offset(24)
            make.width.height.equalTo(downCell)
            make.leading.equalTo(payType)
        }
     
     
        
        payTypeV.addSubview(payCell)
        payCell.typeLabel.text = "付费方案"
        payCell.snp.makeConstraints { (make) in
            make.top.equalTo(allCell)
            make.width.height.equalTo(downCell)
            make.trailing.equalTo(downCell)
        }
        
        payTypeV.addSubview(freeCell)
        freeCell.typeLabel.text = "免费方案"
        freeCell.snp.makeConstraints { (make) in
            make.top.equalTo(allCell.snp.bottom).offset(16)
            make.width.height.equalTo(allCell)
            make.leading.equalTo(allCell)
        }
        
        
        
        payTypeV.addSubview(vipFreeCell)
        vipFreeCell.typeLabel.text = "vip免费"
        vipFreeCell.snp.makeConstraints { (make) in
            make.top.equalTo(freeCell)
            make.width.height.equalTo(downCell)
            make.leading.equalTo(downCell)
        }
        
        let alltapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapAllcell))
        alltapGest.numberOfTapsRequired = 1
        alltapGest.numberOfTouchesRequired = 1
        allCell.addGestureRecognizer(alltapGest)
        let paytapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapPaycell))
        paytapGest.numberOfTapsRequired = 1
        paytapGest.numberOfTouchesRequired = 1
        payCell.addGestureRecognizer(paytapGest)
        let freetapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapfreecell))
        freetapGest.numberOfTapsRequired = 1
        freetapGest.numberOfTouchesRequired = 1
        freeCell.addGestureRecognizer(freetapGest)
        let vipfreetapGest = UITapGestureRecognizer.init(target:self, action: #selector(vipfreetapGest))
        vipfreetapGest.numberOfTapsRequired = 1
        vipfreetapGest.numberOfTouchesRequired = 1
        vipFreeCell.addGestureRecognizer(vipfreetapGest)
        
        contentView.addSubview(botView)
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
            self.downCell.billSelect(isSe: false)
            self.upCell.billSelect(isSe: true)
            self.allCell.billSelect(isSe: true)
            self.payCell.billSelect(isSe: false)
            self.freeCell.billSelect(isSe: false)
            self.vipFreeCell.billSelect(isSe: false)
            
            self.order = 1
            self.paymentType = 0
            
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
        
        okButton.reactive.controlEvents(.touchUpInside).observeValues { [self] (btn) in
            
            self.sureBtnBlock?(self.order,self.paymentType)
            self.isHidden = true
            self.removeFromSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
