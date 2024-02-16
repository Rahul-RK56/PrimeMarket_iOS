//
//  CustomerReferalAlertViewController.swift
//  SMarket
//
//  Created by Shankar Narayanan on 15/02/24.
//  Copyright © 2024 Mind. All rights reserved.
//

import UIKit



class CustomerReferalAlertViewController: UIViewController {

    @IBOutlet weak var lblOffer: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var gifImgView: UIImageView!
    weak var delegate: PopupDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if offerDesctibed == ""{
//            lblOffer.text = "cashback \(cashbackoffer)"
        }else if offerDesctibed != nil {
            lblOffer.text = offerDesctibed
        }
        gifImgView.loadGif(name: "Rewardsgif")
    }

    @IBAction func confirmAction(_ sender: Any) {
        delegate?.goToHomepage()
                
                // Dismiss the popup
                dismiss(animated: true, completion: nil)
    }
}
