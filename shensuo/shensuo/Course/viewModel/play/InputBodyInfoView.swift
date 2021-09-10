//
//  InputBodyInfoView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/24.
//
///录入身体数据view

import UIKit
import HEPhotoPicker
import AMapLocationKit
import MBProgressHUD

class InputBodyInfoView: UIView,UITableViewDelegate,UITableViewDataSource {
    var model : CourseDetalisModel? = nil
    let aMapManage = AMapLocationManager.init()
    let imgBg = UIView()
    let headView = UIView()
    var headHei : CGFloat = 0
    let listView = UITableView()
    
    let sskey = SSCustomgGetSecurtKey()
    let navView = UIView()
    let titleLab = UILabel.initSomeThing(title: "录入身体数据", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    let tipLab = UILabel.initSomeThing(title: "为生成美丽日记、美丽相册，请录入身体数据", titleColor: .white, font: .systemFont(ofSize: 12), ali: .center)
    let tipLab2 = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 12), ali: .left)
    var selImg : UIImageView = UIImageView.initWithName(imgName: "check_addbtn_icon")
    var selImgName = ""
    let selBtn : UIButton = UIButton()
    
    var dataTitle:NSArray = ["身高","体重","腰围","BMI","BMI","体脂率","体脂率"]
    
    let nextBtn = UIButton.initTitle(title: "下一步", font: .MediumFont(size: 18), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    
    var BMINum :CGFloat = 0
    var TiZhiNum :CGFloat = 0
    
    var birthday = "1990-01-01"
    var province = ""
    var city = ""
    ///腰围
    var girth : CGFloat = 0
    var height : CGFloat = 0
    var weight : CGFloat = 0
    var sex : Int = 1
    
    var days = 1{
        didSet{
            if days < 2 {
                self.setupHeadViewFirst()
            }else{
//                self.tipLab2.text = "     提示：第\(days)次录入身体数据记录"
            }
        }
    }
    
    let sexView = BodySelSexView()
    let birView = InputBodyListCellView()
    let cityView = InputBodyListCellView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        navView.backgroundColor = .white
        self.addSubview(navView)
        navView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44 + NavStatusHei)
        }
        
        navView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
            make.height.equalTo(44)
        }
        
        navView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.bottom.equalTo(-10)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
        
        
        
        nextBtn.layer.cornerRadius = 22.5
        nextBtn.layer.masksToBounds = true
        self.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-50)
            make.height.equalTo(45)
        }
        nextBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.days < 2 && self.province.length < 1{
                self.makeToast("请选择位置信息")
                return
            }
            if !self.selBtn.isSelected{
                self.makeToast("请选择图片")
                return
            }
            if self.height < 1{
                self.makeToast("请选择身高")
                return
            }
            self.uploadImg()
        }
        
        self.setupHeadView()
        
        listView.showsVerticalScrollIndicator = false
        listView.backgroundColor = .init(hex: "#F7F8F9")
        self.listView.tableHeaderView = headView
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.separatorStyle = .none
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-12)
        }
        
        self.sskey.getSecurtKey()
        self.getDays()
    }
    
    func setupHeadView(){
        tipLab.backgroundColor = .init(hex: "#FD8024")
        headView.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.height.equalTo(33)
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
        }
        
        tipLab2.backgroundColor = .init(hex: "#F7F8F9")
        headView.addSubview(tipLab2)
        tipLab2.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.top.equalTo(tipLab.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        
        imgBg.backgroundColor = .white
        headView.addSubview(imgBg)
        imgBg.snp.makeConstraints { make in
            make.height.equalTo(153)
            make.top.equalTo(12 + 33)
            make.left.right.equalToSuperview()
        }
        
        let tipLab3 = UILabel.initSomeThing(title: "    照片", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
        imgBg.addSubview(tipLab3)
        tipLab3.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
        }
        
        selImg.layer.cornerRadius = 6
        selImg.layer.masksToBounds = true
        selImg.contentMode = .scaleAspectFill
        imgBg.addSubview(selImg)
        selImg.snp.makeConstraints({ make in
            make.width.height.equalTo(90)
            make.left.equalTo(16)
            make.top.equalTo(tipLab3.snp.bottom)
        })
        
        selBtn.layer.cornerRadius = 6
        selBtn.layer.masksToBounds = true
        imgBg.addSubview(selBtn)
        selBtn.snp.makeConstraints({ make in
            make.width.height.equalTo(90)
            make.left.equalTo(16)
            make.top.equalTo(tipLab3.snp.bottom)
        })
        selBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.selectImage()
        }
        
        self.headHei = 33 + 12 + 153 + 12
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWid, height: headHei)
    }
    
    func setupHeadViewFirst(){
        
        tipLab2.text = ""
        tipLab2.snp.updateConstraints { make in
            make.height.equalTo(12)
        }
        
        sexView.changgeBlock = { num in
            self.sex = num
        }
        headView.addSubview(sexView)
        sexView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview()
            make.top.equalTo(tipLab2.snp.bottom)
        }
        
        birView.clickBlock = { [weak self] in
            self?.showDatePick()
        }
        birView.leftLab.text = "生日"
        birView.hasRicon = true
        birView.rightText = "1990-01-01"
        headView.addSubview(birView)
        birView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview()
            make.top.equalTo(sexView.snp.bottom)
        }
        
        cityView.clickBlock = { [weak self] in
            self?.showAddressPick()
        }
        cityView.leftLab.text = "所在省市"
        cityView.botLine.isHidden = true
        cityView.hasRicon = true
        cityView.rightText = ""
        headView.addSubview(cityView)
        cityView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview()
            make.top.equalTo(birView.snp.bottom)
        }
        
        self.imgBg.snp.updateConstraints { make in
            make.top.equalTo(33 + 12 + 56 + 56 + 56 + 12)
        }
        
        
        aMapManage.desiredAccuracy = kCLLocationAccuracyHundredMeters
        aMapManage.locationTimeout = 2
        aMapManage.reGeocodeTimeout = 2
        aMapManage.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
                    
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let location = location {
                NSLog("location:%@", location)
            }
            
            if let reGeocode = reGeocode {
                self?.province = reGeocode.province
                self?.city = reGeocode.city
                self?.cityView.rightText = "\(reGeocode.province ?? "")\(reGeocode.city ?? "")"
            }
        })
        
        self.headHei = 33 + 12 + 56 + 56 + 56 + 12 + 153 + 12
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWid, height: headHei)
        self.listView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : InputBodyListCell? = tableView.dequeueReusableCell(withIdentifier: "InputBodyListCell") as? InputBodyListCell
        if cell == nil {
            cell = InputBodyListCell.init(style: .default, reuseIdentifier: "InputBodyListCell")
        }
        cell?.mainView.leftLab.text = self.dataTitle[indexPath.row] as? String
        if indexPath.row < 3 {
            cell?.mainView.hasRicon = true
            if indexPath.row == 0 {
                cell?.mainView.rightText = self.height > 0 ? "\(self.height)CM" : ""
            }
            if indexPath.row == 1 {
                cell?.mainView.rightText = self.weight > 0 ? "\(self.weight)KG" : ""
            }
            if indexPath.row == 2 {
                cell?.mainView.rightText = self.girth > 0 ? "\(self.girth)CM" : ""
            }
            cell?.tag = indexPath.row
            cell?.mainView.clickBlock = {
                if (cell?.tag ?? 0) < 3 {
                    let rulerView = RulerForBodyView()
                    rulerView.backBlock = {[weak self] numArr in
                        self?.height = numArr[0] as? CGFloat ?? 0
                        self?.weight = numArr[1] as? CGFloat ?? 0
                        self?.girth = numArr[2] as? CGFloat ?? 0
                        self?.updateBMI()
                    }
                    self.addSubview(rulerView)
                    rulerView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                }
            }
            
        }else{
            cell?.mainView.hasRicon = false
        }
        if indexPath.row == 3 {
            cell?.mainView.rightText = self.BMINum < 1 ? "待计算" : String.init(format: "%.1f", self.BMINum)
        }
        if indexPath.row == 4 {
            cell?.mainView.bmiNum = self.BMINum
        }
        if indexPath.row == 5 {
            cell?.mainView.rightText = self.TiZhiNum < 0.01 ? "待计算" : String.init(format: "%.1f%%", self.TiZhiNum)
        }
        if indexPath.row == 6 {
            cell?.mainView.isGirl = self.sex == 2
            cell?.mainView.bodyFatNum = self.TiZhiNum
        }
        return cell!
    }
    

    
    ///计算体脂率和
    func updateBMI(){
        self.BMINum = self.weight / (self.height * self.height / 10000)
        let a = self.girth * 0.74
        let b = self.weight * 0.082 + (self.sex == 2 ? 34.89 : 44.74)
        self.TiZhiNum = (a-b) / self.weight * 100
        self.listView.reloadData()
    }
    
    func uploadImg(){
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
        
       
        DispatchQueue.main.async { [weak self] in
            MBProgressHUD.showAdded(to: self!, animated: true)
            imgUpload.uploadImg((self!.selImg.image!) as UIImage) { (image) in
                DispatchQueue.main.async { [weak self] in
                    MBProgressHUD.hide(for: self!, animated: true)
                    self?.selImgName = image
                    self?.enterBtnClick()
                }
            } faildBlock: {
                self?.makeToast("图片上传失败，请退出重试")
            }
        }
    }
    
    func enterBtnClick(){
        ///录入身体数据
        CommunityNetworkProvider.request(.addDailyRecord(birthday: birthday, bmi: BMINum, bodyFat: TiZhiNum, city: city, girth: girth, height: height, image: self.selImgName, province: province, sex: sex, weight: weight)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.makeToast("保存成功")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                ///上报事件
                                HQPushActionWith(name: "click_publish_note", dic:  ["current_page":"打卡到动态"])
                                ///跳转到发布动态-拍视频页面
                                ///跳转到发布动态
                                let vc = SSReleaseNewsViewController()
                                vc.hidesBottomBarWhenPushed = true
                                vc.detalisModel = self.model ?? CourseDetalisModel()
                                vc.inType = 2
                                HQPush(vc: vc, style: .default)
                            }
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func getDays(){
        ///获取天数
        CommunityNetworkProvider.request(.dailyRecordSelectDays) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            self.days = model?.data ?? 2
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    func upUserInfo(){
        UserNetworkProvider.request(.getUserInfo) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().userInfo = model?.data as NSDictionary?
                        }else{
                            
                        }
                    }
                } catch {
                    
                }
                
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    func showAddressPick() -> Void {
        let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        dateView.buildAreaPicker()
        dateView.titleLabel.text = "请选择地区"
        dateView.selectAreaBlock = {pName, pId, cName, cId in
            self.province = pName
            self.city = cName
            self.cityView.rightText = "\(pName)\(cName)"
        }
        self.addSubview(dateView)
    }
    
    func showDatePick() -> Void {
        
        let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        dateView.buildDatePicker()
        dateView.selectDateBlock = {date in

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.birthday = formatter.string(from: date)
            self.birView.rightText = self.birthday
            
        }
        dateView.titleLabel.text = "请选择出生日期"
        self.addSubview(dateView)
    }
    
    func selectImage() {
        let option = HEPickerOptions.init()

        option.maxCountOfImage = 1
        // 图片和视频只能选择一种
        option.mediaType = .image

        let imagePickerController = HEPhotoPickerViewController.init(delegate: self,options: option)
        let nav = UINavigationController.init(rootViewController: imagePickerController)
        nav.modalPresentationStyle = .fullScreen
        HQGetTopVC()?.present(nav, animated: true, completion: nil)
    }
}

