//
//  MineViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Private Method
private extension MineViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.orange
    }
}
