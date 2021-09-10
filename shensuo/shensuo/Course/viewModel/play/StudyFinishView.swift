//
//  StudyFinishView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/29.
//

import UIKit
import BSText

class StudyFinishView: UIView {
    var model : CourseDetalisModel? = nil{
        didSet{
            if model?.dayMap != nil {
                let bBtn = UIButton.initWithLineBtn(title: "返回方案首页", font: .systemFont(ofSize: 18), titleColor: .init(hex: "#333333"), bgColor: .white, lineColor: .init(hex: "#CBCCCD"), cr: 22.5)
                bBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                    self.cancleSureAlertAction(title: "不打卡到动态将无法生成“美丽日记”、“美丽相册”，您确定要离开吗？", content: "") {[weak self] ac in
                        self?.enterBtnClick()
                    }
                }
                self.breakBtn.addSubview(bBtn)
                bBtn.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
            }else{
                let bBtn = UIButton.initWithLineBtn(title: "返回课程首页", font: .systemFont(ofSize: 18), titleColor: .init(hex: "#333333"), bgColor: .white, lineColor: .init(hex: "#CBCCCD"), cr: 22.5)
                bBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
                    self.cancleSureAlertAction(title: "不打卡到动态将无法生成“美丽日记”、“美丽相册”，您确定要离开吗？", content: "") {[weak self] ac in
                        self?.enterBtnClick()
                    }
                }
                self.breakBtn.addSubview(bBtn)
                bBtn.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    var infoDic : NSDictionary? = nil{
        didSet{
            if infoDic != nil {
                DispatchQueue.main.async {
                    self.topImg.kf.setImage(with: URL.init(string: self.infoDic!["topImage"] as? String ?? ""),placeholder: UIImage.init(named: "normal_wid_max"))
                    self.finishSubLab.text = "完成\(self.infoDic!["finishStepStr"] as? String  ?? "")小节学习"
                    self.minLab.text = self.infoDic!["totalMin"] as? String ?? "0"
                    let kllStr = self.infoDic!["totalKll"] as? String ?? "0"
                    let kllAstr = NSMutableAttributedString.init(string: "\(kllStr)千卡")
                    kllAstr.bs_font = .systemFont(ofSize: 15)
                    kllAstr.bs_set(font: .boldSystemFont(ofSize: 24), range: .init(location: 0, length: kllStr.count))
                    kllAstr.bs_color = .init(hex: "#333333")
                    kllAstr.bs_alignment = .center
                    self.kllLab.attributedText = kllAstr
                    
                    let pointsSum = self.infoDic?["totalPoints"] as? String ?? "0"
                    if pointsSum != "0" {
                        self.makeToast("获得\(pointsSum)美币")
                    }
                    
                    let dic = self.infoDic!["completionJobResult"] as? NSDictionary
                    if dic != nil {
                        let arr = dic?["badge"] as? NSArray
                        if arr != nil && arr!.count > 0 {
                            self.categoryTip.text = "恭喜您获得\(arr!.count)枚徽章"
                            let cvWid = screenWid - 40
                            let cvHei = self.categorySView.mj_h
                            if arr!.count == 1 {
                                let cvDic = arr![0] as! NSDictionary
                                let cv = CategoryForFinishView()
                                cv.categoryName.text = cvDic["categoryName"] as? String
                                cv.categoryImg.kf.setImage(with: URL.init(string: cvDic["image"] as? String ?? ""))
                                cv.frame = .init(x: 0, y: 0, width: cvWid, height: cvHei)
                                self.categorySView.addSubview(cv)
                            }else{
                                for i in 0...(arr!.count - 1){
                                    let cvDic = arr![i] as! NSDictionary
                                    let cv = CategoryForFinishView()
                                    cv.categoryName.text = cvDic["categoryName"] as? String
                                    cv.categoryImg.kf.setImage(with: URL.init(string: cvDic["image"] as? String ?? ""))
                                   
                                    cv.frame = .init(x: CGFloat(i) * cvWid, y: 0, width: cvWid, height: cvHei)
                                    self.categorySView.addSubview(cv)
                                }
                                self.categorySView.contentSize = .init(width: cvWid * CGFloat(arr!.count), height: 0)
                            }
                        }else{
                            self.categoryView.snp.updateConstraints { make in
                                make.height.equalTo(0)
                            }
                            self.categoryView.isHidden = true
                        }
                    }else{
                        self.categoryView.snp.updateConstraints { make in
                            make.height.equalTo(0)
                        }
                        self.categoryView.isHidden = true
                    }
                    
                }
            }
        }
    }
    
    var needInputBody = false

    let topImg = UIImageView.initWithName(imgName: "normal_wid_max")
    let backBtn = UIButton.initImgv(imgv: UIImageView.initWithName(imgName: "back_white"))
    let finishLab = UILabel.initSomeThing(title: "学习完成", titleColor: .white, font: .SemiboldFont(size: 28), ali: .left)
    let finishSubLab = UILabel.initSomeThing(title: "完成小节学习", titleColor: .white, font: .MediumFont(size: 16), ali: .left)
    
    let minLab = UILabel.initSomeThing(title: "0", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 24), ali: .center)
    let kllLab = BSLabel()
    
