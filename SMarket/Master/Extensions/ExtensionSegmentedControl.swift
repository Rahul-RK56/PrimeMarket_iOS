//
//  ExtensionSegmentedControl.swift
//  SMarket
//
//  Created by Mac-00014 on 05/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont , color: UIColor ) {
        let defaultAttributes = [
            NSAttributedStringKey.font.rawValue: font,
            NSAttributedStringKey.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont, color: UIColor) {
        let selectedAttributes = [
            NSAttributedStringKey.font.rawValue: font,
            NSAttributedStringKey.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
