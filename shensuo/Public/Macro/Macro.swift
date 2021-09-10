//
//  Macro.swift
//  shensuo
//
//  Created by Rsy on 2021/9/7.
//

import Foundation

/* --------- 全局定义 (宏) --------- */


// MARK: - 打印 print
/// 设置为仅 Debug
public func print(_ item: Any) {
    #if DEBUG
    print(item, terminator: "\n")
    #endif
}



// MARK: - 沙盒
public let HomePath: String = { return NSHomeDirectory() }()
public let HomeDocumentsPath: String = { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! }()
public let HomeLibraryPath: String = { return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! }()
public let HomeLibraryCachesPath: String = { return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! }()
public let HomeTmpPath: String = { return NSTemporaryDirectory() }()




// MARK: - APP Info

public let APP_ID = "1559685115"
public let APP_BUNDLE_ID = "shensuokeji.shensuo"
public let APP_VERSION: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
