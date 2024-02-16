//
//  MerchantLeftViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import GoogleSignIn

class MerchantLeftViewController: ParentViewController {
    
    var arrMenu : [[String : Any]]?
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    
    
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
        
        arrMenu = [["icon" : #imageLiteral(resourceName: "home"),
                    "name": "Home"],
                   ["icon" : #imageLiteral(resourceName: "changes_password"),
                    "name":"Change Password"],
                  /* ["icon" : #imageLiteral(resourceName: "notification"),
                    "name":"Notifications"], */
                   ["icon" : #imageLiteral(resourceName: "faq"),
                    "name":"FAQs"],
                   ["icon" : #imageLiteral(resourceName: "info"),
                    "name":"How to use the App"],
                   ["icon" : #imageLiteral(resourceName: "terms"),
                    "name":"Terms & Conditions"],
                   ["icon" : #imageLiteral(resourceName: "privacy"),
                    "name":"Privacy Policy"],
                   ["icon" : #imageLiteral(resourceName: "info"),
                    "name":"About Us"],
                   ["icon" : #imageLiteral(resourceName: "contctsus"),
                    "name":"Contact Us"],
                   ["icon" : #imageLiteral(resourceName: "merchant"),
                    "name":"Login as Customer"],
                   ["icon" : #imageLiteral(resourceName: "logout"),
                    "name":"Logout"]]
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(notification:)), name: Notification.Name(RefreshSideMenuNotification), object: nil)
        
        reloadData(notification: nil)
    }
    
    
    @objc func reloadData(notification: Notification?){
        
        refreshUserInfo()
        loadUserDetailsFromServer()
    }
    
    fileprivate func refreshUserInfo(){
        
        lblName.text = appDelegate?.loginUser?.name
        imgView.imageWithUrl(appDelegate?.loginUser?.picture)
        
//        imgView.touchUpInside { (imageView) in
//            self.fullScreenImage(imageView, urlString: appDelegate?.loginUser?.picture)
//        }
        tblView.reloadData()
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnEditClicked(_ sender : UIButton) {
        
        if let editProfileVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "MerchantEditProfileViewController") as? MerchantEditProfileViewController {
            editProfileVC.view.tag = 200
            appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: editProfileVC)
            appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
        }
    }
    
    
}

// MARK:-
// MARK:- Server request

extension MerchantLeftViewController {
    
    fileprivate func loadUserDetailsFromServer() {
      
        APIRequest.shared().loadUserDetails() { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                self.refreshUserInfo()
            }
        }
    }
}

// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension MerchantLeftViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let dict = arrMenu?[indexPath.row] {
            
            switch indexPath.row {
                
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuRefCashTableViewCell") as? SideMenuRefCashTableViewCell {
                    
                    cell.lblName.text = dict.valueForString(key: "name")
                    cell.lblCash.text = appDelegate?.loginUser?.notification ?? "0"
                    cell.vwContainer.layer.borderWidth = 0
                    cell.imgIcon.image = dict.valueForImage(key:"icon")
                    cell.vwCash.hide(byWidth: cell.lblCash.text == "0")
                    return cell
                }
                
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCustomerSimpleTableViewCell") as? SideMenuCustomerSimpleTableViewCell {
                    
                    cell.lblName.text = dict.valueForString(key: "name")
                    cell.imgIcon.image = dict.valueForImage(key:"icon")
                    return cell
                }                    
            }
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: // Home
            
            if let homeVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "HomeMerchantViewController") as? HomeMerchantViewController {
                homeVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
            
            
        case 1: // Change Password
            
           if let changePasswordVC = CLRF_SB.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                changePasswordVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: changePasswordVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
            
      /*  case 2: // Notifications
            
            if let notificationVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                notificationVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: notificationVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            } */    
        case 2: // FAQs
            
            if let FAQVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FAQViewController") as? FAQViewController {
                FAQVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: FAQVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 3: // How to use the App
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
        
                if let dict = CUserDefaults.value(forKey: UserDefaultHowToUseApp)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                CMSVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: CMSVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 4: // Terms & Conditions
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
            
                if let dict = CUserDefaults.value(forKey: UserDefaultTermsConditionandPrivacyPolicy)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                CMSVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: CMSVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 5: // Privacy Policy
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
               
                if let dict = CUserDefaults.value(forKey: UserDefaultPrivacyPolicy)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                CMSVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: CMSVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 6: // About Us
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                
                if let dict = CUserDefaults.value(forKey: UserDefaultAboutus)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                CMSVC.view.tag = 200    
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: CMSVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
            
        case 7: // Contact Us
            
            if let dict = CUserDefaults.value(forKey: UserDefaultContactUs)  as? [String : Any]{
                
                let email = dict.valueForString(key: "cms_desc").htmlToString
                if !email.isBlank {
                    appDelegate?.openMailComposer(self, email: email)
                }
            }
            
        case 8: // Login as Customer
            
            DispatchQueue.main.async {
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                    CUserDefaults.set(appDelegate?.loginUser?.email, forKey: UserDefaultMerchantLoginEmail)
                    appDelegate?.loginAsCustomerUser(response: nil)
                    
                }, btnTwoTitle: CBtnNo) { (action) in
                    
                }
            }
            
        case 9: // Logout
            
            DispatchQueue.main.async {
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: "LOG OUT", btnOneTapped: { (action) in
                    CUserDefaults.set(appDelegate?.loginUser?.email, forKey: UserDefaultMerchantLoginEmail)
                    appDelegate?.signOutMerchantUser(response: nil)
                    GIDSignIn.sharedInstance().signOut()
                }, btnTwoTitle: "CANCEL") { (action) in}
            }
            
        default:
            break
        }
    }
}

