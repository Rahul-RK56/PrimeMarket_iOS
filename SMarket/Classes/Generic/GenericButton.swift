//
//  GenericButton.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class GenericButton: UIButton {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
   fileprivate func initialize() {
        self.titleLabel?.font = self.titleLabel?.font.setUpAppropriateFont()
    }
}

class GenericCustomerThemeButton: GenericButton {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    fileprivate override func initialize() {
        
        if self.tag == 100 {
            
            self.backgroundColor = .clear
            self.setTitleColor(ColorCustomerAppTheme, for: .normal)
            self.setTitleColor(ColorCustomerAppTheme, for: .selected)
            
        } else {
            self.backgroundColor = ColorCustomerAppTheme
        }
        
    }
}



class LRFGenericButton: UIButton {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    fileprivate func initialize() {
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        if self.tag == 100 {
            self.backgroundColor = ColorCustomerAppTheme
        }
        self.titleLabel?.font = self.titleLabel?.font.setUpAppropriateFont()
    }
    
    
}



class GredientBackgroundButton : GenericButton {
    
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
    
    fileprivate override func initialize() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}

class ColorBackgroundWhiteButton : GenericButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
   fileprivate override func initialize() {
        self.backgroundColor = ColorWhite_FFFAFA
    }
}

class CornerRadiusButton : ColorBackgroundWhiteButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
            initialize()
    }
    
    fileprivate override func initialize() {
        
        self.layer.cornerRadius = 5
        self.layer.shadowColor = CRGB(r: 246, g: 231, b: 231).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2
    }
}


class CircleButton : GenericButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    fileprivate override func initialize() {
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.CViewHeight / 2
        self.layer.masksToBounds = true;
    }
}

class underLineButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    fileprivate  func initialize() {
        

        
        let strTitle = self.title(for: .normal)!
        let attributedString = NSMutableAttributedString(string: strTitle)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : self.tag  == 100 ? ColorCustomerAppTheme : ColorMerchantAppTheme,
                                        NSAttributedStringKey.font : (self.titleLabel?.font.setUpAppropriateFont())!,
                                        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue], range: NSRange(location: 0, length: strTitle.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
class underLineButtonBlack : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    fileprivate  func initialize() {
        

        
        let strTitle = self.title(for: .normal)!
        let attributedString = NSMutableAttributedString(string: strTitle)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor :UIColor.black,
                                        NSAttributedStringKey.font : (self.titleLabel?.font.setUpAppropriateFont())!,
                                        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue], range: NSRange(location: 0, length: strTitle.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}

class ShadowCornerRadiusButton : GenericButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    fileprivate override func initialize() {
        
        self.layer.cornerRadius = 5
        self.layer.shadowColor = CRGB(r: 0, g: 0, b: 0).cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
    }
}

