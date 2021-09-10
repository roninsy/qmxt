//
//  imageTestViewController.swift
//  shensuo
//
//  Created by swin on 2021/3/26.
//

import Foundation
import SnapKit

class imageTestViewController: HQBaseViewController {
    
    var timeView = UIImageView.init()
    var scrollView = UIScrollView.init()
    var imagesArray = [UIImage?]()
    var slibar = UISlider.init()
    var tipLabel = UILabel.init()
    
    var handerView = UIView.init()
    
    var page: NSInteger = 0
    var timer = Timer.init()
    var bScroll: Bool = true
    var stopImageView = UIImageView.init()
    
    var link = CADisplayLink()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        imagesArray = [UIImage.init(named: "001"), UIImage.init(named: "002"), UIImage.init(named: "003"), UIImage.init(named: "004"), UIImage.init(named: "005"), UIImage.init(named: "006"), UIImage.init(named: "007"), UIImage.init(named: "008"), UIImage.init(named: "009"), UIImage.init(named: "010")]
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scrollPage), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer, forMode: .common)
        
        let timelay = CALayer()
        timelay.frame = CGRect(x: screenWid/2-20, y: 100, width: 40, height: 40)

        timelay.backgroundColor = UIColor.init(red: 0.5, green: 0.2, blue: 0.5, alpha: 0.5).cgColor
        timelay.masksToBounds = true
        timelay.cornerRadius = 20
        view.layer.addSublayer(timelay)
        
        handerView = UIView.init(frame: CGRect(x: screenWid/2, y: 110, width: 2, height: 20))
        handerView.backgroundColor = .red
        handerView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        view.addSubview(handerView)
        
        link = CADisplayLink(target: self, selector: #selector(running))
        link.add(to: RunLoop.main, forMode: .default)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 10, y: 150, width: screenWid-20, height: 200))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        
        stopImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        stopImageView.backgroundColor = .red
        stopImageView.snp.makeConstraints { (make) in
//            make.edges.equalTo(scrollView)
        }
        stopImageView.isHidden = true
        scrollView.addSubview(stopImageView)
        
        tipLabel = UILabel.init(frame: CGRect(x: 0, y: scrollView.frame.maxY, width: screenWid, height: 30))
        tipLabel.textAlignment = .center
        tipLabel.textColor = .black
        tipLabel.font.withSize(12)
        view.addSubview(tipLabel)
        
        slibar = UISlider.init(frame: CGRect(x: 10, y: scrollView.frame.maxY+10, width: screenWid-20, height: 200))
        slibar.minimumValue = 0
        slibar.maximumValue = Float(imagesArray.count-1)
        slibar.addTarget(self, action: #selector(clickSlidebar(_:)), for: .valueChanged)
        view.addSubview(slibar)
        
        
        self.loadData()
    }
    
    @objc func running() -> Void {
        let tZone = TimeZone.current
        var calendar = Calendar.current
        let currentDate = Date()
        calendar.timeZone = tZone
              
        let currentTime = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: currentDate)
              
        
        let hourAngle = CGFloat ( Double(currentTime.second!) * (Double.pi * 2.0 / 60) )
        handerView.transform = CGAffineTransform(rotationAngle: hourAngle)
    }
    
    func loadData() -> Void {
        for index in 0...imagesArray.count-1 {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(index)*(screenWid-20), y: 0, width: screenWid-20, height: 200))
            imageView.image = imagesArray[index]
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImageV))
            imageView.tag = 1000 + index
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: imagesArray.count*(Int(screenWid)-20), height: 200)
    }
    
    @objc func scrollPage() -> Void {
        if page<imagesArray.count {
            scrollView.setContentOffset(CGPoint(x: (Int(screenWid)-20)*page, y: 0), animated: true)
            page+=1
        } else {
            
        }
        
    }
    
    @objc func tapImageV() -> Void {
        if bScroll {
            link.invalidate()
            stopImageView.isHidden = false
            timer.fireDate = NSDate.distantFuture
            bScroll = false
        } else {
            link.accessibilityActivate()
            stopImageView.isHidden = true
            timer.fireDate = NSDate.distantPast
            bScroll = true
        }
    }
    
    @objc func clickSlidebar(_ sender: UISlider) -> Void {
        let sli = sender
        scrollView.setContentOffset(CGPoint(x: NSInteger(sli.value)*(Int(screenWid)-20), y: 0), animated: false)
        NSLog(String.init(format: "#########%.0f", sli.value))
        tipLabel.text = String.init(format: "第%.0f天", sli.value)
    }
}
