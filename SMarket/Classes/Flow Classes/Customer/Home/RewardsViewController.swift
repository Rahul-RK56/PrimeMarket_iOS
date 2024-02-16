//
//  RewardsViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 07/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class RewardsViewController: ParentViewController, UISearchResultsUpdating {
    
    

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblRefAlerts: UILabel!
    
    var apiSessionTask : URLSessionTask?
    var arrRewards = [Any]()
     var searchArray = [String]()
     var baseRewards = [Any]()
    var page = 1
   
     let searchController = UISearchController(searchResultsController: nil)
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.delegate = self
        self.definesPresentationContext = true
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblRefAlerts.text = "\(appDelegate?.loginUser?.awaiting_rewards ?? "0")"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        self.title = "AWAITING REWARDS"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))

        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
        loadAWaitingRewardsFromServer()
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
        self.navigationItem.titleView = searchController.searchBar
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchController.searchBar.tintColor = .black
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search anting on SMARKET", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
            textfield.placeholder = "Search anything on SMARKET"
            textfield.textColor = UIColor.black
            textfield.layer.cornerRadius = 60

        }
        searchController.hidesNavigationBarDuringPresentation = false
        
//        if let searchVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantSearchViewController") as? MerchantSearchViewController {
//            self.navigationController?.pushViewController(searchVC, animated: true)
//        }
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension RewardsViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrRewards.removeAll()
               if searchText == "" || searchText.count == 0 {
                 arrRewards = baseRewards
               }else {
                   for data in baseRewards {
                       let tempData = data as? [String : Any]
                       var searchStr =  tempData?.valueForString(key: "business_name") as! String
                       if searchStr.lowercased().contains(searchText.lowercased()) {
                           arrRewards.append(data)
                       }
                       
                   }
               }
        
     
     
        tblView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      
        arrRewards.removeAll()
              if searchBar.text == "" || searchBar.text!.count == 0 {
                  arrRewards = baseRewards
              }else {
                  for data in baseRewards {
                          arrRewards.append(data)
                  }
              }
        searchBar.text = ""
        tblView.reloadData()
    }
}
// MARK:-
// MARK:- Server Request

extension RewardsViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadAWaitingRewardsFromServer()
    }
    
    fileprivate func loadAWaitingRewardsFromServer(){
        
        if apiSessionTask != nil && apiSessionTask?.state == .running {
            apiSessionTask?.cancel()
        }
        
        var param = [String : Any]()
        param["page"] = page
        
        if page == 1 && arrRewards.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
       apiSessionTask = APIRequest.shared().loadAwaitingRewards(param) { (response, error) in
            
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrRewards.removeAll()
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.baseRewards = self.baseRewards + data
                    self.arrRewards = self.arrRewards + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                }else {
                    
                    self.page = 0
                }
            }
            
            //For remove loader or display data not found
            if self.arrRewards.count > 0 {
                self.tblView.stopLoadingAnimation()
                
            } else if error == nil {
                //self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                self.tblView.showDataStatusView(imageName: "nofeed", text: CMessageNoResultAwaiting, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
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

extension RewardsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralAlertTableViewCell") as? ReferralAlertTableViewCell  {
            
            if let data = arrRewards[indexPath.row] as? [String : Any] {
                
                let merchant = OfferList(object: data)
                
                cell.lblMerchantName.text = merchant.name
                cell.lblSubTitle.text = merchant.tagLine
                cell.lblReviews.text = "(\(merchant.noOfRating ?? "0"))"
                cell.lblRatingCount.text = "\(merchant.avgRating ?? 0.0)"
                cell.vWRatingV.setRating(merchant.avgRating ?? 0.0)
                cell.lblDistance.text = "(\(merchant.distance ?? "0.0") mi)"
                cell.lblStoreCredits.text = "\(currencyUnit)\(merchant.storeCredit ?? "0")"
                cell.lblReferrals.text = merchant.referrals
                if merchant.subOfferCategory == .InStore {
                    cell.lblOfferValue.text = ""
                }else {
                    if (merchant.amount != "") {
                        cell.lblOfferValue.text = "\(currencyUnit)\(merchant.amount ?? "0")"
                    } else {
                        cell.lblOfferValue.text = ""
                    }
                    
                }
                cell.btnOfferType.setImage(merchant.exclusiveImage, for: .normal)
                cell.lblOfferType.text = merchant.categoryName
                cell.lblPurchaseBy.text = merchant.purchasedBy
                
                
                switch merchant.status {
                case .Expire:
                    cell.lblExpires.textColor = ColorRedExpireDate
                    cell.lblExpires.text = "Expired on: \(merchant.expiryDate?.dateFromString ?? "-")"
                case .Pending,
                     .Redeemed:
                    cell.lblExpires.text = "Expires on: \(merchant.expiryDate?.dateFromString ?? "-")"
                }
            
                cell.imgVIcon.imageWithUrl(merchant.logo)
                cell.imgVIcon.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: merchant.logo)
                }
                
            }
            
            if indexPath.row == arrRewards.count - 1 && page != 0 {
                self.loadAWaitingRewardsFromServer()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let offerDetailsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
            let data = arrRewards[indexPath.row] as? [String: Any]
            if data?.valueForInt(key: "status") != 2 {
                offerDetailsVC.qrDetailsType = .Offer
            }
            offerDetailsVC.iObject = data?.valueForString(key: "id")
            self.navigationController?.pushViewController(offerDetailsVC, animated: true)
        }
    }
}

