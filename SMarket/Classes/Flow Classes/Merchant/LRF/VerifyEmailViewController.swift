//
//  VerifyEmailViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 12/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class VerifyEmailViewController: ParentViewController {
    
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var lblEMail : UILabel!
    
    @IBOutlet weak var vwEdit : UIView!
    
    @IBOutlet weak var txtOTP : UITextField!
    @IBOutlet weak var btnResendOtp : UIButton!
    
    var fromVC = ""
    var isFromHomePage: Bool = false
    
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
        
        self.title = "VERIFY EMAIL ADDRESS"
        vwEdit.layer.cornerRadius = 10
        vwEdit.layer.masksToBounds = true
        vwEdit.CViewSetWidth(width: 294/375*CScreenWidth)
        vwEdit.CViewSetHeight(height: 180/375*CScreenWidth)
        
        
        
        if let dict = iObject as? [String : Any] {
            lblEMail.text = dict.valueForString(key:"email").trim
            print(lblEMail.text)
            print(dict)
        }
    }
    
    // MARK:-
    // MARK:- Action Event
    
    @IBAction fileprivate func btnVerifyNowClicked(_ sender:UIButton) {
        
        if isValidationOtp() {
            verifyOTP()
        }
    }
    
    @IBAction fileprivate func btnResendClicked(_ sender:UIButton)
    {
        if isValidationEmaillbl() {
            resendOTPEmail()
        }
    }
    
    @IBAction fileprivate func btnEditClicked(_ sender:UIButton) {
        
        resignKeyboard()
        self.presentPopUp(view: vwEdit, shouldOutSideClick: true, type: .center) {
            self.txtEmail.text = self.lblEMail.text?.trim
        }
    }
    @IBAction fileprivate func btnUpdateClicked(_ sender:UIButton) {
        resignKeyboard()
        if isValidationEmail() {
            
            self.dismissPopUp(view: vwEdit) {
                if self.lblEMail.text != self.txtEmail.text?.trim{
                    self.lblEMail.text = self.txtEmail.text?.trim
                    self.updateEmail()
                }
            }
        }
    }
}

// MARK:-
// MARK:- Server Request

extension VerifyEmailViewController {
    
    fileprivate func verifyOTP () {
        
        let param = ["email": lblEMail.text?.trim ?? "",
                     "otp" : txtOTP.text ?? ""]
        
        APIRequest.shared().varifyEmailOTP(param, fromVC: fromVC) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                print(response,"Rahullll")
                
                if let json = response as? [String : Any]{
                    APIRequest.shared().saveLoginUserToLocal(responseObject:json as [String : AnyObject])
                    //appDelegate?.signInMerchantUser(animated: true)
                    
                    
                    if self.isFromHomePage {
                        if let VC = CMainMerchant_SB.instantiateViewController(withIdentifier: "HomeMerchantViewController") as? HomeMerchantViewController {
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                        
                    } else {
                        self.navigateToInitialViewController()
                    }
                    print(json,"Rahul")
                    
                }
            }
        }
    }
    
    fileprivate func resendOTPEmail() {
        
        let param = ["email": lblEMail.text!.trim] as [String : Any]
        APIRequest.shared().resendEmailOTP(param) { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                }
            }
        }
    }
    
    fileprivate func updateEmail() {
        
        if let dict = iObject as? [String : Any] {
            
            var param = [String : Any]()
            param["new_email"] = self.txtEmail.text?.trim ?? ""
            param["old_email"] =  dict.valueForString(key:"email")
            
            APIRequest.shared().editEmail(param) { (response, error) in
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    self.iObject = ["email":self.lblEMail.text!.trim]
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        let msg = meta.valueForString(key: CJsonMessage)
                        self.showAlertView( msg, completion: nil)
                    }
                }
            }
        }
        
    }
}

// MARK:-
// MARK:- Helper Method

extension VerifyEmailViewController {
    
    fileprivate func isValidationOtp() -> Bool {
        
        if (txtOTP.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOTP, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
    
    fileprivate func isValidationEmail() -> Bool {
        
        if (txtEmail.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        } else if !(txtEmail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
    
    fileprivate func isValidationEmaillbl() -> Bool {
        
        if (lblEMail.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        } else if !(lblEMail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
        
    }
    private func navigateToInitialViewController() {
        
       // let initialViewController = UIStoryboard(name: "MainMerchant", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        //navigationController?.pushViewController(initialViewController, animated: true)
        
        appDelegate?.signInMerchantUser(animated: true)
    }
}
