//
//  ExtensionURL.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation

// MARK: - Extension of URL For Converting it TO String.
extension URL {
    
    /// A Computed Property (only getter) of URL For getting the String value from URL.
    /// This Computed Property (only getter) returns String? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("String!") then application will crash.
    var toString:String? {
        return self.absoluteString
    }
}

// MARK: - Extension of URL For queryItems in Dictinory.
extension URL {
    var params: [String: String]? {
        if let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            if let queryItems = urlComponents.queryItems {
                var params = [String: String]()
                queryItems.forEach{
                    params[$0.name] = $0.value
                }
                return params
            }
        }
        return nil
    }
}
