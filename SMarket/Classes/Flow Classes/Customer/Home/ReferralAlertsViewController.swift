//
//  ReferralAlertsViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 05/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class ReferralAlertsViewController: ParentViewController, UISearchResultsUpdating{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblRefAlerts: GenericLabel!
    
    let formatter = NumberFormatter()

    var apiSessionTask : URLSessionTask?
    var apiUserSearchTask : URLSessionTask?
    var arrAlerts = [Any]()
    var searchArray = [String]()
    var baseReferralAlerts = [Any]()
   
    var page = 1
    
    var isFirstTime = true
    //MARK:-
    //MARK:- LIFE CYCLE
    let searchController = UISearchController(searchResultsController: nil)
    var titleLabel:UILabel?
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
       // titleLabel.titleTextAttributes = [NSAttributedStringKey.font:CFontPoppins(size: 19, type: .Medium), NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:CFontPoppins(size: 19, type: .Medium), NSAttributedStringKey.foregroundColor:UIColor.white]
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblRefAlerts.text = "\(appDelegate?.loginUser?.refferal_alert ?? "0")"
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
         self.title = "REFERRAL ALERTS"
        if let viewController = self.navigationController?.viewControllers {

            if !viewController.contains(where: { return $0 is MerchantSearchViewController }) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
            }
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        }
  
        loadReferralAlertListFromServer()
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
    
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
       // let searchtext = searchController.searchBar.text
          
//        if arrayAlert.contains(searchtext!) {
//            print(searchtext)
//        } else {
//            print("search text not available!")
//        }
    }
  
}
extension ReferralAlertsViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //self.navigationItem.rightBarButtonItem = nil
        arrAlerts.removeAll()
        if searchText == "" || searchText.count == 0 {
           // initialize()
             self.tblView.stopLoadingAnimation()
           arrAlerts = baseReferralAlerts
           
        }else {
          for data in baseReferralAlerts {
            let tempData = data as? [String : Any]
            var searchStr =  tempData?.valueForString(key: "business_name") as! String
            var taglineStr =   tempData?.valueForString(key: "tag_line") as! String
            var photostr =   tempData?.valueForString(key: "business_logo") as! String
              
            var photo = ""
            if photostr != "" && photostr.contains(".jpg"){
               photo = "photo"
            }
             
            if searchStr.lowercased().contains(searchText.lowercased()) || taglineStr.lowercased().contains(searchText.lowercased()) ||  photo.lowercased().contains(searchText.lowercased()){
                           arrAlerts.append(data)
                       }
                      
                   }
       
               }
    
         tblView.reloadData()
        
        if arrAlerts.count == 0 {
             self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
       // initialize()
       // searchBar.isHidden = true
         self.tblView.stopLoadingAnimation()
        self.arrAlerts = self.baseReferralAlerts
        self.tblView.reloadData()
        
        
        searchController.searchBar.isHidden = true
        
        titleLabel?.text = "REFERRAL ALERTS"
         self.navigationItem.titleView = titleLabel
        if let viewController = self.navigationController?.viewControllers {

            if !viewController.contains(where: { return $0 is MerchantSearchViewController }) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
            }
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        }

    }
}
// MARK:-
// MARK:- Server Request

