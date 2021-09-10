//
//  SSBadgePopView.swift
//  shensuo
//
//  Created by  yang on 2021/5/27.
//

import UIKit

class SSBadgePopView: UIView {
    
    /// Cell Identifier
    private let CellIdentifier_Badge = "qmxt_cell_identifier_badge"
    
    /// Cell
    fileprivate
    class _BadgeFlowCell: UICollectionViewCell {
        
        var imageView: UIImageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // subview
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(screenWid/2)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /// Flow Layout
    fileprivate
    class badgeFlowLayout: UICollectionViewFlowLayout {
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let array = super.layoutAttributesForElements(in: rect)
    //        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.bounds.size.width/2
            for attributes in array!{
                
    //            let distance = abs(attributes.center.x - centerX);
    //            let apartScale = distance/self.collectionView!.bounds.size.width;
    //            let scale = fabs(cos(Double(apartScale) * .pi/4));
    //            attributes.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale));
                
                let disWithCenter = abs((attributes.center.x - self.collectionView!.contentOffset.x) - self.collectionView!.bounds.size.width * 0.5);
                
                let scale = 1 - disWithCenter / (self.collectionView!.bounds.size.width * 0.5) * 0.4;

                attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
    //            attributes.transform = CGAffineTransformMakeScale(scale, scale);
            }
            
            return array
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            let targetProposed = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            
    //        let attributeArray = super.layoutAttributesForElements(in:CGRect(x: targetProposed.x, y: 0, width: self.collectionView?.bounds.size.width, height: MAXFLOAT))
            
            
    //        //获取当前范围内显示的cell
    //        NSArray *attributeArray = [super layoutAttributesForElementsInRect:CGRectMake(targetProposed.x, 0, self.collectionView.bounds.size.width, MAXFLOAT)];
    //        //寻找距离中心点最近的图片
    //        CGFloat minDis = MAXFLOAT;
    //        for (UICollectionViewLayoutAttributes *attr in attributeArray) {
    //            CGFloat disWithCenter = (attr.center.x - targetProposed.x) - self.collectionView.bounds.size.width * 0.5;
    //
    //            if(fabs(disWithCenter) < fabs(minDis)){
    //                minDis = disWithCenter;
    //            }
    //        }
    //        //停止滚动后可能没有图片在中间，所以我们要计算距离中间最近的图片，然后偏移过去
    //        targetProposed.x += minDis;
    //        if(targetProposed.x < 0){
    //            targetProposed.x = 0;
    //        }
            
            return targetProposed
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }
        
    }
    
    // model
    var badgeModel:badgeCateGoryModel?
    
    // model
    var badgePopModel:SSBadgePopModel? {
        didSet {
            if badgePopModel != nil {
                self.mainCollectionView?.contentSize = CGSize(width: badgePopModel!.badgeList!.count*Int(screenWid/2), height: Int(screenWid)/2)
                
                self.mainCollectionView!.reloadData()
                mainCollectionView?.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: true)
                
                pageControl.numberOfPages = badgePopModel?.badgeList?.count ?? 0
                if pageControl.numberOfPages > 1 {
                    pageControl.currentPage = 0
                    self.setCurrentData()
                }
                
            }
        }
    }

    // 背景
    var bgImageView = UIImageView.initWithName(imgName: "my_badgePopBg")
    // close
    var closeBtn = UIButton.initBgImage(imgname: "my_badge_close")
    
    //
    var mainCollectionView : UICollectionView?
    // page control
    var pageControl = UIPageControl.init()
    // 记录天数
    var timeLabel = UILabel.init()
    // 高光img
    var gaoGView = UIImageView.initWithName(imgName: "my_badge_gaoguang")
    // 左翼ing
    var leftImage = UIImageView.initWithName(imgName: "my_badge_left")
    // 右翼ing
    var rightImage = UIImageView.initWithName(imgName: "my_badge_right")
    // 获得\未获得
    var centerLabel = UILabel.init()
    
    var m_dragStartX : CGFloat = 0
    var m_dragEndX : CGFloat = 0
    var m_currentIndex : Int = 0
    
    // 分享
    var shareBtn = UIButton.init()
    
    //
    var nameLabel = UILabel.initSomeThing(title: "连续训练5天徽章", titleColor: .init(hex: "#FFFFFF"), font: .SemiboldFont(size: 24), ali: .center)
    
    //
    var resultLabel = UILabel.initSomeThing(title: "已获得", titleColor: .init(hex: "#FD8024"), font: .systemFont(ofSize: 18), ali: .center)
    
    //
    var dateLabel = UILabel.initSomeThing(title: "2021-10-02", fontSize: 18, titleColor: .init(hex: "#FFFFFF"))
    
    //
    func setCurrentData() -> Void {
        let model = self.badgePopModel?.badgeList?[1]
        nameLabel.text = model?.name
        dateLabel.text = model!.type ? model?.createdTime : self.badgePopModel?.currentMessage
        resultLabel.text = model!.type ? "已获得" : "未获得"
        shareBtn.setTitle(model!.type ? "分享" : "去获取", for: .normal)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = badgeFlowLayout.init()
        layout.itemSize = CGSize(width: screenWid/2, height: screenWid/2)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 150, width: screenWid, height: screenWid/2), collectionViewLayout: layout)
        mainCollectionView!.delegate = self
        mainCollectionView!.dataSource = self
        // _BadgeFlowCell
        mainCollectionView!.register(_BadgeFlowCell.self, forCellWithReuseIdentifier: CellIdentifier_Badge)
        mainCollectionView!.backgroundColor = .clear
        
        
        addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgImageView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(70)
            make.width.height.equalTo(18)
        }
        
        bgImageView.addSubview(mainCollectionView!)
        
