
//
//  CustomerLoginViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 19/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import KeychainSwift
import ReCaptcha
import RxCocoa
import RxSwift
import SDWebImage

@available(iOS 13.0, *)
class CustomerLoginViewController: ParentViewController {
    
    @IBOutlet var txtPhoneCode : UITextField!
    @IBOutlet var txtMobileNo : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var btnSignUp : UIButton!
    @IBOutlet var signInButtonStack : UIStackView!
    let keychain = KeychainSwift()
    
    var recaptcha = try? ReCaptcha()
    private var locale: Locale?
    private var endpoint = ReCaptcha.Endpoint.default
    private var disposeBag = DisposeBag()
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setUpSignInAppleButton()
        
        //        keychain.delete(UserDefaultAppleID)
        //        keychain.delete(UserDefaultAppleName)
        //        keychain.delete(UserDefaultAppleEmail)
        setupReCaptcha()
    }
    
    func didPressButton() {
        disposeBag = DisposeBag()
        
        recaptcha!.rx.didFinishLoading
            .debug("did finish loading")
            .subscribe()
            .disposed(by: disposeBag)
        
        let validate = recaptcha!.rx.validate(on: view, resetOnError: false)
            .catchError { error in
                return .just("Error \(error)")
        }
        .debug("validate")
        .share()
        
        validate
            .map { [weak self] _ in
                self?.view.viewWithTag(123)
        }
        .subscribe(onNext: { subview in
            self.loginAction()
            subview?.removeFromSuperview()
        })
            .disposed(by: disposeBag)
        
    }
    func setupReCaptcha() {
        // swiftlint:disable:next force_try
        recaptcha = try! ReCaptcha(endpoint: endpoint, locale: locale)
        
        recaptcha!.configureWebView { [weak self] webview in
            webview.frame = self?.view.bounds ?? CGRect.zero
            webview.tag = 123
            
        }
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
    }
    
    func signApple(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.isCustomerLogin = true
        
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
        
        
        txtPhoneCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            
        }, defaultPlaceholder:  "")
        txtMobileNo.text = CUserDefaults.value(forKey: UserDefaultCustomerLoginMobile) as? String ?? ""
        //        txtPhoneCode.text = CUserDefaults.value(forKey: UserDefaultCustomerLoginPostalCode) as? String ?? "+1"
        txtPhoneCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        attributedSignUp()  
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction private func btnLoginClicked(_ sender : UIButton) {
      if IS_SIMULATOR {
                  
                  if (txtMobileNo.text?.isBlank)! {
                      txtMobileNo.text = "9974004501"
                      txtPhoneCode.text = "+91"
                  }
                  if (txtPassword.text?.isBlank)! {
                      txtPassword.text = "mind123"
                  }
              }
              if isValidationPassed() {
                  loginWithUserInfo()
              }
    }
    
    func loginAction(){
        if IS_SIMULATOR {
            
            if (txtMobileNo.text?.isBlank)! {
                txtMobileNo.text = "9974004501"
                txtPhoneCode.text = "+91"
            }
            if (txtPassword.text?.isBlank)! {
                txtPassword.text = "mind123"
            }
        }
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
        
        if let forgotVC = CLRF_SB.instantiateViewController(withIdentifier: "CustomerForgotPasswordViewController") as? CustomerForgotPasswordViewController {
            self.navigationController?.pushViewController(forgotVC, animated: true)
        }
    }
    @IBAction func btnSigninGoogleClick(_ sender: Any) {
        
        //        if let country = CUserDefaults.value(forKey: UserDefaultCancel) {
        //            if country as! String == "Cancel" {
        //                if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
        //                    self.navigationController?.pushViewController(signUpVC, animated: true)
        //                }
        //            }
        //        }
        //        else{
        SharedManager.shared.isGoogleSignin = true
        googleLogin()
        //        }
    }
    func customerSignUp() {
        
        var countryCode = "+1"
        if let country = CUserDefaults.value(forKey: UserDefaultCountry) {
            if  country as! String == "India" {
                countryCode = "+91"
            }else{
                countryCode = "+1"
            }
        }
        
        var param = [String : Any]()
        
        let userIdentifier = keychain.get(UserDefaultAppleID) ?? ""
        let fullName = keychain.get(UserDefaultAppleName) ?? ""
        let email = keychain.get(UserDefaultAppleEmail) ?? ""
        
        param["name"]                       = fullName
        param["country_code"]               = countryCode
        param["email"]                      = email
        param["mobile"]                     = ""
        param["referral_code"]              = ""
        param["password"]                   = ""
        param["login_type"]  = "2"
        param["verification_mail"]  = "0"
        param["google_id"]  = userIdentifier
        
        APIRequest.shared().registerCustomerUser(param, imgProfileData: nil ) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let _ = json[CJsonMeta] as? [String : Any] {
                    if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                        if let json = response as? [String : Any]{
                            APIRequest.shared().saveLoginUserToLocal(responseObject: json as [String : AnyObject])
                            appDelegate?.signInCustomerUser(animated: true)
                        }
                    }
                }
            }
        }
    }
}
// MARK:-
// MARK:- Google sign in

