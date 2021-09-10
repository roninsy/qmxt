//
//  KeChengView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/5.
//

import UIKit
import MJRefresh
import MBProgressHUD

class CourseView: UIView {
    var isLoading = false
    var typeId = ""
    //0 课程 1 方案
    var type = 0
    
    var nowPage = 1
    var scrollY : CGFloat = 0
    var headHei : CGFloat = 0
    var sHeadHei : CGFloat = 0
//    签到视图
    let qianDaoV = QianDaoView()
//    搜索逻辑
    let searchView = HQSearchView()
    var reusableView : CourseHeaderView?
    var collectView : UICollectionView?
    let headView = CourseHeaderView()
    
    let nodataView = SearchNoDataView()
    var models : [PersonageListModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                    self.collectView?.reloadData()
                }
            }
        }
    }
    
    var typeModels : [CourseTypeModel]? = nil{
        didSet{
            if typeModels != nil {
                if typeModels!.count > 0{
                    var strArr : [String] = NSMutableArray() as! [String]
                    for model in typeModels! {
                        strArr.append(model.name ?? "")
                    }
                    self.headView.selView.dataSource.titles = strArr
                    self.headView.selView.dataSource.reloadData(selectedIndex: 0)
                    self.headView.selView.segmentedView.reloadData()
                    self.typeId = typeModels?[0].id ?? ""
                    ///如果图片不为空，则增加图片高度
                    let botImgStr = typeModels![0].bannerImage ?? ""
                    if botImgStr.length > 0 {
                        self.headView.botImg.isHidden = false
                        self.headView.botImg.kf.setImage(with: URL.init(string: botImgStr))
                    }else{
                        self.headView.botImg.isHidden = true
                    }
                    
                    self.sHeadHei = self.headHei + (botImgStr.length > 0 ? self.headView.botImgHei : 0)
                    self.collectView?.contentInset = .init(top: self.sHeadHei, left: 0, bottom: 0, right: 0)
                    self.headView.snp.updateConstraints({ make in
                        make.height.equalTo(self.sHeadHei)
                        make.top.equalTo(-self.sHeadHei)
                    })
                    
                    headView.midView.models = typeModels!
                    self.getListData()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .init(hex: "#F7F8F9")
        
        let searchBG = UIView()
        searchBG.backgroundColor = .white
        self.addSubview(searchBG)
        searchBG.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.top.equalToSuperview()
        }
        
        searchView.nameTf.text = "热门课程"
        self.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.height.equalTo(52)
            make.right.equalTo(-54)
            make.top.equalTo(0)
        }
        self.addSubview(qianDaoV)
        qianDaoV.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(-11)
            make.centerY.equalTo(searchView)
        }
        
        headHei = headView.bannerWid / 394 * 168 + 96 + headView.midView.myHei - 27
        sHeadHei = headHei

        let layout = UICollectionViewFlowLayout.init()
        collectView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectView!.register(CourseInfoCell.self, forCellWithReuseIdentifier: "KeChengInfoCell")
        collectView?.register(CourseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "KeChengHeaderView")
        collectView?.backgroundColor = .white
        collectView?.showsVerticalScrollIndicator = false
        collectView?.dataSource = self
        collectView?.delegate = self
        
        collectView?.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.height.equalTo(headHei)
            make.left.equalToSuperview()
            make.width.equalTo(screenWid)
            make.top.equalTo(-headHei)
        }
        
        nodataView.mainImg.image = UIImage.init(named: "my_nosc")
        nodataView.tipLab.text = "暂无课程"
        collectView?.addSubview(nodataView)
        nodataView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(0)
            make.width.equalTo(screenWid)
            make.height.equalTo(500)
        }
        
        self.addSubview(collectView!)
        collectView?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.bottom.equalTo(-(SafeBottomHei + 49))
        })
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        collectView?.contentInset = .init(top: headHei, left: 0, bottom: 0, right: 0)
        collectView?.contentOffset = CGPoint.init(x: 0, y: -headHei)
        
        collectView!.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            self.nowPage += 1
            self.getListData()
        })
        
        collectView?.contentInsetAdjustmentBehavior = .never
       
        self.headView.selView.selIndex = {[weak self] index in
            let model = self!.typeModels?[index]
            self!.typeId = model?.id ?? ""
            let botImgStr = model?.bannerImage ?? ""
            if botImgStr.length > 0 {
                self!.headView.botImg.isHidden = false
                self!.headView.botImg.kf.setImage(with: URL.init(string: botImgStr))
            }else{
                self!.headView.botImg.isHidden = true
            }
            
            self?.sHeadHei = self!.headHei + (botImgStr.length > 0 ? self!.headView.botImgHei : 0)
            self?.collectView?.contentInset = .init(top: self!.sHeadHei, left: 0, bottom: 0, right: 0)
            self?.headView.snp.updateConstraints({ make in
                make.height.equalTo(self!.sHeadHei)
                make.top.equalTo(-self!.sHeadHei)
            })
           
            self!.models?.removeAll()
            self!.collectView?.reloadData()
            self!.nowPage = 1
            self!.getListData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        self.isLoading = true
        headView.bannerView.type = 2
        headView.bannerView.getNetInfo()
        headView.midView.getNetInfo()
        CourseNetworkProvider.request(.coureseType) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = false
            }
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            self.typeModels = model!.data?.kj.modelArray(type: CourseTypeModel.self)
                                as? [CourseTypeModel]
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
    
    func getListData(){
        CourseNetworkProvider.request(.selectCourseReferrerApp(firstCategoryId: self.typeId, type: 0, number: nowPage, pageSize: 100)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model!.data ?? NSDictionary()
                            let total = dic["totalElements"] as? String ?? "0"
                            if (total.toInt ?? 0) > 0 {
                                let arr = dic["content"] as? NSArray ?? NSArray()
                                if self.nowPage == 1 {
                                    self.models = arr.kj.modelArray(type: PersonageListModel.self)
                                        as? [PersonageListModel]
                                }else{
                                    let models = arr.kj.modelArray(type: CourseModel.self)
                                        as? [PersonageListModel]
                                    self.models = self.models! + (models ?? [])
                                }
                            }
                            if (total.toInt ?? 0) <= (self.models?.count ?? 0) {
                                self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
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
}

extension CourseView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeChengInfoCell", for: indexPath) as! CourseInfoCell
        
        cell.mainView.model = self.models?[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = self.models?.count ?? 0
        self.nodataView.isHidden = num > 0
        collectView?.contentInset = .init(top: sHeadHei, left: 0, bottom: self.nodataView.isHidden ? 0 : 300, right: 0)
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models![indexPath.row]
        let vc = CourseDetalisVC()
        vc.cid = model.id ?? ""

        ///上报事件
        HQPushActionWith(name: "click_course_detail", dic:  ["current_page":"课程瀑布流",
                                                             "course_frstcate":self.type,
                                                                 "course_secondcate":"0"
                                                                 ,"course_id":model.id ?? ""
                                                                 ,"course_title":model.title ?? ""])
        
        HQPush(vc: vc, style: .lightContent)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = models?[indexPath.row]
        return CGSize(width: model?.wid ?? 0, height: model?.modelHei ?? 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollY < 0 && scrollView.contentOffset.y > 0 {
            self.reloadSelView()
            
        }else if scrollY > 0 && scrollView.contentOffset.y < 0{
            self.headView.resetSelView()
        }
        scrollY = scrollView.contentOffset.y
        if scrollY < -(sHeadHei + 80) {
            if isLoading {
                return
            }
            self.nowPage = 1
            self.headView.selView.segmentedView.selectItemAt(index: 0)
            self.headView.selView.segmentedView.reloadData()
            self.getNetInfo()
        }
    }
    
    func reloadSelView(){
        self.headView.selView.removeFromSuperview()
        self.addSubview(self.headView.selView)
        self.headView.selView.snp.makeConstraints { (make) in
            make.height.equalTo(96)
            make.left.equalTo(10)
            make.width.equalTo(screenWid - 20)
            make.top.equalTo(collectView!)
        }
    }
}
