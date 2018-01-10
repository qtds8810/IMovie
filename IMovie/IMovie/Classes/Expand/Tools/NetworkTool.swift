//
//  NetworkTool.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

struct NetworkTool {
    
    static let moyaProvider = MoyaProvider<APIManager>()
    
    /// 整体封装请求，成功返回为 model
    ///
    /// - Parameters:
    ///   - target: 请求的接口 api enum
    ///   - isShowError:  是否预先处理错误提示【默认处理】
    ///   - type: 要转化成的 model
    ///   - keyPath: 需要往下解析的路径
    static func request<T: Decodable>(_ target: APIManager, isShowError: Bool = true, type: T.Type, atKeyPath keyPath: String? = nil, success successCallback: @escaping (T) -> Void, failure failureCallback: ((MoyaError) -> Void)? = nil) {
        moyaProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                
                // 失败状态码过滤
                guard (200...299).contains(response.statusCode) else {
                    let moyaError = MoyaError.statusCode(response)
                    if isShowError {
                        DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                    }
                    failureCallback?(moyaError)
                    return
                }
                
                // 转 JSON【直接调用 Moya】
                guard let json = try? response.mapJSON() else {
                    let moyaError = MoyaError.jsonMapping(response)
                    if isShowError {
                        DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                    }
                    failureCallback?(moyaError)
                    return
                }
                /*
                 // 转 JSON【自己写】
                 guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
                 let moyaError = MoyaError.jsonMapping(response)
                 if isShowError {
                 DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                 }
                 throw moyaError
                 }
                 */
                #if DEBUG
                    if let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                        let json = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("解析结果：\(json)")
                    }
                #endif
                
                do {
                    let t = try response.map(T.self, atKeyPath: keyPath)
                    successCallback(t)
                } catch let error {
                    let moyaError = MoyaError.objectMapping(error, response)
                    if isShowError {
                        DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                    }
                    failureCallback?(moyaError)
                }
                
            case .failure(let error):
                if isShowError {
                    DSProgressHUD.showMessage(message: error.localizedDescription)
                }
                failureCallback?(error)
            }
        }
    }
    
    /// 整体封装请求，成功返回为 json
    ///
    /// - Parameters:
    ///   - target: 请求的接口 api enum
    ///   - isShowError: 是否预先处理错误提示【默认处理】
    static func request(_ target: APIManager, isShowError: Bool = true, success successCallback: @escaping (JSON) -> Void, failure failureCallback: ((MoyaError) -> Void)? = nil) {
        moyaProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                
                // 失败状态码过滤
                guard (200...299).contains(response.statusCode) else {
                    let moyaError = MoyaError.statusCode(response)
                    if isShowError {
                        DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                    }
                    failureCallback?(moyaError)
                    return
                }
                
                // 转 JSON【直接调用 Moya】
                guard let json = try? response.mapJSON() else {
                    let moyaError = MoyaError.jsonMapping(response)
                    if isShowError {
                        DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                    }
                    failureCallback?(moyaError)
                    return
                }
                
                QL1("解析结果：\(JSON(json))")
                
                successCallback(JSON(json))
                
            case .failure(let error):
                failureCallback?(error)
            }
        }
    }
    
}

extension MoyaError {
    ///  自己将错误信息转换为中文，其实没必要
    public var myErrorDescription: String? {
        switch self {
        case .imageMapping:
            return "图片解析失败"//"Failed to map data to an Image."
        case .jsonMapping:
            return "data 转 JSON 失败"//"Failed to map data to JSON."
        case .stringMapping:
            return "data 转 string 失败"//"Failed to map data to a String."
        case .objectMapping:
            return "data 不能解码"//"Failed to map data to a Decodable object."
        case .encodableMapping:
            return "编码失败"//"Failed to encode Encodable object into data."
        case .statusCode:
            return "状态码不在指定区间"//"Status code didn't fall within the given range."
        case .requestMapping:
            return "点对点没有建立连接"//"Failed to map Endpoint to a URLRequest."
        case .parameterEncoding(let error):
            return "参数编码失败：\(error.localizedDescription)"//"Failed to encode parameters for URLRequest. \(error.localizedDescription)"
        case .underlying(let error, _):
            return error.localizedDescription
            
//            let nsError = error as NSError
//            return nsError.localizedDescription
            
        }
    }
}

extension Observable {
    /// 暂时废弃了该使用方法，不再用 rxswift 封装 Moya 了！请直接使用 NetworkTool.request……方法
    public func ds_map<T: Decodable>(_ type: T.Type, isShowError: Bool = true, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
        return map({ (res) in
            guard let response = res as? Moya.Response else {
                let moyaError = MoyaError.requestMapping("无响应")
                if isShowError {
                    DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                }
                throw moyaError
            }
            
            // 失败状态码过滤
            guard (200...299).contains(response.statusCode) else {
                let moyaError = MoyaError.statusCode(response)
                if isShowError {
                    DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                }
                throw moyaError
            }
            
            // 转 JSON【直接调用 Moya】
            guard let json = try? response.mapJSON() else {
                let moyaError = MoyaError.jsonMapping(response)
                if isShowError {
                    DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                }
                throw moyaError
            }
            /*
             // 转 JSON【自己写】
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
                let moyaError = MoyaError.jsonMapping(response)
                if isShowError {
                    DSProgressHUD.showMessage(message: moyaError.localizedDescription)
                }
                throw moyaError
            }
            */
            #if DEBUG
                if let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                    let json = String.init(data: data, encoding: String.Encoding.utf8) {
                    print("解析结果：\(json)")
                }
            #endif
            
            do {
                return try response.map(T.self, atKeyPath: keyPath, using: decoder)
            } catch let error {
                throw MoyaError.objectMapping(error, response)
            }
        }).catchError({ (error) in
            let moyaError = MoyaError.requestMapping(error.localizedDescription)
            if isShowError {
                DSProgressHUD.showMessage(message: error.localizedDescription)
            }
            throw moyaError
        })
    }
    
}

