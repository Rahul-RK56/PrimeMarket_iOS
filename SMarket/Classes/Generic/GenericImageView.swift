//
//  GenericImageView.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class GenericImageView: UIImageView {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true;
    }
    
    //MARK:-
    //MARK:- Initializez
    
    func initialize() {
    
    }
    
}
class CircleImageView: UIImageView {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.CViewHeight / 2
        self.layer.masksToBounds = true;
    }
    
    //MARK:-
    //MARK:- Initializez
    
    func initialize() {
        
    }
    
}


class GredientImageView: UIImageView {
    
    var gradient : CAGradientLayer?
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        initialize()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if gradient == nil {
            gradient = CAGradientLayer()
            gradient?.colors = [
                ColorWhite_FDE5E2.cgColor,
                ColorWhite_FEEDEC.cgColor,
                ColorWhite_FEF0F5.cgColor
            ]
            self.layer .insertSublayer(gradient!, at: 0)
        }
        gradient?.frame = self.bounds
    }
    
    //MARK:-
    //MARK:- Initialize
    
    func initialize() {
    }
}

class ShadwoImageView: UIImageView {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        initialize()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
     func initialize() {
        
        self.layer.shadowColor =  self.tag == 1 ?  ColorMerchantAppTheme.cgColor : ColorCustomerAppTheme.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 5
        
    }
}
