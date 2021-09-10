//
//  SSMyInfoViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/17.
//

import UIKit
import MBProgressHUD
 
//个人资料
class SSMyInfoViewController: SSBaseViewController {

    var dataArray = ["头像","昵称","性别","生日","所在省市","二维码名片"]
//    var nickName:String = ""
//    var birthDay:String = ""
//    var provice:String = ""
//    var proviceId:Int = 0
//    var city:String = ""
//    var cityId:Int = 0
    var headImageName:String = ""
//    var intorduce:String = ""
    let textView = UITextView.init()
    
    
    var listTableView:UITableView = {
        let list = UITableView.init()
        return list
    }()
    
    var securityToken:String?
    var accessKeySecret:String?
    var accessKeyId:String?
    
    var dontReload = false
    var userInfoModel:SSUserInfoModel? = nil {
        didSet{
            DispatchQueue.main.async {
                if self.userInfoModel != nil && !self.dontReload {
                    self.listTableView.reloadData()
                }
                self.textView.text = self.userInfoModel?.introduce
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
        
        navView.backBtnWithTitle(title: "个人资料")
        // Do any additional setup after loading the view.
        self.buildSubViews()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = .init(hex: "#F7F8F9")
        listTableView.tableHeaderView = self.headView()
        listTableView.tableFooterView = self.footerView()
        listTableView.register(myInfoCell.self, forCellReuseIdentifier: "myInfoCell")
        
        self.getSecurtKey()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPersionInfo()
    }
    
    func loadPersionInfo() -> Void {
        UserInfoNetworkProvider.request(.getUserOneselfUpdate) { (result) in
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
                                self.userInfoModel = dic?.kj.model(SSUserInfoModel.self)
                                
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
    
    func getSecurtKey() -> Void {
        CommunityNetworkProvider.request(.getSecretKey) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            let data = dic?["credentials"] as![String:Any]
                            self.accessKeyId = data["accessKeyId"] as? String
                            self.accessKeySecret = data["accessKeySecret"] as? String
                            self.securityToken = data["securityToken"] as? String
                            
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
    
    
    func buildSubViews() -> Void {
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func headView() -> UIView {
        let headV = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 12))
        headV.backgroundColor = .init(hex: "#F7F8F9")
        return headV
    }

    func footerView() -> UIView {
        let footerV = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 360))
        
        
        
        let tipView = UIView.init(frame: CGRect(x: 0, y: 12, width: screenWid, height: 200))
        tipView.backgroundColor = UIColor.init(hex: "#FFFFFF")
        footerV.addSubview(tipView)
        
        let tipLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: 100, height: 56))
        tipLabel.font = .systemFont(ofSize: 16)
        tipLabel.textAlignment = .left
        tipLabel.textColor = .init(hex: "#333333")
        tipLabel.text = "简介"
        tipView.addSubview(tipLabel)
        
        let lineV = UIView.init(frame: CGRect(x: 10, y: tipLabel.frame.maxY, width: screenWid-20, height: 1))
        lineV.backgroundColor = .init(hex: "#EEEFF0")
        tipView.addSubview(lineV)
        
        textView.frame = CGRect(x: 10, y: lineV.frame.maxY, width: screenWid-20, height: 120)
  
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .init(hex: "#999999")
        
        let placeHolderLabel = UILabel.init()
        placeHolderLabel.text = "个人介绍信息"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        textView.addSubview(placeHolderLabel)

        placeHolderLabel.font = .systemFont(ofSize: 16)
        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        textView.delegate = self
        textView.text = self.userInfoModel?.introduce
        tipView.addSubview(textView)
        
        let saveBtn = UIButton.init(frame: CGRect(x: 10, y: tipView.frame.maxY+85, width: screenWid-20, height: 45))
        saveBtn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.backgroundColor = UIColor.init(hex: "#FD8024")
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 24
        saveBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.textView.resignFirstResponder()
            self.saveInfo()
        }
        footerV.addSubview(saveBtn)
        
        
        return footerV
    }
    
    @objc func popVC() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveInfo() -> Void {
//        UserInfoNetworkProvider.request(.setUserOneselfUpdate(birthday: self.birthDay, city: self.city, cityId: self.cityId, headImage: self.headImageName, introduce: self.intorduce, nickName: self.nickName, province: self.provice, provinceId: self.proviceId))
        
        let cell = self.listTableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! myInfoCell
        self.userInfoModel?.sex = cell.boyBtn.isSelected ? 1 : 0
        
        if self.headImageName.length > 0 {
            self.userInfoModel?.headImage = self.headImageName
        }
        UserInfoNetworkProvider.request(.setUserOneselfUpdate(model: self.userInfoModel!)){ (result) in
            switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
//                                let dic = model?.data
//                                if dic == nil {
//                                    return
//                                }
                                
                                self.perform(#selector(self.popVC), with: self, afterDelay: 2)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSMyInfoViewController:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.dontReload = true
        self.userInfoModel?.introduce = textView.text
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        self.userInfoModel?.introduce = textView.text
//        return true
//    }
}

class myInfoCell: UITableViewCell {
    
    var updateNickNameBlock : stringBlock? = nil
    var headImageBlock : stringBlock? = nil
    var headerImage:UIImage? = nil
    
    var titleLabel:UILabel = {
        let title = UILabel.init()
        title.textAlignment = .left
        title.textColor = .init(hex: "#333333")
        title.font = .systemFont(ofSize: 16)
        return title
    }()
    
    var headImage:UIImageView? = nil
    
    var nickNameTF:UITextField = {
        let nickName = UITextField.init()
        nickName.textColor = .init(hex: "#999999")
        nickName.font = .systemFont(ofSize: 16)
        nickName.placeholder = "昵称"
        return nickName
    }()
    
    
    var girlBtn:UIButton = {
        let gBtn = UIButton.init()
        gBtn.setImage(UIImage.init(named: "my_btnNormal"), for: .normal)
        gBtn.setImage(UIImage.init(named: "my_btnSelect"), for: .selected)
        gBtn.setTitle("女", for: .normal)
        gBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        gBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        gBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        gBtn.titleLabel?.font = .systemFont(ofSize: 16)
        return gBtn
    }()
    
    var boyBtn:UIButton = {
        let bBtn = UIButton.init()
        bBtn.setImage(UIImage.init(named: "my_btnNormal"), for: .normal)
        bBtn.setImage(UIImage.init(named: "my_btnSelect"), for: .selected)
        bBtn.setTitle("男", for: .normal)
        bBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        bBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        bBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        bBtn.titleLabel?.font = .systemFont(ofSize: 16)
        return bBtn
    }()
    
    var birthDayLabel:UILabel = {
        let birthDay = UILabel.init()
        birthDay.textAlignment = .right
        birthDay.textColor = UIColor.init(hex: "#999999")
        birthDay.font = .systemFont(ofSize: 16)
        birthDay.text = "1994-05-15"
        return birthDay
    }()
    
    var addressLabel:UILabel = {
        let address = UILabel.init()
        address.textAlignment = .right
        address.textColor = UIColor.init(hex: "#999999")
        address.font = .systemFont(ofSize: 16)
        address.text = "广东省广州市"
        return address
    }()
    
    var erweimaImageV:UIImageView = {
        let erweima = UIImageView.init()
        erweima.image = UIImage.init(named: "my_erweima")
        return erweima
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.buildUI()
    }
    
    func buildUI() -> Void {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(22)
        }
    }
    
    func buildHeadImage(image:String) -> Void {
        
        
        if headerImage != nil {
            headImage?.image = headerImage
        } else {
            headImage = UIImageView()
            headImage?.layer.cornerRadius = 30
            headImage?.layer.masksToBounds = true
            contentView.addSubview(headImage!)
            headImage!.kf.setImage(with: URL.init(string: image), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
            headImage?.snp.makeConstraints { (make) in
                make.right.equalTo(-5)
                make.height.width.equalTo(60)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    func buildNickName(name:String) -> Void {
        if nickNameTF.superview == nil {
            contentView.addSubview(nickNameTF)
            nickNameTF.delegate = self
            nickNameTF.snp.makeConstraints { (make) in
                make.right.equalTo(-10)
                make.centerY.equalToSuperview()
            }
        }
        nickNameTF.text = name
        
    }
    
    func buildSexButton(isBoy:Bool) -> Void {
        contentView.addSubview(boyBtn)
        boyBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        
        contentView.addSubview(girlBtn)
        girlBtn.snp.makeConstraints { (make) in
            make.right.equalTo(boyBtn.snp.left)
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        if isBoy {
            boyBtn.isSelected = true
            girlBtn.isSelected = false
        } else {
            girlBtn.isSelected = true
            boyBtn.isSelected = false
        }
        
        girlBtn.addTarget(self, action: #selector(clickGirlBtn(btn:)), for:.touchUpInside)
        
        boyBtn.addTarget(self, action: #selector(clickBoyBtn(btn:)), for: .touchUpInside)

    }
    
    @objc func clickBoyBtn(btn:UIButton) -> Void {
        btn.isSelected = !btn.isSelected
        girlBtn.isSelected = !girlBtn.isSelected
    }
    
    @objc func clickGirlBtn(btn:UIButton) -> Void {
        btn.isSelected = !btn.isSelected
        boyBtn.isSelected = !boyBtn.isSelected
    }
    
    func buildBirthDay(birty: String) -> Void {
        contentView.addSubview(birthDayLabel)
        birthDayLabel.text = birty
        birthDayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.height.equalTo(22)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
    }
    
    func buildAddress(address:String) -> Void {
        contentView.addSubview(addressLabel)
        addressLabel.text = address
        addressLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.height.equalTo(22)
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
        }
    }
    
    func buildErweima() -> Void {
        contentView.addSubview(erweimaImageV)
        erweimaImageV.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension myInfoCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.updateNickNameBlock != nil {
            self.updateNickNameBlock!(textField.text ?? "")
        }
    }
}

extension SSMyInfoViewController:UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 87
        }
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myInfoCell", for: indexPath) as! myInfoCell
        cell.titleLabel.text = dataArray[indexPath.row]
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.accessoryType = .disclosureIndicator
            cell.buildHeadImage(image: self.userInfoModel?.headImage ?? "")
        } else if indexPath.row == 1 {
            cell.buildNickName(name: self.userInfoModel?.nickName ?? "")
            cell.updateNickNameBlock = { nick in
                self.userInfoModel?.nickName = nick
            }
        } else if indexPath.row == 2 {
            cell.buildSexButton(isBoy: self.userInfoModel?.sex == 1 ? true : false)
            cell.isUserInteractionEnabled = true
        } else if indexPath.row == 3 {
            cell.accessoryType = .disclosureIndicator
            cell.buildBirthDay(birty: self.userInfoModel?.birthday ?? "")
        } else if indexPath.row == 4 {
            cell.accessoryType = .disclosureIndicator
            cell.buildAddress(address: String(format: "%@%@", self.userInfoModel?.province ?? "", self.userInfoModel?.city ?? ""))
        } else if indexPath.row == 5 {
            cell.accessoryType = .disclosureIndicator
            cell.buildErweima()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                self.showHeadImagePicker()
                break
            case 1:
                
                break
            
            case 3:
                self.showDatePick()
                break
            case 4:
                self.showAddressPick()
                break
            case 5:
                
                let vc = ShareVC()
                vc.setupMainView()
                HQPush(vc: vc, style: .default)
//                self.navigationController?.pushViewController(SSMyEeweimaViewController(), animated: true)
                break
                
            default:
//                self.showDatePick()
                break
        }
        
    }
    
    func showDatePick() -> Void {
        
        let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        dateView.buildDatePicker()
        dateView.selectDateBlock = {date in
            let cell = self.listTableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! myInfoCell
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
//            self.birthDay = formatter.string(from: date)
//            cell.birthDayLabel.text = self.birthDay
            self.userInfoModel?.birthday = formatter.string(from: date)
            cell.layoutIfNeeded()
            
        }
        dateView.titleLabel.text = "请选择出生日期"
        self.view.addSubview(dateView)
    }
    
    func showAddressPick() -> Void {
        let dateView = SSPopDialogView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        dateView.buildAreaPicker()
        dateView.titleLabel.text = "请选择地区"
        dateView.selectAreaBlock = {pName, pId, cName, cId in
            self.userInfoModel?.province = pName
            self.userInfoModel?.provinceId = pId
            self.userInfoModel?.city = cName
            self.userInfoModel?.cityId = cId
//            self.provice = pName
//            self.proviceId = pId
//            self.city = cName
//            self.cityId = cId
            let cell = self.listTableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! myInfoCell
            cell.addressLabel.text = pName+cName
            cell.layoutIfNeeded()
            
        }
        self.view.addSubview(dateView)
    }
    
    func showHeadImagePicker() -> Void {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction.init(title: "相册", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction.init(title: "相机", style: .destructive) { (action) in
            let isCamera = UIImagePickerController.isCameraDeviceAvailable(.rear)
            if !isCamera { return self.view.makeToast("没有摄像头")}
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension SSMyInfoViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = editedImage ?? originalImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        let indexpath = IndexPath.init(row: 0, section: 0)
        let cell = listTableView.cellForRow(at: indexpath) as! myInfoCell
        cell.headImage?.image = image
        self.uploadHeadImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadHeadImage(image:UIImage) -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = self.accessKeyId ?? ""
        imgUpload.securityToken = self.securityToken ?? ""
        imgUpload.secretKeyId = self.accessKeySecret ?? ""
        
        DispatchQueue.main.async {
            imgUpload.uploadImg(image) { (imgName) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.dontReload = true
                self.headImageName = imgName
                self.userInfoModel?.headImage = imgName
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dontReload = false
                }
            } faildBlock: {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.view.makeToast("上传头像失败,请重新上传")
            }
        }
    }
    
}
