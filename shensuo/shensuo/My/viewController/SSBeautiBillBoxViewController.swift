//
//  SSBeautiBillBoxViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/4.
//

import UIKit

//美币魔盒
class SSBeautiBillBoxViewController: HQBaseViewController {
    
    var dataCollection:UICollectionView!
    var point:Int?
    
    var oid : String? = nil
    var payType : String? = nil
    
    var headView : SSBeautiReusableView!
    
    var billBoxModels : [SSBillBoxModel]? = nil{
        didSet{
            if billBoxModels != nil {
                self.dataCollection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(payCallBack(notifi:)), name: PayCompletionNotification, object: nil)
        
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screenWid/2-15, height: (screenWid/2-15)/193*229)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: screenWid, height: screenWid/414*320)
        
        dataCollection = UICollectionView.init(frame: CGRect(x: 0, y: -statusHei, width: screenWid, height: screenHei), collectionViewLayout: layout)
        dataCollection.backgroundColor = .white
        dataCollection.delegate = self
        dataCollection.dataSource = self
        dataCollection.register(SSBeautiReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        dataCollection.register(SSBeautiCollectionCell.self, forCellWithReuseIdentifier: "SSBeautiCollectionCell")
        
        self.view.addSubview(dataCollection)
        // Do any additional setup after loading the view.
        
        self.loadData()
        self.getPoints()
    }
    
    ///完成支付回调
    @objc func payCallBack(notifi : Notification){
        self.headView.mainMeiBiView.isHidden = true
        self.headView.mainMeiBiView.removeFromSuperview()
        
        self.point = UserInfo.getSharedInstance().points ?? 0
        self.dataCollection.reloadData()
    }
    
    ///获取美币数
    func getPoints() {
        UserInfoNetworkProvider.request(.findPoints) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultIntModel.self)
                        if model?.code == 0 {
                            UserInfo.getSharedInstance().points = model?.data
                            self.point = model?.data ?? 0
                            self.dataCollection.reloadData()
                        }
                    }
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")

            }
        }
    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func clickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickOption() {
        self.navigationController?.pushViewController(SSBeautiBillTaskViewController(), animated: true)
    }

    func loadData() -> Void {
        UserInfoNetworkProvider.request(.selectExchanges) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultArrModel.self)
                            if model?.code == 0 {
                                let arr = model?.data
                                if arr == nil {
                                    return
                                }
                                self.billBoxModels = arr?.kj.modelArray(type: SSBillBoxModel.self) as? [SSBillBoxModel]                                
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

extension SSBeautiBillBoxViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? SSBeautiReusableView
        
        self.headView.navView.backBtn.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        self.headView.navView.optionBtn.addTarget(self, action: #selector(clickOption), for: .touchUpInside)
        self.headView.valueLabel.text = String(self.point ?? 0)
        return self.headView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.billBoxModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SSBeautiCollectionCell", for: indexPath) as! SSBeautiCollectionCell
        cell.boxModel = self.billBoxModels?[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.billBoxModels?[indexPath.row]
        if Double(self.point ?? 0) > (model?.needPoints ?? 0){
            commonSureAlertAction(sureStr: "立即兑换", cancleStr: "取消", title: "\(model?.name ?? "抵扣券")", content: "\(model?.needPoints ?? 0)美币") { result in
               
                self.buyExchanges(mid: model!)
            }
        }else{
            self.view.makeToast("美币余额不足")
        }
    }
    
    
    ///兑换券
    func buyExchanges(mid: SSBillBoxModel){
        UserInfoNetworkProvider.request(.buyExchanges(mId: mid.id ?? "")) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultBoolModel.self)
                        if model?.data == true{
                            
                            self.point = self.point! - Int(mid.needPoints!)
                            ///兑换成功
                            HQGetTopVC()?.view.makeToast("兑换成功")
                            self.loadData()
//                            self.navigationController?.popViewController(animated: true)
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
