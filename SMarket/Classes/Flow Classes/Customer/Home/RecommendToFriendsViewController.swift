//
//  RecommendToFriendsViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 10/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import Contacts

var selectedCount: String?

class RecommendToFriendsViewController: ParentViewController {
    
    @IBOutlet weak var btnRecommend: UIButton!
    @IBOutlet weak var btnSelectAll : UIButton!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var viewRefer : UIView!
    @IBOutlet weak var btnReferCheck : UIButton!
    @IBOutlet weak var constantReferDis : NSLayoutConstraint!
    @IBOutlet weak var lblCredit : UILabel!

    var viewReferCont : UIView?
    
    var arrContactList = [[String : Any]]()
    var arrFilterContactList = [[String : Any]]()
    var dictContactList = [String: [[String : Any]]]()
    var arrSectionTitles = [String]()
    var arrSelectedNumber = [[String : Any]]()
    var arrServerContact = [[String:Any]]()
    var isRefer = false
    var merchandID = ""
    var ratting = ""
    var merchandName = ""
    var referMessage = ""
    var referralCode = ""
    var isReferralSMS = false
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referMessage = CUserDefaults.value(forKey: UserDefaultReferralMsg) as? String ?? ""
        initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "RECOMMEND TO FRIENDS"
//        lblCredit.text = "\("Store Credit: ")\(appDelegate!.currency)10"
        
        let number = referalloffered
        if let integerPart = number.split(separator: ".").first {
            let formattedString = String(integerPart) // "12"
            lblCredit.text = "\("Store Credit: ")\(formattedString)"
        }
        
