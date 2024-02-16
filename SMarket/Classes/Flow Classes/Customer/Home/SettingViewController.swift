//
//  SettingViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class SettingViewController: ParentViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var arrSetting : [String] {
        get {
            return ["Push Notification","Change Password","How to use the App","Terms & Conditions","Contact Us","Privacy Policy","About Us","Share an App","Rate App","FAQs"]
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
        self.title = "SETTINGS"
        
    }

}


// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as? SettingTableViewCell {
            cell.lblTitle.text = arrSetting[indexPath.row]
            
            if indexPath.row == 0 {
                cell.swtch.isHidden = false
                cell.imgVNext.isHidden = true
                cell.swtch.isOn = (appDelegate?.loginUser?.push_status)!
                cell.swtch.valueChangeEvent { (swtch) in
                    self.pushNotificationEnable(status: swtch.isOn)
                }
            } else {
                cell.swtch.isHidden = true
                cell.imgVNext.isHidden = false
            }
            
           
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1: // Change Password
            
            if let changePasswordVC = CLRF_SB.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            }
        case 2: //How to use the App
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                
                if let dict = CUserDefaults.value(forKey: UserDefaultHowToUseApp)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                
                CMSVC.title = "HOW TO USE THE APP"
                self.navigationController?.pushViewController(CMSVC, animated: true)
            }
        case 3: //Terms & Conditions
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                
                if let dict = CUserDefaults.value(forKey: UserDefaultTermsConditionandPrivacyPolicy)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                
                CMSVC.title = "TERMS & CONDITIONS"
                self.navigationController?.pushViewController(CMSVC, animated: true)
            }
        case 4: //Contact us
            
            if let dict = CUserDefaults.value(forKey: UserDefaultContactUs)  as? [String : Any]{
                
                let email = dict.valueForString(key: "cms_desc").htmlToString
                if !email.isBlank {
                    appDelegate?.openMailComposer(self, email: email)
                }
            }
            
        case 5: //Privacy Policy
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                
                if let dict = CUserDefaults.value(forKey: UserDefaultPrivacyPolicy)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                
                CMSVC.title = "PRIVACY POLICY"
                self.navigationController?.pushViewController(CMSVC, animated: true)
            }
        case 6: //About Us
            
            if let CMSVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                
                if let dict = CUserDefaults.value(forKey: UserDefaultAboutus)  as? [String : Any]{
                    
                    CMSVC.title = dict.valueForString(key: "title")
                    CMSVC.iObject = dict.valueForString(key: "cms_desc")
                }
                
                CMSVC.title = "ABOUT US"
                self.navigationController?.pushViewController(CMSVC, animated: true)
            }
        case 7: //Share an App
            
            DispatchQueue.main.async {
            
                let activityVC = UIActivityViewController(activityItems: ["Download Smarket app from url",CAppStoreAppLink as Any], applicationActivities: nil)
                
                self.present(activityVC, animated: true, completion: nil)
            }
            
            
        case 8: //Rate App
            self.openInSafari(strUrl: CAppStoreAppLink)
            
        case 9://FAQs
            
            if let FAQVC =  CMainCustomer_SB.instantiateViewController(withIdentifier: "FAQViewController") as? FAQViewController {
                
                self.navigationController?.pushViewController(FAQVC, animated: true)
            }
            
        default:
            break
        }
    }
    
}
// MARK:-
// MARK:- Server Request

extension SettingViewController {
    
    fileprivate func pushNotificationEnable(status : Bool) {
        
        var param = [String : Any]()
        param["notification_status"] = status ? "1": "0"
       
        APIRequest.shared().pushNotificationOnOff(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                appDelegate?.loginUser?.push_status = !(appDelegate?.loginUser?.push_status)!
            }
            else {
                self.tblView.reloadData()
            }
        }
    }
}
