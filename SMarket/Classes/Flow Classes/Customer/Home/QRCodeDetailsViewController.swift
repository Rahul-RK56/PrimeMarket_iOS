//
//  QRCodeDetailsViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 07/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
enum QRDetailsType   {
    case Offer
    case ReviewOffer
    case StoreCreditOffer
    case ReferOffer
}

var offerDesctibed = ""



class QRCodeDetailsViewController: ParentViewController, PopupDelegate {
    
    
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblTagline : UILabel!
    @IBOutlet weak var lblReview : UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblExpireDate : UILabel!
    @IBOutlet weak var lblReferredDate : UILabel!
    @IBOutlet weak var lblAvailableStoreCredit : UILabel!
    @IBOutlet weak var lblOfferCode : UILabel!
    @IBOutlet weak var lblCondition : UILabel!
    @IBOutlet weak var lblConditionTitle : UILabel!
    @IBOutlet weak var lblOfferType : UILabel!
    @IBOutlet weak var lblOfferValue : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblOfferStatus : UILabel!
    
    
    @IBOutlet weak var vWRating : RatingView!
    @IBOutlet weak var imgVQRCode : UIImageView!
    @IBOutlet weak var imgVMerchant : UIImageView!
    @IBOutlet weak var imgVStatusBg : UIImageView!
    @IBOutlet weak var vWAlertView : UIView!
    @IBOutlet weak var vWAlertChildView : UIView!
    @IBOutlet weak var btnOfferType : UIButton!
    @IBOutlet weak var btninvite: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var lblCopyText: UILabel!
    var qrDetailsType : QRDetailsType!
         var copyText = ""
    var symbol:String = ""
    var merchant_ID = ""
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    var cashback : CheckCashbackDetails?
    var user_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user_id = CUserDefaults.value(forKey: UserDefaultLoginUserID) as? String ?? ""
        merchant_ID = merchanttID

        initialize()
        lblCopyText.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func goToHomepage() {
        // Navigate to the homepage view controller
        if let homepageVC = storyboard?.instantiateViewController(withIdentifier: "HomeCustomerViewController") {
            navigationController?.pushViewController(homepageVC, animated: true)
        }
    }
    
    func showPopup() {
            // Present the popup view controller
            let popupVC = UIStoryboard(name: "MainCustomer", bundle: nil).instantiateViewController(withIdentifier: "CustomerReferalAlertViewController") as! CustomerReferalAlertViewController
            popupVC.delegate = self
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .fullScreen
        popupVC.view.backgroundColor = .lightGray
            present(popupVC, animated: true, completion: nil)
        }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        lblAvailableStoreCredit.text = ""
        