        if isRefer{
            self.title = "REFER"
            btnRecommend.setTitle("Refer", for: .normal)
            
            viewReferCont = UIView.init(frame: self.view.frame)
            viewReferCont?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.navigationController?.view.addSubview(viewReferCont!)
            viewReferCont?.addSubview(viewRefer)
            viewReferCont?.isHidden = true
        }
        checkContactPermission()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkContactPermission),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        view.backgroundColor = ColorCustomerAppTheme
        txtSearch.valueChangedEvent { (textField) in
            self.searchTextFiledValueChanged()
        }
        
        if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
            if  country as! String == "+91" {
                constantReferDis.constant = 0
            }else{
                constantReferDis.constant = 43
            }
        }
        else{
            constantReferDis.constant = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewRefer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
        viewReferCont?.frame = viewRefer.frame
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnSelectAllClicked(_ sender : UIButton) {
        
        /* sender.isSelected = !sender.isSelected
         
         arrSelectedNumber.removeAll()
         
         if sender.isSelected {
         arrSelectedNumber  = arrContactList
         }
         tblView.reloadData() */
    }
    
    @IBAction func closeButtonHandler(sender:UIButton){
        viewReferCont?.isHidden = true
    }
    
    @IBAction func checkButtonHandler(sender:UIButton){
        btnReferCheck.isSelected = !btnReferCheck.isSelected
    }
    
    @IBAction fileprivate func btnRecommendNowClicked(_ sender : UIButton) {
        
        if CNContactStore.authorizationStatus(for: .contacts) == .restricted || CNContactStore.authorizationStatus(for: .contacts) == .denied {
                    
                    checkContactPermission()
                    return
                }
                if isRefer{
                    if arrSelectedNumber.count >= 1  {
                        
        //                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Please select atleast 5 contact for refer.", btnOneTitle: CBtnOk) { (action) in
//                        viewReferCont?.isHidden = true
        //                }
                        
                        inviteButtonHandler(btnRecommend)
                         selectedCount = "\(arrSelectedNumber.count)"
                    }
                    else if arrSelectedNumber.count == 0 {
                        
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Please select atleast 1 contact for recommend.", btnOneTitle: CBtnOk) { (action) in
                            
                        }
                    }
                }
                else{
                    if arrSelectedNumber.count == 0 {
                        
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Please select atleast 1 contact for recommend.", btnOneTitle: CBtnOk) { (action) in
                            
                        }
                    } else {
                        let arrMobileNo = arrSelectedNumber.map { $0.valueForString(key: "number") }
                        btnRecommend.isUserInteractionEnabled = false

                        var text = (CUserDefaults.value(forKey: UserDefaultReferralMsg) as! String)
                        text = text.replacingOccurrences(of: "XXXXXX", with: CUserDefaults.value(forKey: UserDefaultReferralCode) as! String)

                        appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: text, completion: {
                            self.btnRecommend.isUserInteractionEnabled = true
                        })
                    }
                }
    }
    
    @IBAction fileprivate func inviteButtonHandler(_ sender : UIButton){
        
        let refCode = (CUserDefaults.value(forKey: UserDefaultReferralCode) as! String)
        var param = [String : Any]()
        param["merchant_id"] =  merchandID
        var arrMobileNo = arrSelectedNumber.map { $0.valueForString(key: "number") }
        param["product_name"] =  ""
        param["review"] = ""
        arrMobileNo = arrMobileNo.map{$0.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)}
        param["rating"] = ratting
        param["smarket_contact_list"] = "\(arrMobileNo.joined(separator: ","))"
        if btnReferCheck.isSelected{
            param["refermail"] = "1"
        }
        var openMsg = true
        if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
            if  country as! String == "+91" {
                openMsg = true
            }else{
                openMsg = false
            }
        }
        if openMsg{
            
            if referMessage.count > 1 {
                
             //   let msg = "\(referMessage) \n \("To download the app please visit: \n https://smarketdeals.com/\(merchandID)/\(refCode)")"
//                let textToShare = [ msg ]
//                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//                // exclude some activity types from the list (optional)
//                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
//
//                // present the view controller
//                self.present(activityViewController, animated: true, completion: nil)
            //    let msg = "\(referMessage) \n \("To download the app please visit: \n https://smarketworld.net/c/\(merchandID)/\(refCode)")"
         //   https://smarketdeals.com/SMFlutter_test/c/
                
              let msg = "\(referMessage) \n \("To download the app please visit: \n https://smarketdeals.com/SM/merchant/\(merchandID)/\(refCode)")"
            
              if let  merName = appDelegate?.userDetail.valueForString(key:"referral_merchant_message"){
               // msg = merName
              }
                appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: { [self] in
                    viewReferCont?.isHidden = true
                    self.submitRateAndReferNow(params: param)
                })
                
           self.submitRateAndReferNow(params: param)
                
            }else{
                
                //"Hi I got a great service from \(self.merchandName), to know more such useful deals pls try SMARKET \(CAppStoreAppLink) app a BEST WAY TO HELP FRIENDS AND GREAT WAY TO EARN REWARDS through social marketing"
              //  let msg = "I got great deal from \(self.merchandName), I would recommend you to try it."
                let msg = "\(referMessage) \n \("To download the app please visit: \n https://smarketdeals.com/SM/merchant/\(merchandID)/\(refCode)")"
                print(msg, "message-----")
              if let  merName = appDelegate?.userDetail.valueForString(key:"referral_merchant_message"){
                //msg = merName
              }
                appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: { [self] in
                    self.viewReferCont?.isHidden = true
                    self.submitRateAndReferNow(params: param)
                })
            }
           
           
            
        }else{
            
            
            if isReferralSMS == true {
                param["refersms"] = "1"
                viewReferCont?.isHidden = true
                self.submitRateAndReferNow(params: param)
            }else{
                
                
                if referMessage.count > 1 {
                    let msg = "\(referMessage) \n \("\nTo download the app please visit: \n https://smarketdeals.com/SM/merchant/\(merchandID)/\(refCode)")"
                    appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: { [self] in
                        self.viewReferCont?.isHidden = true
                        self.submitRateAndReferNow(params: param)
                    })
                    appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: { [self] in
                        self.viewReferCont?.isHidden = true
                        self.submitRateAndReferNow(params: param)
                    })
                }else{
                    let msg = "I got great deal from \(self.merchandName), I would recommend you to try it."
                    appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: { [self] in
                        self.viewReferCont?.isHidden = true
                        self.submitRateAndReferNow(params: param)
                    })
                    appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: { [self] in
                        self.viewReferCont?.isHidden = true
                        self.submitRateAndReferNow(params: param)
                    })
                }
                
                //var msg = "Hi I got a great service from \(self.merchandName), to know more such useful deals pls try SMARKET \(CAppStoreAppLink) app a BEST WAY TO HELP FRIENDS AND GREAT WAY TO EARN REWARDS through social marketing"
                
                
//              if let  merName = appDelegate?.userDetail.valueForString(key:"referral_merchant_message"){
//               // msg = merName
//              }
                
            }
            
            
          param["refersms"] = "1"
         
        }
    }
    
    @IBAction fileprivate func btnClearSearchBoxClicked(_ sender : UIButton){
        txtSearch.text = ""
        self.arrFilterContactList = arrContactList
        self.refreshContactList()
    }
}

// MARK:-
// MARK:- Helper Method
extension RecommendToFriendsViewController {
    
