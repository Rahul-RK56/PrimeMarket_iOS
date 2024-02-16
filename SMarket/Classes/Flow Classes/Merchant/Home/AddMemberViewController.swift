//
//  AddMemberViewController.swift
//  SMarket
//
//  Created by Mohammed Khubaib on 25/05/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit

class AddMemberViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtConfirmEmail : UITextField!
    
    var fromEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Member"
        
        if !fromEmail.isEmpty {
            txtEmail.text = fromEmail
            txtConfirmEmail.text = fromEmail
        }
        // Do any additional setup after loading the view.
    }
    
    
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnSaveClicked(_ sender : UIButton) {
        addMemberFromServer()
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



extension AddMemberViewController {
   
    
    fileprivate func addMemberFromServer() {
        
        let param = ["email": txtEmail.text!.trim]
        APIRequest.shared().addMemberWithEmail(param) { (response, error) in
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any],  let meta = json[CJsonMeta] as? [String : Any]{
                    
                    switch meta.valueForInt(key: CJsonStatus) {
                        
                    case CStatusZero:
                        self.navigationController?.popViewController(animated: true)
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: meta.valueForString(key: CJsonMessage))
                    case CStatusOne:
                        
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                       
                    default:
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                    }
                }
                
            }
            
            else if error == nil {
                
                
            } else if let error = error as NSError? {
                
              
            }
        }
    }
}
