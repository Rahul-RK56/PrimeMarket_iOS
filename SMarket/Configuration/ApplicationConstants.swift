//
//  ApplicationConstants.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit


//MARK:-
//MARK:- Status

var isLogin = false

let CJsonResponse       = "response"
let CJsonMessage        = "message"
let CJsonStatus         = "status"
let CStatusCode         = "status_code"
let CJsonTitle          = "title"
let CJsonData           = "data"
let CJsonMeta           = "meta"

let CLimit              = 20

let CStatusZero         = 0
let CStatusOne          = 1
let CStatusTwo          = 2
let CStatusThree        = 3
let CStatusFour         = 4
let CStatusFive         = 5
let CStatusEight        = 8
let CStatusNine         = 9
let CStatusTen          = 10
let CStatusEleven       = 11

let CStatus200         = 200
let CStatus401         = 401

let CStatusTwoHundred   = NSNumber(value: 200 as Int)       //  Success
let CStatusFourHundredAndOne = NSNumber(value: 401 as Int)     //  Unauthorized user access
let CStatusFiveHundredAndFiftyFive = NSNumber(value: 555 as Int)   //  Invalid request
let CStatusFiveHundredAndFiftySix = NSNumber(value: 556 as Int)   //  Invalid request
let CStatusFiveHundredAndFifty = NSNumber(value: 550 as Int)        //  Inactive/Delete user
let CStatusFiveHunred   = NSNumber(value: 500 as Int)



//MARK:-
//MARK:- Fonts
public enum CFontType:Int {
    case Black
    case Bold
    case SemiBold
    case Italic
    case Light
    case Medium
    case Regular
    case Thin
}

func CFontPoppins(size: CGFloat, type: CFontType) -> UIFont {
    
    switch type {
        
    case .Bold:
        return UIFont.init(name: "Poppins-Bold", size: size)!
    case .SemiBold:
        return UIFont.init(name: "Poppins-SemiBold", size: size)!
    case .Light:
        return UIFont.init(name: "Poppins-Light", size: size)!
    case .Medium:
        return UIFont.init(name: "Poppins-Medium", size: size)!
    case .Black:
        return UIFont.init(name: "Roboto-Black", size: size)!
    case .Italic,.Thin,.Regular:
        return UIFont.init(name: "Poppins-Regular", size: size)!
    }
}

//MARK:-
//MARK:- Banner List Type

let CCustomerType         = "1"
let CMerchantType         = "2"


//MARK:-
//MARK:- UserDefaults Keys

let UserDefaultDeviceToken          = "UserDefaultDeviceToken"
let UserDefaultOneSignalPlayerId    = "UserDefaultOneSignalPlayerId"

let UserDefaultLoginUserToken       = "UserDefaultLoginUserToken"
let UserDefaultLoginUserID          = "UserDefaultLoginUserID"
let UserDefaultLoginMerchantID          = "UserDefaultLoginMerchantID"
let UserDefaultCustID         = "UserDefaultCustID "
let UserDefaultCategoryTimestamp    = "UserDefaultCategoryTimestamp"
let UserDefaultInstall              = "NewInstall"
let UserDefaultCountry              = "UserCountry"
let UserDefaultCountryCode          = "UserCountryCode"
let UserDefaultCancel               = "UserCancel"
let UserDefaultAppleID              = "UserDefaultAppleUserID"
let UserDefaultAppleName            = "UserDefaultAppleName"
let UserDefaultAppleEmail           = "UserDefaultAppleEmail"
let UserDefaultReferralCode         = "UserReferralCode"
let UserDefaultReferralMsg          = "UserReferralMsg"
let UserDefaultLoginUser          = "LoginUser"

let UserDefaultMerchantLoginEmail       = "UserDefaultMerchantLoginEmail"
let UserDefaultCustomerLoginMobile       = "UserDefaultCustomerLoginMobile"
let UserDefaultCustomerLoginPostalCode       = "UserDefaultCustomerLoginPostalCode"

let UserDefaultContactUs            = "UserDefaultContactUs"
let UserDefaultAboutus              = "UserDefaultAboutus"
let UserDefaultPrivacyPolicy        = "UserDefaultPrivacyPolicy"
let UserDefaultHowToUseApp          = "UserDefaultHowToUseApp"
let UserDefaultCreateOfferInstruction         = "UserDefaultCreateOfferInstruction"
let UserDefaultTermsConditionandPrivacyPolicy = "UserDefaultTermsConditionandPrivacyPolicy"

