//
//  ExtensionUIViewController.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import UIKit

import ObjectiveC


    
    

typealias alertActionHandler = ((UIAlertAction) -> ())?
typealias alertTextFieldHandler = ((UITextField) -> ())

// MARK: - Extension of UIViewController For AlertView with Different Numbers of Buttons
extension UIViewController {
    
  
    /// This Method is used to show AlertView with one Button.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - btnOneTitle: A String value - Title of button.
    ///   - btnOneTapped: Button Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithOneButton(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler?) {
        print("presentAlertViewWithOneButton--- ",alertMessage)
        if alertMessage == "No Results Found " {
            
            let alertController = UIAlertController(title: alertTitle ?? "", message: "There is no cashback Offer added do you want to add" , preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                if let addMemberVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "CreateCashbackViewController") as? CreateCashbackViewController {
                    addMemberVC.welcome = true
                    let myNavigationController = UINavigationController(rootViewController: addMemberVC)
                    
                  
                    self.present(myNavigationController, animated: true)
                    

                }

                
            }))

            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: btnOneTapped ?? nil))


            self.present(alertController, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped ?? nil))


            self.present(alertController, animated: true, completion: nil)
        }

    }
    class func orderPartsStoryboard() -> UIStoryboard {
           return UIStoryboard(name: "MainMerchant", bundle: nil)
       }
    
    func presentAlertViewWithOneButtonAndLabel(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler?) {
           
           let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
           var addressLabel  = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
              addressLabel.numberOfLines = 0
              addressLabel.lineBreakMode = .byWordWrapping
              addressLabel.sizeToFit()
              addressLabel.preferredMaxLayoutWidth = alertController.view.frame.size.width
              addressLabel.font = UIFont(name: "Avenir-Light", size: 20)
              addressLabel.text = alertMessage
             // alertController.view.addSubview(addressLabel)
           alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped ?? nil))
          alertController.addTextField { (textField) in
             // textField.placeholder = "Enter First Name"
            textField.text = alertMessage
          }
           
           self.present(alertController, animated: true, completion: nil)
       }
    
    func presentAlertViewWithOneButtonAndTextField(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler?) {
              
              let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.text = textfield.text
        }
              var addressTextField  = UITextField(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
                 addressTextField.sizeToFit()
                 
                addressTextField.font = UIFont(name: "Avenir-Light", size: 20)
                 addressTextField.text = alertMessage
                // alertController.view.addSubview(addressTextField)
              alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped ?? nil))
//             alertController.addTextField { (textField) in
//                // textField.placeholder = "Enter First Name"
//               textField.text = alertMessage
//             }
              
              self.present(alertController, animated: true, completion: nil)
          }
    /// This Method is used to show AlertView with two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithTwoButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
//        alertController.addTextField { (textfield) in
//            textfield.text = alertMessage
//        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show AlertView with three Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnThreeTitle: A String value - Title of button three.
    ///   - btnThreeTapped: Button Three Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithThreeButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler , btnThreeTitle:String , btnThreeTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: btnThreeTitle, style: .default, handler: btnThreeTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - Extension of UIViewController For AlertView with Different Numbers of UITextField and with Two Buttons.
extension UIViewController {
    
    /// This Method is used to show AlertView with one TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: TextField Handler , you can directlly get the object of UITextField.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithOneTextField(alertTitle:String? , alertMessage:String? , alertFirstTextFieldHandler:@escaping alertTextFieldHandler , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertTextField) in
            alertFirstTextFieldHandler(alertTextField)
        }
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show AlertView with two TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: First TextField Handeler , you can directlly get the object of First UITextField.
    ///   - alertSecondTextFieldHandler: Second TextField Handeler , you can directlly get the object of Second UITextField.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithTwoTextFields(alertTitle:String? , alertMessage:String? , alertFirstTextFieldHandler:@escaping alertTextFieldHandler , alertSecondTextFieldHandler:@escaping alertTextFieldHandler , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertFirstTextField) in
            alertFirstTextFieldHandler(alertFirstTextField)
        }
        
        alertController.addTextField { (alertSecondTextField) in
            alertSecondTextFieldHandler(alertSecondTextField)
        }
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show AlertView with three TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: First TextField Handeler , you can directlly get the object of First UITextField.
    ///   - alertSecondTextFieldHandler: Second TextField Handeler , you can directlly get the object of Second UITextField.
    ///   - alertThirdTextFieldHandler: Third TextField Handeler , you can directlly get the object of Third UITextField.
    ///   - btnOneTitle:  A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle:  A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithThreeTextFields(alertTitle:String? , alertMessage:String? , alertFirstTextFieldHandler:@escaping alertTextFieldHandler , alertSecondTextFieldHandler:@escaping alertTextFieldHandler , alertThirdTextFieldHandler:@escaping alertTextFieldHandler , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertFirstTextField) in
            alertFirstTextFieldHandler(alertFirstTextField)
        }
        
        alertController.addTextField { (alertSecondTextField) in
            alertSecondTextFieldHandler(alertSecondTextField)
        }
        
        alertController.addTextField { (alertThirdTextField) in
            alertThirdTextFieldHandler(alertThirdTextField)
        }
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Extension of UIViewController For Actionsheet with Different Numbers of Buttons
extension UIViewController {
    
