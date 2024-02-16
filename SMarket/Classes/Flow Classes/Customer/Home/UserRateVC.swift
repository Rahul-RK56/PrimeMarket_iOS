//
//  UserRateVC.swift
//  SMarket
//
//  Created by Mac-00016 on 16/11/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class UserRateVC: ParentViewController {

    @IBOutlet var tblView : UITableView!
    
    var merchant  : OfferList?
    var arrRateReview = [Any]()
    var page = 1
    
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
        self.title = "Users Rate"
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
        loadMerchantRateReview()
    }
}

// MARK:-
// MARK:- Server request

extension UserRateVC {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadMerchantRateReview()
    }
    
    fileprivate func loadMerchantRateReview(){
        
        var param = [String : Any]()
        if let id = iObject as? String {
            param["id"] = id
        }
        param["page"] = page
        
        if page == 1 && arrRateReview.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
        APIRequest.shared().loadMerchantRateandReview(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
           
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                 if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    if self.page == 1 {
                        self.arrRateReview.removeAll()
                        self.tblView.reloadData()
                    }
                    
                    self.arrRateReview = self.arrRateReview + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                } else {
                    self.page = 0
                }
                
                //For remove loader or display data not found
                if self.arrRateReview.count > 0 {
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
}

// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension UserRateVC  : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRateReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferOfferTableViewCell") as? ReferOfferTableViewCell {
            
            if let data = arrRateReview[indexPath.row] as? [String : Any] {

                let rateReview = RateReview(object: data)

                cell.imgVProfile.imageWithUrl(rateReview.profilePic)
                cell.imgVProfile.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: rateReview.profilePic)
                }
                cell.lblMobile.text = rateReview.mobile
                cell.lblReferralDate.text = rateReview.rateOn
                
                cell.lblRatingCount.text = "\(rateReview.rating ?? 0.0)"
                cell.vWRatingV.setRating(rateReview.rating ?? 0.0)

                if rateReview.image != ""  {
                    cell.imgVProduct.hide(byHeight: false)
                    cell.imgVProduct.imageWithUrl(rateReview.image)
                } else {
                    cell.imgVProduct.hide(byHeight: true)
                }

                cell.imgVProduct.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: rateReview.image)
                }
                
                if let review = rateReview.review, !review.isBlank  {
                    cell.lblReviews.text = rateReview.review
                    cell.lblReviewsTitle.hide(byHeight: false)
                } else {
                    cell.lblReviewsTitle.hide(byHeight: true)
                }

            }
            // load more
            if indexPath.row == arrRateReview.count - 1 && page != 0 {
                self.loadMerchantRateReview()
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

