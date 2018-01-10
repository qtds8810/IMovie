//
//  Helper.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

// MARK: - 自定义打印信息
func QL1<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(debug)")
    #endif
}

/// 自定义打印=================
func QLShortLine(_ file: String = #file, function: String = #function, line: Int = #line) {
    let lineString = "======================================"
    #if DEBUG
    print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
    #endif
}

/// 自定义打印+++++++++++++++++++
func QLPlusLine(_ file: String = #file, function: String = #function, line: Int = #line) {
    let lineString = "+++++++++++++++++++++++++++++++++++++"
    #if DEBUG
    print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
    #endif
}