let UserDefaultHOWTOCREATEOFFER     = "UserDefaultHOWTOCREATEOFFER"

let UserDefaultSmarkOffer           = "UserDefaultSmarkOffer"
let UserDefaultWelcomeBonus         = "UserDefaultWelcomeBonus"
let UserDefaultThankYouReward       = "UserDefaultThankYouReward"
let UserDefaultRateReview           = "UserDefaultRateReview"

//MARK:-
//MARK:- Color
let ColorBlack_000000           = CRGB(r: 0, g: 0, b: 0)
let ColorWhite_FFFFFF           = CRGB(r: 255, g: 255, b: 255)
//let ColorAppTheme               = CRGB(r: 64, g: 181, b: 241)
let colorGreen                  = CRGB(r: 58, g: 190, b: 114)
let colorPink                   = CRGB(r: 197, g: 0, b: 147)
let colorLightBule              = CRGB(r: 23, g: 192, b: 227)
let colorOrange                = CRGB(r: 243, g: 80, b: 37)
let textcolor                  = CRGB(r: 148, g: 166, b: 170)
let ColorRewards                 = CRGB(r: 30, g: 79, b: 96)
var ColorAppTheme : UIColor {
    get {
        if (appDelegate?.isCustomerLogin)! {
            return ColorCustomerAppTheme
        }
        return ColorMerchantAppTheme
    }
}

let ColorCustomerAppTheme       = CRGB(r: 69, g: 193, b: 228)
let ColorMerchantAppTheme       = CRGB(r: 174, g: 186, b: 37)
let ColorWhite_FFFAFA           = CRGB(r: 255, g: 250, b: 250)

let ColorWhite_FDE5E2           = CRGB(r: 253, g: 229, b: 227)
let ColorWhite_FEEDEC           = CRGB(r: 254, g: 237, b: 236)
let ColorWhite_FEF0F5           = CRGB(r: 254, g: 240, b: 245)
let ColorWhite_FEEFF0           = CRGB(r: 254, g: 239, b: 240)
let ColorButton_F50057          = CRGB(r: 254, g: 0, b: 87)
let ColorGray_A8A8A8            = CRGB(r: 168, g: 168, b: 168)
let ColorRedExpireDate          = CRGB(r: 247, g: 46, b: 48 )
let ColorYellowOfferlabel       = CRGB(r: 248, g: 183, b: 0 )
let ColorBonus                  = CRGB(r: 52, g: 150, b: 175)
let ColorReward                 = CRGB(r: 36, g: 112, b: 130)

let ColorGradient_Theme         = [ColorWhite_FDE5E2.cgColor,ColorWhite_FEEFF0.cgColor]


//.. Different Storyboard Instances.
let CMainCustomer_SB        = UIStoryboard(name: "MainCustomer", bundle:  nil)
let CMainMerchant_SB        = UIStoryboard(name: "MainMerchant", bundle:  nil)
let CLRF_SB                 = UIStoryboard(name: "LRF", bundle: nil)


//MARK:-
//MARK:- Notification Identifier
let RefreshSideMenuNotification       = "RefreshSideMenuNotification"

//MARK:-
//MARK:- Other

let currencyUnit                    = "$"
let currencyUnitRs                  = "₹"
let imageComprassRatio              = CGFloat(0.7)
let serverDateFormate               = "yyyy-MM-dd"
let displayDateFormate              = "dd MMM, yyyy"
let QRUNIQCODE                      = "SMARKET"


let CBtnOk                          = "Ok"
let CBtnCancel                      = "Cancel"
let CBtnYes                         = "Yes"
let CBtnNo                          = "No"
let CBtnClose                       = "Close"
let CBtnSkip                        = "Skip"
let CBtnOpenSettings                = "Open Settings"
let CBtnAdd                         = "Add"
let CBtnProceed                     = "Proceed"

public enum OfferCategory : Int {
    case GiftCard = 1
    case InStore = 2
    case StoreCredit = 3
}


