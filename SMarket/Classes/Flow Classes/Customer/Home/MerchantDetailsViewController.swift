 //
 //  MerchantDetailsViewController.swift
 //  SMarket
 //
 //  Created by Mac-00014 on 03/07/18.
 //  Copyright © 2018 Mind. All rights reserved.
 //
 
 import UIKit
 import MapKit
var merchanttID = ""
 
 class MerchantDetailsViewController: ParentViewController {
    
    
    @IBOutlet var imgMerchant : UIImageView!
    @IBOutlet var vWDetailsView : UIView!
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var vWHeader : UIView!
    @IBOutlet var vwScrollContent : UIView!
    @IBOutlet var tblOffer : UITableView!
    @IBOutlet var vwFooter : UIView!
    @IBOutlet var vwRating : RatingView!
    @IBOutlet var vwDetails: UILabel!
    
    @IBOutlet var lblTagline : UILabel!
    @IBOutlet var lblReview : UILabel!
    @IBOutlet var lblRatingCount: UILabel!
    @IBOutlet var lblStoreCredit : UILabel!
    @IBOutlet var lblRefferals : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var lblProducts : UILabel!
    @IBOutlet var lblLocation : UILabel!
    
    @IBOutlet var btnDetails : UIButton!
    @IBOutlet var btnOffer : UIButton!
    @IBOutlet var btnCall : UIButton!
    @IBOutlet var btnWebsite : UIButton!
    
    @IBOutlet weak var collViewBottomTab: UICollectionView!
    
    @IBOutlet var cnVwSelectionLeading : NSLayoutConstraint!
    @IBOutlet var cnTblBottom : NSLayoutConstraint!
    @IBOutlet var cnVWDetailsViewBottom : NSLayoutConstraint!
    @IBOutlet var cnTblOfferHeight : NSLayoutConstraint!
    
    var merchant : MerchantDetails?
    var arrBottomTab = [Any]()
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOffer.register(UINib(nibName: "CashBackOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "CashBackOfferTableViewCell")
        initialize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        btnTabClicked(btnDetails)
        
        if let merchantId = iObject as? String {
            loadMerchantDetailsFromServer(merchantId)
        }
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnCloseClicked(_ sender : UIButton) {
        self.dismissPopUp(view: vwDetails, completionHandler: nil)
    }
    
    @IBAction fileprivate func btnTabClicked(_ sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnOffer.isSelected = false
        btnDetails.isSelected = false
        sender.isSelected = true
        
        if sender == btnDetails {
            
            tblOffer.isHidden = true
            vWDetailsView.isHidden = false
            cnVWDetailsViewBottom.priority = UILayoutPriority(rawValue: 999)
            cnTblBottom.priority = UILayoutPriority(rawValue: 750)
            cnTblOfferHeight.constant = vWDetailsView.CViewHeight
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                
                self.cnVwSelectionLeading.constant = 0
                self.view.layoutIfNeeded()
            }
        } else {
            
            tblOffer.isHidden = false
            vWDetailsView.isHidden = true
            cnVWDetailsViewBottom.priority = UILayoutPriority(rawValue: 750)
            cnTblBottom.priority = UILayoutPriority(rawValue: 999)
            tblOffer.reloadData()
           
//                self.tblOffer.performBatchUpdates({
//                    self.tblOffer.insertRows(at: [IndexPath(row: 1,
//                                                               section: merchant?.offers?.count ?? 0)],
//                                              with: .automatic)
//                }, completion: nil)
            self.view.layoutIfNeeded()
            
            
            UIView.animate(withDuration: 0.3) {
                self.cnVwSelectionLeading.constant = (CScreenWidth/2) + 1
                self.view.layoutIfNeeded()
            }
        
            if let offer =  merchant?.offers, offer.count > 0  {
                self.cnTblOfferHeight.constant = self.tblOffer.contentSize.height
            }
        }
    }
    @IBAction fileprivate func btnWebClicked(_ sender : UIButton) {
        self.openInSafari(strUrl: (merchant?.website)!)
    }
    
    @IBAction fileprivate func btnCallClicked(_ sender : UIButton) {
        
        if let code = merchant?.countryCode, let mobileNo = merchant?.mobile {
            self.openPhoneDialer(code + mobileNo)
        }
        
    }
    @IBAction fileprivate func btnDirectionClicked(_ sender : UIButton) {
        
        self.openGoogleMap(merchant?.latitude, longitude: merchant?.longitude, address: merchant?.address)

    }
    
    @IBAction fileprivate func btnReferralClicked(_ sender : UIButton) {
        
        if let refferalAlertsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralAlertsViewController") as? ReferralAlertsViewController {
            refferalAlertsVC.iObject = merchant?.id
            self.navigationController?.pushViewController(refferalAlertsVC, animated: true)
        }
    }
    @IBAction fileprivate func btnUnclaimedClicked(_ sender : UIButton) {
        
        if let unclaimedOfferVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "UnclaimedOfferViewController") as? UnclaimedOfferViewController {
            unclaimedOfferVC.iObject = merchant?.id
            self.navigationController?.pushViewController(unclaimedOfferVC, animated: true)
        }
    }
    @IBAction fileprivate func btnRateClicked(_ sender : UIButton) {
        if let rateAndReviewVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RateAndReviewOfferViewController") as? RateAndReviewOfferViewController {
            rateAndReviewVC.isFromRate = true
            rateAndReviewVC.iObject = merchant
            rateAndReviewVC.title = "RATE MERCHANT"
            rateAndReviewVC.setBlock { (isNeedRefresh,error)in
                
                if let merchantId = self.iObject as? String {
                    self.loadMerchantDetailsFromServer(merchantId)
                }
            }
            self.navigationController?.pushViewController(rateAndReviewVC, animated: true)
        }
    }
    @IBAction fileprivate func btnReferClicked(_ sender : UIButton) {
        
        if let rateAndReviewVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RateAndReviewOfferViewController") as? RateAndReviewOfferViewController {
            rateAndReviewVC.iObject = merchant
            rateAndReviewVC.title = "REFER MERCHANT"
            self.navigationController?.pushViewController(rateAndReviewVC, animated: true)
        }
    }
    @IBAction func btnRatesClicked(_ sender: UIButton) {
        if let userRateVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "UserRateVC") as? UserRateVC {
            userRateVC.iObject = merchant?.id
            self.navigationController?.pushViewController(userRateVC, animated: true)
        }
    }
     
     @IBAction fileprivate func btnCashbackClicked(_ sender : UIButton) {
         
         if let cashbackQR = CMainCustomer_SB.instantiateViewController(withIdentifier: "CashbackQRViewController") as? CashbackQRViewController {
             cashbackQR.iObject = merchant?.id
                     self.navigationController?.pushViewController(cashbackQR, animated: true)
                 }
                
     }
         
     
 }
 
 // MARK:-
 // MARK:- Server Request
 
 extension MerchantDetailsViewController {
    
    fileprivate func loadMerchantDetailsFromServer(_ id : String) {
        var param = [String : Any]()
        param["merchant_id"] = id
        
        merchanttID = id
        
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
            self.showNoOfferView()
        }
    }
 }
 
 // MARK:-
 // MARK:- fill Details
 extension MerchantDetailsViewController {
    
    func fillMerchantDetailsWithData(_ data : [String : Any]?) {
        
        if let data = data  {
            
            merchant = MerchantDetails(object: data)
            
          
            if let merchant = self.merchant {
            
                self.title = merchant.name
                lblTagline.text = merchant.tagLine
                if let value = Float(merchant.avgRating ?? "") {
                                               let roundedValue = String(format: "%.1f", value)
                                               print(roundedValue)
                                 lblRatingCount.text = "\(roundedValue)/5"
                             }
                
                lblReview.text = "(\(merchant.noOfRating ?? "0"))"
//                lblRatingCount.text = "\(merchant.avgRating?.toFloat ?? 0.0)"
                lblStoreCredit.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0")"
                lblRefferals.text = merchant.referrals
                lblDetails.text = merchant.description
                DispatchQueue.main.async {
                    self.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Description", moreText: "Read More", moreTextColor: self.lblTagline.textColor, maxLines: 1)
                }
                lblProducts.text = merchant.productAndServices
                vwRating.setRating((merchant.avgRating?.toFloat) ?? 0.0)
                lblLocation.text = merchant.address
                
                self.imgMerchant.imageWithUrl(merchant.logo)
                self.imgMerchant.isMultipleTouchEnabled = false
//                self.imgMerchant.touchUpInside { (imageView) in
//                    self.fullScreenImage(imageView, urlString: merchant.logo)
//                }
                
                // map
                
                if let lat = merchant.latitude?.toDouble , let long = merchant.longitude?.toDouble {
                    
                    let location = CLLocationCoordinate2DMake(lat, long)
                    let span = MKCoordinateSpanMake(0.03,0.03)
                    let region =  MKCoordinateRegionMake(location, span)
                    mapView.setRegion(region, animated: true)
                    
                    let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                    myAnnotation.coordinate = location
                    //myAnnotation.title = merchant.address
                    mapView.addAnnotation(myAnnotation)
                }
                
                btnWebsite.hide(byWidth: (merchant.website?.isBlank)!)
                btnCall.hide(byWidth: (merchant.mobile?.isBlank)!)
                
                // Button View
                
                arrBottomTab.removeAll()
                
                
                    let referral = ["title":"Referral\nAlerts",
                                    "icon":#imageLiteral(resourceName: "rerferral_alert"),
                                    "optionType":"ReferralAlerts",
                                    "status":merchant.show_referral_alerts] as [String : Any]
                    arrBottomTab .append(referral)
                
                
                
                    let unclaimed = ["title":"Redemption\nHistory",
                                     "icon":#imageLiteral(resourceName: "unclaimed_offer"),
                                     "optionType":"Redemption",
                                     "status":merchant.show_unclaimed_offers] as [String : Any]
                    arrBottomTab .append(unclaimed)
                
                
                    let rate_merchant = ["title":"Rate\nMerchant",
                                         "icon":#imageLiteral(resourceName: "rate_merchant"),
                                         "optionType":"Rate",
                                         "status":merchant.show_rate_merchant] as [String : Any]
                    arrBottomTab .append(rate_merchant)
                
                
                    let refer_merchant = ["title":"Refer\nMerchant",
                                          "icon":#imageLiteral(resourceName: "refer_marchnat"),
                                          "optionType":"Refer",
                                          "status":merchant.show_refer_merchant] as [String : Any]
                    arrBottomTab .append(refer_merchant)
                
                let claim_cashback = ["title":"Claim\nCashback",
                                      "icon":#imageLiteral(resourceName: "rerferral_alert"),
                                      "optionType":"Cashback",
                                      "status":merchant.show_refer_merchant] as [String : Any]
                if merchant.cashback?.offerpercentage ?? 0 > 1{
                    arrBottomTab .append(claim_cashback)
                    }
               
                collViewBottomTab.reloadData()
                
                vwFooter.hide(byHeight: arrBottomTab.count == 0)
            
            }
            btnTabClicked(btnOffer)
        }
    }
    
    fileprivate func showNoOfferView() {
        
        if let merchant = self.merchant {
            if merchant.offers == nil &&  merchant.cashback?.offerpercentage == 0  {
                tblOffer.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
            } else if let offer = merchant.offers , offer.count == 0 &&  merchant.cashback?.offerpercentage == 0{
                tblOffer.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
            }
        }
    }
 }
 
 // MARK:-
 // MARK:- UITableViewDelegate,UITableViewDataSource
 
