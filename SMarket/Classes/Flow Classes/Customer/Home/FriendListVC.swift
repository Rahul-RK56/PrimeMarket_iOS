//
//  FriendListVC.swift
//  SMarket
//
//  Created by Mac-00016 on 15/09/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
enum nav {
    case referral
    case bonus
    case rewards
}
class FriendListVC: ParentViewController {
    
    @IBOutlet weak var btnRecommend: UIButton!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var txtSearch : UITextField!
    
    var params = [String : Any]()
    var arrContactList = [[String : Any]]()
    var arrServerContact = [[String:Any]]()
    var arrFilterContactList : [[String : Any]]?
    var productImage : UIImage?
    var arrSelectedNumber = [[String : Any]]()
    var merchant : MerchantDetails?
    var navigation : nav!
    
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
        
        self.title = "SELECT CONTACTS TO REFER"
        view.backgroundColor = ColorCustomerAppTheme
        
        txtSearch.valueChangedEvent { (textField) in
            self.searchTextFiledValueChanged()
        }
        switch navigation {
        case .referral?:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SKIP", style: .done, target: self, action: #selector(btnSkipClicked))
        default :
            break
        }
        
        if iObject != nil {
            arrContactList = iObject as! [[String : Any]]
            arrFilterContactList = arrContactList
        }
        if params["product_img"] != nil {
            productImage = params["product_img"] as? UIImage
            params.removeValue(forKey: "product_img")
        }
        if params["smarket_contact_list"] != nil {
            
            if let arrSmarketContact = params["smarket_contact_list"] as? [[String:Any]] {
                
                self.arrServerContact = arrSmarketContact
                
                var arrMobileNo = arrSmarketContact.map { $0.valueForString(key: "number") }
                
                arrMobileNo = arrMobileNo.map{$0.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)}
                
                params["smarket_contact_list"] = "\(arrMobileNo.joined(separator: ","))"
                
            }
            
        }
    }
    
    fileprivate func navigateToDetails(data : Any) {
        
        if let offerDetailsVC =  CMainCustomer_SB.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as? QRCodeDetailsViewController {
            offerDetailsVC.iObject = data
            offerDetailsVC.qrDetailsType = .ReferOffer
            if self.block != nil {
                offerDetailsVC.setBlock(block: self.block!)
            }
            self.navigationController?.pushViewController(offerDetailsVC, animated: true)
        }
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    @IBAction fileprivate func btnRecommendNowClicked(_ sender : UIButton) {
        
        switch navigation {
        case .referral?:
            if arrSelectedNumber.count > 0 {
                self.submitRateAndReferNow(isFromSkip: false)
                btnRecommend.isUserInteractionEnabled = false
            } else {
                self.showAlertView("please select contact number.", completion: nil)
            }
        case .bonus?, .rewards?:
        let arrMobileNo = self.arrSelectedNumber.map { $0.valueForString(key: "number") }
        
         let msg = "Hi I found SMARKET a BEST WAY TO HELP FRIENDS AND GREAT WAY TO EARN REWARDS through social marketing, I recommend you to try this SMARKET\(CAppStoreAppLink) app- invited by \(appDelegate?.loginUser?.name ?? "") and \(appDelegate?.loginUser?.post_code ?? "")\(appDelegate?.loginUser?.mobile ?? "")"
        
        appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: {
            self.btnRecommend.isUserInteractionEnabled = true
        })
        default :
            break
        }
        
    }
    @IBAction fileprivate func btnClearSearchBoxClicked(_ sender : UIButton){
        txtSearch.text = ""
        arrFilterContactList = arrContactList
        tblView.reloadData()
    }
    
    @objc fileprivate func btnSkipClicked(){
        self.submitRateAndReferNow(isFromSkip: true)
    }
}

// MARK:-
// MARK:- Helper Method

extension FriendListVC {
    
    fileprivate func searchTextFiledValueChanged() {
        
        if txtSearch.text!.isBlank {
            self.arrFilterContactList = arrContactList
        }else {
            self.arrFilterContactList = arrContactList.filter({$0.valueForString(key: "name").lowercased().contains(txtSearch.text!.lowercased())})
        }
        self.tblView.reloadData()
    }
}

// MARK:-
// MARK:- Server request

extension FriendListVC {
    fileprivate func submitRateAndReferNow(isFromSkip : Bool){
        
        let data = (productImage != nil ? UIImageJPEGRepresentation(productImage!, imageComprassRatio) : nil)
        
        APIRequest.shared().rateAndReferMerchant(params, imgProfileData: data) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    
                    if isFromSkip {
                       self.navigateToDetails(data: data)
                    
                    }else {
                     
                        let arrMobileNo = self.arrSelectedNumber.map { $0.valueForString(key: "number") }
                        
                        let msg = "Hi I got a great service from \(self.merchant?.name ?? ""), to know more such useful deals pls try SMARKET \(CAppStoreAppLink) app a BEST WAY TO HELP FRIENDS AND GREAT WAY TO EARN REWARDS through social marketing"
                        
                        appDelegate?.openMessageComposer(self, mobileNo: arrMobileNo, msgBody: msg, completion: {
                            self.btnRecommend.isUserInteractionEnabled = true
                            self.navigateToDetails(data: data)
                        })
                    }
                    
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: "message"))
                }
            }
        }
    }
}

// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension FriendListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterContactList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecommandTableViewCell") as? RecommandTableViewCell {
            
            if let data = arrFilterContactList?[indexPath.row] {
                
                cell.lblTitle.text = data.valueForString(key: "name")
                cell.lblNumber.text = data.valueForString(key: "number")
                cell.lblIndex.text =  data.valueForString(key: "index")
                
                if arrSelectedNumber.contains(where: {$0.valueForString(key: "id") == data.valueForString(key: "id")}) {
                    cell.btnSelected.hide(byWidth: false)
                } else {
                    cell.btnSelected.hide(byWidth: true)
                }
               
                if arrServerContact.contains(where: {$0.valueForString(key: "number") == data.valueForString(key: "number")}) {
                    cell.btnSelected.hide(byWidth: true)
                    cell.lblAlreadyContact.isHidden = false
                    cell.logoImgView.isHidden = false
                } else {
                    cell.lblAlreadyContact.isHidden = true
                    cell.logoImgView.isHidden = true
                }
                
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let info = arrFilterContactList?[indexPath.row] {
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
        tableView.reloadData()
    }
}
