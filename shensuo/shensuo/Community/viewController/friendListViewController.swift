//
//  friendListViewController.swift
//  shensuo
//
//  Created by swin on 2021/3/23.
//

import Foundation
import SnapKit

class friendListViewController: HQBaseViewController {
    
    
    var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWid, height: screenHei), style: .plain)
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(friendCellView.self, forCellReuseIdentifier: "friendCellView")
        self.view.addSubview(listTableView)
    }
    
}

extension friendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "friendCellView") as! friendCellView
        
        return tableCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

