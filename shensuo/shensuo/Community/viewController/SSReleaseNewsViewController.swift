//
//  SSReleaseNewsViewController.swift
//  shensuo
//
//  Created by swin on 2021/3/27.
//


//MARK: 发布动态页面
import Foundation
import SnapKit
import AMapLocationKit
import CoreLocation
import ImagePicker
import HEPhotoPicker
import AVKit
import Photos


class SSReleaseNewsViewController: SSBaseViewController {
    
    
    var detalisModel = CourseDetalisModel()
    var stepList = [CourseStepListModel]()
    var notesDetaile: SSNotesDetaileModel?{
        didSet{
            self.noteType = notesDetaile?.type ?? 2
        }
    }
    var shareImg: UIImage?
    var isToPreView = false
    
    ///1.完成课程 2.完成课程小节 3.开通vip 4.完成方案 5.完成方案小节 6:动态详情 7: 草稿箱 8:开通会员成功
    var inType = 0{
        didSet{
            
            if inType == 0 {
                
                releaseModel.title = detalisModel.title ?? ""
                releaseModel.headImageName = detalisModel.headerImage ?? ""
                releaseModel.content = ""
                //                releaseModel.imageNames = de
                //                releaseModel.address = detalisModel.address
                //                releaseModel.cityName = ""
                //                releaseModel.videoName = detalisModel.videoUrl
                //                releaseModel.musicUrl = detalisModel.musicUrl
                
            }else if(inType == 6 || inType == 7){
                
                releaseModel.title = notesDetaile?.title ?? ""
                releaseModel.headImageName = notesDetaile?.headerImageUrl ?? ""
                releaseModel.content = notesDetaile?.content ?? ""
                releaseModel.imageNames = notesDetaile?.imageUrls ?? []
                releaseModel.address = notesDetaile?.address ?? ""
                releaseModel.cityName = ""
                releaseModel.videoName = notesDetaile?.videoUrl ?? ""
                releaseModel.musicUrl = notesDetaile?.musicUrl ?? ""
                releaseModel.id = notesDetaile?.id ?? ""
            }else if(inType == 8){
                
                releaseModel.shareImg = shareImg
                releaseModel.locationImg = shareImg
                releaseModel.noteType = 2
                releaseModel.locationImgs.append(shareImg!)
                
            }
            
            else{
                
            }
        }
    }
    var releaseModel = SSReleaseModel()
    var tableView: UITableView!
    var locationManager: AMapLocationManager!
    var geocode = CLGeocoder.init()
    var bgV: UIView?
    var imagePickerController: HEPhotoPickerViewController!
    let sskey = SSCustomgGetSecurtKey()
    var noteType: Int = 2{
        didSet{
            botCell.isVideo = noteType == 1
        }
    }
    
