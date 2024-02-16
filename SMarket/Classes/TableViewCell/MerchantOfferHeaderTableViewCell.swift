//
//  MerchantOfferHeaderTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 04/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MerchantOfferHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var lblExpiresDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
