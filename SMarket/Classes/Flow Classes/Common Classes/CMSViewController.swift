//
//  CMSViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 09/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import WebKit
class CMSViewController: ParentViewController ,WKUIDelegate {
    
    var webView =  WKWebView()
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    
    fileprivate func initialize()  {
        
        view.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        
        if let description = iObject as? String{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                let webConfiguration = WKWebViewConfiguration()
                self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
                self.webView.uiDelegate = self
                
                self.webView.frame = CGRect(x: 10, y: 10, width: self.view.CViewWidth - 20, height: self.view.CViewHeight - 20)
                self.view.addSubview(self.webView)
                
                var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
                headerString.append(description)
                
                self.webView.loadHTMLString("\(headerString)", baseURL: nil)
                self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading", !webView.isLoading  {
            self.view.stopLoadingAnimation()
        }
    }
}

