//
//  CommonTools.swift
//  shensuo
//
//  Created by Rsy on 2021/9/7.
//

import Foundation

// MARK: - String 转 Class
public func ClassFromString(_ aClassName: String) -> AnyClass? {
    let nameSpage: String = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
    return NSClassFromString(nameSpage + "." + aClassName)
}
