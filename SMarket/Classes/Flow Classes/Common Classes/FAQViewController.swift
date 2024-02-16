//
//  FAQViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class FAQViewController: ParentViewController {
    
    @IBOutlet weak var tblView : UITableView!
    
    var selectedIndexPath : IndexPath?
    var arrFAQ = [Any]()
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
        
        self.title = "FAQs"
        selectedIndexPath = IndexPath(row: 0, section: 0)
        loadDataFromServer()
    }
}

// MARK:-
// MARK:- Server request

extension FAQViewController {
    
    fileprivate func loadDataFromServer(){
        
        let param = ["user_type" : appDelegate?.loginUser?.user_type == 1 ? CCustomerType : CMerchantType]
        
        if arrFAQ.count == 0  {
            tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        }
        
        APIRequest.shared().loadFAQ(param) { (response, error) in
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]],data.count > 0  {
                    self.arrFAQ = data
                    self.tblView.reloadData()   
                }
            }
            
            //For remove loader or display data not found
            if self.arrFAQ.count > 0 {
                self.tblView.stopLoadingAnimation()
                
            } else if error == nil {
                self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                // ... -999 cancelled api
                // ... --1001 or -1009 no internet connection
                
                self.tblView.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                    self.loadDataFromServer()
                })
            }
            
        }
    }
}

// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension FAQViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFAQ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as? FAQTableViewCell {
            
            if let data = arrFAQ[indexPath.row] as? [String : Any] {
                
                if selectedIndexPath == indexPath {
                    cell.lblAnswer.text = data.valueForString(key: "answer")
                    cell.btnExpand.isSelected = true
                }else {
                    
                    cell.lblAnswer.text = ""
                    cell.btnExpand.isSelected = false
                }
                
                cell.lblQuestion.text = data.valueForString(key: "question")
                cell.lblQuestion.textColor =  (appDelegate?.isCustomerLogin)! ? ColorCustomerAppTheme : ColorMerchantAppTheme
            }
            
            cell.btnExpand.touchUpInside { (sender) in
                
                if sender.isSelected {
                    self.selectedIndexPath = nil
                } else {
                    self.selectedIndexPath = indexPath
                }
                
                tableView.reloadData()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
}

