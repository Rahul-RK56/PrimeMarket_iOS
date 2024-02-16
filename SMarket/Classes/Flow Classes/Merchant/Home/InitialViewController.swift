//
//  InitialViewController.swift
//  SMarket
//
//  Created by Shankar Narayanan on 07/02/24.
//  Copyright © 2024 Mind. All rights reserved.
//

import UIKit


class InitialViewController: ParentViewController {
    
    
    @IBOutlet weak var scanCodeBtn: UIButton!
    
    @IBOutlet weak var goToHomeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.title = appDelegate?.loginUser?.name
        var emaillId = appDelegate?.loginUser?.email
        emailId = emaillId ?? ""
        
        print(self.title)
        // Do any additional setup after loading the view.
        
        scanCodeBtn.layer.cornerRadius = 10
        goToHomeBtn.layer.cornerRadius = 10
        
        
    }
    
    fileprivate func initialize()  {
        
        self.title = appDelegate?.loginUser?.name
        
        print("Rahul", self.title)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(leftBurgerMenuClicked))
        self.navigationItem.hidesBackButton = true
        appDelegate?.sideMenuViewController?.screenEdgePanGestureEnabled = true
        
        //.. refreshControl
        
    }
    
    
    
    
    @IBAction func scanQrCodePressed(_ sender: Any) {
        
        if let scanQRCodeVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "RedeemCodeViewController") as? RedeemCodeViewController {
            
            self.navigationController?.pushViewController(scanQRCodeVC, animated: true)
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
//                        self.isverified = true
                        if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                            verifyEmailVC.iObject = param
                            verifyEmailVC.fromVC = "LOGIN"
                            verifyEmailVC.isFromHomePage = true
                            //                            self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                            self.navigationController?.pushViewController(verifyEmailVC, animated: true)
                        }
                        
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
    
    
    @IBAction func goToHomePagePressed(_ sender: Any) {
        
    }
    
    
}
