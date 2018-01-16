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
import MJRefresh

class SearchViewModel: NSObject {
    // MARK: - Property
    let bag = DisposeBag()
    
    var modelObservable = Variable<[Search_StoryModel]>([])
    
    let requestCommand = PublishSubject<Bool>()
    var page = Int()
    
    /// 刷新状态
    var refreshStatus = Variable<DSRefreshStatus>(.none)
    
    
    // MARK: - LifeCycle
    func setupViewModel(with tableView: UITableView) {
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        
        modelObservable.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.reuseID, cellType: SearchTableViewCell.self)) { (row, model, cell) in
                cell.showData(model: model)
            }
            .disposed(by: bag)
        
        
        
        requestCommand.subscribe(onNext: { (isNew) in
            self.page = isNew ? 0 : (self.page + 1)
            /*
            NetworkTool.moyaProvider.rx.request(.getNewsList).asObservable()
                .ds_map(SearchModel.self, isShowError: true, atKeyPath: nil)
                .subscribe(onNext: { (model) in
                    
                    if isNew {
                        self.modelObservable.value = model.stories!
                        self.refreshStatus.value = DSRefreshStatus.endHeaderRefresh
                    } else {
                        self.modelObservable.value += model.stories!
                        self.refreshStatus.value = self.page > 3 ? DSRefreshStatus.noMoreData : DSRefreshStatus.endFooterRefresh
                    }
                }, onError: { (error) in
                    QL1(error.localizedDescription)
                    if isNew {
                        self.refreshStatus.value = DSRefreshStatus.endHeaderRefresh
                    } else {
                        self.refreshStatus.value = DSRefreshStatus.endFooterRefresh
                    }
                })
                .disposed(by: self.bag)
            */
            
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
                break
            case .beginHeaderRefresh:
                tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                tableView.mj_header.endRefreshing()
                tableView.mj_footer.resetNoMoreData()
            case .beginFooterRefresh:
                tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                tableView.mj_footer.endRefreshing()
            case .noMoreData:
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        })
            .disposed(by: bag)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.requestCommand.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.requestCommand.onNext(false)
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
}
