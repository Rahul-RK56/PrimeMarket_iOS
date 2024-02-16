//
//  EditProfileViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 10/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class EditProfileViewController: ParentViewController {
    
    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!
    @IBOutlet weak var txtMobileNo : UITextField!
    @IBOutlet weak var vwSeprator : UIView!
    
    var userProfileImage : UIImage?
    
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
        
        txtCountryCode.setPickerData(arrPickerData:self.getAllCountriesPhoneCode(), selectedPickerDataHandler: { (value, index, component) in
            
        }, defaultPlaceholder:  "")
        
        txtCountryCode.addRightImage(strImgName: "dropdown", padding: 6, imageContentMode: .Left)
        prefilledInfo()
        
        
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnUpdateClicked(_ sender : UIButton) {
        
        if isValidationPassed(){
            editProfileApi()
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
    
}

// MARK:-
// MARK:- Server request

extension EditProfileViewController {
    
    fileprivate func editProfileApi(){
        
        var param = [String : Any]()
        param["name"] = txtName.text?.trim ?? ""
        param["email"] = txtEmail.text?.trim ?? ""
        param["country_code"] =  txtCountryCode.text ?? ""
        param["mobile"] = txtMobileNo.text ?? ""
        
        let data = (userProfileImage != nil ? UIImageJPEGRepresentation(userProfileImage!, imageComprassRatio) : nil)
        
        APIRequest.shared().editProfileCustomer(param, imgProfileData: data) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
            
                    if let homeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController") as? HomeCustomerViewController {
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
// MARK:- Helper Methods

extension EditProfileViewController {
    
    fileprivate func prefilledInfo() {
        
        txtName.text = appDelegate?.loginUser?.name
        txtEmail.text = appDelegate?.loginUser?.email
        txtCountryCode.text = appDelegate?.loginUser?.country_code
        txtMobileNo.text = appDelegate?.loginUser?.mobile
        imgVProfile.imageWithUrl(appDelegate?.loginUser?.picture)
        
        txtMobileNo.textColor = ColorGray_A8A8A8
        txtCountryCode.textColor = ColorGray_A8A8A8
        vwSeprator.backgroundColor = ColorGray_A8A8A8
    }
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtName.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtName.text?.isValidName)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidName, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        } else if !(txtEmail.text?.isBlank)! && !(txtEmail.text?.isValidEmail)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            
            return false
            
        }
        return true
    }
}



