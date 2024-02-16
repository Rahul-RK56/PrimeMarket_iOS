//
//  AppDelegate.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import CoreData

import KYDrawerController
import IQKeyboardManagerSwift
import MessageUI
import SDWebImage

import Firebase
import FirebaseInstanceID
import UserNotifications
import FirebaseMessaging
import GoogleSignIn
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import Contacts
import Stripe

typealias ClosurePlacePicker   = (_ place:GMSPlace?) -> Void
typealias CloserAddressPicker = ([String:Any]?) -> Void
typealias locationAuthorizationChange = (_ status :CLAuthorizationStatus?,_ locations:CLLocation?)-> Void
var colorBtn = UIColor(named: "bg_button")


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, KYDrawerControllerDelegate {

    let suiteName = "group.com.app.smarket.share"
//    let suiteName = "group.com.app.smarket.Extension"

    var window: UIWindow?
    var isCustomerLogin = true
    var placePickerHandler : ClosurePlacePicker?
    var sideMenuViewController: KYDrawerController?
    var loginUser : TBLUser?
    var lat : String?
    var long : String?
    var locationManager : CLLocationManager?
    var locationAuthChange : locationAuthorizationChange?
    var referred  = "0"
    var reward : Double  = 0.0
    var currency = " "
    var currencyUSA = "$"
    var currencyINDIA = "₹"
    var userDetail :[String:Any] = [:]
    var launchedURL: URL?
    
}


// MARK:-
// MARK:- Application Life cycle

extension AppDelegate  {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let dictionary = NSDictionary(object: "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forKey: "UserAgent" as NSCopying)
        UserDefaults.standard.register(defaults: dictionary as! [String : Any])

        enableLocationServices()
        
        window?.backgroundColor = .white
        
        //TODO: Firebase configuration
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //TODO: IQKeyboardManager configuration
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //TODO: Google configuration
        GMSPlacesClient.provideAPIKey(GooglePlaceAPIKey)
        GMSServices.provideAPIKey(GooglePlaceAPIKey)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       
        //TODO: Payment Gatway configuration
        STPPaymentConfiguration.shared().publishableKey = stripePublishableKey
        
        // TODO: Common Api Request
        APIRequest.shared().loadCMS { (_, _) in }
        APIRequest.shared().loadCategory { (_, _) in }
        
        if let prefs = UserDefaults(suiteName: suiteName) {
            print(prefs.object(forKey: "ShareText") as Any,"checking--11111")
        }
        //            if((appDelegate?.window?.rootViewController?.isKind(of: ReferralViewController.self)) != nil){
        //                NotificationCenter.default.post(name: Notification.Name("NotifyShare"), object: nil)
        //
        //            }else{
        
        //TODO: Root
        initWelcomeViewController()
        
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            
            if(url.absoluteString == "smarket://"){
                if let prefs = UserDefaults(suiteName: suiteName) {
                    print(prefs.object(forKey: "ShareText") as Any,"checking--22222")
                }
                //            if((appDelegate?.window?.rootViewController?.isKind(of: ReferralViewController.self)) != nil){
                //                NotificationCenter.default.post(name: Notification.Name("NotifyShare"), object: nil)
                //
                //            }else{
                if CUserDefaults.value(forKey: UserDefaultLoginUserID) != nil  {
                    if let referralVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
                        appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: referralVC)
                        referralVC.view.tag = 200
                        appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                    }
                }
                //            }
                return true
            }else{
                return GIDSignIn.sharedInstance().handle(url as URL)
            }

        }else{
             
        }
       
    
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("become")
        
        
    }
   
 
    
    // google sign in
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("open url: URL==== ",url)
        let openUrl = url
        if(url.absoluteString == "smarket://"){
            if let prefs = UserDefaults(suiteName: suiteName) {
                print("checking--")
                print(prefs.object(forKey: "ShareText") as Any)
            }
            //            if((appDelegate?.window?.rootViewController?.isKind(of: ReferralViewController.self)) != nil){
            //                NotificationCenter.default.post(name: Notification.Name("NotifyShare"), object: nil)
            //
            //            }else{
            if CUserDefaults.value(forKey: UserDefaultLoginUserID) != nil  {
                if let referralVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
                    appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: referralVC)
                    referralVC.view.tag = 200
                    appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                }
            }
            //            }
            return true
        }else{
            return GIDSignIn.sharedInstance().handle(url)
        }
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        if(url.absoluteString == "smarket://"){
            if let prefs = UserDefaults(suiteName: suiteName) {
                print(prefs.object(forKey: "ShareText") as Any,"checking-->>>>")
            }
            //            if((appDelegate?.window?.rootViewController?.isKind(of: ReferralViewController.self)) != nil){
            //                NotificationCenter.default.post(name: Notification.Name("NotifyShare"), object: nil)
            //
            //            }else{
            if CUserDefaults.value(forKey: UserDefaultLoginUserID) != nil  {
                if let referralVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
                    appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: referralVC)
                    referralVC.view.tag = 200
                    appDelegate?.sideMenuViewController?.setDrawerState(.closed, animated: true)
                }
            }
            //            }
            return true
        }else{
            return GIDSignIn.sharedInstance().handle(url as URL)
        }
    }
}