    /// This Method is used to show ActionSheet with One Button and with One(by Default) "Cancel Button" , While Using this method you don't need to add "Cancel Button" as its already there in ActionSheet.
    ///
    /// - Parameters:
    ///   - actionSheetTitle: A String value that indicates the title of ActionSheet , it is Optional so you can pass nil if you don't want ActionSheet Title.
    ///   - actionSheetMessage: A String value that indicates the ActionSheet message.
    
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentActionsheetWithOneButton(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertActionStyle , btnOneTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show ActionSheet with Two Buttons and with One(by Default) "Cancel Button" , While Using this method you don't need to add "Cancel Button" as its already there in ActionSheet.
    ///
    /// - Parameters:
    ///   - actionSheetTitle: A String value that indicates the title of ActionSheet , it is Optional so you can pass nil if you don't want ActionSheet Title.
    ///   - actionSheetMessage: A String value that indicates the ActionSheet message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentActionsheetWithTwoButtons(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertActionStyle , btnOneTapped:alertActionHandler , btnTwoTitle:String  , btnTwoStyle:UIAlertActionStyle , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: btnTwoStyle, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show ActionSheet with Three Buttons and with One(by Default) "Cancel Button" , While Using this method you don't need to add "Cancel Button" as its already there in ActionSheet.
    ///
    /// - Parameters:
    ///   - actionSheetTitle: A String value that indicates the title of ActionSheet , it is Optional so you can pass nil if you don't want ActionSheet Title.
    ///   - actionSheetMessage: A String value that indicates the ActionSheet message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnThreeTitle: A String value - Title of button three.
    ///   - btnThreeStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnThreeTapped: Button Three Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentActionsheetWithThreeButton(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertActionStyle , btnOneTapped:alertActionHandler , btnTwoTitle:String  , btnTwoStyle:UIAlertActionStyle , btnTwoTapped:alertActionHandler , btnThreeTitle:String  , btnThreeStyle:UIAlertActionStyle , btnThreeTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: btnTwoStyle, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: btnThreeTitle, style: btnThreeStyle, handler: btnThreeTapped))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func presentActionsheetWithArrayOfButtons(actionSheetTitle:String? , actionSheetMessage:String? , arrBtnTitlesAndStyle:[Any] , btnTapped:alertActionHandler,  btnCancleTapped:alertActionHandler?,  completion: (() -> Swift.Void)? = nil) {
        
        // arrBtnTitlesAndStyle // [[String :Any]]
         //exa arrBtnTitlesAndStyle
//        let arrAction = [["title" :"Action1",
//                          "style":UIAlertActionStyle.default],
//                         ["title" :"Action2",
//                          "style":UIAlertActionStyle.default]] as [Any]
        
        if let action = arrBtnTitlesAndStyle as? [[String : Any]], action.count > 0 {
            
            let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
            
            for (_, item) in action.enumerated() {
                
                if let title = item["title"] as? String, let style = item["style"] as? UIAlertActionStyle {
                    
                    alertController.addAction(UIAlertAction(title: title, style: style, handler: btnTapped))
                }
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: btnCancleTapped ?? nil))
            self.present(alertController, animated: true, completion: completion)
        }
    }
}

typealias popUpCompletionHandler = (() -> ())

extension UIViewController {
    
