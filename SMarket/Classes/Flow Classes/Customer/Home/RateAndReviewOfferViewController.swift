//
//  RateAndReviewOfferViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 10/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import Contacts



var referalloffered = ""

class RateAndReviewOfferViewController: ParentViewController {
    
    @IBOutlet weak var vWAlertView : UIView!
    @IBOutlet weak var vWAlertChildView : UIView!
    @IBOutlet weak var vWMerchantRating : RatingView!
    @IBOutlet weak var vWRate : RatingView!
    @IBOutlet weak var viewReferBanner : UIView!
    var viewRefer : UIView?
    @IBOutlet weak var lblRefer : UILabel!
    @IBOutlet weak var lblEach : UILabel!
    
    @IBOutlet weak var imgRefer : UIImageView!
    @IBOutlet weak var imgVMerchant : UIImageView!
    
    @IBOutlet weak var txtItemName : UITextField!
    @IBOutlet weak var txtVReview : UITextView!
    
    @IBOutlet weak var btninvite: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnOfferType : UIButton!
    @IBOutlet weak var btnSubmit : UIButton!
    
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblTagline : UILabel!
    @IBOutlet weak var lblReview : UILabel!
    @IBOutlet weak var lblExpireDate : UILabel!
    @IBOutlet weak var lblReferredDate : UILabel!
    @IBOutlet weak var lblAvailableStoreCredit : UILabel!
    @IBOutlet weak var lblOfferType : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblDetails : UILabel!
    @IBOutlet weak var lblCondition : UILabel!
    @IBOutlet weak var lblConditionTitle : UILabel!
    @IBOutlet weak var lblOfferValue : UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    
    var isFromRate = false
    var productImage : UIImage?
    var merchant : MerchantDetails?
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    override func viewDidLayoutSubviews() {
        viewRefer!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
        viewReferBanner.frame = viewRefer!.frame
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func attributedEachTime() -> NSMutableAttributedString{
        
        let strSignUp = "Each time your referral shops through SMARKET we deposit you 30% of the rewards thery earn for LIFETIME"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor :  CRGB(r: 0, g: 79, b: 89),NSAttributedStringKey.font :CFontPoppins(size:12, type: .Regular)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : CRGB(r: 0, g: 79, b: 89),NSAttributedStringKey.font : CFontPoppins(size:18, type: .SemiBold)],range:strSignUp.rangeOf("30%"))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorRedExpireDate,NSAttributedStringKey.font :
            CFontPoppins(size:18, type: .SemiBold)],
                                       range:strSignUp.rangeOf("LIFETIME"))
        
        return attributedString
    }
    func attributedRefer() -> NSMutableAttributedString{
        
        let strSignUp = "Refer friends to earn\n 30%\n Lifetime cash rewards"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorWhite_FFFFFF,                                      NSAttributedStringKey.font :CFontPoppins(size:12, type: .Medium)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : CRGB(r: 209, g: 231, b: 77),NSAttributedStringKey.font :
            CFontPoppins(size:24, type: .SemiBold)],
                                       range:strSignUp.rangeOf("30%"))
        
        return attributedString
    }
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        viewRefer = UIView.init(frame: self.view.frame)
        viewRefer?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.navigationController?.view.addSubview(viewRefer!)
        viewRefer?.addSubview(viewReferBanner)
        viewRefer?.isHidden = true
        lblEach.attributedText = attributedEachTime()
        lblRefer.attributedText = attributedRefer()
        
        view.backgroundColor = ColorCustomerAppTheme
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideBannerPopup))
        viewRefer?.addGestureRecognizer(tap)
        
        alertPopUpConfiguration()
        
        imgRefer.touchUpInside { (imageView) in
            
            self.presentImagePickerController(allowEditing: true, imagePickerControllerCompletionHandler: { (image, info) in
                
                if image != nil {
                    self.imgRefer.image = image
                    self.productImage = image
                }
            })
        }
        
        if isFromRate {
            btnSubmit.setTitle("Rate Now", for: .normal)
        }
        prefilledData()
    }
    @objc func hideBannerPopup(){
        viewRefer!.isHidden = true
    }
    @IBAction func inviteSmarketButtonHandler(){
        viewRefer!.isHidden = true
        if let recommendVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RecommendToFriendsViewController") as? RecommendToFriendsViewController {
            self.navigationController?.pushViewController(recommendVC, animated: true)
        }
    }
    
    @IBAction func inviteSocialButtonHandler(){
        viewRefer!.isHidden = true
        // text to share
        var text = (CUserDefaults.value(forKey: UserDefaultReferralMsg) as! String)
        text = text.replacingOccurrences(of: "XXXXXX", with: CUserDefaults.value(forKey: UserDefaultReferralCode) as! String)
//        let text = "Hi, join SMARKET app ( from www.smarketworld.net ) to Compare, Save and Earn rewards while shopping online. Use the referral code \(CUserDefaults.value(forKey: UserDefaultReferralCode) ?? "") at sign-up to receive extra 5% cash rewards on every purchase. Android: https://bit.ly/2F9RPvQ, IOS: https://apple.co/2u6Jm7k"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnSubmitClicked(_ sender : UIButton) {
        
        if isValidationPassed() {
            
            if self.isFromRate {
                self.submitRateAndReview()
            }else {
                self.checkContactPermission()
            }
        }
    }
}

