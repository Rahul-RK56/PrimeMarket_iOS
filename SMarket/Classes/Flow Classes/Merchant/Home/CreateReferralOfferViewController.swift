//
//  CreateReferralOfferViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 13/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class CreateReferralOfferViewController: ParentViewController {
    
    @IBOutlet weak var txtReferralOfferType : UITextField!
    @IBOutlet weak var txtReferralAmountTitle : UITextField!
    @IBOutlet weak var txtVReferralCondition : UITextView!
    
    @IBOutlet weak var txtBonusOfferType : UITextField!
    @IBOutlet weak var txtBonusAmountTitle : UITextField!
    @IBOutlet weak var txtVBonusCondition : UITextView!
    
    @IBOutlet weak var txtRewardOfferType : UITextField!
    @IBOutlet weak var txtRewardAmountTitle : UITextField!
    @IBOutlet weak var txtVRewardCondition : UITextView!
    
    @IBOutlet weak var txtExpireDate : UITextField!
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    @IBOutlet weak var btnSkip : UIButton!
    @IBOutlet weak var btnStep1 : UIButton!
    @IBOutlet weak var btnStep2 : UIButton!
    @IBOutlet weak var btnStep3 : UIButton!
    @IBOutlet weak var btnStep4 : UIButton!
    @IBOutlet weak var btnStep5 : UIButton!
    
    @IBOutlet weak var imgVStep1Tick : UIImageView!
    @IBOutlet weak var imgVStep2Tick : UIImageView!
    @IBOutlet weak var imgVStep3Tick : UIImageView!
    @IBOutlet weak var imgVStep4Tick : UIImageView!
    @IBOutlet weak var imgVStep5Tick : UIImageView!
    
    @IBOutlet var cnBtnNextTopStep1 : NSLayoutConstraint!
    @IBOutlet var cnBtnNextTopStep2 : NSLayoutConstraint!
    @IBOutlet var cnBtnNextTopStep3 : NSLayoutConstraint!
    @IBOutlet var cnBtnNextTopStep4 : NSLayoutConstraint!
    
    @IBOutlet var cnVwStep1Leading : NSLayoutConstraint!
    
    var currentState = 1
    var isOffersEmpty = false
    var arrOfferType = ["Gift Card","Over the counter","Store Credit"] // ["Discount"]
    
    var offerDetails : Offer?
    var referralSubOffer : [String : Any]?
    var bonusSubOffer : [String : Any]?
    var rewardSubOffer : [String : Any]?
    
    var referralSelectedOfferCategory : OfferCategory?
    var bonusSelectedOfferCategory : OfferCategory?
    var rewardSelectedOfferCategory : OfferCategory?
    
    @IBOutlet weak var lblRefrral: UILabel!
    @IBOutlet weak var lblBonus: UILabel!
    @IBOutlet weak var lblReward: UILabel!
    
    
    
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
        
        self.title = "CREATE REFERRAL OFFER"
        
        textfieldConfiguration()
        fillOfferDetails()
        moveToStep(1)
        
        if CUserDefaults.value(forKey: UserDefaultHOWTOCREATEOFFER) == nil {
            btnInfoClicked(UIBarButtonItem())
            CUserDefaults.setValue(1, forKey:UserDefaultHOWTOCREATEOFFER)
            CUserDefaults.synchronize()
        }
    }
    
    fileprivate func fillOfferDetails(){
        
        if let offer = offerDetails {
        
            txtExpireDate.text = offer.expiryDate?.dateFromString
            
            if let refSubOffer = offerDetails?.subOffer?.filter({$0.subOfferType == .Referral}).first {
                
                referralSelectedOfferCategory = refSubOffer.subOfferCategory
                txtVReferralCondition.text = refSubOffer.conditions
                self.btnSkip.isHidden = true
                switch referralSelectedOfferCategory {
                    
                case .GiftCard?:
                    txtReferralOfferType.text = arrOfferType[0]
                    txtReferralAmountTitle.keyboardType = .decimalPad
                    txtReferralAmountTitle.placeholder = "Amount"
                    txtReferralAmountTitle.text = refSubOffer.amount
                    
                case .InStore?:
                    txtReferralOfferType.text = arrOfferType[1]
                    txtReferralAmountTitle.keyboardType = .default
                    txtReferralAmountTitle.placeholder = "Title"
                    txtReferralAmountTitle.text = refSubOffer.title


                case .StoreCredit?:
                    txtReferralOfferType.text = arrOfferType[2]
                    txtReferralAmountTitle.keyboardType = .decimalPad
                    txtReferralAmountTitle.placeholder = "Amount"
                    txtReferralAmountTitle.text = refSubOffer.amount
                    
                default:
                    break
                }
                
            }
            if let bonusSubOffer = offerDetails?.subOffer?.filter({$0.subOfferType == .Bonus}).first {
                
                bonusSelectedOfferCategory = bonusSubOffer.subOfferCategory
                txtVBonusCondition.text = bonusSubOffer.conditions
                
                switch bonusSelectedOfferCategory {
                case .GiftCard?:
                    txtBonusOfferType.text = arrOfferType[0]
                    txtBonusAmountTitle.keyboardType = .decimalPad
                    txtBonusAmountTitle.placeholder = "Amount"
                    txtBonusAmountTitle.text = bonusSubOffer.amount
                    
                case .InStore?:
                    txtBonusOfferType.text = arrOfferType[1]
                    txtBonusAmountTitle.keyboardType = .default
                    txtBonusAmountTitle.placeholder = "Title"
                    txtBonusAmountTitle.text = bonusSubOffer.title
                    
                case .StoreCredit?:
                    txtBonusOfferType.text = arrOfferType[2]
                    txtBonusAmountTitle.keyboardType = .decimalPad
                    txtBonusAmountTitle.placeholder = "Amount"
                    txtBonusAmountTitle.text = bonusSubOffer.amount
                default:
                    break
                }
            }
            
            if let rewardSubOffer = offerDetails?.subOffer?.filter({$0.subOfferType == .Reward}).first {
                rewardSelectedOfferCategory = rewardSubOffer.subOfferCategory
                txtVRewardCondition.text = rewardSubOffer.conditions
                
                switch rewardSelectedOfferCategory {
                    
                case .GiftCard?:
                    txtRewardOfferType.text = arrOfferType[0]
                    txtRewardAmountTitle.keyboardType = .decimalPad
                    txtRewardAmountTitle.placeholder = "Amount"
                    txtRewardAmountTitle.text = rewardSubOffer.amount
                    
                case .InStore?:
                    txtRewardOfferType.text = arrOfferType[1]
                    txtRewardAmountTitle.keyboardType = .default
                    txtRewardAmountTitle.placeholder = "Title"
                    txtRewardAmountTitle.text = rewardSubOffer.title

                case .StoreCredit?:
                    txtRewardOfferType.text = arrOfferType[2]
                    txtRewardAmountTitle.keyboardType = .decimalPad
                    txtRewardAmountTitle.placeholder = "Amount"
                    txtRewardAmountTitle.text = rewardSubOffer.amount
                    
                default:
                    break
                }
            }
            
        }
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnInfoClicked(_ sender : UIBarButtonItem) {
        
        if CUserDefaults.value(forKey: UserDefaultHOWTOCREATEOFFER) == nil {
            CUserDefaults.setValue(1, forKey:UserDefaultHOWTOCREATEOFFER)
            CUserDefaults.synchronize()
            self.presentAlertViewWithOneButton(alertTitle: CMessageHowToUseAppTitle, alertMessage: CMessageHowToUseAppDetails, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            
            switch currentState {
            case 1:
                self.presentAlertViewWithOneButton(alertTitle: CMessageSmarkOfferTitle, alertMessage: CMessageSmarkOfferDetails, btnOneTitle: CBtnOk, btnOneTapped: nil)
            case 2:
                self.presentAlertViewWithOneButton(alertTitle: CMessageWelcomeBonusTitle, alertMessage: CMessageWelcomeBonusDetails, btnOneTitle: CBtnOk, btnOneTapped: nil)
            case 3:
                self.presentAlertViewWithOneButton(alertTitle: CMessageThankYouRewardTitle, alertMessage: CMessageThankYouRewardDetails, btnOneTitle: CBtnOk, btnOneTapped: nil)
            default :
                break
            }
        }
    }
    
    @IBAction fileprivate func btnNextClicked(_ sender : UIButton) {
        
        
        switch currentState {
        case  1:
            if isValidReferralStep() {
                
                referralSubOffer = [String : Any]()
                referralSubOffer?["sub_offer_type"] = SubOfferType.Referral.rawValue
                referralSubOffer?["sub_offer_category"] = referralSelectedOfferCategory?.rawValue
                referralSubOffer?["conditions"] = txtVReferralCondition.text
                if referralSelectedOfferCategory == .InStore {
                    referralSubOffer?["title"] = txtReferralAmountTitle.text
                } else {
                    referralSubOffer?["amount"] = txtReferralAmountTitle.text
                }
                
                moveToStep(currentState + 1)
                
                if let subOffer = offerDetails?.subOffer?.filter({$0.subOfferType == .Referral}).first {
                    referralSubOffer?["id"] = subOffer.id
                    referralSubOffer?["parent_id"] = subOffer.parentId
                }
            }
            
        case  2:
            if isValidBonusStep() {
                
                bonusSubOffer = [String : Any]()
                bonusSubOffer?["sub_offer_type"] = SubOfferType.Bonus.rawValue
                bonusSubOffer?["sub_offer_category"] = bonusSelectedOfferCategory?.rawValue
                bonusSubOffer?["conditions"] = txtVBonusCondition.text
                if bonusSelectedOfferCategory == .InStore {
                    bonusSubOffer?["title"] = txtBonusAmountTitle.text
                } else {
                    bonusSubOffer?["amount"] = txtBonusAmountTitle.text
                }
               
                moveToStep(currentState + 1)
                
                if let subOffer = offerDetails?.subOffer?.filter({$0.subOfferType == .Bonus}).first {
                    bonusSubOffer?["id"] = subOffer.id
                    bonusSubOffer?["parent_id"] = subOffer.parentId
                }
            }
            
        case  3:
            if isValidRewardStep() {
                
                rewardSubOffer = [String : Any]()
                rewardSubOffer?["sub_offer_type"] = SubOfferType.Reward.rawValue
                rewardSubOffer?["sub_offer_category"] = rewardSelectedOfferCategory?.rawValue
                rewardSubOffer?["conditions"] = txtVRewardCondition.text
                if rewardSelectedOfferCategory == .InStore {
                    rewardSubOffer?["title"] = txtRewardAmountTitle.text
                } else {
                    rewardSubOffer?["amount"] = txtRewardAmountTitle.text
                }
    
                moveToStep(currentState + 1)
                
                if let subOffer = offerDetails?.subOffer?.filter({$0.subOfferType == .Reward}).first {
                    rewardSubOffer?["id"] = subOffer.id
                    rewardSubOffer?["parent_id"] = subOffer.parentId
                }
            }
        case  4:
            
            if isValidExpireStep() {
                createOfferPreview()
                
                if let previewVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "OfferPreviewViewController") as? OfferPreviewViewController {
                    previewVC.offerPreview = offerDetails
                    self.navigationController?.pushViewController(previewVC, animated: true)
                }
            }
            
        default :
            break
        }
    }
    
    
    @IBAction fileprivate func btnSkipClicked(_ sender : UIButton) {
        
        func skipRefferal() {
            
            txtReferralOfferType.text = ""
            txtReferralAmountTitle.text = ""
            txtVReferralCondition.text = ""
            referralSubOffer = nil
            moveToStep(currentState + 1)
        }
        
        func skipBonus() {
            txtBonusOfferType.text = ""
            txtBonusAmountTitle.text = ""
            txtVBonusCondition.text = ""
            bonusSubOffer = nil
            moveToStep(currentState + 1)
        }
        
        func skipReward() {
            
            txtRewardOfferType.text = ""
            txtRewardAmountTitle.text = ""
            txtVRewardCondition.text = ""
            rewardSubOffer = nil
            moveToStep(currentState + 1)
        }
        
        switch currentState {
        case 1:
            
            if !(txtReferralAmountTitle.text?.isBlank)! {
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageSkipReferral, btnOneTitle: CBtnSkip, btnOneTapped: { (action) in
                    skipRefferal()
                }, btnTwoTitle: CBtnCancel, btnTwoTapped: nil)
            }else {
                
                skipRefferal()
            }
            
        case 2:
            
            if !(txtBonusAmountTitle.text?.isBlank)! {
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageSkipBonus, btnOneTitle: CBtnSkip, btnOneTapped: { (action) in
                    skipBonus()
                }, btnTwoTitle: CBtnCancel, btnTwoTapped: nil)
            }else {
                skipBonus()
            }
            
            
        case 3:
            
            if !(txtRewardAmountTitle.text?.isBlank)! {
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageSkipReward, btnOneTitle: CBtnSkip, btnOneTapped: { (action) in
                    skipReward()
                }, btnTwoTitle: CBtnCancel, btnTwoTapped: nil)
            }else {
                skipReward()
            }
            
        default:
            break
        }
        
        
    }
    
    @IBAction fileprivate func btnRedemptionClicked(_ sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction fileprivate func btnTrackClicked(_ sender : UIButton) {
        
        
        if sender.tag >= currentState {
            return
        }
        
        moveToStep(sender.tag)
        
    }
    
}