    func presentPopUp(view:UIView , shouldOutSideClick:Bool , type:MIPopUpOverlay.MIPopUpPresentType , completionHandler:popUpCompletionHandler?) {
        
        guard let miPopUpOverlay = MIPopUpOverlay.shared else { return }
        
        if self.navigationController != nil {
            self.navigationController?.view.addSubview(miPopUpOverlay)
        } else {
            self.view.addSubview(miPopUpOverlay)
        }
        
        view.tag = 151
        miPopUpOverlay.shouldOutSideClick = shouldOutSideClick
        miPopUpOverlay.type = type
        miPopUpOverlay.addSubview(view)
        
        miPopUpOverlay.presentPopUpOverlayView(view: view, completionHandler: completionHandler)
    }
    
    func dismissPopUp(view:UIView , completionHandler:popUpCompletionHandler?) {
        
        guard let miPopUpOverlay = MIPopUpOverlay.shared else { return }
        
        miPopUpOverlay.dismissPopUpOverlayView(view: view, completionHandler: completionHandler)
    }
    
}

typealias imagePickerControllerCompletionHandler = ((_ image:UIImage? , _ info:[String : Any]?) -> ())

// MARK: - Extension of UIViewController For UIImagePickerController - Select Image From Camera OR PhotoLibrary
extension UIViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        
        static var imagePickerController = "imagePickerController"
        static var imagePickerControllerCompletionHandler = "imagePickerControllerCompletionHandler"
    }
    
    /// A Computed Property of UIImagePickerController , If its already in memory then return it OR not then create new one and store it in memory reference.
    private var imagePickerController:UIImagePickerController? {
        
        if let imagePickerController = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerController) as? UIImagePickerController {
            
            return imagePickerController
        } else {
            return self.addImagePickerController()
        }
    }
    
    /// A Private method used to create a UIImagePickerController and store it in a memory reference.
    ///
    /// - Returns: return a newly created UIImagePickerController.
    private func addImagePickerController() -> UIImagePickerController? {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerController, imagePickerController, .OBJC_ASSOCIATION_RETAIN)
        
        return imagePickerController
    }
    
    /// A Private method used to set the sourceType of UIImagePickerController
    ///
    /// - Parameter sourceType: A Enum value of "UIImagePickerControllerSourceType"
    private func setImagePickerControllerSourceType(sourceType:UIImagePickerControllerSourceType) {
        
        self.imagePickerController?.sourceType = sourceType
    }
    
    /// A Private method used to set the Bool value for allowEditing OR Not on UIImagePickerController.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func setAllowEditing(allowEditing:Bool) {
        self.imagePickerController?.allowsEditing = allowEditing
    }
    
    /// This method is used to present the UIImagePickerController on CurrentController for select the image from Camera or PhotoLibrary.
    ///
    /// - Parameters:
    ///   - allowEditing: Pass the Bool value for allowEditing OR Not on UIImagePickerController.
    ///   - imagePickerControllerCompletionHandler: This completionHandler contain selected image AND info Dictionary to let you help in CurrentController. Both image AND info Dictionary might be nil , in this case to prevent the crash please use if let OR guard let.
    func presentImagePickerController(allowEditing:Bool , imagePickerControllerCompletionHandler:
        @escaping imagePickerControllerCompletionHandler) {
        
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Take A Photo", btnOneStyle: .default, btnOneTapped: { (action) in
            
            self.takeAPhoto()
            
        }, btnTwoTitle: "Choose From Phone", btnTwoStyle: .default) { (action) in
            
            self.chooseFromPhone(allowEditing:allowEditing)
        }
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    // Open picker in gallery mode
    func presentImagePickerControllerWithGallery(allowEditing:Bool , imagePickerControllerCompletionHandler:
        @escaping imagePickerControllerCompletionHandler) {
        
        self.chooseFromPhone(allowEditing:allowEditing)
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    // Open picker in Camera mode
    func presentImagePickerControllerWithCamera(allowEditing:Bool , imagePickerControllerCompletionHandler:
        @escaping imagePickerControllerCompletionHandler) {
        
        self.takeAPhoto()
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// A private method used to select the image from camera.
    private func takeAPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            self.setImagePickerControllerSourceType(sourceType: .camera)
            self.setAllowEditing(allowEditing: false)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {
            
            self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: "Your device does not support camera", btnOneTitle: "Ok", btnOneTapped: nil)
        }
    }
    
    /// A private method used to select the image from photoLibrary.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func chooseFromPhone(allowEditing:Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            self.setImagePickerControllerSourceType(sourceType: .photoLibrary)
            self.setAllowEditing(allowEditing: allowEditing)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {}
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            
            if let allowEditing = self.imagePickerController?.allowsEditing {
                
                var image:UIImage?
                
                if allowEditing {
                    
                    image = info[UIImagePickerControllerEditedImage] as? UIImage
                    
                } else {
                    image = info[UIImagePickerControllerOriginalImage] as? UIImage
                }
                
                if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                    
                    imagePickerControllerCompletionHandler(image, info)
                }
            }
        }
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            
            if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                
                imagePickerControllerCompletionHandler(nil, nil)
            }
        }
    }
    
}

