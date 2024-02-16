//
//  RedeemRefCashViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 13/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import Stripe

class RedeemRefCashViewController: ParentViewController {
    
    @IBOutlet weak var txtAmount : UITextField!
    
    @IBOutlet weak var lblAvailableBlc: UILabel!
    @IBOutlet weak var btnCredit : UIButton!
    @IBOutlet weak var btnDebit : UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn25 : UIButton!
    @IBOutlet weak var btn50 : UIButton!
    @IBOutlet weak var btn100 : UIButton!
    @IBOutlet weak var btn200 : UIButton!
    
    @IBOutlet weak var tblView : UITableView!
    
    @IBOutlet var cnVwSelectionLeading : NSLayoutConstraint!
    
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
        
        self.title = "REDEEM REFCASH"
        
        refreshRefCash()        
        loadRefCaseHistory()
        textFieldValueUpdateConfiguration()
        txtAmount.delegate = self
       
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
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
        
        loadRefCaseHistory()
        
        UIView.animate(withDuration: 0.3) {
            
            self.cnVwSelectionLeading.constant = sender == self.btnDebit ? 0 : (CScreenWidth/2)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction fileprivate func btnSuggestAmountClicked(_ sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        deSelectSuggestion()

        sender.isSelected = true
        sender.backgroundColor = ColorMerchantAppTheme
        
        switch sender {
        case btn10:
            txtAmount.text = "10"
        case btn25:
            txtAmount.text = "25"
        case btn50:
            txtAmount.text = "50"
        case btn100:
            txtAmount.text = "100"
        case btn200:
            txtAmount.text = "200"
        default:
            break
        }
    }
    
    @IBAction fileprivate func btnAddMoneyClicked(_ sender : UIButton) {
        
      /*  if isValidationPassed() {
            
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            
            // Present add card view controller
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            navigationController.navigationBar.barTintColor = ColorMerchantAppTheme
            navigationController.navigationBar.barStyle = .default
            navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:CFontPoppins(size: 19, type: .Medium), NSAttributedStringKey.foregroundColor:UIColor.white]
            STPTheme.default().secondaryBackgroundColor = ColorMerchantAppTheme
            
            present(navigationController, animated: true)
            
        }  */
        self.showAlertView(CMessageTopupAddMoney, completion: nil)
    }
}

// MARK:-
// MARK:- Server Request

extension RedeemRefCashViewController
{
    @objc func pullToRefresh()  {
        
        page = 1
        loadRefCaseHistory()
    }
    fileprivate func loadRefCaseHistory() {
        
        var param = [String : Any]()
        param["history_type"] = btnDebit.isSelected ? "2" : "1"
        param["page"] = page
        
        if page == 1 && arrData.count == 0  {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
        APIRequest.shared().loadMerchantRefCashHistory(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    if self.page == 1 {
                        self.arrData.removeAll()
                    }
                    self.arrData = self.arrData + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                }
            }
            else if error == nil {
                self.page = 0
            }
            
            if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                appDelegate?.loginUser?.refcash = meta.valueForString(key:"refcash")
                self.refreshRefCash()
                
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
    fileprivate func addRefcash(token: STPToken) {
        
        let param = ["stripe_token": token.tokenId,
                     "amount": txtAmount.text?.toInt ?? 0] as [String : Any]

        APIRequest.shared().addRefCash(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    appDelegate?.loginUser?.refcash = meta.valueForString(key:"refcash")
                    self.navigationController?.popViewController(animated: true)
                    MIToastAlert.shared.showToastAlert(position: .bottom, message:meta.valueForString(key: CJsonMessage) )
                }
            }
        }
    }
}

// MARK:-
// MARK:- HELPER METHODS

extension RedeemRefCashViewController {
    
    
    fileprivate func refreshRefCash(){
        
        if (appDelegate?.loginUser?.refcash?.isBlank)! {
            lblAvailableBlc.text = "\(currencyUnit)0"
        } else {
            lblAvailableBlc.text = "\(currencyUnit)\(appDelegate?.loginUser?.refcash ?? "0")"
        }
    }
    fileprivate func textFieldValueUpdateConfiguration(){
        
        txtAmount.valueChangedEvent { (textField) in
            
            
            switch self.txtAmount.text {
            case "10" :
                self.btnSuggestAmountClicked(self.btn10)
                
            case "25" :
                self.btnSuggestAmountClicked(self.btn25)
                
            case "50" :
                self.btnSuggestAmountClicked(self.btn50)
                
            case "100" :
                self.btnSuggestAmountClicked(self.btn100)
            
            case "200" :
                self.btnSuggestAmountClicked(self.btn200)
                
            default :
                self.deSelectSuggestion()
            }
        }
    }
    
    
    fileprivate func deSelectSuggestion(){
        
        btn10.isSelected = false
        btn25.isSelected = false
        btn50.isSelected = false
        btn100.isSelected = false
        btn200.isSelected = false
        btn10.backgroundColor = CRGB(r: 240, g: 244, b: 195)
        btn25.backgroundColor = CRGB(r: 240, g: 244, b: 195)
        btn50.backgroundColor = CRGB(r: 240, g: 244, b: 195)
        btn100.backgroundColor = CRGB(r: 240, g: 244, b: 195)
        btn200.backgroundColor = CRGB(r: 240, g: 244, b: 195)
    }
    
    fileprivate func isValidationPassed() -> Bool {
        
        if (txtAmount.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageBlankAmount, btnOneTitle: CBtnOk) { (action) in
            }
            return false
        }
        return true
    }
}
// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension RedeemRefCashViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DebitRefCashTableViewCell") as? DebitRefCashTableViewCell  {
        
            if let data = arrData[indexPath.row] as? [String : Any] {
               
                let dataCashHistory = RefCashHistory(object:data)
                cell.lblCash.text = "\(dataCashHistory.amount ?? "") Ref"
                cell.lblDate.text = dataCashHistory.time?.UTCToLocal()
                cell.lblStatus.text = dataCashHistory.name
            }
            
            
            if indexPath.row == arrData.count - 1 && page != 0 {
                loadRefCaseHistory()
            }
            
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK:-
// MARK:- UITextFieldDelegate

extension RedeemRefCashViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = txtAmount.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 25 // Bool
    }
    func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm:ss" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
}   

// MARK:-
// MARK:- Stripe Delegete Method

extension RedeemRefCashViewController : STPAddCardViewControllerDelegate {
   
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        
        if !token.tokenId.isBlank {
            addRefcash(token: token)
        }
        print("Printing Strip Token:\(token.tokenId)")
    }
}
