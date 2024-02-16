//
//  MerchantSearchTableViewCell.swift
//  SMarket
//
//  Created by Dhana Gadupooti on 05/08/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

class MerchantSearchTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var directionView: UIView!
    
    @IBOutlet weak var webView: UIView!
    
    @IBOutlet weak var callView: UIView!
    
    
    static let identifier = "MerchantSearchTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "MerchantSearchTableViewCell", bundle: nil)
        
    }
    @IBOutlet weak var store_credit_MainView: UIView!
    
    @IBOutlet weak var referrals_MainView: UIView!
    // @IBOutlet weak var referrals_MainView: UIView!
    @IBOutlet weak var awaiting_Alerts_MainView: UIView!
    @IBOutlet weak var coupons_MainView: UIView!
 //   @IBOutlet weak var awaiting_Alerts_MainView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgVIcon : UIImageView!
    @IBOutlet weak var lblMerchantName : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    
    
    @IBOutlet weak var lblStoreCredits : UILabel!
    @IBOutlet weak var lblReferrals : UILabel!
    @IBOutlet weak var lblReviews : UILabel!
    @IBOutlet weak var vWRatingV : RatingView!
    
    @IBOutlet weak var btnLabelExpande: UIButton!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnWeb : UIButton!
    @IBOutlet weak var btnCall : UIButton!
    @IBOutlet weak var btnDirection : UIButton!
    @IBOutlet weak var btnStoreCredt: UIButton!
    
    @IBOutlet weak var btnCoupons: UIButton!
    @IBOutlet weak var scoreCreditView: UIView!
    @IBOutlet weak var lblCoupons: GenericLabel!
    
    @IBOutlet weak var btnReferralsAlerts: UIButton!
    
    @IBOutlet weak var btnAwaitingAlerts: UIButton!
    @IBOutlet weak var awaitingAlertsView: UIView!
    @IBOutlet weak var couponsView: UIView!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var lblStoreCredit: UILabel!

    @IBOutlet weak var lblcoupon:UILabel!

    @IBOutlet weak var lblreferal: GenericLabel!
    
    @IBOutlet weak var referalalertview: UIView!
    @IBOutlet weak var lblAwaitingAlert: GenericLabel!
//@IBOutlet weak var lblReferralAlert: GenericLabel!
    
    @IBOutlet weak var lblAwaiting: GenericLabel!
    @IBOutlet weak var awaitingView: UIView!
    
    @IBOutlet weak var lblReferralAlert: GenericLabel!
    
    @IBOutlet weak var lblAwaitingAlerts: GenericLabel!
    var isExpanded = false
    
  //  @IBOutlet weak var lblAwaitingAlerts: GenericLabel!
    
    let kCharacterBeforReadMore =  30
    let kReadMoreText           =  "Read more"
    let kReadLessText           =  "Read less"
    var strFull = ""
    var lessString = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // strFull =  lblAddress.text as! String
        
        // lblAddress.delegate = self
        btnWeb.tintColor = ColorCustomerAppTheme
        btnCall.tintColor = ColorCustomerAppTheme
        btnDirection.tintColor = ColorCustomerAppTheme
        
        
        
        
        //                scoreCreditView.layer.cornerRadius = 5
        //                scoreCreditView.layer.borderWidth = 1.5
        //                self.scoreCreditView.layer.borderColor = UIColor(red:197/255, green:0/255, blue:147/255, alpha: 1).cgColor
       // lblStoreCredits.font =  UIFont.systemFont(ofSize: 10, weight: .bold)
        //lblStoreCredits.textColor = colorPink
        
        
        //                self.referralView.layer.cornerRadius = 5
        //                self.referralView.layer.borderWidth = 1.5
        //                 self.referralView.layer.borderColor = UIColor(red:243/255, green:80/255, blue:37/255, alpha: 1).cgColor
        lblreferal.textColor = colorOrange
        
        //                self.awaitingAlertsView.layer.cornerRadius = 5
        //                self.awaitingAlertsView.layer.borderWidth = 1.5
        //                self.awaitingAlertsView.layer.borderColor = UIColor(red:23/255, green:192/255, blue:227/255, alpha: 1).cgColor
        lblAwaiting.textColor = colorLightBule
        
        //                self.couponsView.layer.cornerRadius = 5
        //                self.couponsView.layer.borderWidth = 1.5
        //                self.couponsView.layer.borderColor = UIColor(red:58/255, green:190/255, blue:114/255, alpha: 1).cgColor
        lblCoupons.textColor = colorGreen
        
        
        self.mainView.layer.cornerRadius = 10.0
        
        // border
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainView.layer.borderWidth = 0.1
        
        // drop shadow
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOpacity = 0.8
        mainView.layer.shadowRadius = 3.0
        mainView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        lblAddress.isUserInteractionEnabled = true
        lblAddress.addGestureRecognizer(labelTap)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
        if self.isExpanded {
            self.isExpanded = false
            showSingleLineText()
        }else {
            self.isExpanded = true
            showFullText()
        }
    }
    
    
    func showSingleLineText() {
        if strFull == lessString {
            lblAddress.text = strFull
            
            return
        }
        lblAddress.numberOfLines = 2
        var myMutableString = NSMutableAttributedString()
        let myString = "\(self.lessString)\(kReadMoreText)"
        
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font :UIFont.init(name: "HelveticaNeue-Medium", size: 12.0)!,NSAttributedString.Key.foregroundColor: textcolor ])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorLightBule, range: NSRange(location:myString.count - kReadLessText.count,length:kReadLessText.count))
        lblAddress.attributedText = myMutableString
        
        
    }
    
    func showFullText() {
        if strFull == lessString {
            lblAddress.text = strFull
            
            return
        }
        lblAddress.numberOfLines = 5
        var myMutableString = NSMutableAttributedString()
        let myString = "\(self.strFull)\(kReadLessText)"
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font :UIFont.init(name: "HelveticaNeue-Medium", size: 10.0)!,NSAttributedString.Key.foregroundColor: textcolor ])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorLightBule, range: NSRange(location:myString.count - kReadLessText.count ,length:kReadLessText.count))
        lblAddress.attributedText = myMutableString
       
    }
    
}


