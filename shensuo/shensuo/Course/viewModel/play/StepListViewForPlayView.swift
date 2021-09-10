//
//  StepListViewForPlayView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/8.
//

import UIKit

class StepListViewForPlayView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var selIndex : intBlock? = nil
    var models : [CourseStepListModel] = NSArray() as! [CourseStepListModel]{
        didSet{
            self.reloadData()
        }
    }
    
    var finishId = ""{
        didSet{
            for i in 0...(models.count - 1) {
                if models[i].id == finishId {
                    models[i].finished = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : StepListViewForPlayViewCell? = tableView.dequeueReusableCell(withIdentifier: "StepListViewForPlayViewCell") as? StepListViewForPlayViewCell
        if cell == nil {
            cell = StepListViewForPlayViewCell.init(style: .default, reuseIdentifier: "StepListViewForPlayViewCell")
        }
        cell!.model = self.models[indexPath.row]
        return cell!
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selIndex?(indexPath.row)
    }
    
}

class StepListViewForPlayViewCell: UITableViewCell {
    
    let stateView = StepNumForPlayView()
    
    let mainImg = UIImageView()
    
    let musicImg = UIImageView.initWithName(imgName: "steplist_music_icon")
    
    let headImg = UIImageView()
    
    let musicView = UIView()
    
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil {
                stateView.setupLab.text = String.init(format: "%@/%@", model!.step!.stringValue,model!.totalStep!.stringValue)
                stateView.stateLab.text = model!.finished! ? " 已学" : " 待学"
                stateView.stateLab.backgroundColor = model!.finished! ? .init(hex: "#21D826") : .init(hex: "#7C7C7C")
                stateView.stateIcon.image = model!.finished! ? UIImage.init(named: "course_setup_finish") : UIImage.init(named: "course_setup_wait")
                mainImg.kf.setImage(with: URL.init(string: model!.surfacePlot ?? ""),placeholder: UIImage.init(named:"home_mid2"))
                if (model?.video ?? false) == false {
                    self.headImg.kf.setImage(with: URL.init(string: model?.headerImage ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                }
                self.musicView.isHidden = (model?.video ?? false)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        mainImg.contentMode = .scaleAspectFill
        mainImg.layer.masksToBounds = true
        self.contentView.addSubview(mainImg)
        mainImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        musicView.backgroundColor = .white
        self.contentView.addSubview(musicView)
        musicView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headImg.contentMode = .scaleAspectFill
        headImg.layer.cornerRadius = 16
        headImg.layer.masksToBounds = true
        musicView.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.equalTo(38)
        }
        
        musicView.addSubview(musicImg)
        musicImg.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(20)
            make.left.equalTo(headImg.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(stateView)
        stateView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.left.top.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
