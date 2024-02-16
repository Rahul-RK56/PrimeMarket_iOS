//
//  MerchantLoginViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 19/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import KeychainSwift


class MerchantLoginViewController: ParentViewController {
    
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var btnSignUp : UIButton!
    @IBOutlet var signInButtonStack : UIStackView!
   
    
    let keychain = KeychainSwift()
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setUpSignInAppleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.isCustomerLogin = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        txtEmail.text = CUserDefaults.value(forKey: UserDefaultMerchantLoginEmail) as? String ?? ""
        attributedSignUp()
        
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction private func btnLoginClicked(_ sender : UIButton) {
        
        if isValidationPassed() {
            loginWithUserInfo()
        }
    }
    @IBAction private func btnSignUpClicked(_ sender : UIButton) {
        
        if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    @IBAction private func btnForgotPasswordClicked(_ sender : UIButton) {
        
        if let forgotVC = CLRF_SB.instantiateViewController(withIdentifier: "MerchantForgotPasswordViewController") as? MerchantForgotPasswordViewController {
            self.navigationController?.pushViewController(forgotVC, animated: true)
        }
    }
    
    @IBAction func btnSigninGoogleClick(_ sender: Any) {
        SharedManager.shared.isGoogleSignin = false
        googleLogin()
    }
     func MerchantSignUp() {
            
            var countryCode = "+1"
            if let country = CUserDefaults.value(forKey: UserDefaultCountry) {
                if  country as! String == "India" {
                    countryCode = "+91"
                }else{
                    countryCode = "+1"
                }
            }
            
            var param = [String : Any]()
            
            let userIdentifier = keychain.get(UserDefaultAppleID)
            let fullName = keychain.get(UserDefaultAppleName) ?? ""
            let email = keychain.get(UserDefaultAppleEmail) ?? ""
            let description = keychain.get(UserDefaultAboutus)
             
            param["business_name"]              = fullName
            param["name"]              = fullName
            param["email"]                      = email
            param["country_code"]               = countryCode
            param["mobile"]                     = ""
            param["website"]                    = fullName + ".com"
            param["business_category_id"]       = ""
            param["address"]                    = ""
            param["description"]                = ""
            param["product_and_services"]       = ""
            param["password"]                   = "Colan1234567"
             param["tag_line"]     = ""
             // param["google_id"]  = userIdentifier
    //        if !(txtMertTagline.text?.isBlank)! {
    //                    param["tag_line"]     = ""
    //                }
            //        if let locationInfo = locationInfo {
                        //            param["latitude"]     = locationInfo.valueForString(key: "latitude")
                        //            param["longitude"]    = locationInfo.valueForString(key: "longitude")
                        //            param["post_code"]    = locationInfo.valueForString(key: "postalCode")
                        param["latitude"]     =   appDelegate?.lat ?? ""
                        param["longitude"]    =  appDelegate?.long ?? ""
                    //    param["post_code"]    = txtMertZip.text ?? ""
            //        }
            

            

                    if let userInfo = iObject as? [String : Any] {
                        param["login_type"]  = "2"
                        param["verification_mail"]  = "0"
                    param["google_id"]  = userInfo.valueForString(key: "socialId")
                      //  param["google_id"] = keychain.get(UserDefaultAppleID)
                     //  param["google_id"] = userIdentifier
                    }
                    else{
                        param["login_type"]  = "1"
                        param["verification_mail"]  = "1"
                      //  param["google_id"]  = userIdentifier

                    }
        
          APIRequest.shared().registerMerchantUser(param, imgProfileData: nil) { (response, error) in
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        switch meta.valueForInt(key: CJsonStatus) {

                            case CStatusZero:

//                            if let data = json[CJsonData] as? [String : Any] {
//                                CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginUserID)
//
//                            }
                            
                            if let data = json[CJsonData] as? [String : Any] {
                                CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginMerchantID)
                            }
                            
                                CUserDefaults.setValue(meta.valueForString(key: "token"), forKey: UserDefaultLoginUserToken)
                                CUserDefaults.synchronize()
                            if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                                verifyEmailVC.iObject = email
                                verifyEmailVC.fromVC = "LOGIN"
                                self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                                }
                            APIRequest.shared().saveLoginUserToLocal(responseObject: json as [String : AnyObject])
                            // appDelegate?.signInMerchantUser(animated: true)

                            case CStatusFour:

                            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: meta.valueForString(key: "message"), btnOneTitle: CBtnOk, btnOneTapped: { (action) in

                            }, btnTwoTitle: "Verify Now", btnTwoTapped: { (action) in
                            self.resendOTPEmail()
                            })

                            default:
                            self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                        }
//                        if APIRequest.shared().isJSONStatusValid(withResponse: response) {
//                            if let json = response as? [String : Any]{
//
//                                APIRequest.shared().saveLoginUserToLocal(responseObject: json as [String : AnyObject])
//                                appDelegate?.signInMerchantUser(animated: true)
//                              //  appDelegate?.signInCustomerUser(animated: true)
//                            }
//                        }
                    }
                }
            }
        }
    
}

