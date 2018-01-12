//
//  NetworkTool.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Moya
import SwiftyJSON

/// 设置Moya请求头部信息
private let endpointClosure = { (target: APIManager) -> Endpoint<APIManager> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    return defaultEndpoint.adding(newHTTPHeaderFields: [
        "APP_NAME": "MY_AWESOME_APP"
        ])
}

/// 设置请求超时时间
private let requestTimeoutClosure = { (endpoint: Endpoint<APIManager>, done: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 30
        QL1("设置请求超时时间：30秒")
        done(.success(request))
    } catch {
        QL1("不能设置请求超时时间")
        DSProgressHUD.show(.success(message: "请求超时设置失败，请检查代码"))
    }
    
}

struct NetworkTool {
    
    static let moyaProvider: MoyaProvider<APIManager> = MoyaProvider<APIManager>.init(endpointClosure: endpointClosure, requestClosure: requestTimeoutClosure, plugins: [kNetworkActivityPlugin])
    
    private init() {}
    
    /// 整体封装请求，成功返回为 model
    ///
    /// - Parameters:
    ///   - target: 请求的接口 api enum
    ///   - isShowError:  是否预先处理错误提示【默认处理】
    ///   - type: 要转化成的 model
    ///   - keyPath: 需要往下解析的路径
    static func request<T: Decodable>(_ target: APIManager, isShowError: Bool = true, type: T.Type, atKeyPath keyPath: String? = nil, success successCallback: @escaping (T) -> Void, failure failureCallback: ((MoyaError) -> Void)? = nil) {
        QL1("\n请求链接：\(target.baseURL.debugDescription + target.path)\n请求头：\(target.headers ?? [:])\n请求参数：\(JSON(target.parameters ?? [:]))")
        
        moyaProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                
                do {
                    let response  = try response.filterSuccessfulStatusCodes()
                    let json = try response.mapJSON()
                    
                    #if DEBUG
                        if let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                            let json = String.init(data: data, encoding: String.Encoding.utf8) {
                            print("解析结果：\(json)")
                        }
                    #endif
                    let t = try response.map(T.self, atKeyPath: keyPath)
                    successCallback(t)
                    
                } catch {
                    let moyaError = (error as! MoyaError)
                    if isShowError {
                        DSProgressHUD.show(.error(message: moyaError.myErrorDescription))
                    }
                    failureCallback?(moyaError)
                }
                
            case .failure(let error):
                if isShowError {
                    DSProgressHUD.show(.error(message: error.myErrorDescription))
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
        QL1("\n请求链接：\(target.baseURL.debugDescription + target.path)\n请求参数：\(JSON(target.parameters ?? [:]))")
        
        moyaProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                
                do {
                    let response  = try response.filterSuccessfulStatusCodes()
                    
                    let json = try response.mapJSON()
                    
                    QL1("解析结果：\(JSON(json))")
                    
                    successCallback(JSON(json))
                } catch {
                    let moyaError = (error as! MoyaError)
                    if isShowError {
                        DSProgressHUD.show(.error(message: moyaError.myErrorDescription))
                    }
                    failureCallback?(moyaError)
                }
                
            case .failure(let error):
                if isShowError {
                    DSProgressHUD.show(.error(message: error.myErrorDescription))
                }
                failureCallback?(error)
            }
        }
    }
    
    static func cancelAllRequest() {
        if #available(iOS 9.0, *) {
            moyaProvider.manager.session.getAllTasks { (tasks) in
                tasks.forEach { $0.cancel() }
            }
        } else {
            // Fallback on earlier versions
            moyaProvider.manager.session.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
        }
    }
    
}

extension MoyaError {
    ///  自己将错误信息转换为中文，其实没必要
    public var myErrorDescription: String? {
        switch self {
        case .imageMapping:
            return "未能将数据映射到图像。"//"Failed to map data to an Image."
        case .jsonMapping:
            return "未能将数据映射到JSON。"//"Failed to map data to JSON."
        case .stringMapping:
            return "未能将数据映射到字符串。"//"Failed to map data to a String."
        case .objectMapping:
            return "无法将数据映射到可解码的对象。"//"Failed to map data to a Decodable object."
        case .encodableMapping:
            return "未能将可编码的对象编码为数据。"//"Failed to encode Encodable object into data."
        case .statusCode:
            return "状态代码不在给定范围内。"//"Status code didn't fall within the given range."
        case .requestMapping:
            return "未能将端点映射到URLRequest。"//"Failed to map Endpoint to a URLRequest."
        case .parameterEncoding(let error):
            return "未能为URLRequest编码参数。\(error.localizedDescription)"//"Failed to encode parameters for URLRequest. \(error.localizedDescription)"
        case .underlying(let error, _):
            return error.localizedDescription
        }
    }
}

extension ObservableType where E == Response {
    /// 可以整体根据是否展示错误提示，在 nettool 中进行统一处理的封装
    public func ds_map<T: Decodable>(_ type: T.Type, isShowError: Bool = true, atKeyPath keyPath: String? = nil) -> Observable<T> {
        return flatMap({ (response) -> Observable<T> in
            do {
                let response  = try response.filterSuccessfulStatusCodes()
                let json = try response.mapJSON()
                
                #if DEBUG
                    if let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                        let json = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("解析结果：\(json)")
                    }
                #endif
                
                return Observable.just(try response.map(T.self, atKeyPath: keyPath, using: JSONDecoder()))
                
            } catch {
                throw error
            }
            
        })
            .catchError({ (error) in
                let moyaError = (error as! MoyaError)
                if isShowError {
                    DSProgressHUD.show(.error(message: moyaError.myErrorDescription))
                }
                throw error
            })
    }
}

