//
//  BaseNavigationController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/12.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            /*
            let title = childViewControllers.count == 1 ? childViewControllers.first?.title : "返回"
            
            // 文字、图片
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.setImage(UIImage(named: "nav_back"), for: .normal)
            btn.backgroundColor = kColor.green
            btn.frame = CGRect(x: -kHeight.d15, y: 0, width: 0, height: kHeight.d44)
            btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
             viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
            */
            // 只有图片
            let item2 = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(popVC))
            item2.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            viewController.navigationItem.leftBarButtonItem = item2
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popVC() {
        popViewController(animated: true)
    }

}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count != 1
    }
}
