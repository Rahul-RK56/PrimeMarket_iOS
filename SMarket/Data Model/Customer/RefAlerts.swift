//
//  RefAlerts.swift
//  SMarket
//
//  Created by Mac-00016 on 10/09/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation

public final class RefAlert {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        
        static let id = "id"
        static let user_id = "user_id"
        static let profile_pic = "profile_pic"
        static let name = "name"
        static let country_code = "country_code"
        static let mobile = "mobile"
        static let rating = "rating"
        static let review = "review"
        static let product_image = "image"
        static let offer_type = "offer_type"
        static let referred_date = "referred_date"
        static let referral_status = "referral_status"
        static let qr_code_image = "qr_code"
        static let code = "code"
        static let merchant_id = "merchant_id"
        
    }
    
    // MARK: Properties
    public var id: String?
    public var user_id: String?
    public var profile_pic: String?
    public var name: String?
    public var country_code: String?
    public var mobile: String?
    public var rating: String?
    public var review: String?
    public var product_image: String?
    public var offerType: OfferType?
    public var referred_date: String?
    public var referral_status : RedemptionStatus?
    public var qr_code_image: String?
    public var code: String?
    public var merchant_id: String?
    
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
        id = json[SerializationKeys.id].stringValue
        user_id = json[SerializationKeys.user_id].stringValue
        profile_pic = json[SerializationKeys.profile_pic].string
        name = json[SerializationKeys.name].string
        country_code = json[SerializationKeys.country_code].stringValue
        mobile = json[SerializationKeys.mobile].stringValue
        rating = json[SerializationKeys.rating].stringValue
        code = json[SerializationKeys.code].string
        review = json[SerializationKeys.review].stringValue
        product_image = json[SerializationKeys.product_image].string
        referred_date = json[SerializationKeys.referred_date].stringValue
        merchant_id = json[SerializationKeys.merchant_id].stringValue

        qr_code_image = json[SerializationKeys.qr_code_image].string
        code = json[SerializationKeys.code].stringValue
        referral_status = RedemptionStatus(rawValue: json[SerializationKeys.referral_status].int!)
    }
}
