//
//  QRCodeData.swift
//  SMarket
//
//  Created by CIPL0874 on 30/12/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import Foundation

public final class QRCodeData{
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        
        static let qr_code = "qr_code"
        static let qr_img = "qr_img"
        
    }
    
    // MARK: Properties
    
    public var qr_code: String?
    public var qr_img: String?
   
    
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
        
        qr_code = json[SerializationKeys.qr_code].stringValue
        qr_img = json[SerializationKeys.qr_img].stringValue
      
    }
}
