//
//  CashbackQRViewController.swift
//  SMarket
//
//  Created by CIPL0874 on 29/12/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

var offerDesctibe = ""
var cashbackoffer = ""

class CashbackQRViewController: ParentViewController, PopupDelegate {
    
    

    @IBOutlet weak var lblCashBackOffer: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lbkTagLine: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var lblReting: UILabel!
    @IBOutlet weak var lblExpireDate: UILabel!
    @IBOutlet weak var business_logo_Img: UIImageView!
    @IBOutlet weak var qr_logo_Img: UIImageView!
    @IBOutlet weak var lblCopyText: UILabel!
    @IBOutlet var vwRating : RatingView!
    var copyText = ""
    var arrOffer : QRCodeData?
    var merchant : MerchantDetails?
    var cashback : CheckCashbackDetails?
    var user_id = ""
    var merchant_ID = ""
    var qr_code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QR Code"
        if let merchantId = iObject as? String {
            print(merchantId, "mertchantid")
            createqrCodeFromServer(merchantId: merchantId)
        }
   
        user_id = CUserDefaults.value(forKey: UserDefaultLoginUserID) as? String ?? ""
        merchant_ID = iObject as? String ?? ""
    //   createClaimcashBackOffer()
       
        // Do any additional setup after loading the view.
        
       
        if let merchantId = iObject as? String {
            print(merchantId, "mertchantid")
            loadMerchantDetailsFromServer(merchantId)
            
        }
        
        if let offer = merchant?.offers?[0] {
            
           
            if let subOffer = offer.subOffer?[0]  {
                lblCondition.text = subOffer.conditions
            }
        }
    }
    
    
   

    @IBAction func copyBtnTapped(_ sender: Any) {
       // UIPasteboard.general.string = lblCode.text
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

    }
    
    func generateQRCode(from string: String) -> UIImage?
        {
            let data = string.data(using: String.Encoding.ascii)

            if let filter = CIFilter(name: "CIQRCodeGenerator")
            {
                filter.setValue(data, forKey: "inputMessage")

                guard let qrImage = filter.outputImage else {return nil}
                let scaleX = self.qr_logo_Img.frame.size.width / qrImage.extent.size.width
                let scaleY = self.qr_logo_Img.frame.size.height / qrImage.extent.size.height
                let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

                if let output = filter.outputImage?.transformed(by: transform)
                {
                    return UIImage(ciImage: output)
                }
            }
            return nil
        }
    fileprivate  func createqrCodeFromServer(merchantId:String){
        
        
    
        
        
        var param = [String : Any]()
       
        param["merchant_id"] = merchantId
        
        APIRequest.shared().generateQRCode(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {


                if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any]{

                    self.arrOffer = QRCodeData(object: data)
                    DispatchQueue.main.async {
                        self.lblCode.text =  self.arrOffer?.qr_code

                        print("hiiii")
                        self.qr_logo_Img.loadFrom(URLAddress: self.arrOffer?.qr_img ?? "")
                        self.qr_code = self.lblCode.text ?? ""
                        self.merchant_ID = merchantId
                        self.checkCashbackDetailsFromServer(qrCode: self.lblCode.text ?? "", merchant_id: merchantId, customer_id: self.user_id)
                     //   self.qr_logo_Img.image = UIImage()
                       // let imgUrl = URL(string: "https://reqres.in/img/faces/9-image.jpg")

//                      let imgUrl = URL(string: self.arrOffer?.qr_img ?? "")
//                        if self.arrOffer?.qr_img == "" {
//                            self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
//                        }else {
//                            self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage:UIImage(named:"temp_QRCOde"))
//                        }
                     //   self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage:UIImage(named:"temp_QRCOde"))
                      //  self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
//                        print( self.arrOffer?.qr_img)
//                        print("welcome")
                        // 1

                    }




                }
            }

        }
        }
