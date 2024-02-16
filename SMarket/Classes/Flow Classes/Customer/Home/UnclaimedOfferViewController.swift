//
//  UnclaimedOfferViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 05/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class UnclaimedOfferViewController: ParentViewController {
    
    @IBOutlet weak var btnClaimed : UIButton!
    @IBOutlet weak var btnRedeemed : UIButton!
    @IBOutlet weak var vWFilter : UIView!
    @IBOutlet weak var vWNavButton : UIView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet var cnVwSelectionLeading : NSLayoutConstraint!
    
    @IBOutlet weak var tblView: UITableView!
    var arrRedemption = [Any]()
    var page = 1
    var filterBy : Int?
    var apiSessionTask : URLSessionTask?
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "REDEMPTION HISTORY"
        
        if let viewController = self.navigationController?.viewControllers {
            
            if viewController.contains(where: { return $0 is MerchantSearchViewController }) {
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(btnFilterClicked(_:)))
            }else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: vWNavButton)
            }
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: vWNavButton)
        }
            //btnTabClicked(btnClaimed)
        
        vWFilter.CViewSetWidth(width: CScreenWidth)
        vWFilter.CViewSetHeight(height: 147/375*CScreenWidth)
        
        let fontSize : CGFloat = IS_iPhone_5 ? 10 : IS_iPhone_6_Plus ? 14 : 12
        segment.defaultConfiguration(font: CFontPoppins(size: fontSize, type: .Regular), color: .black)
        segment.selectedConfiguration(font: CFontPoppins(size: fontSize, type: .Regular), color: .white)
        
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
       // loadRedemptionHistoryFromServer()
        
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
    
    @IBAction fileprivate func btnSearchClicked(_ sender : UIBarButtonItem) {
        
        if let searchVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantSearchViewController") as? MerchantSearchViewController {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
        
    }
    @IBAction fileprivate func btnFilterClicked(_ sender : UIBarButtonItem) {
        
        if let  filterBy = filterBy {
            segment.selectedSegmentIndex = filterBy - 1
        }
        self.presentPopUp(view: vWFilter, shouldOutSideClick: false, type: .bottom) {
            
        }
    }
    @IBAction fileprivate func btnTabClicked(_ sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnClaimed.isSelected = false
        btnRedeemed.isSelected = false
        sender.isSelected = true
        
        UIView.animate(withDuration: 0.3) {
            
            self.cnVwSelectionLeading.constant = sender == self.btnRedeemed ? (CScreenWidth/2) : 0
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK:-
// MARK:- FILTER VIEW CONFIGURATION

extension UnclaimedOfferViewController {
    
    
    // MARK:-
    // TODO: ACTION EVENT
    
    @IBAction fileprivate func btnDoneClicked(_ sender : UIButton){
        
        self.dismissPopUp(view: vWFilter) {
            self.filterBy = self.segment.selectedSegmentIndex + 1
            self.pullToRefresh()
        }
        
    }
    @IBAction fileprivate func btnResetClicked(_ sender : UIButton){
            self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBAction fileprivate func btnCloseClicked(_ sender : UIButton){
        self.dismissPopUp(view: vWFilter) { }
    }
    
    @IBAction fileprivate func btnSegmentValueChanged(_ sender : UISegmentedControl){
        
    }
    
}

// MARK:-
// MARK:- Server Request

extension UnclaimedOfferViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadRedemptionHistoryFromServer()
    }
    
    fileprivate func loadRedemptionHistoryFromServer() {
        
        if apiSessionTask != nil && apiSessionTask?.state == .running {
            apiSessionTask?.cancel()
        }
        
        var param = [String : Any]()
        if let  filterBy = filterBy {
            param["filter_by"] =  filterBy
        }
        param["page"] = page
        
        if let id = iObject as? String {
            param["merchant_id"] = id
        }
        
        if page == 1 && arrRedemption.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
      apiSessionTask = APIRequest.shared().loadRedemptionHistory(param) { (response, error) in
        
            self.tblView.pullToRefreshControl?.endRefreshing()
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrRedemption.removeAll()
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.arrRedemption = self.arrRedemption + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                } else {
                    self.page = 0
                }
            }
            
            //For remove loader or display data not found
            if self.arrRedemption.count > 0 {
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

extension UnclaimedOfferViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRedemption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UnclaimedRedeemedOfferTableViewCell") as? UnclaimedRedeemedOfferTableViewCell  {
            
            if let data = arrRedemption[indexPath.row] as? [String : Any] {
                
                let merchant = OfferList(object: data)
                
                cell.lblMerchantName.text = merchant.name
                cell.lblSubTitle.text = merchant.tagLine
                cell.lblReviews.text = "(\(merchant.noOfRating ?? "0"))"
                cell.lblRatingCount.text = "\(merchant.avgRating ?? 0.0)"
                cell.vWRatingV.setRating(merchant.avgRating ?? 0.0)
                cell.lblDistance.text = "(\(merchant.distance ?? "0.0") mi)"
                cell.lblOfferValue.text = merchant.title
                cell.btnOfferType.setImage(merchant.image, for: .normal)
                cell.lblOfferType.text = merchant.subOfferTitle
                
                cell.imgVIcon.imageWithUrl(merchant.logo)
                cell.imgVIcon.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: merchant.logo)
                }
                
               // cell.lblExpires.textColor = merchant.status == .Expire ? ColorRedExpireDate : ColorBlack_000000
               // cell.lblExpires.text = "Expires on: \(merchant.expiryDate?.dateFromString ?? "-")"
                cell.lblExpires.text = "Redeemed on: \(merchant.redeemedDate?.dateFromString ?? "-")"
                cell.lblRedeemedDate.text = ""
            }
            // load more
            if indexPath.row == arrRedemption.count - 1 && page != 0 {
                self.loadRedemptionHistoryFromServer()
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let offerDetailsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
            let data = arrRedemption[indexPath.row] as? [String: Any]
            offerDetailsVC.iObject = data?.valueForString(key: "id")
            self.navigationController?.pushViewController(offerDetailsVC, animated: true)
        }
    }
}


