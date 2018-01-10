//
//  ImageURLTool.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/5.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation

class ImageURLTool {
    static let baseURL = "http://image.tmdb.org/t/p/"
    static let baseURL_https = "https://image.tmdb.org/t/p/"
    
    enum ImageType {
        case backdrop
    }
    
    private enum backdrop_size {
        case w300, w780, w1280, original
    }
    
    class func standardImage(path: String?, type: ImageType) -> URL? {
        if let path = path {
            switch type {
            case .backdrop:
                return URL.init(string: ImageURLTool.baseURL_https + "\(backdrop_size.w780)" + path)
            }
        }
        return nil
    }
    
}
