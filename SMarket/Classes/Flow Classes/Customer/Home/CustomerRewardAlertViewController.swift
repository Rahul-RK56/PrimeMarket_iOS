//
//  CustomerRewardAlertViewController.swift
//  SMarket
//
//  Created by Shankar Narayanan on 06/02/24.
//  Copyright © 2024 Mind. All rights reserved.
//

import UIKit

protocol PopupDelegate: AnyObject {
    func goToHomepage()
}





class CustomerRewardAlertViewController: UIViewController {
    
    weak var delegate: PopupDelegate?
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if offerDesctibe == ""{
            describeLabel.text = "cashback \(cashbackoffer)"
        }else if offerDesctibe != nil {
            describeLabel.text = offerDesctibe
        }
        gifImageView.loadGif(name: "Rewardsgif")
        
        
    }
//    
//    func goToHomepage() {
//            // Code to navigate to the homepage view controller
//            if let homepageVC = storyboard?.instantiateViewController(withIdentifier: "HomeCustomerViewController") {
//                navigationController?.pushViewController(homepageVC, animated: true)
//            }
//        }
//    
    @IBAction func navigateToHomeCustomerViewController(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "MainCustomer", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HomeCustomerViewController") as! HomeCustomerViewController
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .custom
//        self.present(vc, animated: true)
        
        delegate?.goToHomepage()
                
                // Dismiss the popup
                dismiss(animated: true, completion: nil)
        

        
    }
}

