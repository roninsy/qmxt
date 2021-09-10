//
//  FullScreenImageListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/24.
//

import UIKit
import LLCycleScrollView

class FullScreenImageListView: UIView, LLCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: LLCycleScrollView, didSelectItemIndex index: NSInteger) {
       
    }
    
    func cycleScrollView(_ cycleScrollView: LLCycleScrollView, scrollTo index: NSInteger) {
        self.titleLab.text = "\(index)/\(imgArr.count)"
    }
    
    var closeBlock : arrBlock? = nil
    
    var hasDelBtn = true{
        didSet{
            delBtn.isHidden = !self.hasDelBtn
        }
    }
    var imgArr : [UIImage] = []{
        didSet{
            self.titleLab.text = "1/\(imgArr.count)"
            self.bannerView.imageArr = imgArr
        }
    }
    let bannerView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 44 + NavStatusHei, width: screenWid, height: screenHei - 44 - NavStatusHei))

    let navView = UIView()
    let titleLab = UILabel.initSomeThing(title: "1/1", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    let delBtn = UIButton.initImgv(imgv: .initWithName(imgName: "my_delete"))
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        navView.backgroundColor = .white
        self.addSubview(navView)
        navView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44 + NavStatusHei)
        }
        
        navView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.bottom.equalTo(-10)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.closeBlock?(self.imgArr as NSArray)
            self.removeFromSuperview()
        }
        
        navView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        navView.addSubview(delBtn)
        delBtn.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
            make.bottom.equalTo(-10)
        }
        delBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            if self.imgArr.count > 1{
                self.imgArr.remove(at: self.bannerView.currentIndex())
                self.bannerView.imageArr = self.imgArr
            }else{
                self.imgArr.removeAll()
                self.closeBlock?(self.imgArr as NSArray)
                self.removeFromSuperview()
            }
        }
        bannerView.infiniteLoop = false
        bannerView.delegate = self
        self.addSubview(bannerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
