//
//  RegisterViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 20/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleSignIn
import ReCaptcha
import RxCocoa
import RxSwift

var emailText = ""


class RegisterViewController: ParentViewController, MyAddressDelegateProtocol {
    
    
    
    @IBOutlet var vWCustomerSignUp : UIView!
    @IBOutlet var vWMerchantSignUp : UIView!
    @IBOutlet var viewSwitch : UIView!
    @IBOutlet var viewTopLine : UIView!
    
    @IBOutlet var swtch :UISwitch!
    
    @IBOutlet var imgVProfile : UIImageView!
    
    @IBOutlet var lblCustomer : UILabel!
    @IBOutlet var lblMerchant : UILabel!
    
    @IBOutlet var txtCustName : UITextField!
    @IBOutlet var txtCustEmail : UITextField!
    @IBOutlet var txtCustPhoneCode : UITextField!
    @IBOutlet var txtCustMobileNo : UITextField!
    @IBOutlet var txtCustPassword : UITextField!
    @IBOutlet var txtCustConfirmPassword : UITextField!
    @IBOutlet var txtReferral : UITextField!
    
    @IBOutlet var txtMertBusinessName : UITextField!
    @IBOutlet var txtMertTagline : UITextField!
    @IBOutlet var txtMertEmail : UITextField!
    @IBOutlet var txtMertPhoneCode : UITextField!
    @IBOutlet var txtMertMobileNo : UITextField!
    @IBOutlet var txtMertPassword : UITextField!
    @IBOutlet var txtMertConfirmPassword : UITextField!
    @IBOutlet var txtMertWebsite : UITextField!
    @IBOutlet var txtMertCategory : UITextField!
    @IBOutlet var txtMertAddress : UITextField!
    @IBOutlet var txtMertAddress2 : UITextField!
    @IBOutlet var txtMertCity : UITextField!
    @IBOutlet var txtMertState : UITextField!
    @IBOutlet var txtMertZip : UITextField!
    
    @IBOutlet var txtVMertDescription : UITextView!
    @IBOutlet var txtVMertProduct : UITextView!
    
    @IBOutlet weak var txtvAddress: UITextView!
    @IBOutlet weak var vwAddress: UIView!
    
    @IBOutlet weak var constantTopReferTxt: NSLayoutConstraint!
    
    @IBOutlet weak var btnGoogleSignUp: UIButton!
    
    @IBOutlet var cnBottomVCustomer : NSLayoutConstraint!
    @IBOutlet var cnBottomVMerchant : NSLayoutConstraint!
    
    
    @IBOutlet weak var submitmerchantBtn: LRFGenericButton!
    var userProfileImage : UIImage?
    var selectedCategory : TBLCategory?
    var locationInfo : [String : Any]?
    var adress1 = ""
    
    var recaptcha = try? ReCaptcha()
    private var locale: Locale?
    private var endpoint = ReCaptcha.Endpoint.default
    private var disposeBag = DisposeBag()
    var imagePicker = UIImagePickerController()
    
    fileprivate var arrCategory : [TBLCategory] {
        get {
            if let arrCat = TBLCategory.fetch(predicate:  NSPredicate(format: "status = 1"), orderBy: "name", ascending: true) as? [TBLCategory] {
                return arrCat
            }
            
            return []
        }
    }
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupReCaptcha()
    //    btnGoogleSignUp.isHidden = true
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
                subview?.removeFromSuperview()
                self.customerSignUp()
                
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtMertAddress.text = adress1
        if let country = CUserDefaults.value(forKey: UserDefaultCountry) {
            print(country , "country")
            if  country as! String == "India" {
                txtCustPhoneCode.text = "+91"
                txtMertPhoneCode.text = "+91"
            }else{
                txtCustPhoneCode.text = "+1"
                txtMertPhoneCode.text = "+1"
            }
        }
        else{
            txtCustPhoneCode.text = "+1"
            txtMertPhoneCode.text = "+1"
        }
        
