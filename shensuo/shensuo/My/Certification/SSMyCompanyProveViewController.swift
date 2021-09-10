//
//  SSMyCompanyProveViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/7.
//

import UIKit
import HEPhotoPicker

class MyProveViewController: SSBaseViewController {
    var personModel:SSPersonModel?
}

class SSMyCompanyProveViewController: MyProveViewController {
    
    var imagePickerController: HEPhotoPickerViewController!
    let option = HEPickerOptions.init()
    var defaultSelections = [HEPhotoAsset]()
    let sskey = SSCustomgGetSecurtKey()
    //企业执照
    var businessListIdArray : [UIImage] = []
    //身份证图片
    var imageListIdArray : [UIImage] = []
    //资质素组
    var imageListArray : [UIImage] = []
    var companyIdModel: SSCompanyIdModel?
    //1:身份证 2: 资质
    var imgCellType: Int = 4
    let codeBtn = UIButton.initTitle(title: "|获取验证码", fontSize: 16, titleColor: .init(hex: "#878889"))
    
    var second = 0
    
    override var personModel:SSPersonModel?{
        didSet{
            if personModel != nil {
                self.detailAddress = personModel?.detailAddress ?? ""
                if personModel?.businessLicenseImages.count != 0 {
                    self.setImgImage(list: personModel!.businessLicenseImages, type: 0)
                }
                if personModel?.certificateImages != nil {
                    self.setImgImage(list: personModel!.certificateImages!, type: 2)
                }
            }
        }
    }
    var listArray: [SSCompanyIdModel]?
    var dataArray = [["企业名称","社会信用代码","所在省市"],["详细地址",""],["运营者姓名","身份证号","手机号","短信验证"],["对外认证展示","",""],["企业营业执照"],["运营者身份证正反面"],["运营者工作证明(名片/工牌/授权书)"]]
    var placeHolderArray = [["请输入","请输入","请输入"],["请输入真实姓名","请输入","请输入","请输入"]]
    
    var businessLicenseImages:String = ""
    var certificateImages:String = ""
    var certificationId:Int = 0
    var cityName:String = ""
    var companyName:String = ""
    var creditCode:String = ""
    var detailAddress:String = ""
    var idimages:String = ""
    var operatorIDNumber:String = ""
    var operatorMobile:String = ""
    var operatorName:String = ""
    var provinceName:String = ""
    var showWords:String = ""
    var type: Int = 0       // 0: 身份认证页跳转 1: 认证成功页跳转
    
    var cid : String = ""
    ///身份证cell
    let shenFenZhengCell = SSShenfenzhengCell.init(style: .default, reuseIdentifier: "")
    
