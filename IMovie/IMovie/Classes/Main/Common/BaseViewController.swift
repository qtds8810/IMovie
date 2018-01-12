//
//  BaseViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/12.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension UIViewController {
    
    /// 导航栏、状态栏相关设置（注意在viewWillAppear中调用）
    ///
    /// - Parameters:
    ///   - isFullScreenInteractivePopGestureEnabled: 是否是全屏侧滑，默认为是
    ///   - barColor: 导航栏背景色
    ///   - shadowColor: 导航栏分割线颜色，默认为 nil；如果设置 nil 或者 clear，则为系统默认的分割线
    ///   - left_rightColor: 导航栏左右侧文字颜色
    ///   - centerColor: 导航栏中间文字颜色，默认为darkText
    ///   - navigationBarTransitionStyle: 导航栏样式（JZNavigationBarTransitionStyleSystem: 系统; JZNavigationBarTransitionStyleDoppelganger: 每个控制器间独立）
    ///   - isBarVisible: 导航栏是否可见（true: 可见，false: 隐藏）
    ///   - isStatusBarStyleDefault:  状态栏样式（前提是在 plist 文件中设置 View controller-based status bar appearance选项为 no，true: 系统默认的，即黑色的;false: 白色）
    func ds_setNavbar(barColor: UIColor, shadowColor: UIColor? = nil, left_rightColor: UIColor, centerColor: UIColor?, statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default) {
        // 设置导航栏背景色
        if barColor == UIColor.clear {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.barTintColor = barColor
        }
        // 尽量不要设置navigationBar.isTranslucent属性，frame 布局会错乱
        //        navigationController?.navigationBar.isTranslucent = false
        
        // 设置导航栏分割线
        if shadowColor == UIColor.clear {
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.shadowImage = nil
            if let subviews = navigationController?.navigationBar.subviews.first?.subviews {
                for v in subviews {
                    if v.classForCoder == UIImageView.classForCoder() {
                        let iv = v as! UIImageView
                        
                        if iv.subviews.count > 0 {
                            iv.subviews[0].backgroundColor = shadowColor
                        } else {
                            let tempV = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.33))
                            tempV.backgroundColor = shadowColor
                            iv.insertSubview(tempV, at: 0)
                        }
                        
                    }
                }
            }
        }
        
        // 设置导航栏左右侧颜色
//        navigationController?.navigationBar.tintColor = left_rightColor
        navigationItem.leftBarButtonItem?.tintColor = left_rightColor
        navigationItem.rightBarButtonItem?.tintColor = left_rightColor
        // 设置状态栏颜色
        UIApplication.shared.statusBarStyle = statusBarStyle
    }
}
