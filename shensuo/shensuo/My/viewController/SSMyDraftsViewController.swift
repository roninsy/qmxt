//
//  SSMyDraftsViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/6.
//

import UIKit

//草稿箱
class SSMyDraftsViewController: SSBaseViewController {
    
    var notView : UIView!
    
    var nodataView = SSNoDataView()

    var dataCollection:UICollectionView!
    var page = 1
    let pageSize = 10
    
    var draftModels:[SSDraftModel]? = nil {
        didSet{
            if draftModels != nil {
                if draftModels!.count > 0 {
                    self.dataCollection.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ishideBar = true
    
        navView.backBtnWithTitle(title: "草稿箱")
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screenWid/2-17, height: (screenWid/2-17)/193*322)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        self.dataCollection = UICollectionView.init(frame: CGRect(x: 0, y: NavBarHeight+20, width: screenWid, height: screenHei-NavBarHeight-20), collectionViewLayout: layout)
        self.dataCollection.register(SSDraftsCell.self, forCellWithReuseIdentifier: "SSDraftsCell")
        self.dataCollection.delegate = self
        self.dataCollection.dataSource = self
        self.dataCollection.backgroundColor = .init(hex: "#F7F8F9")
        self.view.addSubview(dataCollection)
        self.dataCollection!.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadDraftsData()
        })
        
        
        notView = nodataView.showNoDataView(imageName: "nodata_caogao", notes: "暂无草稿")
        self.view.addSubview(notView)
        notView.snp.makeConstraints { make in
            make.height.equalTo(289)
            make.width.equalTo(screenWid)
            make.left.equalToSuperview()
            make.top.equalTo(navView.snp.bottom)
        }
        notView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.page = 1
        self.loadDraftsData()

    }
    
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count < page*pageSize {
            self.dataCollection.mj_footer?.isHidden = true
        }
    }
    
    func loadDraftsData() -> Void {
        
        
        UserInfoNetworkProvider.request(.draftList(userId: (UserInfo.getSharedInstance().userId) ?? "", pageNumber: page, size: pageSize)) { [self] result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode

                    if code == 200{
                        let json = try moyaResponse.mapString()
                      
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let arr = model?.data
                            if arr == nil || arr?.count == 0 {
                                
                                self.dataCollection?.mj_footer?.endRefreshingWithNoMoreData()
                                if self.draftModels?.count ?? 0 > 0 {
                                    
                                    self.isHiddenFooter(model: self.draftModels as AnyObject)
                                    
                                    HQGetTopVC()?.view.makeToast("没有更多数据了")
                                }
                                return
                            }
                            if self.page == 1 {
                                self.draftModels = arr?.kj.modelArray(type: SSDraftModel.self)
                                    as? [SSDraftModel]
                                
                            }else{
                                let models = arr?.kj.modelArray(type: SSDraftModel.self)
                                    as? [SSDraftModel]
                                self.draftModels = self.draftModels! + (models ?? [])
                            }
//                            self.isHiddenFooter(model: self.draftModels as AnyObject)
                         
                        }else{
                            self.dataCollection?.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    
    }
    
    func deleteDraft(model : SSDraftModel, index: Int) -> Void {
        UserInfoNetworkProvider.request(.deletaDraft(noteId: model.id!)) { (result) in
            switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                self.draftModels?.remove(at: index)
                                self.dataCollection.reloadData()
                             
                            }else{
                                
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSMyDraftsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        notView.isHidden = (self.draftModels?.count ?? 0) != 0
        
        guard (self.draftModels == nil) else {
            return self.draftModels!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SSDraftsCell", for: indexPath) as! SSDraftsCell
        dataCell.draftModel = self.draftModels![indexPath.row]
        dataCell.deleteBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            
            self.cancleSureAlertAction(title: "您确定要删除此草稿箱吗?", content: "") { result in
                
                self.deleteDraft(model: self.draftModels![indexPath.row], index: indexPath.row)
                
            }
        }
        return dataCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model: SSDraftModel = draftModels![indexPath.item]
        var notsModel = SSNotesDetaileModel()
        notsModel.title = model.title ?? ""
        notsModel.headerImageUrl = model.headerImageUrl ?? ""
        notsModel.content = model.content ?? ""
        notsModel.imageUrls = model.imageUrls ?? []
        notsModel.address = model.address ?? ""
        notsModel.authorId = model.authorId ?? ""
        notsModel.videoUrl = model.videoUrl ?? ""
        notsModel.musicUrl = model.musicUrl ?? ""
        notsModel.id = model.id
        let vc = SSReleaseNewsViewController()
        vc.notesDetaile = notsModel
        vc.inType = 7
        HQPush(vc: vc, style: .default)
        
        
    }
    
    
}
