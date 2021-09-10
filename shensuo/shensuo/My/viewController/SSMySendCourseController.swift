//
//  SSMySendCourseController.swift
//  shensuo
//
//  Created by  yang on 2021/7/7.
//

import UIKit

class SSMySendCourseController: SSBaseViewController {
    
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navView.backBtnWithTitle(title: type == 0 ? "发布课程" : "发布文案")
        let scrollView = UIScrollView.init()
        view.addSubview(scrollView)
        scrollView.backgroundColor = bgColor
        scrollView.snp.makeConstraints { make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navView.snp.bottom)
        }
        let iconv = UIImageView.initWithName(imgName: type == 0 ? "send_course" : "send_programme")
        scrollView.addSubview(iconv)
        let iconVH = screenWid / 414 * 912
        iconv.snp.makeConstraints { make in
            
            make.leading.top.equalTo(16)
            make.height.equalTo(iconVH)
            make.width.equalTo(screenWid - 32)
        }
//        iconv.frame = CGRect(x: 16, y: 16, width: screenWid - 32, height: iconVH)
        scrollView.contentSize = CGSize(width: 0, height: iconVH + 32)
        
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
