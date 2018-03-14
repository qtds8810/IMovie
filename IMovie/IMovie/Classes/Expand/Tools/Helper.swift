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
        print("\((file as NSString).lastPathComponent):\(line) \(function): \(debug)")
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

// MARK: - 获取最顶层的ViewController
func global_getTopViewController() -> UIViewController? {
    var resultVC: UIViewController?
    if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
        resultVC = getTopVC(rootVC)
        while resultVC?.presentedViewController != nil {
            resultVC = resultVC?.presentedViewController
        }
    }
    return resultVC
}

private func getTopVC(_ object: AnyObject?) -> UIViewController? {
    if let navVC = object as? UINavigationController {
        return getTopVC(navVC.viewControllers.last)
    } else if let tabBarVC = object as? UITabBarController {
        if tabBarVC.selectedIndex < tabBarVC.viewControllers!.count {
            return getTopVC(tabBarVC.viewControllers![tabBarVC.selectedIndex])
        }
    } else if let vc = object as? UIViewController {
        return vc
    }
    return nil
}
