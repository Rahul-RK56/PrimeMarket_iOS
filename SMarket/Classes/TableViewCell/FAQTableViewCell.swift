//
//  FAQTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var lblAnswer : UILabel!
    @IBOutlet weak var btnExpand : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
