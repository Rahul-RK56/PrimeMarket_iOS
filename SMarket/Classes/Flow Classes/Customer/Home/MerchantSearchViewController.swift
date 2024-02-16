//
//  MerchantSearchViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 02/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MerchantSearchViewController: ParentViewController {

    let formatter = NumberFormatter()
    
    @IBOutlet weak var vWTitleView : UIView!
    @IBOutlet weak var vwFilter : UIView!
    
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnViewAllTopMerchant: UIButton!
    
    
   
    @IBOutlet weak var lblAddress: GenericLabel!
    @IBOutlet weak var lblSliderValue : UILabel!
    @IBOutlet weak var lblSearchRegion: UILabel!
    
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var slider : CustomSlider!
    
    @IBOutlet weak var cnSliderValueLeading : NSLayoutConstraint!
    @IBOutlet weak var cnSearchWidth : NSLayoutConstraint!
    
    var sliderValue : Float = 25
    var arrData = [Any]()
    var page = 1
    var searchText = String()
    var apiUserSearchTask : URLSessionTask?
    var isFirstTime = true
    var viewTag = Int()
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
         tblView.register( MerchantSearchTableViewCell.nib(), forCellReuseIdentifier:  MerchantSearchTableViewCell.identifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.navigationItem.titleView = vWTitleView
        view.backgroundColor = ColorCustomerAppTheme
        cnSearchWidth.constant = CScreenWidth - ((68/375*CScreenWidth) + 100)
        txtSearch.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .done, target: self, action: #selector(btnFilterClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_blue"), style: .done, target: self, action: #selector(btnSearchClicked))
        
        vwFilter.CViewSetWidth(width: CScreenWidth)
        vwFilter.CViewSetHeight(height: 282/375*CScreenWidth)
        btnViewAllTopMerchant.hide(byHeight: true)
        if searchText != "" {
            txtSearch.text = searchText
           // self.view.tag = viewTag
        }
         self.view.tag = viewTag
         self.pullToRefresh()
//        txtSearch.valueChangedEvent { (textField) in
//            self.pullToRefresh()
//        }
        if let pinCode = appDelegate?.loginUser?.post_code, pinCode != "" {
            self.txtZipCode.text = pinCode
            lblSearchRegion.text = "Search region: \(pinCode) , \(Int(self.slider.value)) mi radius"
        }else {
            self.txtZipCode.text = ""
            lblSearchRegion.text = "Search region: - , \(Int(self.slider.value)) mi radius"
        }
        
        
        if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
            if  country as! String == "+91" {
                appDelegate!.currency = currencyUnitRs
            }else{
                appDelegate!.currency = currencyUnit
            }
        }
        else{
            appDelegate?.currency = currencyUnit
        }
       
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            
            //.. Enable location service and update api
            var isNeedRefresh = true
            appDelegate?.enableLocationService({ (status, location) in
                
                if  status == .authorizedWhenInUse && location != nil && isNeedRefresh {
                    isNeedRefresh = false
                    
                    if let pinCode = appDelegate?.loginUser?.post_code, pinCode != "" {
                        self.txtZipCode.text = pinCode
                        self.lblSearchRegion.text = "Search region: \(pinCode) , \(Int(self.slider.value)) mi radius"
                    }else {
                        self.txtZipCode.text = ""
                        self.lblSearchRegion.text = "Search region: - , \(Int(self.slider.value)) mi radius"
                    }
                    
                    self.pullToRefresh()
                }else if status == .restricted || status == .denied{
                    isNeedRefresh = true
                    self.pullToRefresh()
                }
            })
        })
    
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            if self.viewTag == 301 {
                self.txtSearch.becomeFirstResponder()
            }
        })
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    @objc fileprivate func btnFilterClicked(){
        
        slider.value = sliderValue
        btnSliderValueChanged(slider)
        self.presentPopUp(view: vwFilter, shouldOutSideClick: false, type: .bottom) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.btnSliderValueChanged(self.slider)
        }

    }
    @objc fileprivate func btnSearchClicked(){
//
        self.tblView.startLoadingAnimation()
        initialize()
//        txtSearch.text = ""
      
        
    }
    

    @IBAction fileprivate func btnMerchantNotFoundClicked(_ sender : UIButton){
        
        if let referMerchantVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferMerchantViewController") as? ReferMerchantViewController {
            self.navigationController?.pushViewController(referMerchantVC, animated: true)
        }
    }
    
    @IBAction fileprivate func btnViewAllTopMerchantClicked(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        pullToRefresh()
    }
    
    @IBAction fileprivate func btnClearSearchBoxClicked(_ sender : UIButton){
        txtSearch.text = ""
        pullToRefresh()
    }
        
}

