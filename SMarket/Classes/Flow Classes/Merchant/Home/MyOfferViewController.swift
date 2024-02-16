//
//  MyOfferViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 12/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class MyOfferViewController: ParentViewController {
    
    @IBOutlet weak var vwDetails : UIView!
    @IBOutlet weak var vwSendPDF : UIView!
    @IBOutlet weak var vwSendMsg : UIView!
    @IBOutlet weak var btnReferral : UIButton!
    @IBOutlet weak var btnRateReview : UIButton!
    @IBOutlet weak var btnCreateSendPDF : UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtViewMsg : UITextView!
    
    var arrOffer = [Offer]()
    var arrOffer1 : [Offer]?
    
    let formatter = NumberFormatter()
    
    //MARK:-
    //MARK:- LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tblView.reloadData()
            self.updateAddOfferStatus()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("country code",appDelegate?.loginUser?.country_code)
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
        initialize()
        tblView.separatorColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "MY OFFERS"
        txtViewMsg.layer.borderColor = ColorMerchantAppTheme.cgColor
        
        loadOfferListFromServer()
        
        let width = CScreenWidth - 40
        
        self.vwDetails.CViewSetWidth(width: width)
        self.vwDetails.CViewSetHeight(height: (120 / 335) * width)
        
        self.vwSendPDF.CViewSetWidth(width: width)
        self.vwSendPDF.CViewSetHeight(height: (167 / 335) * width)
        
        self.vwSendMsg.CViewSetWidth(width: width)
        self.vwSendMsg.CViewSetHeight(height: (177 / 335) * width)
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
        updateAddOfferStatus()        
    }
    
    
    fileprivate func updateAddOfferStatus(){
        
        //        if (self.arrOffer?.count ?? 0) < 2  {
        //            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "add_offer"), style: .plain, target: self, action: #selector(self.btnAddClicked))
        //        } else {
        //            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "add_offer"), style: .plain, target: self, action: #selector(self.btnAddClicked))
        //        }
        
        if (self.arrOffer.count ?? 0) > 0 {
            self.tblView.stopLoadingAnimation()
        }
        self.btnCreateSendPDF.hide(byHeight: self.arrOffer.count == 0)
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @objc fileprivate func btnAddClicked(_ sender : UIBarButtonItem) {
        
        if (arrOffer.filter({$0.offerType == .RateAndReview }).first) != nil {
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Add Referral Offer", btnOneStyle: .default) { (action) in
                if let createReferralVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
                    self.navigationController?.pushViewController(createReferralVC, animated: true)
                }
            }
        } else if (arrOffer.filter({$0.offerType == .Referral }).first) != nil {
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Add Rate & Review Offer", btnOneStyle: .default) { (action) in
                if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
                    self.navigationController?.pushViewController(createRateVC, animated: true)
                }
            }
            
        }else {
            
            self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Add Referral Offer", btnOneStyle: .default, btnOneTapped: { (action) in
                
                if let createReferralVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
                    self.navigationController?.pushViewController(createReferralVC, animated: true)
                }
                
                
            }, btnTwoTitle: "Add Rate & Review Offer", btnTwoStyle: .default, btnTwoTapped:  { (action) in
                
                if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
                    self.navigationController?.pushViewController(createRateVC, animated: true)
                }
            }, btnThreeTitle: "Add coupon", btnThreeStyle: .default) { (action) in
                
                if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateOfferCouponViewController") as? CreateOfferCouponViewController {
                    self.navigationController?.pushViewController(createRateVC, animated: true)
                }
            }
            
            
            
        }
    }
    
}

// MARK:-
// MARK:- Read More Configuration

extension MyOfferViewController {
    
    fileprivate  func createListCashBackFromServer(){

        APIRequest.shared().listCashBack(completion: { (response, error) in


            if APIRequest.shared().isJSONStatusValid(withResponse: response) {

                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]]{

                    print(data)
                    self.arrOffer1 = []
                    for item in data {
                        self.arrOffer1?.append(Offer(object: item))
                    }
                    self.tblView.reloadData()
                    print(self.arrOffer)
                    //MIToastAlert.shared.showToastAlert(position: .bottom, message: data.valueForString(key: CJsonMessage))
                }
            }
        })

    }
//
    fileprivate func displayDetailsView(_ data : String?) {
        
        self.presentAlertViewWithOneButton(alertTitle: "Condition", alertMessage: data, btnOneTitle: CBtnClose) { (action) in
        }
        
    }
    
    @IBAction fileprivate func btnCloseClicked(_ sender : UIButton) {
        self.dismissPopUp(view: vwDetails, completionHandler: nil)
    }
    @IBAction fileprivate func btnCancelClicked(_ sender : UIButton) {
        self.dismissPopUp(view: vwSendMsg, completionHandler: nil)
    }
    @IBAction func btnSendReferClicked(_ sender : UIButton) {
        
        if (txtViewMsg.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "Please enter message", btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
        self.dismissPopUp(view: vwSendMsg, completionHandler: nil)
        addReferMsg(params: ["message":txtViewMsg.text])
    }
}

