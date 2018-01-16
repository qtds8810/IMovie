//
//  Date+Extensions.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2017/6/20.
//  Copyright © 2017年 zds. All rights reserved.
//

import Foundation

/// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()
/// 当前日历对象
private let calendar = Calendar.current

extension Date{
    /// 返回当前的时间点
    ///
    /// - Parameter format: 日期格式，默认为："yyyy-MM-dd HH:mm:ss Z"
    static func ds_nowTimeString(format: String = "yyyy-MM-dd HH:mm:ss Z") -> String {
        
        return ds_dateToString(delta: TimeInterval(), format: format)
    }
    
    /// 计算与当前系统时间偏差 delta 秒数的日期字符串
    ///
    /// - Parameters:
    ///   - delta: 指定日期
    ///   - format: 日期格式，默认为："yyyy-MM-dd HH:mm:ss Z"
    static func ds_dateToString(delta: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss Z") -> String {
        let date = Date(timeIntervalSinceNow: delta)
        
        // 必须设置时间格式，否则会出现用户手机系统非中文时有时差的问题
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    /*
    /// 将新郎格式的字符创转换成日期
    ///
    /// - Parameter str:  Tue Sep 15 12:12:00 +0800 2015
    static func ds_sinaDate(str: String) -> Date? {
        //        QL1(str)
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        return dateFormatter.date(from: str)
    }
    */
    /// 字符串转日期
    ///
    /// - Parameters:
    ///   - dateStr: 时间字符串
    ///   - format: 日期格式，默认为："yyyy-MM-dd HH:mm:ss Z"
    static func ds_StringToDate(dateStr: String, format: String = "yyyy-MM-dd HH:mm:ss Z") -> Date? {
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: dateStr)
    }
    
}
