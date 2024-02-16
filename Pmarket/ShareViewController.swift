//
//  ShareViewController.swift
//  PMarket
//
//  Created by CIPL0419 on 25/04/22.
//  Copyright © 2022 Mind. All rights reserved.
//



import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    let suiteName = "group.com.app.smarket.share"
//    let suiteName = "group.com.app.smarket.Extension"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Share"
        
    }
    // This method is used to validate the input from the user. If they type too many characters,
    // or select something invalid, this returns false.
    override func isContentValid() -> Bool {
        return true
    }
    
    // Called after the user selects an image from the photos
    override func didSelectPost() {
        // This is called after the user selects Post.
        // Make sure we have a valid extension item
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            
            for itemProvider in item.attachments!{
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            self.saveData(color: "ShareText", text: shareURL.absoluteString!)
                        }
                    })
                }
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { (text, error) -> Void in
                        self.saveData(color: "ShareText", text: text as? String ?? "")
                    })
                }
            }
            if let url = URL.init(string: "smarket://"){
                _ = self.openURL(url)
            }
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    @discardableResult @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    // Returns an array of colors. In our case it's red, blue or default. These are built configuration
    // items, not just the string.
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return [colorConfigurationItem]
    }
    
    // Builds a configuration item when we need it. This one is for the "Color"
    // configuration item.
    lazy var colorConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item?.title = "Compare"
        item?.value = "ShareText"
        return item!
    }()
    
    
    // Saves an image to user defaults.
    func saveData(color: String, text: String) {
        if let prefs = UserDefaults(suiteName: suiteName) {
            prefs.removeObject(forKey: color)
            prefs.set(text, forKey: color)
            prefs.synchronize()
        }
    }
    func saveText(color: String, text: String) {
        
        if let prefs = UserDefaults(suiteName: suiteName) {
            prefs.removeObject(forKey: color)
            prefs.set(text, forKey: color)
            prefs.synchronize()
        }
    }
}