// MARK:-
// MARK:- Send Mail Configuration

extension MyOfferViewController {
    
    func addReferMsg(params : [String:Any]){
        APIRequest.shared().addReferMsg(params) { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    print(data)
                    print(meta)
                }
            }
        }
    }
    
    @IBAction fileprivate func btnCreatePdfClicked(_ sender : UIButton) {
        createPDFAndSend()
    }
    
    @IBAction fileprivate func btnSendMailClicked(_ sender : UIButton) {
        
        if !btnReferral.isSelected && !btnRateReview.isSelected {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankSelection, btnOneTitle: CBtnOk) { (action) in
                self.btnCreatePdfClicked(UIButton())
            }
        } else {
            self.dismissPopUp(view: vwSendPDF) {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePdfSent, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    @IBAction fileprivate func btnCancleSendPdfClicked(_ sender : UIButton) {
        
        self.dismissPopUp(view: vwSendPDF, completionHandler: nil)
    }
    
    @IBAction fileprivate func btnCheckMarkClicked(_ sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
}

// MARK:-
// MARK:- Server Request

extension MyOfferViewController {
    
    @objc func pullToRefresh()  {
        loadOfferListFromServer()
    }
    
    fileprivate func loadOfferListFromServer() {
        
        if let refreshControl = tblView.pullToRefreshControl, refreshControl.isRefreshing {
        } else if arrOffer.count == 0 || arrOffer.count == nil {
            tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        }
        
        APIRequest.shared().loadOfferList() { (response, error) in
            
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]]{
                    
                    self.arrOffer = []
                    
                    
                    
                    for item in data {
                        if self.arrOffer.count == 0 {
                              self.arrOffer.append(Offer(object: item))
                        }else {
                            let off = Offer(object: item)
                            var isExistOfferType = false
                           let suboffers = off.subOffer ?? [SubOffer]()
                            
                            for dummyOff in self.arrOffer {
                                if off.offerType == dummyOff.offerType {
                                    isExistOfferType = true
                                    var dummysuboffers = dummyOff.subOffer ?? [SubOffer]()
                                    dummysuboffers += suboffers
                                    dummyOff.subOffer = dummysuboffers
                                    break
                                }
                            }
                            
                            if isExistOfferType == false {
                                  self.arrOffer.append(Offer(object: item))
                            }
                        }
                        
                      
                    }
                  //  self.createListCashBackFromServer()
                    
                }
                self.tblView.reloadData()
            }
            
            self.updateAddOfferStatus()
            
            //For remove loader or display data not found
            if (self.arrOffer.count ?? 0) > 0 {
                self.tblView.stopLoadingAnimation()
                
            } else if error == nil {
                self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                // ... -999 cancelled api
                // ... --1001 or -1009 no internet connection
                
                self.tblView.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                    
                    self.pullToRefresh()
                    
                })
            }
        }
    }
    
    fileprivate func createPDFAndSend() {
        
        APIRequest.shared().createPDFAndSendEmail() { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
    
    fileprivate func deleteOffer(_ offer : Offer, param : [String : Any], indexPath : IndexPath){
        
        var existofferTypes = [OfferType]()
        for off in arrOffer {
            existofferTypes.append(off.offerType!)
        }
     
        let section = indexPath.section
        if section == 0{
            if existofferTypes.contains(OfferType.Referral) {
                var index = section
                if existofferTypes.count == 3 {
                    
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    }else if existofferTypes[1] == OfferType.Referral {
                        index = 1
                    }else {
                        index = 2
                    }
                    
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    }else {
                        index = 1
                    }
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                
                
                APIRequest.shared().deleteOffer(param) { (response, error) in
                    
                    if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                        
//                        if offer.subOffer?.count == 1 {
//                            self.arrOffer.remove(at: index)
//
//
//                        }else {
//                            self.arrOffer[section].subOffer?.remove(at: indexPath.row - 1)
//
//                        }
                        
//                        self.updateAddOfferStatus()
//                        self.tblView.reloadData()
                        self.loadOfferListFromServer()
                        
                        if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                        }
                    }
                }
            }
        }
        if section == 1{
            if existofferTypes.contains(OfferType.RateAndReview) {
                var index = section
                if existofferTypes.count == 3 {
                    
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    }else if existofferTypes[1] == OfferType.RateAndReview {
                        index = 1
                    }else {
                        index = 2
                    }
                    
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    }else {
                        index = 1
                    }
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                
                
                APIRequest.shared().deleteOffer(param) { (response, error) in
                    
                    if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                        
//                        if offer.subOffer?.count == 1 {
//                            self.arrOffer.remove(at: index)
//
//
//                        }else {
//                            self.arrOffer[section].subOffer?.remove(at: indexPath.row - 1)
//
//                        }
                        
//                        self.updateAddOfferStatus()
//                        self.tblView.reloadData()
                        self.loadOfferListFromServer()
                        
                        if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                        }
                    }
                }
            }
        }
        if section == 2{
            
            if existofferTypes.contains(OfferType.CuponOffer) {
                var index = section
                if existofferTypes.count == 3 {
                    
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    }else if existofferTypes[1] == OfferType.CuponOffer {
                        index = 1
                    }else {
                        index = 2
                    }
                    
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    }else {
                        index = 1
                    }
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                let off = arrOffer[index]
                let count = off.subOffer?.count ?? 0
                
                
                APIRequest.shared().deleteOffer(param) { (response, error) in
                    
                    if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                     
//                        if offer.subOffer?.count == 1 {
//                            self.arrOffer.remove(at: index)
//                            
//                            
//                        }else {
//                            self.arrOffer[section].subOffer?.remove(at: indexPath.row - 1)
//                            
//                        }
                        
//                        self.update[AddOfferStatus()
//                         self.tblView.reloadData()
                        self.loadOfferListFromServer()
                        
                        if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                        }
                    }
                }
            }
        }
        
        //        APIRequest.shared().deleteOffer(param) { (response, error) in
        //
        //            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
        //
        //                if offer.subOffer?.count == 1 {
        //                    self.arrOffer.remove(at: indexPath.section)
        //
        //
        //                }else {
        //                    self.arrOffer[indexPath.section].subOffer?.remove(at: indexPath.row - 1)
        //
        //                }
        //
        //                self.updateAddOfferStatus()
        //                self.tblView.reloadData()
        //                self.loadOfferListFromServer()
        //
        //                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
        //                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
        //                }
        //            }
        //        }
    }
}

