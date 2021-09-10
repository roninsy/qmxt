//
//  SSMyExchangeDataViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/16.
//

import UIKit

enum cellType {
    case didUsed //已使用
    case unUsed  //未使用
    case outTime //失效
}

public protocol exChangeDataDelegate {
    func updateSegmentTitle(usedNum:Int, unUsedNum:Int, outTimeNum:Int) -> Void
}

class SSMyExchangeDataViewController: UITableViewController {

    var delegate:exChangeDataDelegate?
    
    var type:cellType?
    var navController: UINavigationController!
    var page : Int = 1
    var pageSize : Int = 10
    var usedCount : Int = 0
    var unUsedCount : Int = 0
    var outTimeCount : Int = 0
    var bLoad : Bool = false
    
    
    
    var exchangeModes:[SSExchangeModel]? = nil {
        didSet{
            if exchangeModes != nil {
                if exchangeModes!.count > 0 {
                    tableView.reloadData()
                }
            }
        }
    }
    
    var request:UserInfoApiManage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.separatorStyle = .none
        tableView.register(SSExchangeCell.self, forCellReuseIdentifier: "SSExchangeCell")
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadFirstData()
        })

        
        self.loadFirstData()
    }
    
    func loadFirstData() {
        
        var dataDict = Dictionary<String, Bool>()
        
        switch self.type {
            case .didUsed:
                dataDict.updateValue(true, forKey: "used")
                request = .selectMyExchanges(data: dataDict as NSDictionary, pageNumber: self.page, size: self.pageSize)
                break
            case .unUsed:
                dataDict.updateValue(false, forKey: "used")
                request = .selectMyExchanges(data: dataDict as NSDictionary, pageNumber: self.page, size: self.pageSize)
                break
            case .outTime:
                request = .selectMyExchangesEnd(pageNumber: self.page, size: self.pageSize)
                
                break
            default:
                break
        }
        
        UserInfoNetworkProvider.request(request!) { [self] (result) in
            switch result {
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
                                let total = dic?["totalElements"] as! String
                                if (total.toInt ?? 0) > 0 {
                                    let arr = dic?["content"] as! NSArray
                                    if self.page == 1 {
                                        self.exchangeModes = arr.kj.modelArray(type: SSExchangeModel.self)
                                            as? [SSExchangeModel]
                                        
                                        switch self.type {
                                            case .didUsed:
                                                self.usedCount = self.exchangeModes?.count ?? 0
                                                break
                                            case .unUsed:
                                                self.unUsedCount = self.exchangeModes?.count ?? 0
                                                break
                                            case .outTime:
                                                self.outTimeCount = self.exchangeModes?.count ?? 0
                                                self.bLoad = true
                                                break
                                            default:
                                                break
                                        }
                                        if self.bLoad {
                                            delegate?.updateSegmentTitle(usedNum: self.usedCount, unUsedNum: self.unUsedCount, outTimeNum: self.outTimeCount)
                                        }
                                        
                                    } else {
                                        let models = arr.kj.modelArray(type: SSExchangeModel.self)
                                            as? [SSExchangeModel]
                                        self.exchangeModes = self.exchangeModes! + (models ?? [])
                                        switch self.type {
                                            case .didUsed:
                                                self.usedCount = self.exchangeModes?.count ?? 0
                                                break
                                            case .unUsed:
                                                self.unUsedCount = self.exchangeModes?.count ?? 0
                                                break
                                            case .outTime:
                                                self.outTimeCount = self.exchangeModes?.count ?? 0
                                                self.bLoad = true
                                                break
                                            default:
                                                break
                                        }
                                        
                                        if self.bLoad {
                                            delegate?.updateSegmentTitle(usedNum: self.usedCount, unUsedNum: self.unUsedCount, outTimeNum: self.outTimeCount)
                                        }
                                    }
                                    self.isHiddenFooter(model: self.exchangeModes as AnyObject)
                                }
                                
                             
                            }else{
                                self.tableView.mj_footer?.isHidden = true
                                HQShowNoDataView(parentView: self.view, imageName: "my_nosc", tips: "暂无优惠券")
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }
    
    func isHiddenFooter(model:AnyObject) -> Void {
        if model.count < page*pageSize {
            self.tableView.mj_footer?.isHidden = true
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.exchangeModes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.exchangeModes?[indexPath.row]
        return (screenWid-20)/394*107+13+(model?.isOpen == true ? (62 + (model?.remarkHei ?? 18)) : 0)
    }

//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSExchangeCell", for: indexPath) as! SSExchangeCell
        if cell.openBlock == nil {
            cell.openBlock = {[weak self] num in
                DispatchQueue.main.async {
                    let isOpen = self?.exchangeModes?[num].isOpen ?? false
                    self?.exchangeModes?[num].isOpen = !isOpen
                }
            }
        }
        cell.tag = indexPath.row
        cell.type = type
        cell.selectionStyle = .none
        cell.model = self.exchangeModes?[indexPath.row]
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