//
//        APIRequest.shared().generateQRCode(completion: { (response, error) in
//
//
//
//            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
//
//
//                if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any]{
//
//                    self.arrOffer = QRCodeData(object: data)
//                    DispatchQueue.main.async {
//                        self.lblCode.text =  self.arrOffer?.qr_code
//
//                        print("hiiii")
//                        self.qr_logo_Img.loadFrom(URLAddress: self.arrOffer?.qr_img ?? "")
//                     //   self.qr_logo_Img.image = UIImage()
//                       // let imgUrl = URL(string: "https://reqres.in/img/faces/9-image.jpg")
//
////                      let imgUrl = URL(string: self.arrOffer?.qr_img ?? "")
////                        if self.arrOffer?.qr_img == "" {
////                            self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
////                        }else {
////                            self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage:UIImage(named:"temp_QRCOde"))
////                        }
//                     //   self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage:UIImage(named:"temp_QRCOde"))
//                      //  self.qr_logo_Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
////                        print( self.arrOffer?.qr_img)
////                        print("welcome")
//                        // 1
//
//                    }
//
//
//
//
//                }
//            }
//
//        })
        
  //  }
  
    
  
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CashbackQRViewController {
   
   func fillMerchantDetailsWithData(_ data : [String : Any]?) {
       
       if let data = data  {

           merchant = MerchantDetails(object: data)
           if let merchant = self.merchant {
               print("merchant-----", merchant)
              // self. = merchant.name
             //  lblTagline.text = merchant.tagLine
               lblBusinessName.text = "\(merchant.name ?? "")"
               lbkTagLine.text = merchant.tagLine
               vwRating.setRating((merchant.avgRating?.toFloat) ?? 0.0)
               lblReting.text = "\(merchant.avgRating?.toFloat ?? 0.0)"
               let imgUrl = merchant.logo ?? ""
               let fileUrl = URL(string: imgUrl)
              // lblCondition.text =
               business_logo_Img.sd_setImage(with: fileUrl, placeholderImage: UIImage(named: ""), options: .highPriority, completed: nil)
             //  business_logo_Img.image = UIImage(named: "\(merchant.logo ?? "")")
           //    lblCondition.text = "\(merchant.cashback?.offercondition ?? "")"
               lblCashBackOffer.text = "\(merchant.cashback?.offerpercentage ?? 0)%"
               
               cashbackoffer = lblCashBackOffer.text!
               print("cashbackoffer", cashbackoffer)
               
               print("\(merchant.address) merchant address")
            print("\(merchant.logo)")
             
           }
           
       }
   }
    
    func goToHomepage() {
        // Navigate to the homepage view controller
        if let homepageVC = storyboard?.instantiateViewController(withIdentifier: "HomeCustomerViewController") {
            navigationController?.pushViewController(homepageVC, animated: true)
        }
    }
    
    
    func showPopup() {
            // Present the popup view controller
            let popupVC = UIStoryboard(name: "MainCustomer", bundle: nil).instantiateViewController(withIdentifier: "CustomerRewardAlertViewController") as! CustomerRewardAlertViewController
            popupVC.delegate = self
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .fullScreen
        popupVC.view.backgroundColor = .lightGray
            present(popupVC, animated: true, completion: nil)
        }
    
    func getCheckCashback(_ data : [String : Any]?) {

           if let datta = data {
               
               cashback = CheckCashbackDetails(object: data)
               
               if let item = self.cashback {
                   if item.code_status == "not processed" {
                       checkCashbackDetailsFromServer(qrCode: self.lblCode.text ?? "", merchant_id: merchant_ID, customer_id: user_id)
                   }else{
//                       let alert = UIAlertController(title: "", message: "Your Redemption is successful", preferredStyle: UIAlertController.Style.alert)
//                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
//                           
//                           if let homeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController") as? HomeCustomerViewController {
//                               appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: homeVC)
//                               appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
//                           }
//                       }))
//                       self.present(alert, animated: true, completion: nil)
                       
                       self.showPopup()
                       
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
//                if item.code_status == "not processed" {
//                    checkCashbackDetailsFromServer(qrCode: self.lblCode.text ?? "", merchant_id: merchant_ID, customer_id: user_id)
//                }else{
//                    let alert = UIAlertController(title: "", message: "Your Redemption is successful", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
//
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
extension CashbackQRViewController {
   
   fileprivate func loadMerchantDetailsFromServer(_ id : String) {
       var param = [String : Any]()
       param["merchant_id"] = id
       
       self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
       
       APIRequest.shared().loadMerchantDetails(param) { (response, error) in
           
           if APIRequest.shared().isJSONDataValid(withResponse: response) {
               
               if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [String: Any] {
                   self.fillMerchantDetailsWithData(data)
               }
           }
           
           //For remove loader or display data not found
           if self.merchant != nil {
               self.view.stopLoadingAnimation()
               
           } else if error == nil {
               self.view.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
               
           } else if let error = error as NSError? {
               
               // ... -999 cancelled api
               // ... --1001 or -1009 no internet connection
               
               if error.code != -999 {
                   
                   self.view.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                       
                       if let merchantId = self.iObject as? String {
                           self.loadMerchantDetailsFromServer(merchantId)
                       }
                       
                   })
               }
           }
        //  self.showNoOfferView()
       }
   }
    
    fileprivate func checkCashbackDetailsFromServer(qrCode : String, merchant_id : String, customer_id : String) {
        
        var param = [String : Any]()
        param["customer_id"] = customer_id
        param["qr_code"] = qrCode
        param["merchant_id"] = merchant_id
        
        self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        
        APIRequest.shared().checkCashbackDetails(param) { (response, error) in
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {

                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [String: Any] {
                    
                    var dattaa = data["offer_description"]
                    print(dattaa,"RRR")
                    offerDesctibe = dattaa as! String
                    print("RRRR",offerDesctibe)
                    self.getCheckCashback(data)
                  
                }
            }
            
            

            //For remove loader or display data not found
            if self.merchant != nil {
                self.view.stopLoadingAnimation()
                
            } else if error == nil {
                self.view.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                // ... -999 cancelled api
                // ... --1001 or -1009 no internet connection
                
                if error.code != -999 {
                    
                    self.view.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                        
                        if let merchantId = self.iObject as? String {
                            self.loadMerchantDetailsFromServer(merchantId)
                        }
                        
                    })
                }
            }
         //  self.showNoOfferView()
        }
    }
}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}

