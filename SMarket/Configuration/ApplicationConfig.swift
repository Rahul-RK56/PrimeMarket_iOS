//
//  ApplicationConfig.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation

//# Gmail Account -> smarket.simtot@gmail.com
var GooglePlaceAPIKey            =  "AIzaSyCbrnAh77p5wW4Ae8D5azfMSgv4i1qc2TE"

//# local & Live url
var APIBASEURL:String        =   "https://smarketdeals.com/api/v1/" // Live
//var APIBASEURL:String        =   "https://smarketdeals.com/api/v1/" // Live
//var APIBASEURL:String        =   "https://smarketworld.colanapps.in/api/v1/" // Live
//var APIBASEURL:String        =   "http://18.219.0.157/api/v1/" // Live AWS
//var APIBASEURL:String        =   "http://192.168.1.20/SMarket/api/v1/" // local BHAVESH PATEL
//var APIBASEURL:String        =   "https://itrainacademy.in/SMarket/api/v1/" // itrainacademy.in


//# Stripe Account -> smarket.simtot@gmail.com
//var stripePublishableKey:String = "pk_test_ES1coDryWf1QL2VmCiOWKUtI" // Dev
var stripePublishableKey:String = "pk_live_OlowoLDnCFJQ6TGIAP8B64wc" // Live

//# App Link
var CAppStoreAppLink = "https://itunes.apple.com/us/app/SMARKET - The Social MARKET/id1450384980?ls=1&mt=8"

public func isDeviceJailbroken() -> Bool {
     #if arch(i386) || arch(x86_64)
         return false
     #else
         let fileManager = FileManager.default

         if (fileManager.fileExists(atPath: "/bin/bash") ||
             fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
             fileManager.fileExists(atPath: "/etc/apt")) ||
             fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
             fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
             fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
             return true
         } else {
             return false
         }
     #endif
 }
