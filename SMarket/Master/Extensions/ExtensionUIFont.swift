//
//  ExtensionUIFont.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func setUpAppropriateFont() -> UIFont? {
        
        if IS_iPhone_5 {
            return UIFont(name: self.fontName, size: self.pointSize - 2.0)
        }
        else if IS_iPhone_6_Plus {
            return UIFont(name: self.fontName, size: self.pointSize + 2.0)
        } else {
            return UIFont(name: self.fontName, size: self.pointSize)
        }
    }
}
