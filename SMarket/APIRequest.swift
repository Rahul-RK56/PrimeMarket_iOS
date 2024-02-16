//
//  APIRequest.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


//MARK:-
//MARK:- API TAG

let CAPITagcurrency                    = "currency"
let CAPITagDocumentType                = "document-type"
let CAPITagCheckUserNameEmail          = "check-username-email"
let CAPITagUserInfo                    = "user-detail"

//MARK:-
//MARK:- API TAG Merchant

let CAPITagCMS                         = "cms"
let CAPITagFAQ                         = "faq"
let CAPITagBanner                      = "banner"
let CAPITagCategory                    = "category"
let CAPITagSocialLogin                 = "social-login"
let CAPITagSocialNormal                = "merchant-login"
let CAPITagSocialNormalEmail           = "login-mail-otp"
let CAPITagEmailVarify                 = "merchant-verified"
let CAPITagEmailLoginVarify              = "login-verify-otp"
let CAPITagResendOTPEmail              = "merchant-resend-verification"
let CAPITagResetPass                   = "merchant-reset-password"
let CAPITagForgotPass                  = "merchant-forgot-password"
let CAPITagEditEmail                   = "edit-email"
let CAPImerchantSignUp                 = "merchant-sign-up"
let CAPITagEditProfileMerchant         = "merchant-edit-profile"
let CAPITagUserDetail                  = "user-detail"
let CAPITagChangePassword              = "change-password"
let CAPITagOfferList                   = "merchant/offers"
let CAPITagMemberList                   = "list-member"
let CAPITagDeleteOffer                 = "deleted-offer"
let CAPITagDeleteMember                =  "delete-member"
let CAPITagAddRefCash                  = "add-refcash"
let CAPITagMerchantRefHistory          = "merchant-refcash-history"
let CAPITagAddEditOffer                = "merchant/add-offer"
let CAPITagCreatePDFandSend            = "create-pdf-send-email"
let CAPITagAddReferMsg                 = "merchant-refmsg"
let CAPITagAddMember                   = "add-member"
let CAPITagAddCreateCashBack           = "merchant/add-cashback"
let CAPITagListCashBack                = "merchant/list-cashback"
let CAPITagEditCashBack                = "merchant/edit-cashback"
let CAPITagUpdateCashBack              = "merchant/update-cashback"
let CAPITagDeleteCashBack              = "merchant/delete-cashback"
//MARK:-
//MARK:- API TAG Customer
let CAPIcustomerGiftList                = "giftcard-list"
let CAPIhtmlParsing                     = "html-parsing-test?product_url="
let CAPIcustomerReward                  = "reward-percent"
let CAPIcustomerUserActivity            = "user-activity"
let CAPIcustomerRefered                 = "coupon-list"
let CAPIcustomerSocialLogin             = "customer-social-login"
let CAPIcustomerSignUp                  = "customer-sign-up"
let CAPITagOTPVarify                    = "customer-verified"
let CAPITagResendOTPMobile              = "customer-resend-verification"
let CAPITagEditMobileNo                 = "edit-mobile"
let CAPITagLoginCustomer                = "customer-login"
let CAPITagCustomerForgotPass           = "customer-forgot-password"
let CAPITagCustomerResetPass            = "customer-reset-password"
let CAPITagEditProfileCustomer          = "customer-edit-profile"
let CAPITagReferralAlerts               = "referral-list"
let CAPITagStoreCredit                  = "store-credit"
let CAPITagReferMerchant                = "refer-merchant"
let CAPITagCustomerRefHistory           = "customer-refcash-history"
let CAPITagAwaitingRewardlist           = "awaiting-reward-list"
let CAPITagRateAndReviewMerchant        = "rate-merchant"
let CAPITagRateAndReferMerchant         = "rate-referral-merchant"
let CAPITagSearchMerchant               = "search-merchant"
let CAPITagSearchMerchantDetails        = "scan-merchant-detail"
let CAPITagRedemptionHistory            = "redemption-history"
let CAPITagGenerateRedemptionCodeStore  = "generate-redemption-code-store"
let CAPITagMerchantOfferDetails         = "offer-detail"
let CAPITagMerchantScanOffer            = "merchant/scan-offer"
let CAPITagRedeemedOffer                = "redeem-offer"
let CAPITagRedeemRefCash                = "redeem-refcash"
let CAPITagAddRemoveToken               = "add-remove-token"
let CAPITagPushNotificationOnOff        = "notification-on-off"
let CAPITagReferralAtlertsDetails       = "referral-detail"
let CAPITagGenerateRedemptionCodeAlerts = "generate-redemption-code"
let CAPITagMerchantRateReview           = "merchant-rate-review"
let CAPITagSendContactsOnServer         = "contact-list"
let CAPITagNotificationlist             = "notification"
let CAPIcustomerUserParsingKey          = "merchant-key-list"
let CAPICouponQROffer                   = "couponQR?offer id="
let CAPIGenerateQRCode                  = "customer/generate-qrcode"
let CAPIClaimCashBack                   = "customer/claim-cashback"
let CAPICheckCashback                   = "customer/check-cashback"

let CAPIPerPage = 20


typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ error:Error?) -> Void
typealias ProgressHandler = (Progress) -> Void

class Networking: NSObject {
    
    var BASEURL:String?
    var Manager: SessionManager?

    var headers:[String: String] {
        if UserDefaults.standard.value(forKey: UserDefaultLoginUserToken) != nil {
            return ["Authorization" : "Bearer \((CUserDefaults.value(forKey: UserDefaultLoginUserToken)) as? String ?? "")",
                "Accept":"application/json"]
        } else {
            return ["Authorization" : "",
                    "Accept":"application/json"]
        }
    }
    
    var loggingEnabled = true
    var activityCount = 0
    
    
    /// Networking Singleton
    static let sharedInstance = Networking.init()
    override init() {
        super.init()
       let serverTrustPolicies: [String: ServerTrustPolicy] = [
                    "https://smarketdeals.com/": .pinCertificates(
                        certificates: ServerTrustPolicy.certificates(in:Bundle.main),
                        validateCertificateChain: true,
                        validateHost: true
                    ),
                    "insecure.expired-apis.com": .disableEvaluation
                ]

                Manager = SessionManager(
                    serverTrustPolicyManager: ServerTrustPolicyManager(policies:
        serverTrustPolicies)
                )
    }
    
