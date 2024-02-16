//
//  GenericTextField.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class GenericTextField: UITextField {
    
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
    
    fileprivate func initialize() {
        self.font = self.font?.setUpAppropriateFont()
    }    
}

class LRFGenericTextField: GenericTextField {
    
     //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    //MARK:-
    //MARK:- Initialize
    
    fileprivate override func initialize() {
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.addRightImage(strImgName: nil, padding: 8.0, imageContentMode: .Center)
        self.addLeftImage(strImgName: nil, padding: 16.0, imageContentMode: .Center)
    }
}

class CornerRadiusTextField: GenericTextField {
    
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
    
   fileprivate  override func initialize() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 1
        self.layer.cornerRadius = 5
    }
}

class leftImageTextField: CornerRadiusTextField {
    
     fileprivate  var imgView : UIImageView?
     var leftImage : UIImage?
    //MARK:-
    //MARK:- Override
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if imgView == nil {
            
            self.addLeftImage(strImgName: nil, padding: 50/375*CScreenWidth, imageContentMode: .Center)
            
            if let leftView = self.leftView {
                
                if let arrSubView = leftView.subviews as? [UIImageView] {
                    
                    for imgV in arrSubView {
                        
                        imgView = imgV
                    }
                }                     
            }
        }
        
        imgView?.image = leftImage
    }
    
    //MARK:-
    //MARK:- Initialize
    
    fileprivate override func initialize() {
        
        self.layer.masksToBounds = true
        self.addRightImage(strImgName: nil, padding: 8.0, imageContentMode: .Center)
    }
}

class leftRightPaddingTextField: CornerRadiusTextField {
    
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
    
    fileprivate override func initialize() {
        
        self.layer.masksToBounds = true
        self.addLeftImage(strImgName: nil, padding: 16.0, imageContentMode: .Center)
        self.addRightImage(strImgName: nil, padding: 16.0, imageContentMode: .Center)
    }
}
