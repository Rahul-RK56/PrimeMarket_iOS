//
//  ApplicationMessages.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation


let CMessageBlankCountryCode = "Please select Country Code."
let CMessageBlankMobileNo = "Mobile Number can’t be blank."
let CMessageBlankPassword = "Password can’t be blank."
let CMessageValidMobileNo = "Please enter valid Mobile Number."
let CMessageMobileNoOrEmail = "Please enter Email or Mobile Number."
let CMessageBlankName = "Name can’t be blank."
let CMessageValidName = "Please enter valid Name."
let CMessageValidEmail = "Please enter valid Email Address."
let CMessageBlankconfirmPassword = "Confirm password can’t be blank."
let CMessageValidPassword = "Password must be minimum 6 character alphanumeric."
let CMessagePasswordMismatch = "Password and Confirm Password doesn’t match. Try again."
let CMessageBlankLogo = "Please add your Business Logo."
let CMessageBlankBusinessName = "Business Name can’t be blank."
let CMessageValidBusinessName = "Business Name cannot be accepted as numeric or special Char only."
let CMessageBlankTagline = "Tagline can’t be blank."
let CMessageBlankEmail = "Email Address can’t be blank."
let CMessageBlankBusinessCategory = "Please select Business Category."
let CMessageBlankBusinessAddress = "Please add your Business Address."
let CMessageBlankProductServices = "Product & Services can’t be blank."
let CMessageBlankOTP = "OTP can’t be blank."
let CMessageOTPResend = "OTP has been sent successfully."
let CMessageBlankNewPassword = "New password can’t be blank."
let CMessageValidNewPassword = "New Password must be minimum 6 character alphanumeric."
let CMessageValidNewPasswordMismatch = "New Password and Confirm Password doesn’t match. Try again."
let CMessageBlankOldPassword = "Old password can’t be blank."
let CMessageLogout =  "Are you sure you want to logout?"

let CMessageBlankStoreCredit = "Enter valid store credit amount."
let CMessageBlankOffer = "Please select offer type."
let CMessageBlankTitle = "Title can’t be blank."
let CMessageBlankAmount = "Amount can’t be blank."
let CMessageBlankDescription = "Description can’t be blank."
let CMessageBlankCondition = "Offer Condition can’t be blank."
let CMessageBlankExpiryDate = "Please select expiry date."
let CMessageBlankBonusOffer = "Please select bonus offer type."
let CMessageBlankOffers = "Offer should have at least Referral, Bonus or Reward."
let CMessageMinimumAmount = "Amount must be large or equal to minimum amount."
let CMessageRedemptionRequestSent = "Your refcash redemption request has been sent to SMARKET."
let CMessagePdfSent = "Pdf sent successfully to your registerd email."
let CMessageOfferCreateSuccess = "Offer added successfully."
let CMessageRefCaseAmount = "Entered amount is more than the available balance."

let CMessageSkipReferral = "Are you sure you want to skip Referral?"
let CMessageSkipBonus = "Are you sure you want to skip Bonus?"
let CMessageSkipReward = "Are you sure you want to skip Reward?"

let CMessageBlankSelection = "Please select option."
let CMessageDeleteOffer =  "Are you sure you want to delete?"

let CMessageTopupAddMoney =  "You are on free introductory offer. Use SMARKET free of cost and help your business grow."

// Old message


let CMessageEmailNotVerified = "Email is not verified. Please verify your email."

let CMessageBlankProfilePicture = "Add your profile picture."
let CMessageBlankProductPicture = "Add your product picture."
let CMessageBlankRating = "Please add your rating."

let CMessageBlankDOB = "Select your DOB."

let CMessageReasonReport = "Please select reason of report."
let CMessageBlankReasonReport = "Please describe your reason to report"


let CMessageReportUser =  "Are you sure, you want to report this user."
let CMessageBlockUser =  "Are you sure, you want to block this user."
let CMessageUnBlockUser =  "Are you sure, you want to unblock this user."

let CMessageNoResultFound =  "Sorry, No results found"
let CMessageInProgress =  "No results found, share url & earn money."

let CMessageNoResultFoundWithRefresh = "Sorry we couldn't find any result here!\ntap anywhere to refresh the page."
let CMessageNoResultFoundExtra = "No promotions found."
let CMessageNoInternet = "An error has occured. Please check your network connection or try again."
let CMessageOtherError = "Something wrong here...\ntap anywhere to refresh the page."

let CMessageEmailVerification = "An email verification link has been sent on your registered email. Please verify your email."

let CMessageInValidQRCode = "Invalid QR Code Found. Please try another QR Code."

let CMessageNoResultAwaiting = "Please refer to redemption history for redeemed rewards"
let CMessageAddRefcashAlert = "Add refcash (to promote your business)"

let CMessageVisiblefriendsAlert = "Your recommendation will be visible to all your friends on SMARKET and will help them to make wise decision"

var CMessageHowToUseAppDetails :String {
    
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultCreateOfferInstruction)  as? [String : Any]{
            
            return dict.valueForString(key: "cms_desc").htmlToString
        }
        return ""
    }
}
var CMessageHowToUseAppTitle :String {
    get {
        return "HOW TO CREATE OFFER"
    }
}

var CMessageSmarkOfferDetails :String {
    
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultSmarkOffer)  as? [String : Any]{
            
            return dict.valueForString(key: "cms_desc").htmlToString
        }
        return ""
    }
}
var CMessageSmarkOfferTitle :String {
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultSmarkOffer)  as? [String : Any]{
            
            return dict.valueForString(key: "title").htmlToString
        }
        return ""
    }
}

var CMessageThankYouRewardDetails :String {
    
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultThankYouReward)  as? [String : Any]{
            
            return dict.valueForString(key: "cms_desc").htmlToString
        }
        return ""
    }
}
var CMessageThankYouRewardTitle :String {
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultThankYouReward)  as? [String : Any]{
            
            return dict.valueForString(key: "title").htmlToString
        }
        return ""
    }
}
var CMessageWelcomeBonusDetails :String {
    
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultWelcomeBonus)  as? [String : Any]{
            
            return dict.valueForString(key: "cms_desc").htmlToString
        }
        return ""
    }
}
var CMessageWelcomeBonusTitle :String {
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultWelcomeBonus)  as? [String : Any]{
            
            return dict.valueForString(key: "title").htmlToString
        }
        return ""
    }
}
var CMessageRateReviewDetails :String {
    
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultRateReview)  as? [String : Any]{
            
            return dict.valueForString(key: "cms_desc").htmlToString
        }
        return ""
    }
}
var CMessageRateReviewTitle :String {
    get {
        if let dict = CUserDefaults.value(forKey: UserDefaultRateReview)  as? [String : Any]{
            
            return dict.valueForString(key: "title").htmlToString
        }
        return ""
    }
}





