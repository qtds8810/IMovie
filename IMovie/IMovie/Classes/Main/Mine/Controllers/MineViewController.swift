//
//  MineViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class MineViewController: UIViewController {
    
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
    
    private let bag = DisposeBag()
    private lazy var viewModel = MineViewModel.init()
    
    // MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ds_setNavbar(barColor: kColor.main, shadowColor: nil, left_rightColor: kColor.brown, centerColor: kColor.brown, statusBarStyle: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let nsError = NSError(domain: "测试错误", code: 0, userInfo: [NSLocalizedDescriptionKey: "测试错误"])
        
        let moyaError = MoyaError.underlying(nsError as Error, Response.init(statusCode: 0, data: Data()))
//        let moyaError = MoyaError.requestMapping("测试错误")
        DSProgressHUD.show(DSHUDType.error(message: moyaError.myErrorDescription), to: view)
    }
    
}

// MARK: - Private Method
private extension MineViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.orange
//        view.addSubview(tableView)
//
//        viewModel.setupViewModel(with: tableView)
    }
}
