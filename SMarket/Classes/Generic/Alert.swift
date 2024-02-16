//
//  Alert.swift
//  SMarket
//
//  Created by CIPL0874 on 27/04/22.
//  Copyright © 2022 Mind. All rights reserved.
//

import Foundation
import UIKit
struct Alert {
    static let internetAlertMessage = "Please check your internet connection and try again"
    static let internetAlertTitle = "Internet Failure"
    private static func showAlert(on vc:UIViewController,with title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
