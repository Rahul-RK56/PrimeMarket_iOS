//
//  VerifyMobileNumberViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 10/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class VerifyMobileNumberViewController: ParentViewController {
    
    @IBOutlet weak var txtPhoneCode : UITextField!
    @IBOutlet weak var txtMobileNumber : UITextField!
    @IBOutlet weak var lblMobileNumber : UILabel!
    
    @IBOutlet weak var vwEdit : UIView!
    
    @IBOutlet weak var txtOTP : UITextField!
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var btnResendOtp : UIButton!
    
    var selectedCountryCode = ""
    
    
    var isverified = false
    
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
        
        self.title = "VERIFY MOBILE NUMBER"
        vwEdit.layer.cornerRadius = 10
        vwEdit.layer.masksToBounds = true
        vwEdit.CViewSetWidth(width: 294/375*CScreenWidth)
        vwEdit.CViewSetHeight(height: 180/375*CScreenWidth)
        
        txtPhoneCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            self.selectedCountryCode = value
        }, defaultPlaceholder:  "")
        
        txtPhoneCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        
        if let dict = iObject as? [String : Any] {
            
            lblMobileNumber.text = dict.valueForString(key: "country_code") + " " + dict.valueForString(key: "mobile")
            self.txtPhoneCode.text = dict.valueForString(key: "country_code")
            self.txtMobileNumber.text = dict.valueForString(key: "mobile")
        }
    }
    
    // MARK:-
    // MARK:- Action Event
    
    @IBAction fileprivate func btnVerifyNowClicked(_ sender:UIButton) {
        
        
        if isverified {
            
            if let VC = CMainMerchant_SB.instantiateViewController(withIdentifier: "HomeMerchantViewController") as? HomeMerchantViewController {
                
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        } else {
            isverified = true
            loginWithUserInfo()
        }
        
        
        
        if isValidationOtp() {
            verifyOTP()
        }
    }
    @IBAction fileprivate func btnResendClicked(_ sender:UIButton) {
        resendOTPMobile()
    }
    
    @IBAction fileprivate func btnEditClicked(_ sender:UIButton) {
        resignKeyboard()
        if let data = iObject as? [String : Any] {
            
            self.presentPopUp(view: vwEdit, shouldOutSideClick: true, type: .center) {
                
                if (self.txtPhoneCode.text?.isBlank)! {
                    self.txtPhoneCode.text = data.valueForString(key: "country_code")
                    
                }
                if (self.txtMobileNumber.text?.isBlank)! {
                    self.txtMobileNumber.text = data.valueForString(key: "mobile")
                    
                }
            }
        }
        
    }
    @IBAction fileprivate func btnUpdateClicked(_ sender:UIButton) {
        resignKeyboard()
        if isValidationMobile() {
            self.dismissPopUp(view: vwEdit) {
                
                let newString = self.txtPhoneCode.text! + " " + self.txtMobileNumber.text!
                if  newString != self.lblMobileNumber.text {
                    self.lblMobileNumber.text = newString
                    self.updateMobileNo()
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Method

extension VerifyMobileNumberViewController {
    
    
    fileprivate func isValidationOtp() -> Bool {
        
        if (txtOTP.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOTP, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
    
    fileprivate func isValidationMobile() -> Bool {
        
        if (txtMobileNumber.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        } else if !(txtMobileNumber.text!.isValidPhoneNo) {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
        return true
    }
}

// MARK:-
// MARK:- Server Request

extension VerifyMobileNumberViewController {
    
    fileprivate func verifyOTP () {
        
        if let data = iObject as? [String : Any] {
            
            let param = ["country_code": data.valueForString(key: "country_code"),
                         "mobile": data.valueForString(key:"mobile"),
                         "otp" : txtOTP.text ?? ""]
            
            APIRequest.shared().varifyMobileOTP(param) { (response, error) in
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any]{
                        
                        APIRequest.shared().saveLoginUserToLocal(responseObject: json as [String : AnyObject])
                        appDelegate?.signInCustomerUser(animated: true)
                        
                    }
                }else{
                    let meta = response![CJsonMeta] as? [String : Any]
                    self.showAlertView(meta!.valueForString(key: CJsonMessage), completion: nil)
                    
                }
            }
        }
        
    }
    
    fileprivate func resendOTPMobile() {
        
        if let data = iObject as? [String : Any] {
            
            let param = ["country_code": data.valueForString(key: "country_code"),
                         "mobile": data.valueForString(key:"mobile")]
            
            APIRequest.shared().resendMobileOTP(param) { (response, error) in
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                            self.showAlertView(CMessageOTPResend, completion: nil)
                        }
                        else {
                            self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                        }
                    }
                }
            }
        }
    }
    

    
    fileprivate func loginWithUserInfo() {
        
        let param = ["email": emailId]
        
        APIRequest.shared().loginWithNormal(param) { (response, error) in
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    switch meta.valueForInt(key: CJsonStatus) {
                        
                    case CStatusZero:
                        
                        if let data = json[CJsonData] as? [String : Any] {
                            CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginMerchantID)
                        }
                        
                        CUserDefaults.setValue(meta.valueForString(key: "token"), forKey: UserDefaultLoginUserToken)
                        CUserDefaults.synchronize()
                        self.isverified = true
                        if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                            verifyEmailVC.iObject = param
                            verifyEmailVC.fromVC = "LOGIN"
                            self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                        }
                        
                        // appDelegate?.signInMerchantUser(animated: true)
                        
                    case CStatusFour:
                        
                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: meta.valueForString(key: "message"), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            
                        }, btnTwoTitle: "Verify Now", btnTwoTapped: { (action) in
                            //                            self.resendOTPEmail()
                        })
                        
                    default:
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                        
                        print("Rahul", CJsonMessage)
                    }
                    
                }
            }
        }
    }
    
    fileprivate func updateMobileNo() {
        
        if let data = iObject as? [String : Any] {
            
            let param = ["old_country_code": data.valueForString(key: "country_code"),
                         "old_mobile": data.valueForString(key:"mobile") ,
                         "new_country_code": txtPhoneCode.text ?? "",
                         "new_mobile": txtMobileNumber.text ?? ""]
            
            APIRequest.shared().editMobileNo(param) { (response, error) in
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    self.iObject = ["country_code":self.txtPhoneCode.text!,
                                    "mobile":self.txtMobileNumber.text!]
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        let msg = meta.valueForString(key: CJsonMessage)
                        self.showAlertView( msg, completion: { (action) in
                            
                        })
                    }
                }
            }
        }
    }
}
