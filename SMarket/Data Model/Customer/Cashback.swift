//
//  Cashback.swift
//  SMarket
//
//  Created by Mohammed Khubaib on 11/01/22.
//  Copyright © 2022 Mind. All rights reserved.
//

import Foundation

public final class Cashback {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
       
        static let id = "id"
        static let offerpercentage = "offer_percentage"
        static let offercondition = "offer_condition"
        static let status = "status"
        
       
    }
    
    // MARK: Properties
    
    public var id: Int?
    public var offerpercentage: Int?
    public var offercondition: String?
    public var status: Int?
    
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        self.updateJSON(json: json)
    }
    
    
    func updateValues(object: Any) {
        self.updateJSON(json: JSON(object))
    }
    
    private func updateJSON(json: JSON) {
        
        id = json[SerializationKeys.id].intValue
        offerpercentage = json[SerializationKeys.offerpercentage].intValue
        offercondition = json[SerializationKeys.offercondition].stringValue
        status = json[SerializationKeys.status].intValue
        
        
        if json[SerializationKeys.id].error != .notExist  {
            id  = json[SerializationKeys.id].intValue
        }
        
        if json[SerializationKeys.offerpercentage].error != .notExist  {
            offerpercentage  = json[SerializationKeys.offerpercentage].intValue
        }
        
        if json[SerializationKeys.offercondition].error != .notExist  {
            offercondition  = json[SerializationKeys.offercondition].stringValue
        }

        if json[SerializationKeys.status].error != .notExist  {
            status  = json[SerializationKeys.status].intValue
        }
    }
}

