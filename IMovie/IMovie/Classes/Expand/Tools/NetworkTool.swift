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


/// 设置请求超时时间
private let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        
        if let path = request.url?.path,
            path.contains("OrderFlow/handleOrder") ||
                path.contains("OrderFlow/newBlocOrder") ||
                path.contains("Order/uploadOilImage") ||
                path.contains("Filling/orderAuthorization") ||
                path.contains("DeliveryCode/createGalaxyOrder") {// 特殊接口请求超时设置长一些
            request.timeoutInterval = 60
        } else {
            request.timeoutInterval = 40
        }
        
        //        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        //        request.httpShouldHandleCookies = false
        //        QL1("设置请求超时时间：30秒")
        done(.success(request))
    } catch MoyaError.requestMapping(let url) {
        done(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        done(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
    
}

struct NetworkTool {
    
    /// 失败别名
    public typealias FailureCallback = (_ moyaError: MoyaError) -> Void
    /// 成功 JSON 别名
    public typealias SuccessJSON = (_ json: JSON) -> Void
    
    static let moyaProvider: MoyaProvider<APIManager> = MoyaProvider<APIManager>.init(requestClosure: requestTimeoutClosure, plugins: [kNetworkActivityPlugin])
    
    private init() {}
    
    
    /// 整体封装请求，成功后返回对应的 model
    ///
    /// - Parameters:
    ///   - target: 请求接口、参数
    ///   - isShowError:  是否预先处理错误提示（默认展示）
    ///   - isCache: 是否缓存成功的数据（默认不缓存）
    ///   - type: 要转化成的 model
    ///   - keyPath: 需要往下解析的路径
    static func ds_request<T: Decodable>(_ target: APIManager,
                                         isShowError: Bool = true,
                                         isCache: Bool = false,
                                         type: T.Type,
                                         atKeyPath keyPath: String? = nil,
                                         progress: ProgressBlock? = .none,
                                         success successCallback: @escaping (T) -> Void,
                                         failure failureCallback: FailureCallback? = nil) {
        
        loadData(target, isShowError: isShowError, isCache: isCache, progress: progress, success: { (response) in
            do {
                let t = try response.map(T.self, atKeyPath: keyPath)
                successCallback(t)
            } catch {
                if let moyaError = error as? MoyaError {
                    if isShowError {
                        DSProgressHUD.show(.error(message: moyaError.myErrorDescription))
                    }
                    failureCallback?(moyaError)
                } else {
                    failureCallback?(MoyaError.underlying(error, response))
                }
                
            }
        }, failure: failureCallback)
        
    }
    
    /// 整体封装请求，成功返回为 json
    ///
    /// - Parameters:
    ///   - target: 请求接口、参数
    ///   - isShowError: 是否预先处理错误提示（默认展示）
    ///   - isCache: 是否缓存成功的数据（默认不缓存）
    static func ds_request(_ target: APIManager,
                           isShowError: Bool = true,
                           isCache: Bool = false,
                           callbackQueue: DispatchQueue? = .none,
                           progress: ProgressBlock? = .none,
                           success successCallback: @escaping SuccessJSON,
                           failure failureCallback: FailureCallback? = nil) {
        
        loadData(target, isShowError: isShowError, isCache: isCache, callbackQueue: callbackQueue, progress: progress, success: { (response) in
            do {
                let json = try response.mapJSON()
                successCallback(JSON(json))
            } catch {
                if let moyaError = error as? MoyaError {
                    if isShowError {
                        DSProgressHUD.show(.error(message: moyaError.myErrorDescription))
                    }
                    failureCallback?(moyaError)
                } else {
                    failureCallback?(MoyaError.underlying(error, response))
                }
            }
        }, failure: failureCallback)
        
    }
    
    /// 所有的请求调用
    ///
    /// - Parameters:
    ///   - target: 接口路径、参数
    ///   - isShowError: 是否展示请求错误的弹框（默认展示）
    ///   - isCache: 是否缓存到本地，（默认不缓存）
    private static func loadData(_ target: APIManager,
                                 isShowError: Bool = true,
                                 isCache: Bool = false,
                                 callbackQueue: DispatchQueue? = .none,
                                 progress: ProgressBlock? = .none,
                                 success successCallback: @escaping (Response) -> Void,
                                 failure failureCallback: FailureCallback?) {
        
        QL1("\n请求方法：\(target.method)\n请求链接：\(target.baseURL.debugDescription + target.path)\n请求头：\(target.headers ?? [:])\n请求参数：\(target.parameters ?? [:])")
        
        // 判断是否加载本地缓存，能否成功加载
        if isCache, let data = DSSaveFiles.read(path: target.path) {
            QL1("加载缓存数据---")
            successCallback(Response.init(statusCode: 200, data: data))
            return
        }
        
        moyaProvider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(let response):
                
                do {
                    let response  = try response.filterSuccessfulStatusCodes()
                    
                    if isCache {// 缓存到本地
                        DSSaveFiles.save(path: target.path, data: response.data)
                    }
                    
                    #if DEBUG
                    let json = try response.mapJSON()
                    if let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                        let json = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("解析结果：\(json)")
                    }
                    #endif
                    
                    successCallback(response)
                    
                } catch {
                    if let moyaError = error as? MoyaError {
                        if isShowError {
                            DSProgressHUD.show(.error(message: moyaError.myErrorDescription))
                        }
                        failureCallback?(moyaError)
                    } else {
                        failureCallback?(MoyaError.underlying(error, response))
                    }
                }
                
            case .failure(let error):
                if isShowError {
                    DSProgressHUD.show(.error(message: error.myErrorDescription))
                }
                failureCallback?(error)
            }
        }
        
    }
    
    /// 取消所有的请求
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
        case .statusCode(let response):
            return "状态代码不在给定范围内。(\(response.statusCode))"//"Status code didn't fall within the given range."
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
                
                #if DEBUG
                    let json = try response.mapJSON()
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

