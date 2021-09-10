//
//  SSTopFollowView.swift
//  shensuo
//
//  Created by  yang on 2021/3/30.
//

import Foundation
import SnapKit


class SSTopFollowView: UIView {
    
    var followView = UIView.init()
    var closeBtn = UIButton.init()
    var tableview = UITableView.init()
    var tipLabel = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    func buildUI() -> Void {
        
        tipLabel.text = "特别为您推荐可能感兴趣的女神"
        tipLabel.textColor = .black
        tipLabel.font.withSize(12)
        tipLabel.textAlignment = .center
        followView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        followView.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.addSubview(followView)
        followView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom)
            make.left.equalTo(0)
            make.width.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SSTopFollowView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        return cell
    }
    
    
}