// MARK:-
// MARK:- Firebase

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func initiateFirebaseNotification() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
    }
}

// MARK:-
// MARK:- Notification Token

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("firebase registration token: \(fcmToken)")
        
        CUserDefaults.set(fcmToken, forKey: UserDefaultDeviceToken)
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("received data message: \(remoteMessage.appData)")
//    }
//
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
        if userInfo.valueForString(key: "type") == "2" {
            
            if let notificationVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                
                let rootVC = UINavigationController(rootViewController: notificationVC)
                notificationVC.view.tag = 200
                self.sideMenuViewController?.mainViewController = rootVC
            }
            self.sideMenuViewController?.setDrawerState(.closed, animated: false)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        
        let state = UIApplication.shared.applicationState
        if state == .background  || state == .inactive{
            completionHandler([.alert, .sound, .badge])
            
        }else if state == .active {
            
            let userInfo = notification.request.content.userInfo
            if let alert = userInfo["aps"] as? [String : Any], let alertdata = alert["alert"] as? [String : Any]{
                
                CTopMostViewController?.presentAlertViewWithOneButton(alertTitle: alertdata.valueForString(key: "title"), alertMessage:alertdata.valueForString(key: "body"), btnOneTitle: CBtnOk, btnOneTapped: { (UIAlertAction) in
                    
                    if userInfo.valueForString(key: "type") == "2" {
                        
                        if let notificationVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                            
                            let rootVC = UINavigationController(rootViewController: notificationVC)
                            notificationVC.view.tag = 200
                            self.sideMenuViewController?.mainViewController = rootVC
                        }
                        
                        self.sideMenuViewController?.setDrawerState(.closed, animated: false)
                        
                    } else {
                        let homeVC =  CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController")
                        let rootVC = UINavigationController(rootViewController: homeVC )
                        self.sideMenuViewController?.mainViewController = rootVC
                        self.sideMenuViewController?.setDrawerState(.closed, animated: false)
                    }
                })
            }
        }
    }
}

// MARK:-
// MARK:- Roots

extension AppDelegate {
    
    func initWelcomeViewController() {
        
        //if IS_SIMULATOR {
        //        if let userID = CUserDefaults.value(forKey: UserDefaultLoginUserID)  {
        //            loginUser = TBLUser.findOrCreate(dictionary: ["user_id":userID]) as? TBLUser
        //
        //            if loginUser?.user_type == 1 { // Customer
        //                loginUser?.latitude = ""
        //                loginUser?.longitude = ""
        //                CoreData.saveContext()
        //                signInCustomerUser(animated: false)
        //                APIRequest.shared().loadUserDetails { (response, error) in}
        //                return
        //
        //            } else if loginUser?.user_type == 2 { // Merchant
        //
        //                CoreData.saveContext()
        //                signInMerchantUser(animated: false)
        //                APIRequest.shared().loadUserDetails { (response, error) in}
        //                return
        //
        //            }
        //        }
        // }
//
        let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "TermsViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
        

        
    }
    