    let botCell = SSReleaseBottomCell.init(style: .default, reuseIdentifier: "")
    let option = HEPickerOptions.init()
    var defaultSelections = [HEPhotoAsset]()
    var imageListArray : [UIImage] = []
    var fullView: FullScreenImageListView?
    var isEdit = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sskey.getSecurtKey()
        buildUI()
        navView.backBtnWithTitle(title: "发布动态")
        self.dontBack = true
        navView.backBtn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] btn in
            if self?.releaseModel.title != "" && (self?.releaseModel.imageNames.count != 0 || self?.releaseModel.videoName != "") {
                self?.showBottomAlert()
                return
            }
            self?.navigationController?.popViewController(animated: false)
        }

        ///上传事件
        HQPushActionWith(name: "view_edit_note", dic: ["publish_method" : self.noteType == 1 ? "视频" : "图文"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HQGetTopVC()?.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){
//        if self.isShowBottomAlert {
//            return
//        }
//        self.isShowBottomAlert = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.isShowBottomAlert = false
//        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        let disAgree = UIAlertAction(title:"不保存", style: .default)
        {[weak self]
            action in
            self?.navigationController?.popViewController(animated: false)
        }
        
        let save = UIAlertAction(title:"保存并退出", style: .default)
        {[weak self]
            action in
            self?.loadDraftSaveData()
        }
        alertController.addAction(cancel)
        alertController.addAction(save)
        alertController.addAction(disAgree)
        
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
    
    func buildUI() {
        
        buildTableView()
        buildBottomV()
    }
    
    func buildBottomV()  {
        
        
        let bottomV = SSReleaseBottomView()
        
        self.view.addSubview(bottomV)
        
        bottomV.frame = CGRect(x: 0, y:tableView.frame.maxY, width:screenWid, height: 87.5 + SafeBottomHei)
        bottomV.buildUI(str: "保存草稿", icon: "icon-caogaoxiang", iconW: 15, topMargin: normalMarginHeight, iconTopM: 31)
        
        bottomV.saveBtn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] btn in
            
            if self?.releaseModel.title == "" {
                
                HQGetTopVC()?.view.makeToast("请先去添加标题")
                
                return
                
            }
            if self?.releaseModel.imageNames.count == 0 && self?.releaseModel.videoName == "" {
                
                HQGetTopVC()?.view.makeToast(self?.releaseModel.noteType == 2 ? "请先去上传图片" : "请先去上传视频")
                return
            }
            self?.loadDraftSaveData()
        }
        
        bottomV.btn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            if self?.inType == 8{
                
                self?.upLoadImgToAL()
                
            }else{
                
                self?.sendBtn()
                
            }
        })
        
    }
    
    func sendBtn()  {
        
        if releaseModel.title == "" {
            
            logger.error("请添加动态标题")
            return
            
        }
        if releaseModel.imageNames.count == 0 && releaseModel.videoName == "" {
            
            logger.error("请先选择照片或者视频")
            return
        }
        
        loadData()
    }
    
    func loadData() -> Void {
        releaseModel.noteType = self.noteType
        SSCommonApi.laod(completion: { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model!.data
                            let notesModel = dic!.kj.model(SSNotesSuccessModel.self)
                            
                            if notesModel?.badges!.count ?? 0 > 0 {
                                
                                let vc = SSReleaseSendSuccessView()
                                vc.badges = notesModel?.badges?[0]
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                let num = notesModel?.points?.toInt ?? 0
                                if num > 0 {
                                    ShowMeibiAddView(num: num)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self?.navigationController?.popToRootViewController(animated: false)
                                    let vc = SSPersionDetailViewController.init()
                                    vc.cid = UserInfo.getSharedInstance().userId ?? ""
                                    
                                    HQPush(vc: vc, style: .lightContent)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        vc.segmentedView.defaultSelectedIndex = 0
                                        vc.segmentedView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
            
        }, releaseModel: releaseModel)
    }
    
    func loadDraftSaveData() {
        
        CourseNetworkProvider.request(.draftSave(address: releaseModel.address, cityName: releaseModel.cityName, content: releaseModel.content, headImageName: releaseModel.headImageName, imageNames: releaseModel.imageNames, musicUrl: releaseModel.musicUrl, noteType: "\(releaseModel.noteType)", title: releaseModel.title, videoName: releaseModel.videoName,id: inType == 7 ? releaseModel.id : "")) { [weak self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            
                            self?.addDratfSaveData(tipStr:  "草稿保存成功！您可至[我的-草稿箱]编辑发布。（新保存的本动态草稿会自动覆盖上一条本动态的草稿）")
                            
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
    
    func buildTableView() {
        
        botCell.comTfEditBlcok = {[weak self] (content,edit) in
            
            self?.isEdit = edit
            self?.releaseModel.content = content
        }
        botCell.jumpTapBlock = {[weak self] index in
            
            if index == 1 {
                
                let addressV = SSAddressController()
                addressV.currentStr = ((self?.botCell.addressL.text!.length ?? 0) > 0 && self?.botCell.addressL.text != "添加地点") ? self?.botCell.addressL.text : ""
                self?.navigationController?.pushViewController(addressV, animated: true)
                addressV.adressSelectBlock = {[weak self](title,cityName) in
                    
                    self?.botCell.addressL.text = title.length == 0 ? "添加地点" : title
                    self?.releaseModel.address = title
                    self?.releaseModel.cityName = cityName
                }
            }
            else{
                
                if self?.inType == 8{
                    
                    self?.isToPreView = true
                    self?.upLoadImgToAL()
                    
                }else{
                    
                    
                    let previewV = SSReleasePreviewController()
                    previewV.releaseModel = self?.releaseModel
                    self?.navigationController?.pushViewController(previewV, animated: true)
                }
                
            }
            
        }
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: NavContentHeight + NavStatusHei, width: screenWid, height: screenHei - SafeBottomHei - 87.5 - NavContentHeight - NavStatusHei), style: .plain)
        //        self.tableView.backgroundColor = .red
        tableView.bounces = false
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(self.tableView)
        tableView.register(SSReleaseTopCell.self, forCellReuseIdentifier: String(describing: SSReleaseTopCell.self))
    }
    
    func addDratfSaveData(tipStr: String)  {
        
        let alertView = SSCommonAlertView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
        UIApplication.shared.keyWindow?.addSubview(alertView)
        alertView.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.4)
        alertView.contentL.text = tipStr
        alertView.sureBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] btn in
            
            alertView.removeFromSuperview()
            HQPushToRootIndex(index: 3)
        })
        
    }
    
    
}
//代理
extension SSReleaseNewsViewController: UITableViewDataSource,UITableViewDelegate{
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SSReleaseTopCell.self)) as! SSReleaseTopCell
            cell.setVC(vc: self)
            cell.selectionStyle = .none
            cell.reloadImageData(list: self.imageListArray,detalisModel: releaseModel,stepList: stepList,inType: inType,noteType: noteType,title: releaseModel.title)
            releaseModel.title = cell.titleTf.text
            cell.titleBlock = {[weak self] title in
                
                self?.releaseModel.title = title
                //                self?.addTitleAlertV(cell: cell)
            }
            
            //            cell.titleContentL.text = conten
            
            cell.selectImageBlcok = {[weak self] index in
                
                self?.showHeadImagePicker()
                //                self?.selectImageOrVideo(type: self!.imageOrVideo)
            }
            cell.jumpBigImageBlcok = {[weak self] index in
                
                self?.addFullView()
            }
            return cell
        }
        
        botCell.reloadImageData(detalisModel: releaseModel, stepList: stepList, inType: inType, noteType: noteType,title: releaseModel.content,showTitle: isEdit)
        botCell.selectionStyle = .none
        
        return botCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 242
        }
        return 339
    }
    
}