// MARK:-
// MARK:- Alert popUp Configuration

extension RateAndReviewOfferViewController {
    
    func alertPopUpConfiguration()  {
        
        vWAlertView.CViewSetWidth(width: CScreenWidth)
        vWAlertView.CViewSetHeight(height: CScreenHeight)
        vWAlertChildView.layer.cornerRadius = 5
        vWAlertChildView.layer.masksToBounds = true
    }
}

// MARK:-
// MARK:- Prefilled Data

extension RateAndReviewOfferViewController {
    
    fileprivate func prefilledData() {
        
        if let merchant  =  iObject as? MerchantDetails{
            self.merchant = merchant
            print(merchant.referralCode ?? "")
            lblMerchantName.text = merchant.name
            lblTagline.text = merchant.tagLine
            lblReview.text = "(\(merchant.noOfRating ?? "0"))"
            lblDistance.text = "(\(merchant.distance ?? "0") mi)"            
            lblReferredDate.text = ""
            lblRatingCount.text = "\(merchant.avgRating?.toFloat ?? 0.0)"
            vWMerchantRating.setRating(merchant.avgRating?.toFloat ?? 0.0)
            lblAvailableStoreCredit.text = "Available Store Credit : \(appDelegate!.currency)\(merchant.storeCredit ?? "0")"
            
            imgVMerchant.imageWithUrl(merchant.logo)
            imgVMerchant.touchUpInside { (imageView) in
                self.fullScreenImage(imageView, urlString: merchant.logo)
            }
            
            lblConditionTitle.isHidden = true
            
            if isFromRate {
                
                if let offerDetails = merchant.offers?.filter({$0.offerType == .RateAndReview}).first{
                    
                    lblExpireDate.text = "Expires on: \(offerDetails.expiryDate?.dateFromString ?? "-")"
                    
                    if let subOffer = offerDetails.subOffer?.filter({$0.subOfferType == .RateAndReview}).first {
                        
                        lblCondition.text = subOffer.conditions
                        lblOfferType.text = subOffer.categoryName
                        lblConditionTitle.isHidden = lblCondition.text!.isBlank
                        
                        if subOffer.subOfferCategory == .InStore {
                            lblOfferValue.text = ""
                            btnOfferType.setImage(subOffer.exclusiveImage, for: .normal)
                            
                        }else {
                            lblOfferValue.text = "\(appDelegate!.currency)\(subOffer.amount ?? "0")"
                        }
                    }
                }
            } else {
                
                if let offerDetails = merchant.offers?.filter({$0.offerType == .Referral}).first{
                    
                    lblExpireDate.text = "Expires on: \(offerDetails.expiryDate?.dateFromString ?? "-")"
                    
                    if let subOffer = offerDetails.subOffer?.filter({$0.subOfferType == .Referral}).first {
                        
                        lblCondition.text = subOffer.conditions
                        lblConditionTitle.isHidden = (lblCondition.text?.isBlank)!
                        
                        if subOffer.subOfferCategory == .InStore {
                            lblOfferType.text = subOffer.categoryName
                            lblOfferValue.text = ""
                            btnOfferType.setImage(subOffer.exclusiveImage, for: .normal)
                            
                        }else {
                            lblOfferType.text = subOffer.categoryName
                            lblOfferValue.text = "\(appDelegate!.currency)\(subOffer.amount ?? "0")"
                            referalloffered = lblOfferValue.text!
                        }
                    }else {
                        lblOfferType.isHidden = true
                        lblOfferValue.isHidden = true
                        btnOfferType.isHidden = true
                    }
                }
            }
        }
    }
}
// MARK:-
// MARK:- Server request