        switch qrDetailsType {
        case .Offer?:
            self.title = "OFFER QR CODE"
            alertPopUpConfiguration()
        case .ReviewOffer?:
            self.title = "RATE & REVIEW QR CODE"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(btnBackClicked))
            self.prefilledData(iObject as? [String : Any])
        case .ReferOffer?:
//            self.presentAlertViewWithTwoButtons(alertTitle: "SMark Offer", alertMessage: CMessageVisiblefriendsAlert, btnOneTitle: CBtnCancel, btnOneTapped: { (sender) in
//                self.popToViewController()
//            }, btnTwoTitle: CBtnProceed, btnTwoTapped: { (sender) in
//
//            })
            self.title = "RATE & REFER QR CODE"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(btnBackClicked))
            self.prefilledData(iObject as? [String : Any])
        case .StoreCreditOffer?:
            self.title = "STORE CREDIT QR CODE"
            lblAvailableStoreCredit.text = "Available store credit: \(appDelegate!.currency)0"
        default :
            self.title = "OFFER QR CODE"
        }
        
        //.. Enable location service and update api
        
        var isNeedRefresh = true
        appDelegate?.enableLocationService({ (status, location) in
            
            if  status == .authorizedWhenInUse && location != nil && isNeedRefresh {
                isNeedRefresh = false
                self.loadOfferDetails()
            }else if status == .restricted || status == .denied{
                isNeedRefresh = true
                self.loadOfferDetails()
            }else {
                self.loadOfferDetails()
            }
        })
        

    }
    
    fileprivate func loadOfferDetails() {
        
        if let dict = iObject as? [String : Any] {
            prefilledData(dict)
        } else {
            if let id = iObject as? String {
                loadOfferDetails(id: id)
            }
        }
    }
    
    @IBAction func copyCodeTapped(_ sender: Any) {
        
          lblCopyText.isHidden = false
                let pasteboard = UIPasteboard.general
                pasteboard.string = lblOfferCode.text
                UIPasteboard.general.string = lblOfferCode.text
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
    
//    fileprivate func checkCashbackDetailsFromServer(qrCode : String, merchant_id : String, customer_id : String) {
//        
//        var param = [String : Any]()
//        param["customer_id"] = customer_id
//        param["qr_code"] = qrCode
//        param["merchant_id"] = merchant_id
//        
//        print("param===>>>",param)
//        
////        self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
//        
//        APIRequest.shared().checkCashbackDetails(param) { (response, error) in
//            if APIRequest.shared().isJSONDataValid(withResponse: response) {
//
//                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [String: Any] {
//                    self.getCheckCashback(data)
//                }
//                
//            }
////            
//         }
//    }
    
    fileprivate func checkCashbackDetailsFromServer(qrCode : String, merchant_id : String, customer_id : String, contacts_count : String) {
        
        var param = [String : Any]()
        param["customer_id"] = customer_id
        param["qr_code"] = qrCode
        param["merchant_id"] = merchant_id
        param["contacts_count"] = contacts_count
        
//        self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        
//        APIRequest.shared().checkCashbackDetails(param) { (response, error) in
//            
//            if APIRequest.shared().isJSONDataValid(withResponse: response) {
//                
//                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [String: Any] {
//                    self.getCheckCashback(data)
//                    
//                }
//            }
//        }
        APIRequest.shared().checkCashbackDetails(param) { (response, error) in
            if let error = error {
                // Handle API request error
                print("API request error: \(error)")
                return
            }
            guard let dataResponse = response as? [String : Any] else {
                    // Handle invalid response type
                    print("Invalid response type or empty response")
                    return
                }
            if let data = dataResponse[CJsonData] as? [String: Any] {
                var dattaa = data["offer_description"]
                print(dattaa,"RRR")
                offerDesctibed = dattaa as! String
                print("RRRR",offerDesctibed)
                    self.getCheckCashback(data)
                } else {
                    // Handle missing or invalid data
                    print("Missing or invalid data in response")
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
//                    checkCashbackDetailsFromServer(qrCode: lblOfferCode.text ?? "", merchant_id: merchantId, customer_id: user_id)
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
    
    
    func getCheckCashback(_ data : [String : Any]?) {

           if let datta = data {
               
               cashback = CheckCashbackDetails(object: datta)
               
               if let item = self.cashback {
                   print("messages",self.cashback?.message)
                   if item.code_status == "Credited" {
                       self.showPopup()
                   }else{
                       checkCashbackDetailsFromServer(qrCode: self.lblOfferCode.text ?? "", merchant_id: merchant_ID, customer_id: user_id, contacts_count: selectedCount!)
                   }
                 
               }
           }
       }
    
    
    fileprivate func prefilledData(_ data:[String : Any]?)  {
        
        if let data = data {
            let offerDetails = OfferDetails(object: data)
            
            imgVMerchant.imageWithUrl(offerDetails.logo)
            imgVMerchant.touchUpInside { (imageView) in
                self.fullScreenImage(imageView, urlString: offerDetails.logo)
            }
            
            lblMerchantName.text = offerDetails.name
            lblTagline.text = offerDetails.tagLine
            lblDistance.text = "(\(offerDetails.distance ?? "0.0") mi)"
            vWRating.setRating((offerDetails.avgRating?.toFloat) ?? 0.0)
            lblRatingCount.text = "\(offerDetails.avgRating?.toFloat ?? 0.0)"
            lblReview.text = "(\(offerDetails.noOfRating ?? "0"))"
            imgVQRCode.imageWithUrl(offerDetails.qrCodeImage)
            lblOfferCode.text = offerDetails.code
            lblExpireDate.textColor = offerDetails.status == .Expire ? ColorRedExpireDate : ColorBlack_000000
            
            if qrDetailsType == .StoreCreditOffer {
                lblAvailableStoreCredit.text = "Available store credit: \(symbol)\(offerDetails.storeCredit ?? "0")"
            }
            
            if let offer = offerDetails.offers {
                
                if let expiryDate = offer.expiryDate?.dateFromString, !expiryDate.isBlank {
                    lblExpireDate.text = "Expires on: \(expiryDate)"
                }
                
                if offer.offerType == .Referral {
                    
                    if let referrerDate = offerDetails.referredDate?.dateFromString, !referrerDate.isBlank {
                        lblReferredDate.text = "Referred on: \(referrerDate)"
                    }
                }
                
                if let subOffer = offer.subOffer?.first {
                    lblOfferType.text = subOffer.categoryName
                    lblCondition.text = subOffer.conditions
                    lblConditionTitle.isHidden = lblCondition.text!.isBlank
                    
                    if subOffer.subOfferCategory == .InStore {
                        lblOfferValue.text = ""
                        btnOfferType.setImage(subOffer.exclusiveImage, for: .normal)
                    }else {
                        lblOfferValue.text = "\(appDelegate!.currency)\(subOffer.amount ?? "0")"
                    }
                } else {
                    btnOfferType.isHidden = offer.subOffer?.first == nil
                    lblConditionTitle.isHidden = true
                }
            } else {
                lblOfferValue.isHidden = true
                btnOfferType.isHidden = true
                lblConditionTitle.isHidden = true
                lblCondition.isHidden = true
            }
            
            switch offerDetails.status {
                
            case .Redeemed:
                lblOfferStatus.textColor = CRGB(r: 37, g: 168, b: 24) // Redeemed
                lblOfferStatus.isHidden = false
                lblOfferStatus.text = "Redeemed"
                imgVStatusBg.isHidden = false
                if let redeemedDate = offerDetails.redeemedDate?.dateFromString, !redeemedDate.isBlank {
                    lblReferredDate.text = "Redeemed on: \(redeemedDate)"
                }
                
            case .Expire:
                lblOfferStatus.textColor = CRGB(r: 247, g: 23, b: 1) // Expire
                lblOfferStatus.isHidden = false
                lblOfferStatus.text = "Expired"
                imgVStatusBg.isHidden = false
                
            default:
                lblOfferStatus.isHidden = true
                imgVStatusBg.isHidden = true
            }
        }
        
        self.checkCashbackDetailsFromServer(qrCode: lblOfferCode.text ?? "", merchant_id: merchant_ID, customer_id: self.user_id, contacts_count: selectedCount!)

    }
    fileprivate func popToViewController() {
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            if viewControllers[viewControllers.count - 4] is MerchantDetailsViewController {
                if let merchantDetailsVC = viewControllers [viewControllers.count - 4] as? MerchantDetailsViewController {
                    self.navigationController?.popToViewController(merchantDetailsVC, animated: true)
                }
            } else {
                if viewControllers[viewControllers.count - 3] is MerchantDetailsViewController {
                    if let merchantDetailsVC = viewControllers [viewControllers.count - 3] as? MerchantDetailsViewController {
                        self.navigationController?.popToViewController(merchantDetailsVC, animated: true)
                    }
                }
            }
        }
    }
    // MARK:-
    // MARK:- ACTION EVENT
    @objc  fileprivate func btnBackClicked(_ sender : UIBarButtonItem) {
        
        if block != nil {
            self.block!(true,nil)
        }
        popToViewController()
    }
}

// MARK:-
// MARK:- Alert popUp Configuration

extension QRCodeDetailsViewController {
    
    func alertPopUpConfiguration()  {
        
        vWAlertView.CViewSetWidth(width: CScreenWidth)
        vWAlertView.CViewSetHeight(height: CScreenHeight)
        vWAlertChildView.layer.cornerRadius = 5
        vWAlertChildView.layer.masksToBounds = true
        
        self.presentPopUp(view: self.vWAlertView, shouldOutSideClick: false, type: .center) {
            
        }
        
        self.btninvite.touchUpInside(genericTouchUpInsideHandler: { (sender) in
            self.dismissPopUp(view: self.vWAlertView, completionHandler: nil)
            self.checkContactPermission()
        })
        self.btnSkip.touchUpInside(genericTouchUpInsideHandler: { (sender) in
            self.dismissPopUp(view: self.vWAlertView, completionHandler: nil)
        })
    }
}

// MARK:-
// MARK:- Helper Method

extension QRCodeDetailsViewController {
    
    fileprivate func checkContactPermission() {
        
        SwiftyContacts.shared.requestAccess(true) { (granted) in
            
            if granted {
                
                SwiftyContacts.shared.fetchContacts(ContactsSortorder: .givenName, completionHandler: { (result) in
                    
                    switch result{
                    case .Success(response: let contacts):
                        // Do your thing here with [CNContacts] array
                        
                        if let arrContactList = SwiftyContacts.shared.convertContactListToArray(contacts) as? [[String : Any]] {
                            DispatchQueue.main.async {
                                self.sendContactsOnServer(contacts: arrContactList)
                            }
                        }
                        
                    case .Error(error: let error):
                        print(error)
                        break
                    }
                })
            }
        }
    }
}

// MARK:-
// MARK:- Server Request

extension QRCodeDetailsViewController {
    
    fileprivate func loadOfferDetails(id : String) {
        
        var param = [String : Any]()
        param["id"] = id
        
        if (iObject as? [String : Any]) == nil {
            self.view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        }
        
        APIRequest.shared().loadOfferDetails(param) { (response, error) in
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [String: Any] {
                    self.iObject = data
                    self.prefilledData(data)
                }
            }
            
            //For remove loader or display data not found
            if (self.iObject as? [String : Any]) != nil  {
                self.view.stopLoadingAnimation()
                
            } else if error == nil {
                self.view.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                // ... -999 cancelled api
                // ... --1001 or -1009 no internet connection
                
                if error.code != -999 {
                    
                    self.view.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                        if let offerId = self.iObject as? String {
                            self.loadOfferDetails(id: offerId)
                        }
                    })
                }
            }
        }
    }
    
    fileprivate func sendContactsOnServer(contacts : [Any]){
        
        var param = [String : Any]()
        param["contact_list"] =  contacts
        
        APIRequest.shared().sendContactsOnServer(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    var param = [String : Any]()
                    param["smarket_contact_list"] = data["smarket_contact_list"]
                    
                    if let arrOtherContact = data["other_contact_list"] as? [Any], arrOtherContact.count > 0 {
                        if let friendListVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FriendListVC") as? FriendListVC {
                            friendListVC.navigation = .rewards
                            friendListVC.iObject = contacts
                            friendListVC.params = param
                            self.navigationController?.pushViewController(friendListVC, animated: true)
                        }
                    }
                }
            }
        }
    }
}