// MARK:-
// MARK:- Google sign in

extension MerchantLoginViewController : GIDSignInDelegate {
    
    fileprivate func googleLogin() {
      
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        UIApplication.shared.endIgnoringInteractionEvents()
        
        guard error == nil else {
            print("\(error.localizedDescription)")
            return
        }
        
        let param = ["email": user.profile.email!,
                     "socialId": user.userID!,
                     "type":"2",
                     "imageUrl":user?.profile.imageURL(withDimension: 600).absoluteString ?? ""] as [String : Any]
        
        
        loginWithGoogle(param, apple:  true)
    }
    func setUpSignInAppleButton() {
              
           if #available(iOS 13.0, *) {
               let authorizationButton = ASAuthorizationAppleIDButton()
               authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
               authorizationButton.cornerRadius = 5
               //Add button on some view or stack
               self.signInButtonStack.addArrangedSubview(authorizationButton)
            
           } else {
               // Fallback on earlier versions
           }
           
       }
       
       @objc func handleAppleIdRequest() {
           
           let userIdentifier = keychain.get(UserDefaultAppleID) ?? ""
           if userIdentifier.count > 0{
               print("result: \(userIdentifier)")
            if #available(iOS 13.0, *) {
                let appleIDProviderExist = ASAuthorizationAppleIDProvider()
                appleIDProviderExist.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                        DispatchQueue.main.async {
                            switch credentialState {
                            case .authorized:
                                print("authorized")
                                self.authAppleUser()
                                break
                            case .revoked:
                                print("revoked")
                                self.signApple()
                                break
                            case .notFound:
                                print("not found")
                                self.signApple()
                                break
                            default:
                                break
                            }
                        }
                    }
                }else{
                    signApple()
                }
            } else {
                // Fallback on earlier versions
            }
               
       }
    func signApple(){
        
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            if #available(iOS 13.0, *) {
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self as! ASAuthorizationControllerDelegate
                        authorizationController.performRequests()
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
         
         
        
     }
    func authAppleUser(){
        //
        //        let email = keychain.get(UserDefaultAppleEmail) ?? ""
        //
        //        if(email.count > 0){
        let param = ["name": keychain.get(UserDefaultAppleName) ?? "" ,
                     "email": keychain.get(UserDefaultAppleEmail) ?? "" ,
                     "socialId":keychain.get(UserDefaultAppleID) ?? "",
                     "type":"2",
                     "imageUrl":""] as [String : Any]
        loginWithGoogle(param, apple: true)
       
        //        }else{
        //            presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "Update stop using apple ID in settings and restart the app", btnOneTitle: "Ok") { (action) in
        //            }
        //        }
    }
   
}

// MARK:-
// MARK:- Server Request

extension MerchantLoginViewController {
    
