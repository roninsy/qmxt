//
//  SSExchangeCell.swift
//  shensuo
//
//  Created by  yang on 2021/4/16.
//

import UIKit

class SSExchangeCell: UITableViewCell {
    
    var openBlock : intBlock? = nil
    var model : SSExchangeModel? = nil {
        didSet{
            if model != nil {
                introduce.numberOfLines = 2
                introduce.text = model?.name
                
                if (model?.name?.length ?? 0) > 12 {
                    introduce.snp.updateConstraints { (make) in
                        make.top.equalTo(20)
                        make.height.equalTo(40)
                    }
                }else{
                    introduce.snp.updateConstraints { (make) in
                        make.top.equalTo(33)
                        make.height.equalTo(20)
                    }
                }
                
                let sTime = (model?.startDate ?? "").replacingOccurrences(of: "00:00:00", with: "")
                let eTime = (model?.endDate ?? "").replacingOccurrences(of: "23:59:59", with: "")
                time.text = "\(sTime)至\(eTime)"
                if model?.type == 2 {
                    price.text = (model?.discount)!+"折"
                    
                } else if model?.type == 1 {
                    price.text = "¥"+(model?.worth)!
                    
                } else {
                    price.text = "免费券"
                }
                
                if model?.useCondition == 2 {
                    tips.text = "会员费可用"
                } else if model?.useCondition == 1 {
                    tips.text = (model?.payMore)!+"内可用"
                } else {
                    tips.text = "无门槛"
                }
                if model?.isOpen == true {
                    downBtn.setImage(UIImage.init(named: "my_up"), for: .normal)
                    useView.isHidden = false
                } else {
                    downBtn.setImage(UIImage.init(named: "my_down"), for: .normal)
                    useView.isHidden = true
                }
                let viewHei = 72 + (model?.remarkHei ?? 18)
                useView.snp.updateConstraints { make in
                    make.height.equalTo(viewHei)
                }
                useNotes.snp.updateConstraints { make in
                    make.height.equalTo(model?.remarkHei ?? 18)
                }
                useTime.text = "使用时间：\(model?.usedTime ?? "")"
                useNotes.text = "备注：\(model?.usedRemark ?? "")"
                self.contentView.bringSubviewToFront(bgImageView)
                self.contentView.bringSubviewToFront(useDalisBtnView)
                self.contentView.bringSubviewToFront(self.userBtn)
            }
        }
    }
    
    
    var cellHeight:CGFloat = (screenWid-20)/394*107+13
    var isOpen : Bool = false
    
    
    var bgImageView:UIImageView = {
        let bgView = UIImageView.init()
        return bgView
    }()
    
    var leftBg:UIImageView = {
        let leftView = UIImageView.init()
        return leftView
    }()
    
    var userType:UIImageView = {
        let type = UIImageView.init()
        return type
    }()
    
    var downBtn:UIButton = {
        let dbtn = UIButton.init()
        dbtn.setImage(UIImage.init(named: "my_down"), for: .normal)
        return dbtn
    }()
    
