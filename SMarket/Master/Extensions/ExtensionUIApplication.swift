//
//  ExtensionUIApplication.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension of UIApplication For getting the TopMostViewController(UIViewController) of Application.
extension UIApplication {
    
    /// A Computed Property (only getter) of UIViewController For getting the TopMostViewController(UIViewController) of Application. For using this property you must have instance of UIApplication Like this:(UIApplication.shared).
    
    var topMostViewController:UIViewController? {
        
        var topViewController = self.keyWindow?.rootViewController
        
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        
        return topViewController
    }
    
}
