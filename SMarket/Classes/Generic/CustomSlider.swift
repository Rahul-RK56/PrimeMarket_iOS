//
//  CustomSlider.swift
//  Strategy_Creator
//
//  Created by Mac-00014 on 03/05/18.
//  Copyright © 2018 Mac-00016. All rights reserved.
//

import UIKit



/// The protocol which the container of Slider can conform to
@objc public protocol SliderDelegate {
  
    /// triggered when touchs Began
    @objc optional func touchesBegan()
    
    /// triggered when touches Moved
    @objc optional func touchesMoved()
    
    /// triggered when touches Ended
    @objc optional func touchesEnded()
}

class CustomSlider : UISlider {
    
    open weak var delegate: SliderDelegate?
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func layoutSubviews() {
         super.layoutSubviews()
    }
    
    func getXPositionWithRespectToCurrentValue(thumbWidthPadding : CGFloat) -> Float? {
        
        let trackRect = self.trackRect(forBounds: bounds)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return Float(thumbRect.origin.x - thumbWidthPadding)
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let _ = touches.first {
            if let delegate = delegate {
                delegate.touchesBegan?()
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if let delegate = delegate {
            delegate.touchesEnded?()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let delegate = delegate {
            delegate.touchesMoved?()
        }
    }
}
