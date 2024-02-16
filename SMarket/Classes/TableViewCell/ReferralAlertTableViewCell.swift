//
//  ReferralAlertTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 05/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ReferralAlertTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVIcon : UIImageView!
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblStoreCredits : UILabel!
    @IBOutlet weak var lblReferrals : UILabel!
    @IBOutlet weak var lblReviews : UILabel!
    @IBOutlet var vWRatingV : RatingView!
    @IBOutlet weak var lblExpires : UILabel!
    @IBOutlet weak var lblRedeemDate: UILabel!
    @IBOutlet weak var lblOfferType : UILabel!
    @IBOutlet weak var btnOfferType : UIButton!
    @IBOutlet weak var lblOfferValue : UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblPurchaseBy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
