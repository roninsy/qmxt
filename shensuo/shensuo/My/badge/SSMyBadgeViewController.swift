//
//  SSMyBadgeViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/27.
//

import UIKit

// 徽章
class SSMyBadgeViewController: HQBaseViewController {
    
    var myCollView: UICollectionView!
    var headKind = "collectionHead"
    
    var badgeModel : SSBadgeModel?
    var cateGoryModel: badgeCateGoryModel?
    
    
    var isSupportContinuous = false;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0;
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
        myCollView = UICollectionView(frame: CGRect(x: 0, y: -statusHei, width: screenWid, height: screenHei+statusHei), collectionViewLayout: layout)
        myCollView.backgroundColor = UIColor.init(hex: "#F7F8F9")
        myCollView.delegate = self
        myCollView.dataSource = self
        myCollView.showsVerticalScrollIndicator = true
        myCollView.register(myBadgeCell.self, forCellWithReuseIdentifier: "myBadgeCell")
        myCollView.register(SSBadgeReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SSBadgeReusableView")
        view.addSubview(myCollView)
        loadBadgeInfo()
    }
    func getPoint() -> Void {
        UserInfoNetworkProvider.request(.selectMyPoints) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            
                        }else{
                            
                        }
                        
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    
    }
    
    func loadBadgeInfo() -> Void {
        UserInfoNetworkProvider.request(.getUserBadge) { [self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            self.badgeModel = dic?.kj.model(SSBadgeModel.self)
                            self.myCollView.reloadData()
                        }else{
                            
                        }
                        
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    
    }
    
}

class SSBadgeReusableView: UICollectionReusableView {
    var badgeModel : SSBadgeModel? = nil {
        didSet {
            if badgeModel != nil {
                headImage.kf.setImage(with: URL.init(string: badgeModel?.headImage ?? ""), placeholder: UIImage.init(named: ""), options: nil, completionHandler: nil)
                nickLabel.text = badgeModel?.nickName
                noteLabel.text = String(format: "累计获得%@枚徽章", badgeModel!.badgeNumber)
                createTime.text = String(format: "%@加入“全民形体”", badgeModel!.createdTime)
            }
        }
    }

    var bgImageView = UIImageView.initWithName(imgName: "my_badgeBg")
    var headImage = UIImageView.initWithName(imgName: "placeHolder")
    var nickLabel = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#FFFFFF"), font: .MediumFont(size: 18), ali: .left)
    var noteLabel = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#FFFFFF"), font: .systemFont(ofSize: 14), ali: .left)
    var shareBg = UIImageView.initWithName(imgName: "my_badgeShare")
    var shareBtn = UIButton.initBgImage(imgname: "my_share")
    
    var createTime = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#FFFFFF"), font: .MediumFont(size: 13), ali: .left)
    
    var backBtn = UIButton.initBgImage(imgname: "my_backimage")
    var botbg = UIImageView.initWithName(imgName: "my_badgeBot")
    
    var titleLabel = UILabel.initSomeThing(title: "我的徽章", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 18), ali: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgImageView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(NavStatusHei + 20)
            make.width.height.equalTo(25)
        }
        
        bgImageView.addSubview(headImage)
        headImage.layer.cornerRadius = 30
        headImage.layer.masksToBounds = true
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(backBtn.snp.bottom).offset(30)
            make.height.width.equalTo(60)
        }
        bgImageView.addSubview(shareBg)
        shareBg.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(headImage)
            make.width.equalTo(120)
            make.height.equalTo(33)
        }
        
        shareBg.addSubview(shareBtn)
        shareBg.isUserInteractionEnabled = true
        shareBtn.setTitle(" 分享徽章墙", for: .normal)
        shareBtn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
        shareBtn.titleLabel?.font = .systemFont(ofSize: 14)
        shareBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        shareBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        bgImageView.addSubview(nickLabel)
        nickLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(20)
            make.top.equalTo(backBtn.snp.bottom).offset(40)
            make.height.equalTo(25)
        }
        
        bgImageView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickLabel)
            make.top.equalTo(nickLabel.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        bgImageView.addSubview(createTime)
        createTime.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(headImage.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        bgImageView.addSubview(botbg)
        botbg.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        botbg.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func btnAction()  {
        if self.badgeModel != nil && self.badgeModel?.badgeCateGory != nil && self.badgeModel?.badgeCateGory?.count ?? 0 > 0{
                    let vc = ShareVC()
                    vc.type = 6
            vc.medalGetNum = self.badgeModel?.badgeNumber ?? "0"
            vc.medalModels = self.badgeModel?.badgeCateGory ?? NSArray() as! [badgeCateGoryModel]
            vc.setupMainView()
            HQPush(vc: vc, style: .lightContent)
        }
    }
}

class myBadgeCell:UICollectionViewCell {
    
    var imageView = UIImageView()
    var myLabel = UILabel()
    
    var numLabel = UILabel()
    var botView = UIView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        
        imageView.image = UIImage.init(named: "sousuo")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        self.insertSubview(numLabel, aboveSubview: imageView)
        numLabel.isHidden = true
        numLabel.layer.masksToBounds = true
        numLabel.layer.cornerRadius = 8
        numLabel.textColor = .white
        numLabel.textAlignment = .center
        numLabel.font = .systemFont(ofSize: 10)
        numLabel.backgroundColor = .init(hex: "#FD8024")
        numLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(31)
            make.height.equalTo(17)
        }
        
        myLabel.textAlignment = .center
        myLabel.textColor = .black
        myLabel.font = UIFont.systemFont(ofSize: 14)
        myLabel.text = "我的课程"
        self.addSubview(myLabel)
        myLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.addSubview(botView)
        botView.backgroundColor = .init(hex: "#F7F8F9")
        botView.snp.makeConstraints { (make) in
            make.top.equalTo(myLabel.snp.bottom).offset(16)
            make.height.equalTo(12)
            make.width.height.equalToSuperview()
        }
    }
}