    @objc fileprivate func checkContactPermission() {
        
        SwiftyContacts.shared.requestAccess(true) { (granted) in
            
            if granted {
                
                SwiftyContacts.shared.fetchContacts(ContactsSortorder: .givenName, completionHandler: { (result) in
                    
                    switch result{
                    case .Success(response: let contacts):
                        // Do your thing here with [CNContacts] array
                        
                        self.arrContactList.removeAll()
                        if let  arrContactList = SwiftyContacts.shared.convertContactListToArray(contacts) as? [[String : Any]] {
                            self.arrContactList = arrContactList
                            self.arrFilterContactList = arrContactList
                            DispatchQueue.main.async {
                                self.sendContactsOnServer(contacts : arrContactList)
                                self.refreshContactList()
                            }
                        }
                    case .Error(error: let error):
                        print(error)
                        
                    }
                })
            }
        }
    }
    
    
    fileprivate func refreshContactList() {
        
        dictContactList.removeAll()
        for contact in arrFilterContactList {
            
            let nameKey = String(contact.valueForString(key: "index").prefix(1))
            if var values = dictContactList[nameKey] {
                values.append(contact)
                dictContactList[nameKey] = values
            } else {
                dictContactList[nameKey] = [contact]
            }
        }
        
        arrSectionTitles = [String](dictContactList.keys)
        arrSectionTitles = arrSectionTitles.sorted(by: { $0 < $1 })
        
        DispatchQueue.main.async {
            self.tblView.sectionIndexColor = CRGB(r: 0, g: 0, b: 0)
            self.tblView.reloadData()
        }
    }
    
    fileprivate func searchTextFiledValueChanged() {
        
        if txtSearch.text!.isBlank {
            self.arrFilterContactList = arrContactList
        }else {
            self.arrFilterContactList = arrContactList.filter({$0.valueForString(key: "name").lowercased().contains(txtSearch.text!.lowercased())})
        }
        
        self.refreshContactList()
    }
}
// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension RecommendToFriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrSectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let nameKey = arrSectionTitles[section]
        if let arrValues = dictContactList[nameKey] {
            return arrValues.count
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55/375*CScreenWidth
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecommandTableViewCell") as? RecommandTableViewCell {
            
            // Configure the cell...
            let nameKey = arrSectionTitles[indexPath.section]
            
            if let arrValues = dictContactList[nameKey] {
                
                let info = arrValues[indexPath.row]
                
                cell.lblTitle.text = info.valueForString(key: "name")
                cell.lblNumber.text = info.valueForString(key: "number")
                cell.lblIndex.text = nameKey
                
                if arrSelectedNumber.contains(where: {$0.valueForString(key: "id") == info.valueForString(key: "id")}) {
                    cell.btnSelected.hide(byWidth: false)
                } else {
                    cell.btnSelected.hide(byWidth: true)
                }
                
                if arrServerContact.contains(where: {$0.valueForString(key: "number") == info.valueForString(key: "number")}) {
                    cell.btnSelected.hide(byWidth: true)
                    cell.logoImgView.isHidden = false
                } else {
                    cell.logoImgView.isHidden = true
                }
                cell.vwSeprator.isHidden = indexPath.row == arrValues.count - 1
                
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30/375*CScreenWidth
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblView {
            
            if let header = tableView.dequeueReusableCell(withIdentifier: "RecommandHeaderTableViewCell") as? RecommandHeaderTableViewCell {
                header.lblTitle.text = arrSectionTitles[section]
                return header
            }
        }
        
        return nil
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrSectionTitles
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nameKey = arrSectionTitles[indexPath.section]
        
        if let arrValues = dictContactList[nameKey] {
            
            let info = arrValues[indexPath.row]
            
            if  let index = arrSelectedNumber.index(where: {$0.valueForString(key: "id") == info.valueForString(key: "id")}) {
                arrSelectedNumber.remove(at: index)
                
            }else {
                
                if arrSelectedNumber.count > 19 {
                    self.showAlertView("You can only recommend with up to 20 friends.", completion: nil)
                } else {
                    arrSelectedNumber.append(info)
                }
            }
        }
        
        // btnSelectAll.isSelected = arrSelectedNumber.count == arrContactList.count
        
        tableView.reloadData()
    }
}

// MARK:-
// MARK:- Server request

extension RecommendToFriendsViewController {
    
    fileprivate func sendContactsOnServer(contacts : [Any]){
        
        var param = [String : Any]()
        param["contact_list"] =  contacts
        
        APIRequest.shared().sendContactsOnServer(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    
                    if let arrSmarketContact = data["smarket_contact_list"] as? [[String:Any]] {
                        
                        self.arrServerContact = arrSmarketContact
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    
    func submitRateAndReferNow(params : [String:Any]){
        
        APIRequest.shared().rateAndReferMerchant(params, imgProfileData: Data()) { (response, error) in
            
             if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    self.viewReferCont?.isHidden = true
                    if let offerDetailsVC =  CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
                        offerDetailsVC.iObject = data
                        offerDetailsVC.qrDetailsType = .ReferOffer
                        if self.block != nil {
                            offerDetailsVC.setBlock(block: self.block!)
                        }
                        self.navigationController?.pushViewController(offerDetailsVC, animated: true)
                    }
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: "message"))
                }
            }
        }
    }
}


extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.characters.dropLast())
        return output
    }
}
