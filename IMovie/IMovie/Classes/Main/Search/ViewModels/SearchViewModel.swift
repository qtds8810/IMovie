//
//  SearchViewModel.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/10.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Alamofire

//private func endpointMapping<T: TargetType>(_ target: T) -> Endpoint<T> {
//    QL1(("请求连接：\(target.baseURL)\(target.path) \n方法：\(target.method)\n参数：\(String(describing: target.task)) "))
//    return MoyaProvider.defaultEndpointMapping(for: target)
//}
//
//public func defaultAlamofireManager() -> Manager {
//    
//    let configuration = URLSessionConfiguration.default
//    
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//    
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//    
//    manager.startRequestsImmediately = false
//    configuration.timeoutIntervalForResource = 30
//    
//    return manager
//}

class SearchViewModel: NSObject {
    // MARK: - Property
    let bag = DisposeBag()
    var tableView: UITableView!
    
    var modelObservable = Variable<[Search_StoryModel]>([])
    
    let requestNewData = PublishSubject<Bool>()
    var page = Int()
    
    
    // MARK: - LifeCycle
    override init() {
        super.init()
        
//        modelObservable.asObservable()
//            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.reuseID, cellType: SearchTableViewCell.self)) { (row, model, cell) in
//
//        }
//        .disposed(by: bag)
        
        NetworkTool.request(.getNewsList, type: SearchModel.self, success: { (model) in
            QL1(model)
        }) { (error) in
            QL1(error.localizedDescription)
        }
        
        requestNewData.subscribe(onNext: { (isNew) in
            self.page = isNew ? 0 : (self.page + 1)
            
        }, onError: { (_) in
            
        })
        .disposed(by: bag)
        
    }

}