    var listTableView: UITableView = {
        let listTable = UITableView(frame: .zero, style: .grouped)
        listTable.backgroundColor = .init(hex: "#F7F8F9")
        return listTable
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ishideBar = true
        navView.backBtnWithTitle(title: "企业认证")
        
        // shenFenZhengCell
        shenFenZhengCell.delegate = self
        
        self.buildUI()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = self.footView()
        listTableView.register(RenZhenCell.self, forCellReuseIdentifier: "renzhenCell")
        listTableView.register(imagesCell.self, forCellReuseIdentifier: "imagesCell")
        sskey.getSecurtKey()
        if type == 0 {
            
            self.personModel = SSPersonModel()
            personModel?.operatorMobile = UserInfo.getSharedInstance().mobile ?? ""
            personModel?.mobile = UserInfo.getSharedInstance().mobile ?? ""
            
        }else{
            personModel?.operatorMobile = UserInfo.getSharedInstance().mobile ?? ""
            personModel?.mobile = UserInfo.getSharedInstance().mobile ?? ""
            self.loadData()

        }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.sendCode()
        }
    }
    
    func setImgImage(list: [String],type: Int){
        if type == 0 && self.businessListIdArray.count != 0{
            return
        }
        if type == 2 && self.imageListIdArray.count != 0{
            return
        }
        for index in 0..<list.count {

            let img = UIImageView.init()
            img.kf.setImage(with: URL(string: list[index])) { res in
                if type == 0{
                    do{
                        self.businessListIdArray.append(try res.get().image)
                    }catch {
                        
                    }
                }else if type == 2{
                    do{
                        self.imageListIdArray.append(try res.get().image)
                    }catch {
                        
                    }
                }
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        }
    }
    
    func loadData() -> Void {
        UserInfoNetworkProvider.request(.certificationsdetail(cid: cid)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dic = model?.data
                                if dic == nil {
                                    return
                                }
                                self.personModel = dic?.kj.model(SSPersonModel.self)
                                self.personModel?.certificationId = self.cid
                                DispatchQueue.main.async {
                                    self.listTableView.reloadData()
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
    
    
    func buildUI() -> Void {
        
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }

    func footView() -> UIView {
        let ftView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 160))
        
        let ftBtn = UIButton.init(frame: CGRect(x: 10, y: 80, width: screenWid-20, height: 45))
        ftBtn.backgroundColor = .init(hex: "#FD8024")
        ftBtn.layer.masksToBounds = true
        ftBtn.layer.cornerRadius = 16
        ftBtn.titleLabel?.font = .systemFont(ofSize: 18)
        ftBtn.setTitle("立即认证", for: .normal)
        ftBtn.titleLabel?.textColor = .white
        ftBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            
    
            self.checkSave()
        }
        
        ftView.addSubview(ftBtn)
        
        return ftView
    }
    
    func saveInfo() -> Void {
        UserInfoNetworkProvider.request(.applyCompany(proveModel:self.personModel!)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let vc = SSProveSuccessController()
                                vc.inType = 2
                                HQPush(vc: vc, style: .default)

                            }
                            
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func checkSave()  {
        saveInfo()
        /*
//        self.personModel?.operatorMobile = UserInfo.getSharedInstance().mobile ?? ""
        self.personModel?.idimages = self.shenFenZhengCell.idimages
        if self.personModel?.creditCode == "" {
            
            HQGetTopVC()?.view.makeToast("请输入企业名称")
            return
        }
        if self.personModel?.creditCode == "" || (self.personModel?.creditCode.length)! < 18 {
            
            HQGetTopVC()?.view.makeToast("请输入正确18位社会信用代码")
            return
        }
       
        if self.personModel?.provinceName == "" {
            
            HQGetTopVC()?.view.makeToast("请选择省市")
            return
        }
        if self.personModel?.detailAddress == "" {
            
            HQGetTopVC()?.view.makeToast("请填写详细地址")
            return
        }
        if self.personModel?.operatorName == "" {
            
            HQGetTopVC()?.view.makeToast("请输入真实姓名")
            return
        }
        if self.personModel?.operatorIDNumber == "" || (self.personModel?.operatorIDNumber.length)! < 18 {
            
            HQGetTopVC()?.view.makeToast("请输入正确的运营者身份证号")
            return
        }
        if self.personModel?.mobile == "" || (self.personModel?.mobile.length)! < 11 {
            
            HQGetTopVC()?.view.makeToast("请输入正确的手机号")
            return
        }
        if self.personModel?.checkCode == "" || (self.personModel?.checkCode.length)! > 6 {
            
            HQGetTopVC()?.view.makeToast("请输入正确的验证码")
            return
        }
        if self.personModel?.showWords == "" {
            
            HQGetTopVC()?.view.makeToast("请您输入对外认证展示")
            return
        }
        if self.personModel?.businessLicenseImages.count == 0  {
            
            HQGetTopVC()?.view.makeToast("请您上传企业营业执照")
            return
        }
        if self.personModel?.idimages?.count == 0  {
            
            HQGetTopVC()?.view.makeToast("请您上传证件照")
            return
        }
        if self.personModel?.certificateImages?.count == 0 {
            
            HQGetTopVC()?.view.makeToast("请您上传资质照片")
            return
        }
        saveInfo()
        */
    }

}


extension SSMyCompanyProveViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            return shenFenZhengCell
        }
        
        if indexPath.section == 4 || indexPath.section == 6{
            let imgcell = tableView.dequeueReusableCell(withIdentifier: "imagesCell", for: indexPath) as! imagesCell
            imgcell.selectionStyle = .none
            imgcell.isCloseBtnHidden = false
            imgcell.currentIndexPath = indexPath
            
            imgcell.cellSelectImgBlock = {[weak self] index in
                self?.imgCellType = index.section == 4 ? 4 : 6
                self?.selectImageOrVideo(type: index.section - 1)
            }
            imgcell.closeBtnBlock = {[weak self] (section ,index) in
                
                if section.section == 4 {
                    self?.businessListIdArray.remove(at: index)
//                    self?.listTableView.reloadData()
                    self?.listTableView.reloadRows(at: [IndexPath.init(item: 0, section: 4)], with: .none)
                }else{
                    self?.imageListIdArray.remove(at: index)
                    self?.listTableView.reloadRows(at: [IndexPath.init(item: 0, section: 6)], with: .none)
                }
            }
          
            if indexPath.section == 4 {
                imgcell.tipLabel.text = "企业营业执照"
                imgcell.setReloadImgList(list: businessListIdArray)

            } else if indexPath.section == 6 {
                imgcell.setReloadImgList(list: imageListIdArray)
                imgcell.tipLabel.text = "职位/资质/称号证明（名片/工牌/授权书）"
            }
            return imgcell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "renzhenCell", for: indexPath) as! RenZhenCell
        
            cell.indexPath = indexPath
            cell.selectionStyle = .none
            cell.nameLabel.text = dataArray[indexPath.section][indexPath.row]
            cell.contentField.delegate = self
            if indexPath.section == 0 {
                cell.contentField.isHidden = false
                cell.outContent.isHidden = true
                if indexPath.row == 0 {
                    cell.contentField.placeholder = placeHolderArray[0][indexPath.row]
                    cell.contentField.text = self.personModel?.companyName
                    cell.contentField.tag = 10001  //企业名称
                } else if indexPath.row == 1 {
                    cell.contentField.placeholder = placeHolderArray[0][indexPath.row]
                    cell.contentField.text = self.personModel?.creditCode
                    cell.contentField.tag = 10002  //社会信用代码
                }
                else {
                    cell.selectText.isHidden = false
                    cell.selectText.text = "\(personModel?.provinceName ?? "")\(personModel?.cityName ?? "")"
                    cell.accessoryType = .disclosureIndicator
                    cell.contentField.isHidden = true
                }
            } else if indexPath.section == 1 {
                cell.outContent.isHidden = true
                if indexPath.row == 0 {
                    cell.contentField.isHidden = true
                } else {
                    let addressField = UITextView.init(frame: CGRect(x: 10, y: 10, width: screenWid-20, height: 70))
                    let placeHolderLabel = UILabel.init()
                    placeHolderLabel.text = "请输入"
                    placeHolderLabel.numberOfLines = 0
                    placeHolderLabel.textColor = .lightGray
                    placeHolderLabel.sizeToFit()
                    addressField.addSubview(placeHolderLabel)
                    addressField.tag = 101   //详细地址
                    addressField.delegate = self
                    addressField.font = .systemFont(ofSize: 13)
                    placeHolderLabel.font = .systemFont(ofSize: 13)
                    addressField.setValue(placeHolderLabel, forKey: "_placeholderLabel")
                    addressField.text = self.personModel?.detailAddress
                    cell.contentView.addSubview(addressField)
                }
            } else if indexPath.section == 2 {
                cell.contentField.isHidden = false
                cell.outContent.isHidden = true
                cell.contentField.placeholder = placeHolderArray[1][indexPath.row]
                if indexPath.row == 0 {
                    cell.contentField.text = self.personModel?.operatorName
                    cell.contentField.tag = 10003 //运营者姓名
                } else if indexPath.row == 1 {
                    cell.contentField.text = self.personModel?.operatorIDNumber
                    cell.contentField.tag = 10004 //身份证号
                } else if indexPath.row == 2 {
                    if personModel?.operatorMobile.count == 0 {
                        personModel?.operatorMobile = UserInfo.getSharedInstance().mobile ?? ""
                    }
                    cell.contentField.text = personModel?.operatorMobile
                    cell.contentField.isEnabled = true
                    cell.selectText.isHidden = true
                    cell.contentField.tag = 10005 //手机号
                } else if indexPath.row == 3 {
                    
                    codeBtn.frame = CGRect(x: screenWid-120, y: 10, width: 120, height: 36)
                    
                    cell.contentView.addSubview(codeBtn)
                    cell.contentField.tag = 10006 //验证码
                }else{
                    
                }
            } else if indexPath.section == 3 {
                cell.contentField.isHidden = true
                if indexPath.row == 0 {
//                    cell.accessoryType = .disclosureIndicator
//                    cell.selectText.isHidden = false
//                    cell.selectText.text = "全民形体平台"
                    cell.nameLabel.text = "对外认证展示"
                } else if indexPath.row == 1 {
                    cell.nameLabel.text = ""
                    cell.outContent.isHidden = false
//                    cell.outContent.tag = 102   //对外展示说明
//                    cell.nameLabel.isHidden = true
                    cell.contentField.isHidden = true
                    cell.outContent.text = self.personModel?.showWords
                    cell.outContentBlock = {[weak self] str in

                        self?.personModel?.showWords = str
                    }
                } else if indexPath.row == 2 {
                    cell.nameLabel.text = "示例：国际高级礼仪培训师|身所高级形体导师"
//                    cell.selectText.isHidden = true
//                    cell.contentField.isHidden = true
//                    cell.outContent.isHidden = true
//                    cell.exampleLabel.isHidden = false
//                    cell.exampleLabel.text = "示例：国际高级礼仪培训师|身所高级形体导师"
                }
                
            }
            cell.fieldChangeBlock = {[weak self] (title,indexP) in
                
                if indexP.section == 0 && indexPath.row == 0 {
                    
                    self?.personModel?.companyName = title
                    
                }else if(indexPath.section == 0 && indexPath.row == 1){
                    
                    self?.personModel?.creditCode = title
                }
                else if(indexPath.section == 1 && indexPath.row == 1){
                    
                    self?.personModel?.detailAddress = title
                }else if(indexPath.section == 2 && indexPath.row == 0){
                    
                    self?.personModel?.operatorName = title
                }
                else if(indexPath.section == 2 && indexPath.row == 1){
                    
                    self?.personModel?.operatorIDNumber = title
                }
                else if(indexPath.section == 2 && indexPath.row == 2){
                    
                    self?.personModel?.mobile = title
                }
                else if(indexPath.section == 2 && indexPath.row == 3){
                    
                    self?.personModel?.checkCode = title
                }
                else{
                    
                    self?.personModel?.mobile = title
                }
            }
            return cell
        }
        
