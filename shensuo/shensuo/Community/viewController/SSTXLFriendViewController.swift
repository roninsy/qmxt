//
//  SSTXLFriendViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/13.
//

import UIKit
import Contacts
import MessageUI


//通讯录好友
class SSTXLFriendViewController: SSBaseViewController{
    

    var searchView : SSSearchView = {
        let search = SSSearchView.init()
        return search
    }()
    
    var listTableView : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .grouped)
        return table
    }()
    
    var listDataArray = Array<Any>()
    var searchTipsV: UIView?
    var searchTipsL: UILabel!
    var searchKey: String?
    
    var registeredList = Array<Any>()
    var unRegisteredList = Array<Any>()
    
    var registerModels : [SSRegisterModel]? = nil{
        didSet{
            if registerModels != nil {
                self.listTableView.reloadData()
            }
        }
    }
    
    var unregisterModels : [SSUnRegisterModel]? = nil{
        didSet{
            if unregisterModels != nil {
                self.listTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchView.delegate = self
//        searchTipsV = UIView.init()
//        searchTipsV?.backgroundColor = .white
//        view.addSubview(searchTipsV!)
//        searchTipsV!.isHidden = true
//        searchTipsL = UILabel.initSomeThing(title: "搜索到", fontSize: 14, titleColor: .init(hex: "#B4B4B4"))
//        searchTipsV!.addSubview(searchTipsL)
        
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.rowHeight = 103
        listTableView.register(focusCell.self, forCellReuseIdentifier: "focusCell")
        listTableView.backgroundColor = UIColor.init(hex: "#EEEFF1")
        listTableView.tableFooterView = UIView.init()
        listTableView.separatorStyle = .none
        //获取通讯录权限
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if status == .authorized {
            self.getPhoneList()
        }
        
        if status == .notDetermined {
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: .contacts, completionHandler: {(granted: Bool, error: Error?) in
                if granted {
                    print("授权成功")
                    self.getPhoneList()
                }
            })
        }
        
        navView.backBtnWithTitle(title: "通讯录好友")
    }
    
   
    func getPhoneList(){
       
        
        let store = CNContactStore.init();
  
        let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
        let request = CNContactFetchRequest.init(keysToFetch: keys as [CNKeyDescriptor]);
        try?store.enumerateContacts(with: request, usingBlock: { [self] (contact, iStop) in
            
            let firstName = contact.familyName;
            let lastName = contact.givenName;
            
            let phoneArr = contact.phoneNumbers;
            var dataDict = Dictionary<String, String>()
            
            for labelValue in phoneArr{
                let cnlabelV = labelValue as CNLabeledValue;
                let value = cnlabelV.value;
                
                let phoneValue = value.stringValue;
                let phoneLabel = cnlabelV.label;
                print(phoneLabel as Any,phoneValue);
            
                dataDict.updateValue(firstName+lastName, forKey: "friendName")
                dataDict.updateValue(phoneValue, forKey: "friendMobile")
                listDataArray.append(dataDict)
            }
      
        });

        self.addressFriendData(json: listDataArray.kj.JSONString())
    }

    func addressFriendData(json:String) -> Void {
        UserInfoNetworkProvider.request(.addressBook(arrays: listDataArray)) { (result) in
            switch result{
                case let .success(moyaResponse):
                    do {
                        let code = moyaResponse.statusCode
                        if code == 200{
                            let json = try moyaResponse.mapString()
                            let model = json.kj.model(ResultDicModel.self)
                            if model?.code == 0 {
                                let dict = model?.data
                                if dict == nil {
                                    return
                                }
                                self.registeredList = (dict?["registeredList"] as! NSArray) as! [Any]
                                self.unRegisteredList = (dict?["unRegisteredList"] as! NSArray) as! [Any]
                                
                                self.registerModels = self.registeredList.kj.modelArray(type: SSRegisterModel.self) as? [SSRegisterModel]
                                self.unregisterModels = self.unRegisteredList.kj.modelArray(type: SSUnRegisterModel.self) as? [SSUnRegisterModel]
                             
                            }else{
                                
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
            
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(NavStatusHei)
            make.left.right.equalToSuperview()
            make.height.equalTo(NavContentHeight)
        }
//
//        self.view.addSubview(searchView)
//        searchView.snp.makeConstraints { (make) in
//            make.top.equalTo(navView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(searchViewHeight)
//        }
//        searchTipsV?.snp.makeConstraints({ make in
//
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(40)
//            make.top.equalTo(searchView.snp.bottom)
//        })
//        searchTipsL.snp.makeConstraints { make in
//
//            make.leading.equalTo(16)
//            make.trailing.equalTo(-16)
//            make.centerY.equalToSuperview()
//        }
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navView.snp.bottom)
        }
    }


}

extension SSTXLFriendViewController:SSSearchViewDelegate {
    func searchDataWithKeyWord(key: String) {
        
        searchKey = key
        
    }
}

extension SSTXLFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.unregisterModels == nil {
            return 0
        }
        if self.registerModels == nil {
            return 0
        }
        
        if self.unregisterModels?.count ?? 0 > 0 && self.registerModels?.count ?? 0 > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (registerModels != nil && registerModels?.count ?? 0 > 0) || (unregisterModels != nil && unregisterModels?.count ?? 0 > 0){
            
            let titleL = UILabel.initSomeThing(title: "", fontSize: 17, titleColor: color33)
            titleL.font = UIFont.MediumFont(size: 17)

            if registerModels != nil && registerModels?.count ?? 0 > 0 {
                
               return 60
            }
            if unregisterModels != nil && unregisterModels?.count ?? 0 > 0 {
                
                return 60
            }
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView.init()
        headerView.backgroundColor = UIColor.white
        if (registerModels != nil && registerModels?.count ?? 0 > 0) || (unregisterModels != nil && unregisterModels?.count ?? 0 > 0){
            
            let titleL = UILabel.initSomeThing(title: "", fontSize: 17, titleColor: color33)
            titleL.font = UIFont.MediumFont(size: 17)
            let marginV = UIView.init()
            marginV.backgroundColor = bgColor
            headerView.addSubview(marginV)
            marginV.snp.makeConstraints { make in
                
                make.leading.trailing.top.equalToSuperview()
                make.height.equalTo(normalMarginHeight)
            }
            
            if registerModels != nil && registerModels?.count ?? 0 > 0 {
                
                titleL.text = "加入全面形体: \(registerModels!.count)人"
                titleL.attributedText = setLastTitleColor(str: titleL.text!, colorStr: "\(registerModels!.count)人")
                headerView.addSubview(titleL)
                titleL.snp.makeConstraints { make in
                    
                    make.leading.equalTo(16)
                    make.top.equalTo(marginV.snp.bottom)
                    make.bottom.equalToSuperview()
                }
                return headerView
            }
            if unregisterModels != nil && unregisterModels?.count ?? 0 > 0 {
                
                titleL.text = "未加入全面形体: \(unregisterModels!.count)人"
                titleL.attributedText = setLastTitleColor(str: titleL.text!, colorStr: "\(unregisterModels!.count)人")
                headerView.addSubview(titleL)
                titleL.snp.makeConstraints { make in
                    
                    make.leading.equalTo(16)
                    make.centerY.equalToSuperview()
                    make.top.equalTo(marginV.snp.bottom)
                    make.bottom.equalToSuperview()
                }
                return headerView
            }
            
        }
        return headerView
    }
    
    func setLastTitleColor(str: String,colorStr: String) ->NSMutableAttributedString {
        
        let protocolText = NSMutableAttributedString(string: str)
      ////        userProtocolLabel.textColor = .init(hex: "#6A7587")

              let range: Range = str.range(of: colorStr)!
              let startLocation = str.distance(from: str.startIndex, to: range.lowerBound)
          
      
              protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation, length: colorStr.length))
              return protocolText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.registerModels!.count > 0 {
            if section == 0 {
                return registerModels!.count
            }
            return unregisterModels!.count
        } else {
            return unregisterModels!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "focusCell", for: indexPath) as! focusCell
        if self.registerModels!.count > 0 {
            if indexPath.section == 0 {
                cell.registerModel = self.registerModels![indexPath.row]
            } else {
                cell.unregisterModel = self.unregisterModels![indexPath.row]
            }
        } else {
            cell.unregisterModel = self.unregisterModels![indexPath.row]
            
        }
        cell.compLabel.isHidden = true
        cell.isUserInteractionEnabled = true
        cell.focusBtn.tag = indexPath.row
        cell.focusBtn.addTarget(self, action: #selector(focusOption(btn:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtindexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    @objc func focusOption(btn:UIButton) -> Void {
//        NSLog("############ clickFocusBtn------%d", btn.tag)
//    }
    
    
}

extension SSTXLFriendViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
                //判断短信的状态
                switch result{
                case .sent:
                    HQGetTopVC()?.view.makeToast("短信已发送")
                case .cancelled:
                    HQGetTopVC()?.view.makeToast("短信取消发送")
                case .failed:
                    HQGetTopVC()?.view.makeToast("短信发送失败")
                default:
                    HQGetTopVC()?.view.makeToast("短信已发送")
                    break
                }
    }
    
    //关注/取消关注
    @objc func focusOption(btn:UIButton) -> Void {
        
        if btn.currentTitle == "邀请" {
            
            //判断设备是否能发短信(真机还是模拟器)
                        if MFMessageComposeViewController.canSendText() {
                            let controller = MFMessageComposeViewController()
                            //短信的内容,可以不设置
                            controller.body = "您的通讯录好友【毛毛老师】邀请您加入全民形体学习，和Ta一起变美吧！http：//www.qmxt.com/download"
                            controller.recipients = [unregisterModels![btn.tag].mobile! as String]
                            //设置代理
                            controller.messageComposeDelegate = self
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            HQGetTopVC()?.view.makeToast("本设备不能发短信")
//                        }
            
        }
        }else{
            
            UserInfoNetworkProvider.request(.focusOption(focusUserId: self.registerModels![btn.tag].userId!)) { (result) in
                switch result {
                    case let .success(moyaResponse):
                        do {
                            let code = moyaResponse.statusCode
                            if code == 200{
                                let json = try moyaResponse.mapString()
                                let model = json.kj.model(ResultModel.self)
                                if model?.code == 0 {
                                    let dic = model?.data
                                    let flag = dic?["type"] as? Bool ?? true
                                    if (!flag) {
                                        HQGetTopVC()?.view.makeToast("取消成功")
                                        btn.setTitle("关注", for: .normal)
                                    }else{
                                        HQGetTopVC()?.view.makeToast("关注成功")
                                        btn.setTitle("已关注", for: .normal)
                                    }
                                
                                }else{
                                   
                                    HQGetTopVC()?.view.makeToast(model?.message ?? "")
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
    
//    func setSerchTitle()  {
//
//        if self.searchKey == "" {
//
//            self.searchTipsV?.isHidden = true
//            self.searchTipsV?.snp.updateConstraints({ make in
//
//                make.height.equalTo(0)
//            })
//            return
//        }
//        self.searchTipsL.text = "共搜到\(self.inType == 4 ? self.curView?.giftModels?.count ?? 0 : self.curView?.courseModels?.count ?? 0 )个与“\(self.searchKey ?? "")”相关信息"
//
//        let protocolText = NSMutableAttributedString(string: self.searchTipsL!.text!)
////        userProtocolLabel.textColor = .init(hex: "#6A7587")
//        let range1: Range = self.searchTipsL!.text!.range(of: "\(self.inType == 4 ? self.curView?.giftModels?.count ?? 0 : self.curView?.courseModels?.count ?? 0)")!
//        let range: Range = self.searchTipsL!.text!.range(of: self.searchKey)!
//        let startLocation = self.searchTipsL!.text!.distance(from: self.searchTipsL!.text!.startIndex, to: range.lowerBound)
//        let startLocation1 = self.searchTipsL!.text!.distance(from: self.searchTipsL!.text!.startIndex, to: range1.lowerBound)
//
//        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation, length: self.searchKey.length))
//        protocolText.bs_set(color: btnColor, range: NSRange.init(location: startLocation1, length: String(self.inType == 4 ? self.curView?.giftModels?.count ?? 0 : self.curView?.courseModels?.count ?? 0).length))
//        self.searchTipsL.attributedText = protocolText
//    }
//
}

