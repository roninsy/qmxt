//
//  SSBeautiBillDataViewController.swift
//  shensuo
//
//  Created by  yang on 2021/5/4.
//

import UIKit
import JXPagingView

class SSBeautiBillDataViewController: UITableViewController {

    var index = 0
    
    var updateBlanceBlock: stringBlock? = nil
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    var billModels:[SSBillModel]? = nil{
        didSet{
            if billModels != nil {
                if billModels!.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //企业美币任务
    var companyBillModels:[SSBillModel]? = nil{
        didSet{
            if billModels != nil {
                if billModels!.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(SSBillCell.self, forCellReuseIdentifier: "SSBillCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() -> Void {
    
        UserInfoNetworkProvider.request(.getPointsJop) { (result) in
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
                                
                                let total = dic?["balance"] as! String //美币余额
                                if self.updateBlanceBlock != nil {
                                    self.updateBlanceBlock!(total)
                                }
                                
                                let arr = dic?["pointsJob"] as! NSArray
                                let arr2 = dic?["verifyJob"] as! NSArray
                                self.billModels = arr.kj.modelArray(type: SSBillModel.self)
                                        as? [SSBillModel]
                                self.companyBillModels = arr2.kj.modelArray(type: SSBillModel.self)
                                        as? [SSBillModel]

                             
                            }else{
                                self.tableView.mj_footer?.isHidden = true
                                HQShowNoDataView(parentView: self.view, imageName: "my_nosc", tips: "暂无任务")
                            }
                        }
                        
                    } catch {
                        
                    }
                case let .failure(error):
                    logger.error("error-----",error)
                }
        }
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if index == 0 {
            return self.billModels?.count ?? 0
        }
        return self.companyBillModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSBillCell", for: indexPath) as! SSBillCell
        cell.selectionStyle = .none
        if index == 0 {
            cell.billModel = self.billModels?[indexPath.row]
        }else{
            cell.billModel = self.companyBillModels?[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var model = self.billModels?[indexPath.row]
        if index == 1 {
            model = self.companyBillModels?[indexPath.row]
        }
        return 58 + (model?.myHei ?? 22)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ///美币魔盒cell选中方法
        var model = self.billModels?[indexPath.row]
        if index == 1 {
            model = self.companyBillModels?[indexPath.row]
        }
        GotoTypeVC(type: model?.type ?? 0, cid: model?.code ?? "0")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
            self.listViewDidScrollCallback!(scrollView)
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

extension SSBeautiBillDataViewController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}



