//
//  DiscoverViewModel.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import RxSwift

class DiscoverViewModel {
    
    enum ReloadView {
        case collection, table
    }
    
    let bag = DisposeBag()
    var cycleItems = [DiscoverModel]()
    
    let reloadSubject = PublishSubject<ReloadView>()
    
    
    
    init() {
        // 轮播图
        NetworkTool.request(.discover, type: [DiscoverModel].self, atKeyPath: "results", success: { (models) in
            if self.cycleItems.count > 0 {
                self.cycleItems.removeAll()
            }
            
            self.cycleItems.append(contentsOf: models)
            
            if let model = models.last {
                self.cycleItems.insert(model, at: 0)
                self.cycleItems.append(models[0])
            }
            
            self.reloadSubject.onNext(DiscoverViewModel.ReloadView.collection)
            
        })
        
        
//        NetworkTool.request(APIManager.discover, isShowError: true, success: { (json) in
////            QL1(json)
//        })
        
    }
    
}
