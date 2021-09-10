//
//  SSMyRenZhenViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/26.
//

import UIKit
import HEPhotoPicker

//个人认证
class SSMyPersonalProveViewController: MyProveViewController {
    
    var cid : String = ""
    var photoPickerViewController: HEPhotoPickerViewController?
    let pickerOptions = HEPickerOptions()
    var defaultSelections = [HEPhotoAsset]()
    let sskey = SSCustomgGetSecurtKey()
    //身份证图片
    var imageListIdArray : [UIImage] = []
    //资质素组
    var imageListArray : [UIImage] = []
    var dataArray = [["真实姓名","身份证号","手机号"],["所属认证企业","对外认证展示","",""],["身份证正反面"],["职位/资质/称号证明(名片/工牌/授权书)"]]
    var placeHolderArray = ["请输入真实姓名","请输入身份证号","请输入手机号"]
    
    
    
    var type: Int = 0              // 0: 身份认证页跳转 1: 认证成功页跳转
    var companyIdModel: SSCompanyIdModel?
    //1:身份证 2: 资质
    var imgCellType: Int = 1
    
    override var personModel:SSPersonModel? {
        didSet{
            guard personModel != nil else { return }
            guard personModel?.certificateImages != nil else { return }
            guard personModel?.certificateImages?.count != 0 else { return }
            guard self.imageListArray.count == 0 else { return }
            self.setImgImage(list: personModel!.certificateImages!, type: 0)
        }
    }
    var listArray: [SSCompanyIdModel]?
    var searchKey: String = ""
    
    /// 业主公司选择视图
    let ownerCompanySelectorView = SSOwnerCompanyIdView.init(frame: UIApplication.shared.keyWindow!.bounds)
    /// 身份证cell
    let shenFenZhengCell = SSShenfenzhengCell(style: .default, reuseIdentifier: "")
    
    /// Table View
    var listTableView:UITableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ishideBar = true
        navView.backBtnWithTitle(title: "个人认证")
        // Do any additional setup after loading the view.
        
        // shenFenZhengCell
        shenFenZhengCell.delegate = self
        
        // listTableView
        listTableView.backgroundColor = .init(hex: "#F7F8F9")
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableHeaderView = nil
        listTableView.tableFooterView = tableFooterView()
        listTableView.register(RenZhenCell.self, forCellReuseIdentifier: "renzhenCell")
        listTableView.register(imagesCell.self, forCellReuseIdentifier: "imagesCell")
        
        func tableHeaderView() -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWid, height: 50))
            view.backgroundColor = .init(hex: 0xFD8024)
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: screenWid-32, height: 50))
            label.numberOfLines = 2
            label.text = "进行个人认证前，请先确保自己所属企业已通过企业认证，若无所属企业请选择“全民形体平台”。"
            label.textColor = .init(hex: 0xFFFFFF)
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .justified
            view.addSubview(label)
            return view
        }
        
        func tableFooterView() -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWid, height: 160))
            let btn = UIButton(frame: CGRect(x: 16, y: 44, width: screenWid-32, height: 45))
            btn.setBackgroundImage(UIColor(hex: 0xFD8024).image(), for: .normal)
            btn.setBackgroundImage(UIColor(hex: 0xFD8024).image(), for: .highlighted)
            // 圆角
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 22
            // title
            btn.setTitle("立即认证", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18)
            btn.titleLabel?.textColor = .white
            // Action
            /// checkSave()
//            btn.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
            btn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
                self.submitForm()
            }
            // 默认,不可点击
