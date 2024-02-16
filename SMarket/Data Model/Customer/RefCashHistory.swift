//
//  RefCashHistory.swift
//  SMarket
//
//  Created by Mac-00016 on 13/08/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation

public final class RefCashHistory {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        
        static let amount = "amount"
        static let id = "id"
        static let business_name = "business_name"
        static let name = "name"
        static let tag_line = "tag_line"
        static let business_logo = "business_logo"
        static let transaction_time = "transaction_time"
        static let status = "status"
        static let offer_type = "offer_type"
        
    }
    
    // MARK: Properties
    
    public var id: String?
    public var amount: String?
    public var business_name: String?
    public var name: String?
    public var tag_line: String?
    public var business_logo: String?
    public var time: String?
    public var status: Int?
    public var offerType: OfferType?
    
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
        
        id = json[SerializationKeys.id].stringValue
        amount = json[SerializationKeys.amount].stringValue
        business_name = json[SerializationKeys.business_name].string
        name = json[SerializationKeys.name].string
        tag_line = json[SerializationKeys.tag_line].string
        business_logo = json[SerializationKeys.business_logo].string
        time = json[SerializationKeys.transaction_time].stringValue
        status = json[SerializationKeys.status].intValue
        offerType = OfferType(rawValue: json[SerializationKeys.offer_type].intValue)
    }
}
