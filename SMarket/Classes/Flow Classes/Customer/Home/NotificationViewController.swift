//
//  NotificationViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 10/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class NotificationViewController: ParentViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var arrNofitication = [Any]()
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
        
        self.title = "NOTIFICATIONS"
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        tblView?.pullToRefreshControl = refreshControl
        
        loadNotificationFromServer()
    }

}

// MARK:-
// MARK:- Server Request

extension NotificationViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadNotificationFromServer()
    }
    
    fileprivate func loadNotificationFromServer() {
        
        var param = [String : Any]()
        param["page"] = page
        param["type"] = "customer"
        
        if page == 1 && arrNofitication.count == 0 {
            if let refreshController = tblView.refreshControl, !refreshController.isRefreshing {
                tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
            }
        }
        
        APIRequest.shared().loadNotificationlist(param) { (response, error) in
            self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrNofitication.removeAll()
                    self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                    self.arrNofitication = self.arrNofitication + data
                    self.page = self.page + 1
                    self.tblView.reloadData()
                }
                else {
                    self.page = 0
                }
            }
            
            //For remove loader or display data not found
            if self.arrNofitication.count > 0 {
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
}

// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNofitication.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell  {
            
            if let data = arrNofitication[indexPath.row] as? [String : Any] {
                
                cell.lblMessageText.text = data.valueForString(key: "message")
                cell.lblDate.text = data.valueForString(key: "date").durationFromString()
                
            }
            if indexPath.row == arrNofitication.count - 1 && page != 0 {
                self.loadNotificationFromServer()
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