// MARK:-
// MARK:- FILTER VIEW CONFIGURATION

extension MerchantSearchViewController {
    
    // MARK:-
    // TODO: ACTION EVENT
    
    @IBAction fileprivate func btnResetClicked(_ sender : UIButton){
        
        slider.value = 25
        btnSliderValueChanged(slider)
        txtZipCode.text = ""
        self.dismissPopUp(view: vwFilter) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
    }
    
    @IBAction fileprivate func btnDoneClicked(_ sender : UIButton){
        
        self.dismissPopUp(view: vwFilter) {
            self.sliderValue = self.slider.value
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        if (txtZipCode.text?.isBlank)! {
            self.lblSearchRegion.text = "Search region: \(Int(self.slider.value)) mi radius"
        } else {
            self.lblSearchRegion.text = "Search region: \(txtZipCode.text!), \(Int(self.slider.value)) mi radius"
        }
        pullToRefresh()
    }
    
    @IBAction fileprivate func btnCloseClicked(_ sender : UIButton){
        self.dismissPopUp(view: vwFilter) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    @IBAction fileprivate func btnSliderValueChanged(_ sender : UISlider){
        
        let currentPosition = slider.getXPositionWithRespectToCurrentValue(thumbWidthPadding : 8.0)
        cnSliderValueLeading.constant = CGFloat(currentPosition ?? Float(cnSliderValueLeading.constant))
        lblSliderValue.text = "\(Int(sender.value)) mi"

    }
    
}

// MARK:-
// MARK:- Server Request

extension MerchantSearchViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        searchMerchantListFromServer()
    }
    
    fileprivate func searchMerchantListFromServer() {
        
        if apiUserSearchTask != nil && apiUserSearchTask?.state == .running {
            apiUserSearchTask?.cancel()
        }
        
        var param = [String : Any]()
        param["search_text"] = txtSearch.text
        param["post_code"] = txtZipCode.text
        param["distance"] = Int(self.slider.value)
        param["show_top_merchant"] = btnViewAllTopMerchant.isSelected == true ? 1 : 0
        param["page"] = page
                if page == 1  && arrData.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
        apiUserSearchTask = APIRequest.shared().loadSearchMerchant(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrData.removeAll()
                    
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.arrData = self.arrData + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                }else {
                    self.page = 0
                }
            }
            
            
            if self.isFirstTime && error == nil {
                self.btnViewAllTopMerchant.hide(byHeight: self.arrData.count == 0)
                self.isFirstTime = false
            }
            //For remove loader or display data not found
            if self.arrData.count > 0 {
                self.tblView.stopLoadingAnimation()
                
            } else if error == nil {
                self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                // ... -999 cancelled api
                // ... --1001 or -1009 no internet connection
                
                if error.code != -999 {
                    
                    self.tblView.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                        
                        self.pullToRefresh()
                        
                    })
                }
            }
        }
    }
}
    
// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension MerchantSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: MerchantSearchTableViewCell.identifier, for: indexPath) as! MerchantSearchTableViewCell
        
         if let data = arrData[indexPath.row] as? [String : Any] {
           
        let merchant = Merchant(object: data)
            print(merchant.name)
            cell1.lblMerchantName.text = merchant.name
           
            cell1.lblSubTitle.text = merchant.tagLine
            cell1.strFull = merchant.address!
            
            if cell1.strFull.count <= 60 {
                
                cell1.lessString = cell1.strFull
            }else {
                let index = cell1.strFull.index(cell1.strFull.startIndex, offsetBy: 60)
                 let mySubstring = cell1.strFull[..<index]
                cell1.lessString = String(mySubstring)
                
            }
            cell1.showSingleLineText()
            
            cell1.isExpanded = false
            if merchant.storeCredit == "0"{
                cell1.store_credit_MainView.isHidden = true
//                cell1.lblStoreCredits.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0") .0"
//                cell1.btnStoreCredt.touchUpInside { (sender) in
//
//                if let storeCreditVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "StoreCreditViewController") as? StoreCreditViewController {
//                  storeCreditVC.view.tag = 300
//
//
//                self.navigationController?.pushViewController(storeCreditVC, animated: true)
//                }
//                }
              
                
            }else{
                cell1.store_credit_MainView.isHidden = false
//                cell1.lblStoreCredits.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0") .0"
                let numberRefferal_alert = formatter.number(from: merchant.storeCredit ?? "0")
                                
                                cell1.lblStoreCredits.text = "\(appDelegate!.currency)\(Int(numberRefferal_alert ?? 0))"
                cell1.btnStoreCredt.touchUpInside { (sender) in
                   
                if let storeCreditVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "StoreCreditViewController") as? StoreCreditViewController {
                  storeCreditVC.view.tag = 300
                    
                    
                self.navigationController?.pushViewController(storeCreditVC, animated: true)
                }
                }
            }
            if merchant.referrals == "0" {
                cell1.referrals_MainView.isHidden = true
              //  cell1.lblreferal.text = merchant.referrals
//                cell1.lblreferal.text = "12.0"
//               cell1.btnReferralsAlerts.touchUpInside { (sender) in
//                   if let referralAlertsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralAlertsViewController") as? ReferralAlertsViewController {
//                     referralAlertsVC.view.tag = 300
//
//                       self.navigationController?.pushViewController(referralAlertsVC, animated: true)
//                   }
//               }
                
            }else{
                cell1.referrals_MainView.isHidden = false
               
                cell1.lblreferal.text = merchant.referrals
               cell1.btnReferralsAlerts.touchUpInside { (sender) in
                   if let referralAlertsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralAlertsViewController") as? ReferralAlertsViewController {
                     referralAlertsVC.view.tag = 300
                       
                       self.navigationController?.pushViewController(referralAlertsVC, animated: true)
                   }
               }
               
            }
            if merchant.coupon_count == "0" {
                cell1.coupons_MainView.isHidden = true
               // cell1.lblCoupons.text = merchant.coupon_count
//                cell1.lblCoupons.text = "12.0"
//               cell1.btnCoupons.touchUpInside { (sender) in
//                  if let resetVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FreindsOnMarketVC") as? FreindsOnMarketVC {
//                    resetVC.view.tag = 300
//                              self.navigationController?.pushViewController(resetVC, animated: true)
//                          }
//               }
              
            }else{
                cell1.coupons_MainView.isHidden = false
               
                cell1.lblCoupons.text = merchant.coupon_count
               cell1.btnCoupons.touchUpInside { (sender) in
                  if let resetVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FreindsOnMarketVC") as? FreindsOnMarketVC {
                    resetVC.view.tag = 300
                              self.navigationController?.pushViewController(resetVC, animated: true)
                          }
               }
               
            }
            if merchant.reward_count == "0" {
                cell1.awaiting_Alerts_MainView.isHidden = true
               // cell1.lblAwaiting.text = merchant.reward_count
//                cell1.lblAwaiting.text = "12.0"
//               cell1.btnAwaitingAlerts.touchUpInside { (sender) in
//                          if let rewardsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController {
//                       rewardsVC.view.tag = 300
//                       self.navigationController?.pushViewController(rewardsVC, animated: true)
//                   }
//
//               }
            }else{
                cell1.awaiting_Alerts_MainView.isHidden = false

                cell1.lblAwaiting.text = merchant.reward_count
               cell1.btnAwaitingAlerts.touchUpInside { (sender) in
                          if let rewardsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController {
                       rewardsVC.view.tag = 300
                       self.navigationController?.pushViewController(rewardsVC, animated: true)
                   }

               }

            }
     
          //cell1.lblStoreCredits.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0") .0"
            cell1.lblDistance.text = "(\(merchant.distance ?? "0") mi)"
           // cell1.lblReviews.text = "\(merchant.avgRating ?? "0.0")/5"
             
             if let value = Float(merchant.avgRating ?? "") {
                                            let roundedValue = String(format: "%.1f", value)
                                            print(roundedValue)
                              cell1.lblReviews.text = "\(roundedValue)/5"
                          }
            if merchant.avgRating == "0"{
                cell1.lblReviews.text =  "0.0/5"
            }else{
//                cell1.lblReviews.text = "\(merchant.avgRating ?? "0.0")/5"
            }
            cell1.vWRatingV.setRating(merchant.avgRating?.toFloat ?? 0.0)
            cell1.imgVIcon.imageWithUrl(merchant.logo)
