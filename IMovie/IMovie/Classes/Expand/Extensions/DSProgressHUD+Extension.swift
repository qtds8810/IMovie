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
    private init() {}
    
    static func showMessage(title: String? = nil, message: String?, offsetY: CGFloat = MBProgressMaxOffset, afterDelay: TimeInterval = 1) {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = title
        hud.detailsLabel.text = message
        hud.offset.y = offsetY
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
}
