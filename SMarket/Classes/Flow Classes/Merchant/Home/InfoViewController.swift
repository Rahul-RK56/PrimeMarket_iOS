    //
//  InfoViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 19/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

class InfoViewController: ParentViewController {

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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "close_white"), style: .plain, target: self, action: #selector(btnCloseClicked))
    }

    // MARK:-
    // MARK:- ACTION EVENT
    
    @IBAction fileprivate func btnCloseClicked(_ sender : UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
