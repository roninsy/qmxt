//
//  SSOpenMapView.swift
//  shensuo
//
//  Created by  yang on 2021/4/13.
//

import UIKit

class SSOpenMapView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var mapImageView : UIImageView = {
        let map = UIImageView.init()
        map.image = UIImage.init(named: "dingwei")
        return map
    }()
    
    var tipLabel : UILabel = {
        let tip = UILabel.init()
        return tip
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func layoutSubviews() {
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
