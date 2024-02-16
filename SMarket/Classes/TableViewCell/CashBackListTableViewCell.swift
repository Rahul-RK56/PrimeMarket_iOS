//
//  CashBackListTableViewCell.swift
//  SMarket
//
//  Created by CIPL0874 on 20/12/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

class CashBackListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cashBackLbl: GenericLabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
