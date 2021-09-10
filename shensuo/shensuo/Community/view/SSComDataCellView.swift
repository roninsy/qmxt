//
//  comDataCellView.swift
//  shensuo
//
//  Created by swin on 2021/3/22.
//

import Foundation


//社区cell
class SSComDataCellView: UICollectionViewCell {
    
    var isSelf = false
    var model:MLRJModel? = nil{
        didSet{
            if model != nil{
                imageView.kf.setImage(with: URL.init(string: (model?.image) ?? ""), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
                titleLabel.text = model?.title ?? ""
                tips.likeLabel.text = model?.likeTimes ?? ""
                tips.seeLabel.text = model?.viewTimes ?? ""
                bots.nameLabel.text = model?.nickName ?? ""
                bots.headIcon.kf.setImage(with: URL.init(string: (model?.headImage) ?? ""))
                bots.giftLabel.text = model?.giftTimes ?? ""
                playImageView.isHidden = model?.type == 1 ? false : true
            }
        }
    }
    
    var dtModel:SSDongTaiModel? = nil {
        didSet{
            if dtModel != nil {
                imageView.kf.setImage(with: URL.init(string: (dtModel?.headerImageUrl) ?? ""), placeholder: UIImage.init(named: "imagePlace"), options: nil, completionHandler: nil)
                titleLabel.text = dtModel?.title ?? ""
                tips.likeLabel.text = String(dtModel?.likeTimes ?? 0) //dtModel?.likeTimes
                tips.seeLabel.text = dtModel?.postTimes ?? ""
                bots.nameLabel.text = dtModel?.userName ?? ""
                bots.headIcon.kf.setImage(with: URL.init(string: (dtModel?.userHeadImage) ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                bots.giftLabel.text = dtModel?.giftUserTimes ?? ""
                playImageView.isHidden = dtModel?.type == "1" ? false : true
            }
        }
    }
    
    var fouceModel:SSCommitModel? = nil {
        didSet {
            if fouceModel != nil {
                imageView.kf.setImage(with: URL.init(string: (fouceModel?.headerImage) ?? ""), placeholder: UIImage.init(named: "imagePlace"))
                titleLabel.text = fouceModel?.title ?? ""
                tips.likeLabel.text = fouceModel?.likeTimes
                tips.seeLabel.text = fouceModel?.viewTimes ?? ""
                bots.nameLabel.text = fouceModel?.nickName ?? ""
                bots.headIcon.kf.setImage(with: URL.init(string: (fouceModel?.headerImage) ?? ""),placeholder: UIImage.init(named: "user_normal_icon"))
                bots.giftLabel.text = fouceModel?.giftTimes ?? ""
                playImageView.isHidden = fouceModel?.noteType == "1" ? false : true
            }
        }
    }
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var desLabel = UILabel()
    var nickName = UILabel()
    var playImageView = UIImageView.initWithName(imgName: "anniu-bofnag")
    
    var tips = tipView.init()
    var bots = botView.init()
    var isShowBottomAlert = false
    
    var mainView = UIView()
    
    var reloadBlock : voidBlock? = nil
    func setDataModel() -> Void {
        imageView.image = UIImage.init(named: "user_normal_icon")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(addLongPressGesture))
        // 长按手势最小触发时间
        longTap.minimumPressDuration = 1.0
        // 长按手势需要的同时敲击触碰数（手指数）
        longTap.numberOfTouchesRequired = 1
        // 长按有效移动范围（从点击开始，长按移动的允许范围 单位 px
        longTap.allowableMovement = 15
        self.addGestureRecognizer(longTap)
        self.buildUI()
    }
    
    @objc func addLongPressGesture(){
        self.showBottomAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        self.backgroundColor = .clear
        self.contentView.layer.shadowColor = HQLineColor(rgb: 185).cgColor
        self.contentView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.contentView.layer.shadowRadius = 6
        self.contentView.layer.shadowOpacity = 1
        
        self.contentView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 6
        mainView.layer.masksToBounds = true
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.backgroundColor = .gray

        imageView.image = UIImage.init(named: "imagePlace")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-80)
        HQRoude(view: imageView, cs: [.topLeft,.topRight], cornerRadius: 6)
        mainView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.init(hex: "#333333")
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(50)
        }
        
        
        mainView.addSubview(bots)
        bots.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tips.backgroundColor = .gray
        
        tips.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        HQRoude(view: tips, cs: [.topLeft,.bottomRight], cornerRadius: 6)
        
        imageView.addSubview(tips)
        tips.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(playImageView)
        playImageView.snp.makeConstraints { make in
            
            make.width.height.equalTo(36)
            make.center.equalTo(imageView)
        }

    }
    
    
    /// 屏幕底部弹出的Alert
    func showBottomAlert(){
        if self.isShowBottomAlert || self.isSelf == false {
            return
        }
        self.isShowBottomAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowBottomAlert = false
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.init(hex:"#FD8024"), forKey: "titleTextColor")