typealias blockHandler = ((_ data:Any? , _ error:String?) -> ())

// MARK: - Extension of UIViewController set the Block and getting back with some data(Any Type of Data) AND error message(String).
extension UIViewController {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct blockKey {
        static var blockHandler = "blockHandler"
    }
    
    /// A Computed Property (only getter) of blockHandler(data , error) , Both data AND error are optional so you can pass nil if you don't want to share anything. This Computed Property is optional , it might be return nil so please use if let OR guard let.
    var block:blockHandler? {
        
        guard let block = objc_getAssociatedObject(self, &blockKey.blockHandler) as? blockHandler else { return nil }
        
        return block
    }
    
    /// This method is used to set the block on CurrentController for getting back with some data(Any Type of Data) AND error message(String).
    ///
    /// - Parameter block: This block contain data(Any Type of Data) AND error message(String) to let you help in CurrentController. Both data AND error might be nil , in this case to prevent the crash please use if let OR guard let.
    func setBlock(block:
        @escaping blockHandler) {
        
        objc_setAssociatedObject(self, &blockKey.blockHandler, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}

// MARK: - Extension of UIViewController.
extension UIViewController {
    
    /// This static method is used for initialize the UIViewController with nibName AND bundle.
    /// - Returns: This Method returns instance of UIViewController.
    static func initWithNibName() -> UIViewController {
        return self.init(nibName: "\(self)", bundle: nil)
    }
    
    var isVisible:Bool {
        return self.isViewLoaded && (self.view.window != nil)
    }
    
    var isPresentted:Bool {
        return self.isBeingPresented || self.isMovingToParentViewController
    }
    
    var isDismissed:Bool {
        return self.isBeingDismissed || self.isMovingFromParentViewController
    }
    
}

extension UIViewController {
    
    func openInSafari(strUrl:String?) {
        
        if var newStr = strUrl {
            
            if newStr.lowercased().hasPrefix("http://") || newStr.lowercased().hasPrefix("https://") {
                
            } else {
                newStr = "http://" + newStr
            }
            
            let urlString = newStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            if let newUrlString = urlString, let url = newUrlString.toURL {
                
                if CSharedApplication.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        CSharedApplication.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        CSharedApplication.openURL(url)
                    }
                }
                
            } else {
                print("Master Log ::--> Unable to Convert the String to URL")
            }
        }
    }
    
    func openPhoneDialer(_ mobileNo : String?)  {
        
        guard let mobileNo = mobileNo, let number = URL(string: "tel://\(mobileNo)") else { return }
        
        if UIApplication.shared.canOpenURL(number) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                UIApplication.shared.openURL(number)
            }
        }
    }
    
    func openGoogleMap(_ latitude : String?, longitude : String?, address : String?)  {
        
        if let lat = latitude, let long = longitude {
            
            var urlString = "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving"
        
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                if let url = URL(string: urlString) {
                    if (UIApplication.shared.canOpenURL(url)) {
                        
                        UIApplication.shared.open(url, options: [:]) { (success) in
                            
                        }
                        return
                    }
                }
            }
            
            print("Can't use comgooglemaps://");
            
            urlString = "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving"
            if let url = URL(string: urlString) {                
                UIApplication.shared.open(url, options: [:]) { (success) in
                    
                }
            }
            
            
        }
    }
}
extension UIViewController {
    
   
    
    
    func showAlertView(_ message : String?, completion: alertActionHandler?) {
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: completion)
    }
    
    func fullScreenImage(_ imageView : UIImageView, urlString : String?) {
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
            config.imageUrl = urlString
        }
        present(ImageViewerController(configuration: configuration), animated: true)
    }
}