    fileprivate func logging(request req:Request?) -> Void {
        
        if (loggingEnabled && req != nil) {
            var body:String = ""
            var length = 0
            
            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }
            
            let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"
            
            print("API Request: \(printableString)")
        }
    }
    
    fileprivate func logging(response res:DataResponse<Any>?) -> Void {
        
        if (loggingEnabled && (res != nil)) {
            if (res?.result.error != nil) {
                print("API Response: (\(String(describing: res?.response?.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Error:\(String(describing: res?.result.error))")
            } else {
                print("API Response: (\(String(describing: res?.response!.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Response:\(String(describing: res?.result.value))")
            }
        }
    }
    
    /// Uploading
    
    func upload(
        _ URLRequest: URLRequestConvertible,
        multipartFormData: (MultipartFormData) -> Void,
        encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) -> Void {
        
        let formData = MultipartFormData()
        multipartFormData(formData)
        
        
        var URLRequestWithContentType = try? URLRequest.asURLRequest()
        
        URLRequestWithContentType?.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
        
        let fileManager = FileManager.default
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileName = UUID().uuidString
        
        #if swift(>=2.3)
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #else
        
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #endif
        
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            try formData.writeEncodedData(to: fileURL)
            
            DispatchQueue.main.async {
                
                let encodingResult = SessionManager.MultipartFormDataEncodingResult.success(request: SessionManager.default.upload(fileURL, with: URLRequestWithContentType!), streamingFromDisk: true, streamFileURL: fileURL)
                encodingCompletion?(encodingResult)
            }
        } catch {
            DispatchQueue.main.async {
                encodingCompletion?(.failure(error))
            }
        }
    }
    
    // HTTPs Methods
    func GET(param parameters:[String: Any]?, success:ClosureSuccess?,  failure:ClosureError?) -> URLSessionTask? {
        
        let uRequest = Manager!.request(BASEURL!, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && response.response?.statusCode == 200) {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                if(failure != nil) {
                    failure!(uRequest.task!, response.result.error)
                }
            }
        }
        
        return uRequest.task
    }
    
    func GET(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        
        let uRequest = Manager!.request((BASEURL! + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            
            if(response.result.error == nil && ([200, 401] .contains(response.response!.statusCode)) ) {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                
                if(failure != nil) {
                    
                    if response.result.error != nil {
                        failure!(uRequest.task!,response.result.error )
                    }
                    else {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else {
                            
                            let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :"Error found but error message not found"])
                            
                            return failure!(uRequest.task!,error)
                        }
                        
                        let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :message ])
                        
                        failure!(uRequest.task!, error)
                    }
                    
                    
                }
            }
        }
        
        return uRequest.task
    }
    
    func POST(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        let uRequest = Manager!.request((BASEURL! + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200,201,401] .contains(response.response!.statusCode)) ) {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                
                if(failure != nil) {
                    
                    if response.result.error != nil {
                        failure!(uRequest.task!,response.result.error )
                    }
                    else {
                        
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else {
                            
                            let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :"Error found but error message not found"])
                            
                            return failure!(uRequest.task!,error)
                        }
                        
                        let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :message ])
                        
                        failure!(uRequest.task!, error)
                    }
                    
                }
            }
        }
        
        return uRequest.task
    }
    
    
    
    func POST(param parameters:[String: AnyObject]?, multipartFormData: @escaping (MultipartFormData) -> Void, success:ClosureSuccess?,  failure:ClosureError?) -> Void {
        print(parameters as Any)
        SessionManager.default.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
//            for (key, value) in parameters! {
//
//                if key == "sub_offer" {
//
//                    for (key1, value) in parameters!  {
//
//                         //   for (key1, value) in parameters!  {
//
//                                if key == "sub_offer" && key1 == "sub_offer" {
//
//                                    let dis = value as! [[String:Any]]
//
//
//                                    for data in dis {
//                                        print(data["amount"])
//                                        multipart.append("\(String(describing: data["amount"]))".data(using: String.Encoding.utf8)!, withName: "amount" as String)
//                                        multipart.append("\(String(describing: data["conditions"]))".data(using: String.Encoding.utf8)!, withName: "conditions" as String)
//                                        multipart.append("\(String(describing: data["coupon_image"]))".data(using: String.Encoding.utf8)!, withName: "coupon_image" as String)
//                                        multipart.append("\(String(describing: data["sub_offer_category"]))".data(using: String.Encoding.utf8)!, withName: "sub_offer_category" as String)
//                                        multipart.append("\(String(describing: data["sub_offer_type"]))".data(using: String.Encoding.utf8)!, withName: "sub_offer_type" as String)
//
//                                    }
//
//                                }
//
//
//                           // }
//                    }
//                }else {
//                    multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                }
////                                if let val = value as? Parameters {
////                                    for (key1, value) in val {
////                                        multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)[\(key1)]" as String)
////                                    }
////                                  //
////                                }
//
//
//                            }
            
            
//            for (key, value) in parameters! {
//
//                if key == "sub_offer" {
//                    if let array = value as? [[String : Any]] {
//
//                        if let dat = array as? [String] {
//                            for item in dat {
//                                if let mydat = item.data(using: .utf8){
//                                    multipart.append(mydat, withName: key)
//                                }
//                            }
//                        }
//                    }
//                }else{
//                    print(key)
//                    print(value)
//                    multipart.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
//                }
//
//            }
            
        },  to: (BASEURL! + (parameters!["tag"] as! String)), method: HTTPMethod.post , headers: headers) { (encodingResult) in
                
            switch encodingResult {
                
            case .success(let uRequest, _, _):
                
                self.logging(request: uRequest)
                
                uRequest.responseJSON { (response) in
                    
                    self.logging(response: response)
                    if(response.result.error == nil && ([200, 201, 401] .contains(response.response!.statusCode)) ) {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject)
                        }
                    }
                    else {
                        
                        if(failure != nil) {
                            
                            if response.result.error != nil {
                                failure!(uRequest.task!,response.result.error )
                            }
                            else {
                                let dict = response.result.value as? [String : AnyObject]
                                
                                guard let message = dict?.valueForString(key: "message") else {
                                    
                                    let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :"Error found but error message not found"])
                                    
                                    return failure!(uRequest.task!,error)
                                }
                                
                                let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :message ])
                                
                                failure!(uRequest.task!, error)
                            }
                            
                            
                        }
                    }
                }
                
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
        
    }
    
    
    func POST(param parameters:[String: AnyObject]?, multipartFormData: @escaping (MultipartFormData) -> Void, success:ClosureSuccess?,  failure:ClosureError?, progressHandler: @escaping ProgressHandler) -> Void {
        print(parameters as Any)
        
        
        SessionManager.default.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            for (key, value) in parameters! {
                
                multipart.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
            
        },  to: (BASEURL! + (parameters!["tag"] as! String)), method: HTTPMethod.post , headers: headers) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let uRequest, _, _):
                
                uRequest.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    progressHandler(progress)
                })
                
                self.logging(request: uRequest)
                
                uRequest.responseJSON { (response) in
                    
                    self.logging(response: response)
                    if(response.result.error == nil && ([200, 201, 401] .contains(response.response!.statusCode)) ) {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject)
                        }
                    }
                    else {
                        
                        if(failure != nil) {
                            
                            if response.result.error != nil {
                                failure!(uRequest.task!,response.result.error )
                            }
                            else {
                                let dict = response.result.value as? [String : AnyObject]
                                
                                guard let message = dict?.valueForString(key: "message") else {
                                    
                                    let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :"Error found but error message not found"])
                                    
                                    return failure!(uRequest.task!,error)
                                }
                                
                                let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :message ])
                                
                                failure!(uRequest.task!, error)
                            }
                            
                            
                        }
                    }
                }
                
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
        
    }
    
    func HEAD(param parameters: [String: Any]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .head, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                if(failure != nil) {
                    failure!(uRequest.task!, response.result.error )
                }
            }
        }
        
        return uRequest.task!
    }
    
    func PATCH(param parameters: [String: Any]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                if(failure != nil) {
                    failure!(uRequest.task!, response.result.error )
                }
            }
        }
        
        return uRequest.task!
    }
    
    func PUT(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        let uRequest = SessionManager.default.request(BASEURL!+tag, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200,201] .contains(response.response!.statusCode)) ) {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                if(failure != nil) {
                    
                    if response.result.error != nil {
                        failure!(uRequest.task!,response.result.error )
                    }
                    else {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else {
                            
                            let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :"Error found but error message not found"])
                            
                            return failure!(uRequest.task!,error)
                        }
                        
                        let error = NSError(domain: "", code: response.response?.statusCode ?? 400, userInfo: [NSLocalizedDescriptionKey :message ])
                        
                        failure!(uRequest.task!, error)
                    }
                    
                    
                }
            }
        }
        
        
        return uRequest.task!
    }
    func PUT(param parameters: [String: Any]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                if(failure != nil) {
                    failure!(uRequest.task!, response.result.error )
                }
            }
        }
        
        return uRequest.task!
    }
    
    func DELETE(param parameters: [String: Any]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else {
                if(failure != nil) {
                    failure!(uRequest.task!, response.result.error )
                }
            }
        }
        
        return uRequest.task!
    }
}



