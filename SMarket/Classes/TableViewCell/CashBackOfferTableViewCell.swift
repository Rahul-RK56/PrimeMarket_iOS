//
//  CashBackOfferTableViewCell.swift
//  SMarket
//
//  Created by CIPL0874 on 06/04/22.
//  Copyright © 2022 Mind. All rights reserved.
//

import UIKit

class CashBackOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCashBackOffoerTitle : UILabel!
    @IBOutlet weak var lblCashBackOffoerValue : UILabel!
    
    @IBOutlet weak var lblCashbackDetails: UILabel!
    
    
    
    
    @IBOutlet weak var readMoreBtn: UIButton!
    // cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 5
   // cell1?.lblCashBackOffoerValue.text = "\(cashback.offerpercentage ?? 0)%"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         lblCashBackOffoerTitle.backgroundColor = ColorRewards
         lblCashBackOffoerTitle.layer.cornerRadius = 5
        // Configure the view for the selected state
    }
    
}