@available(iOS 13.0, *)
extension CustomerLoginViewController : GIDSignInDelegate {
    
    fileprivate func googleLogin() {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            print("\(error.localizedDescription)")
            if error.localizedDescription == "The user canceled the sign-in flow."{
                CUserDefaults.set("Cancel", forKey: UserDefaultCancel)
                CUserDefaults.synchronize()
            }
            return
        }
        
        let param = ["name": user.profile.name!,
                     "email": user.profile.email!,
                     "socialId": user.userID!,
                     "type":"2",
                     "imageUrl":user?.profile.imageURL(withDimension: 600).absoluteString ?? ""] as [String : Any]
        
        loginWithGoogle(param, apple: false)
    }
}

// MARK:-
@available(iOS 13.0, *)
extension CustomerLoginViewController {
    
    fileprivate func loginWithUserInfo() {
        
        let param = ["country_code": txtPhoneCode.text ?? "",
                     "mobile": txtMobileNo.text ?? "",
                     "password": txtPassword.text ?? ""]
        
        APIRequest.shared().loginCustomer(param) { (response, error) in
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    switch meta.valueForInt(key: CJsonStatus) {
                        
                    case CStatusZero:
                        
                        if let data = json[CJsonData] as? [String : Any] {
                            CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginUserID)
                        }
                        
                        CUserDefaults.setValue(meta.valueForString(key: "token"), forKey: UserDefaultLoginUserToken)
                        CUserDefaults.set(meta.valueForString(key: "country_code"), forKey: UserDefaultCountryCode)
                        
                        CUserDefaults.synchronize()
                        
                        appDelegate?.signInCustomerUser(animated: true)
                        
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
                        self.showAlertView(CMessageOTPResend, completion: { (action) in
                            
                            if let verifyMobileVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyMobileNumberViewController") as? VerifyMobileNumberViewController {
                                verifyMobileVC.iObject = param
                                self.present(UINavigationController(rootViewController: verifyMobileVC), animated: true, completion: nil)
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

@available(iOS 13.0, *)
extension CustomerLoginViewController {
    fileprivate func loginWithGoogle(_ data : [String : Any]?,apple : Bool) {
        
        if let userInfo = data {
            print(userInfo.valueForString(key: "country") ,"country")
            let param = ["email_id": userInfo.valueForString(key: "email"),
                         "google_id": userInfo.valueForString(key: "socialId")]
           
            APIRequest.shared().loginWithCustomerSocial(param) { (response, error) in
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if meta.valueForInt(key: CJsonStatus) == CStatusZero { // Login to user
                        
                        APIRequest.shared().saveLoginUserToLocal(responseObject: response as! [String : AnyObject])
                        
                        appDelegate?.signInCustomerUser(animated: true)
                        
                    } else {
                        if apple {
                            self.customerSignUp()
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
    private func attributedSignUp(){
        
        //        let strSignUp = "NEW TO SMARKET? SIGN UP"
        let strSignUp = "DON'T HAVE GOOGLE ACCOUNT? SIGN UP HERE"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorBlack_000000,
                                        NSAttributedStringKey.font : CFontPoppins(size: IS_iPhone_5 ? 11 : IS_iPhone_6_Plus ? 15 : 13, type: .Regular)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorCustomerAppTheme,
                                        NSAttributedStringKey.font : CFontPoppins(size: IS_iPhone_5 ? 11 : IS_iPhone_6_Plus ? 15 : 13, type: .Regular),
                                        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue], range:strSignUp.rangeOf("SIGN UP HERE"))
        
        btnSignUp.setAttributedTitle(attributedString, for: .normal)
    }
    
    fileprivate func isValidationPassed() -> Bool {
        
        //        if IS_SIMULATOR {
        //            return true
        //        }
        
        if (txtPhoneCode.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankCountryCode, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if (txtMobileNo.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
        else if !(txtMobileNo.text!.isValidPhoneNo) {

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        }
        else if (txtPassword.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
        
        return true
    }
}
@available(iOS 13.0, *)
extension CustomerLoginViewController : ASAuthorizationControllerDelegate{
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
            let param = ["name": fullName ,
                         "email": email ,
                         "socialId":userIdentifier,
                         "type":"2",
                         "imageUrl":""] as [String : Any]
            
            loginWithGoogle(param, apple: true)
            //            }else{
            //                presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "Update stop using apple ID in settings and restart the app", btnOneTitle: "Ok") { (action) in
            //                }
            //            }
        }
    }
}
