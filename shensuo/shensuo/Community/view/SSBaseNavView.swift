//
//  SSBaseNavView.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit

class SSBaseNavView: UIView {
    
    var clickBackBtnBlock : (()->())?
    var clickSearchBtnBlock : (()->())?
    var clickAddBtnBlock : (()->())?
    
    var backBtn : UIButton = {
        let back = UIButton.init()
        back.setImage(UIImage.init(named: "back_black"), for: .normal)
        return back
    }()
    
    var titleLabel : UILabel = {
        let title = UILabel.init()
        title.textColor = .black
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 18)
        return title
    }()
    
    
    var searchBtn : UIButton = {
        let search = UIButton.init()
        search.setImage(UIImage.init(named: "sousuo"), for: .normal)
        search.addTarget(self, action: #selector(clickSearch), for: .touchUpInside)
        return search
    }()
    
    var addBtn : UIButton = {
        let add = UIButton.init()
        add.setImage(UIImage.init(named: "addfd"), for: .normal)
        add.addTarget(self, action: #selector(clickAdd), for: .touchUpInside)
        return add
    }()
    
    var shareBtn : UIButton = {
        let share = UIButton.init()
        share.setImage(UIImage.init(named: "share"), for: .normal)
        share.addTarget(self, action: #selector(clickShare), for: .touchUpInside)
        return share
    }()
    
    var optionBtn : UIButton = {
        let option = UIButton.init()
        option.setTitleColor(UIColor.init(hex: "#FFFFFF"), for: .normal)
        option.titleLabel?.font = .systemFont(ofSize: 14)
        return option
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
       
    }
    
//    @objc func clickBack() -> Void {
//        self.clickBackBtnBlock!()
//    }
    
    @objc func clickSearch()->Void {
        self.clickSearchBtnBlock!()
    }
    
    @objc func clickAdd()->Void {
        self.clickAddBtnBlock!()
    }
    
    @objc func clickShare()->Void {
//        self.clickAddBtnBlock!()
    }
    
    func backBtnWithTitle(title:String) -> Void {
        addSubview(backBtn)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(backBtn.snp.right)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(25)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func onlyTitleNav(title:String) -> Void {
        
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    func titleWithOpentionBtn(title:String) -> Void {
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
            make.height.equalTo(25)
        }
        
        addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(24)
        }
        
        addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(addBtn.snp.left).offset(-15)
            make.width.height.equalTo(24)
        }
        
        
    }
    
    func backWithTitleOptionBtn(title:String, option:String) -> Void {
        addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(screenWid-160)
            make.height.equalTo(25)
        }
        
        addSubview(optionBtn)
        optionBtn.setTitle(option, for: .normal)
        optionBtn.setTitleColor(.init(hex: "#333333"), for: .normal)
        optionBtn.titleLabel?.font = .systemFont(ofSize: 14)
        optionBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
    }
    
    func backAndShareBtn() -> Void {
        self.backgroundColor = .clear
        addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(10)
        }
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
