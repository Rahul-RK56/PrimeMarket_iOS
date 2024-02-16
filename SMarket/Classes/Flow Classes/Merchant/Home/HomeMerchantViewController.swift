//
//  HomeMerchantViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class HomeMerchantViewController: ParentViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblRefCashTitle: UILabel!
    @IBOutlet weak var lblRefCase: UILabel!
    @IBOutlet weak var vwSendMsg : UIView!
    @IBOutlet weak var vwAddmember : UIView!
    @IBOutlet weak var txtViewMsg : UITextView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var referalView: UIView!
    
    @IBOutlet weak var myOffersView: UIView!
    
    @IBOutlet weak var addReferalView: UIView!
    
    @IBOutlet weak var manageMemberView: UIView!
    
    @IBOutlet weak var cashbackView: UIView!
    @IBOutlet weak var height1: NSLayoutConstraint!
    var arrBanner = [Any]()
    var page = 1
    var apiTask : URLSessionTask?
    
    let formatter = NumberFormatter()
    //MARK:-
    //MARK:- LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // lblRefCase.text = "\(currencyUnit)\(appDelegate?.loginUser?.refcash ?? "0")"
        
        
        
        addRefcash()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
       
        
        
        
      let userName =  CUserDefaults.value(forKey: UserDefaultLoginUser) as? String ?? ""
        print(userName)
        if userName == "merchant"{
            
        }else{
            referalView.isHidden = true
            myOffersView.isHidden = true
            addReferalView.isHidden = true
            manageMemberView.isHidden = true
            cashbackView.isHidden = true
        }
        
     //   height1.constant = 0
        
       // stackView.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = appDelegate?.loginUser?.name
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
        self.navigationController?.view.addSubview(vwSendMsg)
        self.navigationController?.view.addSubview(vwAddmember)
       // vwAddmember.center = (navigationController?.view.center)!
        vwAddmember.layer.masksToBounds = false
        setViewSettingWithBgShade(view: vwAddmember)
        vwSendMsg.isHidden = true
        vwAddmember.isHidden = true

        
        txtViewMsg.layer.borderColor = ColorMerchantAppTheme.cgColor

       // addRefcash()
        loadBannerFromServer()
    }
    
    override func viewDidLayoutSubviews() {
        vwSendMsg.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
    }
   
    public func setViewSettingWithBgShade(view: UIView)
    {
    
        //view.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)

        //MARK:- Shade a view
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.masksToBounds = false
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    @IBAction func btnCancelClicked(_ sender : UIButton) {
        vwSendMsg.isHidden = true
    }
    
    @IBAction func btnOpenMsgClicked(_ sender : UIButton) {
        vwSendMsg.isHidden = false
        
    }
  
    @IBAction func btnBackClicked(_ sender : UIButton) {
        vwSendMsg.isHidden = true
    }
    
    @IBAction func btnSendReferClicked(_ sender : UIButton) {
        
        if (txtViewMsg.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "Alert", alertMessage: "Please enter message", btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        addReferMsg(params: ["message":txtViewMsg.text])
    }
    
    func addReferMsg(params : [String:Any]){
        APIRequest.shared().addReferMsg(params) { (response, error) in
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                    print(data)
                    print(meta)
                }
            }
        }
    }
    
    @IBAction fileprivate func btnScanOfferClicked(_ sender : UIButton) {
        
        if let scanQRCodeVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "RedeemCodeViewController") as? RedeemCodeViewController {
            self.navigationController?.pushViewController(scanQRCodeVC, animated: true)
        }
        
    }
    
    @IBAction fileprivate func btnAddRefCashClicked(_ sender : UIButton) {
        
        if let redeemRefVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "RedeemRefCashViewController") as? RedeemRefCashViewController {
            redeemRefVC.iObject = self.lblRefCase.text
            self.navigationController?.pushViewController(redeemRefVC, animated: true)
        }
        
    }
    @IBAction fileprivate func btnMyOfferClicked(_ sender : UIButton) {
        
        if let myOfferVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "MyOfferViewController") as? MyOfferViewController {
            self.navigationController?.pushViewController(myOfferVC, animated: true)
        }
    }
    
    @IBAction fileprivate func btnManageMemberClicked(_ sender : UIButton) {
        
        if let memberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "MemberListViewController") as? MemberListViewController {
            self.navigationController?.pushViewController(memberVC, animated: true)
        }
        

    }
    
    @IBAction fileprivate func btnCreateCashbackClicked(_ sender : UIButton) {
                if let memberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CashBackListViewController") as? CashBackListViewController {
                    self.navigationController?.pushViewController(memberVC, animated: true)
                }
        
