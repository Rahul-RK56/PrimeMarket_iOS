//
//  ExtensionUIViewControllerGetCountryInfo.swift
//  SMarket
//
//  Created by Mac-00014 on 16/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    private static let getAllCountriesList:Array<Any> = {
        
            if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? [[String : Any]] {
                        
                        return jsonResult
                    }
                } catch {
                    // handle error
                }
            }
            return []
        
    }()
    
    static var getAllCountry:Any {
        return getAllCountriesList
    }
    
    func getAllCountries() -> Any?{
        
        return UIViewController.getAllCountry
    }
    
    func getAllCountriesPhoneCode() -> Array<Any> {
        
        let arrAllCountry = self.getAllCountries()
        
        var arrCountryCode = [Int]()
        if let tempArrCountryCode = arrAllCountry as? [[String : Any]]  {
            
            arrCountryCode = tempArrCountryCode.map({$0.valueForInt(key: "PhoneCode") ?? 0})
            
            if arrCountryCode.count > 0 {
             
                arrCountryCode = Array(Set(arrCountryCode))
                arrCountryCode = arrCountryCode.sorted()
        
                var stringArray = arrCountryCode.map( {
                    (number: Int) -> String in
                    return String("+\(number)")
                })
                
                stringArray.insert("+91", at: 1)
                
                return stringArray
            }
        }
        
        return []
    }
    
    func getAllCountriesCode() -> Array<Any> {
        
        let arrAllCountry = self.getAllCountries()
        
        var arrCountryCode = [[String : Any]]()
        if let tempArrCountryCode = arrAllCountry as? [[String : Any]]  {
            
            for (_, item) in tempArrCountryCode.enumerated() {
             
                let newItem = ["Code" : item.valueForString(key:"Code"),
                "Name":item.valueForString(key:"Name")] as [String : Any]
                arrCountryCode.append(newItem)
            }
            
            return arrCountryCode
        }
        
        return []
    }
}
