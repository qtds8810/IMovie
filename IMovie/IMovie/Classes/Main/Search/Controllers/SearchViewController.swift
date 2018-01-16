//
//  SearchViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ds_setNavbar(barColor: kColor.main, shadowColor: nil, left_rightColor: kColor.brown, centerColor: kColor.brown, statusBarStyle: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
}

// MARK: - Private Method
private extension SearchViewController {
    private func setupUI() {
        view.addSubview(tableView)
        
        // 初始化 viewmodel
        viewModel.setupViewModel(with: tableView, navigationItem: navigationItem)
        
        
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
