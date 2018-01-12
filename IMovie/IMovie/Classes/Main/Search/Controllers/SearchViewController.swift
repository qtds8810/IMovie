//
//  SearchViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

class SearchViewController: UIViewController {
    
    // MARK: - Property
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let footer = UIView()
        footer.frame.size.height = kHeight.d8
        footer.backgroundColor = tableView.backgroundColor
        tableView.tableFooterView = footer
        
        tableView.register(UINib.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: SearchTableViewCell.reuseID)
        
        return tableView
    }()
    
    private lazy var viewModel = SearchViewModel()
    private let bag = DisposeBag()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Private Method
private extension SearchViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.brown
        
        view.addSubview(tableView)
        
        viewModel.tableView = tableView
        viewModel.setupViewModel()
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.viewModel.requestNewData.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.viewModel.requestNewData.onNext(false)
        })
        tableView.mj_header.beginRefreshing()
        
        // tableView Action
        tableView.rx.itemSelected
            .subscribe(onNext: { (indexPath) in
                QL1(indexPath.row)
            })
        .disposed(by: bag)
        
        tableView.rx.modelSelected(Search_StoryModel.self)
            .subscribe(onNext: { [weak self] (model) in
                QL1(model.title)
                let detailVC = SearchDetailViewController()
                detailVC.title = model.id?.description
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
        .disposed(by: bag)
    }
}