//选图片

extension InputBodyInfoView: HEPhotoPickerViewControllerDelegate{
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        
        NSLog("%@----%@", selectedImages,selectedModel[0].asset)
        if selectedImages.count > 0 {
            self.selImg.image = selectedImages[0]
            self.selBtn.isSelected = true
        }else{
            self.selImg.image = UIImage.init(named: "check_addbtn_icon")
            self.selBtn.isSelected = false
        }
    }
    
}




class InputBodyListCell: UITableViewCell {
    let mainView = InputBodyListCellView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputBodyListCellView: UIView {
    var clickBlock : voidBlock? = nil
    
    var isGirl = true
    var age = 18
    var hasRicon = false{
        didSet{
            self.rIcon.snp.updateConstraints { make in
                make.width.equalTo(hasRicon ? 16 : 0)
            }
            rIcon.isHidden = !hasRicon
        }
    }
    
    let leftLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    
    let rightView = UIView()
    let rIcon = UIImageView.initWithName(imgName: "right_black_nobg")
    let rightLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .right)
    
    let stateView = UIView()
    let stateLab = UILabel.initSomeThing(title: "正常", titleColor: .white, font: .MediumFont(size: 12), ali: .center)
    let stateNumLab = UILabel.initSomeThing(title: "18.5 ~ 23.9", titleColor: .init(hex: "#999999"), font: .MediumFont(size: 13), ali: .center)
    
