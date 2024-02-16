//
//  WelcomeViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import GoogleSignIn
class WelcomeViewController: ParentViewController {

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
//        if  appDelegate!.isCustomerLogin{
//        perform(#selector(authenticateCustomer), with: nil, afterDelay: 150)
//        }
//        if{}
//        perform(#selector(authenticateMerchant), with: nil, afterDelay: 150)
    }
   
    // MARK:-
    // MARK:- ACTION EVENT
    @IBAction fileprivate func btnCustomerClicked(_ sender : UIButton) {
        appDelegate?.isCustomerLogin = true
        appDelegate?.initCustomerLoginViewController()
        
        
    }
    @IBAction fileprivate func btnMerchantClicked(_ sender : UIButton) {
        appDelegate?.isCustomerLogin = false
        appDelegate?.initMerchantLoginViewController()
       
    }
}