var BASEURL:String  =  APIBASEURL


class APIRequest: NSObject {
    
    typealias ClosureCompletion = (_ response:AnyObject?, _ error:Error?) -> Void
    
    typealias successCallBack = (([String:AnyObject]?) -> ())
    typealias failureCallBack = ((String) -> ())
    
    private var isInvalidUserAlertDisplaying = false
    
    
    private override init() {
        super.init()
    }
    
    private static var apiRequest:APIRequest {
        let apiRequest = APIRequest()
        
        if (BASEURL.count > 0 && !BASEURL.hasSuffix("/")) {
            BASEURL = BASEURL + "/"
        }
        
        
        Networking.sharedInstance.BASEURL = BASEURL
        return apiRequest
    }
    
    static func shared() -> APIRequest {
        return apiRequest
    }
    
    func isJSONDataValid(withResponse response: AnyObject!) -> Bool {
        if (response == nil) {
            return false
        }
        
        let data = response.value(forKey: CJsonData)
        
        if !(data != nil) {
            return false
        }
        
        if (data is String) {
            if ((data as? String)?.count ?? 0) == 0 {
                return false
            }
        }
        
        if (data is [Any]) {
            if (data as? [Any])?.count == 0 {
                return false
            }
        }
        
        return self.isJSONStatusValid(withResponse: response)
    }
    
