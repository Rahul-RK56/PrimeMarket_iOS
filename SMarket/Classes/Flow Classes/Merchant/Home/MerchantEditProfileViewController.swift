//
//  MerchantEditProfileViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 12/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MerchantEditProfileViewController: ParentViewController {
    
    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var txtBussnessName : UITextField!
    @IBOutlet weak var txtTagline : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPhoneCode : UITextField!
    @IBOutlet weak var txtMobileNo : UITextField!
    @IBOutlet weak var txtWebsite : UITextField!
    @IBOutlet weak var txtCategory : UITextField!
    @IBOutlet weak var txtAddress : UITextField!
    @IBOutlet weak var txtVDescription : UITextView!
    @IBOutlet weak var txtVProductAndServices : UITextView!
    @IBOutlet weak var txtvAddress: UITextView!
    @IBOutlet weak var vwAddress: UIView!
    var userProfileImage : UIImage?
    var selectedCategory : TBLCategory?
    var locationInfo : [String : Any]?
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "EDIT PROFILE"
        
        vwAddress.layer.cornerRadius = 8
        vwAddress.layer.masksToBounds = true
        txtvAddress.layer.cornerRadius = 8
        txtvAddress.layer.masksToBounds = true
        vwAddress.CViewSetWidth(width: 240/375*CScreenWidth)
        vwAddress.CViewSetHeight(height: 115/375*CScreenWidth)
        
        textFieldConfiguration()
        prefilledInfo()
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnUpdateClicked(_ sender : UIButton) {
        
        if isValidationPassed() {
           editProfileApi()
        }
    }
    
    @IBAction func btnAddressOkClicked(_ sender: UIButton) {
        self.dismissPopUp(view: vwAddress) {
            self.txtAddress.text = self.txtvAddress.text
        }
    }
    
    @IBAction fileprivate func btnChangeProfilePicClicked(_ sender : UIButton) {
        
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            
            if image != nil {
                self.imgVProfile.image = image
                self.userProfileImage = image
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
                    }else {
                        self.txtAddress.text = ""
                    }
                })
            }
        })
    }
}

// MARK:-
// MARK:- Server request

extension MerchantEditProfileViewController {
    
    fileprivate func editProfileApi(){
        
        var param = [String : Any]()
        
        param["business_name"]              = txtBussnessName.text
        param["email"]                      = txtEmail.text?.trim
        param["country_code"]               = txtPhoneCode.text
        param["mobile"]                     = txtMobileNo.text
        param["website"]                    = txtWebsite.text
        param["business_category_id"]       = selectedCategory?.cat_id
        param["address"]                    = txtAddress.text
        
        if !(txtTagline.text?.isBlank)! {
            param["tag_line"]     = txtTagline.text
        }
        if let locationInfo = locationInfo {
            param["latitude"]     = locationInfo.valueForString(key: "latitude")
            param["longitude"]    = locationInfo.valueForString(key: "longitude")
            param["post_code"]    = locationInfo.valueForString(key: "postalCode")
        }
        param["description"]                = txtVDescription.text
        param["product_and_services"]       = txtVProductAndServices.text
        
        let data = (userProfileImage != nil ? UIImageJPEGRepresentation(userProfileImage!, imageComprassRatio) : nil)
        
        APIRequest.shared().editProfileMerchant(param, imgProfileData: data) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if let homeVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "HomeMerchantViewController") as? HomeMerchantViewController {
                        appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
                        appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                    }
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Method

extension MerchantEditProfileViewController {
    
    
    fileprivate func prefilledInfo(){
        
        txtBussnessName.text = appDelegate?.loginUser?.name
        txtTagline.text = appDelegate?.loginUser?.tag_line
        txtEmail.text = appDelegate?.loginUser?.email
        txtAddress.text = appDelegate?.loginUser?.address
        txtWebsite.text = appDelegate?.loginUser?.website
        txtCategory.text = appDelegate?.loginUser?.business_category?.name
        txtPhoneCode.text = appDelegate?.loginUser?.country_code
        txtMobileNo.text = appDelegate?.loginUser?.mobile
        txtVDescription.text = appDelegate?.loginUser?.desc
        txtVProductAndServices.text = appDelegate?.loginUser?.product_and_services
        selectedCategory = appDelegate?.loginUser?.business_category
        imgVProfile.imageWithUrl(appDelegate?.loginUser?.picture)
        locationInfo = ["latitude"  : appDelegate?.loginUser?.latitude ?? "",
                        "longitude" : appDelegate?.loginUser?.longitude ?? "",
                        "postalCode" : appDelegate?.loginUser?.post_code ?? ""]
        txtEmail.textColor = ColorGray_A8A8A8
        
    }
    
    fileprivate func textFieldConfiguration() {
        
        txtPhoneCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            
        }, defaultPlaceholder:  "")
        
        txtPhoneCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        txtPhoneCode.text = "+1"
        
        txtCategory.setPickerData(arrPickerData:arrCategory.compactMap({$0.name}), selectedPickerDataHandler: { (value, index, component) in
            
            self.selectedCategory = self.arrCategory[index]
            
        }, defaultPlaceholder: "")
        
        txtCategory.addRightImage(strImgName: "dropdown", padding: 16, imageContentMode: .Left)
        txtAddress.addRightImage(strImgName: "location", padding: 12, imageContentMode: .Left)
        
        txtVDescription.setCharLimit(charLimit: 100)
        txtVProductAndServices.setCharLimit(charLimit: 100)
        
    }
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtBussnessName.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankBusinessName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtBussnessName.text?.isValidAlphabets)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidBusinessName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }/* else if (txtTagline.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankTagline, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }*/ else if (txtEmail.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtEmail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } /*else if !(txtMobileNo.text?.isBlank)! && (txtPhoneCode.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankCountryCode, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }  else if (txtMobileNo.text?.isBlank)! && !(txtPhoneCode.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } */else if  !(txtMobileNo.text?.isBlank)! && !(txtMobileNo.text!.isValidPhoneNo) {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidMobileNo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }  else if (txtCategory.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankBusinessCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        } else if (txtAddress.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankBusinessAddress, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }  else if (txtVProductAndServices.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankProductServices, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
        }
        return true
    }
}