//        if let memberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController {
//            self.navigationController?.pushViewController(memberVC, animated: true)
//        }
    }
    
}

// MARK:-
// MARK:- Helper Method

extension HomeMerchantViewController {
    
    fileprivate func addRefcash() {
        if appDelegate?.loginUser?.refcash?.toFloat == 0.0 {
            lblRefCashTitle.text = "Add refcash (to promote your business)"
            lblRefCase.isHidden = true
        } else {
            lblRefCashTitle.text = "RefCash:"
            lblRefCase.isHidden = false
            let val = appDelegate?.loginUser?.country_code ?? ""
            print(val , "currency")
//            if val == "+91"{
//                lblRefCase.text = "\(appDelegate!.currencyINDIA) \(appDelegate?.loginUser?.refcash ?? "0")"
//
//
//            }else{
//                lblRefCase.text = "\(appDelegate!.currencyUSA) \(appDelegate?.loginUser?.refcash ?? "0")"
//
//            }
            if val == "+91"{
                            let refCash = formatter.number(from: appDelegate?.loginUser?.refcash ?? "0")
                            lblRefCase.text = "\(appDelegate!.currencyINDIA) \(Int(refCash ?? 0))"
                            
                           
                        }else{
                            let refCash = formatter.number(from: appDelegate?.loginUser?.refcash ?? "0")
                            lblRefCase.text = "\(appDelegate!.currencyUSA) \(Int(refCash ?? 0))"
                           
                        }
        }
    }
}

// MARK:-
// MARK:- Server request

extension HomeMerchantViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadBannerFromServer()
    }
    
    fileprivate func loadBannerFromServer() {
        
        if apiTask != nil && apiTask?.state == .running {
            apiTask?.cancel()
        }
        var param = [String : Any]()
        
        param["user_type"] = CMerchantType
        param["page"] = page
                
        apiTask = APIRequest.shared().loadBanner(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrBanner.removeAll()
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.arrBanner = self.arrBanner + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                    
                    if let meta = dataResponse[CJsonMeta] as? [String: Any], meta.count > 0 {
                        
                      //  self.lblRefCase.text = "\(currencyUnit)\(meta.valueForString(key: "refcash"))"
                        
                        let val = appDelegate?.loginUser?.country_code ?? ""
                        print(val , "currency")
//                        if val == "+91"{
//                            self.lblRefCase.text = "\(appDelegate!.currencyINDIA) \(appDelegate?.loginUser?.refcash ?? "0")"
//
//                            print(self.lblRefCase.text)
//                        }else{
//                            self.lblRefCase.text = "\(appDelegate!.currencyUSA) \(appDelegate?.loginUser?.refcash ?? "0")"
//                            print(self.lblRefCase.text)
//                        }
                        if val == "+91"{
                                                    let refCash = self.formatter.number(from: appDelegate?.loginUser?.refcash ?? "0")
                                                    self.lblRefCase.text = "\(appDelegate!.currencyINDIA) \(Int(refCash ?? 0))"
                                                    
                                                    print(self.lblRefCase.text)
                                                }else{
                                                    let refCash = self.formatter.number(from: appDelegate?.loginUser?.refcash ?? "0")
                                                    self.lblRefCase.text = "\(appDelegate!.currencyUSA) \(Int(refCash ?? 0))"
                                                    print(self.lblRefCase.text ?? "no data print")
                                                }
                        
                        appDelegate?.loginUser?.refcash = meta.valueForString(key: "refcash")
                        print("\("Merchant id11")\(meta.valueForInt(key: "id") ?? 0)")
                        
                       
                    }
                }else {
                    self.page = 0
                }
            }
        }
    }
}

// MARK:-
// MARK:- UITableViewDelegate,UITableViewDataSource

extension HomeMerchantViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBanner.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOfferTableViewCell") as! HomeOfferTableViewCell
        
        if let dict = arrBanner[indexPath.row] as? [String : Any] {
            cell.imgView.imageWithUrl(dict.valueForString(key: "banner"))
            
            cell.imgView.touchUpInside { (imageView) in
                self.fullScreenImage(imageView, urlString: dict.valueForString(key: "banner"))
            }
        }
        
        if indexPath.row == arrBanner.count - 1 && page != 0 {
            loadBannerFromServer()
        }
        return cell
    }
}
