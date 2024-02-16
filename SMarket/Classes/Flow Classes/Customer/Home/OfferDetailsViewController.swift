//
//  OfferDetailsViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 06/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class OfferDetailsViewController: ParentViewController {
    
    let formatter = NumberFormatter()

    @IBOutlet var vwTblHeader : UIView!
    @IBOutlet weak var vWAlertView : UIView!
    @IBOutlet weak var vWAlertChildView : UIView!
    
    @IBOutlet var tblView : UITableView!
    @IBOutlet weak var imgVIcon : UIImageView!
    @IBOutlet var vWRatingV : RatingView!
    @IBOutlet weak var vWSeprator: UIView!
    
    @IBOutlet weak var btnOfferType : UIButton!
    @IBOutlet weak var btninvite: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblTagline : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblReview : UILabel!
    @IBOutlet weak var lblExpires : UILabel!
    @IBOutlet weak var lblOfferType : UILabel!
    @IBOutlet weak var lblOfferValue : UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblCondition : UILabel!
    @IBOutlet weak var lblConditionTitle : UILabel!
    
   var copystr = ""
    var merchant  : OfferList?
    var isNeedReload : Bool = true
    var arrData = [Any]()
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
        self.title = "OFFER DETAILS"
        
        vwTblHeader.CViewSetWidth(width: CScreenWidth)
        tblView.tableHeaderView = vwTblHeader
        prefillData()
        
    }
    fileprivate func prefillData() {
        
        if let offerData = iObject as? [String : Any] {
            
            merchant = OfferList(object: offerData)
            
            lblMerchantName.text = merchant?.name
            lblTagline.text = merchant?.tagLine
            lblReview.text = "(\(merchant?.noOfRating ?? "0"))"
            lblRatingCount.text = "\(merchant?.avgRating ?? 0.0)"
            vWRatingV.setRating(merchant?.avgRating ?? 0.0)
            lblDistance.text = "(\(merchant?.distance ?? "0.0") mi)"
            btnOfferType.setImage(merchant?.exclusiveImage, for: .normal)
            lblOfferType.text = merchant?.categoryName
            
            if merchant?.status == .Expire {
                lblExpires.textColor = merchant?.status == .Expire ? ColorRedExpireDate : ColorBlack_000000
                lblExpires.text = "Expired on: \(merchant?.expiryDate?.dateFromString ?? "-")"
            } else if merchant?.status == .Pending {
                lblExpires.text = "Expires on: \(merchant?.expiryDate?.dateFromString ?? "-")"
            } else if merchant?.status == .Redeemed {
                lblExpires.textColor = ColorRedExpireDate
                lblExpires.text = "Redeemed on: \(merchant?.redeemedDate?.dateFromString ?? "-")"
            } else {
                lblExpires.text = ""
            }
            
            imgVIcon.imageWithUrl(merchant?.logo)
            imgVIcon.touchUpInside { (imageView) in
                self.fullScreenImage(imageView, urlString: self.merchant?.logo)
            }
            
            if let condition = merchant?.conditions, !condition.isBlank  {
                vwTblHeader.CViewSetHeight(height: 200/375*CScreenWidth)
                lblCondition.text = condition
                vWSeprator.isHidden = false
            } else {
                vwTblHeader.CViewSetHeight(height: 110/375*CScreenWidth)
                lblCondition.text = ""
                lblConditionTitle.text = ""
                vWSeprator.isHidden = true
            }
            
            if merchant?.subOfferCategory == .InStore {
                lblOfferValue.text = ""
            }else {
                if (merchant?.amount?.isBlank)! {
                    lblOfferValue.text = ""
                } else {
                    let amountD = formatter.number(from: merchant?.amount ?? "0")
                    lblOfferValue.text = "\(currencyUnit)\(amountD ?? 0)"

//                    lblOfferValue.text = "\(currencyUnit)\(merchant?.amount ?? "0")"
                }
            }
            
            loadRefAlertsFromServer()
        }
    }
    

}

// MARK:-
// MARK:- Server Request