//        bgImageView.addSubview(gaoGView)
//        gaoGView.snp.makeConstraints { (make) in
//            make.top.equalTo(mainCollectionView!.snp.bottom).offset(-20)
//            make.centerX.equalToSuperview()
//        }
        
        bgImageView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainCollectionView!.snp.bottom).offset(20)
            make.height.equalTo(33)
            make.centerX.equalToSuperview()
        }
        
        bgImageView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        
        bgImageView.addSubview(leftImage)
        leftImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(resultLabel)
            make.right.equalTo(resultLabel.snp.left).offset(-12)
        }
        
        bgImageView.addSubview(rightImage)
        rightImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(resultLabel)
            make.left.equalTo(resultLabel.snp.right).offset(12)
        }
        
        bgImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(resultLabel.snp.bottom).offset(35)
        }
        
        bgImageView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        bgImageView.addSubview(shareBtn)
        bgImageView.isUserInteractionEnabled = true
        shareBtn.layer.masksToBounds = true
        shareBtn.layer.cornerRadius = 15
        shareBtn.backgroundColor = .init(hex: "#FD8024")
        shareBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageControl.snp.bottom).offset(60)
            make.width.equalTo(screenWid-120)
            make.height.equalTo(60)
        }
        
    }
    
   
    
    func fixCellToCenterScale() {
        
        let dragMiniDistance: Float = Float(screenWid / 4)
        //大小
        let scrW = screenWid / 2
        //滚动几个
        let scrIndex: Int = Int(abs(self.m_dragStartX -  self.m_dragEndX) / scrW)
        //取模
        
        let scr1: Float = fabsf(Float(self.m_dragStartX -  self.m_dragEndX)).truncatingRemainder(dividingBy: Float(scrW))
        
        if (self.m_dragStartX > self.m_dragEndX) {
            //向右
            if scr1 > dragMiniDistance {
                
                m_currentIndex -= scrIndex + 1
            }else{
                
                m_currentIndex -= scrIndex
            }
        }else if(self.m_dragEndX >  self.m_dragStartX){
            if scr1 > dragMiniDistance {
                
                m_currentIndex += scrIndex + 1
            }else{
                
                m_currentIndex += scrIndex
            }
        }
        let maxIndex = mainCollectionView?.numberOfItems(inSection: 0) ?? 0 - 1
        
        
        self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
        self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
        
        pageControl.currentPage = self.m_currentIndex
        if self.m_currentIndex >= self.badgePopModel?.badgeList?.count ?? 0 {
            self.m_currentIndex = self.badgePopModel?.badgeList?.count ?? 0 - 1
            return
        }
        
        let model = self.badgePopModel?.badgeList?[self.m_currentIndex]
        nameLabel.text = model?.name
        dateLabel.text = model!.type ? model?.createdTime : model?.conditionRemark
        resultLabel.text = model!.type ? "已获得" : "未获得"
        shareBtn.setTitle(model!.type ? "分享" : "去获取", for: .normal)
        
        mainCollectionView?.scrollToItem(at: IndexPath.init(row: self.m_currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func fixCellToCenter() -> Void {
        let dragMiniDistance = self.bounds.size.width/20.0
        if (self.m_dragStartX -  self.m_dragEndX >= dragMiniDistance) {
            self.m_currentIndex -= 1//向右
        }else if(self.m_dragEndX -  self.m_dragStartX >= dragMiniDistance){
            self.m_currentIndex += 1//向左
        }
        let maxIndex = mainCollectionView?.numberOfItems(inSection: 0) ?? 0 - 1
        
        
        self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
        self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
        
        pageControl.currentPage = self.m_currentIndex
        if self.m_currentIndex >= self.badgePopModel?.badgeList?.count ?? 0 {
            self.m_currentIndex = self.badgePopModel?.badgeList?.count ?? 0 - 1
            return
        }
        
        let model = self.badgePopModel?.badgeList?[self.m_currentIndex]
        nameLabel.text = model?.name
        dateLabel.text = model!.type ? model?.createdTime : model?.conditionRemark
        resultLabel.text = model!.type ? "已获得" : "未获得"
        shareBtn.setTitle(model!.type ? "分享" : "去获取", for: .normal)
        
        mainCollectionView?.scrollToItem(at: IndexPath.init(row: self.m_currentIndex, section: 0), at: .centeredHorizontally, animated: true)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.m_dragStartX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.m_dragEndX = scrollView.contentOffset.x
        self.fixCellToCenterScale()


    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
////        self.m_dragEndX = scrollView.contentOffset.x
////        self.fixCellToCenterScale()
//        scrollViewDidEndScrollingAnimation(scrollView)
//    }
    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        self.m_dragEndX = scrollView.contentOffset.x
//        self.fixCellToCenterScale()
//    }
    
    func loadBadgeDetail(model:badgeCateGoryModel) -> Void {
        self.badgeModel = model
        UserInfoNetworkProvider.request(.getBadgeDetailsList(id: self.badgeModel?.id ?? "")) { (result) in
            switch result {
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
                                self.badgePopModel = dic?.kj.model(SSBadgePopModel.self)
                                
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Collection Delegate
extension SSBadgePopView:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badgePopModel?.badgeList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier_Badge, for: indexPath) as! _BadgeFlowCell
        
        let model = self.badgePopModel?.badgeList?[indexPath.row]
        cell.imageView.kf.setImage(with: URL.init(string: model!.image), placeholder: UIImage.init(named: "place_badge_normal"), options: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWid/2, height: screenWid/2)
    }
}

