//
//  SSPersonGiftStandCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/29.
//

import UIKit

class SSPersonGiftStandCell: UITableViewCell,UICollectionViewDataSource {

    var giftArr: [GiftUserModel]? = nil {
        
        didSet{
            
            if giftArr?.count ?? 0 > 0  {
                
//                emptyV.isHidden = true
                collectionView?.reloadData()

            }
        }
    }
    var emptyV: SSCommonGiftEmptyView = SSCommonGiftEmptyView()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return giftArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SSPersonGiftStandCollectionCell.self), for: indexPath) as! SSPersonGiftStandCollectionCell
        cell.model = giftArr?[indexPath.item]
        return cell
        
    }
    

    var collectionView: UICollectionView?
    let marginV = UIView.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screenWid / 4, height: 110)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.dataSource = self
        contentView.addSubview(collectionView!)
        collectionView?.backgroundColor = .white
       
        collectionView?.isPagingEnabled = true
        collectionView?.register(SSPersonGiftStandCollectionCell.self, forCellWithReuseIdentifier: String(describing: SSPersonGiftStandCollectionCell.self))
        
        
        contentView.addSubview(marginV)
        marginV.backgroundColor = bgColor
        marginV.backgroundColor = .white
        collectionView?.snp.makeConstraints({ make in
            
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(230)
        })
        marginV.snp.makeConstraints { make in
            
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(22)
//            make.bottom.equalTo(collectionView!.snp.bottom)
        }
        
//        contentView.addSubview(emptyV)
//        emptyV.snp.makeConstraints { make in
//            
//            make.edges.equalToSuperview()
//        }
//        emptyV.isHidden = true
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        collectionView?.snp.makeConstraints({ make in
//
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(230)
//        })
//        marginV.snp.makeConstraints { make in
//
//            make.leading.bottom.trailing.equalToSuperview()
//            make.height.equalTo(22)
////            make.bottom.equalTo(collectionView!.snp.bottom)
//        }
    }
}

class SSPersonGiftStandCollectionCell: UICollectionViewCell {

    var model: GiftUserModel? = nil {
        
        didSet{
            
            icon.kf.setImage(with: URL.init(string: model!.image ?? ""), placeholder: UIImage.init(named: "Image01"))
            nameL.text = model?.name
            nunL.text = "收到\(model?.total ?? 0)"
        }
    }
    
    var icon = UIImageView.initWithName(imgName: "Image01")
    var nameL: UILabel = UILabel.initSomeThing(title: "鲜花", fontSize: 16, titleColor: color33)
    
    var nunL: UILabel = UILabel.initSomeThing(title: "收到", fontSize: 10, titleColor: color99)
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(36)
        }
        
        contentView.addSubview(nameL)
        nameL.snp.makeConstraints { make in
            
            make.top.equalTo(icon.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(nunL)
        nunL.snp.makeConstraints { make in
            
            make.top.equalTo(nameL.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

