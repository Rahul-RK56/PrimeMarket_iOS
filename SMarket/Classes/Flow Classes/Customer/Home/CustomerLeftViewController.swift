//
//  CustomerLeftViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class CustomerLeftViewController: ParentViewController {
    
    var arrMenu : [[String : Any]]?
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var btnContact : UIButton!
    
    let formatter = NumberFormatter()
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        
    }
    @IBAction func contactUsButtonHandler(){
        if let dict = CUserDefaults.value(forKey: UserDefaultContactUs)  as? [String : Any]{
            let email = dict.valueForString(key: "cms_desc").htmlToString
            if !email.isBlank {
                appDelegate?.openMailComposer(self, email: email)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(notification:)), name: Notification.Name(RefreshSideMenuNotification), object: nil)
        
        reloadData(notification: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let dict = CUserDefaults.value(forKey: UserDefaultContactUs)  as? [String : Any]{
            let email = dict.valueForString(key: "cms_desc").htmlToString
            if !email.isBlank {
                btnContact.setTitle("Contact us: \(email)", for: .normal)
            }
        }
    }
    @objc func reloadData(notification: Notification?){
        
        refreshUserInfo()
        loadUserDetailsFromServer()
    }
    
    fileprivate func refreshUserInfo(){
        if(appDelegate?.loginUser?.name == "<null>"){
            appDelegate?.loginUser?.name = ""
        }
        lblName.text = appDelegate?.loginUser?.name
        imgView.imageWithUrl(appDelegate?.loginUser?.picture)
//        imgView.touchUpInside { (imageView) in
//            self.fullScreenImage(imageView, urlString: appDelegate?.loginUser?.picture)
//        }
        sideMenuOption()
        tblView.reloadData()
    }
    
    fileprivate func sideMenuOption(){
        
        let refCash = formatter.number(from: appDelegate?.loginUser?.refcash ?? "0")
               
               let referalAlert = formatter.number(from: appDelegate?.loginUser?.refferal_alert ?? "0")
              
               let awaitingRewards = formatter.number(from: appDelegate?.loginUser?.awaiting_rewards ?? "0")
               
               let storeCredit = formatter.number(from: appDelegate?.loginUser?.store_credit ?? "0")
        
        arrMenu = [["icon" : #imageLiteral(resourceName: "ref_cash"),
                    "name":"RefCash",
                    "count":appDelegate?.loginUser?.refcash ?? "0"],
                   ["icon" : #imageLiteral(resourceName: "home"),
                    "name":"Home"],
                   ["icon" : #imageLiteral(resourceName: "shopping"),
                    "name":"SMarket Shopping",
                    "count":appDelegate?.loginUser?.refferal_alert ?? "0"],
                   ["icon" : #imageLiteral(resourceName: "merc_refferalAlerts"),
                    "name":"Refferral Alerts",
                    "count":appDelegate?.loginUser?.refferal_alert ?? "0"],
                   ["icon" : #imageLiteral(resourceName: "cust_awitinmg_rewards"),
                    "name":"Awaiting Rewards",
                    "count":appDelegate?.loginUser?.awaiting_rewards ?? "0"],
                   ["icon" : #imageLiteral(resourceName: "store_credits"),
                    "name":"Store Credits",
                    "count":"\(currencyUnit)\(appDelegate?.loginUser?.store_credit ?? "0") credit among all stores"],
                   ["icon" : #imageLiteral(resourceName: "myunclimed_offer"),
                    "name":"Redemption History"],
                   ["icon" : #imageLiteral(resourceName: "notification"),
                    "name":"Notifications",
                    "count":appDelegate?.loginUser?.notification ?? "0"],
                   ["icon" : #imageLiteral(resourceName: "recommed_offer"),
                    "name":"Recommend to Your Friends"],
                   ["icon" : #imageLiteral(resourceName: "setting"),
                    "name":"Settings"],
                   ["icon" : #imageLiteral(resourceName: "merchant"),
                    "name":"Login as Merchant"],
                   ["icon" : #imageLiteral(resourceName: "logout"),
                    "name":"Logout"]]
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnEditClicked(_ sender : UIButton) {
        
        if let editProfileVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            editProfileVC.view.tag = 200
            appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: editProfileVC)
            appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
        }
    }
    
    
}

// MARK:-
// MARK:- Server request

extension CustomerLeftViewController {
    
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

extension CustomerLeftViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let dict = arrMenu?[indexPath.row] {
            
