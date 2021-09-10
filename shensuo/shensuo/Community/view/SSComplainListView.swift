//
//  SSComplainListView.swift
//  shensuo
//
//  Created by  yang on 2021/7/19.
//

import UIKit

class SSComplainListView: UIView {

    var reasonArr : [NSDictionary] = NSArray() as! [NSDictionary]
    let listView = UITableView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
