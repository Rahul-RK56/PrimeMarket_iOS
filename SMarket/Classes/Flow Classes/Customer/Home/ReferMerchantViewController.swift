//
//  ReferMerchantViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 02/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ReferMerchantViewController: ParentViewController {
    
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtMobileNo : UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    
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
        self.title = "REFER MERCHANT"
        
        txtCountryCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
        }, defaultPlaceholder:  "")
        
        txtCountryCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnAllSetClicked(_ sender : UIButton) {
        
        if isValidationPassed() {
            referMerchant()
        }
    }
}

// MARK:-
// MARK:- Server request

extension ReferMerchantViewController {
    
    fileprivate func referMerchant(){
        
        var param = [String : Any]()
        param["email"] = txtEmail.text ?? ""
        
        if !(txtMobileNo.text?.isBlank)! {
            param["country_code"] = txtCountryCode.text ?? ""
        }
        param["mobile"] = txtMobileNo.text ?? ""
        
        APIRequest.shared().referMerchant(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    self.showAlertView(meta.valueForString(key: "message"), completion: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Methods

extension ReferMerchantViewController {
    
    fileprivate func isValidationPassed() -> Bool {
        
        if !(txtEmail.text?.isBlank)! && !(txtEmail.text!.isValidEmail) {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        } else if !(txtMobileNo.text?.isBlank)! && !(txtMobileNo.text!.isValidPhoneNo) {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtMobileNo.text?.isBlank)! && (txtCountryCode.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankCountryCode, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }else if (txtMobileNo.text!.isBlank) && (txtEmail.text!.isBlank) {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageMobileNoOrEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }
        
        return true
    }
}
