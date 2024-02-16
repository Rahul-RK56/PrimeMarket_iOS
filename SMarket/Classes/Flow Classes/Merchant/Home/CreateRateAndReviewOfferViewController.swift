//
//  CreateRateAndReviewOfferViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 13/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class CreateRateAndReviewOfferViewController: ParentViewController {
    
    @IBOutlet weak var txtOfferType : UITextField!
    @IBOutlet weak var txtAmountTitle : UITextField!
    @IBOutlet weak var txtExpireDate : UITextField!
    @IBOutlet weak var txtVCondition : UITextView!
    
    var selectedOfferCategory : OfferCategory?
    var offerDetails : Offer?
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "CREATE RATE & REVIEW OFFER"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(btnInfoClicked))
        textfieldConfiguration()
        fillOfferDetails()
        
        if CUserDefaults.value(forKey: UserDefaultHOWTOCREATEOFFER) == nil {
            btnInfoClicked(UIBarButtonItem())
            CUserDefaults.setValue(1, forKey:UserDefaultHOWTOCREATEOFFER)
            CUserDefaults.synchronize()
        }
    }
    
    fileprivate func fillOfferDetails(){
        
        if let offer = offerDetails {
            
            if let subOffer = offer.subOffer?.first {
                
                selectedOfferCategory = subOffer.subOfferCategory
                switch selectedOfferCategory{
                case .GiftCard?:
                    txtOfferType.text = "Gift Card"
                    txtAmountTitle.text = subOffer.amount
                    txtAmountTitle.keyboardType = .decimalPad
                    txtAmountTitle.placeholder = "Amount"
                    
                case .InStore?:
                    txtOfferType.text = "Over the counter"
                    txtAmountTitle.text = subOffer.title
                    txtAmountTitle.keyboardType = .default
                    txtAmountTitle.placeholder = "Title"
                    
                case .StoreCredit?:
                    txtOfferType.text = "Store Credit"
                    txtAmountTitle.text = subOffer.amount
                    txtAmountTitle.keyboardType = .decimalPad
                    txtAmountTitle.placeholder = "Amount"
                    
                default:
                    txtOfferType.text = ""
                    txtAmountTitle.text = ""
                }
                
                txtVCondition.text = subOffer.conditions
                txtExpireDate.text = offer.expiryDate?.dateFromString
            }
        } 
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnInfoClicked(_ sender : UIBarButtonItem) {
        
        if CUserDefaults.value(forKey: UserDefaultHOWTOCREATEOFFER) == nil {
            CUserDefaults.setValue(1, forKey:UserDefaultHOWTOCREATEOFFER)
            CUserDefaults.synchronize()
            self.presentAlertViewWithOneButton(alertTitle: CMessageHowToUseAppTitle, alertMessage: CMessageHowToUseAppDetails, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
        } else {
            self.presentAlertViewWithOneButton(alertTitle: CMessageRateReviewTitle, alertMessage: CMessageRateReviewDetails, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        
        
        
    }
    
    @IBAction fileprivate func btnNextClicked(_ sender : UIButton) {
        
        if isValidationPassed() {
            
            
            var subOfferDict = [String : Any]()
            var param = [String : Any]()
            param["offer_type"] = OfferType.RateAndReview.rawValue
            param["expiry_date"] = txtExpireDate.text
            
            subOfferDict["sub_offer_type"] = SubOfferType.RateAndReview.rawValue
            subOfferDict["sub_offer_category"] = selectedOfferCategory?.rawValue
            subOfferDict["conditions"] = txtVCondition.text
            
            if selectedOfferCategory == .InStore {
                subOfferDict["title"] = txtAmountTitle.text
            } else {
                subOfferDict["amount"] = txtAmountTitle.text
            }
           
            if offerDetails == nil {
                param["sub_offer"] = [subOfferDict]
                offerDetails = Offer(object:param)
            }else {
                
                if let subOffer  = offerDetails?.subOffer?.first {
                    subOfferDict["id"] = subOffer.id
                    subOfferDict["parent_id"] = subOffer.parentId
                }
                param["sub_offer"] = [subOfferDict]
                offerDetails?.updateValues(object: param)
            }
            
            if let previewVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "OfferPreviewViewController") as? OfferPreviewViewController {
                previewVC.offerPreview = offerDetails
                self.navigationController?.pushViewController(previewVC, animated: true)
            }
        }        
    }
    
    @IBAction fileprivate func btnRedemptionClicked(_ sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
}

// MARK:-
// MARK:- Helper Method


extension CreateRateAndReviewOfferViewController {
    
    fileprivate func textfieldConfiguration() {
        
        txtOfferType.addRightImage(strImgName: "dropdown", padding: 16, imageContentMode: .Left)
        txtExpireDate.addRightImage(strImgName: "date", padding: 14, imageContentMode: .Left)
        
        
        txtOfferType.setPickerData(arrPickerData: ["Gift Card","Over the counter","Store Credit"], selectedPickerDataHandler: { (selected, row, component) in
            
            let newOfferCategory = OfferCategory(rawValue: row + 1)
            
            if self.selectedOfferCategory != newOfferCategory{
                self.txtAmountTitle.text = ""
                self.selectedOfferCategory = newOfferCategory
            }
            
            if self.selectedOfferCategory == .InStore {
                self.txtAmountTitle.keyboardType = .default
                self.txtAmountTitle.placeholder = "Title"
            }else {
                
                self.txtAmountTitle.keyboardType = .decimalPad
                self.txtAmountTitle.placeholder = "Amount"
            }
            
        }, defaultPlaceholder: nil)
        
        txtExpireDate.setDatePickerWithDateFormate(dateFormate: displayDateFormate, defaultDate: Date(), isPrefilledDate: true) { (date) in
            
        }
        
        txtExpireDate.setDatePickerMode(mode: .date)
        txtExpireDate.setMinimumDate(minDate: Date())
       
        txtVCondition.setCharLimit(charLimit: 150)
    }
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtOfferType.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOffer, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        } else if (txtAmountTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage:selectedOfferCategory == .InStore ? CMessageBlankTitle :CMessageBlankAmount, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        } else if (txtExpireDate.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankExpiryDate, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        
        return true
    }
}


