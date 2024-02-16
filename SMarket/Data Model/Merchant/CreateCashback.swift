//
//  CreateCashback.swift
//  SMarket
//
//  Created by Mohammed Khubaib on 21/12/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import Foundation


struct CreateCashback: Codable {
    let status: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id, merchantID, offerPercentage: Int
    let offerCondition, status: String
    let deletedAt: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case offerPercentage = "offer_percentage"
        case offerCondition = "offer_condition"
        case status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
