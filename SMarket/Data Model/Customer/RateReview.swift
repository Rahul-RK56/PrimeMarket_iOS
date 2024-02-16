//
//  RateReview.swift
//
//  Created by Mac-00012 on 26/11/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class RateReview {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let profilePic = "profile_pic"
    static let review = "review"
    static let name = "name"
    static let id = "id"
    static let mobile = "mobile"
    static let image = "image"
    static let countryCode = "country_code"
    static let rating = "rating"
    static let userId = "user_id"
    static let merchantId = "merchant_id"
    static let rateOn = "rate_on"
  }

  // MARK: Properties
  public var profilePic: String?
  public var review: String?
  public var name: String?
  public var id: Int?
  public var mobile: String?
  public var image: String?
  public var countryCode: String?
  public var rateOn: String?
  public var rating: Float?
  public var userId: Int?
  public var merchantId: Int?

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
    profilePic = json[SerializationKeys.profilePic].string
    review = json[SerializationKeys.review].string
    name = json[SerializationKeys.name].string
    id = json[SerializationKeys.id].int
    mobile = json[SerializationKeys.mobile].stringValue
    image = json[SerializationKeys.image].string
    countryCode = json[SerializationKeys.countryCode].string
    rating = json[SerializationKeys.rating].floatValue
    userId = json[SerializationKeys.userId].int
    merchantId = json[SerializationKeys.merchantId].int
    rateOn = json[SerializationKeys.rateOn].stringValue
    
    rateOn = "Rated on: \(rateOn?.dateFromString ?? "-")"
    mobile = "\(countryCode ?? "") \(mobile ?? "")"
    
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = profilePic { dictionary[SerializationKeys.profilePic] = value }
    if let value = review { dictionary[SerializationKeys.review] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = mobile { dictionary[SerializationKeys.mobile] = value }
    if let value = rateOn { dictionary[SerializationKeys.rateOn] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = merchantId { dictionary[SerializationKeys.merchantId] = value }
    return dictionary
  }

}
