//
//  MemberListViewController.swift
//  SMarket
//
//  Created by Mohammed Khubaib on 21/05/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

class MemberListViewController: ParentViewController {
    

    @IBOutlet weak var btnReferral : UIButton!
    @IBOutlet weak var btnRateReview : UIButton!
    @IBOutlet weak var btnCreateSendPDF : UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var arrOffer : [Offer]?
    
    //MARK:-
    //MARK:- LIFE CYCLE
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialize()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tblView.reloadData()
            self.updateAddOfferStatus()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "MEMBER LIST"
        loadMemberListFromServer()
        updateAddOfferStatus()
    }
    
    
    fileprivate func updateAddOfferStatus(){
        
    
        
        if CUserDefaults.string(forKey: UserDefaultLoginUser) ==  "member" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:nil, style: .plain, target: self, action: #selector(self.btnAddClicked))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "add_offer"), style: .plain, target: self, action: #selector(self.btnAddClicked))
        }
            
        
        
        if (self.arrOffer?.count ?? 0) > 0 {
            self.tblView.stopLoadingAnimation()
        }
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @objc fileprivate func btnAddClicked(_ sender : UIBarButtonItem) {
        if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "AddMemberViewController") as? AddMemberViewController {
            self.navigationController?.pushViewController(addMemberVC, animated: true)
        }
        
        
    }
    
    
}


// MARK:- Read More Configuration

extension MemberListViewController {
    
    fileprivate func displayDetailsView(_ data : String?) {
        
        self.presentAlertViewWithOneButton(alertTitle: "Condition", alertMessage: data, btnOneTitle: CBtnClose) { (action) in
        }
        
    }
    
  
}

// MARK:-
// MARK:- Send Mail Configuration

extension MemberListViewController {
    
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
    
    
}



// MARK:-
// MARK:- UITableViewDelegate,UITableViewDataSource

extension MemberListViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOffer?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOfferTableViewCell") as? MerchantOfferTableViewCell {
                        let data = arrOffer?[indexPath.row]
                        cell.lblTital.text = data?.email
                        cell.btnDelete.touchUpInside { (sender) in
                            
                            cell.btnDelete.isUserInteractionEnabled = false
                            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteOffer, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                                cell.btnDelete.isUserInteractionEnabled = true
                                let param = ["member_id":data?.memberID!]
                                self.deleteMember(param: param, indexPath: indexPath)
                                
                            }, btnTwoTitle: CBtnNo, btnTwoTapped: { (action) in
                                cell.btnDelete.isUserInteractionEnabled = true
                            })
                        }
                        
                        cell.btnEdit.touchUpInside { (sender) in
                            if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "AddMemberViewController") as? AddMemberViewController {
                                addMemberVC.fromEmail =  data?.email ?? ""
                                self.navigationController?.pushViewController(addMemberVC, animated: true)
                            }
                            
                        }
                        return cell
                    }
         return UITableViewCell()
    }
    
    }

extension MemberListViewController {
    
    @objc func pullToRefresh()  {
        loadMemberListFromServer()
    }
    
    fileprivate func loadMemberListFromServer() {
        
        if let refreshControl = tblView.pullToRefreshControl, refreshControl.isRefreshing {
        } else if arrOffer?.count == 0 || arrOffer?.count == nil {
            tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        }
        
        APIRequest.shared().loadMemberList() { (response, error) in
            
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]]{
                    
                   self.arrOffer = []
                    for item in data {
                       // print(item.valueForString(key: "email"))
                        self.arrOffer?.append(Offer(object: item))
                    }
                }
                print(self.arrOffer)
                self.tblView.reloadData()
            }
            
            self.updateAddOfferStatus()
            
            //For remove loader or display data not found
            if (self.arrOffer?.count ?? 0) > 0 {
                self.tblView.stopLoadingAnimation()
                
            } else if error == nil {
                self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                // ... -999 cancelled api
                // ... --1001 or -1009 no internet connection
                
                self.tblView.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                    
                    self.pullToRefresh()
                    
                })
            }
        }
    }
    
    fileprivate func createPDFAndSend() {
        
        APIRequest.shared().createPDFAndSendEmail() { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
    
    fileprivate func deleteMember(param : [String : Any], indexPath : IndexPath){
        
        APIRequest.shared().deleteMemberList(param) { (response, error) in
            
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
           
                    self.arrOffer?.remove(at: indexPath.row)
                
                
                self.updateAddOfferStatus()
                self.tblView.reloadData()
                //self.loadOfferListFromServer()
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                }
            }
        }
    }
}