// MARK:-
// MARK:- HELPER METHOD

extension CreateReferralOfferViewController {
    
    fileprivate func textfieldConfiguration() {
        
        referralTextFieldConfiguration()
        bonusTextFieldConfiguration()
        rewardTextFieldConfiguration()
        
        // Expire date textfield configuration
        txtExpireDate.addRightImage(strImgName: "date", padding: 14, imageContentMode: .Left)
        txtExpireDate.setDatePickerWithDateFormate(dateFormate: displayDateFormate, defaultDate: Date(), isPrefilledDate: true) { (date) in
            
        }
        txtExpireDate.setDatePickerMode(mode: .date)
        txtExpireDate.setMinimumDate(minDate: Date())
        
    }
    
    fileprivate func referralTextFieldConfiguration() {
        
        // Referral View textfield configuration
        txtReferralOfferType.addRightImage(strImgName: "dropdown", padding: 16, imageContentMode: .Left)
        
        
        txtReferralOfferType.setPickerData(arrPickerData: arrOfferType, selectedPickerDataHandler: { (selected, row, component) in
            
            
            let newOfferCategory  = OfferCategory(rawValue: row + 1)
            
            if self.referralSelectedOfferCategory != newOfferCategory{
                self.txtReferralAmountTitle.text = ""
                self.referralSelectedOfferCategory = newOfferCategory
            }
            
            if self.referralSelectedOfferCategory == .InStore {
                self.txtReferralAmountTitle.keyboardType = .default
                self.txtReferralAmountTitle.placeholder = "Title"
            }else {
                
                self.txtReferralAmountTitle.keyboardType = .decimalPad
                self.txtReferralAmountTitle.placeholder = "Amount"
            }
                    
        }, defaultPlaceholder: nil)
        
        txtVReferralCondition.setCharLimit(charLimit: 150)
    }
    
