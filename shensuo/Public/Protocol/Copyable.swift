//
//  Copyable.swift
//  umma
//
//  Created by RSY on 2019/8/21.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation


// MARK: - 对象复制
protocol Copyable: AnyObject {
    func copy() -> Self
}

extension Copyable where Self: Codable {
    func copy() -> Self {
        guard let data = try? JSONEncoder().encode(self)
            , let copy = try? JSONDecoder().decode(Self.self, from: data) else { fatalError(#""\#(Self.self)" JSON encode or decode error!"#) }
        return copy
    }
}
