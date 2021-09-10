//
//  KeChengUserView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/7.
//

import UIKit
import BSText

class CourseUserView: UIView {
    
    let headView = UIImageView.initWithName(imgName: "my_couse_icon")
    
    let titleLab = UILabel.initSomeThing(title: "我的课程", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 16), ali: .left)
    
    let goBtn = UIButton.initRightImg(imgName: "kecheng_go", titleStr: "去学习", titleColor: .init(hex: "#FD8024"), font: .boldSystemFont(ofSize: 14), imgWid: 16)
    let subLab = BSLabel.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        subLab.textColor = .init(hex: "#666666")
        subLab.font = .systemFont(ofSize: 14)
        // 1. Create an attributed string.
        let text = NSMutableAttributedString(string: "未完成：0 / 全部课程：20")
            
        // 2. Set attributes to text, you can use almost all CoreText attributes.
        text.bs_font = .systemFont(ofSize: 14)
        text.bs_color = .init(hex: "#666666")
        text.bs_set(color: .init(hex: "#FD8024"), range: NSRange(location: 4, length: 1))
        
        subLab.attributedText = text
        
        headView.layer.cornerRadius = 21
        headView.layer.masksToBounds = true
        self.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.width.height.equalTo(42)
            make.left.equalTo(27)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(headView.snp.right).offset(17)
            make.right.equalTo(-27)
            make.top.equalTo(headView).offset(-2)
            make.height.equalTo(22)
        }
        
        self.addSubview(subLab)
        subLab.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab)
            make.height.equalTo(20)
            make.top.equalTo(titleLab.snp.bottom).offset(4)
            make.right.equalTo(titleLab)
        }
        
        self.addSubview(goBtn)
        goBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(62)
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
        }
        goBtn.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getNetInfo(){
        CourseNetworkProvider.request(.selectMyCourseCondition(type: 0)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            let allNum = dic["countAll"] as? Int ?? 0
                            let unNum = dic["countFinish"] as? Int ?? 0
                            DispatchQueue.main.async {
                                let text = NSMutableAttributedString(string: "未完成：\(unNum) / 全部课程：\(allNum)")
                                    
                                // 2. Set attributes to text, you can use almost all CoreText attributes.
                                text.bs_font = .systemFont(ofSize: 14)
                                text.bs_color = .init(hex: "#666666")
                                text.bs_set(color: .init(hex: "#FD8024"), range: NSRange(location: 4, length: String(unNum).count))
                                
                                self.subLab.attributedText = text
                            }
                        }
                    }
                }catch {
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GotoTypeVC(type: 18, cid: "")
    }
}
