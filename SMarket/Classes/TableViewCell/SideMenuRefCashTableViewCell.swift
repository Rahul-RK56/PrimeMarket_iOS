//
//  SideMenuRefCashTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class SideMenuRefCashTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet  var lblName : UILabel!
    @IBOutlet  var lblCash : UILabel!
    @IBOutlet  var vwContainer : UIView!
    @IBOutlet  var vwCash : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vwContainer.layer.borderWidth = 1
        vwContainer.layer.borderColor = CRGB(r: 225, g: 226, b: 226).cgColor
        
        vwCash.layer.cornerRadius = 2
        vwCash.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
