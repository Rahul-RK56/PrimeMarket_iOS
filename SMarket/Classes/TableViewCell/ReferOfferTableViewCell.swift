//
//  ReferOfferTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 07/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ReferOfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vwGeneratedCode : UIView!
    @IBOutlet weak var btnGenerateCode : UIButton!
    @IBOutlet weak var vwSeparator : UIView!
    
    @IBOutlet weak var imgVProfile: UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblMobile : UILabel!
    @IBOutlet weak var lblReferralDate : UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblReviews : UILabel!
    @IBOutlet weak var lblReviewsTitle : UILabel!
    @IBOutlet var vWRatingV : RatingView!
    @IBOutlet weak var lblCode : UILabel!
    @IBOutlet weak var imgVCode: UIImageView!
    @IBOutlet weak var imgVProduct: UIImageView!
    
    @IBOutlet weak var btnCopyText: UIButton!
    
    @IBOutlet weak var lblCopyText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
