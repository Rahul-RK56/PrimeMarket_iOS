//
//  MerchantForgotPasswordViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 20/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MerchantForgotPasswordViewController: ParentViewController {

    @IBOutlet var txtEmail : UITextField!
    
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
        
        self.title = "FORGOT PASSWORD"
    }
    
    // MARK:-
    // MARK:- Action Event
    
    @IBAction fileprivate func btnSubmitClicked(_ sender:UIButton) {
        
        if isvalidationPassed() {
            forgotPassword()
        }
    }
}

// MARK:-
// MARK:- Server Request
extension MerchantForgotPasswordViewController {
    
    fileprivate func forgotPassword() {
        
        let param = ["email": txtEmail.text!.trim]
 
        APIRequest.shared().forgotPasswordWithEmail(param) { (response, error) in
            
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
                            self.resendOTP()
                        })
                       
                    default:
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                    }
                    
                }
            }
        }
    }
    
    fileprivate func resendOTP() {
        
        let param = ["email": txtEmail.text!.trim] as [String : Any]
        
        APIRequest.shared().resendEmailOTP(param) { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    self.showAlertView(meta.valueForString(key: CJsonMessage), completion: { (action) in
                        
                        if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                            verifyEmailVC.iObject = param
                            verifyEmailVC.fromVC = "FORGOT"
                            self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                        }
                    })
                    
                }
            }
        }
    }
}
// MARK:-
// MARK:- Helper method

extension MerchantForgotPasswordViewController {
    
    fileprivate func isvalidationPassed() -> Bool {
        
        if (txtEmail.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        } else if !(txtEmail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        }
        
        return true
    }
}