    fileprivate func loginWithGoogle(_ data : [String : Any]?,apple : Bool) {
        
        if let userInfo = data {
            
            let param = ["email": userInfo.valueForString(key: "email"),
                         "google_id": userInfo.valueForString(key: "socialId")]
            
           
            APIRequest.shared().loginWithSocial(param) { (response, error) in

                if APIRequest.shared().isJSONDataValid(withResponse: response) {

                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {

                        if meta.valueForInt(key: CJsonStatus) == CStatusZero { // Login to user

                            APIRequest.shared().saveLoginUserToLocal(responseObject: response as! [String : AnyObject])

                           appDelegate?.signInMerchantUser(animated: true)

                        } else if meta.valueForInt(key: CJsonStatus) == CStatusTen {
                            
                            if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
                                signUpVC.iObject = userInfo
                                self.navigationController?.pushViewController(signUpVC, animated: true)
                            }
                        }else if meta.valueForInt(key: CJsonStatus) == CStatusFour {
                            
                            if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
                                signUpVC.iObject = userInfo
                                self.navigationController?.pushViewController(signUpVC, animated: true)
                            }
                        }else {
                            if apple {

                                self.MerchantSignUp()
                            }else{
                                if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
                                    signUpVC.iObject = userInfo
                                    self.navigationController?.pushViewController(signUpVC, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    fileprivate func loginWithUserInfo() {
        
        let param = ["email": txtEmail.text?.trim ?? ""]
       
        APIRequest.shared().loginWithNormal(param) { (response, error) in
            if APIRequest.shared().isJSONDataValid(withResponse: response) {

                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {

                    switch meta.valueForInt(key: CJsonStatus) {

                    case CStatusZero:

//                        if let data = json[CJsonData] as? [String : Any] {
//                            CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginUserID)
//                        }
                        
                        if let data = json[CJsonData] as? [String : Any] {
                            CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginMerchantID)
                        }
                        
                        CUserDefaults.setValue(meta.valueForString(key: "token"), forKey: UserDefaultLoginUserToken)
                        CUserDefaults.synchronize()
                        if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                            verifyEmailVC.iObject = param
                            verifyEmailVC.fromVC = "LOGIN"
                            self.navigationController?.pushViewController(verifyEmailVC, animated: true)
//                            self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                        }

                      // appDelegate?.signInMerchantUser(animated: true)

                    case CStatusFour:

                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: meta.valueForString(key: "message"), btnOneTitle: CBtnOk, btnOneTapped: { (action) in

                        }, btnTwoTitle: "Verify Now", btnTwoTapped: { (action) in
                            self.resendOTPEmail()
                        })

                    default:
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                        
                        print("Rahul", CJsonMessage)
                    }

                }
            }
        }
    }
    
    fileprivate func resendOTPEmail() {
        
        let param = ["email": txtEmail.text!.trim] as [String : Any]
        
        APIRequest.shared().resendEmailOTP(param) { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                        self.showAlertView(CMessageOTPResend, completion: { (action) in
                            
                            if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                                verifyEmailVC.iObject = param
                                self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                            }
                        })
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

extension MerchantLoginViewController {
    
    private func attributedSignUp(){
        
        let strSignUp = "NEW TO SMARKET? SIGN UP"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorBlack_000000,
                                        NSAttributedStringKey.font : CFontPoppins(size: IS_iPhone_5 ? 11 : IS_iPhone_6_Plus ? 15 : 13, type: .Regular)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorMerchantAppTheme,
                                        NSAttributedStringKey.font : CFontPoppins(size: IS_iPhone_5 ? 11 : IS_iPhone_6_Plus ? 15 : 13, type: .Regular),
                                        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue], range:strSignUp.rangeOf("SIGN UP"))
        
        btnSignUp.setAttributedTitle(attributedString, for: .normal)
    }
    
    fileprivate func isValidationPassed() -> Bool {
        
//        if IS_SIMULATOR {
//            return true
//        }
        
        if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        } else if !(txtEmail.text?.isValidEmail)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        /*else if (txtPassword.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
      */  return true
    }
}

@available(iOS 13.0, *)
extension MerchantLoginViewController : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            var fullName = appleIDCredential.fullName?.givenName ?? ""
            var email = appleIDCredential.email ?? ""
            
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            keychain.set(userIdentifier, forKey: UserDefaultAppleID)
            
            if (email.count == 0){
                email = keychain.get(UserDefaultAppleEmail) ?? ""
            }
            else{
                keychain.set(email, forKey: UserDefaultAppleEmail)
            }
            
            if (fullName.count == 0){
                fullName = keychain.get(UserDefaultAppleName) ?? ""
            }
            else{
                keychain.set(fullName, forKey: UserDefaultAppleName)
            }
            
            //            if(email.count > 0){
          
            

            let param = ["name": fullName ?? "" ,
                                "email": email ?? "" ,
                                "socialId": userIdentifier ?? "",
                                "type":"2",
                                "imageUrl":""] as [String : Any]
        loginWithGoogle(param, apple:  true)
           
            //            }else{
            //                presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "Update stop using apple ID in settings and restart the app", btnOneTitle: "Ok") { (action) in
            //                }
            //            }
        }
    }
}
