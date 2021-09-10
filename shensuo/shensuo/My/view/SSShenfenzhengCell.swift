//
//  SSShenfenzhengCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/2.
//

import UIKit
import HEPhotoPicker

class SSShenfenzhengCell: UITableViewCell {

    var myHei : CGFloat = 77
    
    var imgHei = screenWid / 414 * 138
    
    var imgWid = screenWid / 414 * 187
    
    var defaultSelections = [HEPhotoAsset]()
    let sskey = SSCustomgGetSecurtKey()
    
    ///身份证正面
    var mainImg = UIImageView.initWithName(imgName: "idcard_cn_info")
    ///身份证反面
    var fanImg = UIImageView.initWithName(imgName: "idcard_cn")
    
    var idimages : [String] = NSMutableArray() as! [String]
    
    ///0正面 1反面
    var selType = 0
    let titleLab = UILabel.initSomeThing(title: "身份证正反面", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .left)
    
    weak var delegate: MyProveViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.myHei += imgHei
        
        
        
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.equalTo(200)
            make.height.equalTo(22)
            make.top.equalTo(15)
        }
        
        self.contentView.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.width.equalTo(imgWid)
            make.height.equalTo(imgHei)
            make.left.equalTo(16)
            make.top.equalTo(61)
        }
        
        self.contentView.addSubview(fanImg)
        fanImg.snp.makeConstraints { make in
            make.width.equalTo(imgWid)
            make.height.equalTo(imgHei)
            make.right.equalTo(-16)
            make.top.equalTo(61)
        }
        mainImg.contentMode = .scaleAspectFit
        fanImg.contentMode = .scaleAspectFit
        
        let mainBtn = UIButton()
        let fanBtn = UIButton()
        self.contentView.addSubview(mainBtn)
        mainBtn.snp.makeConstraints { make in
            make.edges.equalTo(mainImg)
        }
        self.contentView.addSubview(fanBtn)
        fanBtn.snp.makeConstraints { make in
            make.edges.equalTo(fanImg)
        }
        mainBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.selType = 0
            self.selectImageOrVideo()
        }
        fanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.selType = 1
            self.selectImageOrVideo()
        }
        idimages.append("-1")
        idimages.append("-1")
        sskey.getSecurtKey()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectImageOrVideo() {
        let option = HEPickerOptions.init()
        // 只能选择一个视频
        option.singleVideo = true
        
        // 将上次选择的数据传入，表示支持多次累加选择，
        //                option.defaultSelections = self.selectedModel
        // 选择图片的最大个数
        
        option.maxCountOfImage = 1
        // 图片和视频只能选择一种
        option.mediaType = .image
        option.defaultSelections = defaultSelections
        let imagePickerController = HEPhotoPickerViewController.init(delegate: self,options: option)
        let nav = UINavigationController.init(rootViewController: imagePickerController)
        nav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            HQGetTopVC()?.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
}

extension SSShenfenzhengCell: HEPhotoPickerViewControllerDelegate {
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        if selectedImages.count == 0 {
            return
        }
        if self.selType ==  0 {
            self.mainImg.image = selectedImages[0]
        }else{
            self.fanImg.image = selectedImages[0]
        }
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = sskey.accessKeyId ?? ""
        imgUpload.securityToken = sskey.securityToken ?? ""
        imgUpload.secretKeyId = sskey.accessKeySecret ?? ""
        
        let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        myQueue.async { [weak self] in
            imgUpload.uploadImg((selectedImages[0]) as UIImage) { (image) in
                self?.idimages[self?.selType == 0 ? 0 : 1] = image
                self?.delegate?.personModel?.idimages = self?.idimages
            } faildBlock: {
                
            }
        }
    }
}
