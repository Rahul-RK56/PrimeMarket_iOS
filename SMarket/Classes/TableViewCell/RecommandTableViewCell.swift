//
//  RecommandTableViewCell.swift
//  SMarket
//
//  Created by Mac-00014 on 11/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class RecommandTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblIndex : UILabel!
    @IBOutlet weak var lblAlreadyContact: UILabel!
    @IBOutlet weak var btnSelected : UIButton!
    @IBOutlet weak var vwBGCircle : UIView!
    @IBOutlet weak var vwSeprator : UIView!

    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