// MARK: - Collection代理
extension SSMyBadgeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.badgeModel?.badgeCateGory?.count ?? 0
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badgeModel?.badgeCateGory?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollView.dequeueReusableCell(withReuseIdentifier: "myBadgeCell", for: indexPath) as! myBadgeCell
        let cellModel = self.badgeModel?.badgeCateGory?[indexPath.row]
        cell.myLabel.text = cellModel?.categoryName
        cell.imageView.kf.setImage(with: URL.init(string: cellModel?.obtainImage ?? ""), placeholder: UIImage.init(named: ""), options: nil, completionHandler: nil)
        if cellModel?.current ?? 0 > 0 {
            cell.numLabel.isHidden = false
            cell.numLabel.text = String(format: "%d枚", cellModel!.current)
        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SSBadgeReusableView", for: indexPath) as! SSBadgeReusableView
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                view.badgeModel = self.badgeModel
                view.backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
//                view.shareBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
//                    if self?.badgeModel != nil && self?.badgeModel?.badgeCateGory != nil && self?.badgeModel?.badgeCateGory?.count ?? 0 > 0{
//
//                        self?.badgeShare(img: self?.badgeModel?.badgeCateGory?[0].obtainImage ?? "", name: self?.badgeModel?.badgeCateGory?[0].categoryName ?? "")
////                    let vc = ShareVC()
////                    vc.type = 2
////                    var model = SSNotesBadgesModel()
////
////                    model.badgeImageUrl = self?.badgeModel?.badgeCateGory?[0].obtainImage
////                    model.badgeTypeName = self?.badgeModel?.badgeCateGory?[0].categoryName
////                    vc.medalModel = model
////                    vc.setupMainView()
////                    HQPush(vc: vc, style: .lightContent)
//                    }
//                })
            
            }
            
            return view;
        }else{
//            view.myLabel.text = "Footer";
            return view;
        }
    }
    
    
    @objc func clickBackBtn() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func badgeShare(img: String,name: String,id:String)  {
        
        let vc = ShareVC()
        vc.type = 2
        
        var model = SSNotesBadgesModel()
            
        model.badgeImageUrl = img
        model.badgeTypeName = name
        model.id = id
        vc.medalModel = model
        vc.setupMainView()
        HQPush(vc: vc, style: .lightContent)
    }
    func shareBtnAction(listModel :badgeListModel)  {
        
        //分享
        if listModel.type {
            
            badgeShare(img: listModel.image, name: listModel.name,id: listModel.id)
            
        }else{
            
            if self.cateGoryModel?.categoryName == "TOTAL_TRAINING" || self.cateGoryModel?.categoryName == "CONTINUOUS_TRAINING" || self.cateGoryModel?.categoryName == "FINISH_COURSE" {
                
                tabBarController?.selectedIndex = 1
                
            }else if(self.cateGoryModel?.categoryName == "SEND_GIFT" || self.cateGoryModel?.categoryName == "RECEIVE_GIFT") {
                        
               tabBarController?.selectedIndex = 0
                
                
            }else if(self.cateGoryModel?.categoryName == "FINISH_PLAN") {
                
                tabBarController?.selectedIndex = 2
                 
            }else{
                
                tabBarController?.selectedIndex = 3

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popView = SSBadgePopView(frame: self.view.frame)
        let badgeModel = (self.badgeModel?.badgeCateGory?[indexPath.row])!
        popView.loadBadgeDetail(model: badgeModel)
        cateGoryModel = badgeModel
        popView.closeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            popView.isHidden = true
            popView.removeFromSuperview()
        }
        popView.shareBtn.reactive.controlEvents(.touchUpInside).observe({[weak self] _ in
            if popView.badgePopModel != nil && popView.badgePopModel?.badgeList != nil && popView.badgePopModel?.badgeList?.count ?? 0 > 0 {
                
                let popModel = popView.badgePopModel?.badgeList![popView.m_currentIndex]
                self?.shareBtnAction(listModel: popModel!)
            }
        })
        self.view.addSubview(popView)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor(screenWid)/3, height: floor(screenWid)/3+10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWid, height: screenWid/414*254+36)
        }
        return CGSize(width: screenWid, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: screenWid, height: 0)
    }
    
    
}
