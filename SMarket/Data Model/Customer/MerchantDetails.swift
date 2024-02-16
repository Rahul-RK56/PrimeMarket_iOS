//
//  MerchantDetails.swift
//
//  Created by Mac-00016 on 28/08/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class MerchantDetails {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let email = "email"
        static let mobile = "mobile"
        static let website = "website"
        static let address = "address"
        static let descriptionValue = "description"
        static let businessName = "business_name"
        static let category = "category"
        static let averageRating = "average_rating"
        static let id = "id"
        static let tagLine = "tag_line"
        static let referralmessage = "referral_message"
        static let countryCode = "country_code"
        static let referrals = "referrals"
        static let productAndServices = "product_and_services"
        static let storeCredit = "store_credit"
        static let noOfRating = "no_of_rating"
        static let businessLogo = "business_logo"
        static let offers = "offer"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let show_referral_alerts = "show_referral_alerts"
        static let show_unclaimed_offers = "show_unclaimed_offers"
        static let referral_sms = "referral_sms"
        static let show_rate_merchant = "show_rate_merchant"
        static let show_refer_merchant = "show_refer_merchant"
        static let referralcode = "referral_code"
        static let cashback = "cashback"
    }
    
    // MARK: Properties
    
    public var id: String?
    public var name: String?
    public var logo: String?
    public var referral_sms = false
    public var tagLine: String?
    public var referralmessage: String?
    public var email: String?
    public var countryCode: String?
    public var mobile: String?
    public var website: String?
    public var address: String?
    public var description: String?
    public var avgRating: String?
    public var noOfRating: String?
    public var referralCode:String?
    public var category: String?
    public var distance: String?
    public var productAndServices: String?
    public var longitude: String?
    public var latitude: String?
    public var referrals: String?
    public var storeCredit: String?
    public var show_referral_alerts = false
    public var show_unclaimed_offers = false
    public var show_rate_merchant = false
    public var show_refer_merchant = true
    public var offers: [Offer]?
    public var cashback : Cashback?
    
    
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
        
        email = json[SerializationKeys.email].string
        mobile = json[SerializationKeys.mobile].string
        website = json[SerializationKeys.website].string
        address = json[SerializationKeys.address].string
        description = json[SerializationKeys.descriptionValue].string
        name = json[SerializationKeys.businessName].string
        category = json[SerializationKeys.category].string
        avgRating = json[SerializationKeys.averageRating].stringValue
        id = json[SerializationKeys.id].stringValue
        tagLine = json[SerializationKeys.tagLine].string
        referralmessage = json[SerializationKeys.referralmessage].string
        countryCode = json[SerializationKeys.countryCode].string
        referrals = json[SerializationKeys.referrals].stringValue
        productAndServices = json[SerializationKeys.productAndServices].string
        storeCredit = json[SerializationKeys.storeCredit].stringValue
        noOfRating = json[SerializationKeys.noOfRating].stringValue
        logo = json[SerializationKeys.businessLogo].string
        referralCode = json[SerializationKeys.referralcode].string
        latitude = json[SerializationKeys.latitude].stringValue
        longitude = json[SerializationKeys.longitude].stringValue
        show_referral_alerts = json[SerializationKeys.show_referral_alerts].boolValue
        show_unclaimed_offers = json[SerializationKeys.show_unclaimed_offers].boolValue
        referral_sms = json[SerializationKeys.referral_sms].boolValue
        show_rate_merchant = json[SerializationKeys.show_rate_merchant].boolValue
        show_refer_merchant =  true  //json[SerializationKeys.show_refer_merchant].boolValue
        cashback = Cashback(object:json[SerializationKeys.cashback].object)
        
        
                
        if let arrObject = json[SerializationKeys.offers].arrayObject, arrObject.count > 0  {
            offers = []
            for item in arrObject {
                let offer = Offer(object: item)
                offers?.append(offer)
            }
        }
        
        

    }
}
