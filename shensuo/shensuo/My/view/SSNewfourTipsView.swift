//
//  SSMyNewHeaderReusableView.swift
//  shensuo
//
//  Created by  yang on 2021/6/28.
//

import UIKit

//MARK: 点赞关注粉丝美币
class SSNewfourTipsView: UIView {
    
    var clickFenContentHander: (()->())?
    var clickFocusContentHander:(()->())?
    var clickFocusBtnHander:((UIButton)->(Void))?

    //点赞
    var tipContent: newMyLabelContent = {
        let con = newMyLabelContent.init()
        con.numLabel.text = "0"
        con.tipLabel.text = "点赞"
        return con
    }()

    //关注
    var foceContent : newMyLabelContent = {
        let foce = newMyLabelContent.init()
        foce.numLabel.text = "0"
        foce.tipLabel.text = "关注"
        return foce
    }()

    //粉丝
    var fenContent : newMyLabelContent = {
        let fen = newMyLabelContent.init()
        fen.numLabel.text = "0"
        fen.tipLabel.text = "粉丝"

        return fen
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()

        let tapGest = UITapGestureRecognizer.init(target:self, action: #selector(tapFenView))
        tapGest.numberOfTapsRequired = 1
        tapGest.numberOfTouchesRequired = 1
        fenContent.addGestureRecognizer(tapGest)

        let focusGest = UITapGestureRecognizer.init(target: self, action: #selector(tapFocusView))
        focusGest.numberOfTapsRequired = 1
        focusGest.numberOfTouchesRequired = 1
        foceContent.addGestureRecognizer(focusGest)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapFenView() {
        if clickFenContentHander != nil {
            clickFenContentHander!()
        }
    }

    @objc func tapFocusView(){
        if clickFocusContentHander != nil {
            clickFocusContentHander!()
        }
    }

    func initLayout() {
        addSubview(tipContent)

        tipContent.snp.makeConstraints { (make) in
            make.top.left.height.equalToSuperview()
            make.width.equalTo(screenWid/3)

        }

        addSubview(foceContent)
        foceContent.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
            make.left.equalTo(tipContent.snp.right)
            make.width.equalTo(screenWid/3)
        }

        addSubview(fenContent)
        fenContent.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
            make.left.equalTo(foceContent.snp.right)
            make.width.equalTo(screenWid/3)

        }
    }
}

class newMyLabelContent: UIView {

    var numLabel : UILabel = {
        let num = UILabel.init()
        num.textAlignment = .center
        num.textColor = .white
        num.font = UIFont.boldSystemFont(ofSize: 16)
        return num
    }()

    var tipLabel : UILabel = {
        let tip = UILabel.init()
        tip.textAlignment = .center
        tip.textColor = .white
        tip.font = UIFont.systemFont(ofSize: 12)
        return tip
    }()

    var lineImage : UIImageView = {
        let line = UIImageView.init()
        line.backgroundColor = .white
        return line
    }()



    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func initLayout() {
        addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.width.equalToSuperview()
            make.height.equalTo(24)
        }

        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(numLabel.snp.bottom)
            make.height.equalTo(24)
        }

        addSubview(lineImage)
        lineImage.isHidden = true
        lineImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(8)
        }
    }
}

