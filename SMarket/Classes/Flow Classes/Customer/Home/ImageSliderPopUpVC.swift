//
//  ImageSliderPopUpVC.swift
//  SMarket
//
//  Created by Dhana Gadupooti on 13/07/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit
import ImageSlideshow

class ImageSliderPopUpVC: UIViewController {

    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var slideshow: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageControl()
       // slideshow.layer.cornerRadius = 15
         self.lblText.text = "Step 1: Find a merchant"
        self.lblText.textColor = ColorRedExpireDate
        
        lblClose.isHidden = true
        lblText.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        dismiss(animated: true, completion: nil)
    }
    func loadPageControl(){
          let localSource = [BundleImageSource(imageString: "refer_merhant_Refer"), BundleImageSource(imageString: "referdetails"),BundleImageSource(imageString: "find_Marchant")]
          //        slideshow.slideshowInterval = 3.0
          slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
          slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            self.lblClose.addGestureRecognizer(tap)
          let pageControl = UIPageControl()
          pageControl.currentPageIndicatorTintColor = ColorRedExpireDate
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

extension ImageSliderPopUpVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        if page == 0{
          //  btnLeft.isHidden = true
           // btnRight.isHidden = false
          //  self.lblText.text = "Step 1: Find a merchant"
            
        }
        else if page == 1 {
          //  btnLeft.isHidden = false
          //  btnRight.isHidden = false
            self.lblText.text = "Step 2: Refer merchant"
        }
        else{
          //  btnLeft.isHidden = false
          //  btnRight.isHidden = true
            self.lblText.text = "Step 3: Redeem offer code"
        }
    }
}
