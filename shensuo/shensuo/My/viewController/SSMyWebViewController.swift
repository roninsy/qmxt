//
//  SSMyWebViewController.swift
//  shensuo
//
//  Created by  yang on 2021/4/19.
//

import UIKit

enum loadType {
    case YHXY  //用户协议
    case YSXY  //隐私协议
}

class SSMyWebViewController: SSBaseViewController {

    var type:loadType = .YHXY
    
    var xyWebView:UIWebView = {
        let webView = UIWebView.init()
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ishideBar = true
        switch type {
            case .YHXY:
                navView.backBtnWithTitle(title: "“全民形体”用户协议")
                break
            case .YSXY:
                navView.backBtnWithTitle(title: "隐私政策")
                break
            default:
                navView.backBtnWithTitle(title: "隐私政策")
                break
        }
        
        xyWebView.frame = CGRect(x: 0, y: NavBarHeight, width: screenWid, height: screenHei-NavBarHeight)
        self.view.addSubview(xyWebView)
        
        xyWebView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.quanminxingti.com/h5/#/userAgreement")!))
        
        // Do any additional setup after loading the view.
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
