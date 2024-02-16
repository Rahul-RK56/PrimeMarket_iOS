//
//  CreateCashbackViewController.swift
//  SMarket
//
//  Created by Mohammed Khubaib on 01/12/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit




class CreateCashbackViewController: ParentViewController {

    @IBOutlet weak var cashBackPercentageTF: LRFGenericTextField!
    
    @IBOutlet weak var conditionTF: LRFGenericTextField!
    
    @IBOutlet weak var saveBtn: LRFGenericButton!
    
    var welcome:Bool = false
    
    var arrOffer : [Offer]?
    var fromAmount = ""
    var cashBackId = ""
    var fromCondition = ""
    var edit: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CREATE CASHBACK OFFER"
      //  createCouponOffer()
     //   createEditCashBack()
        
      //  createUpdateCashback()
      //  createDeleteCashBack()
        addBackButton()
      
        cashBackPercentageTF.text = fromAmount
        conditionTF.text = fromCondition
        
        // Do any additional setup after loading the view.
        if edit {
            saveBtn.setNormalTitle(normalTitle: "Update")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           addBackButton()
       }
       
       func addBackButton() {
           self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(btnBackClicked))
       }

       @objc  fileprivate func btnBackClicked(_ sender : UIBarButtonItem) {
           self.navigationController?.popViewController(animated: true)
           dismiss(animated: true)
       }
    
    
    @IBAction func cashBackCreateButtonTapped(_ sender: Any) {
        
        if saveBtn.titleLabel?.text == "Update"{
            guard let amount = cashBackPercentageTF.text else {
                    return  MIToastAlert.shared.showToastAlert(position: .bottom, message: "Please enter Amount")
                }
            guard let condition = conditionTF.text else {
                return  MIToastAlert.shared.showToastAlert(position: .bottom, message: "Please enter condition to use cash back")
            }
            
            
            var param = [String : Any]()
            
                param["cashback_id"] = cashBackId
                    param["offer_percentage"] = amount
                
                param["offer_condition"] = condition
                param["status"] = 0
                
        
            print(param)
            APIRequest.shared().addUpdateCashBack(param, completion:  { (response, error) in
                // Create new Alert
                let dialogMessage = UIAlertController(title: "Success", message: "Your Cashback Details Updated", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
                    
                    self.navigationController?.popViewController(animated: true)
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
                    
                    if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                        
                        if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                            
                            print(json.valueForString(key: "status"))
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                        }
                    }
                })
            
            
        }else{
            guard let amount = cashBackPercentageTF.text else {
                    return  MIToastAlert.shared.showToastAlert(position: .bottom, message: "Please enter Amount")
                }
            guard let condition = conditionTF.text else {
                return  MIToastAlert.shared.showToastAlert(position: .bottom, message: "Please enter condition to use cash back")
            }
            
            var param = [String : Any]()
            
                
                    param["offer_percentage"] = amount
                
            
                param["offer_condition"] = condition
                param["status"] = 0
            
            
            print(param)
            APIRequest.shared().addCreateCashback(param, completion:  { [self] (response, error) in
              
                    
                
                    // Create new Alert
                    let dialogMessage = UIAlertController(title: "Success", message: "your cashback created", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
                        
                       
                       
                        self.navigationController?.popViewController(animated: true)
                      
                      
                     })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)
                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                
               
                    if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                        
                        if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                            
                            
                            MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            
        }
      
       
    }
    fileprivate func  createDeleteCashBack(){
        var param = [String : Any]()
        
            param["cashback_id"] = 27
        
        print(param)
        APIRequest.shared().deleteCashBack(param, completion:  { (response, error) in
          
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        
                        print(json.valueForString(key: "status"))
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                    }
                }
            })
        
    }
    
    fileprivate func  createUpdateCashback(){
        
        var param = [String : Any]()
        
            param["cashback_id"] = 28
                param["offer_percentage"] = 10
            
            param["offer_condition"] = "Test"
            param["status"] = 0
            
    
        print(param)
        APIRequest.shared().addUpdateCashBack(param, completion:  { (response, error) in
          
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        
                        print(json.valueForString(key: "status"))
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                    }
                }
            })
        
    }
    
    fileprivate func  createEditCashBack(){
        
        var param = [String : Any]()
        
            
                param["cashback_id"] = 28
            
        
        print(param)
        APIRequest.shared().addEditCashBack(param, completion:  { (response, error) in
          
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        
                        
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                    }
                }
            })
        
    }
    
    
    
    

    
    fileprivate func createCouponOffer() {
        
        var param = [String : Any]()
        
            
                param["offer_percentage"] = 10
            
            param["offer_condition"] = "test"
            param["status"] = 0
        
        
        print(param)
        APIRequest.shared().addCreateCashback(param, completion:  { (response, error) in
          
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                        
                        
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                    }
                }
            })
            
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
