//
//  MerchantOfferTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 04/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MerchantOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTital : UILabel!
    @IBOutlet weak var lblCardValue : UILabel!
    @IBOutlet weak var lblDetails : UILabel!
    @IBOutlet weak var lblTitleDetails : UILabel!
    @IBOutlet weak var vwSeprator : UIView!
    @IBOutlet weak var btnCardType : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var btnReadMore : UIButton!
    @IBOutlet weak var lblGiftcardWorth : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