    // MARK:-
    // MARK:- Customer Login and Logout
    
    func initCustomerLoginViewController() {
        isCustomerLogin = true
        let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "CustomerLoginViewController"))
        
        self.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
    }
    func loginAsCustomerUser(response:AnyObject?) {
        
        let signOutBlock = {
            
            //....General Logout
            UIApplication.shared.unregisterForRemoteNotifications()
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
            GIDSignIn.sharedInstance()?.signOut()
            TBLUser.deleteAllObjects()
            
            //....Clear Image Cache
            let imageCache = SDImageCache.shared
            imageCache().clearDisk(onCompletion: nil)
            imageCache().clearMemory()
            
            
            //....
            self.sideMenuViewController = nil
            
            self.isCustomerLogin = true
            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "CustomerLoginViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
            APIRequest.shared().cancelAllApiRequest()
        }
        
        //...Signout.
        signOutBlock()
    }
    func signInCustomerUser(animated: Bool) {
        
        GIDSignIn.sharedInstance()?.signOut()
        isCustomerLogin = true
        
        initiateFirebaseNotification()
        
        //...Initial Screen
        sideMenuViewController = nil
        sideMenuViewController = KYDrawerController(drawerDirection: .left, drawerWidth: CScreenWidth*0.776)
        isLogin = true
        let rootVC = UINavigationController(rootViewController: CMainCustomer_SB.instantiateViewController(withIdentifier: "HomeCustomerViewController"))
        let leftVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CustomerLeftViewController")
        
        enableLocationServices()
        sideMenuViewController?.mainViewController = rootVC
        sideMenuViewController?.drawerViewController = leftVC
        sideMenuViewController?.containerViewMaxAlpha = 0.6
        self.setWindowRootViewController(rootVC: sideMenuViewController, animated: animated, completion: nil)
        enableLocationServices()
        
        var param = [String : Any]()
        param["device_token"] = CUserDefaults.value(forKey: UserDefaultDeviceToken)
        param["user_id"] = loginUser?.user_id
        param["device_type"] = "1" // 1 = ios
        param["type"] = "add"
        
        APIRequest.shared().addRemovePushToken(param) { (response, error) in
            print(response.debugDescription)
        }
    }
    
    func signOutCustomerUser(response:AnyObject?) {
        
        let signOutBlock = {
            //
            //            //Remembering Customer Postal Code / Mobile
            //            CUserDefaults.set(self.loginUser?.mobile, forKey: UserDefaultCustomerLoginMobile)
            //            CUserDefaults.set(self.loginUser?.country_code, forKey: UserDefaultCustomerLoginPostalCode)
            
            //....General Logout
            UIApplication.shared.unregisterForRemoteNotifications()
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
            GIDSignIn.sharedInstance()?.signOut()
            self.loginUser = nil
            TBLUser.deleteAllObjects()
            
            //....Clear Image Cache
            let imageCache = SDImageCache.shared
            imageCache().clearDisk(onCompletion: nil)
            imageCache().clearMemory()
            
            
            //....
            self.sideMenuViewController = nil
            self.isCustomerLogin = true
            
            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "CustomerLoginViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
            
            APIRequest.shared().cancelAllApiRequest()
            
        }
        if loginUser != nil {
            
            var param = [String : Any]()
            param["device_token"] = CUserDefaults.value(forKey: UserDefaultDeviceToken)
            param["user_id"] = loginUser?.user_id
            param["device_type"] = "1" // 1 = ios
            param["type"] = "remove"
            
            APIRequest.shared().addRemovePushToken(param) { (response, error) in
                //...Signout.
                signOutBlock()
            }
            
        }
    }
      
    
    // MARK:-
    // MARK:- Merchant Login and Logout
    
    func initMerchantLoginViewController() {
        isCustomerLogin = false
        let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "MerchantLoginViewController"))
       
        self.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
    }
    
    func loginAsMerchantUser(response:AnyObject?) {
        
        let signOutBlock = {
            
            //....General Logout
            UIApplication.shared.unregisterForRemoteNotifications()
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
            GIDSignIn.sharedInstance()?.signOut()
            self.loginUser = nil
            TBLUser.deleteAllObjects()
            
            //....Clear Image Cache
            let imageCache = SDImageCache.shared()
            imageCache.clearDisk(onCompletion: nil)
            imageCache.clearMemory()
            
            
            //....
            self.sideMenuViewController = nil
            self.isCustomerLogin = false
            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "MerchantLoginViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
            APIRequest.shared().cancelAllApiRequest()
        }
        if loginUser != nil {
            
            var param = [String : Any]()
            param["device_token"] = CUserDefaults.value(forKey: UserDefaultDeviceToken)
            param["user_id"] = loginUser?.user_id
            param["device_type"] = "1" // 1 = ios
            param["type"] = "remove"
            
            APIRequest.shared().addRemovePushToken(param) { (response, error) in}
            
        }
        
        //...Signout.
        signOutBlock()
    }
    
    
    
    

    
    
    func signInMerchantUser(animated: Bool) {
        GIDSignIn.sharedInstance()?.signOut()
        isCustomerLogin = false
    
        initiateFirebaseNotification()
        //...Initial Screen
        sideMenuViewController = nil
        sideMenuViewController = KYDrawerController(drawerDirection: .left, drawerWidth: CScreenWidth*0.776)
        isLogin = true
        let rootVC = UINavigationController(rootViewController: CMainMerchant_SB.instantiateViewController(withIdentifier: "RedeemCodeViewController"))
        let leftVC = CMainMerchant_SB.instantiateViewController(withIdentifier: "MerchantLeftViewController")
        
        enableLocationServices()
        sideMenuViewController?.mainViewController = rootVC
        sideMenuViewController?.drawerViewController = leftVC
        sideMenuViewController?.containerViewMaxAlpha = 0.6
       
        enableLocationServices()
        self.setWindowRootViewController(rootVC: sideMenuViewController, animated: animated, completion: nil)
        
        var param = [String : Any]()
        param["device_token"] = CUserDefaults.value(forKey: UserDefaultDeviceToken)
        param["user_id"] = loginUser?.user_id
        param["device_type"] = "1" // 1 = ios
        param["type"] = "add"
        CUserDefaults.set(loginUser?.user_id, forKey: "merID")
        
        
        APIRequest.shared().addRemovePushToken(param) { (response, error) in
            print(response.debugDescription)
        }
        
       
    }
    
    
    func signOutMerchantUser(response:AnyObject?) {
        
        let signOutBlock = {
            
            //....General Logout
            // UIApplication.shared.unregisterForRemoteNotifications()
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
            GIDSignIn.sharedInstance()?.signOut()
            
            //....Clear Image Cache
            let imageCache = SDImageCache.shared
            imageCache().clearDisk(onCompletion: nil)
            imageCache().clearMemory()
            
            
            //....
            self.sideMenuViewController = nil
            self.isCustomerLogin = false
            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "MerchantLoginViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
            
            APIRequest.shared().cancelAllApiRequest()
        }
        
        //...Signout.
        signOutBlock()
    }
    
    
    // MARK:-
    // MARK:- Root update
    
    func setWindowRootViewController(rootVC:UIViewController?, animated:Bool, completion: ((Bool) -> Void)?) {
        
        guard rootVC != nil else {
            return
        }
        
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        
        UIView.transition(with: self.window!, duration: animated ? 0.6 : 0.0, options: .transitionCrossDissolve, animations: {
            
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            
            self.window?.rootViewController = rootVC
            UIView.setAnimationsEnabled(oldState)
        }) { (finished) in
            if let handler = completion {
                handler(true)
            }
        }
    }
}

