//
//  DebitRefCashTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class DebitRefCashTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVIcon : UIImageView!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblCash : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
