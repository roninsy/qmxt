//
//  KechengTypeSelView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/19.
//

import UIKit

class CourseTypeSelView: UIView {

    let bgView = UIView()
    let titleLab = UILabel.initSomeThing(title: "", fontSize: 12, titleColor: .init(hex: "#333333"))
    
    var isSel = false{
        didSet{
            bgView.backgroundColor = isSel ? .init(hex: "#FD8024") : .init(hex: "#EEEFF1")
            titleLab.backgroundColor = isSel ? .init(hex: "#FFEFE3") : .clear
            titleLab.textColor = isSel ? .init(hex: "#FD8024") : .init(hex: "#333333")
        }
    }
    
    var model : KechengChildTypeModel? = nil{
        didSet{
            if model != nil{
                self.titleLab.text = model?.name
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.layer.cornerRadius = 13.5
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLab.layer.cornerRadius = 11.5
        titleLab.layer.masksToBounds = true
        titleLab.textAlignment = .center
        self.addSubview(titleLab)
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(1)
            make.right.bottom.equalTo(-1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
