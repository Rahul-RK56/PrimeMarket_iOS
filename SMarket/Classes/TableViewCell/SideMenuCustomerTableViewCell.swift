//
//  SideMenuCustomerTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class SideMenuCustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet  var lblName : UILabel!
    @IBOutlet  var lblCash : UILabel!
    @IBOutlet  var vwContainer : UIView!
    @IBOutlet  var vwCash : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwCash.layer.cornerRadius = 2
        vwCash.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
