//
//  StudyUnfinishView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/17.
//

///学习中途退出页面
import UIKit

class StudyUnfinishView: UIView {
    let feelView = FinishFeelView()
    
    var viewTime : Double = 0
    var model : CourseDetalisModel? = nil
    
    var stepModel : CourseStepListModel? = nil{
        didSet{
            self.finishSubLab.text = "未完成\(stepModel?.step ?? 0)/\(stepModel?.totalStep ?? 0)小节学习，无法获得美币/徽章"
            if (stepModel?.headerImage ?? "").length > 0 {
                topImg.kf.setImage(with: URL.init(string: stepModel?.headerImage ?? ""),placeholder: UIImage.init(named: "normal_wid_max"))
            }else{
                topImg.kf.setImage(with: URL.init(string: model?.headerImage ?? ""),placeholder: UIImage.init(named: "normal_wid_max"))
            }
            feelView.viewTime = viewTime
            feelView.cid = self.model?.id ?? ""
            feelView.sid = self.stepModel?.id ?? ""
            feelView.model = self.model
            feelView.stepModel = self.stepModel
        }
    }

    let topImg = UIImageView.initWithName(imgName: "normal_wid_max")
    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "back_white"))
    let finishLab = UILabel.initSomeThing(title: "学习中途退出", titleColor: .white, font: .SemiboldFont(size: 28), ali: .left)
    let finishSubLab = UILabel.initSomeThing(title: "未完成小节学习", titleColor: .white, font: .MediumFont(size: 16), ali: .left)
    
    let topImgHei = screenWid / 414 * 326.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(topImg)
        topImg.contentMode = .scaleAspectFill
        topImg.layer.masksToBounds = true
        topImg.snp.makeConstraints { make in
            make.right.left.top.equalToSuperview()
            make.height.equalTo(topImgHei)
        }
        topImg.backgroundColor = .init(hex: "#666666")
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(57)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
        }
        
        self.addSubview(finishLab)
        finishLab.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.top.equalTo(125 + NavStatusHei)
        }
        
        self.addSubview(finishSubLab)
        finishSubLab.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.top.equalTo(finishLab.snp.bottom).offset(12)
        }
        
        
        feelView.isEnd = false
        self.addSubview(feelView)
        feelView.snp.makeConstraints { make in
            make.top.equalTo(topImgHei + 17)
            make.height.equalTo(450)
            make.left.right.equalToSuperview()
        }
        feelView.skipBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
        }
        feelView.enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