    ///徽章相关
    let categoryTip = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 16), ali: .left)
    
    
    let categoryView = UIView()
    let categorySView = UIScrollView()
    
    let enterBtn = UIButton.initTitle(title: "打卡到动态", font: .MediumFont(size: 18), titleColor: .white, bgColor: .init(hex: "#FD8024"))
    
    let breakBtn = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        self.addSubview(topImg)
        topImg.contentMode = .scaleAspectFill
        topImg.layer.masksToBounds = true
        topImg.snp.makeConstraints { make in
            make.right.left.top.equalToSuperview()
            make.height.equalTo(screenWid / 414 * 326.5)
        }
        
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
        
        let midBg = UIView()
        
        self.addSubview(midBg)
        midBg.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(102)
            make.bottom.equalTo(topImg).offset(51)
        }
        
        let labWid = screenWid / 2 - 20
        midBg.addSubview(minLab)
        minLab.snp.makeConstraints { make in
            make.height.equalTo(33)
            make.top.equalTo(26)
            make.width.equalTo(labWid)
            make.left.equalToSuperview()
        }
        
        midBg.backgroundColor = .white
        midBg.layer.cornerRadius = 6
        midBg.layer.masksToBounds = true
        midBg.addSubview(kllLab)
        kllLab.textAlignment = .center
        kllLab.snp.makeConstraints { make in
            make.height.equalTo(33)
            make.top.equalTo(26)
            make.width.equalTo(labWid)
            make.right.equalToSuperview()
        }
        
        let minTip = UILabel.initSomeThing(title: "总分钟", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
        midBg.addSubview(minTip)
        minTip.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalTo(minLab.snp.bottom)
            make.width.equalTo(labWid)
            make.left.equalToSuperview()
        }
        
        let kllTip = UILabel.initSomeThing(title: "总消耗", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 13), ali: .center)
        midBg.addSubview(kllTip)
        kllTip.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalTo(minTip)
            make.width.equalTo(labWid)
            make.right.equalToSuperview()
        }
        
        categoryView.backgroundColor = .white
        categoryView.layer.cornerRadius = 6
        categoryView.layer.masksToBounds = true
        self.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(midBg.snp.bottom).offset(12)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(screenWid < 414 ? 230 : 316)
        }
        
        categoryView.addSubview(categoryTip)
        categoryTip.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-20)
            make.height.equalTo(22)
        }
        
        categorySView.isPagingEnabled = true
        categoryView.addSubview(categorySView)
        categorySView.snp.makeConstraints { make in
            make.top.equalTo(screenWid < 414 ? 36 : 95)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(186)
        }
        
        let btnWid = screenWid / 2 - 28
        self.addSubview(breakBtn)
        breakBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.equalTo(45)
            make.width.equalTo(btnWid)
            make.top.equalTo(categoryView.snp.bottom).offset(24)
        }
        
        enterBtn.layer.cornerRadius = 22.5
        enterBtn.layer.masksToBounds = true
        self.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalTo(45)
            make.width.equalTo(btnWid)
            make.top.equalTo(categoryView.snp.bottom).offset(24)
        }
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.enterBtnClick()
        }
        
        self.getDays()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enterBtnClick(){
        if self.needInputBody{
            let vc = InputBodyInfoVC()
            vc.mainView.model = self.model
            ///跳转到录入身体数据
            HQPush(vc: vc, style: .default)
        }else{
            ///上报事件
            HQPushActionWith(name: "click_publish_note", dic:  ["current_page":"打卡到动态"])
            ///跳转到发布动态
            let vc = SSReleaseNewsViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.detalisModel = self.model ?? CourseDetalisModel()
            vc.inType = 2
            HQPush(vc: vc, style: .default)
        }
    }
    
    func cancleSureAlertAction(title: String,content: String,sureHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: title, message: content, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "打卡到动态", style: .default, handler: sureHandle)
    
        let cancelAction = UIAlertAction.init(title: "残忍离开", style: .cancel) {[weak self] (action) in
            if self?.model?.dayMap != nil{
                HQPushToRootIndex(index: 2)
            }else{
                HQPushToRootIndex(index: 1)
            }
            
        }
        sureAction.setValue(btnColor, forKey: "_titleTextColor")
        cancelAction.setValue(color99, forKey: "_titleTextColor")
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        HQGetTopVC()?.present(alert, animated: true, completion: nil)
    }
    
    func getDays(){
        ///获取天数
        CommunityNetworkProvider.request(.checkAddDailyRecord) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultBoolModel.self)
                        if model?.code == 0 {
                            self.needInputBody = !(model?.data ?? true)
                        }
                    }
                } catch {
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
}

class CategoryForFinishView: UIView {
    let categoryImg = UIImageView()
    let categoryName = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(categoryImg)
        categoryImg.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        self.addSubview(categoryName)
        categoryName.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
