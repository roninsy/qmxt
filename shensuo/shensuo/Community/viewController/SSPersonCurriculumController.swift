//
//  SSPersonCurriculumController.swift
//  shensuo
//
//  Created by  yang on 2021/7/3.
//

import UIKit
import SnapKit
import JXPagingView
import Toast_Swift
import MJRefresh

class SSPersonCurriculumController: HQBaseViewController {

    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var isLoading = false
    var typeId = ""
    // 0 课程 1 方案
    var type = 0
    var nowPage = 1
    var scrollY : CGFloat = 0
    var headHei : CGFloat = 50
    
    var collectView : UICollectionView?
    let headView = SSPersonCurriculumHeadView()
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
                    strArr.append("全部\(type == 0 ? "课程" : "方案")")
                    for model in typeModels! {
                        strArr.append("\(model.name ?? "")\(type == 0 ? "课程" : "方案")")
                    }
                    self.headView.selView.dataSource.titles = strArr
                    self.headView.selView.dataSource.reloadData(selectedIndex: 0)
                    self.headView.selView.segmentedView.reloadData()
//                    self.typeId = typeModels?[0].id ?? ""
                    self.getListData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        HQRoude(view: self.view, cs: [.topLeft,.topRight], cornerRadius: 16)
        buildUI()
        getNetInfo()
    }
    
    func buildUI()  {
        
        self.view.backgroundColor = .init(hex: "#F7F8F9")
   

        let layout = UICollectionViewFlowLayout.init()
    
        
        collectView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectView!.register(CourseInfoCell.self, forCellWithReuseIdentifier: "KeChengInfoCell")
        collectView?.register(SSPersonCurriculumHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "KeChengHeaderView")
        collectView?.backgroundColor = .white
        collectView?.showsVerticalScrollIndicator = false
        collectView?.dataSource = self
        collectView?.delegate = self
        
        collectView?.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.height.equalTo(headHei)
            make.left.equalToSuperview()
            make.width.equalTo(screenWid)
            make.top.equalTo(0)
        }
        
        view.addSubview(collectView!)
        collectView?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(view).offset(10)
            make.bottom.equalTo(-(SafeBottomHei + 49))
        })
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        collectView?.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectView?.contentOffset = CGPoint.init(x: 0, y: 0)
        
        collectView!.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            self.nowPage += 1
            self.getListData()
        })
        
        collectView?.contentInsetAdjustmentBehavior = .never
       
       
        self.headView.selView.selIndex = {[weak self] index in
            var model: CourseTypeModel?
            if index != 0 {
                
                model = self!.typeModels![index - 1]
                self?.typeId = model?.id ?? ""
            }else{
                
                self?.typeId = ""
            }
            self!.models?.removeAll()
            self!.collectView?.reloadData()
            self!.nowPage = 1
            self!.getListData()
        }
    }

    func getNetInfo(){
        self.isLoading = true
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
        CourseNetworkProvider.request(.selectCourseReferrerApp(firstCategoryId: self.typeId, type: self.type, number: nowPage, pageSize: 10)) { result in
            
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
                            }else{
                                self.collectView?.mj_footer?.endRefreshingWithNoMoreData()
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

extension SSPersonCurriculumController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeChengInfoCell", for: indexPath) as! CourseInfoCell
        
        cell.mainView.model = self.models?[indexPath.row]
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
        let vc = CourseDetalisVC()
        vc.cid = model.id ?? ""
        ///上报事件
        HQPushActionWith(name: "click_course_detail", dic:  ["current_page":"我的主页",
                                                             "course_frstcate":"",
                                                                 "course_secondcate":"",
                                                                 "course_id":model.id ?? "",
                                                                 "course_title":model.title ?? ""])
        HQPush(vc: vc, style: .lightContent)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = models?[indexPath.row]
        return CGSize(width: (screenWid - 24 - 12) / 2, height: model?.modelHei ?? 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollY < 0 && scrollView.contentOffset.y > 0 {
            self.reloadSelView()
            
        }else if scrollY > 0 && scrollView.contentOffset.y < 0{
            self.headView.resetSelView()
        }
        scrollY = scrollView.contentOffset.y
        if scrollY < -(headHei + 80) {
            if isLoading {
                return
            }
            self.nowPage = 1
            self.headView.selView.segmentedView.selectItemAt(index: 0)
            self.headView.selView.segmentedView.reloadData()
//            self.headView.selView
            self.getNetInfo()
        }
        self.listViewDidScrollCallback!(scrollView)

    }

    func reloadSelView(){
        self.headView.selView.removeFromSuperview()
        self.view.addSubview(self.headView.selView)
        self.headView.selView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(10)
            make.width.equalTo(screenWid)
            make.top.equalTo(collectView!)
        }
    }
}
extension SSPersonCurriculumController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        
        return self.view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.collectView!
    }
}
