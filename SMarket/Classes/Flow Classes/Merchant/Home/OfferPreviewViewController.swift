//
//  OfferPreviewViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 13/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit


class OfferPreviewViewController: ParentViewController {
    
    @IBOutlet var imgMerchant : UIImageView!
    @IBOutlet var vWHeader : UIView!
    @IBOutlet var vwFooter : UIView!
    @IBOutlet var tblOffer : UITableView!
    @IBOutlet var vwRating : RatingView!
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblTagline : UILabel!
    @IBOutlet var lblReview : UILabel!
    @IBOutlet var lblRetingCount: UILabel!
    @IBOutlet var lblExpireDate : UILabel!
    @IBOutlet weak var btnCreatePdf: UIButton!
    var offerPreview : Offer?
    var fromVC = ""
    
    var couponImage : UIImage?
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        prefilledInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "PREVIEW"
        
        vWHeader.CViewSetWidth(width: CScreenWidth)
        vWHeader.CViewSetHeight(height: 222/375*CScreenWidth)
        vwFooter.CViewSetWidth(width: CScreenWidth)
        vwFooter.CViewSetHeight(height: 118/375*CScreenWidth)
        
        tblOffer.tableHeaderView = vWHeader
        //tblOffer.tableFooterView = vwFooter
    }
    fileprivate func prefilledInfo()  {
        imgMerchant.imageWithUrl(appDelegate?.loginUser?.picture)
        lblName.text = appDelegate?.loginUser?.name
        lblTagline.text = appDelegate?.loginUser?.tag_line
        lblReview.text = "\(appDelegate?.loginUser?.average_rating ?? "0.0")"
        lblRetingCount.text = "(\(appDelegate?.loginUser?.no_of_rating ?? "0"))"
        vwRating.rating = appDelegate?.loginUser?.average_rating?.toFloat ?? 0.0
        lblExpireDate.text = "Expires on: \(offerPreview?.expiryDate ?? "-")"
        
        imgMerchant.touchUpInside { (imageView) in
            self.fullScreenImage(imageView, urlString: appDelegate?.loginUser?.picture)
        }
        
    }
    
    fileprivate func popToViewController(_ arrOffer : [Any]?) {
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            if let myOfferVC = viewControllers[1] as? MyOfferViewController {
                
                if let arrOffer = arrOffer {
                    var offer = [Offer]()
                    for item in arrOffer {
                        offer.append(Offer(object: item))
                    }
                    myOfferVC.arrOffer = offer
                }
                self.navigationController?.popToViewController(myOfferVC, animated: true)
            }
            else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnSaveClicked(_ sender : UIButton) {
        
        if fromVC == "coupon" {
            createCouponOffer()
        }else{
            createEditOffer()
        }
        
    }
    
    @IBAction fileprivate func btnPdfClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

// MARK:-
// MARK:- Server Request

extension OfferPreviewViewController {
    
    fileprivate func createEditOffer() {
        
        var param = [String : Any]()
        
        if offerPreview != nil {
            
            if let id = offerPreview?.id {
                param["id"] = id
            }
            param["offer_type"] = offerPreview?.offerType?.rawValue
            param["expiry_date"] = offerPreview?.expiryDate?.dateFromString(displayDateFormate, toDateFormate: serverDateFormate)
            param["mail_pdf"] = btnCreatePdf.isSelected ? "1" : "0"
            
            if let arr_SubOffer = offerPreview?.subOffer {
                
                var arrSubOffer = [[String : Any]]()
                for sub_Offer in arr_SubOffer {
                    
                    var dictSubOffer = [String : Any]()
                    if let id = sub_Offer.id {
                        dictSubOffer["id"] = id
                    }
                    dictSubOffer["sub_offer_type"] = sub_Offer.subOfferType?.rawValue
                    dictSubOffer["sub_offer_category"] = sub_Offer.subOfferCategory?.rawValue
                    dictSubOffer["conditions"] = sub_Offer.conditions
                    
                    if sub_Offer.subOfferCategory == .InStore {
                        dictSubOffer["title"] = sub_Offer.title
                    }else {
                        dictSubOffer["amount"] = sub_Offer.amount
                    }

                    arrSubOffer.append(dictSubOffer)
                }
                
                param["sub_offer"] = arrSubOffer
            }
        }
        
        APIRequest.shared().addEditOffer(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    self.popToViewController(json[CJsonData] as? [Any])
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
    
    fileprivate func createCouponOffer() {
        
        var param = [String : Any]()
        
        if offerPreview != nil {
            
            if let id = offerPreview?.id {
                param["id"] = id
            }
            param["offer_type"] = 3
            param["expiry_date"] = offerPreview?.expiryDate?.dateFromString(displayDateFormate, toDateFormate: serverDateFormate)
            param["mail_pdf"] = btnCreatePdf.isSelected ? "1" : "0"
            
            if let arr_SubOffer = offerPreview?.subOffer {
                
                var arrSubOffer = [[String : Any]]()
                for sub_Offer in arr_SubOffer {
                    
                    var dictSubOffer = [String : Any]()
                    if let id = sub_Offer.id {
                        dictSubOffer["id"] = id
                    }
                    dictSubOffer["sub_offer_type"] =  5    //sub_Offer.subOfferType?.rawValue
                    dictSubOffer["sub_offer_category"] = sub_Offer.subOfferCategory?.rawValue
                    dictSubOffer["conditions"] = sub_Offer.conditions
                    
                    
                    
                    if sub_Offer.subOfferCategory == .InStore {
                        dictSubOffer["title"] = sub_Offer.title
                    }else {
                        dictSubOffer["amount"] = sub_Offer.amount
                    }
                    dictSubOffer["coupon_image"] =  couponImage
                    arrSubOffer.append(dictSubOffer)
                }
                
                param["sub_offer"] = arrSubOffer
            }
        }
        
        let data = (couponImage != nil ? UIImageJPEGRepresentation(couponImage!, imageComprassRatio) : nil)
        
        print(param)
        APIRequest.shared().addCouponOffer(param, imgProfileData: data) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    self.popToViewController(json[CJsonData] as? [Any])
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
    
    fileprivate func createPDFAndSend(_ data :[Any]?) {
        
        APIRequest.shared().createPDFAndSendEmail() { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                self.popToViewController(data)
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
}

// MARK:-
// MARK:-  UITableViewDelegate,UITableViewDataSource

extension OfferPreviewViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let offer = offerPreview {
            
            return offer.subOffer?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
            
            if let offer = offerPreview {
                
                if let subOffer = offer.subOffer?[indexPath.row] {
                    cell.lblTital.text = subOffer.subOfferTitle
                    cell.lblCardValue.text = subOffer.title
                    cell.btnCardType.setImage(subOffer.image, for: .normal)
                    cell.lblDetails.text = subOffer.conditions
                    
                    if let condition = subOffer.conditions, !condition.isBlank {
                        cell.lblTitleDetails.hide(byHeight: false)
                        cell.lblDetails.hide(byHeight: false)
                    
                    }else {
                        cell.lblTitleDetails.hide(byHeight: true)
                        cell.lblDetails.hide(byHeight: true)
                    }
                }
                cell.vwSeprator.isHidden = indexPath.row == ((offer.subOffer?.count ?? 1) - 1)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
}