    let botLine = UIView()
    
    var isStateType = false{
        didSet{
            self.stateView.isHidden = !isStateType
            self.rightView.isHidden = isStateType
        }
    }
    
    var rightText : String = ""{
        didSet{
            self.rightLab.text = rightText
            self.isStateType = false
        }
    }
    
    var bmiNum : CGFloat = 20{
        didSet{
            self.isStateType = true
            if bmiNum < 1 {
                return
            }
            if bmiNum <= 18.4 {
                self.stateView.backgroundColor = .init(hex: "#5DDBFF")
                self.stateLab.text = "偏瘦"
                self.stateNumLab.text = "<=18.4"
            }else if bmiNum < 24{
                self.stateView.backgroundColor = .init(hex: "#4DCC3C")
                self.stateLab.text = "正常"
                self.stateNumLab.text = "18.5-23.9"
            }
            else if bmiNum < 28 {
                self.stateView.backgroundColor = .init(hex: "#FFC52B")
                self.stateLab.text = "过重"
                self.stateNumLab.text = "24.0-27.9"
            }else{
                self.stateView.backgroundColor = .init(hex: "#FC462F")
                self.stateLab.text = "肥胖"
                self.stateNumLab.text = ">=28"
            }
        }
    }
    
    var bodyFatNum : CGFloat = 20{
        didSet{
            self.isStateType = true
            if bodyFatNum < 1 {
                return
            }
            if isGirl {
                var tempNum : CGFloat = age < 40 ? 0 : 1
                tempNum += age >= 60 ? 1 : 0
                if bodyFatNum <= (20+tempNum) {
                    self.stateView.backgroundColor = .init(hex: "#5DDBFF")
                    self.stateLab.text = "偏瘦"
                    self.stateNumLab.text = "5-\(20+tempNum)%"
                }else if bodyFatNum < (34+tempNum){
                    self.stateView.backgroundColor = .init(hex: "#4DCC3C")
                    self.stateLab.text = "正常"
                    self.stateNumLab.text = "\(20+tempNum+1)-\(34+tempNum)%"
                }
                else if bodyFatNum < (39+tempNum) {
                    self.stateView.backgroundColor = .init(hex: "#FFC52B")
                    self.stateLab.text = "过重"
                    self.stateNumLab.text = "\(34+tempNum+1)-\(39+tempNum)%"
                }else{
                    self.stateView.backgroundColor = .init(hex: "#FC462F")
                    self.stateLab.text = "肥胖"
                    self.stateNumLab.text = "\(39+tempNum+1)-\(45)%"
                }
            }else{
                var tempNum : CGFloat = age < 40 ? 0 : 1
                tempNum += age >= 60 ? 2 : 0
                if bodyFatNum <= (10+tempNum) {
                    self.stateView.backgroundColor = .init(hex: "#5DDBFF")
                    self.stateLab.text = "偏瘦"
                    self.stateNumLab.text = "5-\(10+tempNum)%"
                }else if bodyFatNum < (21+tempNum){
                    self.stateView.backgroundColor = .init(hex: "#4DCC3C")
                    self.stateLab.text = "正常"
                    self.stateNumLab.text = "\(10+tempNum+1)-\(21+tempNum)%"
                }
                else if bodyFatNum < (26+tempNum) {
                    self.stateView.backgroundColor = .init(hex: "#FFC52B")
                    self.stateLab.text = "过重"
                    self.stateNumLab.text = "\(21+tempNum+1)-\(26+tempNum)%"
                }else{
                    self.stateView.backgroundColor = .init(hex: "#FC462F")
                    self.stateLab.text = "肥胖"
                    self.stateNumLab.text = "\(26+tempNum+1)-\(45)%"
                }
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(leftLab)
        leftLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
        
        self.addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(150)
        }
        
        rightView.addSubview(rIcon)
        rIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        
        rightView.addSubview(rightLab)
        rightLab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rIcon.snp.left).offset(-4)
            make.left.equalTo(0)
        }
        
