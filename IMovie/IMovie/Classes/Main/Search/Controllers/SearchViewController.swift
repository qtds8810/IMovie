//
//  SearchViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import MJRefresh

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
    }
}
