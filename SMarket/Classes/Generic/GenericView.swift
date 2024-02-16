//
//  GenericView.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class GenericView: UIView {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    func initialize() {
        
        if self.tag == 1000 {
            
            // Blue color
            self.layer.borderWidth = 1
            self.layer.borderColor = ColorCustomerAppTheme.withAlphaComponent(0.5).cgColor
        } else if self.tag == 1001 {
            // Grey color
            self.layer.borderWidth = 1
            self.layer.borderColor = CRGB(r: 178, g: 178, b: 178).cgColor
        }
        
        
    }
}

class LRFGenericView: UIView {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    func initialize() {
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}


class ShadwoView: UIView {
    
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
        
        if self.tag == 100 {
            self.layer.shadowColor = CRGB(r: 50, g: 50, b: 50).cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 3
            self.layer.cornerRadius = 5
        } else {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 3
            self.layer.cornerRadius = 5
        }
        
    }
}

class GredientView: UIView {
    
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
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}



class DashedBorderView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var dashPaintedSize: Int = 2
    @IBInspectable var dashUnpaintedSize: Int = 2
    
    let dashedBorder = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //custom initialization
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        self.layer.addSublayer(dashedBorder)
        applyDashBorder()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        applyDashBorder()
    }
    
    func applyDashBorder() {
        dashedBorder.strokeColor = borderColor.cgColor
        dashedBorder.lineDashPattern = [NSNumber(value: dashPaintedSize), NSNumber(value: dashUnpaintedSize)]
        dashedBorder.fillColor = nil
        dashedBorder.cornerRadius = cornerRadius
        dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        dashedBorder.frame = self.bounds
    }
}



class CustomerThemeView: UIView {
    
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    //MARK:-
    //MARK:- Initialize
    
    func initialize() {
        
        if self.tag == 100 {
            self.backgroundColor = ColorCustomerAppTheme.withAlphaComponent(0.3)
        } else {
            self.backgroundColor = ColorCustomerAppTheme
        }
        
        
    }
}

