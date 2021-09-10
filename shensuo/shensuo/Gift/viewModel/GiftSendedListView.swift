//
//  GiftSendedListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/1.
//

import UIKit

class GiftSendedListView: UIView {
    var listView : UICollectionView!
    var uid = ""
    var sid = ""
    let pageFlagView = UIView()
    
    let whiteBg = UIView()
    let sanjiao = UIImageView.initWithName(imgName: "gift_sanjiao")
    var giftArr : [GiftUserModel] = NSArray() as! [GiftUserModel]{
        didSet{
            self.listView.reloadData()
        }
    }
    var sanJiaoX : Double = 0{
        didSet{
            if sanJiaoX != 0{
                sanjiao.snp.updateConstraints { make in
                    make.left.equalTo(sanJiaoX)
                }
            }
        }
    }
    
    var nowPage = 0{
        didSet{
            pageFlagView.snp.updateConstraints { make in
                make.left.equalTo(nowPage * 30)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        whiteBg.backgroundColor = .white
        whiteBg.layer.shadowColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.3).cgColor
        whiteBg.layer.shadowOffset = CGSize(width: 0, height: 4)
        whiteBg.layer.shadowOpacity = 0.3
        whiteBg.layer.shadowRadius = 8
        let layer = CALayer()
        layer.frame = whiteBg.bounds
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        whiteBg.layer.addSublayer(layer)
        whiteBg.layer.cornerRadius = 8;
        self.addSubview(whiteBg)
        whiteBg.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(sanjiao)
        sanjiao.snp.makeConstraints { make in
            make.height.equalTo(13.5)
            make.top.equalTo(2)
            make.width.equalTo(21)
            make.left.equalTo(0)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: (screenWid - 30) / 3, height: 92)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        listView = UICollectionView.init(frame: .init(x: 0, y: 0, width: screenWid, height: 250), collectionViewLayout: layout)
        listView.backgroundColor = .clear
        listView.register(GiftSendedListItemView.self, forCellWithReuseIdentifier: "GiftSendedListItemView")
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.height.equalTo(190)
        }
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        listView.delegate = self
        listView.dataSource = self
        listView.isPagingEnabled = true
        
        let pageBG = UIView()
        pageBG.layer.cornerRadius = 1.5
        pageBG.layer.masksToBounds = true
        pageBG.backgroundColor = .init(hex: "#FD8024")
        pageBG.alpha = 0.2
        self.addSubview(pageBG)
        pageBG.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(3)
            make.centerX.equalToSuperview()
            make.top.equalTo(listView.snp.bottom).offset(15)
        }
        
        pageFlagView.layer.cornerRadius = 1.5
        pageFlagView.layer.masksToBounds = true
        pageFlagView.backgroundColor = .init(hex: "#FD8024")
        pageBG.addSubview(pageFlagView)
        pageFlagView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(3)
            make.left.equalTo(0)
            make.top.equalToSuperview()
        }
    }
    
    func getNetInfo() {
        GiftNetworkProvider.request(.giftStand(userId: uid)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            if model?.data != nil{
                                self.giftArr = model!.data!.kj.modelArray(GiftUserModel.self)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension GiftSendedListView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GiftSendedListItemView = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftSendedListItemView", for: indexPath) as! GiftSendedListItemView
        cell.model = giftArr[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x : Int = Int(scrollView.contentOffset.x)
        if x > 0 {
            nowPage = x / Int(screenWid - 22) + ((x % Int(screenWid - 22) > 0) ? 1 : 0)
        }else if x <= 0{
            nowPage = 0
        }
    }
}

