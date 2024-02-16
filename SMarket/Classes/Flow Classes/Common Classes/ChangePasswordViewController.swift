//
//  ChangePasswordViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ParentViewController {

    @IBOutlet weak var txtOldPassword : UITextField!
    @IBOutlet weak var txtNewPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var btnUpdate : UIButton!
    
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
        self.title = "CHANGE PASSWORD"
        
        if (appDelegate?.isCustomerLogin)! {
            btnUpdate.backgroundColor = ColorCustomerAppTheme
        } else {
            btnUpdate.backgroundColor = ColorMerchantAppTheme
        }
        
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnUpdateClicked(_ sender : UIButton) {
        
        if isValidationPassed() {
            changePasswordApi()
        }
    }
}

// MARK:-
// MARK:- Server request

extension ChangePasswordViewController {
    
    fileprivate func changePasswordApi() {
        
        var param = [String : Any]()
        param["old_password"] = txtOldPassword.text
        param["new_password"] = txtNewPassword.text
        
        APIRequest.shared().changePassword(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                        
                        if (appDelegate?.isCustomerLogin)! {
                            self.navigationController?.popViewController(animated: true)
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                        
                        } else {
                            if let homeVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "HomeMerchantViewController") as? HomeMerchantViewController {
                                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
                                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                                MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                            }
                        }
                    }
                    else {
                        self.showAlertView(meta.valueForString(key: "message"), completion: nil)
                    }
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Method

extension ChangePasswordViewController {
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtOldPassword.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage:CMessageBlankOldPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
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
