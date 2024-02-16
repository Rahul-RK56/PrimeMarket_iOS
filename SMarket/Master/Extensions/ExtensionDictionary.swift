//
//  ExtensionDictionary.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import  UIKit
// MARK: - Extension of Dictionary For getting the different types of values from it.
extension Dictionary {
    
    /// This method is used to get the string value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: return String value according to passed key.
    func valueForString(key:String) -> String {
        
        if let dictionary = self as? [String:Any] {
            
            return "\(dictionary[key] ?? "")"
            
        } else {
            return ""
        }
    }
    
    /// This method is used to get the Int value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: This Method returns Int? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    func valueForInt(key:String) -> Int? {
        return self.valueForString(key: key).toInt
    }
    
    func valueForDouble(key:String) -> Double? {
        return self.valueForString(key: key).toDouble
    }
    
    func valueForFloat(key:String) -> Float? {
        return self.valueForString(key: key).toFloat
    }
    
    /// This method is used to get the Any value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: This Method returns Any? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("Any!") then application will crash.
    func valueForJSON(key:String) -> Any? {
        
        if let dictionary = self as? [String:Any] {
            
            return dictionary[key] ?? nil
            
        } else {
            return nil
        }
    }
    
    func valueForBool(key:String) -> Bool {
        
        if let dictionary = self as? [String:Any] {
            
            switch dictionary[key] {
            case let string as String:
                if string == "1" || string.lowercased() == "true" {
                    return true
                }
            case let int as Int:
                if int > 0  {
                    return true
                }
            case let bool as Bool:
                return bool
            default:
                return false
            }
            
        }
        
        return false
    }
    
    func valueForImage(key:String) -> UIImage? {
        
        if let dictionary = self as? [String:Any] {
            if let image = dictionary[key] as? UIImage {
                return image
            }
        }
        
        return nil
        
    }
}



