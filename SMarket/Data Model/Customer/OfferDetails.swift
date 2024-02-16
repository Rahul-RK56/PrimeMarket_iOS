//
//  OfferDetails.swift
//
//  Created by Mac-00016 on 31/08/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class OfferDetails {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let expiresDate = "expires_date"
        static let qrCode = "qr_code"
        static let businessName = "business_name"
        static let sub_offer_category = "sub_offer_category"
        static let merchantId = "merchant_id"
        static let averageRating = "average_rating"
        static let referredDate = "referred_date"
        static let status = "status"
        static let id = "id"
        static let tagLine = "tag_line"
        static let code = "code"
        static let distance = "distance"
        static let storeCredit = "store_credit"
        static let noOfRating = "no_of_rating"
        static let businessLogo = "business_logo"
        static let offers = "offer"
        static let redeemedDate = "redeemed_date"
    }
    
    // MARK: Properties
    public var merchantId: String?
    public var name: String?
    public var tagLine: String?
    public var avgRating: String?
    public var logo: String?
    public var distance: String?
    public var storeCredit: String?
    public var noOfRating: String?
    
    public var id: String?
    public var subOfferCategory: OfferCategory?
    public var qrCodeImage: String?
    public var code: String?
    public var referredDate: String?
    public var redeemedDate : String?
    public var offers: Offer?
    public var status = OfferStatus.Pending
    
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
        qrCodeImage = json[SerializationKeys.qrCode].string
        name = json[SerializationKeys.businessName].string
        merchantId = json[SerializationKeys.merchantId].stringValue
        avgRating = json[SerializationKeys.averageRating].stringValue
        referredDate = json[SerializationKeys.referredDate].string
        id = json[SerializationKeys.id].stringValue
        tagLine = json[SerializationKeys.tagLine].string
        code = json[SerializationKeys.code].string
        distance = json[SerializationKeys.distance].stringValue
        redeemedDate = json[SerializationKeys.redeemedDate].stringValue
        storeCredit = json[SerializationKeys.storeCredit].stringValue
        noOfRating = json[SerializationKeys.noOfRating].stringValue
        logo = json[SerializationKeys.businessLogo].string
        subOfferCategory = OfferCategory(rawValue: json[SerializationKeys.sub_offer_category].intValue)
        
        if  json[SerializationKeys.offers].error != .notExist {
            offers = Offer(object:json[SerializationKeys.offers].object)
        }
        
        let status = json[SerializationKeys.status].intValue        
        if status > 0 && status < 4 {
            self.status = OfferStatus(rawValue:status)!
        }
    }
}
