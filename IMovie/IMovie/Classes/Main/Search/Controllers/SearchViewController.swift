//
//  SearchViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Property
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        
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
    }
}
