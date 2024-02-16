//
//  CTView.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 02/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var showBorder: Bool = false {
        didSet {
            if self.showBorder {
                self.addBorder()
            }
            else {
                self.removeBorder()
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .blue {
        didSet {
            if shadowLayer != nil {
                shadowLayer.strokeColor = borderColor.cgColor
            }
        }
    }
    
    @IBInspectable var applyTintColorToInnerElements: Bool = false {
        didSet {
            for view in self.subviews {
                view.tintColor = borderColor
            }
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    private func updateView() {
        if (shadowLayer != nil){
            shadowLayer.removeFromSuperlayer()
        }
        
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        //shadowLayer.shadowColor = UIColor.ctViewBg.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        layer.insertSublayer(shadowLayer, at: 0)
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    private func addBorder() {
        
        if shadowLayer != nil {
            shadowLayer.strokeColor = borderColor.cgColor
        }
    }
    
    private func removeBorder() {
        
        if shadowLayer != nil {
            shadowLayer.strokeColor = UIColor.clear.cgColor
        }
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIImage {
    func resizeTopAlignedToFill(newWidth: CGFloat) -> UIImage? {
        let newHeight = size.height * newWidth / size.width

        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