// MARK:-
// MARK:- UITableViewDelegate,UITableViewDataSource

extension MyOfferViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
        // return arrOffer?.count  ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var existofferTypes = [OfferType]()
        for off in arrOffer {
            existofferTypes.append(off.offerType!)
        }
        
        if section == 0 {
            
            if existofferTypes.contains(OfferType.Referral) {
                var index = section
                if existofferTypes.count == 3 {
                    
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    }else if existofferTypes[1] == OfferType.Referral {
                        index = 1
                    }else if existofferTypes[2] == OfferType.Referral {
                        index = 2
                    }else {
                        index = 2
                    }
                    
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    }else {
                        index = 1
                    }
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                let off = arrOffer[index]
                let count = off.subOffer?.count ?? 0
                return count + 1
            }
        }
        
        if section == 1 {
            
            
            if existofferTypes.contains(OfferType.RateAndReview) {
                var index = section
                if existofferTypes.count == 3 {
                    
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    }else if existofferTypes[1] == OfferType.RateAndReview {
                        index = 1
                    }else {
                        index = 2
                    }
                    
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    }else {
                        index = 1
                    }
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                let off = arrOffer[index]
                let count = off.subOffer?.count ?? 0
                return count + 1
            }
        }
        
        if section == 2 {
            
            if existofferTypes.contains(OfferType.CuponOffer) {
                var index = section
                if existofferTypes.count == 3 {
                    
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    }else if existofferTypes[1] == OfferType.CuponOffer {
                        index = 1
                    }else {
                        index = 2
                    }
                    
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    }else {
                        index = 1
                    }
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                let off = arrOffer[index]
                let count = off.subOffer?.count ?? 0
                return count + 1
            }
            
        }
        if section == 3 {
            
            
//            if existofferTypes.contains(OfferType.CashBackOffer) {
//                var index = section
//                if existofferTypes.count == 4 {
//
//                    if existofferTypes[0] == OfferType.CashBackOffer {
//                        index = 0
//                    }else if existofferTypes[1] == OfferType.CashBackOffer {
//                        index = 1
//                    }else {
//                        index = 2
//                    }
//
//                }else  if existofferTypes.count == 2 {
//                    if existofferTypes[0] == OfferType.CashBackOffer {
//                        index = 0
//                    }else {
//                        index = 1
//                    }
//                }else  if existofferTypes.count == 1 {
//                    index = 0
//                }
//
//                let off = arrOffer[index]
//                let count = off.subOffer?.count ?? 0
//                return count + 1
//            }
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var existofferTypes = [OfferType]()
        for off in arrOffer {
            existofferTypes.append(off.offerType!)
        }
        
        let section = indexPath.section
        
        if section == 0 {
            
            if existofferTypes.contains(OfferType.Referral) {
                //let offer = arrOffer[section]
                var index = section
                if existofferTypes.count == 4 {
                    
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    }else if existofferTypes[1] == OfferType.Referral {
                        index = 1
                    }else if existofferTypes[2] == OfferType.Referral {
                        index = 2
                    }else {
                        index = 3
                    }
                    
                }else  if existofferTypes.count == 3 {
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    } else if existofferTypes[1] == OfferType.Referral {
                        index = 1
                    }else {
                        index = 2
                    }
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.Referral {
                        index = 0
                    }else {
                        index = 1
                    }
                    
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                let offer = arrOffer[index]
                
                if indexPath.row == 0 {
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpireDateTableViewCell") as? ExpireDateTableViewCell {
                        
                        if let expDate = offer.expiryDate?.dateFromString {
                            cell.lblExpireDate.text = "Expires on: \(expDate)"
                        }
                        return cell
                    }
                } else {
                    
                    if let subOffer = offer.subOffer?[indexPath.row - 1]  {
                        
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                            
                            cell.lblTital.text = subOffer.subOfferTitle
                            //cell.lblCardValue.text =  subOffer.title
//                            if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
//                                if  country as! String == "+91" {
//                                    appDelegate!.currency = currencyUnitRs
//                                    cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnitRs
//                                    cell.lblCardValue.text =  subOffer.amount!
//                                }else{
//                                    appDelegate!.currency = currencyUnit
//                                    cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
//                                    cell.lblCardValue.text = subOffer.amount!
//                                  }
//                                }
//                            else{
//                                appDelegate?.currency = currencyUnit
//                                cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
//                                cell.lblCardValue.text =  subOffer.amount!
//                            }
                            
                            if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
                                                          if  country as! String == "+91" {
                                                              appDelegate!.currency = currencyUnitRs
                                                              cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnitRs
                                                              let gcwAmount = formatter.number(from: "\(subOffer.amount!)")
                                                              cell.lblCardValue.text =  "\(gcwAmount ?? 0)"
                                                          }else{
                                                              appDelegate!.currency = currencyUnit
                                                              cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
                                                              let gcwAmount = formatter.number(from: "\(subOffer.amount!)")
                                                              cell.lblCardValue.text = "\(gcwAmount ?? 0)"
                                                            }
                                                          }
                                                      else{
                                                          appDelegate?.currency = currencyUnit
                                                          cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
                                                          let gcwAmount = formatter.number(from: "\(subOffer.amount!)")
                                                          cell.lblCardValue.text =  "\(gcwAmount ?? 0)"
                                                      }
                            cell.btnCardType.setImage(subOffer.image, for: .normal)
                            cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                            if let condition = subOffer.conditions, !condition.isBlank {
                                cell.btnReadMore.hide(byHeight: false)
                            }else {
                                cell.btnReadMore.hide(byHeight: true)
                            }
                            
                            cell.btnReadMore.touchUpInside { (sender) in
                                self.displayDetailsView(subOffer.conditions)
                            }
                            cell.btnDelete.touchUpInside { (sender) in
                                
                                cell.btnDelete.isUserInteractionEnabled = false
                                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteOffer, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                                    cell.btnDelete.isUserInteractionEnabled = true
                                   
                                    let param = ["offer_id":offer.id!,
                                                 "sub_offer_id":subOffer.id!]
                                    self.deleteOffer(offer, param: param, indexPath: indexPath)
                                    
                                }, btnTwoTitle: CBtnNo, btnTwoTapped: { (action) in
                                    cell.btnDelete.isUserInteractionEnabled = true
                                })
                            }
                            return cell
                        }
                    }
                    // }
                }
                
            }
        }
        
        
        if section == 1 {
            
            if existofferTypes.contains(OfferType.RateAndReview) {
                
                var index = section
                if existofferTypes.count == 4 {
                    
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    }else if existofferTypes[1] == OfferType.RateAndReview {
                        index = 1
                    }else if existofferTypes[2] == OfferType.RateAndReview {
                        index = 2
                    }else {
                        index = 3
                    }
                    
                }else  if existofferTypes.count == 3 {
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    } else if existofferTypes[1] == OfferType.RateAndReview {
                        index = 1
                    }else {
                        index = 2
                    }
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.RateAndReview {
                        index = 0
                    }else {
                        index = 1
                    }
                    
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                let offer = arrOffer[index]
                
                if indexPath.row == 0 {
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpireDateTableViewCell") as? ExpireDateTableViewCell {
                        
                        if let expDate = offer.expiryDate?.dateFromString {
                            cell.lblExpireDate.text = "Expires on: \(expDate)"
                        }
                        return cell
                    }
                } else {
                    
                    if let subOffer = offer.subOffer?[indexPath.row - 1]  {
                        
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                            
                            cell.lblTital.text = subOffer.subOfferTitle
                           // cell.lblCardValue.text =  subOffer.title
//                           if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
//                            if  country as! String == "+91" {
//                                appDelegate!.currency = currencyUnitRs
//                                cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnitRs
//                               cell.lblCardValue.text =   subOffer.amount!
//                            }else{
//                                appDelegate!.currency = currencyUnit
//                                cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
//                                cell.lblCardValue.text =   subOffer.amount!
//                                }
//                            }
//                            else{
//                                appDelegate?.currency = currencyUnit
//                            cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
//                                cell.lblCardValue.text =   subOffer.amount!
//                            }
                            if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
                                                        if  country as! String == "+91" {
                                                            appDelegate!.currency = currencyUnitRs
                                                            cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnitRs
                                                            let gcwAmount = formatter.number(from: "\(subOffer.amount!)")
                                                           cell.lblCardValue.text =   "\(gcwAmount ?? 0)"
                                                        }else{
                                                            appDelegate!.currency = currencyUnit
                                                            cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
                                                            let gcwAmount = formatter.number(from: "\(subOffer.amount!)")
                                                            cell.lblCardValue.text =   "\(gcwAmount ?? 0)"
                                                            }
                                                        }
                                                        else{
                                                            appDelegate?.currency = currencyUnit
                                                            cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
                                                            let gcwAmount = formatter.number(from: "\(subOffer.amount!)")
                                                            cell.lblCardValue.text =   "\(gcwAmount ?? 0)"
                                                        }

                            
                            cell.btnCardType.setImage(subOffer.image, for: .normal)
                            cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                            if let condition = subOffer.conditions, !condition.isBlank {
                                cell.btnReadMore.hide(byHeight: false)
                            }else {
                                cell.btnReadMore.hide(byHeight: true)
                            }
                            
                            cell.btnReadMore.touchUpInside { (sender) in
                                self.displayDetailsView(subOffer.conditions)
                            }
                            cell.btnDelete.touchUpInside { (sender) in
                                
                                cell.btnDelete.isUserInteractionEnabled = false
                                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteOffer, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                                    cell.btnDelete.isUserInteractionEnabled = true
                                    let param = ["offer_id":offer.id!,
                                                 "sub_offer_id":subOffer.id!]
                                    self.deleteOffer(offer, param: param, indexPath: indexPath)
                                    
                                }, btnTwoTitle: CBtnNo, btnTwoTapped: { (action) in
                                    cell.btnDelete.isUserInteractionEnabled = true
                                })
                            }
                            return cell
                        }
                    }
                    // }
                }
                
            }
        }
        
        if section == 2 {
            
            if existofferTypes.contains(OfferType.CuponOffer) {
                
                var index = section
                if existofferTypes.count == 4 {
                    
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    }else if existofferTypes[1] == OfferType.CuponOffer {
                        index = 1
                    }else if existofferTypes[2] == OfferType.CuponOffer {
                        index = 2
                    }else {
                        index = 3
                    }
                    
                }else  if existofferTypes.count == 3 {
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    } else if existofferTypes[1] == OfferType.CuponOffer {
                        index = 1
                    }else {
                        index = 2
                    }
                }else  if existofferTypes.count == 2 {
                    if existofferTypes[0] == OfferType.CuponOffer {
                        index = 0
                    }else {
                        index = 1
                    }
                    
                }else  if existofferTypes.count == 1 {
                    index = 0
                }
                
                let offer = arrOffer[index]
                
                if indexPath.row == 0 {
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpireDateTableViewCell") as? ExpireDateTableViewCell {
                        
                        if let expDate = offer.expiryDate?.dateFromString {
                            cell.lblExpireDate.text = "Expires on: \(expDate)"
                        }
                        return cell
                    }
                } else {
                    
                    if let subOffer = offer.subOffer?[indexPath.row - 1]  {
                        
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                            
                            cell.lblTital.text = subOffer.subOfferTitle
                           // cell.lblCardValue.text =  subOffer.title
                            if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
                                if  country as! String == "+91" {
                                appDelegate!.currency = currencyUnitRs
                                cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnitRs
                                cell.lblCardValue.text =    subOffer.amount!
                                }else{
                                appDelegate!.currency = currencyUnit
                                    cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
                                cell.lblCardValue.text =   subOffer.amount!
                                }
                            }
                            else{
                                appDelegate?.currency = currencyUnit
                                cell.lblGiftcardWorth.text = "Gift Card Worth" + currencyUnit
                                cell.lblCardValue.text =  subOffer.amount!
                                }
                            cell.btnCardType.setImage(subOffer.image, for: .normal)
                            cell.vwSeprator.isHidden = offer.subOffer!.count == indexPath.row
                            if let condition = subOffer.conditions, !condition.isBlank {
                                cell.btnReadMore.hide(byHeight: false)
                            }else {
                                cell.btnReadMore.hide(byHeight: true)
                            }
                            
                            cell.btnReadMore.touchUpInside { (sender) in
                                self.displayDetailsView(subOffer.conditions)
                            }
                            cell.btnDelete.touchUpInside { (sender) in
                                
                                cell.btnDelete.isUserInteractionEnabled = false
                                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteOffer, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                                    cell.btnDelete.isUserInteractionEnabled = true
                                    
                                    let param = ["offer_id":offer.id!,
                                                 "sub_offer_id":subOffer.id!]
                                    self.deleteOffer(offer, param: param, indexPath: indexPath)
                                    
                                }, btnTwoTitle: CBtnNo, btnTwoTapped: { (action) in
                                    cell.btnDelete.isUserInteractionEnabled = true
                                })
                            }
                            
                            return cell
                        }
                    }
                    // }
                }
                
            }
        }
        if section == 3{
            
            
//            if existofferTypes.contains(OfferType.CashBack) {
//
//                var index = section
//                if existofferTypes.count == 4 {
//
//                    if existofferTypes[0] == OfferType.CashBack {
//                        index = 0
//                    }else if existofferTypes[1] == OfferType.CashBack {
//                        index = 1
//                    }else if existofferTypes[2] == OfferType.CashBack {
//                        index = 2
//                    }else {
//                        index = 3
//                    }
//
//                }else  if existofferTypes.count == 3 {
//                    if existofferTypes[0] == OfferType.CashBack {
//                        index = 0
//                    } else if existofferTypes[1] == OfferType.CashBack {
//                        index = 1
//                    }else {
//                        index = 2
//                    }
//                }else  if existofferTypes.count == 2 {
//                    if existofferTypes[0] == OfferType.CashBack {
//                        index = 0
//                    }else {
//                        index = 1
//                    }
//
//                }else  if existofferTypes.count == 1 {
//                    index = 0
//                }
//
//                let offer = arrOffer[index]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CashBackList1TableViewCell") as? CashBackList1TableViewCell {
                    let data = arrOffer1?[indexPath.row]
                    cell.cashBackLbl.text =  data?.offer_condition
                    
                    
                    // cell.cashBackLbl.text = data?.email
                                            cell.deleteButton.touchUpInside { (sender) in
                    
                                                cell.deleteButton.isUserInteractionEnabled = false
                                                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteOffer, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                                                    cell.deleteButton.isUserInteractionEnabled = true
                                                    let param = ["member_id":data?.memberID]
                                                   // self.deleteMember(param: param, indexPath: indexPath)
                    
                                                }, btnTwoTitle: CBtnNo, btnTwoTapped: { (action) in
                                                    cell.deleteButton.isUserInteractionEnabled = true
                                                })
                                            }
                    
                                            cell.editButton.touchUpInside { (sender) in
                    
                                                if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController
                                                
                                                {
                                                    addMemberVC.fromAmount = String(10)
                                                    addMemberVC.fromCondition = "test"
                                                    self.navigationController?.pushViewController(addMemberVC, animated: true)
                                                }
                    
                                            }
                    return cell
                }
                return UITableViewCell()

                
           // }
            
        }
        self.tblView.reloadData()
        
        //  let offer = arrOffer[indexPath.section] {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 36/375*CScreenWidth
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if let header  = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferHeaderTableViewCell") as? MerchantOfferHeaderTableViewCell {
            var existofferTypes = [OfferType]()
            for off in arrOffer {
                existofferTypes.append(off.offerType!)
            }
            
