//
//  SubOffer.swift
//  SMarket
//
//  Created by Mac-00016 on 10/08/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

public final class SubOffer {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        
        static let id = "id"
        static let parent_id = "parent_id"
        static let sub_offer_type = "sub_offer_type"
        static let sub_offer_category = "sub_offer_category"
        static let amount = "amount"
        static let title = "title"
        static let conditions = "conditions"
        static let is_redemption = "is_redemption"
    }
    
    // MARK: Properties
    
    public var id: String?
    public var parentId: String?
    public var subOfferType: SubOfferType?
    public var subOfferTitle: String?
    public var subOfferCategory: OfferCategory?
    public var amount: String?
    public var title: String?
    public var conditions: String?
    public var isRedemption: Bool = false
    public var image = UIImage()
    public var exclusiveImage = UIImage()
    public var categoryName : String?
     
    
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
        
        if json[SerializationKeys.parent_id].error != .notExist  {
            parentId = json[SerializationKeys.parent_id].stringValue
        }
        
        if json[SerializationKeys.id].error != .notExist  {
            id = json[SerializationKeys.id].stringValue
        }
        
        
        amount = json[SerializationKeys.amount].stringValue
        title = json[SerializationKeys.title].string
        conditions = json[SerializationKeys.conditions].stringValue
        isRedemption = json[SerializationKeys.is_redemption].boolValue
        subOfferType = SubOfferType(rawValue: json[SerializationKeys.sub_offer_type].intValue)
        subOfferCategory = OfferCategory(rawValue: json[SerializationKeys.sub_offer_category].intValue)

        switch subOfferType {
        case .Referral?:
            subOfferTitle = "SMARK Offer"
            
        case .Bonus?:
            subOfferTitle = "Welcome Bonus"

        case .Reward?:
            subOfferTitle = "Thank you Reward"
            
        case .RateAndReview?:
            subOfferTitle = ""
            
        default:
            break
        }
      
        switch subOfferCategory {
        case .GiftCard?:
            title = "Gift Card Worth \(currencyUnit)\(amount ?? "0")"
            image = #imageLiteral(resourceName: "gift_gray")
            categoryName = "Gift Card"
            
        case .InStore?:
            image = #imageLiteral(resourceName: "shop_gray")
            categoryName = "Exclusive Over the counter Offer"
            exclusiveImage = #imageLiteral(resourceName: "Bonus")
            
        case .StoreCredit?:
            title = "Store Credit Worth \(currencyUnit)\(amount ?? "0")"
            image = #imageLiteral(resourceName: "dollar_gray")
            categoryName = "Store Credit"
        default:
            break
        }
    }
}
