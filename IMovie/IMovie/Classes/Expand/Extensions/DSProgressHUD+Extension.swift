//
//  DSProgressHUD+Extension.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import MBProgressHUD

enum DSHUDType {
    case success(message: String?)
    case error(message: String?)
    /// UIActivityIndicatorView
    case loading(message: String?)
    case info(icon: UIImage?, message: String?)
    /// Shows only labels.
    case onlyText(message: String?, isAutoHide: Bool)
}

class DSProgressHUD {
    static let hudKeyWindow = UIApplication.shared.keyWindow!
    
    private init() {}
    
    private class func show(_ mode: MBProgressHUDMode, message: String?, icon: UIImage?, view: UIView, isUserEnable: Bool = false, isAutoHide: Bool = true) {
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.bezelView.style = MBProgressHUDBackgroundStyle.blur
        hud.bezelView.backgroundColor = UIColor.black
        
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        hud.detailsLabel.text = message
        
        //设置模式
        hud.mode = mode
        switch mode {
        case .customView:
            //设置图片
            hud.customView = UIImageView(image: icon)//UIImageView(image: UIImage(named: "MBProgressHUD.bundle/\(icon)"))
            //消失时间
            hud.hide(animated: true, afterDelay: 1.5)
            
//        case .determinate, .determinate:
            
        case .text:
            /// 设置和苹果默认的是相反的
            hud.isUserInteractionEnabled = !isUserEnable
            
        default:
            break
        }
        
        
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        hud.contentColor = UIColor.white
        
        //隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        
        //消失时间
        if isAutoHide {
            hud.hide(animated: true, afterDelay: 1.5)
        }
        
    }
    
    class func hide(view: UIView = hudKeyWindow) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    class func show(_ type: DSHUDType, to view: UIView = hudKeyWindow) {
        // "MBProgressHUD.bundle/success.png"
        switch type {
        case .success(let message):
            show(.customView, message: message, icon: UIImage.init(named: "hud_success.png"), view: view)
        case .error(let message):
            show(.customView, message: message, icon: UIImage.init(named: "hud_error.png"), view: view)
        case .loading(let message):
            show(.indeterminate, message: message, icon: nil, view: view, isAutoHide: false)
        case .info(let icon, let message):
            show(.customView, message: message, icon: icon, view: view)
        case .onlyText(let message, let isAutoHide):
            show(.text, message: message, icon: nil, view: view, isUserEnable: true, isAutoHide: isAutoHide)
            
        }
    }
    
}
