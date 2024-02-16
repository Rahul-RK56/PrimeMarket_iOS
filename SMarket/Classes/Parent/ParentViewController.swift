//
//  ParentViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    var iObject : Any?
    //MARK:- UIStatusBar
    var isStatusBarHide = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK:-
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignKeyboard()
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    fileprivate func setupViewAppearance() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //....Generic Navigation Setup
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:CFontPoppins(size: 19, type: .Medium), NSAttributedStringKey.foregroundColor:UIColor.white]
        
        
        self.navigationController?.navigationBar.barTintColor = (appDelegate?.isCustomerLogin)! ? ColorCustomerAppTheme : ColorMerchantAppTheme
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
        
        appDelegate?.sideMenuViewController?.screenEdgePanGestureEnabled = false
        
        
        if #available(iOS 14.0, *) {
                  let appearance = UINavigationBarAppearance()
                  appearance.configureWithOpaqueBackground()
                  appearance.backgroundColor =  (appDelegate?.isCustomerLogin)! ? ColorCustomerAppTheme : ColorMerchantAppTheme
                  self.navigationController?.navigationBar.standardAppearance = appearance;
                  self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
              } else {
                  self.navigationController?.navigationBar.barTintColor = (appDelegate?.isCustomerLogin)! ? ColorCustomerAppTheme : ColorMerchantAppTheme
                  self.navigationController?.navigationBar.tintColor =  (appDelegate?.isCustomerLogin)! ? ColorCustomerAppTheme : ColorMerchantAppTheme
              }

        
        if (self.view.tag == 100) { // Welcome screen
            
            self.navigationController?.navigationBar.isTranslucent = true
            //....LRF flow
            
        } 
        else if (self.view.tag == 200) {
        
            //......Show burger menu in navigationItem......
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(leftBurgerMenuClicked))
            self.navigationItem.hidesBackButton = true
            appDelegate?.sideMenuViewController?.screenEdgePanGestureEnabled = true
        }
       
        if let title = self.title, !title.isBlank {
            self.title = title.uppercased()
        }
    }
    
    
    func resignKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //MARK:-
    //MARK:- Helper Method
    
    @objc func leftBurgerMenuClicked() {
        
        NotificationCenter.default.post(name: Notification.Name(RefreshSideMenuNotification), object: nil)
        appDelegate?.sideMenuViewController?.setDrawerState(.opened, animated: true)
    }
    
    func presentPopUp(title:NSAttributedString, done:String = "Proceed",isCancel:Bool = true, cancel:String = "Cancel",completionHandler:popUpCompletionHandler?) {
        
        guard let miPopUpOverlay = SkyPopUp.shared else { return }
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(miPopUpOverlay)
        miPopUpOverlay.lblTitle.attributedText = title
        if isCancel{
            miPopUpOverlay.btnCancel.isHidden = false
        }else{
            miPopUpOverlay.btnCancel.isHidden = true
        }
        miPopUpOverlay.btnDone.setTitle(done, for: .normal)
        miPopUpOverlay.btnCancel.setTitle(cancel, for: .normal)
        miPopUpOverlay.presentPopUpOverlayView(view: miPopUpOverlay.subviews[1], completionHandler: completionHandler)
    }
    
}
@nonobjc extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }

    func remove() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
