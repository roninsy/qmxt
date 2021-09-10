//
//  SSMyFeedbackViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/11.
//

import UIKit

class SSMyFeedbackViewController: SSBaseViewController {

    var mainTableView = UITableView.init()
    var selectType:String = "建议"
    var typeNum:Int = 1
    
    
    var content:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ishideBar = true
        self.mainTableView.frame = CGRect(x: 0, y: NavBarHeight, width: screenWid, height: screenHei-NavBarHeight)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.tableFooterView = self.footView()
        self.mainTableView.backgroundColor = .init(hex: "#F7F8F9")
        
        self.view.addSubview(self.mainTableView)
        navView.backBtnWithTitle(title: "用户反馈")
        // Do any additional setup after loading the view.
    }
    
    
    func footView() -> UIView {
        let footer = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 200))
        
        let checkBtn = UIButton.init(frame: CGRect(x: 10, y: 100, width: screenWid-20, height: 45))
        checkBtn.setTitle("立即反馈", for: .normal)
        checkBtn.layer.masksToBounds = true
        checkBtn.layer.cornerRadius = 20
        checkBtn.backgroundColor = .init(hex: "#FD8024")
        checkBtn.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.addFeedBack()
        }
        
        footer.addSubview(checkBtn)
        
        return footer
    }
    
    @objc func popVC() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addFeedBack() -> Void {
        UserInfoNetworkProvider.request(.addFeedback(content: self.content, type: self.typeNum)) { (result) in
            switch result {
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultModel.self)
                            if model?.code == 0 {
                                self.view.makeToast("提交反馈成功")
                                self.perform(#selector(self.popVC), with: self, afterDelay: 2)
                            }else{
                                self.view.makeToast(model?.message ?? "出现错误，请重试")
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
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

extension SSMyFeedbackViewController : UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        self.content = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.content = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.content = textView.text
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 12))
        headView.backgroundColor = .init(hex: "#F7F8F9")
        return headView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 56
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell.init()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            let title = UILabel.initSomeThing(title: "反馈类型", fontSize: 16, titleColor: .init(hex: "#000000"))
            title.frame = CGRect(x: 10, y: 13, width: 80, height: 30)
            cell.contentView.addSubview(title)
            
            let content = UILabel.initSomeThing(title: "建议", fontSize: 16, titleColor: .init(hex: "#878889"))
            content.text = self.selectType
            content.textAlignment = .right
            content.frame = CGRect(x: screenWid-80, y: 13, width: 50, height: 30)
            cell.contentView.addSubview(content)
            return cell
        } else {
            let cell = UITableViewCell.init()
            let textView = UITextView.init(frame: CGRect(x: 0, y: 0, width: screenWid, height: 200))
            let placeHolderLabel = UILabel.init()
            placeHolderLabel.text = "请输入内容"
            placeHolderLabel.numberOfLines = 0
            placeHolderLabel.textColor = .lightGray
            placeHolderLabel.sizeToFit()
            textView.addSubview(placeHolderLabel)

            textView.delegate = self
            textView.font = .systemFont(ofSize: 15)
            placeHolderLabel.font = .systemFont(ofSize: 15)
            textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
            cell.contentView.addSubview(textView)
            return cell
        }
        
        return UITableViewCell.init()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let typeView = feedTypeView.init()
            typeView.setTypeTitle(titleArray: [" 建议"," 举报"])
            typeView.typeBlock = {content, type in
                self.selectType = content
                self.typeNum = type
                self.mainTableView.reloadData()
            }
            self.view.addSubview(typeView)
        }
    }
    
}


class feedTypeView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var typeBlock : ((String, Int)->())?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            let checkBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            checkBtn.isUserInteractionEnabled = false
            checkBtn.setTitle(self.listTitles[indexPath.row] as? String, for: .normal)
            checkBtn.setTitleColor(.init(hex: "#333333"), for: .normal)
            checkBtn.setImage(UIImage.init(named: "my_btnNormal"), for: .normal)
            checkBtn.setImage(UIImage.init(named: "my_btnSelect"), for: .selected)
            cell.contentView.addSubview(checkBtn)
        } else {
            let checkBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            checkBtn.isUserInteractionEnabled = false
            checkBtn.setTitle(self.listTitles[indexPath.row] as? String, for: .normal)
            checkBtn.setTitleColor(.init(hex: "#333333"), for: .normal)
            checkBtn.setImage(UIImage.init(named: "my_btnNormal"), for: .normal)
            checkBtn.setImage(UIImage.init(named: "my_btnSelect"), for: .selected)
            cell.contentView.addSubview(checkBtn)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeBlock != nil {
            if indexPath.row == 0 {
                self.typeBlock!("建议", 1)
            } else {
                self.typeBlock!("举报", 2)
            }
        }
        
        self.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    
    var titleLabel = UILabel.initSomeThing(title: "选择反馈类型", isBold: true, fontSize: 20, textAlignment: .center, titleColor: .init(hex: "#333333"))
    
    var listTableView = UITableView.init()
    
    var contentView = UIView.init()
    var listTitles : NSArray = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0.8, alpha: 0.6)
        
        self.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(screenWid-40)
            make.height.equalTo((screenWid-40)/355*230)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        contentView.addSubview(listTableView)
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView.init()
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
    }
    
    func loadOutType() -> Void {
        
    }
    
    func setTypeTitle(titleArray: NSArray) -> Void {
        self.listTitles = titleArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
