//
//  SSDetailHeadView.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit
import Kingfisher

//MARK:顶部图片
class SSDetailHeadView: UIView {
    var touchBlock : voidBlock? = nil
    var timer = Timer.init()
    var bScroll: Bool = true
    var link = CADisplayLink()
    var page: NSInteger = 0
    
//    var imagesArray : [UIImage]? = nil {
//        didSet{
//            if imagesArray != nil && imagesArray!.count > 0 {
//                DispatchQueue.main.async(execute: { [self] in
//                    initImageScroll(images: imagesArray! as NSArray)
//                })
//            }
//        }
//    }
    
    var imagesArray : Array? = []
    
    
    var pageControl:UIPageControl = {
        let page = UIPageControl.init()
        page.pageIndicatorTintColor = UIColor.init(hex: "#CBCCCD")
        page.currentPageIndicatorTintColor = UIColor.init(hex: "#FD8024")
        if #available(iOS 14.0, *) {
            page.preferredIndicatorImage = UIImage.init(named: "pageselect")
        } else {
            // Fallback on earlier versions
            page.setValue(UIImage.init(named: "pageselect"), forKeyPath: "_currentPageImage")
        }
//        if #available(iOS 14.0, *) {
//            page.setIndicatorImage(UIImage.init(named: "pagenormal"), forPage: 0)
//        } else {
//            // Fallback on earlier versions
//            page.setValue(UIImage.init(named: "pagenormal"), forKeyPath: "_pageImage")
//        }
        return page
    }()
    

    var headScrollView : UIScrollView = {
        let headScroll = UIScrollView.init()
        headScroll.isPagingEnabled = true
        headScroll.indicatorStyle = .white
        headScroll.showsVerticalScrollIndicator = false
        headScroll.showsHorizontalScrollIndicator = false
        return headScroll
    }()
    
    var giftView : giftHeadView = {
        let gift = giftHeadView.init()
        return gift
    }()
    
//    var musicView = UIView.init()
//    var calendarView = UIView.init()
    
//    let tipView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenWid/414*80))
//    let nameLabel = UILabel.initSomeThing(title: "30天美丽相册,记录变美生活30天美丽相册-记录变美生活", fontSize: 18, titleColor: .init(hex: "#333333"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildSubviews()
    }
    
    @objc func scrollPage() -> Void {
        if page < imagesArray?.count ?? 0 {
            headScrollView.setContentOffset(CGPoint(x: (Int(screenWid))*page, y: 0), animated: true)
            page += 1
        } else {
            
        }
        
    }
    
    @objc func tapImageV() -> Void {
        if bScroll {
//            link.invalidate()
            timer.fireDate = NSDate.distantFuture
            bScroll = false
        } else {
//            link.accessibilityActivate()
//            stopImageView.isHidden = true
            timer.fireDate = NSDate.distantPast
            bScroll = true
        }
    }
    
    func initImageScroll(images:NSArray) -> Void {
        if images.count == 0{
            return
        }
        pageControl.numberOfPages = images.count
        imagesArray = images as? Array<Any>
        for index in 0...images.count-1 {
            let imageview = UIImageView.init(frame: CGRect(x: screenWid*CGFloat(index), y: 0, width: screenWid, height: screenWid/414*546-30))
            imageview.kf.setImage(with: URL.init(string: images[index] as! String), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
            imageview.contentMode = .scaleAspectFill
            imageview.layer.masksToBounds = true
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImageV))
            imageview.tag = 1000 + index
            imageview.isUserInteractionEnabled = true
            imageview.addGestureRecognizer(tap)
            
            headScrollView.addSubview(imageview)
        }
        headScrollView.contentSize = CGSize(width: screenWid*CGFloat(images.count), height: screenWid/414*546-30)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scrollPage), userInfo: nil, repeats: true)

        RunLoop.main.add(timer, forMode: .common)
    }

    func locationImageScroll(images:NSArray) -> Void {
        if images.count == 0{
            return
        }
        pageControl.numberOfPages = images.count
        imagesArray = images as? Array<Any>
        for index in 0...images.count-1 {
            let imageview = UIImageView.init(frame: CGRect(x: screenWid*CGFloat(index), y: 0, width: screenWid, height: screenWid/414*546-30))
            imageview.image = images[index] as? UIImage
            imageview.contentMode = .scaleAspectFill
            imageview.layer.masksToBounds = true
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImageV))
            imageview.tag = 1000 + index
            imageview.isUserInteractionEnabled = true
            imageview.addGestureRecognizer(tap)
            
            headScrollView.addSubview(imageview)
        }
        headScrollView.contentSize = CGSize(width: screenWid*CGFloat(images.count), height: screenWid/414*546-30)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scrollPage), userInfo: nil, repeats: true)

        RunLoop.main.add(timer, forMode: .common)
    }
    
    func buildSubviews() {
        
        addSubview(headScrollView)
        headScrollView.delegate = self
        headScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
//        HQRoude(view: tipView, cs: [.topLeft, .topRight], cornerRadius: 12)
//        addSubview(tipView)
//
//        tipView.snp.makeConstraints { (make) in
//            make.top.equalTo(headScrollView.snp.bottom) //.offset(-12)
//            make.width.equalToSuperview()
//            make.left.equalToSuperview()
//            make.height.equalTo(screenWid/414*80)
//
//        }
        
//        tipView.addSubview(nameLabel)
//        nameLabel.numberOfLines = 0
//        nameLabel.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        }
        
        insertSubview(giftView, aboveSubview: headScrollView)
        giftView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(10)
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        
        
//        headScrollView.addSubview(musicView)
//        musicView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
//        musicView.layer.masksToBounds = true
//        musicView.layer.cornerRadius = 10
//        musicView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(10)
//            make.bottom.equalToSuperview().offset(-20)
//            make.width.equalTo(150)
//            make.height.equalTo(25)
//        }
//        
//        headScrollView.addSubview(calendarView)
//        calendarView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
//        calendarView.layer.masksToBounds = true
//        calendarView.layer.cornerRadius = 10
//        calendarView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(musicView)
//            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(25)
//            make.width.equalTo(120)
//        }
        
//        addSubview(pageControl)
//
//        pageControl.addTarget(self, action: #selector(tapPageControl(page:)), for: .valueChanged)
//        pageControl.snp.makeConstraints { (make) in
//            make.top.equalTo(headScrollView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(30)
//        }
    }
    
