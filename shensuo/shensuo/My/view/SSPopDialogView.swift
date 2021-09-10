//
//  SSPopDialogView.swift
//  shensuo
//
//  Created by  yang on 2021/4/21.
//

import UIKit

enum pickerType {
    case datePicker
    case areaPicker
}

class SSPopDialogView: UIView {
    
    var dataArray:[Any] = [];
    var pickerType:pickerType = .datePicker
    var numberOfComponents:Int = 1
    var selectedMultiComponents:(first:Int,second:Int) = (0,0)
    
    var selectDateBlock : ((Date)->())?
    var selectAreaBlock : ((String, Int, String, Int)->())?
    
    
//    var layBgView : UIImageView = {
//        let bgView = UIImageView.init()
////        bgView.backgroundColor = .init(hex: "#F7F8F9")
////        bgView.alpha = 0.5
//        bgView.isUserInteractionEnabled = true
//        return bgView
//    }()
    
    var contentView:UIView = {
        let content = UIView.init()
        content.backgroundColor = .white
        content.layer.masksToBounds = true
        content.layer.cornerRadius = 16
        return content
    }()
    
    var titleLabel:UILabel = {
        let title = UILabel.init()
        title.font = .boldSystemFont(ofSize: 18)
        title.textAlignment = .center
        title.textColor = .init(hex: "#333333")
        return title
    }()
    
    var areaPicker:UIPickerView = {
        let picker = UIPickerView.init()

        return picker
    }()
    
    var datePicker:UIDatePicker = {
        let picker = UIDatePicker.init()
        return picker
    }()
    
    
    var inlineView:UIView = {
        let inline = UIView.init()
        inline.backgroundColor = .init(hex: "#E4E4E4")
        return inline
    }()
    
    
    
    var cancelBtn:UIButton = {
        let cancel = UIButton.init()
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(.init(hex: "#666666"), for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 20)
        return cancel
    }()
    
    var lineView:UIView = {
        let line = UIView.init()
        line.backgroundColor = .init(hex: "#E4E4E4")
        return line
    }()
    
    
    var okBtn:UIButton = {
        let ok = UIButton.init()
        ok.setTitle("确定", for: .normal)
        ok.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        ok.titleLabel?.font = .systemFont(ofSize: 20)
        return ok
    }()
    
    var provinceModels : [SSProvinceModel]? = nil{
        didSet{
            if provinceModels != nil {
                areaPicker.reloadAllComponents()
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        cancelBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.removeFromSuperview()
        }
        okBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            if self.pickerType == .areaPicker {
                let provice:SSProvinceModel = self.provinceModels![self.selectedMultiComponents.first] as SSProvinceModel
                if (self.selectAreaBlock != nil) {
                    self.selectAreaBlock!(provice.name, provice.id, provice.cityList![self.selectedMultiComponents.second].name, provice.cityList![self.selectedMultiComponents.second].id)
                }
            }
            
            self.removeFromSuperview()
        }
    }
    
    func buildDatePicker() -> Void {
        self.pickerType = .datePicker
        self.numberOfComponents = 3
        buildUI()
    }
    
    func buildAreaPicker() -> Void {
        self.pickerType = .areaPicker
        
        guard let path = Bundle.main.path(forResource: "area", ofType: "plist") else {return}
        guard let arr = NSArray.init(contentsOfFile: path) else {return}
        dataArray = arr as! [Any]
        self.numberOfComponents = 2
        self.loadAddressData()
        buildUI()
    }
    
    func loadAddressData() -> Void {
        UserInfoNetworkProvider.request(.provincesList) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                let array = model?.data
                                self.provinceModels = array?.kj.modelArray(type: SSProvinceModel.self) as? [SSProvinceModel]
                                
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
    
    
    func buildUI() -> Void {
        self.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenHei)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isUserInteractionEnabled = true
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(screenWid/353*338)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.width.equalToSuperview()
            make.height.equalTo(25)
        }
    
        
        contentView.addSubview(inlineView)
        inlineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-56)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        if pickerType == .areaPicker {
            contentView.addSubview(areaPicker)
            areaPicker.delegate = self
            areaPicker.dataSource = self
            areaPicker.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(inlineView.snp.top).offset(-10)
            }
        } else {
            contentView.addSubview(datePicker)
            datePicker.datePickerMode = .date
            if #available(iOS 13.0, *) {
                datePicker.date = NSDate.now
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            
            datePicker.addTarget(self, action: #selector(clickDatePicker(datePick:)), for: .valueChanged)
            datePicker.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(inlineView.snp.top).offset(-10)
            }
        }
        
        
        contentView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(56)
            make.left.equalTo(16)
            make.width.equalTo(160)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(56)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview()
            make.width.equalTo(160)
        }
    }
    
    @objc func clickDatePicker(datePick:UIDatePicker) -> Void {
        let date = datePick.date
        selectDateBlock!(date)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension SSPopDialogView:UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.pickerType == .areaPicker {
            if numberOfComponents == 1 {
                return "\(dataArray[row])"
            } else if numberOfComponents == 2 {
                if component == 0 {
//                    let d = dataArray[row] as! [String:Any]
//                    return d["province"] as? String
                    
                    let model = self.provinceModels?[row]
                    return model?.name
                }else {
                    let model = (self.provinceModels?[selectedMultiComponents.first])! as SSProvinceModel
                    return model.cityList![row].name
                    
//                    let d = dataArray[selectedMultiComponents.first] as! [String:Any]
//                    let arr = d["areas"] as! [String]
//                    return arr[row]
                }
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.pickerType == .areaPicker {
            if numberOfComponents == 1 {
                selectedMultiComponents.first = row

            }else if numberOfComponents == 2 {
                if component == 0 {
                    selectedMultiComponents.first = row
                    selectedMultiComponents.second = 0
                    pickerView.reloadComponent(1)
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                }else if component == 1 {
                    selectedMultiComponents.second = row
                }
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerType == .areaPicker {
            if component == 0 {
                return self.provinceModels?.count ?? 0
//                return dataArray.count
            } else if component == 1 {
                if self.provinceModels == nil {
                    return 0
                }
                let model = self.provinceModels![selectedMultiComponents.first] as SSProvinceModel
                return model.cityList?.count ?? 0
//                let d = dataArray[selectedMultiComponents.first] as! [String:Any]
//                let arr = d["areas"] as! [String]
//                return arr.count
            }
            
//            if component == 0 {
//                return self.provinceModels?.count ?? 0
//            } else if component == 1 {
//                return self.provinceModels![component].cityList?.count ?? 0
//            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
}