    func isJSONStatusValid(withResponse response: AnyObject!) -> Bool {
        
        if response == nil {
            return false
        }
        
        let responseObject = response as? [String : AnyObject]
        
        if let meta = responseObject?[CJsonMeta]  as? [String : AnyObject] {
            
            switch meta.valueForInt(key: CJsonStatus) {
                
            case CStatusZero: // Success
                return  true
                
            case CStatusFour: // Email or mobile number Varification Pending
                return  true
                
            case CStatusOne: // Email exist
                return  true
                
            case CStatusTen: // Email is not registered with us
                return  true
                
            default :
                return false
            }
        }
        
        if let status = responseObject?.valueForString(key: CJsonStatus) {
            
            switch status {
                
            case "error":
                return false
                
            case "success" :
                return true
                
            default :
                return false
            }
        }
        
        if  responseObject?.valueForInt(key: CJsonStatus) == CStatusZero {
            return  true
        }
        else {
            return false
        }
        
        
    }
    
    
    func checkAPIStatus(withResponse response: AnyObject?, showAlert:Bool) -> Bool {
        
        MILoader.shared.hideLoader()
        if response == nil {
            return false
        }
        
        let responseObject = response as? [String : AnyObject]
        
        if let meta = responseObject?[CJsonMeta]  as? [String : AnyObject] {
            
            switch meta.valueForInt(key: CJsonStatus) {
                
            case CStatusZero:
                return  true
                
            case CStatusFour:
                
                //                if showAlert {
                //                    CTopMostViewController?.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                //                }
                return  true
                
            case CStatusTen:
                return true
            case CStatusOne:
                return true
                
            default :
                if showAlert {
                    CTopMostViewController?.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                }
                return  false
            }
            
        }
        
        if let status = responseObject?.valueForInt(key: CJsonStatus) {
            
            switch status {
                
            case CStatusZero:
                return true
                
            case CStatus401 :
                return isValidUser(response: response)
                
            default :
                if showAlert {
                    CTopMostViewController?.showAlertView(responseObject?.valueForString(key: CJsonMessage), completion: nil)
                }
            }
        }
        
        if let status = responseObject?.valueForString(key: CJsonStatus) {
            
            switch status {
                
            case "error":
                if showAlert {
                    CTopMostViewController?.showAlertView(responseObject?.valueForString(key: CJsonMessage), completion: nil)
                }
                
            case "success" :
                return true
                
            default :
                if showAlert {
                    CTopMostViewController?.showAlertView(responseObject?.valueForString(key: CJsonMessage), completion: nil)
                }
            }
        }
        
        return false
    }
    
    
    func isValidUser(response:AnyObject?) -> Bool {
        
        if appDelegate?.loginUser != nil {
            let responseObject = response as? [String : AnyObject]
            
            if  responseObject?.valueForString(key: CJsonStatus).toInt == CStatus401 {
                if appDelegate?.loginUser?.user_type == 1 {
                    appDelegate?.signOutCustomerUser(response: response)
                }else {
                    appDelegate?.signOutMerchantUser(response: response)
                }
                
                return false
            }
        }
        
        return true
    }
    
    func failureWithError(_ error : Error?, showAlert : Bool)  {
        
        if error != nil {
            
            if showAlert {
                CTopMostViewController?.showAlertView(error?.localizedDescription ?? "Something went wrong", completion: nil)
            }
        }
    }
}


//MARK:-
//MARK:-~

extension APIRequest {
    
    //MARK:-
    //MARK:- General API
    
