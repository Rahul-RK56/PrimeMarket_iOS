//
//  StoreCreditViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 07/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class StoreCreditViewController: ParentViewController,UISearchResultsUpdating {
   
    let formatter = NumberFormatter()

    @IBOutlet weak var vwGenerateRedemptionCode :UIView!
    @IBOutlet weak var imgVIcon :UIImageView!
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblTagline : UILabel!
    @IBOutlet weak var lblTotalCredit : UILabel!
    @IBOutlet weak var lblCurrency : UILabel!
    @IBOutlet weak var txtCredit : UITextField!
    @IBOutlet weak var btnGenerateCode : UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    var arrCredit = [Any]()
    var baseCredit = [Any]()
    var searchArray = [String]()
    var page = 1
    var selectedMerchant : Merchant?
    var apiSessionTask : URLSessionTask?
    var titleLabel:UILabel?
    
    let searchController = UISearchController(searchResultsController: nil)
    var amountSymbol:String = ""
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.delegate = self
        self.definesPresentationContext = true
        initialize()
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        self.title = "STORE CREDITS"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
    
        redemptionPopUpConfiguration()
        lblCurrency.text = appDelegate!.currency
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl

        loadStoreCreditListFromServer()
        
        //.. Enable location service and update api
        var isNeedRefresh = true
        appDelegate?.enableLocationService({ (status, location) in
            
            if  status == .authorizedWhenInUse && location != nil && isNeedRefresh {
                isNeedRefresh = false
                self.pullToRefresh()
            }else if status == .restricted || status == .denied{
                isNeedRefresh = true
                self.pullToRefresh()
            }
        })
    }
    
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @objc fileprivate func btnSearchClicked(_ sender : UIBarButtonItem) {
        self.searchController.searchBar.layer.cornerRadius = self.searchController.searchBar.bounds.height/1.5
               self.searchController.searchBar.clipsToBounds = true
                searchController.searchBar.isHidden = false
               self.navigationItem.rightBarButtonItem = nil
               
        self.navigationItem.titleView = searchController.searchBar
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchController.searchBar.tintColor = .black
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search anting on SMARKET", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
            textfield.placeholder = "Search anything on SMARKET"
            textfield.textColor = UIColor.black
           
            textfield.layer.cornerRadius = textfield.layer.frame.size.height
                       UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white

        }
        searchController.hidesNavigationBarDuringPresentation = false
//        if let searchVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantSearchViewController") as? MerchantSearchViewController {
//            self.navigationController?.pushViewController(searchVC, animated: true)
//        }
        
    }
    func updateSearchResults(for searchController: UISearchController) {
         //  let searchtext = searchController.searchBar.text
       }
}

extension StoreCreditViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        arrCredit.removeAll()
        if searchText == "" || searchText.count == 0 {
            arrCredit = baseCredit
            self.tblView.stopLoadingAnimation()
        }else {
            for data in baseCredit {
                let tempData = data as? [String : Any]
                var searchStr =  tempData?.valueForString(key: "business_name") as! String
                if searchStr.lowercased().contains(searchText.lowercased()) {
                    arrCredit.append(data)
                }
                
            }
        }
   
       
        tblView.reloadData()
        
        if arrCredit.count == 0 {
             self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tblView.stopLoadingAnimation()
              self.arrCredit = self.baseCredit
              self.tblView.reloadData()
        
        searchController.searchBar.isHidden = true
      //  initialize()
        titleLabel?.text = "STORE CREDITS"
        self.navigationItem.titleView = titleLabel
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
//        arrCredit.removeAll()
//        if searchBar.text == "" || searchBar.text!.count == 0 {
//            arrCredit = baseCredit
//        }else {
//            for data in baseCredit {
//                    arrCredit.append(data)
//            }
//        }
//        searchBar.text = ""
//        tblView.reloadData()
    }
}
// MARK:-
// MARK:- Redemption popUp Configuration

extension StoreCreditViewController {
    
    func redemptionPopUpConfiguration()  {
        
        vwGenerateRedemptionCode.CViewSetWidth(width: 335/375*CScreenWidth)
        vwGenerateRedemptionCode.CViewSetHeight(height: 315/375*CScreenWidth)
        vwGenerateRedemptionCode.layer.cornerRadius = 5
        vwGenerateRedemptionCode.layer.masksToBounds = true
        txtCredit.layer.cornerRadius = 10
        txtCredit.layer.masksToBounds = true
        btnGenerateCode.layer.cornerRadius = 10
        btnGenerateCode.layer.masksToBounds = true
        txtCredit.addLeftImage(strImgName: nil, padding: 36, imageContentMode: .Center)
    }
    
    func openRedemptionPopUp(_ indexPath : IndexPath)  {
        
        txtCredit.text = ""
        if let data = arrCredit[indexPath.row] as? [String : Any] {
            selectedMerchant = Merchant(object: data)
            
            imgVIcon.imageWithUrl(self.selectedMerchant?.logo)
            lblMerchantName.text = self.selectedMerchant?.name
            lblTagline.text = self.selectedMerchant?.tagLine
            let val = self.selectedMerchant?.countryCode
            if val == "+91"{
                amountSymbol = "₹"
            }else{
                amountSymbol = "$"
            }
           
//            lblTotalCredit.text = "You have \(val == "+91" ? "₹" : "$")\(selectedMerchant?.storeCredit ?? "0") available as the usable store credit. Enter store credit redemption amount in below here to redeem store credit."
            
            let numberAmount = formatter.number(from: selectedMerchant?.storeCredit ?? "0")
            lblTotalCredit.text = "You have \(val == "+91" ? "₹" : "$")\(Int(numberAmount ?? 0)) available as the usable store credit. Enter store credit redemption amount in below here to redeem store credit."
            
            self.presentPopUp(view: vwGenerateRedemptionCode, shouldOutSideClick: false, type: .center) {
                
            }
        }
    }
    
