//
//  SSCommonNoDataView.swift
//  shensuo
//
//  Created by  yang on 2021/7/15.
//

import UIKit

class SSCommonNoDataView: UIView {

    var titleL: UILabel!
    let icon: UIImageView = UIImageView.initWithName(imgName: "")
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(188)
            make.width.equalTo(310)
        }
        
        titleL = UILabel.initSomeThing(title: "", fontSize: 16, titleColor: color33)
        titleL.numberOfLines = 0
        titleL.font = .MediumFont(size: 16)
        titleL.textAlignment = .center
        addSubview(titleL)
        titleL.snp.makeConstraints({ make in
            
            make.top.equalTo(icon.snp.bottom).offset(21)
            make.centerX.equalToSuperview()
        })
        
    }
    
    func initWithTitle(title: String,img: String) {
        
        titleL.text = title
        icon.image = UIImage.init(named: img)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class SSCommonNoDataObject: NSObject {
    
    lazy var noDataView: SSCommonNoDataView = {
        
        let view = SSCommonNoDataView()
        view.backgroundColor = .white
        return view
    }()
    
  public  func addNoDataView(superV: UIView,title: String,img: String) {
        
        superV.addSubview(self.noDataView)
        noDataView.frame = CGRect(x: 0, y: 0, width: screenWid, height: 287)
        noDataView.initWithTitle(title: title, img: img)
        
    }
}
func SSShowNoDataView(parentView:UIView, imageName:String, tips:String) -> SSCommonNoDataObject{
    let view = SSCommonNoDataObject()
    view.addNoDataView(superV: parentView, title: tips, img: imageName)
    return view
}


class SSNoLocationView: UIView {
    
    let btn = UIButton.initTitle(title: "立即允许", fontSize: 18, titleColor: .white)
    let titleL1 = UILabel.initSomeThing(title: "才能更好进行同城推荐哦", fontSize: 18, titleColor: color33)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bgColor
        let icon: UIImageView = UIImageView.initWithName(imgName: "dingwei")
        addSubview(icon)
        icon.snp.makeConstraints { make in
            
            make.top.equalTo(72)
            make.centerX.equalToSuperview()
            make.height.equalTo(101)
            make.width.equalTo(97)
        }
        

        let titleL = UILabel.initSomeThing(title: "开启你的精准定位", fontSize: 18, titleColor: color33)
        titleL.font = .SemiboldFont(size: 18)
        titleL.textAlignment = .center
        addSubview(titleL)
        titleL.snp.makeConstraints({ make in
            
            make.top.equalTo(icon.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        })


        titleL1.font = .SemiboldFont(size: 18)
        titleL1.textAlignment = .center
        addSubview(titleL1)
        titleL1.snp.makeConstraints({ make in
            
            make.top.equalTo(titleL.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        })
        
        addSubview(btn)
        btn.backgroundColor = btnColor
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = .MediumFont(size: 18)
        btn.snp.makeConstraints { make in
            
            make.leading.equalTo(44)
            make.trailing.equalTo(-44)
            make.height.equalTo(45)
            make.top.equalTo(titleL1.snp.bottom).offset(33)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SSCommonNoLocationObject: NSObject {
    
    lazy var noDataView: SSNoLocationView = {
        
        let view = SSNoLocationView()
//        view.backgroundColor = .white
        return view
    }()
    
  public  func addNoDataView(superV: UIView,title: String) {
        
        superV.addSubview(self.noDataView)
    noDataView.frame = CGRect(x: 0, y: 0, width: screenWid, height: superV.ll_h < 100 ? 700 : superV.ll_h)
        
    }
}
func SSShowNoLocationView(parentView:UIView, tips:String) -> SSCommonNoLocationObject{
    let view = SSCommonNoLocationObject()
    view.addNoDataView(superV: parentView, title: tips)
    return view
}
