//
//  TipStudyView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/9.
//

import UIKit
import BSText

class TipStudyView: UIView,UITableViewDelegate,UITableViewDataSource {
///    0课程 1方案 首页传3
    var type : Int = 3
    
    let topImg = UIImageView.initWithName(imgName: "course_tip_icon")
    
    let topLab = UILabel.initSomeThing(title: "学习提醒", titleColor: .white, font: .boldSystemFont(ofSize: 18), ali: .center)
    
    let whiteBg = UIView()
    
    let listView = UITableView()
    
    let tipLab = BSLabel()
    
    let closeBtn = UIButton.initImgv(imgv: .initWithName(imgName: "qiandao_close"))
    
    let cellHei : CGFloat = 84
    
    var studyModel : TipStudyModel? = nil{
        didSet{
            if studyModel != nil {
                let sNum = studyModel!.courseCount ?? "0"
                let pNum = studyModel!.planCount ?? "0"
                
                var protocolText : NSMutableAttributedString
                if type == 3 {
                    protocolText = NSMutableAttributedString(string: "您有\(sNum)个课程\(pNum)个方案待学习，马上开启元气满满的一天吧！")
                }else{
                    protocolText = NSMutableAttributedString(string: "您有\(self.type == 0 ? sNum : pNum)个\(self.type == 0 ? "课程" : "方案")待学习，马上开启元气满满的一天吧！")
                }
                   
                protocolText.bs_color = .init(hex: "#999999")
                protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 2, length: sNum.length))
                if type == 3 {
                    protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 5+sNum.length, length: pNum.length))
                }
                protocolText.bs_font = .systemFont(ofSize: 13)
                
                self.tipLab.attributedText = protocolText
                self.models = studyModel?.learningReminds ?? []
            }
        }
    }
    
    var models : [learningRemind] = NSArray() as! [learningRemind]{
        didSet{
            if models.count > 0 {
                ///计算列表高度
                var listHei = cellHei * CGFloat(models.count)
                let defultHei : CGFloat = 98
                ///限制最大高度
                if listHei > cellHei * 3.5 {
                    listHei = cellHei * 3.5
                }
                self.whiteBg.snp.updateConstraints { make in
                    make.height.equalTo(defultHei + listHei)
                }
                self.isHidden = false
                self.listView.reloadData()
            }else{
                self.removeFromSuperview()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = HQColor(r: 0, g: 0, b: 0, a: 0.41)
        
        whiteBg.layer.cornerRadius = 16
        whiteBg.layer.masksToBounds = true
        whiteBg.backgroundColor = .white
        self.addSubview(whiteBg)
        whiteBg.snp.makeConstraints { make in
            make.width.equalTo(325)
            make.height.equalTo(270)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(topImg)
        topImg.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(74)
            make.top.equalTo(whiteBg).offset(-44)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(topLab)
        topLab.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(25)
            make.top.equalTo(topImg).offset(18)
            make.centerX.equalToSuperview()
        }
        
        tipLab.font = .systemFont(ofSize: 13)
        tipLab.numberOfLines = 0
        whiteBg.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.top.equalTo(35)
            make.right.equalTo(-28)
            make.height.equalTo(44)
        }
        
        whiteBg.addSubview(listView)
        listView.separatorStyle = .none
        listView.delegate = self
        listView.dataSource = self
        listView.showsVerticalScrollIndicator = false
        listView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
            make.top.equalTo(tipLab.snp.bottom)
        }
        
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(45)
            make.top.equalTo(whiteBg.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        closeBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        CourseNetworkProvider.request(.selectLearningRemind(type: self.type)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            self.studyModel = dic.kj.model(TipStudyModel.self)
                        }
                    }
                }catch {
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : TipStudyCell? = tableView.dequeueReusableCell(withIdentifier: "TipStudyCell") as? TipStudyCell
        if cell == nil {
            cell = TipStudyCell.init(style: .default, reuseIdentifier: "TipStudyCell")
        }
        cell?.botLine.isHidden = indexPath.row == (models.count - 1)
        cell?.model = models[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHei
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        if (model.type ?? "0") == "0" {
            GotoTypeVC(type: 2, cid: model.courseId ?? "")
        }else{
            GotoTypeVC(type: 3, cid: model.courseId ?? "")
        }
    }
}

class TipStudyCell: UITableViewCell {
    
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    
    let subLab  = BSLabel()
    
    let rImg = UIImageView.initWithName(imgName: "right_black_nobg")
    
    let botLine = UIView()
    
    let dayIcon = UIImageView.initWithName(imgName: "project_day_icon")
    
    let dayLab = BSLabel()
    
    var model : learningRemind? = nil{
        didSet{
            if model != nil {
                titleLab.text = model?.title
                let step = "\(model!.finishStep ?? "0")/\(model!.totalStep ?? "0")"
                let protocolText = NSMutableAttributedString(string: "已学：\(step)节")
                protocolText.bs_color = .init(hex: "#999999")
                protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 3, length: step.length))
                protocolText.bs_font = .systemFont(ofSize: 14)
                self.subLab.attributedText = protocolText
                
                if (model!.type ?? "0") == "1" {
                    dayIcon.isHidden = false
                    dayLab.isHidden = false
                    let step = "\(model!.finishDays ?? "0")/\(model!.totalDays ?? "0")"
                    let protocolText = NSMutableAttributedString(string: "\(step)天")
                    protocolText.bs_color = .init(hex: "#999999")
                    protocolText.bs_set(color: .init(hex: "#FD8024"), range: NSRange.init(location: 0, length: step.length))
                    protocolText.bs_font = .systemFont(ofSize: 14)
                    self.dayLab.attributedText = protocolText
                }else{
                    dayIcon.isHidden = true
                    dayLab.isHidden = true
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.left.equalTo(28)
            make.right.equalTo(-78)
            make.top.equalTo(16)
        }
        
        subLab.textColor = .init(hex: "#999999")
        self.contentView.addSubview(subLab)
        subLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.width.equalTo(99)
            make.height.equalTo(20)
            make.top.equalTo(titleLab.snp.bottom).offset(9)
        }
        
        self.contentView.addSubview(rImg)
        rImg.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalTo(-28)
            make.top.equalTo(34)
        }
        
        self.contentView.addSubview(botLine)
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        botLine.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        self.contentView.addSubview(dayIcon)
        dayIcon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.centerY.equalTo(subLab)
            make.left.equalTo(subLab.snp.right).offset(5)
        }
        
        self.contentView.addSubview(dayLab)
        dayLab.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.right.equalTo(titleLab)
            make.centerY.equalTo(subLab)
            make.left.equalTo(dayIcon.snp.right).offset(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