//MARK:-
//MARK:- MFMailComposer Methods and delegate

extension AppDelegate : MFMailComposeViewControllerDelegate {
    
    func openMailComposer(_ viewController : UIViewController, email : String)  {
        
        DispatchQueue.main.async {
            
            if MFMailComposeViewController.canSendMail() {
                
                let composeVC: MFMailComposeViewController = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setSubject("Contact Us")
                composeVC.setToRecipients([email])
                viewController.present(composeVC, animated: true, completion: nil)
                
            } else {
                
                viewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Your device not support mail composer", btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    
                })
            }
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK:-
//MARK:- MFMailComposer Methods and delegate

extension AppDelegate : MFMessageComposeViewControllerDelegate {
    
    func openMessageComposer(_ viewController : UIViewController, mobileNo : [String], msgBody : String, completion: (() -> Swift.Void)? = nil)  {
        
        DispatchQueue.main.async {
            
            if (MFMessageComposeViewController.canSendText()) {
                
                let controller = MFMessageComposeViewController()
                controller.body = msgBody
                controller.recipients = mobileNo
                controller.messageComposeDelegate = self
                viewController.present(controller, animated: true, completion: completion)
            } else {
                
                viewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Your device not support message composer", btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    
                })
            }
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        //... handle sms screen actions
        controller.dismiss(animated: true, completion: nil)
        
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            
        case .failed:
            print("Message failed")
            
