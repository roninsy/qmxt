//
//  SSNumSlider.swift
//  shensuo
//
//  Created by  yang on 2021/5/26.
//

import UIKit

class SSNumSlider: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var parentView:UIView = UIView.init()
    var videoModels: [SSVideoModel]? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage.init(named: "bt_sliber")
        
        self.tintColor = .init(hex: "#FD8024")
        self.setThumbImage(image, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setValue(_ value: Float, animated: Bool) {
        super.setValue(value, animated: animated)
        let image = UIImage.init(named: "bt_sliber")
//        let tip = numTipView.init()
        self.tintColor = .init(hex: "#FD8024")
        self.setThumbImage(image, for: .normal)
        self.setMinimumTrackImage(image, for: .normal)
        
        if (!animated) {
            
            let numerator = value - self.minimumValue;
            let denominator = self.maximumValue - self.minimumValue;
            let x = numerator / denominator;
            if (self.videoModels?.endIndex ?? 0) > Int(value) {
                let model = self.videoModels?[Int(value)]
                let dateString:String = model?.createdTime ?? ""
                numTipView.getSharedInstance().showTips(date: dateString, pView: self, px: CGFloat(x)*(screenWid-30) - 56/2 + 15, day: Int(value)+1, pareView: self.parentView)
            }
//            numTipView.getSharedInstance().showTips(date: "", pView: self, px: CGFloat(x)*(screenWid-30) - 56/2 + 15, day:Int(value), pareView:parentView)

        }
    }

}


class numTipView: UIView {
    private static var _sharedInstance: numTipView?
    
    var daylabel = UILabel.initSomeThing(title: "第一天", fontSize: 13, titleColor: .init(hex: "#FFFFFF"))
    var datelabel = UILabel.initSomeThing(title: "2020-10-10", fontSize: 13, titleColor: .init(hex: "#333333"))
    
    class func getSharedInstance() -> numTipView {
        guard let instance = _sharedInstance else {
            _sharedInstance = numTipView()
            return _sharedInstance!
        }
        return instance
    }
    class func destroy() {
        _sharedInstance = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizesSubviews = true;
        self.frame = CGRect(x: 0, y: 0, width: 144, height: 33) //CGRectMake(0, 0, 144, 33);
        self.layer.contents = UIImage.init(named: "bt_tipbg")?.cgImage
        
        
        daylabel.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        daylabel.textAlignment = .center
        self.addSubview(daylabel)
        datelabel.frame = CGRect(x: 50, y: 0, width: 94, height: 25)
        datelabel.textAlignment = .center
        self.addSubview(datelabel)
    }
    
    func showTips(date:String, pView:UIView, px:CGFloat, day:Int, pareView:UIView) -> Void {
        
        
        let targetframe = pView.convert(pView.bounds, to: pareView)
        self.frame = CGRect(x: targetframe.origin.x+px-48, y: targetframe.origin.y-self.frame.size.height+12, width: self.frame.size.width, height: self.frame.size.height)
        pareView.addSubview(self)
//        UIApplication.shared.keyWindow?.addSubview(self)
        daylabel.text = String(format: "第%d天", day) //"第"+day+"天"
        datelabel.text = date
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