        self.addSubview(stateView)
        stateView.layer.cornerRadius = 5
        stateView.layer.masksToBounds = true
        stateView.backgroundColor = .init(hex: "#4DCC3C")
        stateView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.height.equalTo(26)
            make.width.equalTo(81 + 54)
            make.centerY.equalToSuperview()
        }
        
        stateView.addSubview(stateLab)
        stateLab.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.top.bottom.right.equalToSuperview()
        }
        
        stateNumLab.layer.cornerRadius = 5
        stateNumLab.layer.masksToBounds = true
        stateNumLab.backgroundColor = .white
        stateView.addSubview(stateNumLab)
        stateNumLab.snp.makeConstraints { make in
            make.width.equalTo(79)
            make.top.equalTo(1)
            make.left.equalTo(1)
            make.height.equalTo(24)
        }

        botLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clickBlock?()
    }
    
}

class BodySelSexView : UIView{
    var changgeBlock : intBlock? = nil
    let leftLab = UILabel.initSomeThing(title: "性别", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)

    let girlIcon = UIImageView.initWithName(imgName:"my_btnSelect")
    let boyIcon = UIImageView.initWithName(imgName:"my_btnNormal")
    
    var isGirl = true{
        didSet{
            girlIcon.image = UIImage.init(named: isGirl ? "my_btnSelect" : "my_btnNormal")
            boyIcon.image = UIImage.init(named: isGirl == false ? "my_btnSelect" : "my_btnNormal")
            self.changgeBlock?(isGirl ? 2 : 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(leftLab)
        leftLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
        
        
        let boy = UILabel.initSomeThing(title: "男", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 16), ali: .right)
        self.addSubview(boy)
        boy.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(18)
        }
        
        self.addSubview(boyIcon)
        boyIcon.snp.makeConstraints { make in
            make.right.equalTo(boy.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(19)
        }
        
        let boyBtn = UIButton()
        self.addSubview(boyBtn)
        boyBtn.snp.makeConstraints { make in
            make.right.equalTo(boy)
            make.left.equalTo(boyIcon)
            make.top.bottom.equalTo(0)
        }
        boyBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.isGirl = false
        }
        
        let girl = UILabel.initSomeThing(title: "女", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 16), ali: .right)
        self.addSubview(girl)
        girl.snp.makeConstraints { make in
            make.right.equalTo(-95)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(18)
        }
        
        self.addSubview(girlIcon)
        girlIcon.snp.makeConstraints { make in
            make.right.equalTo(girl.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(19)
        }
        
        let girlBtn = UIButton()
        self.addSubview(girlBtn)
        girlBtn.snp.makeConstraints { make in
            make.right.equalTo(girl)
            make.left.equalTo(girlIcon)
            make.top.bottom.equalTo(0)
        }
        girlBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.isGirl = true
        }
        
        let botLine = UIView()
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}
