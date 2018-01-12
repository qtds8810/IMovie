//
//  String+Extension.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

extension String {
    
    /// 返回第一次出现的指定子字符串在此字符串中的索引
    func positionOf(sub:String) -> Int {
        var pos = -1
        if let range = range(of:sub) {
            if !range.isEmpty {
                pos = distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    /// 将当前字符串拼接到cache目录后面
    var cacheDir: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        return filePath
    }
    
    /// 将当亲字符串拼接到doc目录后面
    var docDir: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    /// 将当前字符串拼接到tmp目录后面
    var tmpDir: String {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /*
     /// MD5加密，经过检测，有内存泄露
     func toMd5() ->String {
     let str = self.cString(using: String.Encoding.utf8)
     let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
     let digestLen = Int(CC_MD5_DIGEST_LENGTH)
     let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
     CC_MD5(str!, strLen, result)
     let hash = NSMutableString()
     for i in 0 ..< digestLen {
     hash.appendFormat("%02x", result[i])
     }
     result.deinitialize()
     return String(format: hash as String)
     }
     */
    /// URL中文转码：encodeURIComponent编码方式,会对特殊符号编码；
    func urlEncodeWithSpecialCharacter() -> String {
        /// 方法一
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        
        /// 方法二
        //        return CFURLCreateStringByAddingPercentEscapes(nil, self, nil, "!*'();:@&=+$,/?%#[]", CFStringBuiltInEncodings.UTF8.rawValue)
    }
    
    /// URL中文转码：encodeURI编码,不会对特殊符号编码;
    func urlEncodeExceptSpecialCharacter() -> String {
        return CFURLCreateStringByAddingPercentEscapes(nil, self as CFString!, "!*'();:@&=+$,/?%#[]" as CFString!, nil, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    func widthWithLimit(size: CGSize, font: UIFont) -> CGFloat {
        return sizeWithLimit(size: size, font: font).width
    }
    
    func heightWithLimit(size: CGSize, font: UIFont) -> CGFloat {
        return sizeWithLimit(size: size, font: font).height
    }
    
    func sizeWithLimit(size: CGSize, font: UIFont) -> CGSize {
        guard count > 0 else {
            return CGSize.zero
        }
        
        return (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
    }
    
}
