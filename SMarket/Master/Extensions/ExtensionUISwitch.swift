//
//  ExtensionUISwitch.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import UIKit

typealias genericSwitchToggleHandler<T> = ((T) -> ())

// MARK: - Extension of UISwitch For ToggleHandler.
extension UISwitch {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        static var genericSwitchToggleHandler = "genericSwitchToggleHandler"
    }
    
    /// This method is used for UISwitch's ToggleHandler
    ///
    /// - Parameter ToggleHandler: ToggleHandler will give you object of UISwitch.
    func valueChangeEvent(genericSwitchToggleHandler:
        @escaping genericSwitchToggleHandler<UISwitch>) {
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.genericSwitchToggleHandler, genericSwitchToggleHandler, .OBJC_ASSOCIATION_RETAIN)
        
        self.addTarget(self, action: #selector(handleToggleEvent(sender:)), for: .valueChanged)
    }
    
    /// This Private method is used for handle the Toggle event of UISwitch.
    ///
    /// - Parameter sender: UISwitch.
    @objc private func handleToggleEvent(sender:UISwitch) {
        
        if let genericSwitchToggleHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.genericSwitchToggleHandler) as?  genericSwitchToggleHandler<UISwitch> {
            
            genericSwitchToggleHandler(sender)
        }
    }
    
}

