//
//  friendCellView.swift
//  shensuo
//
//  Created by swin on 2021/3/23.
//

import Foundation
import SnapKit

class friendCellView: UITableViewCell {
    
    var headImageView: UIImageView?
    var nameLabel: UILabel?
    var typeLabel: UILabel?
    var num: UILabel?
    var addBtn: UIButton?
    
    func creatCell() {
        headImageView = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        headImageView?.layer.masksToBounds = true
        headImageView?.layer.cornerRadius = 30
        headImageView?.image = UIImage.init(named: "tabbar-class")
        self.contentView.addSubview(headImageView!)
        
        nameLabel = UILabel.initSomeThing(title: "身所", fontSize: 12, titleColor: .black)
    }
    
}
