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
    var page: Int = 0
    
    /// 刷新状态
    var refreshStatus = Variable<DSRefreshStatus>(.none)
    var newsDate = ""
    
    // MARK: - LifeCycle
    func setupViewModel(with tableView: UITableView, navigationItem: UINavigationItem) {
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        
        modelObservable.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.reuseID, cellType: SearchTableViewCell.self)) { (row, model, cell) in
                cell.showData(model: model)
            }
            .disposed(by: bag)
        
        
        
        requestCommand.subscribe(onNext: { [unowned self] (isNew) in
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
            
            if isNew { // 下拉刷新
                NetworkTool.ds_request(.getNewsList, type: SearchModel.self, success: { (model) in
                    self.newsDate = model.date ?? ""
                    navigationItem.title = "今日要闻"
                    self.modelObservable.value = model.stories!
                    self.refreshStatus.value = DSRefreshStatus.endHeaderRefresh
                    
                }) { (error) in
                    self.refreshStatus.value = DSRefreshStatus.endHeaderRefresh
                }
                
            } else { // 上拉加载更多
                NetworkTool.ds_request(.getMoreNews(self.newsDate), type: SearchModel.self, success: { (model) in
                    self.newsDate = model.date ?? ""
                    navigationItem.title = self.dateStrToNewDateStr(old: model.date ?? "")//model.date
                    self.modelObservable.value += model.stories!
                    // TODO: - 测试，暂时用
                    self.refreshStatus.value = self.page > 10 ? DSRefreshStatus.noMoreData : DSRefreshStatus.endFooterRefresh
//                    self.refreshStatus.value = DSRefreshStatus.endFooterRefresh
                    
                }) { (error) in
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
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.requestCommand.onNext(false)
        })
        
        tableView.mj_header.beginRefreshing()
        
    }
    
    private func dateStrToNewDateStr(old oldDateStr: String) -> String {
        let date = Date.ds_StringToDate(dateStr:  oldDateStr, format: "yyyyMMdd")
        return Date.ds_dateToString(delta: date?.timeIntervalSinceNow ?? TimeInterval(), format: "yyyy年MM月dd日")
    }
    
}
