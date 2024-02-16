//
//  Offer.swift
//  SMarket
//
//  Created by Mac-00016 on 10/08/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation

public final class Offer {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
       
        static let offer_type = "offer_type"
        static let expiry_date = "expiry_date"
        static let email = "email"
        static let sub_offer = "sub_offer"
        static let message = "message"
        static let id = "id"
        static let memberID = "id"
        static let referral_count = "referral_count"
        static let offer_percentage = "offer_percentage"
        static let offer_condition = "offer_condition"
        static let merchant_id = "merchant_id"
       
    }
    
    // MARK: Properties
    public var offerType: OfferType?
    public var offerTitle: String?
    public var expiryDate: String?
    public var message: String?
    public var subOffer: [SubOffer]?
    public var id: String?
    public var memberID: String?
    public var memberid: String?
    public var email: String?
    public var referral_count: String?
    public var offer_percentage : Int?
    public var offer_condition : String?
    public var merchant_id : Int?
    
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
        
        offerType = OfferType(rawValue: json[SerializationKeys.offer_type].intValue)
        expiryDate = json[SerializationKeys.expiry_date].stringValue
        message = json[SerializationKeys.message].stringValue
        email = json[SerializationKeys.email].stringValue
        referral_count = json[SerializationKeys.referral_count].stringValue
        offer_condition = json[SerializationKeys.offer_condition].stringValue
        merchant_id = json[SerializationKeys.merchant_id].intValue
        offer_percentage = json[SerializationKeys.offer_percentage].intValue
        
        if json[SerializationKeys.id].error != .notExist  {
            id  = json[SerializationKeys.id].stringValue
        }
        
        if json[SerializationKeys.memberID].error != .notExist  {
            memberID  = json[SerializationKeys.memberID].stringValue
        }
        
        offerTitle = offerType == .Referral ? "Referral Offer" : "Rate & Review"
        
       
        if let arrObject = json[SerializationKeys.sub_offer].arrayObject, arrObject.count > 0  {
            subOffer = []
            for item in arrObject {
                let sub_Offer = SubOffer(object: item)
                subOffer?.append(sub_Offer)
            }
        }
    }
}





public final class CashOffer {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
       
      
        static let id = "id"
        static let status = "status"
        static let offer_percentage = "offer_percentage"
        static let offer_condition = "offer_condition"
        static let merchant_id = "merchant_id"
       
    }
    
 
    public var id: Int?
    public var merchant_id: Int?
    public var status: Int?
    public var offer_percentage : Int?
    public var offer_condition : String?
  
    
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
        status = json[SerializationKeys.status].intValue
        offer_condition = json[SerializationKeys.offer_condition].stringValue
        merchant_id = json[SerializationKeys.merchant_id].intValue
        offer_percentage = json[SerializationKeys.offer_percentage].intValue
        
      }
}
