//
//  ImageListView.swift
//  Jixue
//
//  Created by 陈鸿庆 on 2020/7/10.
//  Copyright © 2020 yuchen. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import ImagePicker

import ZLPhotoBrowser
import Photos

//图片九宫格
class HQImageListView: UIView {
    
    let imagePickerController = ImagePickerController()
    var notiName = ""
    
    var imgBtnClick : intBlock? = nil
    var myImgViewArr :[UIImageView] = NSMutableArray.init() as! [UIImageView]
    var myBtnArr : [UIButton] = NSMutableArray.init() as! [UIButton]
    var delBtnArr :[UIButton] = NSMutableArray.init() as! [UIButton]
    var leftSpace : CGFloat = 10
    var imgSpace : CGFloat = 10
    var topSpace : CGFloat = 10
    
    var selectedAssets: [PHAsset] = []
    
    var isOriginal = false
    
    var vc:UIViewController?
    
    
    ///不可用横向区域
    var noSpace : CGFloat = 0
    var imgW : CGFloat = 0
    ///是否有删除按钮
    var hasDel : Bool = false
    var hasAdd : Bool = false{
        didSet{
            self.addBtn.isHidden = !hasAdd
        }
    }
    var hasVedio : Bool = false{
        didSet{
            self.playIcon.isHidden = !hasVedio
        }
    }
    let addBtn = UIButton.init()
    ///是否网络图片
    var isNetwork : Bool = false
    
    let playIcon = UIImageView.initWithName(imgName: "pil_play")
    ///本地图片数组
    var imgArr : [UIImage]? = nil{
        didSet{
            if imgArr != nil && imgArr!.count > 0{
                DispatchQueue.main.async(execute: {
                    
                    self.reloadSubViews()
                    
                })
                
            }
        }
    }
    
    
    var imgTempUrlArr : [String] = NSMutableArray.init() as! [String]
    ///网络图片数组
    var imgUrlArr : [String] = NSMutableArray.init() as! [String]{
        didSet{
            if imgUrlArr.count > 0{
                DispatchQueue.main.async(execute: {
                    self.reloadSubViews()
                })
            }
        }
    }
    
