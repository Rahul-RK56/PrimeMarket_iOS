//
//  SideMenuCustomerSimpleTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class SideMenuCustomerSimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet  var lblName : UILabel!
    @IBOutlet  var vwContainer : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
