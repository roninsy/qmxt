//
//  SSLineView.swift
//  shensuo
//
//  Created by swin on 2021/3/27.
//

import Foundation
import SnapKit

class lineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let line = UIView.init(frame: frame)
        line.backgroundColor = .gray
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
