//
//  Merchant.swift
//
//  Created by Mac-00016 on 29/08/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class Merchant {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let name = "business_name"
        static let logo = "business_logo"
        static let tagLine = "tag_line"
        static let email = "email"
        static let loginId = "login_id"
        static let loginMail = "login_mail"
        static let countryCode = "country_code"
        static let mobile = "mobile"
        static let website = "website"
        static let address = "address"
        static let avgRating = "average_rating"
        static let noOfRating = "no_of_rating"
        static let description = "description"
        static let category = "category"
        static let distance = "distance"
        static let productAndServices = "product_and_services"
        static let longitude = "longitude"
        static let latitude = "latitude"
        static let referrals = "referrals"
        static let storeCredit = "store_credit"
        static let reward_count  = "reward_count"
        static let coupon_count  = "coupon_count"
        
        //coupon_count
        //reward_count
    }
    
    // MARK: Properties
    public var id: String?
    public var name: String?
    public var logo: String?
    public var tagLine: String?
    public var email: String?
    public var countryCode: String?
    public var mobile: String?
    public var website: String?
    public var address: String?
    public var description: String?
    public var avgRating: String?
    public var noOfRating: String?
    public var category: String?
    public var distance: String?
    public var productAndServices: String?
    public var longitude: String?
    public var latitude: String?
    public var referrals: String?
    public var storeCredit: String?
    public var coupon_count: String?
    public var reward_count: String?
    public var loginId: String?
    public var loginMail: String?
    
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
        description = json[SerializationKeys.description].string
        name = json[SerializationKeys.name].string
        category = json[SerializationKeys.category].string
        avgRating = json[SerializationKeys.avgRating].stringValue
        latitude = json[SerializationKeys.latitude].string
        countryCode = json[SerializationKeys.countryCode].string
        tagLine = json[SerializationKeys.tagLine].string
        id = json[SerializationKeys.id].stringValue
        distance = json[SerializationKeys.distance].stringValue
        productAndServices = json[SerializationKeys.productAndServices].stringValue
        referrals = json[SerializationKeys.referrals].stringValue
        storeCredit = json[SerializationKeys.storeCredit].stringValue
        longitude = json[SerializationKeys.longitude].string
        logo = json[SerializationKeys.logo].string
        noOfRating = json[SerializationKeys.noOfRating].stringValue
        coupon_count = json[SerializationKeys.coupon_count].stringValue
        reward_count = json[SerializationKeys.reward_count].stringValue
        loginId = json[SerializationKeys.loginId].stringValue
        loginMail = json[SerializationKeys.loginMail].stringValue
    }
    }
    