//选图片

extension SSReleaseNewsViewController: HEPhotoPickerViewControllerDelegate{
    
    func addFullView()  {
        
        
        fullView = FullScreenImageListView()
        fullView!.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenHei)
        fullView!.imgArr = self.imageListArray
        fullView?.closeBlock = {[weak self] array in
            
            self?.imageListArray = array as! [UIImage]
            self?.tableView.reloadData()
        }
        UIApplication.shared.keyWindow?.addSubview(fullView!)
        
    }
    
    func addTitleAlertV(cell: SSReleaseTopCell) {
        
        if bgV == nil {
            
            bgV = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei))
            bgV?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.4)
            UIApplication.shared.keyWindow?.addSubview(bgV!)
            
            let alertV = SSTitleAlertView.init(frame: CGRect(x: 30, y: (screenHei - 258) / 2, width: screenWid - 60, height: 258))
            bgV?.addSubview(alertV)
            alertV.btnBlcok = {[weak self] title in
                
                self?.bgV?.isHidden = true
                if title != "取消" {
                    
                    cell.titleTf.text = title
                }
            }
        }
        else{
            
            bgV?.isHidden = false
        }
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    ///待实现定位权限
    ///待实现vip占位图
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        if selectedImages.count == 0 {
            return
        }
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
        
        if self.noteType == 1 {
            
            self.imageListArray.removeAll()
            self.imageListArray.append(selectedImages[0])
            self.tableView.reloadData()
            self.releaseModel.imageNames = []
            let asset = selectedModel[0].asset
            self.releaseModel.locationImg = self.imageListArray[0]
            let option = PHVideoRequestOptions.init()
            option.isNetworkAccessAllowed = true
            PHImageManager.default().requestAVAsset(forVideo: asset, options: option) { [weak self] asset2, audioMix, info in
                
                let avAsset = asset2 as? AVURLAsset
                self?.releaseModel.locationVideo = avAsset?.url
                
                var imageList = [UIImage]()
                var selections = [HEPhotoAsset]()
                
                if avAsset != nil{
                    let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
                    myQueue.async { [weak self] in
                        imgUpload.uploadVideo(avAsset!.url, successBlock: { (image) in
                            
                            DispatchQueue.main.async { [weak self] in
                                selections.append(selectedModel[0])
                                imageList.append(selectedImages[0])
                                //                                    self?.imageListArray = imageList
                                self!.defaultSelections = selections
                                self?.releaseModel.videoName = image
                                //                                    self?.tableView.reloadData()
                            }
                            imgUpload.uploadImg((selectedImages[0]) as UIImage, successBlock: { (image) in
                                self?.releaseModel.headImageName = image
                                DispatchQueue.main.async {
                                    self?.tableView.reloadData()
                                }
                                
                            }, faildBlock: {
                            }
                            )
                            
                            //  }
                        }, faildBlock: {
                            
                            
                        }
                        )
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.view.makeToast("视频获取失败，请重试")
                    }
                    
                }
            }
            
            
        }else{
            self.imageListArray = selectedImages
            self.tableView.reloadData()
            self.releaseModel.videoName = ""
            self.releaseModel.locationImg = nil
            self.releaseModel.locationVideo = nil
            self.releaseModel.locationImgs = self.imageListArray
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
                            DispatchQueue.main.async {
                                
                                self!.releaseModel.imageNames = listrray
                                //                                self?.imageListArray = imageList
                                self!.defaultSelections = selections
                                //                                self!.tableView.reloadData()
                                NSLog("%@", listrray)
                                
                            }
                        }
                        
                        
                    } faildBlock: {
                        
                    }
                }
            }
            
        }
    }
    
    func upLoadImgToAL() {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
        self.releaseModel.locationImg = shareImg
        let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        myQueue.async { [weak self] in
            imgUpload.uploadImg((self?.shareImg ?? UIImage.init()) as UIImage) { (image) in
                DispatchQueue.main.async {
                    
                    self?.releaseModel.imageNames.append(image)
                    if self?.isToPreView == true{
                        let previewV = SSReleasePreviewController()
                        previewV.releaseModel = self?.releaseModel
                        self?.navigationController?.pushViewController(previewV, animated: true)
                        self?.isToPreView = false
                        
                    }else{
                        
                        self?.sendBtn()
                        
                    }
                }
                
            } faildBlock: {
                
                
            }
        }
    }
    
    func selectImageOrVideo(type: Int) {
        
        ///上传事件
        HQPushActionWith(name: "select_note_type", dic: ["publish_method":type == 1 ? "视频" : "图文"])
        
        releaseModel.noteType = type
        // 只能选择一个视频
        option.singleVideo = true
        
        // 将上次选择的数据传入，表示支持多次累加选择，
        //                option.defaultSelections = self.selectedModel
        // 选择图片的最大个数
        if type == 1 {
            
            option.maxCountOfVideo = 1
            // 图片和视频只能选择一种
            option.mediaType = .video
            
        }else{
            
            option.maxCountOfImage = 9
            // 图片和视频只能选择一种
            option.mediaType = .image
            
        }
        option.defaultSelections = defaultSelections
        self.imagePickerController = HEPhotoPickerViewController.init(delegate: self,options: option)
        self.hePresentPhotoPickerController(picker: (self.imagePickerController)!, animated: true)
    }
    func showHeadImagePicker() -> Void {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction.init(title: "图片", style: .default) { (action) in
            
            self.noteType = 2
            self.selectImageOrVideo(type: self.noteType)
            
        }
        
        let cameraAction = UIAlertAction.init(title: "视频", style: .default) { (action) in
            self.noteType = 1
            self.selectImageOrVideo(type: self.noteType)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
