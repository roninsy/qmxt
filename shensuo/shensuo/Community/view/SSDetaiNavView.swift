//
//  SSDetaiNavView.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit

//导航栏
class SSDetaiNavView: UIView {
    
    var clickBackAction:Selector!
    
    
    var backBlock: (()->())?
    var clickFocusBtnHandler:((UIButton)->())?
    
    var backBtn:UIButton = {
        let back = UIButton.init()
        back.setImage(UIImage.init(named: "back_black"), for: .normal)
        
        return back
    }()
    var headImage:UIImageView = {
        let head = UIImageView.init()
        head.layer.masksToBounds = true
        head.layer.cornerRadius = 15
        
//        head.image = UIImage.init(named: "qq")
        head.isUserInteractionEnabled = true
        return head
    }()
    var titleLabel:UILabel = {
        let title = UILabel.init()
        title.font = UIFont.systemFont(ofSize: 17)
        title.textAlignment = .left
//        title.text = "广东身所科技有限公司"
        title.textColor = UIColor.init(hex: "#333333")
        return title
    }()
    var focusBtn:UIButton = {
        let focus = UIButton.init()
        focus.layer.borderWidth = 1
        focus.layer.borderColor = UIColor.init(hex: "#FD8024").cgColor
        focus.layer.masksToBounds = true
        focus.layer.cornerRadius = 16
        focus.setTitle("关注", for: .normal)
        focus.setTitleColor(UIColor.init(hex: "#FD8024"), for: .normal)
        return focus
    }()
    var shareBtn:UIButton = {
        let share = UIButton.init()
        share.setImage(UIImage.init(named: "share"), for: .normal)
        return share
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clickBackAction = #selector(clickBack)
        self.backgroundColor = .white
        
        //自己进入
//        focusBtn.setTitle("编辑", for: .normal)
        
        focusBtn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            self.clickFocusBtnHandler!(button)
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(backBtn)
        backBtn.addTarget(self, action: clickBackAction, for: .touchUpInside)
        backBtn.snp.makeConstraints { (make) in
   
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.width.height.equalTo(24)
        }
        
        addSubview(headImage)
        headImage.snp.makeConstraints { (make) in

            make.centerY.equalToSuperview()
            make.left.equalTo(backBtn.snp.right).offset(5)
            make.width.height.equalTo(30)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(headImage.snp.right).offset(5)
            make.width.equalTo(200)
//            make.bottom.equalToSuperview()
        }
        
        addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        addSubview(focusBtn)
        focusBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(shareBtn.snp.left).offset(-10)
            make.width.equalTo(68)
            make.height.equalTo(32)
        }
    }
    
    @objc func clickBack() -> Void {
        self.backBlock!()
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