//            cell1.imgVIcon.touchUpInside { (imageView) in
//                self.fullScreenImage(imageView, urlString: merchant.logo)
//            }
           
            if (merchant.website?.isBlank)!{
                 cell1.webView.isHidden = true
            }else{
                 cell1.webView.isHidden = false
            }
           
           
            cell1.btnWeb.touchUpInside { (sender) in
            print("goto web")
            self.openInSafari(strUrl: merchant.website)
            }
            cell1.btnDirection.touchUpInside { (sender) in
                print("goto direction")
                self.openGoogleMap(merchant.latitude, longitude: merchant.longitude, address: merchant.address)
            }
            
            if (merchant.mobile?.isBlank)!{
                 cell1.callView.isHidden = true
            }else{
                 cell1.callView.isHidden = false
            }
          //  cell1.btnCall.hide(byWidth: (merchant.mobile?.isBlank)!)
            cell1.btnCall.touchUpInside { (sender) in
                print("goto call")
                if let code = merchant.countryCode, let mobileNo = merchant.mobile {
                    self.openPhoneDialer(code + mobileNo)
                }
            }
            
            
            
            return cell1
        }
       
        
       
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantListTableViewCell") as? MerchantListTableViewCell  {
//            
//            
//            if let data = arrData[indexPath.row] as? [String : Any] {
//               
//                let merchant = Merchant(object: data)
//                
//                cell.lblMerchantName.text = merchant.name
//                cell.lblSubTitle.text = merchant.tagLine
//                cell.lblAddress.text = merchant.address
//                cell.lblStoreCredits.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0")"
//                cell.lblDistance.text = "(\(merchant.distance ?? "0") mi)"
//                cell.lblReviews.text = "\(merchant.avgRating ?? "0.0") (\(merchant.noOfRating ?? "0"))"
//                cell.vWRatingV.setRating(merchant.avgRating?.toFloat ?? 0.0)
//                cell.lblReferrals.text = merchant.referrals
//                cell.lblCoupons.text = "0"
//                cell.lblAwaitingAlerts.text = "0"
//                cell.imgVIcon.imageWithUrl(merchant.logo)
//                cell.imgVIcon.touchUpInside { (imageView) in
//                    self.fullScreenImage(imageView, urlString: merchant.logo)
//                }
//                cell.btnWeb.hide(byWidth: (merchant.website?.isBlank)!)
//                cell.btnWeb.touchUpInside { (sender) in
//                    self.openInSafari(strUrl: merchant.website)
//                }
//                cell.btnCall.hide(byWidth: (merchant.mobile?.isBlank)!)
//                cell.btnCall.touchUpInside { (sender) in
//                    if let code = merchant.countryCode, let mobileNo = merchant.mobile {
//                        self.openPhoneDialer(code + mobileNo)                        
//                    }
//                }                
//                cell.btnDirection.touchUpInside { (sender) in
//                    self.openGoogleMap(merchant.latitude, longitude: merchant.longitude, address: merchant.address)
//                }
//                
////                cell.btnLabelExpande.touchUpInside { (sender) in
////                    print("tapped")
////                    if cell.isExpanded == false {
////                    cell.lblAddress.numberOfLines = 3
////                        cell.isExpanded = true
////                      }else {
////                        cell.lblAddress.numberOfLines = 1
////                           cell.isExpanded = false
////                      }
////                }
//            }
//            if indexPath.row == arrData.count - 1 && page != 0 {
//                searchMerchantListFromServer()
//            }
//            return cell
//        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let detailVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as? MerchantDetailsViewController {
            let data = arrData[indexPath.row] as? [String : Any]
            detailVC.iObject = data?.valueForString(key: "id")
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MerchantSearchViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        //if desired
        txtSearch.resignFirstResponder()
        self.btnSearchClicked()
        return true
    }
}