//        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 4,6:
            return 180
        case 5:
            return shenFenZhengCell.myHei
        case 1,3:
            if indexPath.row == 1 {
                return 90
            }
            return 56
        default:
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
                dateView.buildAreaPicker()
                dateView.titleLabel.text = "请选择地区"
                dateView.selectAreaBlock = {pName, pId, cName, cId in
//                    self.userInfoModel?.province = pName
//                    self.userInfoModel?.provinceId = pId
//                    self.userInfoModel?.city = cName
//                    self.userInfoModel?.cityId = cId
        //            self.provice = pName
        //            self.proviceId = pId
        //            self.city = cName
        //            self.cityId = cId
                    let cell = self.listTableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! RenZhenCell
                    cell.selectText.isHidden = false
                    cell.selectText.text = pName+cName
                    self.personModel?.provinceName = pName
                    self.personModel?.cityName = cName
                    cell.layoutIfNeeded()

                }
                self.view.addSubview(dateView)
            }
        }
    }
    
    func sendCode() -> Void {
        self.RACTimer()
        
        UserNetworkProvider.request(.sendCode(areaCode:"86",phone:self.personModel?.operatorMobile ?? "",isReg:false)) { result in
//            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
//                            self.code.becomeFirstResponder()
                        }else{
                            
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }

    func RACTimer() {
        self.codeBtn.isUserInteractionEnabled = false
        self.second = 60
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "GCDTimer", timeInterval: 1, queue: .main, repeats: true) {
            if self.second > 0{
                self.second -= 1
                self.codeBtn.setTitle( "\(self.second)秒后重新发送", for: .normal)
            }else{
                MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
                self.codeBtn.setTitle("|获取验证码", for: .normal)
                self.codeBtn.isUserInteractionEnabled = true
            }
        }
    }
}