//            btn.isEnabled = false
            
            view.addSubview(btn)
            return view
        }
        
        let topView = tableHeaderView()
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(navView.snp.bottom)
        }
        
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.bottom.width.equalToSuperview()
//            make.top.equalTo(navView.snp.bottom)
            make.top.equalTo(topView.snp.bottom)
        }
        
        
        // 请求数据
        loadCompanyData()
        
        // 获取签名
        sskey.getSecurtKey()
        
        switch type {
        case 0:
            personModel = SSPersonModel()
            personModel?.mobile = UserInfo.getSharedInstance().mobile ?? ""
        case 1:
            loadData()
        default:
            loadData()
        }
    }
    
    func setImgImage(list: [String],type: Int){
        self.imageListArray.removeAll()
        for index in 0..<list.count {

            let img = UIImageView.init()
            img.kf.setImage(with: URL(string: list[index])) { res in
                do{
                    self.imageListArray.append(try res.get().image)
                }catch {
                    
                }
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        }
    }
    
    /// 提交表单
    @objc func submitForm()  {
        guard let model = personModel else { return }
        sendForm(model: model)
        
        /*      表单校验
        DispatchQueue.main.async { [self] in
            if self.personModel?.idimages?.count == 0 && self.shenFenZhengCell.idimages[0] != "-1"{
                self.personModel?.idimages = self.shenFenZhengCell.idimages
            }
            
            if self.personModel?.idname == "" {
                HQGetTopVC()?.view.makeToast("请输入您的姓名")
                return
            }
            
            if self.personModel?.idnumber == "" || (self.personModel?.idnumber.length)! < 18 {
                HQGetTopVC()?.view.makeToast("请您输入正确的身份证号码")
                return
            }
            if self.personModel?.mobile == "" || (self.personModel?.mobile.length)! < 11 {
                
                HQGetTopVC()?.view.makeToast("请输入正确的手机号")
                return
            }
            if self.personModel?.companyName == "" {
                
                HQGetTopVC()?.view.makeToast("请您选择认证机构")
                return
            }
            if self.personModel?.showWords == "" {
                
                HQGetTopVC()?.view.makeToast("请您输入对外认证展示")
                return
            }
            guard let str1 = self.personModel?.idimages?[0], str1 != "-1",
                  let str2 = self.personModel?.idimages?[1], str2 != "-1" else {
                HQGetTopVC()?.view.makeToast("请您上传证件照")
                return
            }
            if self.personModel?.certificateImages?.count == 0 {
                
                HQGetTopVC()?.view.makeToast("请您上传资质照片")
                return
            }
            self.personModel?.certificationId = self.cid
            self.saveInfo()
        }
         */
    }
    
    /// 发送表单
    func sendForm(model: SSPersonModel) {
        UserInfoNetworkProvider.request(.applyPersonal(personModel: model)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let vc = SSProveSuccessController()
                            vc.inType = 1
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

    
    func loadData() -> Void {
        UserInfoNetworkProvider.request(.personalDetail(cid: cid)) { (result) in
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
                            
                            self.listTableView.reloadData()
                            
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
    
    func loadCompanyData()  {
        
        UserInfoNetworkProvider.request(.getCompanyList(title: searchKey)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let arr = model?.data?.kj.modelArray(SSCompanyIdModel.self)
                            
                            if arr == nil {
                                return
                            }
                            self.listArray = arr
                            self.ownerCompanySelectorView.listArray = arr
                            //                                self.bgV.tableView.reloadData()
                            
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
    
    func openPhotoPicker() {
        /// 设置 Picker Options
        // 是否支持视频单选 默认是false，如果是ture只允许选择一个视频（如果 mediaType = imageAndVideo 此属性无效）
        pickerOptions.singleVideo = true
        // 挑选图片的最大个数
        pickerOptions.maxCountOfImage = 9
        // 要挑选的数据类型
        pickerOptions.mediaType = .image
        // 实现多次累加选择时，需要传入的选中的模型。为空时表示不需要多次累加
        pickerOptions.defaultSelections = defaultSelections
        
        /// photoPickerViewController
        photoPickerViewController = HEPhotoPickerViewController(delegate: self,options: pickerOptions)
        
        /// 跳转 photoPickerViewController
        hePresentPhotoPickerController(picker: photoPickerViewController!, animated: true)
    }
}

// MARK: - TableView Delegate DataSource
extension SSMyPersonalProveViewController : UITableViewDelegate, UITableViewDataSource {
    
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "renzhenCell", for: indexPath) as! RenZhenCell
            cell.selectionStyle = .none
            cell.nameLabel.text = dataArray[indexPath.section][indexPath.row]
            cell.indexPath = indexPath
            cell.contentField.placeholder = placeHolderArray[indexPath.row]
            cell.contentField.isUserInteractionEnabled = true
            switch indexPath.row {
            case 0:
                cell.contentField.text = personModel?.idname
                cell.fieldChangeBlock = {[weak self] (title,indexP) in
                    self?.personModel?.idname = title
                }
            case 1:
                cell.contentField.text = personModel?.idnumber
                cell.fieldChangeBlock = {[weak self] (title,indexP) in
                    self?.personModel?.idnumber = title
                }
            case 2:
                cell.contentField.text = personModel?.mobile
//                personModel?.mobile = UserInfo.getSharedInstance().mobile ?? ""
//                cell.contentField.text = UserInfo.getSharedInstance().mobile
                cell.fieldChangeBlock = {[weak self] (title,indexP) in
                    self?.personModel?.mobile = title
                }
            default:
                return cell
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "renzhenCell", for: indexPath) as! RenZhenCell
            cell.selectionStyle = .none
            cell.nameLabel.text = dataArray[indexPath.section][indexPath.row]
            cell.contentField.removeFromSuperview()
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
                cell.selectText.isHidden = false
                cell.selectText.text = personModel?.companyName
            } else if indexPath.row == 2 {
                cell.outContentBlock = {[weak self] str in
                    self?.personModel?.showWords = str
                }
                cell.outContent.isHidden = false
                cell.nameLabel.isHidden = true
                cell.contentField.isHidden = true
                cell.outContent.text = personModel?.showWords
            } else if indexPath.row == 3 {
                cell.nameLabel.isHidden = true
                cell.selectText.isHidden = true
                cell.contentField.isHidden = true
                cell.outContent.isHidden = true
                cell.exampleLabel.isHidden = false
                cell.exampleLabel.text = "示例：国际高级礼仪培训师|身所高级形体导师"
            }
            return cell
        case 2:
            // 身份证 Cell
            return shenFenZhengCell
        case 3:
            // 图片 Cell
            let imgcell = tableView.dequeueReusableCell(withIdentifier: "imagesCell", for: indexPath) as! imagesCell
            imgcell.currentIndexPath = indexPath
            imgcell.cellSelectImgBlock = {[weak self] index in
                self?.imgCellType = 2
                self?.openPhotoPicker()
            }
            imgcell.closeBtnBlock = {[weak self] (section ,index) in
                self?.imageListArray.remove(at: index)
                self?.listTableView.reloadRows(at: [IndexPath.init(item: 0, section: 3)], with: .none)
            }
            imgcell.selectionStyle = .none
            imgcell.setReloadImgList(list: imageListArray)
            imgcell.tipLabel.text = "职位/资质/称号证明（名片/工牌/授权书）"
            imgcell.imageList.vc = self
            return imgcell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if indexPath.row == 2 {
                return 90
            }
            return 56
        case 2:
            return shenFenZhengCell.myHei
        case 3:
            return 200
        default:
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                ownerCompanySelectorView.listArray = listArray
                ownerCompanySelectorView.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.5)
                UIApplication.shared.keyWindow?.addSubview(ownerCompanySelectorView)
                ownerCompanySelectorView.sureBlock = {[weak self] index in
                    
                    if self?.listArray?.count == 0 {
                        
                        HQGetTopVC()?.view.makeToast("请选择所属企业")
                        return
                    }
                    if index > self?.listArray?.count ?? 0 - 1 {
                        
                        return
                    }
                    self?.companyIdModel = self?.listArray?[index]
                    self?.ownerCompanySelectorView.removeFromSuperview()
                    self?.personModel?.companyName = self?.companyIdModel?.companyName ?? ""
                    self?.personModel?.ownerCompanyId = self?.companyIdModel?.companyId ?? ""
                    self?.listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
                }
                ownerCompanySelectorView.searchBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
                    self?.ownerCompanySelectorView.selectIndex = 0
                    self?.searchKey = self?.ownerCompanySelectorView.searchTf.text ?? ""
                    self?.loadCompanyData()
                })
            default:
                return
            }
        default:
            return
        }
    }
    
}

