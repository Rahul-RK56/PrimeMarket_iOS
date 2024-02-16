//
//  MerchantListTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 02/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MerchantListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblId: UILabel!
    
    @IBOutlet weak var imgVIcon : UIImageView!
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
   
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblStoreCredits : UILabel!
    @IBOutlet weak var lblReferrals : UILabel!
    @IBOutlet weak var lblReviews : UILabel!
    @IBOutlet weak var vWRatingV : RatingView!
    
    @IBOutlet weak var btnLabelExpande: UIButton!
    @IBOutlet weak var lblAddress: GenericLabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnWeb : UIButton!
    @IBOutlet weak var btnCall : UIButton!
    @IBOutlet weak var btnDirection : UIButton!
    
    @IBOutlet weak var scoreCreditView: UIView!
    @IBOutlet weak var lblCoupons: GenericLabel!
    
    @IBOutlet weak var awaitingAlertsView: UIView!
    @IBOutlet weak var couponsView: UIView!
    @IBOutlet weak var referralView: UIView!
    var isExpanded = false
    
    @IBOutlet weak var lblAwaitingAlerts: GenericLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        btnWeb.tintColor = ColorCustomerAppTheme
//        btnCall.tintColor = ColorCustomerAppTheme
//        btnDirection.tintColor = ColorCustomerAppTheme
//
//        scoreCreditView.layer.cornerRadius = 10
//        scoreCreditView.layer.borderWidth = 1.5
//        self.scoreCreditView.layer.borderColor = UIColor(red:207/255, green:53/255, blue:165/255, alpha: 1).cgColor
//        lblStoreCredits.textColor = colorPink
//
//        self.referralView.layer.cornerRadius = 10
//        self.referralView.layer.borderWidth = 1.5
//         self.referralView.layer.borderColor = UIColor(red:245/255, green:111/255, blue:77/255, alpha: 1).cgColor
//        lblReferrals.textColor = colorOrange
//
//        self.awaitingAlertsView.layer.cornerRadius = 10
//        self.awaitingAlertsView.layer.borderWidth = 1.5
//        self.awaitingAlertsView.layer.borderColor = UIColor(red:44/255, green:195/255, blue:229/255, alpha: 1).cgColor
//       lblAwaitingAlerts.textColor = colorLightBule
//
//        self.couponsView.layer.cornerRadius = 10
//        self.couponsView.layer.borderWidth = 1.5
//        self.couponsView.layer.borderColor = UIColor(red:67/255, green:191/255, blue:120/255, alpha: 1).cgColor
//    lblCoupons.textColor = colorGreen
//        bottomView.layer.borderWidth = 0.2
//        bottomView.layer.borderColor = UIColor(red:44/255, green:195/255, blue:229/255, alpha: 1).cgColor
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            // self.lblAddress.isUserInteractionEnabled = true
            // self.lblAddress.addGestureRecognizer(labelTap)
       
    }
    
 
    
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
       // print("labelTapped")
        if self.isExpanded == false {
             lblAddress.numberOfLines = 3
            self.isExpanded = true
        }else {
            lblAddress.numberOfLines = 1
             self.isExpanded = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
