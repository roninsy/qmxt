//
//  CommentLookMoreCell.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/18.
//

import UIKit

class CommentLookMoreCell: UITableViewCell {

    let titleLab = UILabel.initSomeThing(title: "展开更多回复", titleColor: .init(hex: "#999999"), font: .systemFont(ofSize: 14), ali: .left)
    let showBtn = UIButton()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white

        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.bottom.equalTo(-16)
            make.left.equalTo(98)
            make.right.equalTo(-10)
        }
        
        self.contentView.addSubview(showBtn)
        showBtn.snp.makeConstraints { make in
            make.edges.equalTo(titleLab)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