    func loadCategory(completion: @escaping ClosureCompletion) {
        
        //timestamp
        
        let param = ["timestamp":"0"]
        
        //        if let timestamp = CUserDefaults.value(forKey: UserDefaultCategoryTimestamp) as? String, !(timestamp.isBlank) {
        //            param["timestamp"] = timestamp
        //        }
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagCategory, param: param, successBlock:{ (task, response) in
            MILoader.shared.hideLoader()
            
            if self.isJSONDataValid(withResponse: response) {
                self.saveCategory(response)
            }
            
            completion(response, nil)
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
        })
    }
    
    func loadCMS(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCMS, param: nil, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            
            if self.isJSONDataValid(withResponse: response) {
                self.saveCMS(response)
            }
            completion(response, nil)
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
        })
    }
    
    func cancelAllApiRequest()  {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    //MARK:-
    //MARK:- Common
    
    func loadBanner(_ param : [String : Any], completion: @escaping ClosureCompletion)-> URLSessionTask? {
        
        //user_type
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        
        return Networking.sharedInstance.POST(apiTag: CAPITagBanner, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func loadFAQ(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //user_type
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagFAQ, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func changePassword(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //old_password
        //new_password
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagChangePassword, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loadUserDetails(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagUserInfo, param: nil, successBlock: { (task, response) in
            
            print("response====>>>", response)
            
            if self.checkAPIStatus(withResponse: response, showAlert:false) {
               // self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                print("response====>>>", response)
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    //MARK:-
    //MARK:- LRF Merchant
    
    func registerMerchantUser(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        //Merchant
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
//        if imgProfileData != nil {
//
//            var dictParam = param as [String : AnyObject]
//            dictParam["tag"] = CAPImerchantSignUp as AnyObject
//
//            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
//
//                if let profileData =  imgProfileData {
//                    formData.append(profileData, withName: "business_logo", fileName: "profilePicture.jpg", mimeType: "image/jpeg")
//                }
//
//            }, success: { (task, response) in
//
//                if self.checkAPIStatus(withResponse: response, showAlert: true) {
//                    completion(response, nil)
//                }
//
//
//            }) { (task, error) in
//                MILoader.shared.hideLoader()
//                completion(nil, error)
//
//                self.failureWithError(error, showAlert: true)
//
//            }
//
//        } else {
            _ = Networking.sharedInstance.POST(apiTag: CAPImerchantSignUp, param: param as [String : AnyObject], successBlock: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                self.failureWithError(error, showAlert: true)
            })
       // }
        
    }
    
    func loginWithSocial(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        //google_id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagSocialLogin, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    func rewardPercent(completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.GET(apiTag: CAPIcustomerReward, param: nil, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func htmlParsingKeys(completion: @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPIcustomerUserParsingKey, param: ["type":"ios"], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func htmlParsing(product:String, completion: @escaping ClosureCompletion) {
        var country = "india"
        if let coun = CUserDefaults.value(forKey: UserDefaultCountryCode) {
            if  coun as! String == "+91" {
                country = "india"
            }else{
                country = "others"
            }
        }
        else{
            country = "india"
        }
        
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.GET(apiTag: "\(CAPIhtmlParsing)\(product)&country=\(country)", param: nil, successBlock: { (task, response) in
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func giftList(completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.GET(apiTag: CAPIcustomerGiftList, param: nil, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    func userActivity(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPIcustomerUserActivity, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    func customerReferred(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPIcustomerRefered, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    func loginWithCustomerSocial(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        //google_id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPIcustomerSocialLogin, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
   
    func loginWithNormal(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        //password
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagSocialNormalEmail, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func merchantResetPassword(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        email
        //        password
        //        otp
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagResetPass, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func varifyEmailOTP(_ param : [String : Any],fromVC:String, completion: @escaping ClosureCompletion) {
        
        // email
        // otp
        var urlPath = ""
        if fromVC == "LOGIN"  {
            urlPath = CAPITagEmailLoginVarify
        }else{
            urlPath = CAPITagEmailVarify
        }
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: urlPath, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func editEmail(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        new_email
        //        old_email
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagEditEmail, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func resendEmailOTP(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagResendOTPEmail, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func forgotPasswordWithEmail(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagForgotPass, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func editProfileMerchant(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        if imgProfileData != nil {
            
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagEditProfileMerchant as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                if let profileData =  imgProfileData {
                    formData.append(profileData, withName: "business_logo", fileName: "logo.jpg", mimeType: "image/jpeg")
                }
                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    
                    self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            }
            
        } else {
            _ = Networking.sharedInstance.POST(apiTag: CAPITagEditProfileMerchant, param: param as [String : AnyObject], successBlock: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    
                    self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                    completion(response, nil)
                }
                
            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            })
        }
        
    }
    
    //MARK:-
    //MARK:- Offer Merchant
    
    func addReferMsg(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddReferMsg, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loadOfferList(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagOfferList, param: nil, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
           self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func generateQRCode(_ param : [String : Any],completion: @escaping ClosureCompletion){
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPIGenerateQRCode, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
        
    }
    func loadMemberList(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagMemberList, param: nil, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func addEditOffer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        Id
        //        offer_type
        //        expiry_date
        //        sub_offer{ Id,sub_offer_type,sub_offer_category,amount,conditions,is_redemption,title }
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddEditOffer, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func createPDFAndSendEmail(completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCreatePDFandSend, param: nil, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func deleteMemberList(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        offer_id
        //        sub_offer_id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagDeleteMember, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func addMemberWithEmail(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddMember, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func deleteOffer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        offer_id
        //        sub_offer_id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagDeleteOffer, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func addRefCash(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //amount
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddRefCash, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loadMerchantRefCashHistory(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //history_type
        
        // MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagMerchantRefHistory, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func scanOffer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //code
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagMerchantScanOffer, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func redeemOffer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagRedeemedOffer, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {}
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    func couponQROffer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPICouponQROffer, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {}
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    //CAPICouponQROffer
    //MARK:-
    //MARK:- LRF Customer
    
    func registerCustomerUser(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
//        if imgProfileData != nil {
//
//            var dictParam = param as [String : AnyObject]
//            dictParam["tag"] = CAPIcustomerSignUp as AnyObject
//          
//
//            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
//
//                if let profileData =  imgProfileData {
//                    formData.append(profileData, withName: "profile_pic", fileName: "profilePicture.jpg", mimeType: "image/jpeg")
//                }
//
//            }, success: { (task, response) in
//
//                if self.checkAPIStatus(withResponse: response, showAlert: true) {
//                    completion(response, nil)
//                }
//
//
//            }) { (task, error) in
//                MILoader.shared.hideLoader()
//                completion(nil, error)
//
//                self.failureWithError(error, showAlert: true)
//
//            }
//
//        } else {
        
        var dictParam = param as [String : AnyObject]
        dictParam["tag"] = CAPIcustomerSignUp as AnyObject
            _ = Networking.sharedInstance.POST(apiTag: CAPIcustomerSignUp, param: dictParam, successBlock: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                self.failureWithError(error, showAlert: true)
            })
       // }
        
    }
    
    func addCouponOffer(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        if imgProfileData != nil {
            
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagAddEditOffer as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                for (key, value) in dictParam {
                    
                    if key == "sub_offer" {
                        
                        for (key1, value) in param  {
                            
                             //   for (key1, value) in parameters!  {
                                    
                                    if key == "sub_offer" && key1 == "sub_offer" {
                                        
                                        let dis = value as! [[String:Any]]
                                        
                                        
                                        for data in dis {
                                            print(data["amount"])
                                            formData.append("\(String(describing: data["amount"]))".data(using: String.Encoding.utf8)!, withName: "amount" as String)
                                            formData.append("\(String(describing: data["conditions"]))".data(using: String.Encoding.utf8)!, withName: "conditions" as String)
                                            formData.append("\(String(describing: data["coupon_image"]))".data(using: String.Encoding.utf8)!, withName: "coupon_image" as String)
                                            formData.append("\(String(describing: data["sub_offer_category"]))".data(using: String.Encoding.utf8)!, withName: "sub_offer_category" as String)
                                            formData.append("\(String(describing: data["sub_offer_type"]))".data(using: String.Encoding.utf8)!, withName: "sub_offer_type" as String)
                                            formData.append(imgProfileData!, withName: "coupon_image", fileName: "couponPicture.jpg", mimeType: "image/jpeg")


                                        }
                                        
                                    }
                                    
                                    
                               // }
                        }
                    }else {
                        formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
    //                                if let val = value as? Parameters {
    //                                    for (key1, value) in val {
    //                                        multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)[\(key1)]" as String)
    //                                    }
    //                                  //
    //                                }
                                    
                                    
                                }
                
//                if let profileData =  imgProfileData {
//                    formData.append(profileData, withName: "coupon_image", fileName: "couponPicture.jpg", mimeType: "image/jpeg")
//                }
                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                
                self.failureWithError(error, showAlert: true)
                
            }
            
        } else {
            _ = Networking.sharedInstance.POST(apiTag: CAPITagAddEditOffer, param: param as [String : AnyObject], successBlock: { (task, response) in

                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }

            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                self.failureWithError(error, showAlert: true)
            })
        }
        
    }
    
    func  listCashBack(completion: @escaping ClosureCompletion){
    MILoader.shared.showLoader(type: .circularRing, message: "")
    _ = Networking.sharedInstance.POST(apiTag: CAPITagListCashBack, param: nil, successBlock: { (task, response) in
        
        print(response?["status"] as? String ?? "", "task")
        
        let result = response?["status"] as? String ?? ""
        if result == "error"{
            print("welcome")
            completion(response, nil)
        }
        if self.checkAPIStatus(withResponse: response, showAlert: false) {
            print("hhchxch")
            completion(response, nil)
        }
         
    }, failureBlock: { (task, error) in
        MILoader.shared.hideLoader()
        self.failureWithError(error, showAlert: true)
        //SharedClass.sharedInstance.alert(title: "Your title here", message: "Your message here")
    })
    }
    
   
    
    func addEditCashBack(_ param : [String : Any], completion: @escaping ClosureCompletion){
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagEditCashBack as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                for (key, value) in dictParam {
                    
                formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    
//                                    if let val = value as? Parameters {
//                                        for (key1, value) in val {
//                                            formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)[\(key1)]" as String)
//                                        }
//                                    }
                                    
                                    
                                }

                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                
                self.failureWithError(error, showAlert: true)
                
            }
            
//         else {
//            _ = Networking.sharedInstance.POST(apiTag: CAPITagAddEditOffer, param: param as [String : AnyObject], successBlock: { (task, response) in
//
//                if self.checkAPIStatus(withResponse: response, showAlert: true) {
//                    completion(response, nil)
//                }
//
//            }, failureBlock: { (task, error) in
//                MILoader.shared.hideLoader()
//                completion(nil, error)
//                self.failureWithError(error, showAlert: true)
//            })
//        }
        
    }
    
    func addUpdateCashBack(_ param : [String : Any], completion: @escaping ClosureCompletion){
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
            
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagUpdateCashBack as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                for (key, value) in dictParam {
                    
                formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    

                                    
                                    
                                }

                
            }, success: { (task, response) in
                
             
                
              
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                
                self.failureWithError(error, showAlert: true)
                
            }
            

        
        
    }
    
    func deleteCashBack(_ param : [String : Any], completion: @escaping ClosureCompletion){
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
            
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagDeleteCashBack as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                for (key, value) in dictParam {
                    
                formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    
                                    
                                }

                
            }, success: { (task, response) in
                
                print(response?["message"])
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                
                self.failureWithError(error, showAlert: true)
                
            }
            
        
    }
    
    func addCreateCashback(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
            
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagAddCreateCashBack as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                for (key, value) in dictParam {
                    
                formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    
//                                    if let val = value as? Parameters {
//                                        for (key1, value) in val {
//                                            formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)[\(key1)]" as String)
//                                        }
//                                    }
                                    
                                    
                                }

                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                
                self.failureWithError(error, showAlert: true)
                
            }
            
//         else {
//            _ = Networking.sharedInstance.POST(apiTag: CAPITagAddEditOffer, param: param as [String : AnyObject], successBlock: { (task, response) in
//
//                if self.checkAPIStatus(withResponse: response, showAlert: true) {
//                    completion(response, nil)
//                }
//
//            }, failureBlock: { (task, error) in
//                MILoader.shared.hideLoader()
//                completion(nil, error)
//                self.failureWithError(error, showAlert: true)
//            })
//        }
        
    }
    
    
    func claimCashBack(_ param : [String : Any], completion: @escaping ClosureCompletion) {
           
           MILoader.shared.showLoader(type: .circularRing, message: "")
           
               
               var dictParam = param as [String : AnyObject]
               dictParam["tag"] = CAPIClaimCashBack as AnyObject
               
               _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                   
                   for (key, value) in dictParam {
                       
                   formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                       

                                       
                                       
                                   }

                   
               }, success: { (task, response) in
                   
                   if self.checkAPIStatus(withResponse: response, showAlert: true) {
                       completion(response, nil)
                   }
                   
                   
               }) { (task, error) in
                   MILoader.shared.hideLoader()
                   completion(nil, error)
                   
                   self.failureWithError(error, showAlert: true)
                   
               }
               

           
       }
       
    
    func listCashback(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
            
            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagAddCreateCashBack as AnyObject
            
            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in
                
                for (key, value) in dictParam {
                    
                formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    
//                                    if let val = value as? Parameters {
//                                        for (key1, value) in val {
//                                            formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)[\(key1)]" as String)
//                                        }
//                                    }
                                    
                                    
                                }

                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                completion(nil, error)
                
                self.failureWithError(error, showAlert: true)
                
            }
            
//         else {
//            _ = Networking.sharedInstance.POST(apiTag: CAPITagAddEditOffer, param: param as [String : AnyObject], successBlock: { (task, response) in
//
//                if self.checkAPIStatus(withResponse: response, showAlert: true) {
//                    completion(response, nil)
//                }
//
//            }, failureBlock: { (task, error) in
//                MILoader.shared.hideLoader()
//                completion(nil, error)
//                self.failureWithError(error, showAlert: true)
//            })
//        }
        
    }
    func varifyMobileOTP(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        // country_code
        // mobile
        // otp
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagOTPVarify, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func resendMobileOTP(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //country_code
        //mobile
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagResendOTPMobile, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func editMobileNo(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //old_country_code
        //old_mobile
        //new_country_code
        //new_mobile
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagEditMobileNo, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loginCustomer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //country_code
        //mobile
        //password
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagLoginCustomer, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func forgotPasswordWithMobile(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //mobile
        //country_code
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagCustomerForgotPass, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func customerResetPassword(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        country_code
        //        mobile
        //        password
        //        otp
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagCustomerResetPass, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func editProfileCustomer(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        if imgProfileData != nil {

            var dictParam = param as [String : AnyObject]
            dictParam["tag"] = CAPITagEditProfileCustomer as AnyObject

            _ = Networking.sharedInstance.POST(param: dictParam, multipartFormData: { (formData) in

                if let profileData =  imgProfileData {
                    formData.append(profileData, withName: "profile_pic", fileName: "profilePicture.jpg", mimeType: "image/jpeg")
                }

            }, success: { (task, response) in

                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                    completion(response, nil)
                }


            }) { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            }

        } else {
            _ = Networking.sharedInstance.POST(apiTag: CAPITagEditProfileCustomer, param: param as [String : AnyObject], successBlock: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    self.saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                    completion(response, nil)
                }
                
            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            })
        }
        
    }
    
    func addRemovePushToken(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //        user_id
        //        type
        //        device_token
        //        device_type
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddRemoveToken, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
            }
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func pushNotificationOnOff(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagPushNotificationOnOff, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    //MARK:-
    //MARK:- Offer Customer
    
    func loadSearchMerchant(_ param : [String : Any], completion: @escaping ClosureCompletion) -> URLSessionTask?{
        
        //longitude
        //latitude
        //post_code
        //search_text
        //distance
        //show_top_merchant
        
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        //dicParam["latitude"] = appDelegate?.loginUser?.latitude
       // dicParam["longitude"] = appDelegate?.loginUser?.longitude
            dicParam["latitude"] = "23.057389604233844"
             dicParam["longitude"] = "72.53433392196742"
      
        return Networking.sharedInstance.POST(apiTag: CAPITagSearchMerchant, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func loadMerchantDetails(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //merchant_id
        //longitude
        //latitude
        
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagSearchMerchantDetails, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
            }
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func checkCashbackDetails(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //merchant_id
        //longitude
        //latitude
//        var dicParam = param
//        dicParam["per_page"] = CAPIPerPage
//        dicParam["latitude"] = appDelegate?.loginUser?.latitude
//        dicParam["longitude"] = appDelegate?.loginUser?.longitude
//        print("checkCashbackDetails-- ", dicParam)
        
        _ = Networking.sharedInstance.POST(apiTag: CAPICheckCashback, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
            }
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func loadReferralAlerts(_ param : [String : Any], completion: @escaping ClosureCompletion) -> URLSessionTask?{
        
        //latitude
        //longitude
        
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        return Networking.sharedInstance.POST(apiTag: CAPITagReferralAlerts, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                print("arrAlerts--->>>22222 ",response)
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    func loadAwaitingRewards(_ param : [String : Any], completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        //latitude
        //longitude
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        return Networking.sharedInstance.POST(apiTag: CAPITagAwaitingRewardlist, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func loadStoreCredit(_ param : [String : Any], completion: @escaping ClosureCompletion) -> URLSessionTask?{
        
        //latitude
        //longitude
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        return Networking.sharedInstance.POST(apiTag: CAPITagStoreCredit, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func loadRedemptionHistory(_ param : [String : Any], completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        //latitude
        //longitude
        
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        return Networking.sharedInstance.POST(apiTag: CAPITagRedemptionHistory, param: dicParam as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func referMerchant(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //email
        //country_code
        //mobile
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagReferMerchant, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loadCustomerRefCashCreditDebit(_ param : [String : Any], completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        //type
        //customer_id
        
        //MILoader.shared.showLoader(type: .circularRing, message: "")
        return Networking.sharedInstance.POST(apiTag: CAPITagCustomerRefHistory, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func rateAndReviewMerchant(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        //merchant_id
        //rate
        //item_name
        //review
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        if imgProfileData != nil {
            
            var dictParam = param
            dictParam["tag"] = CAPITagRateAndReviewMerchant
            
            _ = Networking.sharedInstance.POST(param: dictParam as [String : AnyObject], multipartFormData: { (formData) in
                
                if let profileData =  imgProfileData {
                    formData.append(profileData, withName: "product_image", fileName: "productImage.jpg", mimeType: "image/jpeg")
                }
                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            }
            
        } else {
            _ = Networking.sharedInstance.POST(apiTag: CAPITagRateAndReviewMerchant, param: param as [String : AnyObject], successBlock: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            })
        }
    }
    
    func generateRedemptionCode(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //amount
        //latitude
        //longitude
        
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagGenerateRedemptionCodeStore, param: dicParam, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loadOfferDetails(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //id
        //longitude
        //latitude
        
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        dicParam["latitude"] = appDelegate?.loginUser?.latitude
        dicParam["longitude"] = appDelegate?.loginUser?.longitude
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagMerchantOfferDetails, param: dicParam, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {
            }
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func redeemRefCase(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //amount
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagRedeemRefCash, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func ReferralAtlertsDetails(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //merchant id
        var dicParam = param
        dicParam["per_page"] = CAPIPerPage
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagReferralAtlertsDetails, param:dicParam, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: false) {}
            
            completion(response, nil)
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: false)
            completion(nil, error)
        })
    }
    
    func generateRedemptionCodeAlerts(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        // merchant id
        // id
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagGenerateRedemptionCodeAlerts, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func sendContactsOnServer(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        //contacts array
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        _ = Networking.sharedInstance.POST(apiTag: CAPITagSendContactsOnServer, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func rateAndReferMerchant(_ param : [String : Any], imgProfileData : Data?, completion: @escaping ClosureCompletion) {
        
        //merchant_id
        //rate
        //item_name
        //review
        //contact Array
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        if imgProfileData != nil {
            
            var dictParam = param
            dictParam["tag"] = CAPITagRateAndReferMerchant + "?" + param.queryString
            
            _ = Networking.sharedInstance.POST(param: dictParam as [String : AnyObject], multipartFormData: { (formData) in
                
                if let profileData =  imgProfileData {
                    formData.append(profileData, withName: "product_image", fileName: "productImage.jpg", mimeType: "image/jpeg")
                }
                
            }, success: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
                
            }) { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            }
            
        } else {
            _ = Networking.sharedInstance.POST(apiTag: CAPITagRateAndReferMerchant, param: param as [String : AnyObject], successBlock: { (task, response) in
                
                if self.checkAPIStatus(withResponse: response, showAlert: true) {
                    completion(response, nil)
                }
                
            }, failureBlock: { (task, error) in
                MILoader.shared.hideLoader()
                self.failureWithError(error, showAlert: true)
                completion(nil, error)
            })
        }
    }
    func loadMerchantRateandReview(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        // id
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagMerchantRateReview, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    func loadNotificationlist(_ param : [String : Any], completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagNotificationlist, param: param, successBlock: { (task, response) in
            
            if self.checkAPIStatus(withResponse: response, showAlert: true) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, error) in
            MILoader.shared.hideLoader()
            self.failureWithError(error, showAlert: true)
            completion(nil, error)
        })
    }
    
    //MARK:-
    //MARK:- Save data
    
    func saveLoginUserToLocal(responseObject: [String : AnyObject]) {
        
        if let data = responseObject.valueForJSON(key: CJsonData) as? [String : AnyObject] {
            
            appDelegate?.loginUser = self.loginUserWithDictionary(dictUser: data)
            guard appDelegate?.loginUser?.user_id != nil else {return}
            appDelegate?.userDetail = data
            
            if data.valueForString(key: "user_type") == "2"{
                CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginMerchantID)
            }else{
                CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultCustID)
            }
            
            
            CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginUserID)
            CUserDefaults.set(data.valueForString(key: "country_code"), forKey: UserDefaultCountryCode)
            CUserDefaults.set(data.valueForString(key: "referral_code"), forKey: UserDefaultReferralCode)
            CUserDefaults.set(data.valueForString(key: "referral_message"), forKey: UserDefaultReferralMsg)
            CUserDefaults.set(data.valueForString(key: "login_user"), forKey: UserDefaultLoginUser)
            
            
            CUserDefaults.set(data.valueForString(key: "login_id"), forKey: "LoginID")
            CUserDefaults.set(data.valueForString(key: "user_type"), forKey: "UserType")
            CUserDefaults.set(data.valueForString(key: "login_type"), forKey: "LoginType")
            CUserDefaults.set(data.valueForString(key: "login_user"), forKey: "LoginUser")
            CUserDefaults.set(data.valueForString(key: "merchant_id"), forKey: "MerchantId")
            CUserDefaults.set(data.valueForString(key: "login_mail"), forKey: "LoginMail")
         
           
          
           
            
            if let meta = responseObject.valueForJSON(key: CJsonMeta) as? [String: Any], let token = meta["token"] {
                
                CUserDefaults.setValue(token, forKey: UserDefaultLoginUserToken)
                print("login user token == \(CUserDefaults.object(forKey: UserDefaultLoginUserToken) ?? "")")
            }
            CUserDefaults.synchronize()
        }
    }
    
    
    
    func loginUserWithDictionary(dictUser: [String : AnyObject]) -> TBLUser {
        
        let tblUser = TBLUser.findOrCreate(dictionary: ["user_id": dictUser.valueForString(key: "id")]) as! TBLUser
        
        tblUser.user_id = dictUser.valueForString(key: "id")
        tblUser.user_type = Int16(dictUser.valueForInt(key: "user_type") ?? 0)
        tblUser.email = dictUser.valueForString(key: "email")
        tblUser.country_code = dictUser.valueForString(key: "country_code")
        tblUser.mobile = dictUser.valueForString(key: "mobile")
        tblUser.refcash = dictUser.valueForString(key: "refcash")
        tblUser.notification = dictUser.valueForString(key: "notification")
        
        
        if dictUser.valueForInt(key: "user_type") == 1 { // For customer
            
            tblUser.name = dictUser.valueForString(key: "name")
            tblUser.picture = dictUser.valueForString(key: "profile_pic")
            tblUser.refferal_alert = dictUser.valueForString(key: "refferal_alert")
            tblUser.awaiting_rewards = dictUser.valueForString(key: "awaiting_rewards")
            tblUser.store_credit = dictUser.valueForString(key: "store_credit")
            tblUser.push_status = dictUser.valueForBool(key: "notification_status")
            tblUser.min_withdraw_amount = dictUser.valueForString(key: "min_withdraw_amount")
            
        }else { // For Merchant
            
            tblUser.login_type = Int16(dictUser.valueForInt(key: "login_type") ?? 0)
            tblUser.picture = dictUser.valueForString(key: "business_logo")
            tblUser.email = dictUser.valueForString(key: "email")
            tblUser.name = dictUser.valueForString(key: "business_name")
            tblUser.tag_line = dictUser.valueForString(key: "tag_line")
            tblUser.website = dictUser.valueForString(key: "website")
            tblUser.post_code = dictUser.valueForString(key: "post_code")
            tblUser.address = dictUser.valueForString(key: "address")
            tblUser.latitude = dictUser.valueForString(key: "latitude")
            tblUser.longitude = dictUser.valueForString(key: "longitude")
            tblUser.desc = dictUser.valueForString(key: "description")
            tblUser.product_and_services = dictUser.valueForString(key: "product_and_services")
            tblUser.no_of_rating = dictUser.valueForString(key: "no_of_rating")
            tblUser.average_rating = dictUser.valueForString(key: "average_rating")
            
            if let tblCat = TBLCategory.findOrCreate(dictionary: ["cat_id":dictUser.valueForString(key: "business_category_id")]) as? TBLCategory {
                tblUser.business_category = tblCat
            }
        }
        CoreData.saveContext()
        return tblUser
    }
    
    func saveCMS(_ response : AnyObject?)  {
        
        if let dictResponse = response as? [String :Any] {
            
            if let arrData = dictResponse[CJsonData] as? [[String : Any]] {
                
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "about-us"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultAboutus)
                }
                
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "terms-and-conditions"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultTermsConditionandPrivacyPolicy)
                }
                
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "privacy-policy"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultPrivacyPolicy)
                    
                }
                
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "how-to-use-this-app"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultHowToUseApp)
                    
                }
                
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "contact-us"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultContactUs)
                }
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "create-offer-instruction"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultCreateOfferInstruction)
                }
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "SMARK-offer"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultSmarkOffer)
                }
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "welcome-bonus"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultWelcomeBonus)
                }
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "thank-you-reward"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultThankYouReward)
                }
                if let index = arrData.index(where: {$0.valueForString(key: "seo_url") == "rate-review"}) {
                    
                    let data = arrData[index]
                    CUserDefaults.setValue(data, forKey: UserDefaultRateReview)
                }
                
                CUserDefaults.synchronize()
            }
        }
    }
    
    func saveCategory(_ response : AnyObject?)  {
        
        if let dictResponse = response as? [String :Any], let data = dictResponse[CJsonData] as? [[String : Any]], data.count > 0 {
            
            TBLCategory.deleteAllObjects()
            for (_, item) in data.enumerated() {
                
                if let tblCat = TBLCategory.findOrCreate(dictionary: ["cat_id":item.valueForString(key: "id")]) as? TBLCategory {
                    tblCat.cat_id = item.valueForString(key: "id")
                    tblCat.name = item.valueForString(key: "name")
                    tblCat.status = Int16(item.valueForInt(key: "status") ?? 1)
                }
            }
            CoreData.saveContext()
            
            if let meta = dictResponse[CJsonMeta] as? [String : Any] {
                
                CUserDefaults.setValue(meta.valueForString(key: "timestamp"), forKey: UserDefaultCategoryTimestamp)
                CUserDefaults.synchronize()
            }
        }
    }
}



