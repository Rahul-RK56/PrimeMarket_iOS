//
//  Alertview.swift
//  SkyeWalls
//
//  Created by CIPL0668 on 17/02/21.
//  Copyright © 2021 CIPL0668. All rights reserved.
//

import Foundation
import UIKit



class SkyPopUp: UIView {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnDone: UIButton!
    var closeTagAlert = 0
    var closeBtnClosure : (()->Void)?
    var doneBtnClosure : (()->Void)?
    
    private static let popUpOverlay:SkyPopUp? = {
        guard let popUpOverlay = Bundle.main.loadNibNamed("SkyPopUp", owner: self, options: nil)?[0] as? SkyPopUp else { return nil }
        popUpOverlay.frame = UIScreen.main.bounds
        return popUpOverlay
    }()
    
    static var shared:SkyPopUp? {
        return popUpOverlay
    }
}

extension SkyPopUp {
    @IBAction private func btnCloseTapped(sender:UIButton) {
        closeTagAlert = 0
        self.dismissPopUpOverlayView(view: self.subviews[1],completionHandler: nil)
    }
    @IBAction private func btnDoneTapped(sender:UIButton) {
        closeTagAlert = 1
        self.dismissPopUpOverlayView(view: self.subviews[1],completionHandler: nil)
    }
    
    func presentPopUpOverlayView(view:UIView , completionHandler:popUpCompletionHandler?) {
        view.center = CGPoint(x: UIScreen.main.bounds.size.width/2.0, y:  UIScreen.main.bounds.size.height/2.0)
        view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5,animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { (completed) in
            if let completionHandler = completionHandler {
                completionHandler()
            }
        })
    }
    
    func dismissPopUpOverlayView(view:UIView,completionHandler:popUpCompletionHandler?) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }, completion: { [self] (completed) in
            if completed {
                self.removeFromSuperview()
                if self.closeTagAlert == 0 {
                    if let closeAction = self.closeBtnClosure{closeAction()}
                }else{
                    if let doneAction = self.doneBtnClosure{doneAction()}
                }
            }
        })
    }
}

