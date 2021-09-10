//
//  CourseLearnNumsView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/17.
// 学习人数

import UIKit

class CourseLearnNumsView: UIView {
    var isStep = false
    var listView : UICollectionView!
    var cid = ""
    var studyNumLab  = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#FD8024"), font: .MediumFont(size: 16), ali: .right)
    let backBtn = UIButton.initImgv(imgv: .initWithName(imgName: "back_black"))
    
    let navTitle = UILabel.initSomeThing(title: "学习人数", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    
    let scrollview = UIScrollView()
    
    var topView = UIView()
    
    var userArr : [NSDictionary] = NSArray() as! [NSDictionary]
    
    var stepModel : CourseStepListModel? = nil
    
    var model : CourseDetalisModel? = UserInfo.getSharedInstance().tempObj as? CourseDetalisModel
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(16 + NavStatusHei)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
        }
        
        self.addSubview(navTitle)
        navTitle.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backBtn)
        }
        
        self.addSubview(scrollview)
        scrollview.snp.makeConstraints { make in
            make.top.equalTo(navTitle.snp.bottom).offset(9)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.setupTopView()
        self.setupBotView()
    }
    
    func getNetInfo(cid:String) {
        
        CourseNetworkProvider.request(.coureseDetails(cid: cid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            self.model = model!.data?.kj.model(CourseDetalisModel.self)
                            self.setupUI()
                            self.studyNumLab.text = "\(self.userArr.count)"
                            self.listView.reloadData()
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    func getNetInfo(){
        if self.model == nil {
            self.getNetInfo(cid: cid)
        }
        if self.isStep {
            CourseNetworkProvider.request(.selectLearningCountStep(cid: cid)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                self.userArr = (model?.data ?? []) as! [NSDictionary]
                                self.studyNumLab.text = "\(self.userArr.count)"
                                self.listView.reloadData()
                            }
                        }
                    }catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                }
            }
            return
        }
        CourseNetworkProvider.request(.courseLearningCount(cid: cid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            self.userArr = (model?.data ?? []) as! [NSDictionary]
                            if self.model != nil {
                                self.studyNumLab.text = "\(self.userArr.count)"
                                self.listView.reloadData()
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
    
    func setupTopView() {
        let topline = UIView()
        topline.backgroundColor = .init(hex: "#F7F8F9")
        scrollview.addSubview(topline)
        topline.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.width.equalTo(screenWid)
            make.height.equalTo(12)
        }
        ///是否小节
        let isStep = self.stepModel != nil
        ///是否有导师
        let hasTeacher = (model?.tutorName ?? "").count > 0
        let cellHei = 54
        var cellNum = isStep ? 6 : 5
        if hasTeacher {
            cellNum += 1
        }
        
        topView.backgroundColor = .white
        scrollview.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(topline.snp.bottom)
            make.height.equalTo(cellHei * cellNum)
            make.width.equalTo(screenWid)
            make.left.equalTo(0)
        }
        
        let studyLab = UILabel.initSomeThing(title: "学习信息", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 17), ali: .left)
        topView.addSubview(studyLab)
        studyLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.right.equalToSuperview()
            make.height.equalTo(cellHei)
        }
        let studyLabLine = UIView()
        studyLabLine.backgroundColor = .init(hex: "#EEEFF0")
        topView.addSubview(studyLabLine)
        studyLabLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(studyLab)
        }
        
        let typeCell = LeftAndRightTitleView()
        typeCell.leftTitle.text = "类型"
        typeCell.hasRightIcon = false
        topView.addSubview(typeCell)
        typeCell.snp.makeConstraints { make in
            make.top.equalTo(cellHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(cellHei)
        }
        
        let titleCell = LeftAndRightTitleView()
        titleCell.leftTitle.text = "标题"
        titleCell.hasRightIcon = true
        topView.addSubview(titleCell)
        titleCell.snp.makeConstraints { make in
            make.top.equalTo(cellHei*2)
            make.left.right.equalToSuperview()
            make.height.equalTo(cellHei)
        }
        titleCell.selBlock = {
            ///判断是否小节
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        let otherCell = LeftAndRightTitleView()
        if isStep {
            otherCell.leftTitle.text = "所属课程"
            otherCell.hasRightIcon = true
            topView.addSubview(otherCell)
            otherCell.snp.makeConstraints { make in
                make.top.equalTo(cellHei*3)
                make.left.right.equalToSuperview()
                make.height.equalTo(cellHei)
            }
        }
        otherCell.selBlock = {
            HQGetTopVC()?.navigationController?.popViewController(animated: false)
            if isStep{
                HQGetTopVC()?.navigationController?.popViewController(animated: true)
            }
        }
        
        let subTypeCell = LeftAndRightTitleView()
        subTypeCell.leftTitle.text = "分类"
        subTypeCell.hasRightIcon = false
        topView.addSubview(subTypeCell)
        subTypeCell.snp.makeConstraints { make in
            make.top.equalTo(cellHei*(isStep ? 4 : 3))
            make.left.right.equalToSuperview()
            make.height.equalTo(cellHei)
        }
        
        let teacherCell = LeftAndRightTitleView()
        if hasTeacher {
            teacherCell.leftTitle.text = "导师"
            teacherCell.hasRightIcon = false
            topView.addSubview(teacherCell)
            teacherCell.snp.makeConstraints { make in
                make.top.equalTo(subTypeCell.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(cellHei)
            }
        }
        teacherCell.selBlock = {
            let cid = self.model?.teacherUserId ?? ""
            if cid.length < 1 {
                self.makeToast("找不到该导师")
                return
            }
            GotoTypeVC(type: 99, cid: cid)
        }
        
        let authCell = LeftAndRightTitleView()
        authCell.leftTitle.text = "版权所有"
        authCell.hasRightIcon = false
        topView.addSubview(authCell)
        authCell.snp.makeConstraints { make in
            make.top.equalTo(hasTeacher ? teacherCell.snp.bottom : subTypeCell.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(cellHei)
        }
        authCell.botLine.isHidden = true
        authCell.selBlock = {
            let cid = self.model?.userId ?? ""
            if cid.length < 1 {
                self.makeToast("找不到该用户")
                return
            }
            GotoTypeVC(type: 99, cid: cid)
        }
        
        
        if model != nil {
            let secondCategory = model?.secondCategory ?? ""
            typeCell.rightTitle.text = model!.type == 0 ? "课程\(isStep ? "-小节" : "")" : "方案\(isStep ? "-小节" : "")"
            
            otherCell.leftTitle.text =  model!.type == 0 ? "所属课程" : "所属方案"
            titleCell.rightTitle.text = isStep ? stepModel?.title : model?.title
            otherCell.rightTitle.text = model?.title
            subTypeCell.rightTitle.text = "\(model?.firstCategory ?? "")\(secondCategory.length > 0 ? "-" : "")\(secondCategory)"
            teacherCell.rightTitle.text = model?.tutorName
            authCell.rightTitle.text = model?.copyrightName
        }
    }
    
    func setupBotView(){
        let botline = UIView()
        botline.backgroundColor = .init(hex: "#F7F8F9")
        scrollview.addSubview(botline)
        
        botline.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(screenWid)
            make.height.equalTo(12)
        }
        
        let numTipLab = UILabel.initSomeThing(title: "学习人数", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 17), ali: .left)
        scrollview.addSubview(numTipLab)
        numTipLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(botline.snp.bottom)
            make.height.equalTo(56)
            make.right.equalToSuperview()
        }
        
        let renLab = UILabel.initSomeThing(title: "人", titleColor: .init(hex: "#666666"), font: .MediumFont(size: 16), ali: .left)
        scrollview.addSubview(renLab)
        renLab.snp.makeConstraints { make in
            make.right.equalTo(botline).offset(-16)
            make.height.top.equalTo(numTipLab)
            make.width.equalTo(renLab.mj_textWidth())
        }
        
        
        scrollview.addSubview(studyNumLab)
        studyNumLab.snp.makeConstraints { make in
            make.right.equalTo(renLab.snp.left)
            make.height.top.equalTo(numTipLab)
            make.left.equalTo(150)
        }
        
        let layout = UICollectionViewFlowLayout()
        let itemSizeNum = screenWid / 4
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: itemSizeNum, height: itemSizeNum)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        listView = UICollectionView.init(frame: .init(x: 0, y: 0, width: screenWid, height: screenHei - (NavStatusHei + 40 + 56)), collectionViewLayout: layout)
        listView.backgroundColor = .clear
        listView.register(CourseLearnNumsCell.self, forCellWithReuseIdentifier: "CourseLearnNumsCell")
        scrollview.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(screenWid)
            make.top.equalTo(studyNumLab.snp.bottom)
            make.height.equalTo(screenHei - (NavStatusHei + 68 + 56 + SafeBottomHei))
            make.bottom.equalToSuperview()
        }
        scrollview.showsVerticalScrollIndicator = false
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        listView.delegate = self
        listView.dataSource = self
        listView.isPagingEnabled = false
    }
    
}

extension CourseLearnNumsView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CourseLearnNumsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseLearnNumsCell", for: indexPath) as! CourseLearnNumsCell
        cell.model = self.userArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.userArr[indexPath.row]
        let num = model["id"] as? NSNumber
        let cid = num?.stringValue ?? ""
        GotoTypeVC(type: 99, cid: cid)
    }
}


class CourseLearnNumsCell: UICollectionViewCell {
    var model : NSDictionary? = nil{
        didSet{
            if model != nil{
               let img = model!["headImage"] as? String ?? ""
                headImg.kf.setImage(with: URL.init(string: img),placeholder: UIImage.init(named: "user_normal_icon"))
                nameLab.text = model!["nickName"] as? String
            }
        }
    }
    let headImg = UIImageView.initWithName(imgName: "user_normal_icon")
   
    let nameLab = UILabel.initSomeThing(title: "鲜花", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        headImg.layer.cornerRadius = 27
        headImg.layer.masksToBounds = true
        
        self.addSubview(headImg)
        headImg.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.width.height.equalTo(54)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-4)
            make.height.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
