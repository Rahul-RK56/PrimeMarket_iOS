//
//  ExtensionArray.swift
//  SMarket
//
//  Created by Mac-00016 on 12/09/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation

extension Array where Element: Comparable{
    
    var toString: String? {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            
            return String(data: data, encoding: .utf8)
            
        } catch {
            
            return nil
        }
    }
    
    var indexOfMax: Index? {
          guard var maxValue = self.first else { return nil }
          var maxIndex = 0

          for (index, value) in self.enumerated() {
             if value > maxValue {
                maxValue = value
                maxIndex = index
             }
         }

         return maxIndex
       }
}