public enum OfferType : Int {
     case Referral = 1
     case RateAndReview = 2
     case CuponOffer = 3
     case CashBack = 5
     
}
public enum SubOfferType : Int {
    case Referral = 1
    case Bonus = 2
    case Reward = 3
    case RateAndReview = 4
    case CashBack = 5
}

public enum OfferStatus : Int {
    case Pending = 1
    case Redeemed = 2
    case Expire = 3
}
public enum RedemptionStatus : Int {
    case Pending = 1
    case Accept = 2
    case Reject = 3
}

//MARK:-
//MARK:- Disable print for production.

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}


var allCountryCode : Array<Any> {
    
    get {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String : Any]] {
                    
                    return jsonResult
                }
            } catch {
                // handle error
            }
        }
        return []
    }
}

//    func getHtmlParsing(){
//        self.arrayProducts.removeAll()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.showLoader2()
//        }
//        APIRequest.shared().htmlParsing(product:shareURL) { (response, error) in
//            if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
//                self.hideloader()
//                for (_, value) in data{
//                    if value is Dictionary<AnyHashable,Any> {
//                        let dict = value as! [String : Any]
//                        var product = Product()
//                        product.title = dict["product_name"] as? String
//                        product.price = dict["product_price"] as? String
//                        product.imgURL = dict["product_image"] as? String
//                        product.site = self.getSite(url: (dict["product_url"] as? String)!)
//                        product.url = self.getSiteURL(url: ((dict["product_url"] as? String)!))
//                        self.arrayProducts.append(product)
//                    }
//                }
//                if self.arrayProducts.count == 0 {
//                    self.presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "Product is not available, please share available product.", btnOneTitle: "OK") { (acton) in
//                    }
//
//                }else{
//                    self.tableRefer.reloadData()
//                }
//            }
//        }
//    }
//

//var urlAmazon = "https://www.amazon.com/s?k="
//var urlAmazonIN = "https://www.amazon.in/s?k="
//var urlEbay = "https://www.ebay.com/sch/i.html?_from=R40&_trksid=m570.l1313&_nkw="
//var urlFlibkart = "https://www.flipkart.com/search?q="
//var urlWall = "https://www.walmart.com/search/?query="
//var urlBH = "https://www.bhphotovideo.com/c/search?Ntt="
//var urlNewEgg = "https://www.newegg.com/p/pl?d="
//var urlReliance = "https://www.reliancedigital.in/search?q="
//
//var amazonKey = ["s-image","a-offscreen","s-image"]
//var amazonComKey = ["s-image","a-offscreen","s-image"]
//var eBayKey = ["s-item__title","s-item__price","s-item__image-img"]
//var flipKey = ["_4rR01T","_30jeq3 _1_WHN1","_1Nyybr"]
//var wallKey = ["Tile-image","price-group","Tile-image"]//"product-title"
//var bhKey = ["title_ip0F69brFR7q991bIVYh1","container_14EdEmSSsYmuetz3imKuAI","image_1RwLvcJ70jHSVLOALM4UoW"]//"product-title"
//var newEggKey = ["item-title","price-current","item-img"]//"product-title"
//var relianceKey = ["sp grid"]
//
//var flipKeyDetail = ["B_NuCI","_30jeq3 _16Jk6d","_396cs4 _2amPTt _3qGmMb  _3exPp9"]
//var amazonKeyDetail = ["a-size-small a-color-secondary a-text-normal","a-color-base priceToPayPadding","a-image-wrapper a-lazy-loaded a-manually-loaded immersive-carousel-img-manual-load"]
//var amazonComKeyDetail = ["title","priceblock_ourprice","a-image-wrapper a-lazy-loaded a-manually-loaded immersive-carousel-img-manual-load"]
//var ebayKeyDetail = ["product-title","display-price","vi-image-gallery__image vi-image-gallery__image--absolute-center"]
//var wallKeyDetail = ["prod-ProductTitle prod-productTitle-buyBox font-bold","price-group","prod-ProductImage prod-LoadingCarousel-s"]
//var bhKeyDetail = ["title_1S1JLm7P93Ohi6H_hq7wWh","price_1DPoToKrLP8uWvruGqgtaY","image_2AnnrdYk1brbXAJDpSPf_y"]
//var newEggKeyDetail = ["product-title","price-current","product-view-img-original"]
//var bestBuyDetail = ["heading-5 v-fw-regular","priceView-hero-price priceView-customer-price","primary-image"]
