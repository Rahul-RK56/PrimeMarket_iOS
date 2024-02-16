//
//  SettingTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var swtch : UISwitch!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgVNext : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
