//
//  SearchUserListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/7.
//

import UIKit

class SearchUserListView: UITableView,UITableViewDelegate,UITableViewDataSource {

    var totalNum = 0
    
    var models : [SSFocusPopModel]? = nil{
        didSet{
            self.reloadData()
        }
    }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .white
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = models?.count ?? 0
        if totalNum <= num {
            self.mj_footer?.endRefreshingWithNoMoreData()
        }else{
            self.mj_footer?.endRefreshing()
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : SearchUserListCell? = tableView.dequeueReusableCell(withIdentifier: "SearchUserListCell") as? SearchUserListCell
        if cell == nil {
            cell = SearchUserListCell.init(style: .default, reuseIdentifier: "SearchUserListCell")
        }
        cell?.model = models?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models![indexPath.row]
        GotoTypeVC(type: 99, cid: model.id ?? "")
    }
}