// MARK: - HEPhotoPickerViewControllerDelegate
extension SSMyPersonalProveViewController: HEPhotoPickerViewControllerDelegate {
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        print(selectedImages,"----",selectedModel[0].asset)
        
        guard selectedImages.count > 0 else { return }
        
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
        
        switch imgCellType {
        case 1:     // 身份证
            imageListIdArray = selectedImages
            listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none) // 刷新 row cell
        case 2:     // 资质
            imageListArray = selectedImages
            listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 3)], with: .none)
        default:
            return
        }
        
        var listrray:[String] = []
        var imageList: [UIImage] = []
        var selections: [HEPhotoAsset] = []
        
        let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        
        for i in 0..<selectedImages.count {
            myQueue.async { [weak self] in      // 异步
                // 上传照片
                imgUpload.uploadImg((selectedImages[i])) { image in
                    //
                    listrray.append(image)
                    imageList.append(selectedImages[i])
                    selections.append(selectedModel[i])
                    //
                    if listrray.count == selectedImages.count {
                        listrray = listrray.sorted()
                        // 主线程执行
                        DispatchQueue.main.async { [self] in
                            guard let self = self else { return }
                            switch self.imgCellType {
                            case 1:     // 身份证
                                self.personModel?.idimages = listrray
                                self.defaultSelections = selections
                                self.listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
                            case 2:     // 资质
                                self.personModel?.certificateImages = listrray
                                self.defaultSelections = selections
                                self.listTableView.reloadRows(at: [IndexPath.init(row: 0, section: 3)], with: .none)
                            default:
                                return
                            }
                            print("############",listrray,"############")
                        }
                    }
                } faildBlock: {
                    
                }
            }
        }
    }
}

