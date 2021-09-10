//
//  CourseSetupListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/8.
//

import UIKit
import BSText
///课程小节列表
class CourseSetupListView: UIView {
    
    ///1,课程 6，方案
    var type = 1
    var myHei : CGFloat = 0
    let labHei : CGFloat = 38
    let cellHei : CGFloat = 88
    
    let projectDaySelView = ProjectDaySelView()
    
    var detalisModel : CourseDetalisModel? = nil{
        didSet{
            if self.type == 1 {
                let finishStepStr = detalisModel?.finishStep ?? ""
                let protocolText = NSMutableAttributedString(string: "已学：\(finishStepStr)/\(detalisModel?.totalStep?.stringValue ?? "")节")
                protocolText.bs_font = .MediumFont(size: 14)
                protocolText.bs_color = .init(hex: "#333333")
                protocolText.bs_set(color: .init(hex: "#FD8024"), range: .init(location: 3, length: finishStepStr.length))
                topLab.attributedText = protocolText
            }else{
                let finishStepStr = detalisModel?.finishStep ?? "0"
                let finishDayStr = detalisModel?.finishDays?.stringValue ?? "0"
                let totalStepStr = detalisModel?.totalStep?.stringValue ?? "0"
                let protocolText = NSMutableAttributedString(string: "已学：\(finishDayStr)/\(detalisModel?.totalDays?.stringValue ?? "0")天，\(finishStepStr)/\(totalStepStr)节")
                protocolText.bs_font = .MediumFont(size: 14)
                protocolText.bs_color = .init(hex: "#333333")
                protocolText.bs_set(color: .init(hex: "#FD8024"), range: .init(location: 3, length: finishDayStr.length))
                protocolText.bs_set(color: .init(hex: "#FD8024"), range: .init(location: protocolText.length - finishStepStr.count - totalStepStr.count - 2, length: finishStepStr.length))
                topLab.attributedText = protocolText
            }
           
        }
    }
    let topLab = BSLabel()
    var cells : [CourseSetupListCell] = NSMutableArray() as! [CourseSetupListCell]
    var models : [CourseStepListModel] = NSArray() as! [CourseStepListModel]{
        didSet{
            self.projectDaySelView.isHidden = self.type != 6
            for cell in cells{
                cell.removeFromSuperview()
            }
            cells.removeAll()
            let daysViewHei : CGFloat = self.type == 6 ? 50 : 0
            myHei = labHei + daysViewHei
            if models.count > 0 {
                myHei = labHei + daysViewHei + cellHei * CGFloat(models.count)
                for i in 0...models.count - 1{
                    let cell = CourseSetupListCell()
                    if i == 0 {
                        cell.topLine.isHidden = true
                    }
                    self.addSubview(cell)
                    cell.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(cellHei)
                        make.top.equalTo(labHei + daysViewHei + CGFloat(i) * cellHei)
                    }
                    cell.model = models[i]
                    cell.type = self.type
                    cells.append(cell)
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(topLab)
        topLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.top.equalToSuperview()
            make.height.equalTo(labHei)
        }
        let protocolText = NSMutableAttributedString(string: "已学：0/0")
        protocolText.bs_font = .MediumFont(size: 14)
        protocolText.bs_color = .init(hex: "#333333")
        protocolText.bs_set(color: .init(hex: "#FD8024"), range: .init(location: 3, length: 1))
        topLab.attributedText = protocolText
        let topLine = UIView()
        topLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.bottom.equalTo(topLab)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        self.addSubview(projectDaySelView)
        projectDaySelView.snp.makeConstraints { make in
            make.top.equalTo(topLab.snp.bottom).offset(16)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(27)
        }
        projectDaySelView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CourseSetupListCell: UIView {
    var type = 1
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil{
                titleLab.text = model?.title
                let maxWid = screenWid - 200
                let wid = titleLab.sizeThatFits(CGSize.init(width: maxWid, height: 20)).width
                titleLab.snp.updateConstraints { make in
                    make.width.equalTo(wid > maxWid ? maxWid : wid)
                }
                
                setupLab.text = String.init(format: "%@/%@", model!.step!.stringValue,model!.totalStep!.stringValue)
                stateLab.text = model!.finished! ? "已学" : "待学"
                stateLab.backgroundColor = model!.finished! ? .init(hex: "#21D826") : .init(hex: "#7C7C7C")
                stateIcon.image = model!.finished! ? UIImage.init(named: "course_setup_finish") : UIImage.init(named: "course_setup_wait")
                if (model?.deletedRemark ?? "").length > 0 {
                    self.titleLab.isHidden = true
                    self.studyNumLab.isHidden = true
                    self.playBtn.isHidden = true
                    self.playVedioBtn.isHidden = true
                    self.msgLab.isHidden = true
                    self.msgIcon.isHidden = true
                    self.freeIcon.isHidden = true
                    self.delLab.text = (model?.deletedRemark ?? "")
                    self.delLab.isHidden = false
                }else{
                    self.titleLab.isHidden = false
                    self.studyNumLab.isHidden = false
                    self.msgLab.isHidden = false
                    self.msgIcon.isHidden = false
                    
                    freeIcon.isHidden = !model!.freeTry!
                    playBtn.isHidden = model!.video
                    playVedioBtn.isHidden = !model!.video
                    
                    studyNumLab.text = "\(getNumString(num: model!.studyTimes!.toDouble ?? 0))学习"
                    msgLab.text = model!.postTimes!.stringValue
                    self.delLab.isHidden = true
                }
                
            }
        }
    }
    let layerView = UIView()
    let setupLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 13), ali: .center)
    ///状态文本
    let stateLab = UILabel.initSomeThing(title: "已学", fontSize: 11, titleColor: .white)
    
    ///状态文本
    let delLab = UILabel.initSomeThing(title: "内容违规已被删除", fontSize: 16, titleColor: .init(hex: "#B4B4B4"))
    ///状态图标
    let stateIcon = UIImageView.initWithName(imgName: "course_setup_finish")
    ///标题文本
    let titleLab = UILabel.initSomeThing(title: "第一节", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    ///学习人数
    let studyNumLab = UILabel.initSomeThing(title: "0人学习", fontSize: 14, titleColor: .init(hex: "#A2A2A7"))
    ///消息图标
    let msgIcon = UIImageView.initWithName(imgName: "comment_num_gray")
    ///消息数文本
    let msgLab = UILabel.initSomeThing(title: "0人学习", fontSize: 14, titleColor: .init(hex: "#A2A2A7"))
    ///免费图标
    let freeIcon = UIImageView.initWithName(imgName: "course_free_try")
    ///播放按钮
    let playBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "course_setup_ting"))
    let playVedioBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "course_setup_vedio"))
    let topLine = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        topLine.backgroundColor = .init(hex: "#EEEFF0")
        self.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(0.5)
        }
        
        // shadowCode
        layerView.layer.shadowColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 0.08).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        layerView.layer.shadowOpacity = 1
        layerView.layer.shadowRadius = 6
        // fill
        layerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        layerView.alpha = 1
        self.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
        }
        
        setupLab.adjustsFontSizeToFitWidth = true
        self.addSubview(setupLab)
        setupLab.snp.makeConstraints { make in
            make.left.right.equalTo(layerView)
            make.top.equalTo(layerView)
            make.bottom.equalTo(layerView).offset(-20)
        }
        
        stateLab.layer.cornerRadius = 2
        stateLab.layer.masksToBounds = true
        stateLab.backgroundColor = .init(hex: "#21D826")
        layerView.addSubview(stateLab)
        stateLab.snp.makeConstraints { make in
            make.left.equalTo(3)
            make.right.equalTo(-3)
            make.bottom.equalTo(-4)
            make.height.equalTo(16)
        }
        
        layerView.addSubview(stateIcon)
        stateIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(stateLab)
            make.right.equalTo(-2)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(layerView.snp.right).offset(17)
            make.height.equalTo(22)
            make.top.equalTo(17)
            make.width.equalTo(100)
        }
        
        self.addSubview(freeIcon)
        freeIcon.snp.makeConstraints { make in
            make.width.equalTo(58)
            make.height.equalTo(19)
            make.left.equalTo(titleLab.snp.right).offset(16)
            make.centerY.equalTo(titleLab)
        }
        
        self.addSubview(studyNumLab)
        studyNumLab.snp.makeConstraints { make in
            make.left.equalTo(layerView.snp.right).offset(19)
            make.height.equalTo(20)
            make.top.equalTo(titleLab.snp.bottom).offset(6)
        }
        studyNumLab.sizeToFit()
        self.addSubview(msgIcon)
        msgIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(studyNumLab)
            make.left.equalTo(studyNumLab.snp.right).offset(20)
        }
        
        self.addSubview(msgLab)
        msgLab.snp.makeConstraints { make in
            make.left.equalTo(msgIcon.snp.right)
            make.height.equalTo(studyNumLab)
            make.width.equalTo(100)
            make.top.equalTo(studyNumLab)
        }
        
        self.addSubview(playBtn)
        playBtn.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
        }
        
        self.addSubview(playVedioBtn)
        playVedioBtn.snp.makeConstraints { make in
            make.edges.equalTo(playBtn)
        }
        
        playBtn.isUserInteractionEnabled = false
        playVedioBtn.isUserInteractionEnabled = false
        
        self.addSubview(delLab)
        delLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
            make.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (model?.deletedRemark ?? "").length > 0 {
            return
        }
        let vc = StepDetalisVC()
        vc.cid = model?.id ?? "0"
        vc.mainView.type = self.type
        HQPush(vc: vc, style: .default)
    }
}
