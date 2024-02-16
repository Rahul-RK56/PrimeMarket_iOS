//
//  ExtensionUITableView.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import UIKit

extension UITableView {

    var pullToRefreshControl: UIRefreshControl? {
        get {
            if #available(iOS 10.0, *) {
                return self.refreshControl
            } else {
                return self.viewWithTag(9876) as? UIRefreshControl
            }
        } set {
            if #available(iOS 10.0, *) {
                self.refreshControl = newValue
            } else {
                if let refreshControl = newValue {
                    refreshControl.tag = 9876
                    self.addSubview(refreshControl)
                }
            }
        }
    }
}
