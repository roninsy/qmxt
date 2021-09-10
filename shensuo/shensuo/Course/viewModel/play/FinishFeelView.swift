//
//  FinishFeelView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/23.
//

import UIKit

class FinishFeelView: UIView,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    var isEnd = false{
        didSet{
            if !isEnd {
                ///中途退出
                self.bgView.isHidden = true
                self.backBtn.isHidden = true
                self.skipBtn.isHidden = false
                self.titleLab.text = "亲亲，为什么中途退出本次学习"
            }
        }
    }
    var selType = 1
    ///课程id
    var cid = ""
    ///小节id
    var sid = ""
    
    var viewTime : Double = 0
    
    var model : CourseDetalisModel? = nil
    
    var stepModel : CourseStepListModel? = nil
    
    var models = ["内容很喜欢","内容不喜欢","内容太简单","内容难完成"]
    let titleLab = UILabel.initSomeThing(title: "学习完成，说说您的感受~", titleColor: .init(hex: "#333333"), font: .SemiboldFont(size: 17), ali: .center)
    let listView = UITableView()
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "play_white_close"))
    
    var placeHolderLabel = UILabel.initSomeThing(title: "其他感受", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 15), ali: .left)
    let contentView = UITextView()
    let contentNumLab = UILabel.initSomeThing(title: "0/30", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 13), ali: .right)
    
    let enterBtn = UIButton.initTitle(title: "提交感受", font: .MediumFont(size: 20), titleColor: .init(hex: "#FD8024"), bgColor: .clear)
    let bgView = UIView()
    
    let skipBtn = UIButton.initTitle(title: "跳过", font: .systemFont(ofSize: 16), titleColor: .init(hex: "#666666"), bgColor: .clear)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.backgroundColor = .black
        bgView.alpha = 0.8
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(21)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.removeFromSuperview()
        }
        
        let whiteBG = UIView()
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 16
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.width.height.equalTo(372)
            make.center.equalToSuperview()
        }
        
        whiteBG.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(123-46)
        }
        
        listView.delegate = self
        listView.dataSource = self
        whiteBG.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom)
            make.height.equalTo(46 * 4)
            make.left.right.equalToSuperview()
        }
        
        placeHolderLabel.sizeToFit()
        contentView.addSubview(placeHolderLabel)
        contentView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        contentView.font = .systemFont(ofSize: 15)
        contentView.textColor = .init(hex: "#333333")
        contentView.backgroundColor = .clear
        whiteBG.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(listView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(-60)
        }
        contentView.delegate = self
        
        whiteBG.addSubview(contentNumLab)
        contentNumLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.right.equalTo(-10)
            make.left.equalTo(10)
            make.bottom.equalTo(-62)
        }
        
        whiteBG.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(55)
        }
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.addFeel()
            self.removeFromSuperview()
        }
        listView.isScrollEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listView.deselectRow(at: .init(row: 0, section: 0), animated: true)
            self.listView.reloadData()
        }
        
        self.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(whiteBG.snp.bottom).offset(10)
        }
        skipBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 30 {
            textView.text = textView.text.subString(to: 29)
            return
        }
        self.contentNumLab.text = "\(textView.text.length)/30"
        if textView.text.count > 0 && self.selType != 5 {
            self.listView.deselectRow(at: .init(row: self.selType - 1, section: 0), animated: true)
            self.listView.reloadData()
            self.selType = 5
        }
    }
    
    ///提交学习感受
    func addFeel(){
        CourseNetworkProvider.request(.addTrainingFeel(commitType: self.isEnd ? 1 : 2, courseId: cid, courseStepId: sid, feelContent: contentView.text ?? "", feelType: self.selType)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            HQGetTopVC()?.view.makeToast("提交成功")
                            
                            var freeStr = self.model?.free == true ? "免费" : "付费"
                            if self.model?.vipFree == true {
                                freeStr = "vip免费"
                            }
                            
                            var exit_reason = ""
                            if self.selType == 5 {
                                exit_reason = "其他感受"
                            }else{
                                exit_reason = self.models[self.selType - 1]
                            }
                            ///上传事件
                            HQPushActionWith(name: "exit_course", dic: ["course_frstcate":"",
                                                                        "course_secondcate":"",
                                                                        "course_id":self.model?.id ?? "",
                                                                        "course_title":self.model?.title ?? "",
                                                                        "course_type":self.model?.dayMap != nil ? "方案" : "课程",
                                                                        "course_rates":freeStr,
                                                                        "current_price":self.model?.price?.doubleValue ?? 0,
                                                                        "institution_id":self.model?.userId ?? "",
                                                                        "institution_name":self.model?.copyrightName ?? "",
                                                                        "teacher_id":self.model?.teacherUserId ?? "",
                                                                        "teacher_name":self.model?.tutorName ?? "",
                                                                        "total_minutes":(self.model?.totalMinutes?.doubleValue ?? 0) * 60,
                                                                        "total_calorie":self.model?.totalCalorie?.doubleValue ?? 0,
                                                                        "total_days":self.model?.totalDays ?? 0,
                                                                        "total_step":self.model?.totalStep ?? 0,
                                                                        "watch_duration":String.init(format: "%.0f", self.viewTime).toInt ?? 0,
                                                                        "period_id":self.stepModel?.id ?? "",
                                                                        "period_name":self.stepModel?.title ?? "",
                                                                        "period_amount":self.stepModel?.step?.intValue ?? 0,
                                                                        "period_duration":self.stepModel?.minutes ?? 0,
                                                                        "exit_reason":exit_reason])
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
        var cell : FinishFeelCell? = tableView.dequeueReusableCell(withIdentifier: "FinishFeelCell") as? FinishFeelCell
        if cell == nil {
            cell = FinishFeelCell.init(style: .default, reuseIdentifier: "FinishFeelCell")
        }
        cell?.titleLab.text = self.models[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selType = indexPath.row + 1
        self.contentView.text = ""
    }
}

class FinishFeelCell: UITableViewCell {
    
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 15), ali: .center)
    var isSel = false{
        didSet{
            
        }
    }
    let botLine = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        self.contentView.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