    var myHei : CGFloat = 0{
        didSet{
            if myHei > 0 {
                let name = "HQImageListViewHeiChang" + notiName
                NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: myHei - oldValue)
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func showImagePicker(_ preview: Bool) {
        let config = ZLPhotoConfiguration.default()
//        config.editImageClipRatios = [.custom, .wh1x1, .wh3x4, .wh16x9, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)]
//        config.filters = [.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)]
        
        config.imageStickerContainerView = ImageStickerContainerView()
        
        // You can first determine whether the asset is allowed to be selected.
        config.canSelectAsset = { (asset) -> Bool in
            return true
        }
        
        config.noAuthorityCallback = { (type) in
            switch type {
            case .library:
                debugPrint("No library authority")
            case .camera:
                debugPrint("No camera authority")
            case .microphone:
                debugPrint("No microphone authority")
            }
        }
        
        let ac = ZLPhotoPreviewSheet(selectedAssets: self.selectedAssets)
        ac.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            self?.imgArr = images
            self?.selectedAssets = assets
            self?.isOriginal = isOriginal
//            self?.collectionView.reloadData()
            debugPrint("\(images)   \(assets)   \(isOriginal)")
        }
        ac.cancelBlock = {
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { (errorAssets, errorIndexs) in
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        
        if preview {
            ac.showPreview(animate: true, sender: vc!)
        } else {
            ac.showPhotoLibrary(sender: vc!)
        }
    }
    
    func makeSubViews() {
        if myImgViewArr.count > 0 {
            return
        }
        imagePickerController.delegate = self
        addBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.showImagePicker(false)
//            HQGetTopVC()?.present(self.imagePickerController, animated: true, completion: nil)
        }
        imgW = (screenWid - noSpace - leftSpace * 2 - imgSpace * 2) / 3
        for num in 0...8{
            let imgv = UIImageView()
            imgv.contentMode = .scaleAspectFill
            imgv.layer.masksToBounds = true
            imgv.backgroundColor = HQLineColor(rgb: 245)
            imgv.tag = num
            myImgViewArr.append(imgv)
            self.addSubview(imgv)
            let row = num % 3
            let line = num / 3
            imgv.snp.makeConstraints { (make) in
                make.height.width.equalTo(imgW)
                make.left.equalTo(leftSpace + (imgW + imgSpace) * CGFloat(row))
                make.top.equalTo(topSpace + (imgW + imgSpace) * CGFloat(line))
            }
            imgv.isHidden = true
            
            ///添加图片点击事件
            let imgBtn = UIButton()
            imgBtn.tag = num
            myBtnArr.append(imgBtn)
            self.addSubview(imgBtn)
            imgBtn.snp.makeConstraints { (make) in
                make.edges.equalTo(imgv)
            }
            imgBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
                self.showImagePicker(false)
            }
            imgBtn.isUserInteractionEnabled = false
            if hasDel{
                let btn = UIButton()
                btn.tag = num
                delBtnArr.append(btn)
                btn.setImage(UIImage.init(named: "TeacherTrend_ImgClose_icon"), for: .normal)
                self.addSubview(btn)
                btn.snp.makeConstraints { (make) in
                    make.width.height.equalTo(20)
                    make.right.equalTo(imgv).offset(10)
                    make.top.equalTo(imgv).offset(-10)
                }
                btn.isHidden = true
                btn.reactive.controlEvents(.touchUpInside).observeValues { (btn2) in
                    if self.isNetwork{
                        if btn2.tag < self.imgUrlArr.count{
                            self.imgUrlArr.remove(at: btn2.tag)
                            if btn2.tag < self.imgTempUrlArr.count{
                                self.imgTempUrlArr.remove(at: btn2.tag)
                            }
                            
                            if self.imgUrlArr.count == 0{
                                self.isNetwork = false
                            }
                        }else{
                            self.imgArr?.remove(at: (btn2.tag - self.imgUrlArr.count))
                        }
                        
                    }else{
                        self.imgArr?.remove(at: btn2.tag)
                        self.selectedAssets.remove(at: btn2.tag)
                    }
                    self.hasAdd = true
                    self.hasVedio = false
                    self.reloadSubViews()
                }
            }
            
            if num == 0 {
                self.addSubview(playIcon)
                playIcon.isHidden = true
                playIcon.snp.makeConstraints { (make) in
                    make.width.height.equalTo(40)
                    make.centerX.equalTo(imgv)
                    make.centerY.equalTo(imgv)
                }
                if hasAdd {
                    addBtn.setBackgroundImage(UIImage.init(named: "check_addbtn_icon"), for: .normal)
                    self.addSubview(addBtn)
                    addBtn.snp.makeConstraints { (make) in
                        make.edges.equalTo(imgv)
                    }
                }
            }
        }
        self.myHei = imgW + topSpace
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadSubViews() {
        for imgv:UIImageView in myImgViewArr {
            imgv.isHidden = true
            
        }
        for btn in myBtnArr {
            btn.isHidden = true
            btn.isUserInteractionEnabled = false
        }
        if hasDel {
            for btn in delBtnArr {
                btn.isHidden = true
            }
        }
        var line = 0
        if isNetwork {
            let urlNum = imgUrlArr.count
            let imgNum = imgArr?.count ?? 0
            var allNum = urlNum + imgNum
            for num in 0...(allNum - 1){
                let imgv = myImgViewArr[num]
                let btn = myBtnArr[num]
                if num < (urlNum) {
                    imgv.kf.setImage(with: URL.init(string: imgUrlArr[num]))
                }else{
                    imgv.image = imgArr![num - urlNum]
                }
                imgv.isHidden = false
                btn.isUserInteractionEnabled = true
                btn.isHidden = false
                if hasDel {
                    delBtnArr[num].isHidden = false
                }
            }
            if hasAdd {
                if allNum < 9{
                    self.addBtn.isHidden = false
                    self.addBtn.snp.remakeConstraints { (make) in
                        make.edges.equalTo(myImgViewArr[allNum])
                    }
                }
            }
            var addLine = 1
            let addNum = self.addBtn.isHidden ? 0 : 1
            allNum = allNum + addNum
            if allNum == 3 || allNum == 6 || allNum == 9{
                addLine = 0
            }
            line = allNum / 3 + addLine
            //            if imgUrlArr!.count % 3 == 0 && imgUrlArr!.count < 9  {
            //                line += 1
            //            }
        }else{
            if (imgArr?.count ?? 0) > 0 {
                for num in 0...(imgArr!.count - 1){
                    let imgv = myImgViewArr[num]
                    let btn = myBtnArr[num]
                    imgv.image = imgArr![num]
                    imgv.isHidden = false
                    btn.isUserInteractionEnabled = true
                    btn.isHidden = false
                    if hasDel {
                        delBtnArr[num].isHidden = false
                    }
                }
            }
            
            
            
            if hasAdd {
                if (imgArr?.count ?? 0) < 9{
                    self.addBtn.isHidden = false
                    self.addBtn.snp.remakeConstraints { (make) in
                        make.edges.equalTo(myImgViewArr[(imgArr?.count ?? 0)])
                    }
                }
            }
            var addLine = 1
            let addNum = self.addBtn.isHidden ? 0 : 1
            let imgNum = (imgArr?.count ?? 0) + addNum
            if imgNum == 3 || imgNum == 6 || imgNum == 9{
                addLine = 0
            }
            
            line = imgNum / 3 + (addLine)
            //            if imgArr!.count % 3 == 0 && imgArr!.count < 9  {
            //                line += 1
            //            }
            
            
        }
        myHei = (imgW + topSpace) * CGFloat(line)
    }
}



///图片选择回调
extension HQImageListView : ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.imagePickerController.dismiss(animated: true, completion: nil)
        self.imgArr = images
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    
}
