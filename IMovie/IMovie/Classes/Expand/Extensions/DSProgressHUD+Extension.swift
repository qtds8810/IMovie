//
//  DSProgressHUD+Extension.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import MBProgressHUD

class DSProgressHUD {
    /// 用户设置取消按钮，点击取消按钮隐藏
    static var tmpView: UIView?
    static let hudKeyWindow = UIApplication.shared.keyWindow!
    
    private init() {}
    
    class func showMessage(title: String? = nil, message: String?, offsetY: CGFloat = MBProgressMaxOffset, afterDelay: TimeInterval = 1) {
        let hud = MBProgressHUD.showAdded(to: hudKeyWindow, animated: true)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = title
        hud.detailsLabel.text = message
        hud.offset.y = offsetY
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
    // MARK: - Private Class Method
    private class func show(text: String, icon: String, view: UIView) {
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.bezelView.style = MBProgressHUDBackgroundStyle.blur
        hud.bezelView.backgroundColor = UIColor.black
        
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        hud.detailsLabel.text = text
        //设置图片
        hud.customView = UIImageView(image: UIImage(named: NSString(format: "MBProgressHUD.bundle/\(icon)" as NSString) as String))
        //设置模式
        hud.mode = MBProgressHUDMode.customView
        
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        hud.contentColor = UIColor.white
        
        //隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        
        //消失时间
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    // MARK: - Public Class Method
    /// 显示成功信息,view需要设置
    class func show(success: String, toView: UIView = hudKeyWindow) {
        show(text: success, icon: "success.png", view: toView)
    }
    
    /// 显示错误信息，view需要设置
    class func show(error: String, toView: UIView = hudKeyWindow) {
        show(text: error, icon: "error.png", view: toView)
    }
    
    //    @discardableResult
    /// 展示一个view
    ///
    /// - Parameters:
    ///   - message: 信息文字
    ///   - toView: 需要承载的view，不传值为keywindow
    class func show(message: String, toView: UIView = hudKeyWindow) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.detailsLabel.text = message
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        hud.contentColor = UIColor.white
        
        hud.removeFromSuperViewOnHide = true
        
        return hud
    }
    
    /// 隐藏展示的view
    ///
    /// - Parameter toView: 需要承载的view，不传值为keywindow
    @objc class func hide(toView: UIView = hudKeyWindow) {
        MBProgressHUD.hide(for: toView, animated: true)
    }
    
    /// 只toast文字
    ///
    /// - Parameters:
    ///   - onlyText: 文字
    ///   - toView: 要展示的view，不传值为keywindow
    ///   - isUserEnable: 是否 允许用户交互，默认不允许
    ///   - hideTime: 展示多久后隐藏
    ///   - offsetY: 偏离屏幕中心的y值，默认为0，如果设置了屏幕高度，则仍然可见
    class func show(onlyText: String, toView: UIView = hudKeyWindow, isUserEnable: Bool = false, offsetY: CGFloat = 0) -> MBProgressHUD {
        
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = onlyText
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        hud.contentColor = UIColor.white
        
        hud.removeFromSuperViewOnHide = true
        /// 设置和苹果默认的是相反的
        hud.isUserInteractionEnabled = !isUserEnable
        hud.offset.y = offsetY
        
        return hud
    }
    
    @discardableResult
    /// 展示联网失败的view，背景色为灰白色
    class func showNetError(toView: UIView) -> MBProgressHUD {
        // 快速显示提示信息
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        //设置模式
        hud.mode = MBProgressHUDMode.customView
        //隐藏时候从父控件移除
        hud.removeFromSuperViewOnHide = true
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.backgroundColor = UIColor.clear
        hud.backgroundColor = UIColor(r: 237, g: 238, b: 239)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.textColor = UIColor(r: 155, g: 156, b: 157)
        hud.detailsLabel.text = "糟糕，什么都没有~"
        
        hud.customView = UIImageView(image: UIImage(named: "alert_message"))
        hud.customView?.tintColor = UIColor(r: 155, g: 156, b: 157)
        
        return hud
        
    }
    
    @discardableResult
    /// 展示首页联网失败、其他整个页面暂无数据的view，背景色为暗灰色
    ///
    /// - Parameters:
    ///   - onlyText: 提示的文字
    ///   - view: 放置的view
    ///   - isUserEnable: 遮盖是是否允许用户交互
    ///   - hideTime: 隐藏的时间
    class func showHomeVC(text: String, toView: UIView = hudKeyWindow, offsetY: CGFloat = 0) -> MBProgressHUD {
        // 快速显示提示信息
        let hud = MBProgressHUD.showAdded(to: toView, animated: false)
        //设置模式
        hud.mode = MBProgressHUDMode.customView
        //隐藏时候从父控件移除
        hud.removeFromSuperViewOnHide = true
        
        hud.offset.y = offsetY
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.color = UIColor.clear
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.textColor = UIColor(r: 35, g: 24, b: 21)
        hud.detailsLabel.text = text
        hud.customView = UIImageView(image: UIImage(named: "alert_message"))
        hud.customView?.tintColor = UIColor(r: 34, g: 23, b: 20)
        
        return hud
    }
    
}
