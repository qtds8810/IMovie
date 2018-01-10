//
//  APIManager.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/5.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import Moya

enum APIManager {
    /// 发现控制器
    case discover
    /// 我的 - 获取新闻
    case getNewsList
    /// 我的 - 获取更多新闻
    case getMoreNews(String)
}

// MARK: - TargetType
extension APIManager: TargetType {
    var baseURL: URL {
        switch self {
        case .getNewsList, .getMoreNews(_):
            return URL(string: "http://news-at.zhihu.com/api/")!
        default:
            return URL(string: "https://api.themoviedb.org/3")!
        }
    }
    
    var path: String {
        switch self {
        case .getNewsList:
            return "4/news/latest"
        case .getMoreNews(let date):
            return "4/news/before/" + date
        case .discover:
            return "/discover/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .discover:
//            return .get
        default:
            return .get
        }
    }
    
    /// 这个就是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "我是sampleData".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getNewsList, .getMoreNews(_):
            return Task.requestPlain
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
//        case .getNewsList, .getMoreNews(_):
//            return nil
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getNewsList, .getMoreNews(_):
            return nil
        default:
            return ["api_key": kKey.api]
        }
    }
    
}

/**
 The String extension is just for convenience – you don't have to use it.
 */
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
