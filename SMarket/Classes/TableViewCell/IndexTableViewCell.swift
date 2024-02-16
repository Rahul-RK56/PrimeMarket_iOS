//
//  IndexTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 12/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class IndexTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            lblTitle.textColor = CRGB(r: 64, g: 181, b: 242)
        } else {
            lblTitle.textColor = CRGB(r: 0, g: 0, b: 0 )
        }
    }

}
