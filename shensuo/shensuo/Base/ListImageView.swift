//
//  ListImageView.swift
//  Jixue
//
//  Created by 陈鸿庆 on 2020/7/15.
//  Copyright © 2020 yuchen. All rights reserved.
//

import UIKit
import JXPhotoBrowser
import RxSwift
import RxCocoa

class ListImageView: UIView {
    
    let browser = JXPhotoBrowser()
    
    var viewHei : CGFloat = 0
    
    var imgSpace : CGFloat = 10
    
    var leftSpace : CGFloat = 0
    
    var rightSpace : CGFloat = 0
    
    var imgVArr = NSMutableArray.init()
    
    var btnArr = NSMutableArray.init()
    
    var hlImgUrlArr : [String]? = nil
    
    var imgUrlArr : [String]? = nil{
        didSet{
            if imgUrlArr != nil{
                let num = imgUrlArr?.count ?? 0
                if num > 0{
                    
                    for imgv in imgVArr {
                        let imgvv = imgv as! UIImageView
                        imgvv.removeFromSuperview()
                    }
                    imgVArr.removeAllObjects()
                    
                    for btn in btnArr {
                        let btnn = btn as! UIButton
                        btnn.removeFromSuperview()
                    }
                    btnArr.removeAllObjects()
                    
                    var imgWid = screenWid - leftSpace - rightSpace
                    imgWid = (imgWid - imgSpace * 2) / 3
                    var rowNum = 1
                    if num == 2 || num == 4{
                        rowNum = 2
                    }else if num != 1{
                        rowNum = 3
                    }
                    
                    for i in 0...(num - 1){
                        let imgv = UIImageView.init()
                        imgv.layer.cornerRadius = 4
                        imgv.layer.masksToBounds = true
                        self.addSubview(imgv)
                        imgv.snp.makeConstraints { (make) in
                            make.width.height.equalTo(imgWid)
                            var num2 = (ceil(CGFloat(i) / CGFloat(rowNum)))
                            if i % rowNum > 0{
                                num2 -= 1
                            }
                            make.top.equalTo((num2 < 0 ? 0 : num2) * (imgWid + imgSpace))
                            make.left.equalTo(CGFloat(i%rowNum) * (imgWid + imgSpace))
                        }
                        imgv.kf.setImage(with: URL.init(string: imgUrlArr![i]),placeholder: UIImage.init(named: "user_normal_icon"))
                        imgv.contentMode = .scaleAspectFill
                        imgv.layer.masksToBounds = true
                        imgVArr.add(imgv)
                        
                        let btn = UIButton.init()
                        btn.tag = i
                        self.addSubview(btn)
                        btn.snp.makeConstraints { (make) in
                            make.edges.equalTo(imgv)
                        }
                        btn.rx.tap.subscribe(onNext:{
                            self.browser.pageIndex = btn.tag
                            self.browser.show()
                        }).disposed(by: disposeBag)
                    }
                    browser.numberOfItems = {
                        num
                    }
                    viewHei = (ceil(CGFloat(num) / CGFloat(rowNum))) * (imgWid + imgSpace) - imgSpace
                }else{
                    viewHei = 0
                }
            }else{
                viewHei = 0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            let indexPath = IndexPath(item: context.index, section: 0)
//            let imgv = self.imgVArr[indexPath.row] as! UIImageView
//            browserCell?.imageView.image = imgv.image
//            let url = (self.hlImgUrlArr?.count ?? 0) > indexPath.row ? self.hlImgUrlArr![indexPath.row] : self.imgUrlArr![indexPath.row]
            let url = self.imgUrlArr![indexPath.row]
            // 用Kingfisher加载
            browserCell?.imageView.kf.setImage(with: URL.init(string: url))
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