            switch indexPath.row {
            case 0:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuRefCashTableViewCell") as? SideMenuRefCashTableViewCell {
                    cell.lblName.text = dict.valueForString(key: "name")
                    cell.lblCash.text = dict.valueForString(key: "count")
                    cell.imgIcon.image = dict["icon"] as? UIImage
                    return cell
                }
                
            case 4:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCustomerStoreCreditTableViewCell") as? SideMenuCustomerStoreCreditTableViewCell {
                    
                    cell.lblName.text = dict.valueForString(key: "name")
                    cell.lblCash.text = dict.valueForString(key: "count")
                    cell.imgIcon.image = dict["icon"] as? UIImage
                    return cell
                }
                
            case 1,8,9,5,10,11:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCustomerSimpleTableViewCell") as? SideMenuCustomerSimpleTableViewCell {
                    cell.lblName.text = dict.valueForString(key: "name")
                    cell.imgIcon.image = dict["icon"] as? UIImage
                    return cell
                }
                
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCustomerTableViewCell") as? SideMenuCustomerTableViewCell {
                    
                    cell.lblName.text = dict.valueForString(key: "name")
                    cell.lblCash.text = dict.valueForString(key: "count")
                    cell.vwCash.hide(byWidth: dict.valueForString(key: "count") == "0")
                    cell.imgIcon.image = dict["icon"] as? UIImage
                    return cell
                }
            }
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: // RefCash
            
            if let refCashVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RefcashViewController") as? RefcashViewController {
                refCashVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: refCashVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
            
            
        case 1: // Home
            
            if let homeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController") as? HomeCustomerViewController {
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 2: // Referral
            
            if let referralVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: referralVC)
                referralVC.view.tag = 200
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 3: // Referral Alerts
            
            if let referralAlertsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralAlertsViewController") as? ReferralAlertsViewController {
                referralAlertsVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: referralAlertsVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 4: // Awaiting Reward
            
            if let rewardsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController {
                rewardsVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: rewardsVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 5: // Store Credit
            
            if let storeCreditVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "StoreCreditViewController") as? StoreCreditViewController {
                storeCreditVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: storeCreditVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 6: // Redemption History
            
            if let unclaimedOfferVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "UnclaimedOfferViewController") as? UnclaimedOfferViewController {
                unclaimedOfferVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: unclaimedOfferVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
        case 7: // Notification

            if let notificationVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                notificationVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: notificationVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                
              
            }
            
        case 8: // Recommand
            
            var text = (CUserDefaults.value(forKey: UserDefaultReferralMsg) as! String)
            text = text.replacingOccurrences(of: "XXXXXX", with: CUserDefaults.value(forKey: UserDefaultReferralCode) as! String)
            
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
            self.present(activityViewController, animated: true, completion: nil)

//            if let referralVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
//                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: referralVC)
//                referralVC.view.tag = 200
//                referralVC.isInvite = true
//                referralVC.isClose = true
//                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
//            }
            
//                        if let recommendVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RecommendToFriendsViewController") as? RecommendToFriendsViewController {
//                            recommendVC.view.tag = 200
//                            appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: recommendVC)
//                            appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
//                        }
            
        case 9: // Settings
            
            if let settingVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
                settingVC.view.tag = 200
                appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: settingVC)
                appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
            }
            
        case 10: // Login as Merchant
            
            DispatchQueue.main.async {
                
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                    CUserDefaults.set(appDelegate?.loginUser?.mobile, forKey: UserDefaultCustomerLoginMobile)
                    CUserDefaults.set(appDelegate?.loginUser?.country_code, forKey: UserDefaultCustomerLoginPostalCode)
                    appDelegate?.loginAsMerchantUser(response: nil)
                }, btnTwoTitle: CBtnNo) { (action) in}
                
            }
            
        case 11: // Logout
            
            DispatchQueue.main.async {
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: "LOG OUT", btnOneTapped: { (action) in
                    CUserDefaults.set(appDelegate?.loginUser?.mobile, forKey: UserDefaultCustomerLoginMobile)
                    CUserDefaults.set(appDelegate?.loginUser?.country_code, forKey: UserDefaultCustomerLoginPostalCode)
                    appDelegate?.signOutCustomerUser(response: nil)
                }, btnTwoTitle: "CANCEL") { (action) in}
            }
            
        default:
            break
        }
    }
    
}