        if (self.iObject as? [String : Any]) != nil {
            viewSwitch.isHidden = true
            self.title = "Update Profile"
            txtCustMobileNo.placeholder = "Mobile Number(Optional)"
            viewTopLine.isHidden = true
        }
      
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GIDSignIn.sharedInstance()?.signOut()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
   
   
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "SIGN UP"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCameraActionSheet))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        vwAddress.layer.cornerRadius = 8
        vwAddress.layer.masksToBounds = true
        txtvAddress.layer.cornerRadius = 8
        txtvAddress.layer.masksToBounds = true
        vwAddress.CViewSetWidth(width: 240/375*CScreenWidth)
        vwAddress.CViewSetHeight(height: 115/375*CScreenWidth)
        
        switchSignUp((appDelegate?.isCustomerLogin)!)
        
        //        imgVProfile.touchUpInside { (imageView) in
        //            self.presentImagePickerController(allowEditing: false,imagePickerControllerCompletionHandler: { (image, dict) in
        //
        //                if image != nil {
        //                    self.imgVProfile.image = image
        //                    self.userProfileImage = image
        //                }
        //
        //                if (appDelegate?.isCustomerLogin)! {
        //                    self.navigationController?.navigationBar.barTintColor = ColorCustomerAppTheme
        //                } else {
        //                    self.navigationController?.navigationBar.barTintColor =  ColorMerchantAppTheme
        //                }
        //            })
        //        }
        
        txtCustPhoneCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            
        }, defaultPlaceholder:  "")
        
        txtCustPhoneCode.text = "+1"
        
        txtMertPhoneCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            
        }, defaultPlaceholder:  "")
        txtMertPhoneCode.text = "+1"
        
        
        txtMertCategory.setPickerData(arrPickerData:arrCategory.compactMap({$0.name}), selectedPickerDataHandler: { (value, index, component) in
            
            self.selectedCategory = self.arrCategory[index]
            
        }, defaultPlaceholder: "")
        
        txtCustPhoneCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        txtMertPhoneCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        txtMertCategory.addRightImage(strImgName: "dropdown", padding: 16, imageContentMode: .Left)
                txtMertAddress.addRightImage(strImgName: "location", padding: 12, imageContentMode: .Left)
        
        txtVMertDescription.setCharLimit(charLimit: 100)
        txtVMertProduct.setCharLimit(charLimit: 100)
        
        if let userInfo = iObject as? [String : Any] {
            
            if !userInfo.valueForString(key: "email").isBlank {
                txtMertEmail.isUserInteractionEnabled = false
                txtMertEmail.textColor = ColorGray_A8A8A8
                txtCustEmail.isUserInteractionEnabled = false
                txtCustEmail.textColor = ColorGray_A8A8A8
            }
            txtMertEmail.text = userInfo.valueForString(key: "email")
            txtCustEmail.text = userInfo.valueForString(key: "email")
            txtCustName.text = userInfo.valueForString(key: "name")
            emailText = txtMertEmail.text ?? ""
            print(userInfo.valueForString(key: "country"))
            
            txtMertPassword.hide(byHeight: true)
            txtCustPassword.hide(byHeight: true)
            constantTopReferTxt.constant = -6
            if let imageUrl = userInfo.valueForString(key: "imageUrl").toURL {
                
                self.imgVProfile.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder.png"))
                let imgdata = NSData.init(contentsOf: imageUrl)
                let gimg = UIImage.init(data: imgdata! as Data)
                self.userProfileImage = gimg
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(txtAddresstapped))
        txtMertAddress.addGestureRecognizer(tap)
        txtMertAddress.isUserInteractionEnabled = true
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getDataSegue" {
            let secondVC: PlacePickerViewController = segue.destination as! PlacePickerViewController
            secondVC.delegate = self
           
        }
    }
    func sendDataToFirstViewController(myData: String) {
        
        self.txtvAddress.text = myData
       
    }
    @objc func txtAddresstapped() {
              
           self.gotoMapVC()
       }
    
    func gotoMapVC() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "LRF", bundle:nil)
        let mapVC = storyBoard.instantiateViewController(withIdentifier: "PlacePickerViewController") as! PlacePickerViewController
        mapVC.delegate = self
       
        self.navigationController?.pushViewController(mapVC, animated: true)
        //PlacePickerViewController
    }
    @objc func showCameraActionSheet(){
        let alert = UIAlertController(title: "Select", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.showCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Library", style: .default , handler:{ (UIAlertAction)in
            self.showLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: {
            })
        }
    }
    
    func showLibrary(){
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: {
        })
    }
    
    public override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgVProfile.image = image?.resizeImage(newSize: CGSize(width: 300, height: 300))
        self.userProfileImage =  imgVProfile.image
        self.dismiss(animated: true, completion: {
        })
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction func btnGoogleHandler(_ sender : UIButton) {
        googleLogin()
    }
    
    @IBAction fileprivate func btnSwitchClicked(_ sender : UIButton) {
        
        switchSignUp(swtch.isOn)
    }
    
    @IBAction fileprivate func btnSubmitClicked(_ sender : UIButton) {
        
        if swtch.isOn { // Merchant
            
            if isMerchantValidationPassed() {
                merchantSignUp()
            }
            
        } else { // Customer
            
         
            if isCustomerValidationPassed() {
                didPressButton()
            }
        }
    }
    
    @IBAction fileprivate func btnAddressClicked(_ sender : UIButton) {
        
        appDelegate?.openPlacePicker(self, complition: { (place) in
            
            if let place = place {
                
                appDelegate?.formattedAddress(place, completion: { (dictData) in
                    
                    if let info = dictData {
                        
                        self.presentPopUp(view: self.vwAddress, shouldOutSideClick: false, type: .center) {
                            
                            if info.valueForString(key: "fullAddress").isBlank {
                                self.txtvAddress.text = info.valueForString(key: "address")
                            }else {
                                self.txtvAddress.text = info.valueForString(key: "fullAddress")
                            }
                        }
                        self.locationInfo = info
                    } else {
                        self.txtMertAddress.text = ""
                        self.locationInfo = nil
                    }
                })
            }
        })
    }
    
    @IBAction func btnAddressOkClicked(_ sender: UIButton) {
        self.dismissPopUp(view: vwAddress) {
            self.txtMertAddress.text = self.txtvAddress.text
        }
    }
}