extension RateAndReviewOfferViewController {
    
    fileprivate func submitRateAndReview(){
        
        var param = [String : Any]()
        param["merchant_id"] =  merchant?.id
        param["rating"] = vWRate.rating.toString
        param["product_name"] =  txtItemName.text
        param["review"] = txtVReview.text
        
        let data = (productImage != nil ? UIImageJPEGRepresentation(productImage!, imageComprassRatio) : nil)
        
        APIRequest.shared().rateAndReviewMerchant(param, imgProfileData: data) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    
                    if let offerDetailsVC =  CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
                        offerDetailsVC.iObject = data
                        offerDetailsVC.qrDetailsType = .ReviewOffer
                        if self.block != nil {
                            offerDetailsVC.setBlock(block: self.block!)
                        }
                        self.navigationController?.pushViewController(offerDetailsVC, animated: true)
                    }
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: "message"))
                    
                }
            }
        }
    }
    fileprivate func sendContactsOnServer(contacts : [Any]){
        
        var param = [String : Any]()
        param["contact_list"] =  contacts
        
        APIRequest.shared().sendContactsOnServer(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                var param = [String : Any]()
                param["merchant_id"] =  self.merchant?.id
                param["rating"] = self.vWRate.rating.toString
                param["product_name"] =  self.txtItemName.text
                param["review"] = self.txtVReview.text
                
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    
                    param["smarket_contact_list"] = data["smarket_contact_list"]
                    //                    if let arrSmarketContact = data["smarket_contact_list"] as? [[String:Any]] {
                    //
                    //                         var arrMobileNo = arrSmarketContact.map { $0.valueForString(key: "number") }
                    //
                    //                            arrMobileNo = arrMobileNo.map{$0.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)}
                    //
                    //                        //param["smarket_contact_list"] = "\(arrMobileNo.joined(separator: ","))"
                    //
                    //                    }
                    // self.viewRefer?.isHidden = false
                    
//                    self.presentPopUp(view: self.vWAlertView, shouldOutSideClick: false, type: .center) {
//
//                    }
                    
                    if let recommendVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RecommendToFriendsViewController") as? RecommendToFriendsViewController {
                        recommendVC.isRefer = true
                        recommendVC.merchandID = (self.merchant?.id)!
                        recommendVC.merchandName = (self.merchant?.name)!
                        recommendVC.ratting = self.vWRate.rating.toString
                        recommendVC.isReferralSMS = (self.merchant?.referral_sms)!
                        recommendVC.referMessage = (self.merchant?.referralmessage)!
                       // recommendVC.referralCode = (CUserDefaults.value(forKey: "referral_code") as! String)
                        self.navigationController?.pushViewController(recommendVC, animated: true)
                    }
                        
                    self.btninvite.touchUpInside(genericTouchUpInsideHandler: { (sender) in
                        self.dismissPopUp(view: self.vWAlertView, completionHandler: nil)
                        if let arrOtherContact = data["other_contact_list"] as? [Any], arrOtherContact.count > 0 {
                            if let friendListVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FriendListVC") as? FriendListVC {
                                friendListVC.navigation = .referral
                                friendListVC.iObject = contacts
                                param["product_img"] = self.productImage
                                friendListVC.params = param
                                friendListVC.merchant = self.merchant
                                self.navigationController?.pushViewController(friendListVC, animated: true)
                            }
                        }
                    })
                    self.btnSkip.touchUpInside(genericTouchUpInsideHandler: { (sender) in
                        
                        param.removeValue(forKey: "product_img")
                        if let arrSmarketContact = data["smarket_contact_list"] as? [[String:Any]] {
                            
                            var arrMobileNo = arrSmarketContact.map { $0.valueForString(key: "number") }
                            
                            arrMobileNo = arrMobileNo.map{$0.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)}
                            
                            param["smarket_contact_list"] = "\(arrMobileNo.joined(separator: ","))"
                            
                        }
                        self.submitRateAndReferNow(params: param)
                        self.dismissPopUp(view: self.vWAlertView, completionHandler: nil)
                    })
                }
            }
        }
    }
    fileprivate func submitRateAndReferNow(params : [String:Any]){
        
        let data = (productImage != nil ? UIImageJPEGRepresentation(productImage!, imageComprassRatio) : nil)
        
        APIRequest.shared().rateAndReferMerchant(params, imgProfileData: data) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    
                    if let offerDetailsVC =  CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
                        offerDetailsVC.iObject = data
                        offerDetailsVC.qrDetailsType = .ReferOffer
                        if self.block != nil {
                            offerDetailsVC.setBlock(block: self.block!)
                        }
                        self.navigationController?.pushViewController(offerDetailsVC, animated: true)
                    }
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: "message"))
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Methods

