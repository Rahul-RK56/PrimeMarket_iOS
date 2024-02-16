//
//  CheckCashback.swift
//  SMarket
//
//  Created by CIPL0419 on 26/08/22.
//  Copyright © 2022 Mind. All rights reserved.
//

import Foundation


public final class CheckCashbackDetails {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let message = "message"
        static let code_status = "code_status"
        static let code_amount = "code_amount"
        static let total_cashback = "total_cashback"
        static let redeemed_cashback = "redeemed_cashback"
        static let balance_cashback = "balance_cashback"
        static let offer_description = "offer_description"
        static let coupon_status = "coupon_status"
    }
    
    // MARK: Properties
    public var message: String?
    public var code_status: String?
    public var code_amount: Int?
    public var total_cashback: Int?
    public var redeemed_cashback: Int?
    public var balance_cashback: Int?
    public var offer_description: String?
    
    
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
        message = json[SerializationKeys.message].string
        code_status = json[SerializationKeys.code_status].string
        code_amount = json[SerializationKeys.code_amount].int
        total_cashback = json[SerializationKeys.total_cashback].int
        redeemed_cashback = json[SerializationKeys.redeemed_cashback].int
        balance_cashback = json[SerializationKeys.balance_cashback].int        
    }
}