    @IBAction fileprivate func btnCloseClicked(_ sender:UIButton) {
        self.dismissPopUp(view: vwGenerateRedemptionCode) {  }
    }
    
    @IBAction fileprivate func btnGenerateCodeClicked(_ sender:UIButton) {
        
        if (txtCredit.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankStoreCredit, btnOneTitle: CBtnOk) { (action) in
            }
        } else {
            if (txtCredit.text?.toInt ?? 0) <= (selectedMerchant?.storeCredit?.toInt ?? 0) {
                self.dismissPopUp(view: vwGenerateRedemptionCode) {
                     self.generateRedemption()
                }
            } else {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankStoreCredit, btnOneTitle: CBtnOk) { (action) in
                }
            }
        }
    }
}

// MARK:-
// MARK:- Server Request

extension StoreCreditViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadStoreCreditListFromServer()
    }
    
    fileprivate func loadStoreCreditListFromServer() {
        
        if apiSessionTask != nil && apiSessionTask?.state == .running {
            apiSessionTask?.cancel()
        }
        
        var param = [String : Any]()
        param["page"] = page
        
        if page == 1 && arrCredit.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
      apiSessionTask = APIRequest.shared().loadStoreCredit(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    if self.page == 1 {
                        self.arrCredit.removeAll()
                        self.tblView.reloadData()
                    }
                    
                    self.baseCredit = self.baseCredit + data
                     self.arrCredit = self.arrCredit + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                }else {
                    self.page = 0
                }
            }
            
            //For remove loader or display data not found
            if self.arrCredit.count > 0 {
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
    fileprivate func generateRedemption() {
        
        var param = [String : Any]()
        param["id"] = self.selectedMerchant?.id
        param["amount"] = self.txtCredit.text
        
        APIRequest.shared().generateRedemptionCode(param) { (response, error) in
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any],let data = json[CJsonData] as? [String : Any] {
                    
                    self.showAlertView(meta.valueForString(key: CJsonMessage), completion: { (action) in
                        if let offerDetailsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
                            offerDetailsVC.iObject = data
                            offerDetailsVC.merchant_ID = self.selectedMerchant?.id ?? ""
                            offerDetailsVC.symbol = self.amountSymbol
                            offerDetailsVC.qrDetailsType = .StoreCreditOffer
                            self.navigationController?.pushViewController(offerDetailsVC, animated: true)
                        }
                    })
                }
            }
        }
    }
}

// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension StoreCreditViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCredit.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantListTableViewCell") as? MerchantListTableViewCell  {
         
                
                if let data = arrCredit[indexPath.row] as? [String : Any] {
                let merchant = Merchant(object: data)
                    
                    cell.lblMerchantName.text = merchant.name
                    cell.lblSubTitle.text = merchant.tagLine
                    cell.lblAddress.text = merchant.address
                    let val = merchant.countryCode
                    if val == "+91"{
                        cell.lblStoreCredits.text = "\(appDelegate!.currencyINDIA)\(merchant.storeCredit ?? "0")"
                    }else{
                        cell.lblStoreCredits.text = "\(appDelegate!.currencyUSA)\(merchant.storeCredit ?? "0")"
                    }
                   
                    cell.lblDistance.text = "(\(merchant.distance ?? "0") mi)"
                               
                    cell.imgVIcon.imageWithUrl(merchant.logo)
                    cell.imgVIcon.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: merchant.logo)
                    }
                    cell.btnWeb.hide(byWidth: (merchant.website?.isBlank)!)
                    cell.btnWeb.touchUpInside { (sender) in
                    self.openInSafari(strUrl: merchant.website)
                    }
                    cell.btnCall.hide(byWidth: (merchant.mobile?.isBlank)!)
                    cell.btnCall.touchUpInside { (sender) in
                    if let code = merchant.countryCode, let mobileNo = merchant.mobile {
                    self.openPhoneDialer(code + mobileNo)
                      }
                }
                    cell.btnDirection.touchUpInside { (sender) in
                     self.openGoogleMap(merchant.latitude, longitude: merchant.longitude, address: merchant.address)
                    }
                }
            //}
         /*   if let data = arrCredit[indexPath.row] as? [String : Any] {
                let merchant = Merchant(object: data)
              //  var searchStr =  data.valueForString(key: "business_name")
              //  storeCredit.append(searchStr)
                cell.lblMerchantName.text = merchant.name
                cell.lblSubTitle.text = merchant.tagLine
                cell.lblAddress.text = merchant.address
                cell.lblStoreCredits.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0")"
                cell.lblDistance.text = "(\(merchant.distance ?? "0") mi)"
                
                cell.imgVIcon.imageWithUrl(merchant.logo)
                cell.imgVIcon.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: merchant.logo)
                }
                cell.btnWeb.hide(byWidth: (merchant.website?.isBlank)!)
                cell.btnWeb.touchUpInside { (sender) in
                    self.openInSafari(strUrl: merchant.website)
                }
                cell.btnCall.hide(byWidth: (merchant.mobile?.isBlank)!)
                cell.btnCall.touchUpInside { (sender) in
                    if let code = merchant.countryCode, let mobileNo = merchant.mobile {
                        self.openPhoneDialer(code + mobileNo)
                    }
                }
                cell.btnDirection.touchUpInside { (sender) in
                    self.openGoogleMap(merchant.latitude, longitude: merchant.longitude, address: merchant.address)
                }
            } */
            
            if indexPath.row == arrCredit.count - 1 && page != 0 {
                self.loadStoreCreditListFromServer()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openRedemptionPopUp(indexPath)
        
    }
}
