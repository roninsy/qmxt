//
//  SSDetailCommentView.swift
//  shensuo
//
//  Created by  yang on 2021/4/7.
//

import UIKit
//底部评论
class SSDetailCommentView: UIView {
    
    
    var isVideo: Bool? = nil{
        didSet{
            if isVideo == true {
                
                backBtn.setImage(UIImage.init(named: "icon-shequ "), for: .normal)
                backBtn.setTitleColor(UIColor.white, for: .normal)
                scBtn.setImage(UIImage.init(named: "icon-shoucang-shoucangji"), for: .normal)
                likeBtn.setImage(UIImage.init(named: "icon-dianzan-weidianji"), for: .normal)
                pinglunBtn.setImage(UIImage.init(named: "icon-pinglun"), for: .normal)

            }
        }
    }
    
    var backBtn : UIButton = {
        let back = UIButton.init()
        back.setImage(UIImage.init(named: "bottom_shequ"), for: .normal)
        back.setTitle("社区", for: .normal)
        back.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        back.titleLabel?.font = .systemFont(ofSize: 10)
        return back
    }()
    
    var likeBtn : UIButton = {
        let like = UIButton.init()
        like.setImage(UIImage.init(named: "like"), for: .selected)
        like.setImage(UIImage.init(named: "unlike"), for: .normal)
        like.setTitleColor(UIColor.init(hex: "#666666"), for: .normal)
        like.titleLabel?.font = .systemFont(ofSize: 10)
        return like
    }()
    
    var scBtn : UIButton = {
        let sc = UIButton.init()
        sc.setImage(UIImage.init(named: "shoucan"), for: .selected)
        sc.setImage(UIImage.init(named: "noshoucan"), for: .normal)
        sc.setTitleColor(UIColor.init(hex: "#666666"), for: .normal)
        sc.titleLabel?.font = .systemFont(ofSize: 10)
        return sc
    }()
    
    var pinglunBtn : UIButton = {
        let like = UIButton.init()
//        like.setImage(UIImage.init(named: "icon-pinglun_gray"), for: .selected)
        like.setImage(UIImage.init(named: "icon-pinglun_gray"), for: .normal)
        like.setTitleColor(UIColor.init(hex: "#666666"), for: .normal)
        like.titleLabel?.font = .systemFont(ofSize: 10)
        return like
    }()
    
    var giftBtn : UIButton = {
        let gift = UIButton.init()
        gift.setTitle("", for: .normal)
        gift.setImage(UIImage.init(named: "community_gift"), for: .normal)
        return gift
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.init(hex: "#070707")
//        self.alpha = 0.25
        
//        commentField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(backBtn)
        
        backBtn.imageEdgeInsets =  UIEdgeInsets(top:-(20),
                                                left:0,
                                                bottom: 0,
                                                right:-23)
        backBtn.titleEdgeInsets = UIEdgeInsets(top:0,
                                               left:-23,
                                               bottom:-20,
                                               right:0)
        
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(40)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        addSubview(giftBtn)
        giftBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
       
        addSubview(scBtn)
        scBtn.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        scBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }
        
        addSubview(likeBtn)
        likeBtn.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        likeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(scBtn.snp.leading)
            make.width.equalTo(90)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            
        }
        
        addSubview(pinglunBtn)
        pinglunBtn.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        pinglunBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(scBtn.snp.trailing)
            make.width.equalTo(90)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }

}


extension SSDetailCommentView : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