typealias contentChangeBlock = (_ str : String,_ indexPath : IndexPath)->()


// MARK: - RenZhenCell
class RenZhenCell: UITableViewCell,UITextFieldDelegate,UITextViewDelegate{
    
    var fieldChangeBlock: contentChangeBlock?
    var outContentBlock: stringBlock?
    var personModel:SSPersonModel? = nil{
        
        didSet{
            
            if personModel != nil {
                
                if indexPath?.section ==  0 && indexPath?.row == 0{
                    
                    self.contentField.text = personModel?.idname
                }else if(indexPath?.section ==  0 && indexPath?.row == 1){
                    
                    self.contentField.text = personModel?.idnumber
                    
                }
                else if(indexPath?.section ==  0 && indexPath?.row == 2){
                    
                    self.contentField.text = UserInfo.getSharedInstance().mobile
                    
                }
                else if(indexPath?.section == 1 && indexPath?.row == 0){
                    
                    self.selectText.text = personModel?.companyName
                }else if(indexPath?.section == 0){
                    
                    
                }
            }
        }
    }
    var indexPath: IndexPath? = nil{
        
        didSet {
            
            if indexPath != nil  {
//                contentField.isUserInteractionEnabled = (indexPath?.row == 2 && UserInfo.getSharedInstance().mobile != nil && UserInfo.getSharedInstance().mobile != "") ? false : true
                if indexPath?.row == 2 {
                    
                    contentField.text = UserInfo.getSharedInstance().mobile
                }
            }
        }
    }
    var nameLabel:UILabel = {
        let name = UILabel.init()
        name.textAlignment = .left
        name.font = .systemFont(ofSize: 16)
        name.textColor = .init(hex: "#333333")
        return name
    }()
    
    var contentField:UITextField = {
        let content = UITextField.init()
        return content
    }()
    
    var selectText:UILabel = {
        let select = UILabel.init()
        select.textAlignment = .right
        select.font = .systemFont(ofSize: 16)
        select.textColor = .init(hex: "#333333")
        return select
    }()
    
    var outContent:UITextView = {
        let com = UITextView.init()
        var placeHolderLabel = UILabel.init()
        placeHolderLabel.text = "请输入对外认证展示说明，建议填写职位/资质/称号等相关名称，最长30字。"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        com.addSubview(placeHolderLabel)
        
        com.font = .systemFont(ofSize: 13)
        placeHolderLabel.font = .systemFont(ofSize: 13)
        com.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
        return com
    }()
    
    var exampleLabel:UILabel = {
        let example = UILabel.init()
        example.font = .systemFont(ofSize: 13)
        example.textAlignment = .left
        example.textColor = .init(hex: "#333333")
        return example
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.height.equalTo(30)
            make.width.equalTo(106)
        }
        