extension RateAndReviewOfferViewController {
    
    fileprivate func isValidationPassed() -> Bool {
        
        if vWRate.rating == 0.0 {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankRating, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
        /* else if (productImage == nil) {
         
         self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankProductPicture, btnOneTitle: CBtnOk, btnOneTapped: nil)
         
         return false
         
         } */
        return true
    }
    fileprivate func checkContactPermission() {
        SwiftyContacts.shared.requestAccess(true) { (granted) in
            if granted {
                SwiftyContacts.shared.fetchContacts(ContactsSortorder: .givenName) { (result) in
                    switch result {
                    case .Success(response: let contacts):
                        // Filter out unwanted contacts before sending them to the server
                        let filteredContacts = contacts.filter { self.shouldIncludeContact($0) }
                        
                        print("Filtered Contacts Count: \(filteredContacts.count)")
                        
                        if var arrContactList = SwiftyContacts.shared.convertContactListToArray(filteredContacts) as? [[String : Any]] {
                            DispatchQueue.main.async {
                                self.sendContactsOnServer(contacts: arrContactList)
                            }
                        }
                    case .Error(error: let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    
    func shouldIncludeContact(_ contact: CNContact) -> Bool {
        
        //            guard !contact.givenName.isEmpty || !contact.familyName.isEmpty
        //            else {
        //                    // If the contact has no name, exclude it
        //                print("Checking contact1: \(contact.givenName) \(contact.familyName)")
        //                    return false
        //                }
        //            print("Checking contact2: \(contact.givenName) \(contact.familyName)")
        //            return true // Modify this based on your criteria
        //        }
        
        guard let firstCharacter = contact.givenName.first else {
            // If the contact has no given name, exclude it
            return false
        }
        
        // Check if the first character is a letter
        let isLetter = firstCharacter.isLetter
        
        // Include the contact if the first character is a letter
        return isLetter
    }
    
}
