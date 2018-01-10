//
//  UIAlertController+Extension.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// 快速展示 alertVC
    class func show(title: String? = nil, message: String?, preferredStyle: UIAlertControllerStyle = .alert, confirm: String? = "确定", confirmHandler: ((UIAlertAction) -> Void)? = nil, cancel: String? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if confirm != nil {
            alertVC.addAction(UIAlertAction(title: confirm, style: .default, handler: confirmHandler))
        }
        if cancel != nil {
            alertVC.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelHandler))
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        
    }
}