// extension MerchantDetailsViewController : UITableViewDelegate,UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//
////        if merchant?.cashback?.offerpercentage ?? 0 > 1 {
////            return merchant?.offers?.count ?? 0 + 1
////        }else {
//            return merchant?.offers?.count ?? 0
//        //}
//
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
////        if merchant?.cashback?.offerpercentage ?? 0 > 1 {
////
////            if let arrSubOffer = merchant?.offers?[section].subOffer {
////
////                return arrSubOffer.count + 1
////            }
////        }else{
//           if let arrSubOffer = merchant?.offers?[section].subOffer {
//
//                return arrSubOffer.count
//            }
//
//
//       // }
//
//        return 0
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if let offer = merchant?.offers?[indexPath.section] {
//            if let subOffer = offer.subOffer?[indexPath.row]  {
//
//
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
//
//                    cell.lblTital.layer.cornerRadius = 4
//                    cell.lblTital.layer.masksToBounds = true
//                    cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
//                    cell.btnCardType.setImage(subOffer.image, for: .normal)
//                    cell.lblDetails.text = subOffer.conditions
//
//                    cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
//
//                    if offer.offerType == .Referral {
//                        cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
//                    } else {
//                        cell.lblCardValue.text =  subOffer.title
//                    }
//
//                    if appDelegate!.currency != "$" {
//                        let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
//                        cell.lblCardValue.text = strTitle
//
//                    }
//
////                    if let condition = subOffer.conditions, !condition.isBlank {
////
////                        if cell.lblDetails.calculateMaxLines() > 1 {
////                            cell.btnReadMore.hide(byHeight: false)
////                        } else {
////                            cell.btnReadMore.hide(byHeight: true)
////                        }
////
////                    }else {
//                        cell.btnReadMore.hide(byHeight: true)
//                    //}
////                    cell.btnReadMore.touchUpInside { (sender) in
////                        self.displayDetailsView(subOffer.conditions)
////                    }
//
//                    switch subOffer.subOfferType {
//                    case .Referral?:
//                        cell.lblTital.backgroundColor = ColorCustomerAppTheme
//
//                    case .Bonus?:
//                        cell.lblTital.backgroundColor = ColorBonus
//
//                    case .Reward?:
//                        cell.lblTital.backgroundColor = ColorReward
//
//                    default:
//                        break
//                    }
//
//                    cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
//                    return cell
//                }
//            }
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return 36/375*CScreenWidth
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {
//
//            if let offer = merchant?.offers?[section]  {
//                header.lblTitle.text = offer.offerTitle
//                if let expDate = offer.expiryDate?.dateFromString{
//                    header.lblExpiresDate.text = "Expires on: \(expDate)"
//                }
//            }
//            return header
//        }
//
//        return nil
//    }
// }



extension MerchantDetailsViewController : UITableViewDelegate,UITableViewDataSource{
   
   func numberOfSections(in tableView: UITableView) -> Int {
       
       let number = merchant?.offers?.count ?? 0
       if merchant?.cashback?.offerpercentage ?? 0 > 1{
           
       }
       
       if number == 0{
           return 1
       }else if number == 1{
           return 2
       }else if number == 2{
           return 3
       }else{
           return 4
       }
//       let total = number+1
//       print(total ,"totalnumber")
//       return total
//
//        if merchant?.cashback?.offerpercentage ?? 0 > 1 {
//            if merchant?.offers?.count ?? 0 == 0{
//                return 1
//            }else{
//                let number = merchant?.offers?.count ?? 0
//                return (number)
//            }
//
//        }else {
//    // return 2
//       return 1
//        //return merchant?.offers?.count ?? 0
//       }
       
       
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let number = merchant?.offers?.count ?? 0
       
       if number == 0{
          return 1
       }else if number == 1{
           if section == 0{
               if let arrSubOffer = merchant?.offers?[section].subOffer {
                   print(arrSubOffer.count ,"suboffer")
                            return arrSubOffer.count
                   
               }else{
                   return 0
               }
            
           }else{
               return 1
           }
       } else if number == 2{
           if section == 0{
               if let arrSubOffer = merchant?.offers?[section].subOffer {
                   print(arrSubOffer.count ,"suboffer")
                            return arrSubOffer.count
                   
               }else{
                   return 0
               }
            
           }else if section == 1{
               if let arrSubOffer = merchant?.offers?[section].subOffer {
                   print(arrSubOffer.count ,"suboffer")
                            return arrSubOffer.count
                   
               }else{
                   return 0
               }
            
           
       }
           
       }else if number == 3 {
           if section == 0{
               if let arrSubOffer = merchant?.offers?[section].subOffer {
                   print(arrSubOffer.count ,"suboffer")
                            return arrSubOffer.count
                   
               }else{
                   return 0
               }
            
           }else if section == 1{
               if let arrSubOffer = merchant?.offers?[section].subOffer {
                   print(arrSubOffer.count ,"suboffer")
                            return arrSubOffer.count
                   
               }else{
                   return 0
               }
            
           }else if section == 2{
               if let arrSubOffer = merchant?.offers?[section].subOffer {
                   print(arrSubOffer.count ,"suboffer")
                            return arrSubOffer.count
                   
               }else{
                   return 0
               }
            
           }
           else{
               return 1
           }
       }else{
           return 1
       }
     return 0
     /*  if section == 0{
           if let arrSubOffer = merchant?.offers?[section].subOffer {
               print(arrSubOffer.count ,"suboffer")
                        return arrSubOffer.count
               
           }else{
               return 0
           }
        
       }else if section == 1{
           if let arrSubOffer = merchant?.offers?[section].subOffer {
               print(arrSubOffer.count ,"suboffer")
                        return arrSubOffer.count
               
           }else{
               return 0
           }
        
       }else if section == 2{
           if let arrSubOffer = merchant?.offers?[section].subOffer {
               print(arrSubOffer.count ,"suboffer")
                        return arrSubOffer.count
               
           }else{
               return 0
           }
        
       }
       else{
           return 1
       }
      
      */
       
//       if merchant?.offers?.count ?? 0 == 0{
//           return 1
//       }else{
//            if let arrSubOffer = merchant?.offers?[section].subOffer {
//
//                               return arrSubOffer.count
//            }else if section == number  {
//                return 1
//            }
  //     }
//        if merchant?.cashback?.offerpercentage ?? 0 > 1 {
//
//            if let arrSubOffer = merchant?.offers?[section].subOffer {
//
//               return arrSubOffer.count
//            }
//        }else{
//
//
//
//           if let arrSubOffer = merchant?.offers?[section].subOffer {
//
//                return arrSubOffer.count
//            }
//
//
//       }
//
//        return 1
       
       
//       if merchant?.cashback?.offerpercentage ?? 0 > 1 {
//           if merchant?.offers?.count ?? 0 == 0{
//               return 1
//           }else{
//               let nmuber = merchant?.offers?.count ?? 0
//               return nmuber + 1
//           }
//
//       }else {
//   // return 2
//      return 1
//       //return merchant?.offers?.count ?? 0
//      }
      
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let number = merchant?.offers?.count ?? 0
       
       if number == 0 {
           if   merchant?.cashback?.offerpercentage ?? 0 > 1{
               let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell

               if let cashback = merchant?.cashback{
                   
               cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
                                       cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
                                       cell1?.lblCashBackOffoerTitle.text = "Cashback  "
                                       cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
                                       cell1?.lblCashBackOffoerTitle.textAlignment = .center
                                       cell1?.lblCashbackDetails.text = cashback.offercondition
                                      
                                       cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
    //                                    print(cashback.offerpercentage,"persectage")
    //                                    print(cashback.offercondition, "decription")
                   cell1?.lblCashbackDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)

                   cell1?.readMoreBtn.hide(byHeight: true)
           }
               
              
                    //    }
               
               

               return cell1!
           }
           
       } else if number == 1 {
           
           if indexPath.section == 0 {
          
               if let offer = merchant?.offers?[0] {
                   
                   
                  
                  
                   if let subOffer = offer.subOffer?[indexPath.row]  {
                      
                       
                       if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                           
                           cell.lblTital.layer.cornerRadius = 4
                           cell.lblTital.layer.masksToBounds = true
                           cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                           cell.btnCardType.setImage(subOffer.image, for: .normal)
                           cell.lblDetails.text = subOffer.conditions
                           
                           cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                           
                           if offer.offerType == .Referral {
                               cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                           } else {
                               cell.lblCardValue.text =  subOffer.title
                           }
                           
      
                          
                           if appDelegate!.currency != "$" {
                               let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                               cell.lblCardValue.text = strTitle
                            //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                           }
    //                       if indexPath.row == 4{
    //                           if let cashback = merchant?.cashback{
    //                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
    //                               print(cashback.offerpercentage,"persectage")
    //                               print(cashback.offercondition, "decription")
    //
    //                           }
    //                       }
       //                    if let condition = subOffer.conditions, !condition.isBlank {
       //
       //                        if cell.lblDetails.calculateMaxLines() > 1 {
       //                            cell.btnReadMore.hide(byHeight: false)
       //                        } else {
       //                            cell.btnReadMore.hide(byHeight: true)
       //                        }
       //
       //                    }else {
                               cell.btnReadMore.hide(byHeight: true)
                           //}
       //                    cell.btnReadMore.touchUpInside { (sender) in
       //                        self.displayDetailsView(subOffer.conditions)
       //                    }
                           
                           switch subOffer.subOfferType {
                           case .Referral?:
                               cell.lblTital.backgroundColor = ColorCustomerAppTheme
                               
                           case .Bonus?:
                               cell.lblTital.backgroundColor = ColorBonus
                               
                           case .Reward?:
                               cell.lblTital.backgroundColor = ColorReward
                        
                               
                           default:
                               break
                           }
                           
                           cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                       
                           return cell
                       }
                   }
                   
                
               }
               
           }
           else if indexPath.section == 1 {
               
               if   merchant?.cashback?.offerpercentage ?? 0 > 1{
                   let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell

                   if let cashback = merchant?.cashback{
                       
                   cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
                                           cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
                                           cell1?.lblCashBackOffoerTitle.text = "Cashback  "
                                           cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
                                           cell1?.lblCashBackOffoerTitle.textAlignment = .center
                                           cell1?.lblCashbackDetails.text = cashback.offercondition
                                          
                                           cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
                       
                       cell1?.lblCashbackDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)

                       cell1?.readMoreBtn.hide(byHeight: true)
        //                                    print(cashback.offerpercentage,"persectage")
        //                                    print(cashback.offercondition, "decription")
               }
                    

                        //    }
                   
                   

                   return cell1!
               }
//               let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell
//
//                                   if let cashback = merchant?.cashback{
//                                       cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
//                                       cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
//                                       cell1?.lblCashBackOffoerTitle.text = " cash back  "
//                                       cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
//                                       cell1?.lblCashBackOffoerTitle.textAlignment = .center
//
//                                       cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
//    //                                    print(cashback.offerpercentage,"persectage")
//    //                                    print(cashback.offercondition, "decription")
//           }
//
//
//                    //    }
//
//
//
//               return cell1!
           }
           
       }else if number == 2 {
           
           if indexPath.section == 0 {
         
           
          
           
               if let offer = merchant?.offers?[0] {
                   
                   
                  
                  
                   if let subOffer = offer.subOffer?[indexPath.row]  {
                      
                       
                       if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                           
                           cell.lblTital.layer.cornerRadius = 4
                           cell.lblTital.layer.masksToBounds = true
                           cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                           cell.btnCardType.setImage(subOffer.image, for: .normal)
                           cell.lblDetails.text = subOffer.conditions
                           
                           cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                           
                           if offer.offerType == .Referral {
                               cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                           } else {
                               cell.lblCardValue.text =  subOffer.title
                           }
                           
      
                          
                           if appDelegate!.currency != "$" {
                               let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                               cell.lblCardValue.text = strTitle
                            //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                           }
    //                       if indexPath.row == 4{
    //                           if let cashback = merchant?.cashback{
    //                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
    //                               print(cashback.offerpercentage,"persectage")
    //                               print(cashback.offercondition, "decription")
    //
    //                           }
    //                       }
       //                    if let condition = subOffer.conditions, !condition.isBlank {
       //
       //                        if cell.lblDetails.calculateMaxLines() > 1 {
       //                            cell.btnReadMore.hide(byHeight: false)
       //                        } else {
       //                            cell.btnReadMore.hide(byHeight: true)
       //                        }
       //
       //                    }else {
                               cell.btnReadMore.hide(byHeight: true)
                           //}
       //                    cell.btnReadMore.touchUpInside { (sender) in
       //                        self.displayDetailsView(subOffer.conditions)
       //                    }
                           
                           switch subOffer.subOfferType {
                           case .Referral?:
                               cell.lblTital.backgroundColor = ColorCustomerAppTheme
                               
                           case .Bonus?:
                               cell.lblTital.backgroundColor = ColorBonus
                               
                           case .Reward?:
                               cell.lblTital.backgroundColor = ColorReward
                        
                               
                           default:
                               break
                           }
                           
                           cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                       
                           return cell
                       }
                   }
                   
                
               }
               
           }
           else if indexPath.section == 1 {
          
            
           
            
                if let offer = merchant?.offers?[1] {
                    
                    
                   
                   
                    if let subOffer = offer.subOffer?[indexPath.row]  {
                       
                        
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                            
                            cell.lblTital.layer.cornerRadius = 4
                            cell.lblTital.layer.masksToBounds = true
                            cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                            cell.btnCardType.setImage(subOffer.image, for: .normal)
                            cell.lblDetails.text = subOffer.conditions
                            
                            cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                            
                            if offer.offerType == .Referral {
                                cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                            } else {
                                cell.lblCardValue.text =  subOffer.title
                            }
                            
       
                           
                            if appDelegate!.currency != "$" {
                                let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                                cell.lblCardValue.text = strTitle
                             //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                            }
     //                       if indexPath.row == 4{
     //                           if let cashback = merchant?.cashback{
     //                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
     //                               print(cashback.offerpercentage,"persectage")
     //                               print(cashback.offercondition, "decription")
     //
     //                           }
     //                       }
        //                    if let condition = subOffer.conditions, !condition.isBlank {
        //
        //                        if cell.lblDetails.calculateMaxLines() > 1 {
        //                            cell.btnReadMore.hide(byHeight: false)
        //                        } else {
        //                            cell.btnReadMore.hide(byHeight: true)
        //                        }
        //
        //                    }else {
                                cell.btnReadMore.hide(byHeight: true)
                            //}
        //                    cell.btnReadMore.touchUpInside { (sender) in
        //                        self.displayDetailsView(subOffer.conditions)
        //                    }
                            
                            switch subOffer.subOfferType {
                            case .Referral?:
                                cell.lblTital.backgroundColor = ColorCustomerAppTheme
                                
                            case .Bonus?:
                                cell.lblTital.backgroundColor = ColorBonus
                                
                            case .Reward?:
                                cell.lblTital.backgroundColor = ColorReward
                         
                                
                            default:
                                break
                            }
                            
                            cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                        
                            return cell
                        }
                    }
                    
                 
                }
                
            }
           else if indexPath.section == 2 {
               
               if   merchant?.cashback?.offerpercentage ?? 0 > 1{
                   let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell

                   if let cashback = merchant?.cashback{
                       
                   cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
                                           cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
                                           cell1?.lblCashBackOffoerTitle.text = "Cashback  "
                                           cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
                                           cell1?.lblCashBackOffoerTitle.textAlignment = .center
                                          
                                             cell1?.lblCashbackDetails.text = cashback.offercondition
                                           cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
                       
                       cell1?.lblCashbackDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)

                       cell1?.readMoreBtn.hide(byHeight: true)
        //                                    print(cashback.offerpercentage,"persectage")
        //                                    print(cashback.offercondition, "decription")
               }
                    

                        //    }
                   
                   

                   return cell1!
               }
//               let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell
//
//                                   if let cashback = merchant?.cashback{
//                                       cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
//                                       cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
//                                       cell1?.lblCashBackOffoerTitle.textAlignment = .center
//                                       cell1?.lblCashBackOffoerTitle.text = " cash back  "
//                                       cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
//
//                                       cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
//    //                                    print(cashback.offerpercentage,"persectage")
//    //                                    print(cashback.offercondition, "decription")
//           }
//
//
//                    //    }
//
//
//
//               return cell1!
           }
           
       }else if number == 3 {
           
           if indexPath.section == 0 {
         
           
          
           
               if let offer = merchant?.offers?[0] {
                   
                   
                  
                  
                   if let subOffer = offer.subOffer?[indexPath.row]  {
                      
                       
                       if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                           
                           cell.lblTital.layer.cornerRadius = 4
                           cell.lblTital.layer.masksToBounds = true
                           cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                           cell.btnCardType.setImage(subOffer.image, for: .normal)
                           cell.lblDetails.text = subOffer.conditions
                           
                           cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                           
                           if offer.offerType == .Referral {
                               cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                           } else {
                               cell.lblCardValue.text =  subOffer.title
                           }
                           
      
                          
                           if appDelegate!.currency != "$" {
                               let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                               cell.lblCardValue.text = strTitle
                            //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                           }
    //                       if indexPath.row == 4{
    //                           if let cashback = merchant?.cashback{
    //                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
    //                               print(cashback.offerpercentage,"persectage")
    //                               print(cashback.offercondition, "decription")
    //
    //                           }
    //                       }
       //                    if let condition = subOffer.conditions, !condition.isBlank {
       //
       //                        if cell.lblDetails.calculateMaxLines() > 1 {
       //                            cell.btnReadMore.hide(byHeight: false)
       //                        } else {
       //                            cell.btnReadMore.hide(byHeight: true)
       //                        }
       //
       //                    }else {
                               cell.btnReadMore.hide(byHeight: true)
                           //}
       //                    cell.btnReadMore.touchUpInside { (sender) in
       //                        self.displayDetailsView(subOffer.conditions)
       //                    }
                           
                           switch subOffer.subOfferType {
                           case .Referral?:
                               cell.lblTital.backgroundColor = ColorCustomerAppTheme
                               
                           case .Bonus?:
                               cell.lblTital.backgroundColor = ColorBonus
                               
                           case .Reward?:
                               cell.lblTital.backgroundColor = ColorReward
                        
                               
                           default:
                               break
                           }
                           
                           cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                       
                           return cell
                       }
                   }
                   
                
               }
               
           }
           else if indexPath.section == 1 {
          
            
           
            
                if let offer = merchant?.offers?[1] {
                    
                    
                   
                   
                    if let subOffer = offer.subOffer?[indexPath.row]  {
                       
                        
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                            
                            cell.lblTital.layer.cornerRadius = 4
                            cell.lblTital.layer.masksToBounds = true
                            cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                            cell.btnCardType.setImage(subOffer.image, for: .normal)
                            cell.lblDetails.text = subOffer.conditions
                            
                            cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                            
                            if offer.offerType == .Referral {
                                cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                            } else {
                                cell.lblCardValue.text =  subOffer.title
                            }
                            
       
                           
                            if appDelegate!.currency != "$" {
                                let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                                cell.lblCardValue.text = strTitle
                             //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                            }
     //                       if indexPath.row == 4{
     //                           if let cashback = merchant?.cashback{
     //                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
     //                               print(cashback.offerpercentage,"persectage")
     //                               print(cashback.offercondition, "decription")
     //
     //                           }
     //                       }
        //                    if let condition = subOffer.conditions, !condition.isBlank {
        //
        //                        if cell.lblDetails.calculateMaxLines() > 1 {
        //                            cell.btnReadMore.hide(byHeight: false)
        //                        } else {
        //                            cell.btnReadMore.hide(byHeight: true)
        //                        }
        //
        //                    }else {
                                cell.btnReadMore.hide(byHeight: true)
                            //}
        //                    cell.btnReadMore.touchUpInside { (sender) in
        //                        self.displayDetailsView(subOffer.conditions)
        //                    }
                            
                            switch subOffer.subOfferType {
                            case .Referral?:
                                cell.lblTital.backgroundColor = ColorCustomerAppTheme
                                
                            case .Bonus?:
                                cell.lblTital.backgroundColor = ColorBonus
                                
                            case .Reward?:
                                cell.lblTital.backgroundColor = ColorReward
                         
                                
                            default:
                                break
                            }
                            
                            cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                        
                            return cell
                        }
                    }
                    
                 
                }
                
            }
           /*else if indexPath.section == 2 {
             
             
             
             
             if let offer = merchant?.offers?[2] {
                 
                 
                
                
                 if let subOffer = offer.subOffer?[indexPath.row]  {
                    
                     
                     if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                         
                         cell.lblTital.layer.cornerRadius = 4
                         cell.lblTital.layer.masksToBounds = true
                         cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                         cell.btnCardType.setImage(subOffer.image, for: .normal)
                         cell.lblDetails.text = subOffer.conditions
                         
                         cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                         
                         if offer.offerType == .Referral {
                             cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                         } else {
                             cell.lblCardValue.text =  subOffer.title
                         }
                         
    
                        
                         if appDelegate!.currency != "$" {
                             let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                             cell.lblCardValue.text = strTitle
                          //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                         }
  //                       if indexPath.row == 4{
  //                           if let cashback = merchant?.cashback{
  //                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
  //                               print(cashback.offerpercentage,"persectage")
  //                               print(cashback.offercondition, "decription")
  //
  //                           }
  //                       }
     //                    if let condition = subOffer.conditions, !condition.isBlank {
     //
     //                        if cell.lblDetails.calculateMaxLines() > 1 {
     //                            cell.btnReadMore.hide(byHeight: false)
     //                        } else {
     //                            cell.btnReadMore.hide(byHeight: true)
     //                        }
     //
     //                    }else {
                             cell.btnReadMore.hide(byHeight: true)
                         //}
     //                    cell.btnReadMore.touchUpInside { (sender) in
     //                        self.displayDetailsView(subOffer.conditions)
     //                    }
                         
                         switch subOffer.subOfferType {
                         case .Referral?:
                             cell.lblTital.backgroundColor = ColorCustomerAppTheme
                             
                         case .Bonus?:
                             cell.lblTital.backgroundColor = ColorBonus
                             
                         case .Reward?:
                             cell.lblTital.backgroundColor = ColorReward
                      
                             
                         default:
                             break
                         }
                         
                         cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                     
                         return cell
                     }
                 }
                 
              
             }
             
         } */
           else if indexPath.section == 3 {
               print("cashbackoffers ----- ",merchant?.cashback?.offerpercentage)
               if   merchant?.cashback?.offerpercentage ?? 0 > 1{
                   let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell

                   if let cashback = merchant?.cashback{
                       
                   cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
                                           cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
                                           cell1?.lblCashBackOffoerTitle.text = "Cashback  "
                                           cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
                                           cell1?.lblCashBackOffoerTitle.textAlignment = .center
                                           cell1?.lblCashbackDetails.text = cashback.offercondition
                                          
                                           cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
                       cell1?.lblCashbackDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)

                       cell1?.readMoreBtn.hide(byHeight: true)
        //                                    print(cashback.offerpercentage,"persectage")
        //                                    print(cashback.offercondition, "decription")
               }
                    

                        //    }
                   
                   

                   return cell1!
               }
//               let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell
//
//                                   if let cashback = merchant?.cashback{
//                                       cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
//                                       cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
//                                       cell1?.lblCashBackOffoerTitle.textAlignment = .center
//                                       cell1?.lblCashBackOffoerTitle.text = " cash back  "
//                                     //  cell1?.lblCashBackOffoerTitle.text = " cash back "
//                                       cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
//                                       cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
//    //                                    print(cashback.offerpercentage,"persectage")
//    //                                    print(cashback.offercondition, "decription")
//           }
//
//
//                    //    }
//
//
//
//               return cell1!
           }
           
       }
       
    /*   if indexPath.section == 0 {
     
       
      
       
           if let offer = merchant?.offers?[0] {
               
               
              
              
               if let subOffer = offer.subOffer?[indexPath.row]  {
                  
                   
                   if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                       
                       cell.lblTital.layer.cornerRadius = 4
                       cell.lblTital.layer.masksToBounds = true
                       cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                       cell.btnCardType.setImage(subOffer.image, for: .normal)
                       cell.lblDetails.text = subOffer.conditions
                       
                       cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                       
                       if offer.offerType == .Referral {
                           cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                       } else {
                           cell.lblCardValue.text =  subOffer.title
                       }
                       
  
                      
                       if appDelegate!.currency != "$" {
                           let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                           cell.lblCardValue.text = strTitle
                        //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                       }
//                       if indexPath.row == 4{
//                           if let cashback = merchant?.cashback{
//                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
//                               print(cashback.offerpercentage,"persectage")
//                               print(cashback.offercondition, "decription")
//
//                           }
//                       }
   //                    if let condition = subOffer.conditions, !condition.isBlank {
   //
   //                        if cell.lblDetails.calculateMaxLines() > 1 {
   //                            cell.btnReadMore.hide(byHeight: false)
   //                        } else {
   //                            cell.btnReadMore.hide(byHeight: true)
   //                        }
   //
   //                    }else {
                           cell.btnReadMore.hide(byHeight: true)
                       //}
   //                    cell.btnReadMore.touchUpInside { (sender) in
   //                        self.displayDetailsView(subOffer.conditions)
   //                    }
                       
                       switch subOffer.subOfferType {
                       case .Referral?:
                           cell.lblTital.backgroundColor = ColorCustomerAppTheme
                           
                       case .Bonus?:
                           cell.lblTital.backgroundColor = ColorBonus
                           
                       case .Reward?:
                           cell.lblTital.backgroundColor = ColorReward
                    
                           
                       default:
                           break
                       }
                       
                       cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                   
                       return cell
                   }
               }
               
            
           }
           
       }
      else if indexPath.section == 1 {
     
       
      
       
           if let offer = merchant?.offers?[1] {
               
               
              
              
               if let subOffer = offer.subOffer?[indexPath.row]  {
                  
                   
                   if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                       
                       cell.lblTital.layer.cornerRadius = 4
                       cell.lblTital.layer.masksToBounds = true
                       cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                       cell.btnCardType.setImage(subOffer.image, for: .normal)
                       cell.lblDetails.text = subOffer.conditions
                       
                       cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                       
                       if offer.offerType == .Referral {
                           cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                       } else {
                           cell.lblCardValue.text =  subOffer.title
                       }
                       
  
                      
                       if appDelegate!.currency != "$" {
                           let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                           cell.lblCardValue.text = strTitle
                        //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                       }
//                       if indexPath.row == 4{
//                           if let cashback = merchant?.cashback{
//                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
//                               print(cashback.offerpercentage,"persectage")
//                               print(cashback.offercondition, "decription")
//
//                           }
//                       }
   //                    if let condition = subOffer.conditions, !condition.isBlank {
   //
   //                        if cell.lblDetails.calculateMaxLines() > 1 {
   //                            cell.btnReadMore.hide(byHeight: false)
   //                        } else {
   //                            cell.btnReadMore.hide(byHeight: true)
   //                        }
   //
   //                    }else {
                           cell.btnReadMore.hide(byHeight: true)
                       //}
   //                    cell.btnReadMore.touchUpInside { (sender) in
   //                        self.displayDetailsView(subOffer.conditions)
   //                    }
                       
                       switch subOffer.subOfferType {
                       case .Referral?:
                           cell.lblTital.backgroundColor = ColorCustomerAppTheme
                           
                       case .Bonus?:
                           cell.lblTital.backgroundColor = ColorBonus
                           
                       case .Reward?:
                           cell.lblTital.backgroundColor = ColorReward
                    
                           
                       default:
                           break
                       }
                       
                       cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                   
                       return cell
                   }
               }
               
            
           }
           
       }     else if indexPath.section == 2 {
           
           
           
           
           if let offer = merchant?.offers?[2] {
               
               
              
              
               if let subOffer = offer.subOffer?[indexPath.row]  {
                  
                   
                   if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                       
                       cell.lblTital.layer.cornerRadius = 4
                       cell.lblTital.layer.masksToBounds = true
                       cell.lblTital.text = " \(subOffer.subOfferTitle ?? "") "
                       cell.btnCardType.setImage(subOffer.image, for: .normal)
                       cell.lblDetails.text = subOffer.conditions
                       
                       cell.lblDetails.addTrailingReadMore(with: "... ", alertTitle: "Conditions", moreText: "Read More", moreTextColor: ColorCustomerAppTheme, maxLines: 1)
                       
                       if offer.offerType == .Referral {
                           cell.lblCardValue.text =  "  \(subOffer.title ?? "")"
                       } else {
                           cell.lblCardValue.text =  subOffer.title
                       }
                       
  
                      
                       if appDelegate!.currency != "$" {
                           let strTitle = cell.lblCardValue.text?.replacingOccurrences(of: "$", with: "\(appDelegate!.currency)")
                           cell.lblCardValue.text = strTitle
                        //  cell.lblCardValue.font = UIFont(name: "Poppins-Medium", size: 10)
                       }
//                       if indexPath.row == 4{
//                           if let cashback = merchant?.cashback{
//                               cell.lblCardValue.text = "\(cashback.offerpercentage)"
//                               print(cashback.offerpercentage,"persectage")
//                               print(cashback.offercondition, "decription")
//
//                           }
//                       }
   //                    if let condition = subOffer.conditions, !condition.isBlank {
   //
   //                        if cell.lblDetails.calculateMaxLines() > 1 {
   //                            cell.btnReadMore.hide(byHeight: false)
   //                        } else {
   //                            cell.btnReadMore.hide(byHeight: true)
   //                        }
   //
   //                    }else {
                           cell.btnReadMore.hide(byHeight: true)
                       //}
   //                    cell.btnReadMore.touchUpInside { (sender) in
   //                        self.displayDetailsView(subOffer.conditions)
   //                    }
                       
                       switch subOffer.subOfferType {
                       case .Referral?:
                           cell.lblTital.backgroundColor = ColorCustomerAppTheme
                           
                       case .Bonus?:
                           cell.lblTital.backgroundColor = ColorBonus
                           
                       case .Reward?:
                           cell.lblTital.backgroundColor = ColorReward
                    
                           
                       default:
                           break
                       }
                       
                       cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                   
                       return cell
                   }
               }
               
            
           }
           
       }

       
       else if indexPath.section == 3 {
           let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell

                               if let cashback = merchant?.cashback{
                                   cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 4
                                   cell1?.lblCashBackOffoerTitle.layer.masksToBounds = true
                                   cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
                                  
                                   cell1?.lblCashBackOffoerValue.text = "cash back \(cashback.offerpercentage ?? 0)%"
//                                    print(cashback.offerpercentage,"persectage")
//                                    print(cashback.offercondition, "decription")
       }
           

                //    }
           
           

           return cell1!
       }
       */
       
