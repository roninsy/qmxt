//
//  StepNumForPlayView.swift
//  BMPlayer
//
//  Created by 陈鸿庆 on 2021/5/22.
//

import UIKit

class StepNumForPlayView: UIView {
    let setupLab = UILabel()
    let stateLab = UILabel()
    let stateIcon = UIImageView()
    
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil{
                setupLab.text = String.init(format: "%@/%@", model!.step!.stringValue,model!.totalStep!.stringValue)
                stateLab.text = model!.finished! ? " 已学" : " 待学"
                self.stateLab.backgroundColor = model!.finished! ? .init(hex: "#21D826") : .init(hex: "#7C7C7C")
                stateIcon.image = model!.finished! ? UIImage.init(named: "course_setup_finish") : UIImage.init(named: "course_setup_wait")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layerView = UIView()
        layerView.layer.cornerRadius = 6
        layerView.layer.masksToBounds = true
        // fill
        layerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        layerView.alpha = 1
        self.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupLab.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        setupLab.font = .systemFont(ofSize: 13)
        setupLab.text = "0/0"
        setupLab.adjustsFontSizeToFitWidth = true
        setupLab.textAlignment = .center
        self.addSubview(setupLab)
        setupLab.snp.makeConstraints { make in
            make.left.right.equalTo(layerView)
            make.top.equalTo(layerView)
            make.height.equalTo(22)
        }
        
        stateLab.textColor = .white
        stateLab.font = .boldSystemFont(ofSize: 11)
        stateLab.text = "待学"
        stateLab.textAlignment = .left
        stateLab.layer.cornerRadius = 4
        stateLab.layer.masksToBounds = true
        stateLab.backgroundColor = .init(red: 124/255.0, green: 124/255.0, blue: 124/255.0, alpha: 1)
        layerView.addSubview(stateLab)
        stateLab.snp.makeConstraints { make in
            make.left.equalTo(3)
            make.right.equalTo(-3)
            make.bottom.equalTo(-4)
            make.height.equalTo(16)
        }
        
        stateIcon.image = UIImage.init(named: "course_setup_wait")
        layerView.addSubview(stateIcon)
        stateIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(stateLab)
            make.right.equalTo(-2)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
