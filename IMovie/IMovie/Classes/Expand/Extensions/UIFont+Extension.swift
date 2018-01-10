//
//  UIFont+Extension.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

extension UIFont {
    class func ds_fontSizeOfpx(_ pxSize: CGFloat) -> UIFont {
        /**
         let pt = (pxSize/96)*72
         let font = systemFontOfSize(pt)
         */
        
        let pt = (pxSize * 0.5)
        let font = systemFont(ofSize: pt)
        
        return font
    }
    
    class func ds_fontSizeOfMine(_ size: CGFloat) -> UIFont {
        /**
         iPhone 4s: 320*480
         iPhone 5: 320.0-------------568.0
         iPhone 6s: 375.0-------------667.0
         iPhone 6sp：414.0-------------736.0
         */
        
        if UIScreen.main.bounds.width <= 320 {
            return systemFont(ofSize: size - 1)
        } else if UIScreen.main.bounds.width >= 414 {
            return systemFont(ofSize: size + 1)
        } else {
            return systemFont(ofSize: size)
        }
        
    }
}
