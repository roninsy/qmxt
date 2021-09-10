//
//  SSNoDataView.swift
//  shensuo
//
//  Created by  yang on 2021/5/7.
//

import UIKit

class SSNoDataView: UIView {
    let tipsImageView = UIImageView.initWithName(imgName:"")
    let tipsLabel = UILabel.initSomeThing(title: "", isBold: true, fontSize: 16, textAlignment: .center, titleColor: .init(hex: "#333333"))
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func showNoDataView(imageName:String, notes:String) -> SSNoDataView {
        self.frame = CGRect(x: 0, y: 0, width: screenWid, height: screenWid/412*267)
        let notesView = UIView.init(frame: CGRect(x: 0, y: 20, width: screenWid, height: screenWid/412*267))
        
        addSubview(notesView)
        notesView.backgroundColor = .white
        notesView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        notesView.addSubview(tipsImageView)
        tipsImageView.image = UIImage.init(named: imageName)
        tipsImageView.snp.makeConstraints { (make) in
            make.top.equalTo(24)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo((screenWid-100)/310*176)
        }
        
        notesView.addSubview(tipsLabel)
        tipsLabel.textAlignment = .center
        tipsLabel.text = notes
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipsImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(22)
        }
        
        return self
    }
    
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

}
