//
//  HomeView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/31.
//

import UIKit
import MJRefresh

class HomeView: UIView {

    var isPlay = true
    
    var isLoading = false
    var cIndex = "0"
    var cStage = "1"
    var pIndex = "0"
    var pStage = "1"
    
    var scrollY : CGFloat = 0
    var headHei : CGFloat = 0
    //    签到视图
    let qianDaoV = QianDaoView()
    //    搜索逻辑
    let searchView = HQSearchView()
    var collectView : UICollectionView?
    let headView = HomeHeadView()
    var models : [PersonageListModel]? = nil{
        didSet{
            if models != nil {
                if models!.count > 0{
                    self.collectView?.reloadData()
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .init(hex: "#F4F5F6")
        let searchBG = UIView()
        searchBG.backgroundColor = .white
        self.addSubview(searchBG)
        searchBG.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.height.equalTo(62)
            make.right.equalTo(0)
            make.top.equalTo(0)
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
        
        
        headHei = headView.myHei + 10
        
        let layout = UICollectionViewFlowLayout.init()
        
        collectView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectView!.register(CourseInfoCell.self, forCellWithReuseIdentifier: "KeChengInfoCell")
        collectView?.register(CourseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "KeChengHeaderView")
        collectView?.backgroundColor = .init(hex: "#F4F5F6")
        collectView?.showsVerticalScrollIndicator = false
        collectView?.dataSource = self
        collectView?.delegate = self
        
        collectView?.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.height.equalTo(headHei)
            make.left.equalTo(0)
            make.width.equalTo(screenWid)
            make.top.equalTo(-headHei)
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
            self.getNetInfo()
        })
        collectView?.contentInsetAdjustmentBehavior = .never
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        isLoading = true
        headView.bannerView.type = 1
        headView.bannerView.getNetInfo()
        headView.getNetInfo()
        NetworkProvider.request(.homeListData(cIndex: cIndex, cStage: cStage, pIndex: pIndex, pStage: pStage)) { result in
            self.collectView?.mj_footer?.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = false
            }
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            let homeModel = dic.kj.model(HomeListModel.self)
                            
                            if homeModel != nil{
                                self.cIndex = homeModel!.cIndex ?? "0"
                                self.cStage = homeModel!.cStage ?? "1"
                                self.pIndex = homeModel!.pIndex ?? "0"
                                self.pStage = homeModel!.pStage ?? "1"
                            }
                            
                            if homeModel?.content != nil  {
                                self.models = (self.models ?? []) + homeModel!.content!
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

}

extension HomeView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeChengInfoCell", for: indexPath) as! CourseInfoCell
        if (self.models?.count ?? 0) > indexPath.row {
            cell.mainView.model = self.models?[indexPath.row]
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models![indexPath.row]
        var type = model.genre
        if type == 1 {
            type = 2
        }else if type == 6 {
            type = 3
        }else if type == 3 {
            type = 4
        }else if type == 4 {
            type = 5
        }else if type == 5 {
            type = 6
        }
        if type == 2 || type == 3 {
            ///上报事件
            HQPushActionWith(name: "click_course_detail", dic:  ["current_page":"首页瀑布流",
                                                                 "course_frstcate":"",
                                                                 "course_secondcate":""
                                                                 ,"course_id":model.id ?? ""
                                                                 ,"course_title":model.title ?? ""])
        }
        GotoTypeVC(type: type, cid: model.id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = models?[indexPath.row]
        return CGSize(width: model?.wid ?? 0, height: model?.modelHei ?? 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sy = scrollView.contentOffset.y
        if sy > -203 && sy > scrollY{
            self.isPlay = false
            self.headView.midView.player.pause()
        }else if(sy < scrollY && sy < -203){
            self.isPlay = true
            self.headView.midView.player.play()
        }
        
        self.scrollY = sy
        if sy < -(headHei + 80) {
            if isLoading {
                return
            }
            self.cIndex = "0"
            self.cStage = "1"
            self.pIndex = "0"
            self.pStage = "1"
            self.models?.removeAll()
            self.headView.midView.model = nil
            self.getNetInfo()
        }
    }
}
