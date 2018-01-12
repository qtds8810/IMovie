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

class SearchViewModel: NSObject {
    // MARK: - Property
    let bag = DisposeBag()
    var tableView = UITableView()
    
    var modelObservable = Variable<[Search_StoryModel]>([])
    
    let requestNewData = PublishSubject<Bool>()
    var page = Int()
    
    /// 刷新状态
    var refreshStatus = Variable<DSRefreshStatus>(.none)
    
    
    // MARK: - LifeCycle
    func setupViewModel() {
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        
        modelObservable.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.reuseID, cellType: SearchTableViewCell.self)) { (row, model, cell) in
                cell.showData(model: model)
            }
            .disposed(by: bag)
        
        
        
        requestNewData.subscribe(onNext: { (isNew) in
            self.page = isNew ? 0 : (self.page + 1)
            
            NetworkTool.request(.getNewsList, type: SearchModel.self, success: { (model) in
                
                if isNew {
                    self.modelObservable.value = model.stories!
                    self.refreshStatus.value = DSRefreshStatus.endHeaderRefresh
                } else {
                    self.modelObservable.value += model.stories!
                    self.refreshStatus.value = self.page > 3 ? DSRefreshStatus.noMoreData : DSRefreshStatus.endFooterRefresh
                }
                
                
            }) { (error) in
                QL1(error.localizedDescription)
                if isNew {
                    self.refreshStatus.value = DSRefreshStatus.endHeaderRefresh
                } else {
                    self.refreshStatus.value = DSRefreshStatus.endFooterRefresh
                }
            }
            
        })
            .disposed(by: bag)
        
        refreshStatus.asObservable().subscribe(onNext: { (state) in
            switch state {
            case .none:
                QL1("没有数据呢")
            case .beginHeaderRefresh:
                self.tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.resetNoMoreData()
            case .beginFooterRefresh:
                self.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        })
            .disposed(by: bag)
    }
    
}