    let userBtn = UIButton.initBackgroudImage(imgname: "bt_dayselect")
    let price = UILabel.initSomeThing(title: "1元", isBold: true, fontSize: 16, textAlignment: .center, titleColor: .init(hex: "#EF0B19"))
    let tips = UILabel.initSomeThing(title: "无门槛", isBold: false, fontSize: 14, textAlignment: .center, titleColor: .init(hex: "#333333"))
    let introduce = UILabel.initSomeThing(title: "1元抵扣券", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let time = UILabel.initSomeThing(title: "2020.10.01至2020.10.08", isBold: false, fontSize: 12, textAlignment: .left, titleColor: .init(hex: "#999999"))
    
    
    let useView = UIView.init()
    let useTips = UILabel.initSomeThing(title: "使用说明:", isBold: true, fontSize: 14, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let useTime = UILabel.initSomeThing(title: "使用时间", isBold: false, fontSize: 12, textAlignment: .left, titleColor: .init(hex: "#333333"))
    let useNotes = UILabel.initSomeThing(title: "备注", isBold: false, fontSize: 12, textAlignment: .left, titleColor: .init(hex: "#333333"))
    
    let useDalisBtnView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var type:cellType? = nil{
        didSet {
            self.price.textColor = type == .unUsed ? .init(hex: "#EF0B19") : .init(hex: "#ADABAD")
            self.tips.textColor = type == .unUsed ? .init(hex: "#333333") : .init(hex: "#ADABAD")
            self.useDalisBtnView.isHidden = type != .didUsed
//            self.bgImageView.image = type != .didUsed ? UIImage.init(named: "") : UIImage.init(named: "")
            let hei = type != .didUsed ? 28 : 33
            introduce.snp.updateConstraints { make in
                make.top.equalTo(hei)
            }
            switch type {
            case .unUsed:
                bgImageView.image = UIImage.init(named: "my_exchange")
                leftBg.image = UIImage.init(named: "my_exchangeLeft")
                userType.isHidden = true
                downBtn.isHidden = true
                break
            case .didUsed:
                bgImageView.image = UIImage.init(named: "my_unexchange")
                leftBg.image = UIImage.init(named: "my_unexchangeLeft")
                userType.image = UIImage.init(named: "my_used")
                userBtn.isHidden = true
                break
            case .outTime:
                bgImageView.image = UIImage.init(named: "my_unexchange")
                leftBg.image = UIImage.init(named: "my_unexchangeLeft")
                userType.image = UIImage.init(named: "my_outtime")
                userBtn.isHidden = true
                downBtn.isHidden = true
                break
            default:
                break
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildSubviews()
        
        downBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.isOpen = !self.isOpen
        }
    }
    
    func buildSubviews() {
        self.contentView.addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(107)
        }
        
        bgImageView.addSubview(leftBg)
        leftBg.snp.makeConstraints { (make) in
            make.top.left.height.equalToSuperview()
            make.width.equalTo(114)
            make.height.equalTo(107)
        }
        
        leftBg.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(13)
            make.height.equalTo(50)
        }
        
        leftBg.addSubview(tips)
        tips.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(price.snp.bottom)
            make.height.equalTo(20)
        }
        
        bgImageView.addSubview(introduce)
        introduce.snp.makeConstraints { (make) in
            make.left.equalTo(leftBg.snp.right).offset(12)
            make.top.equalTo(33)
            make.height.equalTo(20)
            make.right.equalTo(-90)
        }
        
        bgImageView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.left.equalTo(introduce)
            make.top.equalTo(introduce.snp.bottom).offset(8)
            make.height.equalTo(17)
        }
        
        bgImageView.addSubview(userType)
        userType.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.right.equalToSuperview().offset(-11)
            make.width.height.equalTo(61)
        }
        
        self.contentView.addSubview(useDalisBtnView)
        useDalisBtnView.snp.makeConstraints { make in
            make.bottom.equalTo(bgImageView)
            make.left.equalTo(124)
            make.height.equalTo(25)
            make.right.equalTo(bgImageView)
        }
        
        let useTip = UILabel.initSomeThing(title: "使用说明", titleColor: .init(hex: "#AAA8AA"), font: .systemFont(ofSize: 11), ali: .left)
        useDalisBtnView.addSubview(useTip)
        useTip.snp.makeConstraints { make in
            make.left.equalTo(13)
            make.width.equalTo(50)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        useDalisBtnView.addSubview(downBtn)
        downBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(16)
        }
        
        let lineImg = UIImageView.initWithName(imgName: "exchange_used_line")
        useDalisBtnView.addSubview(lineImg)
        lineImg.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(0)
        }
        
        let detalisBtn = UIButton()
        useDalisBtnView.addSubview(detalisBtn)
        detalisBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        detalisBtn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] btn in
            self?.openBlock?(self?.tag ?? 0)
        }
        
        
        useView.backgroundColor = .init(hex: "#F7F7F7")
        useView.layer.cornerRadius = 6
        useView.layer.masksToBounds = true
        self.contentView.addSubview(useView)
        useView.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom).offset(-10)
            make.left.right.equalTo(bgImageView)
            make.height.equalTo(90)
        }

        useView.addSubview(useTips)
        useTips.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.left.equalTo(10)
            make.height.equalTo(20)
        }
        
        useView.addSubview(useTime)
        useTime.snp.makeConstraints { (make) in
            make.top.equalTo(useTips.snp.bottom).offset(8)
            make.left.equalTo(useTips)
            make.height.equalTo(18)
        }
        
        useNotes.numberOfLines = 0
        useView.addSubview(useNotes)
        useNotes.snp.makeConstraints { (make) in
            make.top.equalTo(useTime.snp.bottom)
            make.left.equalTo(useTime)
            make.height.equalTo(18)
            make.right.equalTo(-10)
        }
        
        self.contentView.addSubview(userBtn)
        userBtn.setTitle("去使用", for: .normal)
        userBtn.setTitleColor(.init(hex: "#FD8024"), for: .normal)
        userBtn.titleLabel?.font = .systemFont(ofSize: 13)
        userBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgImageView).offset(isFullScreen ? 0 : -10)
            make.right.equalTo(bgImageView).offset(-21)
            make.width.equalTo(68)
            make.height.equalTo(32)
        }
        userBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                HQPushToRootIndex(index: 0)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