extension ReferralAlertsViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadReferralAlertListFromServer()
    }
    
    fileprivate func loadReferralAlertListFromServer() {
        
        if apiSessionTask != nil && apiSessionTask?.state == .running {
            apiSessionTask?.cancel()
        }
        
        var param = [String : Any]()
        param["page"] = page
       
        if let id = iObject as? String {
            param["merchant_id"] = id
        }
        
        if page == 1 && arrAlerts.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
        apiSessionTask = APIRequest.shared().loadReferralAlerts(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            print("arrAlerts--->>>11111 ",response)
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                print("arrAlerts--->>> ",response)
                if self.page == 1 {
                    self.arrAlerts.removeAll()
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.baseReferralAlerts = self.baseReferralAlerts + data
                    self.arrAlerts = self.arrAlerts + data
                  print("arrAlerts--- ",self.arrAlerts)
                    self.page = self.page + 1
                   
                    self.tblView.reloadData()
                }
                else {
                    self.page = 0
                }
            }
            
            //For remove loader or display data not found
            if self.arrAlerts.count > 0 {
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

extension ReferralAlertsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrAlerts.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralAlertTableViewCell") as? ReferralAlertTableViewCell  {
          
            if let data = arrAlerts[indexPath.row] as? [String : Any] {
               
                let merchant = OfferList(object: data)
                    cell.lblMerchantName.text = merchant.name
                    cell.lblSubTitle.text = merchant.tagLine
                    cell.lblReviews.text = "(\(merchant.noOfRating ?? "0"))"
                    cell.lblRatingCount.text = "\(merchant.avgRating ?? 0.0)"
                    cell.vWRatingV.setRating(merchant.avgRating ?? 0.0)
                    cell.lblDistance.text = "(\(merchant.distance ?? "0.0") mi)"
//                    cell.lblStoreCredits.text = "\(appDelegate!.currency)\(merchant.storeCredit ?? "0")"
                let storeCredits = formatter.number(from:"\(merchant.storeCredit ?? "0")")
                                   cell.lblStoreCredits.text = "\(appDelegate!.currency)\(Int(storeCredits ?? 0))"
                    cell.lblReferrals.text = merchant.referrals
                    cell.btnOfferType.setImage(merchant.exclusiveImage, for: .normal)
                    cell.lblOfferType.text = merchant.categoryName
                    if merchant.status == .Expire {
                    cell.lblExpires.textColor = merchant.status == .Expire ? ColorRedExpireDate : ColorBlack_000000
                    cell.lblExpires.text = "Expired on: \(merchant.expiryDate?.dateFromString ?? "-")"
                    } else if merchant.status == .Pending {
                    cell.lblExpires.text = "Expires on: \(merchant.expiryDate?.dateFromString ?? "-")"
                    } else{
                    cell.lblExpires.text = ""
                    }
                    if merchant.status == .Redeemed {
                        cell.lblRedeemDate.text = "Redeemed on: \(merchant.redeemedDate?.dateFromString ?? "-")"
                    } else {
                        cell.lblRedeemDate.text = ""
                    }
                    cell.imgVIcon.imageWithUrl(merchant.logo)
                    cell.imgVIcon.touchUpInside { (imageView) in
                        self.fullScreenImage(imageView, urlString: merchant.logo)
                    }
                    
//                    switch merchant.subOfferCategory {
//                    case .GiftCard? :
//                        cell.lblOfferValue.text = "\(appDelegate!.currency)\(merchant.amount ?? "0")"
//                        cell.lblPurchaseBy.text = merchant.title
//
//                    case .InStore? :
//                        cell.lblOfferValue.text = ""
//                        cell.lblPurchaseBy.text = merchant.title
//
//                    case .StoreCredit? :
//                        cell.lblOfferValue.text = "\(appDelegate!.currency)\(merchant.amount ?? "0")"
//                        cell.lblPurchaseBy.text = merchant.purchasedBy
//                    default:
//                        break
//                    }
                switch merchant.subOfferCategory {
                                    case .GiftCard? :
                                        let numberAmount = formatter.number(from: merchant.amount ?? "0")
                                        print(numberAmount,"numberAmount")
                                        cell.lblOfferValue.text =  "\(appDelegate!.currency)\(Int(numberAmount ?? 0))"
                                       
                                        let giftCardWorth = formatter.number(from: merchant.title ?? "0")
                                        print(giftCardWorth,"giftCardWorth")
                                        cell.lblPurchaseBy.text = "Gift Card Worth \(currencyUnit)\(Int(giftCardWorth ?? 0))"
                                        
                                    case .InStore? :
                                        cell.lblOfferValue.text = ""
                                        cell.lblPurchaseBy.text = merchant.title
                                    case .StoreCredit? :
                                        let numberAmount = formatter.number(from: merchant.amount ?? "0")
                                        print(numberAmount,"StoreCredit")
                                        cell.lblOfferValue.text = "\(appDelegate!.currency)\(Int(numberAmount ?? 0))"
                                        cell.lblPurchaseBy.text = merchant.purchasedBy
                                    default:
                                        break
                                    }
                
              /*  cell.lblMerchantName.text = merchant.name
                cell.lblSubTitle.text = merchant.tagLine
                cell.lblReviews.text = "(\(merchant.noOfRating ?? "0"))"
                cell.lblRatingCount.text = "\(merchant.avgRating ?? 0.0)"
                cell.vWRatingV.setRating(merchant.avgRating ?? 0.0)
                cell.lblDistance.text = "(\(merchant.distance ?? "0.0") mi)"
                cell.lblStoreCredits.text = "\(currencyUnit)\(merchant.storeCredit ?? "0")"
                cell.lblReferrals.text = merchant.referrals
                cell.btnOfferType.setImage(merchant.exclusiveImage, for: .normal)
                cell.lblOfferType.text = merchant.categoryName
                
                if merchant.status == .Expire {
                    cell.lblExpires.textColor = merchant.status == .Expire ? ColorRedExpireDate : ColorBlack_000000
                    cell.lblExpires.text = "Expired on: \(merchant.expiryDate?.dateFromString ?? "-")"
                } else if merchant.status == .Pending {
                    cell.lblExpires.text = "Expires on: \(merchant.expiryDate?.dateFromString ?? "-")"
                } else{
                    cell.lblExpires.text = ""
                }
                if merchant.status == .Redeemed {
                    cell.lblRedeemDate.text = "Redeemed on: \(merchant.redeemedDate?.dateFromString ?? "-")"
                } else {
                    cell.lblRedeemDate.text = ""
                }

                cell.imgVIcon.imageWithUrl(merchant.logo)
                cell.imgVIcon.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: merchant.logo)
                }
                
                switch merchant.subOfferCategory {
                case .GiftCard? :
                    cell.lblOfferValue.text = "\(currencyUnit)\(merchant.amount ?? "0")"
                    cell.lblPurchaseBy.text = merchant.title
                    
                case .InStore? :
                    cell.lblOfferValue.text = ""
                    cell.lblPurchaseBy.text = merchant.title
                    
                case .StoreCredit? :
                    cell.lblOfferValue.text = "\(currencyUnit)\(merchant.amount ?? "0")"
                    cell.lblPurchaseBy.text = merchant.purchasedBy
                default:
                    break
                }*/
                
            }
            if indexPath.row == arrAlerts.count - 1 && page != 0 {
                self.loadReferralAlertListFromServer()
            }
            
            return cell
            
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let offerDetailsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "OfferDetailsViewController") as? OfferDetailsViewController {
            offerDetailsVC.iObject = arrAlerts[indexPath.row]
            self.navigationController?.pushViewController(offerDetailsVC, animated: true)
        }
    }
}

