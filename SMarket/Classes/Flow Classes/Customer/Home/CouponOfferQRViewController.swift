//
//  CouponOfferQRViewController.swift
//  SMarket
//
//  Created by Dhana Gadupooti on 22/06/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

class CouponOfferQRViewController: ParentViewController {

    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var lblReferredDate: UILabel!
    @IBOutlet weak var lblExpireDate: UILabel!
    @IBOutlet weak var business_logo_Img: UIImageView!
    @IBOutlet weak var lblCopyText: UILabel!
    var merchant : MerchantDetails?
    var arrayOfQRCodeData = [[String:Any]]()
    var businessName = ""
    var copyText = ""
    var amount = ""
    var expireDate = ""
    var business_logo = ""
    var condition = ""
    
    var cashback : CheckCashbackDetails?
    var user_id = ""
    var merchant_ID = ""
    var qr_code = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
         initialize()
        lblCopyText.isHidden = true
        // Do any additional setup after loading the view.
        lblBusinessName.text = businessName
        lblExpireDate.text = "Expires on: " + expireDate
        lblCondition.text = condition
        business_logo_Img.image = UIImage(named: business_logo)
        btnAmount.setTitle(amount, for: .normal)
        if business_logo != ""{
                       let business_logourl = URL(string:"\(business_logo)")
                       if let data = try? Data(contentsOf: business_logourl!)
                       {
                       business_logo_Img.image = UIImage(data: data)
                       }
                   }else{
            business_logo_Img.image = UIImage(named: "cust_welcom")
                   }
     
        user_id = CUserDefaults.value(forKey: UserDefaultLoginUserID) as? String ?? ""
        qr_code = lblCode.text ?? ""
        
        self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)

        self.checkCashbackDetailsFromServer(qrCode: self.lblCode.text ?? "", merchant_id: merchant_ID, customer_id: self.user_id)
    }
    

    fileprivate func initialize()  {
        self.title = "COUPON QR CODE"
        
    }
    
    @IBAction func copyTapped(_ sender: Any) {
        lblCopyText.isHidden = false
        let pasteboard = UIPasteboard.general
        pasteboard.string = lblCode.text
        UIPasteboard.general.string = lblCode.text
       if let myString = UIPasteboard.general.string {
          copyText = myString
        self.lblCopyText.alpha = 0
        self.lblCopyText.text = "Code Copied"
        self.lblCopyText.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.lblCopyText.fadeOut()
                })
       }
//        presentAlertViewWithOneButton(alertTitle: "Text Copied", alertMessage: "\(copyText)", btnOneTitle: "Ok") { (okButton) in
//
//        }

        
    }
    
    
    fileprivate func checkCashbackDetailsFromServer(qrCode : String, merchant_id : String, customer_id : String) {
        

        
        var param = [String : Any]()
        param["customer_id"] = customer_id
        param["qr_code"] = qrCode
        param["merchant_id"] = merchant_id
        
//        self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        
        APIRequest.shared().checkCashbackDetails(param) { (response, error) in
            
            self.view.stopLoadingAnimation()

            if APIRequest.shared().isJSONDataValid(withResponse: response) {

                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [String: Any] {
                    self.getCheckCashback(data)
                }
            }else{
                self.getCheckCashback(response as? [String : Any])
            }
            
        }
    }
    
    func getCheckCashback(_ data : [String : Any]?) {

          if let datta = data {
              
              cashback = CheckCashbackDetails(object: data)
              
              if let item = self.cashback {
                  if  item.message == "You Have No Cashback Offers" {
                      let alert = UIAlertController(title: "", message: "Your Redemption is successful", preferredStyle: UIAlertController.Style.alert)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                          if let homeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController") as? HomeCustomerViewController {
                              appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
                              appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                          }
                      }))
                      self.present(alert, animated: true, completion: nil)
                  }else{
                      checkCashbackDetailsFromServer(qrCode: self.lblCode.text ?? "", merchant_id: merchant_ID, customer_id: user_id)
                      
                  }
                
              }
          }
      }
    
//    func getCheckCashback(_ data : [String : Any]?) {
//
//        if let datta = data {
//
//            cashback = CheckCashbackDetails(object: data)
//
//            if let item = self.cashback {
//                if item.message == "You Have No Cashback Offers " {
//                    checkCashbackDetailsFromServer(qrCode: self.lblCode.text ?? "", merchant_id: merchant_ID, customer_id: user_id)
//                }else{
//                    let alert = UIAlertController(title: "", message: "Your Redemption is successful", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
//                        if let homeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController") as? HomeCustomerViewController {
//                            appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
//                            appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
//                        }
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                }
//
//            }
//        }
//    }
}
extension UIView {


    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 2.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
        }, completion: completion)
}

}