//            if section == 0 {
//                header.lblTitle.text = "Referral Offer"
//                
//                header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
//                
//                header.btnEdit.touchUpInside { (sender) in
//                    
//                    if let createReferralVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
//                        self.navigationController?.pushViewController(createReferralVC, animated: true)
//                    }
//                    
//                }
//                
//                
//            }
//            if section == 1 {
//
//                header.lblTitle.text = "Rate & Review Offer"
//
//                header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
//                header.btnEdit.touchUpInside { (sender) in
//
//                    if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
//                        self.navigationController?.pushViewController(createRateVC, animated: true)
//                    }
//
//                }
//
//
//            }
            
            
            if section == 0{
                           
                           header.lblTitle.text = "Referral"
                           if existofferTypes.contains(OfferType.Referral) {
                               var index = section
                               if existofferTypes.count == 4 {
                                   
                                   if existofferTypes[0] == OfferType.Referral {
                                       index = 0
                                   }else if existofferTypes[1] == OfferType.Referral {
                                       index = 1
                                   }else if existofferTypes[2] == OfferType.Referral {
                                       index = 2
                                   }else {
                                       index = 3
                                   }
                                   
                               }else  if existofferTypes.count == 3 {
                                   if existofferTypes[0] == OfferType.Referral {
                                       index = 0
                                   } else if existofferTypes[1] == OfferType.Referral {
                                       index = 1
                                   }else {
                                       index = 2
                                   }
                               }else  if existofferTypes.count == 2 {
                                   if existofferTypes[0] == OfferType.Referral {
                                       index = 0
                                   }else {
                                       index = 1
                                   }
                                   
                               }else  if existofferTypes.count == 1 {
                                   index = 0
                               }
                               
                               let off = arrOffer[index]
                               
                               if off.subOffer?.count ?? 0 == 0 {
                                   header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                                   header.btnEdit.touchUpInside { (sender) in
                                       
                                       if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
                                           createRateVC.isEditing = false
                                           self.navigationController?.pushViewController(createRateVC, animated: true)
                                       }
                                       
                                   }
                                   
                               }else {// Edit Here
                                   header.btnEdit.touchUpInside { (sender) in
                                       
                                       if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
                                           createRateVC.isEditing = true
                                           createRateVC.offerDetails = off
                                           self.navigationController?.pushViewController(createRateVC, animated: true)
                                       }
                                       
                                   }
                               }
                               
                               
                           }else {
                               header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                                header.btnEdit.touchUpInside { (sender) in
                                                         
                                if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
                                    createRateVC.isEditing = false
                                self.navigationController?.pushViewController(createRateVC, animated: true)
                                }
                                                         
                            }
                           }
                           
                       }
            
            if section == 1{
                
                header.lblTitle.text = "RateAndReview"
                if existofferTypes.contains(OfferType.RateAndReview) {
                    var index = section
                    if existofferTypes.count == 4 {
                        
                        if existofferTypes[0] == OfferType.RateAndReview {
                            index = 0
                        }else if existofferTypes[1] == OfferType.RateAndReview {
                            index = 1
                        }else if existofferTypes[2] == OfferType.RateAndReview {
                            index = 2
                        }else {
                            index = 3
                        }
                        
                    }else  if existofferTypes.count == 3 {
                        if existofferTypes[0] == OfferType.RateAndReview {
                            index = 0
                        } else if existofferTypes[1] == OfferType.RateAndReview {
                            index = 1
                        }else {
                            index = 2
                        }
                    }else  if existofferTypes.count == 2 {
                        if existofferTypes[0] == OfferType.RateAndReview {
                            index = 0
                        }else {
                            index = 1
                        }
                        
                    }else  if existofferTypes.count == 1 {
                        index = 0
                    }
                    
                    let off = arrOffer[index]
                    
                    if off.subOffer?.count ?? 0 == 0 {
                        header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                        header.btnEdit.touchUpInside { (sender) in
                            
                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
                                createRateVC.isEditing = false
                                self.navigationController?.pushViewController(createRateVC, animated: true)
                            }
                            
                        }
                        
                    }else {// Edit Here
                        header.btnEdit.touchUpInside { (sender) in
                            
                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
                                createRateVC.isEditing = true
                                createRateVC.offerDetails = off
                                self.navigationController?.pushViewController(createRateVC, animated: true)
                            }
                            
                        }
                    }
                    
                    
                }else {
                    header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                                          header.btnEdit.touchUpInside { (sender) in
                                              
                                              if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
                                                  createRateVC.isEditing = false
                                                  self.navigationController?.pushViewController(createRateVC, animated: true)
                                              }
                                              
                                          }
                }
                
                
                
                
            }
            
            if section == 2{
                
                header.lblTitle.text = "Coupon Offer"
                if existofferTypes.contains(OfferType.CuponOffer) {
                    var index = section
                    if existofferTypes.count == 4 {
                        
                        if existofferTypes[0] == OfferType.CuponOffer {
                            index = 0
                        }else if existofferTypes[1] == OfferType.CuponOffer {
                            index = 1
                        }else if existofferTypes[2] == OfferType.CuponOffer {
                            index = 2
                        }else {
                            index = 3
                        }
                        
                    }else  if existofferTypes.count == 3 {
                        if existofferTypes[0] == OfferType.CuponOffer {
                            index = 0
                        } else if existofferTypes[1] == OfferType.CuponOffer {
                            index = 1
                        }else {
                            index = 2
                        }
                    }else  if existofferTypes.count == 2 {
                        if existofferTypes[0] == OfferType.CuponOffer {
                            index = 0
                        }else {
                            index = 1
                        }
                        
                    }else  if existofferTypes.count == 1 {
                        index = 0
                    }
                    
                    let off = arrOffer[index]
                    
                    if off.subOffer?.count ?? 0 == 0 {
                        header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                        header.btnEdit.touchUpInside { (sender) in
                            
                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateOfferCouponViewController") as? CreateOfferCouponViewController {
                                createRateVC.isEditing = false
                                self.navigationController?.pushViewController(createRateVC, animated: true)
                            }
                            
                        }
                        
                    }else {// Edit Here
                        header.btnEdit.touchUpInside { (sender) in
                            
                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateOfferCouponViewController") as? CreateOfferCouponViewController {
                                createRateVC.isEditing = true
                                createRateVC.offerDetails = off
                                self.navigationController?.pushViewController(createRateVC, animated: true)
                            }
                            
                        }
                    }
                    
                    
                }else {
                    header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                    header.btnEdit.touchUpInside { (sender) in
                                              
                if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateOfferCouponViewController") as? CreateOfferCouponViewController {
                    createRateVC.isEditing = false
                    self.navigationController?.pushViewController(createRateVC, animated: true)
                    }
                                              
                }
                }
   
            }
            
          /*  if section == 3 {
                
                header.lblTitle.text = "CashBack Offer"
                if existofferTypes.contains(OfferType.CashBack) {
                    var index = section
                    if existofferTypes.count == 4 {
                        
                        if existofferTypes[0] == OfferType.CashBack {
                            index = 0
                        }else if existofferTypes[1] == OfferType.CashBack {
                            index = 1
                        }else if existofferTypes[2] == OfferType.CashBack {
                            index = 2
                        }else {
                            index = 3
                        }
                        
                    }else  if existofferTypes.count == 3 {
                        if existofferTypes[0] == OfferType.CashBack {
                            index = 0
                        } else if existofferTypes[1] == OfferType.CashBack {
                            index = 1
                        }else {
                            index = 2
                        }
                    }else  if existofferTypes.count == 2 {
                        if existofferTypes[0] == OfferType.CashBack {
                            index = 0
                        }else {
                            index = 1
                        }
                        
                    }else  if existofferTypes.count == 1 {
                        index = 0
                    }
                    
                    let off = arrOffer[index]
                    
                    if off.subOffer?.count ?? 0 == 0 {
                        header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                        header.btnEdit.touchUpInside { (sender) in
                            
                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateOfferCouponViewController") as? CreateOfferCouponViewController {
                                createRateVC.isEditing = false
                                self.navigationController?.pushViewController(createRateVC, animated: true)
                            }
                            
                        }
                        
                    }else {// Edit Here
                        header.btnEdit.touchUpInside { (sender) in
                            
                            if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController {
                                self.navigationController?.pushViewController(addMemberVC, animated: true)
                            }
                            
                        }
                    }
                    
                    
                }else {
                    header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
                    header.btnEdit.touchUpInside { (sender) in
                                              
                        if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController {
                            self.navigationController?.pushViewController(addMemberVC, animated: true)
                        }
                                              
                }
                }
                
   
            }  */
            
            /* if let offer = arrOffer?[section]  {
             // header.lblTitle.text = offer.offerTitle
             header.btnEdit.setImage(UIImage(named: "edit_offer"), for: .normal)
             
             // header.btnEdit.addTarget(self, action: #selector(btnAddClicked), for: .touchUpInside)
             //                if offer.subOffer?.count ?? 0 == 0 {
             //                    header.btnEdit.setImage(UIImage(named: "add_offer"), for: .normal)
             //                    header.btnEdit.touchUpInside { (sender) in
             //                        if (self.arrOffer?.filter({$0.offerType == .RateAndReview }).first) != nil {
             //                            if let createReferralVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
             //                                self.navigationController?.pushViewController(createReferralVC, animated: true)
             //                            }
             //                        }else if (self.arrOffer?.filter({$0.offerType == .Referral }).first) != nil {
             //                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
             //                                self.navigationController?.pushViewController(createRateVC, animated: true)
             //                            }
             //                        }else{
             //                            if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateOfferCouponViewController") as? CreateOfferCouponViewController {
             //                                self.navigationController?.pushViewController(createRateVC, animated: true)
             //                            }
             //                        }
             //
             //                    }
             //                    return header
             //                }
             
             header.btnEdit.touchUpInside { (sender) in
             if offer.offerType == .RateAndReview {
             //header.btnEdit.setImage(UIImage(named: "edit_offer"), for: .normal)
             if let createRateVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateRateAndReviewOfferViewController") as? CreateRateAndReviewOfferViewController {
             createRateVC.offerDetails = offer
             self.navigationController?.pushViewController(createRateVC, animated: true)
             
             }
             
             }else {
             
             if let createReferralVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateReferralOfferViewController") as? CreateReferralOfferViewController {
             createReferralVC.offerDetails = offer
             self.navigationController?.pushViewController(createReferralVC, animated: true)
             
             }
             
             }
             }
             
             }*/
            
            return header
        }
        
        return nil
    }
}
