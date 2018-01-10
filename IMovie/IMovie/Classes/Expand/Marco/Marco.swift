//
//  Marco.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 项目上线配置


// MARK: - 各种key
struct kKey {
    /// api 请求用的 key
    static let api = "f539575bedd7836aee57ef69e54413a7"
}


// MARK: - 全局尺寸
/// 主屏幕
struct kScreen {
    /// 主屏幕--尺寸
    static let bounds: CGRect = UIScreen.main.bounds
    /// 主屏幕--宽
    static let width: CGFloat = UIScreen.main.bounds.size.width
    /// 主屏幕--高
    static let height: CGFloat = UIScreen.main.bounds.size.height
}


// MARK: - 全局高度
struct kHeight {
    static let d05: CGFloat = 0.5
    static let d8: CGFloat = 8
    static let d15: CGFloat = 15
    static let d50: CGFloat = 50
    static let d49: CGFloat = 49
    static let d64: CGFloat = 64
}


// MARK: - 全局颜色
struct kColor {
    /// 项目主背景色
    static let main = UIColor.init(white: 22.0 / 255.0, alpha: 1.0)
    /// 项目的 tintColor
    static let tint = UIColor.init(r: 246, g: 122, b: 40)
    /// 白色
    static let white = UIColor.white
    /// 绿色
    static let green = UIColor.green
    /// 棕色
    static let brown = UIColor.brown
    /// 黑色
    static let black = UIColor.black
    /// gray
    static let gray = UIColor.gray
    /// lightGray
    static let lightGray = UIColor.lightGray
    /// lightText
    static let lightText = UIColor.lightText
    /// darkGray
    static let darkGray = UIColor.darkGray
    /// darkText
    static let darkText = UIColor.darkText
    /// tableView 背景色
    static let groupTableViewBackground = UIColor.groupTableViewBackground
    /// tableView 分割线颜色
    static let separator = UIColor.init(hexString: "#cccccc")
}


// MARK: - 全局字号
/// 全局字号
struct kFontSize {
    static let system_11 = UIFont.ds_fontSizeOfMine(11)
    static let system_12 = UIFont.ds_fontSizeOfMine(12)
    static let system_13 = UIFont.ds_fontSizeOfMine(13)
    static let system_14 = UIFont.ds_fontSizeOfMine(14)
    static let system_15 = UIFont.ds_fontSizeOfMine(15)
    static let system_16 = UIFont.ds_fontSizeOfMine(16)
    static let system_17 = UIFont.ds_fontSizeOfMine(17)
    static let system_18 = UIFont.ds_fontSizeOfMine(18)
    static let system_19 = UIFont.ds_fontSizeOfMine(19)
    
    static let bold_18 = UIFont.boldSystemFont(ofSize: 18)
}


// MARK: - 全局时间
/// 全局时间
struct kTime {
    static let duration: TimeInterval = 0.25
}


// MARK: - UserDefaults
/// 全局快捷获取UserDefaults
public let kUserDefaults = UserDefaults.standard
/// UserDefaults的 key 名字
struct kUDkey {
    
}


// MARK: - Notification
/// 全局快捷获取通知
public let kNotificationCenter = NotificationCenter.default
/// 通知名字
struct kNotiName {
    
}


// MARK: - 文案相关
/// 文案相关
struct kTitle {
    
}