        case .sent:
            print("Message was sent")
        }
        
    }
    
}

// MARK:-
// MARK:- Google PlacePickerViewController Delegate

extension AppDelegate : GMSPlacePickerViewControllerDelegate  {
    
    func openPlacePicker(_ viewController :UIViewController, complition : ClosurePlacePicker? )  {
        
        placePickerHandler = complition
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        placePicker.delegate = self
        
        placePicker.modalPresentationStyle = .popover
        
        viewController.navigationController?.pushViewController(placePicker, animated: true)
        placePicker.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        placePicker.navigationController?.navigationBar.isTranslucent = true
        
        if let color = viewController.navigationController?.navigationBar.barTintColor {
            
            let colors = [color.cgColor,color.cgColor,color.cgColor]
            viewController.navigationController?.setGradientBackground(colors: colors)
        }
        
    }
    
    func formattedAddress(_ place : GMSPlace, completion: CloserAddressPicker?) {
        
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
        print("Place lat long \(place.coordinate)")
        
        var info = [String : Any]()
        info["latitude"] = place.coordinate.latitude.toString
        info["longitude"] = place.coordinate.longitude.toString
        info["coordinate"] = place.coordinate
        info["fullAddress"] = place.formattedAddress
        
        if let arrAddressComponent = place.addressComponents {
            
            for (_,address) in arrAddressComponent.enumerated() {
                
                switch address.type {
                    
                case "country" : // Country
                    print(address.name)
                    info["country"] = address.name
                    
                case "administrative_area_level_1" : // State
                    print(address.name)
                    info["state"] = address.name
                    
                case "locality" : // City
                    print(address.name)
                    info["city"] = address.name
                    
                case "postal_code" : // postal code
                    print(address.name)
                    info["postalCode"] = address.name
                    
                default :
                    print(address.name)
                    info[address.type] = address.name
                }
            }
            
            
            if info.valueForString(key: "city").isBlank {
                
                if info.valueForString(key: "administrative_area_level_2").isBlank {
                    
                    if info.valueForString(key: "state").isBlank {
                        
                        reverseGeocodeLocation(info, coordinate: place.coordinate, completion: completion)
                    }else {
                        
                        let address = info.valueForString(key: "state") + ", " + info.valueForString(key: "country")
                        info["address"] = address
                        info["city"] = info.valueForString(key: "state")
                        
                        if let handler = completion {
                            handler(info)
                        }
                    }
                    
                } else {
                    
                    let address = info.valueForString(key: "locality") + ", " + info.valueForString(key: "country")
                    info["address"] = address
                    
                    if let handler = completion {
                        handler(info)
                    }
                }
                
            }else {
                
                let address = info.valueForString(key: "city") + ", " + info.valueForString(key: "country")
                info["address"] = address
                
                if let handler = completion {
                    handler(info)
                }
            }
            
        } else {
            
            reverseGeocodeLocation(info, coordinate: place.coordinate, completion: completion)
        }
        
        
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.navigationController?.popViewController(animated: true)
        viewController.dismiss(animated: true, completion: nil)
        
        if placePickerHandler != nil {
            placePickerHandler!(place)
        }
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
        if placePickerHandler != nil {
            placePickerHandler!(nil)
        }
    }
    