// MARK:-
// MARK:- Server request

extension RegisterViewController {
    
    fileprivate func merchantSignUp() {
        
        var param = [String : Any]()
      //  let address = "\(txtMertAddress.text ?? ""),\(txtMertAddress2.text ?? ""),\(txtMertCity.text ?? ""),\(txtMertState.text ?? ""),\(txtMertZip.text ?? "")"
        let address = "\(txtMertAddress.text ?? "")"
        param["business_name"]              = txtMertBusinessName.text?.trim
        param["email"]                      = txtMertEmail.text?.trim
        param["country_code"]               = txtMertPhoneCode.text
        param["mobile"]                     = txtMertMobileNo.text
        param["website"]                    = txtMertWebsite.text
        param["business_category_id"]       = selectedCategory?.cat_id
        param["address"]                    = address
        param["description"]                = txtVMertDescription.text
        param["product_and_services"]       = txtVMertProduct.text
        param["password"]                   = "12345a"
        
        if !(txtMertTagline.text?.isBlank)! {
            param["tag_line"]     = txtMertTagline.text
        }
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
        }
        else{
            param["login_type"]  = "1"
            param["verification_mail"]  = "1"
        }
        
        let data = (userProfileImage != nil ? UIImageJPEGRepresentation(userProfileImage!, imageComprassRatio) : nil)
        
