//
//  ExtensionUIImageView.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import UIKit

typealias touchUpInsideHandler<T> = ((T) -> ())

extension UIImageView {
    
    func loadGif(name: String) {
        
        DispatchQueue.global().async {
            
            if let image = UIImage.gif(name: name) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
}


// MARK: -
// MARK: - ImageViewTouchUpInSide

extension UIImageView {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        static var TouchUpInside = "genericTouchUpInsideHandler"
    }
    
    func touchUpInside(touchUpInside:
        @escaping touchUpInsideHandler<UIImageView>) {
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.TouchUpInside, touchUpInside, .OBJC_ASSOCIATION_RETAIN)
        
        self.isUserInteractionEnabled = true
        
        if let tapGesture = self.gestureRecognizers?.first(where: {$0.isEqual(UITapGestureRecognizer.self)}) as? UITapGestureRecognizer {
            
            tapGesture.addTarget(self, action: #selector(tapDetected))
            
        } else {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDetected)))
        }
        
        
    }
    
    //Action
    @objc func tapDetected(_ completion: ((Bool) -> Void)?) {
        
        print("Imageview Clicked")
//
//        if let touchUpInsideHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.TouchUpInside) as?  touchUpInsideHandler<UIImageView> {
//
//            touchUpInsideHandler(self)
//        }
    }
}

// MARK: -
// MARK: - Helper Method

extension UIImageView {
    
    func imageWithUrl(_ url : String?)  {
        
        if let url = url {
            let imgUrl = url + "?w=\(Int(self.CViewWidth * 3))"
            self.sd_setShowActivityIndicatorView(true)
            self.sd_setIndicatorStyle(.gray)
            self.sd_setImage(with: imgUrl.toURL, completed: nil)
        }
        
    }
    
}
