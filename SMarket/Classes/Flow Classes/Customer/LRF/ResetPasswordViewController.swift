//
//  ResetPasswordViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ResetPasswordViewController: ParentViewController {

    @IBOutlet weak var txtOTP : UITextField!
    @IBOutlet weak var txtNewPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var btnSubmit : UIButton!
    
    
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
        
        self.title = "RESET PASSWORD"
        
        btnSubmit.backgroundColor = (appDelegate?.isCustomerLogin)! ? ColorCustomerAppTheme : ColorMerchantAppTheme
        
    }
    
    // MARK:-
    // MARK:- Action Event
    
    @IBAction fileprivate func btnUpdateClicked(_ sender:UIButton) {
        
        if isValidationPassed() {
            
            if (appDelegate?.isCustomerLogin)! { // customer
                forgotCustomer()
            }
            else {
                forgotMerchant()
            }
        }
    }
}


// MARK:-
// MARK:- Server Request

extension ResetPasswordViewController {
   
    fileprivate func forgotMerchant() {
        
        let dic = iObject as! [String : Any]
        
        let email = dic.valueForString(key: "email")
        
        let param = ["email": email ,
                     "password": txtNewPassword.text ?? "",
                     "otp": txtOTP.text ?? ""]
        
        APIRequest.shared().merchantResetPassword(param) { (response, error) in
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
    
    fileprivate func forgotCustomer() {
        
        let dic = iObject as! [String : Any]
        
        let cCode = dic.valueForString(key: "country_code")
        let mobile = dic.valueForString(key: "mobile")
        
        let param = ["country_code": cCode ,
                     "mobile" : mobile ,
                     "password": txtNewPassword.text ?? "",
                     "otp": txtOTP.text ?? ""]
        
        APIRequest.shared().customerResetPassword(param) { (response, error) in
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    self.navigationController?.popToRootViewController(animated: true)
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Method

extension ResetPasswordViewController {
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtOTP.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOTP, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        } else if (txtNewPassword.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankNewPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        } else if !(txtNewPassword.text?.isValidPassword)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidNewPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        } else if (txtConfirmPassword.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankconfirmPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        }   else if txtConfirmPassword.text != txtNewPassword.text {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidNewPasswordMismatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        }
        return true
    }
}
