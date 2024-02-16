//
//  OfferList.swift
//  SMarket
//
//  Created by Mac-00014 on 06/09/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

public final class OfferList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        
        static let id = "id"
        static let merchant_id = "merchant_id"
        static let business_logo = "business_logo"
        static let distance = "distance"
        static let business_name = "business_name"
        static let tag_line = "tag_line"
        static let average_rating = "average_rating"
        static let no_of_rating = "no_of_rating"
        static let amount = "amount"
        static let sub_offer_category_id = "sub_offer_category_id"
        static let expiry_date = "expiry_date"
        static let redeemed_date = "redeemed_date"
        static let title = "title"
        static let status = "status"
        static let purchased_by = "purchased_by"
        static let referrals = "referrals"
        static let storeCredit = "store_credit"
        static let conditions = "conditions"
        static let sub_offer_type = "sub_offer_type"
        static let offer_id = "offer_id"
    }
    
    // MARK: Properties
    
    public var id: Int?
    public var merchant_id: Int?
    public var logo: String?
    public var distance: String?
    public var name: String?
    public var tagLine: String?
    public var avgRating: Float?
    public var noOfRating: String?
    public var amount: String?
    public var subOfferCategory: OfferCategory?
    public var expiryDate: String?
    public var redeemedDate: String?
    public var image = UIImage()
    public var title: String?
    public var purchasedBy: String?
    public var categoryName : String?
    public var exclusiveImage = UIImage()
    public var referrals: String?
    public var storeCredit: String?
    public var conditions: String?
    public var subOfferType: SubOfferType?
    public var subOfferTitle: String?
    public var status = OfferStatus.Pending
    public var offer_id: String?
    
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
        
        id = json[SerializationKeys.id].int
        merchant_id = json[SerializationKeys.merchant_id].int
        logo = json[SerializationKeys.business_logo].stringValue
        distance = json[SerializationKeys.distance].stringValue
        name = json[SerializationKeys.business_name].stringValue
        tagLine = json[SerializationKeys.tag_line].stringValue
        avgRating = json[SerializationKeys.average_rating].floatValue
        noOfRating = json[SerializationKeys.no_of_rating].stringValue
        amount = json[SerializationKeys.amount].stringValue
        expiryDate = json[SerializationKeys.expiry_date].stringValue
        redeemedDate = json[SerializationKeys.redeemed_date].stringValue
        subOfferCategory = OfferCategory(rawValue: json[SerializationKeys.sub_offer_category_id].intValue)
        title = json[SerializationKeys.title].string
        referrals = json[SerializationKeys.referrals].stringValue
        conditions = json[SerializationKeys.conditions].string
        storeCredit = json[SerializationKeys.storeCredit].stringValue
        offer_id = json[SerializationKeys.offer_id].stringValue
        subOfferType = SubOfferType(rawValue: json[SerializationKeys.sub_offer_type].intValue)
        
        switch subOfferType {
        case .Referral?:
            subOfferTitle = "Referral"
            
        case .Bonus?:
            subOfferTitle = "Bonus"
            
        case .Reward?:
            subOfferTitle = "Reward"
            
        case .RateAndReview?:
            subOfferTitle = "Rate&Review"
            
        default:
            break
        }
        
        if let purchaseBy = json[SerializationKeys.purchased_by].string, purchaseBy != "" {
            
            if purchaseBy == "No Bonus" {
                purchasedBy = "no bonus*"
            } else {
                purchasedBy = "for the purchase by \(purchaseBy)"
            }
        } else {
            purchasedBy = "welcome bonus*"
        }
    
        switch subOfferCategory {
        case .GiftCard?:
            title = "Gift Card Worth \(currencyUnit)\(amount ?? "0")"
            image = #imageLiteral(resourceName: "gift_gray")
            categoryName = "Gift Card"
            exclusiveImage = #imageLiteral(resourceName: "round")
            
        case .InStore?:
            image = #imageLiteral(resourceName: "shop_gray")
            categoryName = "Exclusive Over the counter Offer"
            exclusiveImage = #imageLiteral(resourceName: "Bonus")
            
        case .StoreCredit?:
            title = "Store Credit Worth \(currencyUnit)\(amount ?? "0")"
            image = #imageLiteral(resourceName: "dollar_gray")
            categoryName = "Store Credit"
            exclusiveImage = #imageLiteral(resourceName: "round")
            
        default:
            title = ""
            amount = ""
        }
        
        let status = json[SerializationKeys.status].intValue
        if status > 0 && status < 4 {
            self.status = OfferStatus(rawValue:status)!
        }
    }
}
