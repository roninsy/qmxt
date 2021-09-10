//
//  ComplainView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/9.
// 投诉页面

import UIKit

class ComplainView: UIView,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    //
    ///    如果是评论或回复类型需填入 评论回复对应的类型 1课程，2课程小节，3动态，4美丽日志，5美丽相册，6方案,7方案小节
    var commentType = -1
    ///内容类型,1课程，2课程小节，3方案，4方案小节，5动态，6美丽日志，7美丽相册，8评论，9回复 10主页
    var contentType = 1
    /// 投诉的内容id
    var sourceId = "-1"
    
    var placeHolderLabel = UILabel.initSomeThing(title: "请输入", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 15), ali: .left)
    
    let whiteBG = UIView()
    
    let cancelBtn = UIButton.initTitle(title: "取消", fontSize: 20, titleColor: .init(hex: "#666666"))
    let enterBtn = UIButton.initTitle(title: "确认", fontSize: 20, titleColor: .init(hex: "#FD8024"))
    let contentView = UITextView()
    let contentNumLab = UILabel.initSomeThing(title: "0/300", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 13), ali: .right)
    
    let titleLab = UILabel.initSomeThing(title: "投诉", titleColor: .init(hex: "#333333"), font: .MediumFont(size: 20), ali: .center)
    
    var reasonArr : [NSDictionary] = NSArray() as! [NSDictionary]
    
    let listView = UITableView()
    
    var selIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
        whiteBG.backgroundColor = .white
        whiteBG.layer.cornerRadius = 12
        whiteBG.layer.masksToBounds = true
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(506)
            make.centerY.equalToSuperview()
        }
        
        whiteBG.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(28)
            make.top.equalTo(32)
        }
        
        listView.separatorStyle = .none
        listView.showsVerticalScrollIndicator = false
        listView.delegate = self
        listView.dataSource = self
        whiteBG.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom)
            make.bottom.equalTo(-203)
            make.left.right.equalToSuperview()
        }
        
        self.upComplainCategoryList()
        
        placeHolderLabel.sizeToFit()
        contentView.addSubview(placeHolderLabel)
        contentView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        contentView.font = .systemFont(ofSize: 15)
        contentView.textColor = .init(hex: "#333333")
        contentView.backgroundColor = .clear
        whiteBG.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(listView.snp.bottom).offset(21)
            make.left.equalTo(26)
            make.right.equalTo(-26)
            make.height.equalTo(69)
        }
        contentView.delegate = self
        
        whiteBG.addSubview(contentNumLab)
        contentNumLab.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.right.equalTo(-10)
            make.left.equalTo(10)
            make.bottom.equalTo(-90)
        }
        
        whiteBG.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(screenWid / 2 - 16)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
        cancelBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            DispatchQueue.main.async {
                self.removeFromSuperview()
            }
        }
        
        whiteBG.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(cancelBtn)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        enterBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.addComplain()
        }
        
        let btnTopLine = UIView()
        btnTopLine.backgroundColor = .init(hex: "#E4E4E4")
        whiteBG.addSubview(btnTopLine)
        btnTopLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalTo(0)
            make.top.equalTo(cancelBtn)
        }
        
        let btnMidLine = UIView()
        btnMidLine.backgroundColor = .init(hex: "#E4E4E4")
        whiteBG.addSubview(btnMidLine)
        btnMidLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.right.equalTo(cancelBtn)
            make.bottom.top.equalTo(cancelBtn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///获取分类
    func upComplainCategoryList(){
        CourseNetworkProvider.request(.selectComplainCategoryList) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultArrModel.self)
                        if model?.code == 0 {
                            let dic = model!.data
                            if dic != nil {
                                self.reasonArr = dic as! [NSDictionary]
                                DispatchQueue.main.async {
                                    self.listView.reloadData()
                                }
                            }
                        }
                    }
                } catch {
                    
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            }
        }
    }
    
    ///新增投诉
    func addComplain() {
        let model = reasonArr[self.selIndex]
        CourseNetworkProvider.request(.addComplain(
            commentType: self.commentType == -1 ? "" : "\(self.commentType)",
                                        complainCategoryId: model["id"] as? String ?? "",
                                        content: contentView.text ?? "", contentType: "\(self.contentType)",
                                        sourceId: self.sourceId)) { result in
            
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            DispatchQueue.main.async {
                                self.removeFromSuperview()
                                HQGetTopVC()?.view.makeToast("投诉成功")
                            }
                        }
                    }
                }catch {
                }
            case .failure(_):
                HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ComplainViewCell? = tableView.dequeueReusableCell(withIdentifier: "ComplainViewCell") as? ComplainViewCell
        if cell == nil {
            cell = ComplainViewCell.init(style: .default, reuseIdentifier: "ComplainViewCell")
        }
        cell?.model = reasonArr[indexPath.row]
        cell?.isSel = self.selIndex == indexPath.row
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selIndex = indexPath.row
        self.listView.reloadData()
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 300 {
            textView.text = textView.text.subString(to: 299)
            return
        }
        self.contentNumLab.text = "\(textView.text.length)/300"
    }
}

///投诉类型cell
class ComplainViewCell: UITableViewCell {
    var isSel = false{
        didSet{
            selImg.image = isSel ? UIImage.init(named: "my_btnSelect") : UIImage.init(named: "my_btnNormal")
        }
    }
    
    let selImg = UIImageView.initWithName(imgName: "my_btnNormal")
    
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 16), ali: .left)
    let botLine = UIView()
    
    var model : NSDictionary? = nil{
        didSet{
            if model != nil {
                self.titleLab.text = model!["name"] as? String
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(selImg)
        selImg.snp.makeConstraints { make in
            make.width.height.equalTo(19)
            make.left.equalTo(26)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(53)
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        
        botLine.backgroundColor = .init(hex: "#EEEFF0")
        self.contentView.addSubview(botLine)
        botLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
