//
//  RefcashViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class RefcashViewController: ParentViewController {
    
    @IBOutlet weak var btnCredit : UIButton!
    @IBOutlet weak var btnDebit : UIButton!
    @IBOutlet weak var lblAvailableBlc: UILabel!
    
    @IBOutlet weak var lblMinRedeemAmount: UILabel!
    @IBOutlet weak var lblOne: UILabel!
    
    @IBOutlet weak var txtAmount : UITextField!
    
    @IBOutlet weak var tblView : UITableView!
    
    @IBOutlet var cnVwSelectionLeading : NSLayoutConstraint!
    
    var apiSessionTask : URLSessionTask?
    var arrData = [Any]()
    var page = 1
    
    let formatter = NumberFormatter()

    
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
        self.title = "REDEEM REFCASH"
        
        refreshRefCash()
        loadRefCaseCreditDebit()
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        lblOne.text = "\(appDelegate!.currency)1"
        let amountMin = formatter.number(from: appDelegate?.loginUser?.min_withdraw_amount ?? "0")
                let amtMin = "Minimum redeemption amount is \(appDelegate!.currency)\(amountMin ?? 0)"
//        let amtMin = "Minimum redeemption amount is \(appDelegate!.currency)\(appDelegate?.loginUser?.min_withdraw_amount ?? "0")"
        let attributedString = NSMutableAttributedString(string: amtMin)
        
        attributedString.setAttributes([NSAttributedStringKey.font :UIFont.systemFont(ofSize: 14, weight: .regular)], range: NSRange(location: 29, length: amtMin.count-29))
        
        lblMinRedeemAmount.attributedText = attributedString
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnTabClicked(_ sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnCredit.isSelected = false
        btnDebit.isSelected = false
        sender.isSelected = true
        
        arrData.removeAll()
        tblView.reloadData()
        page = 1
        
        loadRefCaseCreditDebit()
        
        UIView.animate(withDuration: 0.3) {
            
            self.cnVwSelectionLeading.constant = sender == self.btnDebit ? (CScreenWidth/2) : 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction fileprivate func btnRedeemClicked(_ sender : UIButton) {
        
        if let vc = CMainCustomer_SB.instantiateViewController(withIdentifier: "RedeemViewController") as? RedeemViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //        if isValidationPassed() {
        //
        //            if appDelegate?.loginUser?.refcash?.toFloat ?? 0 >= appDelegate?.loginUser?.min_withdraw_amount?.toFloat ?? 0 {
        //                self.reedeemRefCase()
        //            } else {
        //                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageRefCaseAmount, btnOneTitle: CBtnOk) { (action) in
        //                    self.txtAmount.text = "" }
        //            }
        //        }
    }
}

// MARK:-
// MARK:- Server Request

extension RefcashViewController
{
    @objc func pullToRefresh()  {
        
        page = 1
        loadRefCaseCreditDebit()
    }
    
    fileprivate func loadRefCaseCreditDebit()
    {
        if apiSessionTask != nil && apiSessionTask?.state == .running {
            apiSessionTask?.cancel()
        }
        
        var param = [String : Any]()
        param["history_type"] = btnDebit.isSelected ? "2" : "1"
        param["page"] = page
        
        if page == 1 && arrData.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
        apiSessionTask = APIRequest.shared().loadCustomerRefCashCreditDebit(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrData.removeAll()
                    self.tblView.reloadData()
                }
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.arrData = self.arrData + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                }
                else {
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
                        
                        self.pullToRefresh()
                        
                    })
                }
            }
        }
        
    }
    fileprivate func reedeemRefCase()
    {
        var param = [String : Any]()
        param["amount"] = txtAmount.text
        
        APIRequest.shared().redeemRefCase(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                        appDelegate?.loginUser?.refcash = meta.valueForString(key:"refcash")
                        appDelegate?.loginUser?.min_withdraw_amount = meta.valueForString(key:"min_withdraw_amount")
                        self.refreshRefCash()
                    }
                    else {
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                    }
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper Method

extension RefcashViewController {
    
    fileprivate func refreshRefCash(){
        
//        if (appDelegate?.loginUser?.refcash?.isBlank)! {
//            lblAvailableBlc.text = "\(appDelegate!.currency)0"
//        } else {
//            lblAvailableBlc.text = "\(appDelegate!.currency)\(appDelegate?.loginUser?.refcash ?? "0")"
//        }
//        if (appDelegate?.loginUser?.min_withdraw_amount?.isBlank)! {
//            lblMinRedeemAmount.text = "Minimum redeemption amount is \(appDelegate?.loginUser?.min_withdraw_amount ?? "0") ref."
//        } else {
//            lblMinRedeemAmount.text = "Minimum redeemption amount is \(appDelegate?.loginUser?.min_withdraw_amount ?? "0") ref."
//        }
        if (appDelegate?.loginUser?.refcash?.isBlank)! {
                    lblAvailableBlc.text = "\(appDelegate!.currency)0"
                } else {
                    let refcash = formatter.number(from: appDelegate?.loginUser?.refferal_alert ?? "")
                    lblAvailableBlc.text = "\(appDelegate!.currency)\(refcash ?? 0)"
                }
                if (appDelegate?.loginUser?.min_withdraw_amount?.isBlank)! {
                    let minWithdraw = formatter.number(from: appDelegate?.loginUser?.min_withdraw_amount ?? "0")
                    lblMinRedeemAmount.text = "Minimum redeemption amount is \(minWithdraw ?? 0 ) ref."
                } else {
                    let minWithdraw = formatter.number(from: appDelegate?.loginUser?.min_withdraw_amount ?? "0")
                    lblMinRedeemAmount.text = "Minimum redeemption amount is \(minWithdraw ?? 0) ref."
                }
    }
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtAmount.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankAmount, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        } else if txtAmount.text!.toFloat! < appDelegate?.loginUser?.min_withdraw_amount?.toFloat ?? 0 {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageMinimumAmount, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
            
        }
        return true
    }
}   
// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension RefcashViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataCashHistory = RefCashHistory(object: arrData[indexPath.row])
        
        if btnCredit.isSelected {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RefCashTableViewCell") as? RefCashTableViewCell  {
                
                cell.lblCash.text = "\(dataCashHistory.amount ?? "") Ref"
                cell.lblDate.text = dataCashHistory.time?.UTCToLocal()  
                cell.lblMerchantName.text = dataCashHistory.business_name
                cell.lblTagline.text = dataCashHistory.tag_line
                cell.imgVIcon.imageWithUrl(dataCashHistory.business_logo)
                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DebitRefCashTableViewCell") as? DebitRefCashTableViewCell  {
                
                switch dataCashHistory.status {
                case 1:
                    cell.imgVIcon.image = #imageLiteral(resourceName: "pending")
                    cell.lblStatus.text = "Pending"
                case 2:
                    cell.imgVIcon.image = #imageLiteral(resourceName: "redeemed")
                    cell.lblStatus.text = "Redeemed"
                default :
                    break
                }
                
                cell.lblCash.text = "\(dataCashHistory.amount ?? String()) Ref"
                cell.lblDate.text = dataCashHistory.time?.UTCToLocal()
                
                
                return cell
            }
        }
        if indexPath.row == arrData.count - 1 && page != 0 {
            self.loadRefCaseCreditDebit()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