    fileprivate func bonusTextFieldConfiguration() {
        
        // Bonus View textfield configuration
        txtBonusOfferType.addRightImage(strImgName: "dropdown", padding: 16, imageContentMode: .Left)
        
        txtBonusOfferType.setPickerData(arrPickerData: arrOfferType, selectedPickerDataHandler: { (selected, row, component) in
            
            let newOfferCategory = OfferCategory(rawValue: row + 1)
            
            if self.bonusSelectedOfferCategory != newOfferCategory{
                self.txtBonusAmountTitle.text = ""
                self.bonusSelectedOfferCategory = newOfferCategory
            }
            
            if self.bonusSelectedOfferCategory == .InStore {
                self.txtBonusAmountTitle.keyboardType = .default
                self.txtBonusAmountTitle.placeholder = "Title"
            }else {
                
                self.txtBonusAmountTitle.keyboardType = .decimalPad
                self.txtBonusAmountTitle.placeholder = "Amount"
            }
            
        }, defaultPlaceholder: nil)
        
        txtVBonusCondition.setCharLimit(charLimit: 150)
        
    }
    
    fileprivate func rewardTextFieldConfiguration() {
        
        // Reward View textfield configuration
        txtRewardOfferType.addRightImage(strImgName: "dropdown", padding: 16, imageContentMode: .Left)
       
        txtRewardOfferType.setPickerData(arrPickerData: arrOfferType, selectedPickerDataHandler: { (selected, row, component) in
            
            let newOfferCategory = OfferCategory(rawValue: row + 1)
            
            if self.rewardSelectedOfferCategory != newOfferCategory{
                self.txtRewardAmountTitle.text = ""
                self.rewardSelectedOfferCategory = newOfferCategory
            }
            
            if self.rewardSelectedOfferCategory == .InStore {
                self.txtRewardAmountTitle.keyboardType = .default
                self.txtRewardAmountTitle.placeholder = "Title"
            }else {
                
                self.txtRewardAmountTitle.keyboardType = .decimalPad
                self.txtRewardAmountTitle.placeholder = "Amount"
            }
           
        }, defaultPlaceholder: nil)
        
        txtVRewardCondition.setCharLimit(charLimit: 150)
    }
    
