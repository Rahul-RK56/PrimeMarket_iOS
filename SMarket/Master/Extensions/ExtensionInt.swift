//
//  ExtensionInt.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation

// MARK: - Extension of Int For Converting it TO String.
extension Int {
    
    /// A Computed Property (only getter) of String For getting the String value from Int.
    var toString:String {
        return "\(self)"
    }
    
    var toDouble:Double {
        return Double(self)
    }
    
    var toFloat:Float {
        return Float(self)
    }
    
}