//       else if merchant?.cashback?.offerpercentage ?? 0 > 0    {
//           let cell1 = tableView.dequeueReusableCell(withIdentifier: "CashBackOfferTableViewCell", for: indexPath) as? CashBackOfferTableViewCell
//
//                               if let cashback = merchant?.cashback{
//                                  cell1?.lblCashBackOffoerTitle.backgroundColor = ColorRewards
//                                   cell1?.lblCashBackOffoerTitle.layer.cornerRadius = 5
//                                   cell1?.lblCashBackOffoerValue.text = "\(cashback.offerpercentage ?? 0)%"
////                                    print(cashback.offerpercentage,"persectage")
////                                    print(cashback.offercondition, "decription")
//       }
//
//
//                //    }
//
//
//
//           return cell1!

       
       return UITableViewCell()
   }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       let number = merchant?.offers?.count ?? 0
       if merchant?.cashback?.offerpercentage ?? 0 > 1{
           
       }
       
       if number == 0{
           if section == 0 {
               return 0
           }else{
               return 0
           }
          
       }else if number == 1{
           if section == 0{
               return 36/375*CScreenWidth
           }else if section == 1{
               return 0
           }
       }else if number == 2{
           if section == 0{
               return 36/375*CScreenWidth
           }else if section == 1{
               return 36/375*CScreenWidth
           }else if section == 2{
               return 0
           }
       }else if number == 3{
           if section == 0{
               return 36/375*CScreenWidth
           }else if section == 1{
               return 36/375*CScreenWidth
           }else if section == 2{
               return 36/375*CScreenWidth
           }else if section == 3{
               return 0
           }
       }
       
       return 0
      
   }
   
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 1
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let number = merchant?.offers?.count ?? 0
       if number == 0 {
           return nil
       } else if number == 1 {
           if section == 0 {
               if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

                   if let offer = merchant?.offers?[0]  {
                       header.lblTitle.text = offer.offerTitle
                       if let expDate = offer.expiryDate?.dateFromString{
                           header.lblExpiresDate.text = "Expires on: \(expDate)"
                       }
                   }
                   return header
               }
           }else {
               return nil
           }
       }else if number == 2 {
           if section == 0 {
               if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

                   if let offer = merchant?.offers?[0]  {
                       header.lblTitle.text = offer.offerTitle
                       if let expDate = offer.expiryDate?.dateFromString{
                           header.lblExpiresDate.text = "Expires on: \(expDate)"
                       }
                   }
                   return header
               }
           }else if section == 1 {
               if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

                   if let offer = merchant?.offers?[1]  {
                       header.lblTitle.text = offer.offerTitle
                       if let expDate = offer.expiryDate?.dateFromString{
                           header.lblExpiresDate.text = "Expires on: \(expDate)"
                       }
                   }
                   return header
               }
           }else {
               return nil
           }
       } else if number == 3 {
           if section == 0 {
               if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

                   if let offer = merchant?.offers?[0]  {
                       header.lblTitle.text = offer.offerTitle
                       if let expDate = offer.expiryDate?.dateFromString{
                           header.lblExpiresDate.text = "Expires on: \(expDate)"
                       }
                   }
                   return header
               }
           }else if section == 1 {
               if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

                   if let offer = merchant?.offers?[1]  {
                       header.lblTitle.text = offer.offerTitle
                       if let expDate = offer.expiryDate?.dateFromString{
                           header.lblExpiresDate.text = "Expires on: \(expDate)"
                       }
                   }
                   return header
               }
           }else if section == 2 {
               if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

                   if let offer = merchant?.offers?[1]  {
                       header.lblTitle.text = offer.offerTitle
                       if let expDate = offer.expiryDate?.dateFromString{
                           header.lblExpiresDate.text = "Expires on: \(expDate)"
                       }
                   }
                   return header
               }
           }else {
               return nil
           }
       }
     /*
       if section == 0 {
           if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

               if let offer = merchant?.offers?[0]  {
                   header.lblTitle.text = offer.offerTitle
                   if let expDate = offer.expiryDate?.dateFromString{
                       header.lblExpiresDate.text = "Expires on: \(expDate)"
                   }
               }
               return header
           }
       }else if section == 1 {
           if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

               if let offer = merchant?.offers?[1]  {
                   header.lblTitle.text = offer.offerTitle
                   if let expDate = offer.expiryDate?.dateFromString{
                       header.lblExpiresDate.text = "Expires on: \(expDate)"
                   }
               }
               return header
           }
       }else if section == 2 {
           if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {

               if let offer = merchant?.offers?[2]  {
                   header.lblTitle.text = offer.offerTitle
                   if let expDate = offer.expiryDate?.dateFromString{
                       header.lblExpiresDate.text = "Expires on: \(expDate)"
                   }
               }
               return header
           }
       }
       else if section == 3{
           return nil
       }

*/
       return nil
   }
    
    
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//            if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {
//
//                if let offer = merchant?.offers?[0]  {
//                    header.lblTitle.text = offer.offerTitle
//                    if let expDate = offer.expiryDate?.dateFromString{
//                        header.lblExpiresDate.text = "Expires on: \(expDate)"
//                    }
//                }
//                return header
//            }
//
//            return nil
//        }
//
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         if  indexPath.section == 3 {
//             return 44
//         }else{
             return UITableViewAutomaticDimension
      //  }

     }
}
 // MARK:-
 // MARK:- UICollectionViewDataSource, UICollectionViewDelegate
 
 extension MerchantDetailsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBottomTab.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:CScreenWidth/CGFloat(arrBottomTab.count), height: collectionView.CViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantDetailsTabCollectionViewCell", for: indexPath) as? MerchantDetailsTabCollectionViewCell {
            
            if let data = arrBottomTab[indexPath.row] as? [String : Any]{
            
                switch data.valueForString(key: "optionType") {
                case "Rate","Refer":
                    cell.lblTitle.textColor = ColorButton_F50057
                default:
                    break
                }
                cell.vwContainer.alpha = data.valueForBool(key: "status")  ? 1.0 : 0.2
                cell.lblTitle.text = data.valueForString(key: "title")
                cell.btnType.setImage(data.valueForImage(key: "icon"), for: .normal)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let data = arrBottomTab[indexPath.row] as? [String : Any] {
            
            if !data.valueForBool(key: "status") {
                return
            }
            switch data.valueForString(key: "optionType") {
            case "ReferralAlerts":
                btnReferralClicked(UIButton())
            case "Redemption":
                btnUnclaimedClicked(UIButton())
            case "Rate":
                btnRateClicked(UIButton())
            case "Refer":
                btnReferClicked(UIButton())
            case "Cashback":
                btnCashbackClicked(UIButton())
            default:
                break
            }
        }
    }
 }
 

 // MARK:-
 // MARK:- Offer Details
 
 extension MerchantDetailsViewController {
    
    fileprivate func displayDetailsView(_ data : String?) {
        
        self.presentAlertViewWithOneButton(alertTitle: "Condition", alertMessage: data, btnOneTitle: CBtnClose) { (action) in
        }
    }
 }
