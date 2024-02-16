//
//  CashBackListViewController.swift
//  SMarket
//
//  Created by CIPL0874 on 20/12/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit



class CashBackListViewController: ParentViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrOffer : [CashOffer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didLoad")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        print("viewDidAppear")
            // insert animation here to run when FirstViewController appears...
        }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        initialize()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              self.tableView.reloadData()
           //lf.updateAddOfferStatus()
        }
        
       // createListCashBackFromServer()
        tableView.reloadData()
    }
    
   
    @IBAction func pdfSendTapped(_ sender: Any) {
        
        createPDFAndSend()
    }
    
    
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "CASH BACK LIST"
        //  loadMemberListFromServer()
       createListCashBackFromServer()
        tableView.reloadData()
        updateAddOfferStatus()
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
    
    fileprivate func updateAddOfferStatus(){
        
        
        
        if CUserDefaults.string(forKey: UserDefaultLoginUser) ==  "member" {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:nil, style: .plain, target: self, action: #selector(self.btnAddClicked))
        }else{
          
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "add_offer"), style: .plain, target: self, action: #selector(self.btnAddClicked))
         
            
        }
        //        if (self.arrOffer?.count ?? 0) > 0 {
        //            self.tblView.stopLoadingAnimation()
        //        }
    }
    
    // MARK:-
    // MARK:- ACTION EVENT
    
    @objc fileprivate func btnAddClicked(_ sender : UIBarButtonItem) {
        
        if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController {
            self.navigationController?.pushViewController(addMemberVC, animated: true)
        }
        
        
    }
    
}



// MARK:-
// MARK:- UITableViewDelegate,UITableViewDataSource

extension CashBackListViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOffer?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CashBackListTableViewCell") as? CashBackListTableViewCell {
            let data = arrOffer?[indexPath.row]
            cell.cashBackLbl.text =  "\(data?.offer_percentage ?? 0) \("% Cashback")"
            
            // cell.cashBackLbl.text = data?.email
                                    cell.deleteButton.touchUpInside { (sender) in
                                        
                                        var param = [String : Any]()
                                        
                                        param["cashback_id"] = data?.id
                                        
                                        print(param)
                                        APIRequest.shared().deleteCashBack(param, completion:  { (response, error) in
                                          
                                            // Create new Alert
                                            let dialogMessage = UIAlertController(title: "Alert", message: "Your Cashback Details Deleted", preferredStyle: .alert)
                                            
                                            // Create OK button with action handler
                                            let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
                                                self.arrOffer = []
                                                tableView.reloadData()
                                                initialize()
                                               
                                             })
                                            
                                            //Add OK button to a dialog message
                                            dialogMessage.addAction(ok)
                                            // Present Alert to
                                            self.present(dialogMessage, animated: true, completion: nil)
                                                
                                                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                                                    
                                                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                                                        
                                                        print(json.valueForString(key: "status"))
                                                        MIToastAlert.shared.showToastAlert(position: .bottom, message: "Your Cashback Details Deleted")
                                                        
//                                                        // Create new Alert
//                                                        let dialogMessage = UIAlertController(title: "Alert", message: "Your Cashback Details Deleted", preferredStyle: .alert)
//
//                                                        // Create OK button with action handler
//                                                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                                                            self.initialize()
//                                                         })
//
//                                                        //Add OK button to a dialog message
//                                                        dialogMessage.addAction(ok)
//                                                        // Present Alert to
//                                                        self.present(dialogMessage, animated: true, completion: nil)
                                                    }
                                                }
                                            })
            
//                                       // cell.deleteButton.isUserInteractionEnabled = false
//                                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteOffer, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
//                                            cell.deleteButton.isUserInteractionEnabled = true
//                                            let param = ["member_id":data?.memberID!]
//                                           // self.deleteMember(param: param, indexPath: indexPath)
//
//                                        }, btnTwoTitle: CBtnNo, btnTwoTapped: { (action) in
//                                            cell.deleteButton.isUserInteractionEnabled = true
//                                        })
                                    }
            
                                    cell.editButton.touchUpInside { (sender) in
            
                                        if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController
                                        
                                        {
                                            addMemberVC.fromAmount = "\(data?.offer_percentage ?? 0)"
                                            addMemberVC.fromCondition = data?.offer_condition ?? ""
                                            addMemberVC.edit = true
                                            addMemberVC.cashBackId = "\(data?.id ?? 0)"
                                            self.navigationController?.pushViewController(addMemberVC, animated: true)
                                        }
            
                                    }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
}


extension CashBackListViewController  {
    
    fileprivate  func createListCashBackFromServer(){
        
        APIRequest.shared().listCashBack(completion: { (response, error) in
         
            

            let result = response?["status"] as? String ?? ""
            if result == "error"{
              
                let alertController = UIAlertController(title: "", message: "There is no cashback Offer added do you want to add" , preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController {
                        self.navigationController?.pushViewController(addMemberVC, animated: true)
                    }

                    
                }))

                alertController.addAction(UIAlertAction(title: "No", style: .default, handler:nil))


                self.present(alertController, animated: true, completion: nil)
               
            }
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                print(response?["status"], "message1")
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]]{
                
                    print(json.valueForString(key: "message"),"message")
                    print(json.valueForString(key: CJsonStatus))
                    self.arrOffer = []
                    for item in data {
                        self.arrOffer?.append(CashOffer(object: item))
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                  
                    print(self.arrOffer)
                    //MIToastAlert.shared.showToastAlert(position: .bottom, message: data.valueForString(key: CJsonMessage))
                }
                
                
            }
           
           
        })
        
    }

}



