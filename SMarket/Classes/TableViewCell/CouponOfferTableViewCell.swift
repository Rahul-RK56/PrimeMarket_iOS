//
//  CouponOfferTableViewCell.swift
//  SMarket
//
//  Created by Dhana Gadupooti on 21/06/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

class CouponOfferTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRedeem: UIButton!
    @IBOutlet weak var lblCouponOffer: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var btnPhone_Number: UIButton!
    
    @IBOutlet weak var lbl_tagline: UILabel!
    @IBOutlet weak var lblCoupon_Amount: UILabel!
    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var business_logoImageView: UIImageView!
    @IBOutlet weak var couponImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnRedeem.layer.cornerRadius = 10
    }
//tagline
    @IBAction func redeemTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func websiteTapped(_ sender: Any) {
        print("goto website")
    }
    
    @IBAction func phone_callTapped(_ sender: Any) {
        print("goto phone call")
        
        
    }
    @IBAction func directionTapped(_ sender: Any) {
        print("goto direction")
        
           }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