        contentView.addSubview(contentField)
        
        
        contentField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(138)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-10)
        }
        contentField.delegate = self
        contentField.reactive.controlEvents(.editingChanged).observe({[weak self] contentField in
            
            if self?.indexPath?.section == 0 && self?.indexPath?.row == 0{
                
                if self?.contentField.text?.length ?? 0 > 15 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 15))!
                }
                
            }else if(self?.indexPath?.section == 0 && self?.indexPath?.row == 1){
                
                if self?.contentField.text?.length ?? 0 > 18 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 18))!
                }
            }else if(self?.indexPath?.section == 0 && self?.indexPath?.row == 2){
                
                if self?.contentField.text?.length ?? 0 > 11 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 11))!
                }
            }else if(self?.indexPath?.section == 1 && self?.indexPath?.row == 1){
                
                if self?.contentField.text?.length ?? 0 > 30 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 30))!
                }
            }
            else if(self?.indexPath?.section == 2 && self?.indexPath?.row == 0){
                
                if self?.contentField.text?.length ?? 0 > 15 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 15))!
                }
            }
            else if(self?.indexPath?.section == 2 && self?.indexPath?.row == 1){
                
                if self?.contentField.text?.length ?? 0 > 18 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 18))!
                }
            }else if(self?.indexPath?.section == 2 && self?.indexPath?.row == 2){
                
                if self?.contentField.text?.length ?? 0 > 11 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 11))!
                }
            }else if(self?.indexPath?.section == 2 && self?.indexPath?.row == 3){
                
                if self?.contentField.text?.length ?? 0 > 6 {
                    
                    self?.contentField.text! = (self?.contentField.text!.subString(to: 6))!
                }
            }
            //            else if(self?.indexPath?.section == 1 && self?.indexPath?.row == 0){
            //
            //                if self?.contentField.text?.length ?? 0 > 30 {
            //
            //                    self?.contentField.text! = (self?.contentField.text!.subString(to: 30))!
            //                }
            //            }
            
            self?.fieldChangeBlock?(self?.contentField.text ?? "",(self?.indexPath!)!)
        })
        contentView.addSubview(selectText)
        selectText.textAlignment = .right
        selectText.isHidden = true
        selectText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(22)
            //            make.width.equalTo(160)
        }
        
        contentView.addSubview(outContent)
        outContent.isHidden = true
        outContent.delegate = self
        outContent.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
        
        contentView.addSubview(exampleLabel)
        exampleLabel.isHidden = true
        exampleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.length > 30 {
            
            textView.text = textView.text.subString(to: 30)
            
        }
        outContentBlock?(textView.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
typealias imagesSelectBlock = (_ indexPath : IndexPath)->()
typealias cellCloseBtnBlock = (_ indexPath : IndexPath,_ index: Int)->()

class imagesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SSListImagesCell.self), for: indexPath) as! SSListImagesCell
        cell.index = indexPath.item
        cell.imageContent = listArray[indexPath.item]
//        if indexPath.row == listArray.count - 1 && isCloseBtnHidden {
//            cell.closeBtnHidden = true
//        }else{
//            cell.closeBtnHidden = false
//        }
//        cell.closeBtnBlock = {[weak self] index in
//            self?.closeBtnBlock?((self?.currentIndexPath)!,index)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentIndexPath = currentIndexPath else { return }
        cellSelectImgBlock?(currentIndexPath)
    }
    
    var tipLabel:UILabel = {
        let tip = UILabel.init()
        tip.textAlignment = .left
        tip.textColor = .init(hex: "#333333")
        tip.font = .systemFont(ofSize: 16)
        return tip
    }()
    
    var imageList:HQImageListView = {
        let images = HQImageListView.init()
        images.hasAdd = true
        images.hasDel = true
        images.makeSubViews()
        return images
    }()
    var currentIndexPath: IndexPath?
    var isCloseBtnHidden: Bool = true
    var cellSelectImgBlock: imagesSelectBlock?
    
    var listArray = [UIImage.init(named: "check_addbtn_icon")]
    var collectionView:UICollectionView!
    var closeBtnBlock: cellCloseBtnBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        
        isCloseBtnHidden = true
        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.height.equalTo(22)
            make.width.equalTo(screenWid-20)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = .init(width: 90, height: 90)
        layout.sectionInset = .init(top: 10, left: 16, bottom: 10, right: 16)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SSListImagesCell.self, forCellWithReuseIdentifier: String(describing: SSListImagesCell.self))
        collectionView.backgroundColor = .white
        layout.scrollDirection = .horizontal
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tipLabel.snp.bottom).offset(10)
            make.width.equalTo(screenWid-20)
            make.height.equalTo(112)
        }
    }
    
    func setReloadImgList(list: [UIImage]) {
        
        if listArray.count > 1 {
            listArray.removeAll()
            listArray.append(UIImage.init(named: "check_addbtn_icon"))
            
        }
        if list.count == 0 {
            isCloseBtnHidden = true
            listArray[0] = UIImage.init(named: "check_addbtn_icon")
            collectionView.reloadData()
            return
        }
        listArray = list
        if currentIndexPath?.section == 2 {
            
            if list.count < 4 {
                
                listArray.insert(UIImage.init(named: "check_addbtn_icon"), at: list.count)
                isCloseBtnHidden = true
                
            }else{
                
                isCloseBtnHidden = false
                
            }
        }
        if currentIndexPath?.section == 3 || currentIndexPath?.section == 4 || currentIndexPath?.section == 5 || currentIndexPath?.section == 6  {
            
            if list.count < 9 {
                
                listArray.insert(UIImage.init(named: "check_addbtn_icon"), at: list.count)
                isCloseBtnHidden = true
                
            }else{
                
                isCloseBtnHidden = false
                
            }
        }
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