        let editAction = UIAlertAction(title:"编辑", style: .default)
        {[weak self]
            action in
            let vc = SSReleaseNewsViewController()
            let model = self?.dtModel
            var notesModel = SSNotesDetaileModel()
            notesModel.address = model?.address
            notesModel.authorId = model?.authorId
            notesModel.content = model?.content
            notesModel.headerImageUrl = model?.headerImageUrl
            notesModel.imageUrls = model?.imageUrls
            notesModel.id = model?.id
            notesModel.videoUrl = model?.videoUrl
            notesModel.title = model?.title
            notesModel.type = model?.type?.toInt
            notesModel.userHeadImage = model?.userHeadImage
            notesModel.userName = model?.userName
            notesModel.musicUrl = model?.musicUrl
            vc.notesDetaile = notesModel
            vc.inType = 6
            DispatchQueue.main.async {
                HQPush(vc: vc, style: .default)
            }
        }
        
        let stateAction = UIAlertAction(title:self.dtModel?.personal == true ? "所有人可见" : "仅自己可见", style: .default)
        {[weak self]
            action in
            self?.changeNotesStates()
        }
        
        let del = UIAlertAction(title:"删除", style: .default)
        {
            action in
            self.cancleSureAlertAction(title: "您确定删除此动态？", content: "") {[weak self] ac in
                self?.delNotes()
                self?.reloadBlock?()
            }
        }
        alertController.addAction(cancel)
        alertController.addAction(del)
        alertController.addAction(editAction)
        alertController.addAction(stateAction)
        
        HQGetTopVC()!.present(alertController, animated:true, completion:nil)
        
    }
    
    func cancleSureAlertAction(title: String,content: String,sureHandle: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController.init(title: title, message: content, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "确定", style: .default, handler: sureHandle)
    
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        sureAction.setValue(btnColor, forKey: "_titleTextColor")
        cancelAction.setValue(color99, forKey: "_titleTextColor")
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        HQGetTopVC()?.present(alert, animated: true, completion: nil)
    }
    
    ///删除动态
    func delNotes() {
        CourseNetworkProvider.request(.notesDelete(noteId: self.dtModel?.id ?? "")) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.reloadBlock?()
                        }
                    }
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
    
    ///修改动态是否可见
    func changeNotesStates() {
        let isPrivate = self.dtModel?.personal == false ? true : false
        CourseNetworkProvider.request(.notesPermission(noteId: self.dtModel?.id ?? "", isPrivate: isPrivate)) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.dtModel?.personal = isPrivate
                        }
                        DispatchQueue.main.async {
                            HQGetTopVC()?.view.makeToast("操作成功")
                        }
                    }
                } catch {
                    
                }
            case let .failure(error):
                logger.error("error-----",error)
            }
        }
    }
}

class tipView: UIView {
    var seeIcon = UIImageView()
    var seeLabel = UILabel()
    var likeIcon = UIImageView()
    var likeLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        seeIcon.image = UIImage.init(named: "yueduliang")
        addSubview(seeIcon)
        seeIcon.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        seeLabel.textAlignment = .center
        seeLabel.textColor = .white
        seeLabel.font = UIFont.systemFont(ofSize: 8)
        addSubview(seeLabel)
        seeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(seeIcon.snp.right)
            make.top.equalTo(seeIcon)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
//        likeIcon.backgroundColor = .blue
        likeIcon.image = UIImage.init(named: "like_num_white")
        addSubview(likeIcon)
        likeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(seeLabel.snp.right)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        likeLabel.textAlignment = .center
        likeLabel.textColor = .white
        likeLabel.font = UIFont.systemFont(ofSize: 8)
        addSubview(likeLabel)
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likeIcon.snp.right)
            make.top.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
    }
}

class botView: UIView {
    var headIcon = UIImageView()
    var nameLabel = UILabel()
    var giftIcon = UIImageView()
    var giftLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headIcon.layer.masksToBounds = true
        headIcon.layer.cornerRadius = 10
        headIcon.backgroundColor = .red
        addSubview(headIcon)
        headIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.init(hex: "#B4B4B4")
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headIcon.snp.right).offset(5)
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        
        
        giftLabel.textAlignment = .left
        giftLabel.font = UIFont.systemFont(ofSize: 13)
        giftLabel.textColor = UIColor.init(hex: "#B4B4B4")
        addSubview(giftLabel)
        giftLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        giftIcon.image = UIImage.init(named: "liwu")
        addSubview(giftIcon)
        giftIcon.snp.makeConstraints { (make) in
            make.right.equalTo(giftLabel.snp.left).offset(-5)
            make.top.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
    }
}