extension OfferDetailsViewController {
    
    
    fileprivate func loadRefAlertsFromServer() {
        
        var param = [String : Any]()
        param["id"] = merchant?.merchant_id
        param["page"] = page
        param["offer_id"] = merchant?.offer_id
        
        if page == 1 && arrData.count == 0 {
            tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        }
        
        APIRequest.shared().ReferralAtlertsDetails(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrData.removeAll()
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.arrData = self.arrData + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                } else {
                    self.page = 0
                }
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
                        
                        self.loadRefAlertsFromServer()
                        
                    })
                }
            }
        }
    }
    fileprivate func generateRedemptionCode(id : String?, merchantId : String?, indexPath : IndexPath) {
        
        var param = [String : Any]()
        param["id"] = id
        param["merchant_id"] = merchantId
        
        APIRequest.shared().generateRedemptionCodeAlerts(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let dataResponse = response as? [String : Any], let newData = dataResponse[CJsonData] as? [String: Any], newData.count > 0 {
                    
                    self.arrData = self.arrData.map({
                        var referal = $0
                        if var info = referal as? [String : Any] {
                            
                            info.updateValue(3, forKey: "referral_status")
                            referal = info
                        }
                        return referal
                    })
                    
                    self.arrData[indexPath.row] = newData
                    self.tblView.reloadData()
                    self.alertPopUpConfiguration()
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
                            friendListVC.navigation = .bonus
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

// MARK:-
// MARK:- Alert popUp Configuration

extension OfferDetailsViewController {
    
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

extension OfferDetailsViewController {
    
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
// MARK:- UITableViewDelegate, UITableViewDataSource

extension OfferDetailsViewController  : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferOfferTableViewCell") as? ReferOfferTableViewCell {
            
            if let data = arrData[indexPath.row] as? [String : Any] {
                
                let refAlert = RefAlert(object: data)
                
                cell.lblName.text = refAlert.name
                if let number = refAlert.mobile?.dropFirst(5) {
                    cell.lblMobile.text = "xxxxx\(number)"
                } else {
                    cell.lblMobile.text = "xxxxxxxxxx"
                }
                
                cell.imgVProfile.imageWithUrl(refAlert.profile_pic)
                cell.imgVProfile.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: refAlert.profile_pic)
                }
                // cell.lblMobile.text = refAlert.mobile
                cell.lblReferralDate.text = "Refferd on: \(refAlert.referred_date?.dateFromString ?? "-")"
                
                cell.lblRatingCount.text = "\(refAlert.rating?.toFloat ?? 0.0)"
                cell.vWRatingV.setRating(refAlert.rating?.toFloat ?? 0.0)
                
                if refAlert.product_image != ""  {
                    cell.imgVProduct.hide(byHeight: false)
                    cell.imgVProduct.imageWithUrl(refAlert.product_image)
                } else {
                    cell.imgVProduct.hide(byHeight: true)
                }
                
                cell.imgVProduct.touchUpInside { (imageView) in
                    self.fullScreenImage(imageView, urlString: refAlert.product_image)
                }
                if let review = refAlert.review, !review.isBlank  {
                    cell.lblReviews.text = refAlert.review
                    cell.lblReviewsTitle.hide(byHeight: false)
                } else {
                    cell.lblReviewsTitle.hide(byHeight: true)
                }
               
                cell.lblCode.text = refAlert.code
                copystr = cell.lblCode.text ?? ""
                cell.btnCopyText.touchUpInside { (copy) in
                    cell.lblCopyText.isHidden = false
                     let pasteboard = UIPasteboard.general
                    pasteboard.string = cell.lblCode.text!
                    UIPasteboard.general.string = cell.lblCode.text!
                    if let myString = UIPasteboard.general.string {
                        self.copystr = myString
                        
                        cell.lblCopyText.alpha = 0
                        cell.lblCopyText.text = "Code Copied"
                        cell.lblCopyText.fadeIn(completion: {
                                (finished: Bool) -> Void in
                                cell.lblCopyText.fadeOut()
                                })
                    }
//                    self.presentAlertViewWithOneButton(alertTitle: "Text Copied", alertMessage: "\(self.copystr)", btnOneTitle: "Ok") { (okButton) in
//                         
//                     }
                }
                cell.imgVCode.imageWithUrl(refAlert.qr_code_image)
                
                cell.btnGenerateCode.touchUpInside { (sender) in
                    self.generateRedemptionCode(id: refAlert.id, merchantId: refAlert.merchant_id, indexPath: indexPath)
                }
                
                
                switch refAlert.referral_status {
                    
                case .Pending?: // 1
                    cell.btnGenerateCode.isUserInteractionEnabled = true
                    cell.vwGeneratedCode.hide(byHeight: true)
                    cell.btnGenerateCode.alpha = 1
                    
                case .Accept?:  // 2
                    cell.btnGenerateCode.isUserInteractionEnabled = false
                    cell.vwGeneratedCode.hide(byHeight: false)
                    cell.btnGenerateCode.alpha = 0.5
                    
                case .Reject?: // 3
                    cell.btnGenerateCode.isUserInteractionEnabled = false
                    cell.vwGeneratedCode.hide(byHeight: true)
                    cell.btnGenerateCode.alpha = 0.5
                    
                default :
                    break
                    
                }
                cell.vwSeparator.hide(byHeight: indexPath.row == arrData.count - 1)
            }
            // load more
            if indexPath.row == arrData.count - 1 && page != 0 {
                self.loadRefAlertsFromServer()
            }
            
            return cell
        }
        return UITableViewCell()
    }
}