        APIRequest.shared().registerMerchantUser(param, imgProfileData: data ) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                        
                        APIRequest.shared().saveLoginUserToLocal(responseObject: json as [String : AnyObject])
                        appDelegate?.isCustomerLogin = false
                        appDelegate?.signInMerchantUser(animated: true)
                        
                    } else {
                        
                        self.showAlertView(meta.valueForString(key: "message"), completion: { (action) in
                            
                            if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                                verifyEmailVC.iObject = json[CJsonData]
                                verifyEmailVC.fromVC = "REGISTER"
                                self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                            }
                        })
                    }
                }
            }else{
                let meta = response?[CJsonMeta] as? [String : Any]
                let alertMsg = meta?["message"] as? String ?? ""
                
              //  self.presentAlertViewWithOneButton(alertTitle: "ALert!", alertMessage: alertMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                
               }
            
        }
    }
    
    fileprivate func customerSignUp() {
        
        var param = [String : Any]()
        
        param["name"]                       = txtCustName.text?.trim
        param["country_code"]               = txtCustPhoneCode.text
        param["mobile"]                     = txtCustMobileNo.text
        param["referral_code"]              = txtReferral.text
        param["password"]                   = txtCustPassword.text
        
        if let userInfo = iObject as? [String : Any] {
            param["login_type"]  = "1"
            param["verification_mail"]  = "0"
            param["google_id"]  = userInfo.valueForString(key: "socialId")
            
          //  print(userInfo.valueForString(key: "imageURL") , "profilePicture")
        }
        else{
            param["login_type"]  = "1"
            param["verification_mail"]  = "1"
        }
        
        if !(txtCustEmail.text?.isBlank)! {
            param["email"]                  = txtCustEmail.text?.trim
        }
        
        let data = (userProfileImage != nil ? UIImageJPEGRepresentation(userProfileImage!, imageComprassRatio) : nil)
        
        print(data , "userProfileImage")
        
        APIRequest.shared().registerCustomerUser(param, imgProfileData: data ) { (response, error) in
            
            if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                
                if meta.valueForInt(key:CJsonStatus) == CStatusFour {
                    
                    self.showAlertView(meta.valueForString(key: "message"), completion: { (action) in
                        if self.txtCustMobileNo.text != ""{
                            if let verifyMobileVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyMobileNumberViewController") as? VerifyMobileNumberViewController {
                                verifyMobileVC.iObject = json[CJsonData]
                                self.present(UINavigationController(rootViewController: verifyMobileVC), animated: true, completion: nil)
                            }
                        }else{
                            APIRequest.shared().saveLoginUserToLocal(responseObject: json as [String : AnyObject])
                            appDelegate?.signInCustomerUser(animated: true)
                        }
                    })
                }
                else{
                    self.showAlertView(meta.valueForString(key: "message"), completion: nil)
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper

extension RegisterViewController {
    
    fileprivate func switchSignUp(_ isCustomer : Bool){
        
        appDelegate?.isCustomerLogin = isCustomer
        
        if isCustomer {
            print("customer")
            submitmerchantBtn.isHidden = true
            cnBottomVCustomer.priority = UILayoutPriority(rawValue: 999)
           // cnBottomVMerchant.priority = UILayoutPriority(rawValue: 998)
            vWCustomerSignUp.isHidden = false
            vWMerchantSignUp.isHidden = true
            imgVProfile.image = userProfileImage ?? #imageLiteral(resourceName: "uploadimage")
            swtch.setOn(false, animated: true)
            lblCustomer.textColor = .black
            lblMerchant.textColor = CRGB(r: 135, g: 137, b: 137)
            self.navigationController?.navigationBar.barTintColor = ColorCustomerAppTheme
            swtch.backgroundColor = ColorCustomerAppTheme
            swtch.layer.cornerRadius = swtch.CViewHeight/2
            swtch.layer.masksToBounds = true
        } else {
            print("Merchant")
            submitmerchantBtn.isHidden = false
            cnBottomVCustomer.priority = UILayoutPriority(rawValue: 998)
           // cnBottomVMerchant.priority = UILayoutPriority(rawValue: 999)
            vWCustomerSignUp.isHidden = true
            vWMerchantSignUp.isHidden = false
            imgVProfile.image = userProfileImage ?? #imageLiteral(resourceName: "image")
            swtch.setOn(true, animated: true)
            lblMerchant.textColor = .black
            lblCustomer.textColor =  CRGB(r: 135, g: 137, b: 137)
            self.navigationController?.navigationBar.barTintColor =  ColorMerchantAppTheme
            swtch.backgroundColor = .clear
        }
    }
    
    
    fileprivate func isCustomerValidationPassed() -> Bool {
        
        if (txtCustName.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtCustName.text?.isValidName)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtCustEmail.text?.isBlank)! && !(txtCustEmail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }
        else if (txtCustPhoneCode.text?.isBlank)!{

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankCountryCode, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false

        } else if (txtCustMobileNo.text?.isBlank)! && iObject == nil{

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        } else if !(txtCustMobileNo.text!.isValidPhoneNo) && iObject == nil{

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        } else if (txtCustPassword.text?.isBlank)! && iObject == nil {

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        } else if !(txtCustPassword.text?.isValidPassword)!  && iObject == nil{

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        } else if (txtCustConfirmPassword.text?.isBlank)!  && iObject == nil{

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankconfirmPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        } else if txtCustConfirmPassword.text != txtCustPassword.text && iObject == nil {

            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePasswordMismatch, btnOneTitle: CBtnOk, btnOneTapped: nil)

            return false
        }
        
        
        return true
    }
    
    fileprivate func isMerchantValidationPassed() -> Bool {
        
        
//        if userProfileImage == nil {
//
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankLogo, btnOneTitle: CBtnOk, btnOneTapped: nil)
//
//            return false
//
//        } else
        if (txtMertBusinessName.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankBusinessName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtMertBusinessName.text?.isValidAlphabets)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidBusinessName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }/* else if (txtMertTagline.text?.isBlank)! {
         
         self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankTagline, btnOneTitle: CBtnOk, btnOneTapped: nil)
         
         return false
         
         }*/ else if (txtMertEmail.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
         } else if !(txtMertEmail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
         }else if (txtMertMobileNo.text?.isBlank)! && iObject == nil{
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        } else if !(txtMertMobileNo.text!.isValidPhoneNo) && iObject == nil{
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
         
         
    
        
//        if !((txtMertMobileNo.text?.isEmpty) != nil)  && !(txtMertMobileNo.text!.isValidPhoneNo) {
//
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
//
//            return false
         
         else if (txtMertCategory.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankBusinessCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
         }
         
        /* else if (txtMertAddress.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankBusinessAddress, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
         } else if (txtVMertProduct.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankProductServices, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
         }*/
        
        /*if txtMertEmail.isUserInteractionEnabled {
            
            if (txtMertPassword.text?.isBlank)! {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                return false
            } else if !(txtMertPassword.text?.isValidPassword)! {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                return false
            } else if (txtMertConfirmPassword.text?.isBlank)! {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankconfirmPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                return false
            } else if txtMertConfirmPassword.text != txtMertPassword.text {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePasswordMismatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                return false
            }
        }*/
        return true
    }
}


// MARK:- Google sign in

extension RegisterViewController : GIDSignInDelegate {
    
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
        
        if error == nil{
            txtCustName.text = user.profile.name!
            txtCustEmail.text = user.profile.email!
            txtMertEmail.text = user.profile.email!
            txtMertBusinessName.text = user.profile.name!
            txtMertEmail.text = user.profile.email!
            
           
            
            imgVProfile.sd_setImage(with:URL(string: user?.profile.imageURL(withDimension: 400).absoluteString ?? "") ,placeholderImage: nil)
        }
    }
}

// MARK:-
// MARK:- Server Request
extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