    fileprivate func moveToStep(_ step : Int)  {
        
        if step == 4  && !isValidOfferDetails() {
            return
        }
        if step == 5  && !isValidExpireStep() {
            return
        }
        
        currentState = step
        
        UIView.animate(withDuration: 0.3) {
            self.cnVwStep1Leading.constant = -(CScreenWidth*CGFloat(self.currentState-1))
            self.btnSkip.hide(byHeight: step > 3 )
            self.view.layoutIfNeeded()
        }
        
        switch step {
            
        case 1: // Referral
            moveToReferralStep()
            btnSkip.hide(byHeight:(offerDetails?.subOffer?.filter({$0.subOfferType == .Referral}).first) != nil)
            
        case 2: // Bonus
            moveToBonusStep()
            btnSkip.hide(byHeight:(offerDetails?.subOffer?.filter({$0.subOfferType == .Bonus}).first) != nil)
            
        case 3: // Reward
            moveToRewardStep()
            btnSkip.hide(byHeight:(offerDetails?.subOffer?.filter({$0.subOfferType == .Reward}).first) != nil)
            
            
        case 4:  // Expire Date
            moveToExpireDateStep()
            
        case 5:  // Preview
            break
        default:
            break
        }
    }
    
    fileprivate func moveToReferralStep(){
        
        // Referral
        btnStep1.isSelected = true
        btnStep2.isSelected = false
        btnStep3.isSelected = false
        btnStep4.isSelected = false
        btnStep5.isSelected = false
        lblRefrral.textColor = ColorYellowOfferlabel
        lblBonus.textColor = ColorBlack_000000
        lblReward.textColor = ColorBlack_000000
        
        imgVStep1Tick.isHidden = false
        imgVStep2Tick.isHidden = true
        imgVStep3Tick.isHidden = true
        imgVStep4Tick.isHidden = true
        imgVStep5Tick.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.cnBtnNextTopStep1.priority = UILayoutPriority(rawValue: 999)
            self.cnBtnNextTopStep2.priority = UILayoutPriority(rawValue: 998)
            self.cnBtnNextTopStep3.priority = UILayoutPriority(rawValue: 997)
            self.cnBtnNextTopStep4.priority = UILayoutPriority(rawValue: 996)
            self.view.layoutIfNeeded()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(btnInfoClicked))
        
    }
    fileprivate func moveToBonusStep(){
        // Bonus
        btnStep1.isSelected = true
        btnStep2.isSelected = true
        btnStep3.isSelected = false
        btnStep4.isSelected = false
        btnStep5.isSelected = false
        lblRefrral.textColor = ColorYellowOfferlabel
        lblBonus.textColor = ColorYellowOfferlabel
        lblReward.textColor = ColorBlack_000000
        
        imgVStep1Tick.isHidden = false
        imgVStep2Tick.isHidden = false
        imgVStep3Tick.isHidden = true
        imgVStep4Tick.isHidden = true
        imgVStep5Tick.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.cnBtnNextTopStep1.priority = UILayoutPriority(rawValue: 996)
            self.cnBtnNextTopStep2.priority = UILayoutPriority(rawValue: 999)
            self.cnBtnNextTopStep3.priority = UILayoutPriority(rawValue: 998)
            self.cnBtnNextTopStep4.priority = UILayoutPriority(rawValue: 997)
            self.view.layoutIfNeeded()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(btnInfoClicked))
        
    }
    fileprivate func moveToRewardStep(){
        
        // Reward
        btnStep1.isSelected = true
        btnStep2.isSelected = true
        btnStep3.isSelected = true
        btnStep4.isSelected = false
        btnStep5.isSelected = false
        lblRefrral.textColor = ColorYellowOfferlabel
        lblBonus.textColor = ColorYellowOfferlabel
        lblReward.textColor = ColorYellowOfferlabel
        
        imgVStep1Tick.isHidden = false
        imgVStep2Tick.isHidden = false
        imgVStep3Tick.isHidden = false
        imgVStep4Tick.isHidden = true
        imgVStep5Tick.isHidden = true
        
        
        UIView.animate(withDuration: 0.3) {
            self.cnBtnNextTopStep1.priority = UILayoutPriority(rawValue: 996)
            self.cnBtnNextTopStep2.priority = UILayoutPriority(rawValue: 997)
            self.cnBtnNextTopStep3.priority = UILayoutPriority(rawValue: 999)
            self.cnBtnNextTopStep4.priority = UILayoutPriority(rawValue: 998)
            self.view.layoutIfNeeded()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(btnInfoClicked))
        
    }
    fileprivate func moveToExpireDateStep(){
        
        // Expire Date
        btnStep1.isSelected = true
        btnStep2.isSelected = true
        btnStep3.isSelected = true
        btnStep4.isSelected = true
        btnStep5.isSelected = false
        lblRefrral.textColor = ColorYellowOfferlabel
        lblBonus.textColor = ColorYellowOfferlabel
        lblReward.textColor = ColorYellowOfferlabel
        
        imgVStep1Tick.isHidden = false
        imgVStep2Tick.isHidden = false
        imgVStep3Tick.isHidden = false
        imgVStep4Tick.isHidden = false
        imgVStep5Tick.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.cnBtnNextTopStep1.priority = UILayoutPriority(rawValue: 996)
            self.cnBtnNextTopStep2.priority = UILayoutPriority(rawValue: 997)
            self.cnBtnNextTopStep3.priority = UILayoutPriority(rawValue: 998)
            self.cnBtnNextTopStep4.priority = UILayoutPriority(rawValue: 999)
            self.view.layoutIfNeeded()
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    fileprivate func isValidReferralStep() -> Bool {
        
        if (txtReferralOfferType.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOffer, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        } else if (txtReferralAmountTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: referralSelectedOfferCategory != .InStore ? CMessageBlankAmount : CMessageBlankTitle, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        return true
    }
    
    fileprivate func isValidBonusStep() -> Bool {
        
        if (txtBonusOfferType.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOffer, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        } else if (txtBonusAmountTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: bonusSelectedOfferCategory != .InStore ? CMessageBlankAmount : CMessageBlankTitle, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        return true
    }
    
    fileprivate func isValidRewardStep() -> Bool    {
        
        if (txtRewardOfferType.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOffer, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        } else if  (txtRewardAmountTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: rewardSelectedOfferCategory != .InStore ? CMessageBlankAmount : CMessageBlankTitle, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        return true
    }
    
    fileprivate func isValidExpireStep() ->Bool {
        
        if (txtExpireDate.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankExpiryDate, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        return true
    }
    
    fileprivate func isValidOfferDetails() ->Bool {
        
        if referralSubOffer == nil && bonusSubOffer == nil && rewardSubOffer == nil {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankOffers, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        return true
        
    }
    
    fileprivate func createOfferPreview(){
        
        var param = [String : Any]()
        param["offer_type"] = OfferType.Referral.rawValue
        param["expiry_date"] = txtExpireDate.text
        
        var arrSubOffer = [[String : Any]]()
        if let referralSubOffer = referralSubOffer {
            arrSubOffer.append(referralSubOffer)
        }
        if let bonusSubOffer = bonusSubOffer {
            arrSubOffer.append(bonusSubOffer)
        }
        if let rewardSubOffer = rewardSubOffer {
            arrSubOffer.append(rewardSubOffer)
        }
        param["sub_offer"] = arrSubOffer
        
        if offerDetails == nil {
            offerDetails = Offer(object:param)
        }else {
            offerDetails?.updateValues(object: param)
        }
    }
    
}
