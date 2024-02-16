//
//  GenericLabel.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class GenericLabel: UILabel {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    fileprivate func initialize() {
        self.font = self.font.setUpAppropriateFont()
        
        if self.tag == 100 {
            self.textColor = ColorCustomerAppTheme
        }
    }
       
}

class ShadowLabel: UILabel {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    fileprivate func initialize() {
        self.font = self.font.setUpAppropriateFont()
        
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 5
//        self.layer.cornerRadius = 5
    }
    
}
