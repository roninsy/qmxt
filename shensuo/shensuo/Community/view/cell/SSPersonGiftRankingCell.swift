//
//  SSPersonGiftRankingCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/29.
//

import UIKit

class SSPersonGiftRankingCell: UITableViewCell, UICollectionViewDataSource {
    
    var listArray:Array<Any>?
    var rankModels : GiftRankModel? = nil {
        
        didSet{
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SSPersonGiftRankingCollectionCell.self), for: indexPath)
        return cell
        
    }
    

    var collectionView: UICollectionView?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screenWid / 4, height: 110)
        collectionView = UICollectionView.init(frame: contentView.bounds, collectionViewLayout: layout)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.dataSource = self
        contentView.addSubview(collectionView!)
        collectionView?.isPagingEnabled = true
        collectionView?.register(SSPersonGiftRankingCollectionCell.self, forCellWithReuseIdentifier: String(describing: SSPersonGiftRankingCollectionCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SSPersonGiftRankingCollectionCell: UICollectionViewCell {

    var icon = UIImageView.initWithName(imgName: "")
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
