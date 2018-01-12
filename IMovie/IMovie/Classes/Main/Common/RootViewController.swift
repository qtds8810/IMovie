//
//  RootViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
    }

}

private extension RootViewController {
    private func setupChildControllers() {
        addController(vc: DiscoverViewController(), title: "发现", image: UIImage.init(named: "tabbar_discover"), selectedImage: UIImage.init(named: "tabbar_discover_selected"))
        addController(vc: SearchViewController(), title: "搜索", image: UIImage.init(named: "tabbar_search"), selectedImage: UIImage.init(named: "tabbar_search_selected"))
        addController(vc: MineViewController(), title: "我的", image: UIImage.init(named: "tabbar_mine"), selectedImage: UIImage.init(named: "tabbar_mine_selected"))
    }
    
    private func addController(vc: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {
        vc.tabBarItem = UITabBarItem.init(title: title, image: image, selectedImage: selectedImage)
        vc.title = title
        
        let nav = BaseNavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
}
