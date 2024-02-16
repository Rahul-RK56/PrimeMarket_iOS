//
//  CustomerForgotPasswordViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 20/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class CustomerForgotPasswordViewController: ParentViewController {

    @IBOutlet var txtPhoneCode : UITextField!
    @IBOutlet var txtMobileNo : UITextField!
    
    
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         if let country = CUserDefaults.value(forKey: UserDefaultCountry) {
             if  country as! String == "India" {
                 txtPhoneCode.text = "+91"
             }else{
                 txtPhoneCode.text = "+1"
             }
         }
         else{
             txtPhoneCode.text = "+1"
         }
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "FORGOT PASSWORD"
        
        txtPhoneCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            
        }, defaultPlaceholder:  "")
        
        txtPhoneCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        txtPhoneCode.text = "+1"
        
    }

    // MARK:-
    // MARK:- Action Event
    
    @IBAction fileprivate func btnSendCodeClicked(_ sender:UIButton) {
        
        if isValidationPassed() {
            forgotPassword()
        }
    }
}

// MARK:-
// MARK:- Server Request
extension CustomerForgotPasswordViewController {
    
    fileprivate func forgotPassword() {
        
        let param = ["mobile": txtMobileNo.text ?? "",
                     "country_code" : txtPhoneCode.text ?? ""]
        
        APIRequest.shared().forgotPasswordWithMobile(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    switch meta.valueForInt(key: CJsonStatus) {
                        
                    case CStatusZero:
                        if let resetVC = CLRF_SB.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
                            resetVC.iObject = param
                            self.navigationController?.pushViewController(resetVC, animated: true)
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                        }
                    case CStatusFour:
                        
                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: meta.valueForString(key: "message"), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            
                        }, btnTwoTitle: "Verify Now", btnTwoTapped: { (action) in
                            self.resendOTPMobile()
                        })
                        
                    default:
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                    }
                    
                }
            }
        }
    }
    
    fileprivate func resendOTPMobile() {
        
        let param = ["country_code": txtPhoneCode.text ?? "",
                     "mobile": txtMobileNo.text ?? ""]
        
        APIRequest.shared().resendMobileOTP(param) { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                        if let verifyMobileVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyMobileNumberViewController") as? VerifyMobileNumberViewController {
                            verifyMobileVC.iObject = param
                            self.present(UINavigationController(rootViewController: verifyMobileVC), animated: true, completion: nil)
                        }
                    }
                    else {
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                    }
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Method

extension CustomerForgotPasswordViewController {
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtPhoneCode.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankCountryCode, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if (txtMobileNo.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        } else if !(txtMobileNo.text!.isValidPhoneNo) {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
        return true
    }
    
}