    func reverseGeocodeLocation(_ data : [String : Any]?, coordinate : CLLocationCoordinate2D, completion: CloserAddressPicker? )  {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if let country = placemarks?.first?.country {
                var address = ""
                var city = ""
                
                if let locality = placemarks?.first?.locality {
                    
                    address = locality + ", " + country
                    city = locality
                    
                } else {
                    address = country
                }
                
                if var info = data {
                    info["address"] = address
                    info["city"] = city
                    info["country"] = country
                    info["postalCode"] = placemarks?.first?.postalCode
                    
                    if let handler = completion  {
                        handler(info)
                    }
                    
                } else {
                    
                    var info = [String : Any]()
                    info["address"] = address
                    info["city"] = city
                    info["country"] = country
                    info["postalCode"] = placemarks?.first?.postalCode
                    
                    if let handler = completion  {
                        handler(info)
                    }
                }
            }else {
                if let handler = completion  {
                    handler(nil)
                }
            }
            
        })
    }
}

// MARK:-
// MARK:- Location manager Delegate

extension AppDelegate : CLLocationManagerDelegate {
    
    func enableLocationServices()  {
        
        if self.locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager?.delegate = self
        }
        
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager?.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            // Disable location features
            CTopMostViewController?.presentAlertViewWithTwoButtons(alertTitle: "Please allow access of your location to search merchant near by you", alertMessage:"" , btnOneTitle: CBtnOpenSettings, btnOneTapped: { (action) in
                
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    // If general location settings are enabled then open location settings for the app
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if self.locationAuthChange != nil {
                            self.locationAuthChange!(CLLocationManager.authorizationStatus(), self.locationManager?.location)
                        }
                    })
                }
            }, btnTwoTitle: CBtnCancel, btnTwoTapped: { (action) in
                if self.locationAuthChange != nil {
                    self.locationAuthChange!(CLLocationManager.authorizationStatus(), self.locationManager?.location)
                }
            })
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            locationManager?.startUpdatingLocation()
            
        case .authorizedAlways:
            // Enable any of your app's location features
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .restricted, .denied:
            // Disable your app's location features
            if self.loginUser != nil, self.loginUser?.user_type == 1 {
                self.loginUser?.latitude = ""
                self.loginUser?.longitude = ""
                self.loginUser?.post_code = ""
                
                CoreData.saveContext()
            }
            if self.locationAuthChange != nil {
                self.locationAuthChange!(CLLocationManager.authorizationStatus(), self.locationManager?.location)
            }
            break
            
        case .authorizedWhenInUse:
            // Enable only your app's when-in-use features.
            locationManager?.startUpdatingLocation()
            
        case .authorizedAlways:
            // Enable any of your app's location services.
            break
            
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if self.locationAuthChange != nil {
            self.locationAuthChange!(CLLocationManager.authorizationStatus(), nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = "\(locValue.latitude)"
        let longitude = "\(locValue.longitude)"
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = latitude
        self.long = longitude
        if self.loginUser != nil, self.loginUser?.user_type == 1 {
            self.loginUser?.latitude = latitude
            self.loginUser?.longitude = longitude
            self.reverseGeocodeLocation(nil, coordinate: locValue) { (info) in
                
                if let info = info {
                    self.loginUser?.post_code = info.valueForString(key: "postalCode")
                    CUserDefaults.set(info.valueForString(key: "country"), forKey: UserDefaultCountry)
                    
                }
                if self.locationAuthChange != nil {
                    self.locationAuthChange!(CLLocationManager.authorizationStatus(), manager.location)
                }
            }
            CoreData.saveContext()
        }else{
            self.reverseGeocodeLocation(nil, coordinate: locValue) { (info) in
                if let info = info {
                    CUserDefaults.set(info.valueForString(key: "country"), forKey: UserDefaultCountry)
                }
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func enableLocationService(_ complition :locationAuthorizationChange? ) {
        self.locationAuthChange = complition
        self.enableLocationServices()
    }
}