extension SSMyCompanyProveViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.length == 0 {
            self.view.makeToast("资料填写不完整")
            return
        }
        
        switch textField.tag {
//            case 10001:
//                self.saveModel?.companyName = textField.text!
//                break
//            case 10002:
//                self.saveModel?.creditCode = textField.text!
//                break
//            case 10003:
//                self.saveModel?.operatorName = textField.text!
//                break
//            case 10004:
//                self.saveModel?.operatorIDNumber = textField.text!
//                break
            case 10005:
                self.personModel?.operatorMobile = textField.text ?? ""
                break
            case 10006:
//                self.
                break
            default:
                break
        }
    }
}

extension SSMyCompanyProveViewController : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.tag {
            case 101:
                self.personModel?.detailAddress = textView.text
                break
            case 102:
                self.personModel?.showWords = textView.text
                break
            default:
                break
        }
    }
}
extension SSMyCompanyProveViewController: HEPhotoPickerViewControllerDelegate {
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        NSLog("%@----%@", selectedImages,selectedModel[0].asset)
        if selectedImages.count == 0 {
            
            return
        }
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
            
        if imgCellType == 4 {
            self.businessListIdArray = selectedImages
            listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4)], with: .none)
            
        }else if(imgCellType == 5){
            self.imageListArray = selectedImages
            listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5)], with: .none)


        }
        else{
            self.imageListIdArray = selectedImages
            listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6)], with: .none)


        }
            var listrray = [String]()
            var selections = [HEPhotoAsset]()
            var imageList = [UIImage]()
            
            let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
            for index in 0...selectedImages.count-1 {
                myQueue.async { [weak self] in
                    imgUpload.uploadImg((selectedImages[index]) as UIImage) { (image) in
                        listrray.append(image)
                        imageList.append(selectedImages[index])
                        selections.append(selectedModel[index])
                        if listrray.count == selectedImages.count {
                            listrray = listrray.sorted()
                            DispatchQueue.main.async { [self] in
                                
                                if self?.imgCellType == 4{
                                    
                                    self!.personModel?.businessLicenseImages = listrray
                                    self!.listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4)], with: .none)


                                }else if(self?.imgCellType == 5){
                                    
                                    self!.personModel?.idimages = listrray
                                    self!.listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5)], with: .none)

                                }
                                else{
                                    
                                    self!.personModel?.certificateImages = listrray
                                    self!.listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6)], with: .none)
                                }
//                                self!.defaultSelections = selections
                               


                            
                                NSLog("%@", listrray)
                                
                            }
                        }
                        
                        
                    } faildBlock: {
                        
                    }
            }
            
        }
        
    }
    
    func selectImageOrVideo(type: Int) {
        
        // 只能选择一个视频
        option.singleVideo = true
       
        // 将上次选择的数据传入，表示支持多次累加选择，
//                option.defaultSelections = self.selectedModel
        // 选择图片的最大个数
            
        option.maxCountOfImage = 9
            // 图片和视频只能选择一种
            option.mediaType = .image

        
        option.defaultSelections = defaultSelections
        self.imagePickerController = HEPhotoPickerViewController.init(delegate: self,options: option)
        self.hePresentPhotoPickerController(picker: (self.imagePickerController)!, animated: true)
    }
}
