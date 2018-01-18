//
//  DSSaveFiles.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/18.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation

class DSSaveFiles {
    
    class func save(path: String, data: Data) {
        let pathURL = (path as NSString).replacingOccurrences(of: "/", with: "-")
        //拿到一个本地文件的URL
        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        url?.appendPathComponent("cache/")
        if let urlStr = url?.absoluteString, manager.isExecutableFile(atPath: urlStr) == false {
            try? manager.createDirectory(at: url!, withIntermediateDirectories: true, attributes: nil)
        }
        url?.appendPathComponent(pathURL)
        do {
            try data.write(to: url!)
            QL1("保存到本地\(url!)")
        } catch {
            QL1("保存到本地文件失败，原因：\(error.localizedDescription)")
        }
    }
    
    class func read(path: String) -> Data? {
        let pathURL = (path as NSString).replacingOccurrences(of: "/", with: "-")
        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        url?.appendPathComponent("cache/\(pathURL)")
        if let dataRead = try? Data(contentsOf: url!) {
            return dataRead
        } else {
            QL1("文件不存在，读取本地文件失败")
        }
        return nil
    }
    
    class func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        url?.appendPathComponent("cache")
        do {
            try? manager.removeItem(at: url!)
        }
    }
}