//    @objc func tapPageControl(page:UIPageControl) -> Void {
//        var point = CGPoint.zero
//        point.x = CGFloat(page.currentPage)*screenWid
//        point.y = 0
//        headScrollView.setContentOffset(point, animated: true)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchBlock?()
    }

}

extension SSDetailHeadView:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x/screenWid)
    }
}

class giftHeadView: UIView {
    
    var images: [GiftUserModel]? = nil{
        
        didSet{
            
            if images != nil && imageVS != nil{
                
                for index in 0..<imageVS!.count {
                    
                    let img = imageVS![index]
                    if index > images!.count - 1 {
                        
                        return
                    }
                    img.kf.setImage(with: URL.init(string: images![index].headImage ?? "" ), placeholder: UIImage.init(named: "user_normal_icon"))
                }
                
            }
        }
    }
    var imageVS: [UIImageView]?
    
    
    var imageHeight:CGFloat = 24
    var imageWidth:CGFloat = 24
    
    var lineImage:UIImageView = {
        let line = UIImageView.init()
        line.backgroundColor = UIColor.init(hex: "#FFFFFF")
        return line
    }()
    
    var giftBtn:UIButton = {
        let gBtn = UIButton.init()
        gBtn.setTitle("礼物榜", for: .normal)
        gBtn.setImage(UIImage.init(named: "liwubang"), for: .normal)
        gBtn.titleLabel?.font = .systemFont(ofSize: 13)
        gBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        gBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return gBtn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for index in 0...3 {
            let imageV = UIImageView.init(frame: CGRect(x: CGFloat(3-index)*imageWidth/2, y: 3, width: imageWidth, height: imageHeight))
            imageV.layer.masksToBounds = true
            imageV.layer.cornerRadius = imageHeight/2
            if index == 0 {
                imageV.image = UIImage.init(named: "more")
            } else {
                imageV.image = UIImage.init(named: "user_normal_icon")
            }
            
            self.addSubview(imageV)
        }
        
        addSubview(lineImage)
        lineImage.snp.makeConstraints { (make) in
            make.left.equalTo(imageWidth*3)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(13)
        }
        
        addSubview(giftBtn)
        giftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineImage.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dotPageControl: UIPageControl {
    
    var activeImage : UIImage = {
        let active = UIImage.init(named: "qq")
        return active!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
