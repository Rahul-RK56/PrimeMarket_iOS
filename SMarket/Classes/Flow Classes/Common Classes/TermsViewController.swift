//
//  TermsViewController.swift
//  SMarket
//
//  Created by CIPL0668 on 14/09/20.
//  Copyright © 2020 Mind. All rights reserved.
//

import UIKit
import ImageSlideshow

class TermsViewController: UIViewController {
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet var viewTutorial: UIView!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    @IBOutlet var btnNext: underLineButton!
    @IBOutlet var splashImage: UIImageView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if !isDeviceJailbroken(){
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.view.addSubview(viewTutorial)
            viewTutorial.frame = self.view.frame
            viewTutorial.isHidden = true
            btnNext.isHidden = true
            topHeight.constant = UIApplication.shared.statusBarFrame.height +
                (navigationController?.navigationBar.frame.height ?? 0.0)
            headerView.isHidden = true
            
            if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
                if  country as! String == "+91" {
                    splashImage.image = UIImage.init(named: "splash1")
                }else{
                    splashImage.image = UIImage.init(named: "splash2")
                }
            }
            else{
                splashImage.image = UIImage.init(named: "splash2")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.checkFirst()
            }
//        }else{
//            presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "App is not supported for Jail Broken Device", btnOneTitle: "ok") { (action) in
//            }
//        }
        
    }
    @IBAction func leftArrowHandler(sender:UIButton){
        slideshow.setCurrentPage(slideshow.currentPage - 1, animated: true)
    }
    @IBAction func rightArrowHandler(sender:UIButton){
        slideshow.setCurrentPage(slideshow.currentPage + 1, animated: true)
    }
    func checkFirst(){
        splashImage.isHidden = true
        
        if let _ = CUserDefaults.value(forKey: UserDefaultInstall)  {
            loadNext()
        }else{
            headerView.isHidden = false
        }
    }
    
    @IBAction func termsButtonHandler(sender:UIButton){
        sender.isSelected.toggle()
        if sender.isSelected{
//            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "WelcomeViewController"))
//            appDelegate!.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
//            loadPageControl()
            loadNext()
        }
    }
    @IBAction func nextButtonHandler(sender:UIButton){
        loadNext()
    }
    func loadNext(){
        
        if let userID = CUserDefaults.value(forKey: UserDefaultLoginUserID)  {
            appDelegate!.loginUser = TBLUser.findOrCreate(dictionary: ["user_id":userID]) as? TBLUser
            
            if appDelegate!.loginUser?.user_type == 1 { // Customer
                appDelegate!.loginUser?.latitude = ""
                appDelegate!.loginUser?.longitude = ""
                CoreData.saveContext()
                appDelegate!.signInCustomerUser(animated: false)
                CUserDefaults.set("instal", forKey: UserDefaultInstall)
                APIRequest.shared().loadUserDetails { (response, error) in}
                return
            } else if appDelegate!.loginUser?.user_type == 2 { // Merchant
                
                CoreData.saveContext()
                CUserDefaults.set("instal", forKey: UserDefaultInstall)
                appDelegate!.signInMerchantUser(animated: false)
                APIRequest.shared().loadUserDetails { (response, error) in}
                return
            }
        }
        CUserDefaults.set("instal", forKey: UserDefaultInstall)
        let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "WelcomeViewController"))
        appDelegate!.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
    }
    func loadPageControl(){
        let localSource = [BundleImageSource(imageString: "tScreen1"), BundleImageSource(imageString: "tScreen2"), BundleImageSource(imageString: "tScreen3")]
        //        slideshow.slideshowInterval = 3.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = ColorCustomerAppTheme
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(localSource)
        
        // Do any additional setup after loading the view.
    }
    
}
extension TermsViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        if page == 0{
            btnLeft.isHidden = true
            btnRight.isHidden = false
            btnNext.isHidden = true
        }
        else if page == 1{
            btnLeft.isHidden = false
            btnRight.isHidden = false
            btnNext.isHidden = true
        }
        else{
            btnLeft.isHidden = false
            btnRight.isHidden = true
            btnNext.isHidden = false
        }
    }
}
