//
//  SSSendCommentViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/15.
//

import UIKit
import MBProgressHUD

class SSSendCommentViewController: HQBaseViewController {

    ///1.课程 2.小节 3.动态 4.美丽日志，5美丽相册，6方案,7方案小节
    var type:Int = 0
    ///是否回复
    var isReCommnet = false
    var sourceId:String = ""
    var commentId:String = ""
    var atUserId:String = ""
    
    var navView:sendView = {
        let nav = sendView.init()
        
        return nav
    }()
    
    var comTextView:UITextView = {
        let com = UITextView.init()
        var placeHolderLabel = UILabel.init()
        placeHolderLabel.text = "请输入内容"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        com.addSubview(placeHolderLabel)
        
        com.font = .systemFont(ofSize: 13)
        placeHolderLabel.font = .systemFont(ofSize: 13)
        com.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
        return com
    }()
    
    
    
    var imageList:HQImageListView = {
        let images = HQImageListView.init()
    
        return images
    }()
    
    var securityToken:String?
    var accessKeySecret:String?
    var accessKeyId:String?
    var comTextString:String?
    
    
    var imageArray = Array<String>()
    var workArray = Array<DispatchWorkItem>()
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        layoutSubViews()
        getSecurtKey()
        
        imageList.hasAdd = true
        imageList.hasDel = true
        imageList.vc = self
        imageList.makeSubViews()
        
        navView.closeBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        
        navView.sendBtn.reactive.controlEvents(.touchUpInside).observeValues { [self] (btn) in
            self.view.endEditing(false)
            comTextString = comTextView.text
            if comTextString == nil || comTextString!.count == 0{
                self.view.makeToast("请输入内容")
                return
            }
            if comTextString!.count > 300{
                self.view.makeToast("文本内容最大为300字")
                return
            }
            
            DispatchQueue.main.async(execute: {
                if uploadImages() {
                    
                }
            })
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func getSecurtKey() -> Void {
        CommunityNetworkProvider.request(.getSecretKey) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            let dic = model?.data
                            if dic == nil {
                                return
                            }
                            let data = dic?["credentials"] as![String:Any]
                            self.accessKeyId = data["accessKeyId"] as? String
                            self.accessKeySecret = data["accessKeySecret"] as? String
                            self.securityToken = data["securityToken"] as? String
                            
                        }else{
                            
                        }
                        
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    func send(comText:String, images:Array<Any>) -> Void {
        
        if isReCommnet{
            CommunityNetworkProvider.request(.addCommentReply(atUserId :atUserId, content: comTextString!,commentId:commentId, createdTime: "", imageArray: images, sourceId: self.sourceId, type: self.type, userId: UserInfo.getSharedInstance().userId!)) { result in
                switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                self.view.makeToast("发布成功")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            }
            return
        }
        
        CommunityNetworkProvider.request(.addComment(content: comTextString!, createdTime: "", imageArray: images, sourceId: self.sourceId, type: self.type, userId: UserInfo.getSharedInstance().userId!)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultModel.self)
                        if model?.code == 0 {
                            self.view.makeToast("发布成功")
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            
                        }
                        
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    func getCurrentDateString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let time = dateformatter.string(from: Date())
        return time
    }
    
    func uploadImages() -> Bool {

        if (imageList.imgArr?.count ?? 0) < 1{
            send(comText: "", images: Array<Any>())
            return true
        }
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let imgUpload = app.api
        imgUpload.accessKeyId = self.accessKeyId ?? ""
        imgUpload.securityToken = self.securityToken ?? ""
        imgUpload.secretKeyId = self.accessKeySecret ?? ""
        
        self.imageArray.removeAll()
        let myQueue = DispatchQueue(label: "com.myQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        for index in 0...imageList.imgArr!.count-1 {
            myQueue.async { [self] in
                imgUpload.uploadImg((imageList.imgArr?[index])! as UIImage) { (image) in
                    self.imageArray.append(image)
                    if self.imageArray.count == imageList.imgArr?.count {
                        self.imageArray = self.imageArray.sorted()
                        DispatchQueue.main.async { [self] in
                            send(comText: "", images: self.imageArray)
                            
                        }
                    }
                } faildBlock: {
                    
                }
            }
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    func layoutSubViews() -> Void {
        self.view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
        
        self.view.addSubview(comTextView)
        comTextView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.view.addSubview(imageList)
        imageList.snp.makeConstraints { (make) in
            make.top.equalTo(comTextView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class sendView: UIView {
    
    var closeBtn:UIButton = {
        let close = UIButton.init()
        close.setImage(UIImage.init(named: "close"), for: .normal)
        return close
    }()
    
    var sendBtn:UIButton = {
        let send = UIButton.init()
        send.backgroundColor = UIColor.init(hex: "#FD8024")
        send.setTitle("发布", for: .normal)
        send.titleLabel?.textAlignment = .center
        send.titleLabel?.textColor = .white
        return send
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
            make.left.equalTo(10)
        }
        
        addSubview(sendBtn)
        sendBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
