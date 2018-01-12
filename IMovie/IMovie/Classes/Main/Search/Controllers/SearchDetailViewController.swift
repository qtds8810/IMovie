//
//  SearchDetailViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/12.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {

    // MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ds_setNavbar(barColor: kColor.green, shadowColor: UIColor.clear, left_rightColor: kColor.brown, centerColor: kColor.brown, statusBarStyle: .lightContent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = kColor.green
        
    }

}
