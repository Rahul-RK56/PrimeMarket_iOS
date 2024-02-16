//
//  RedeemCodeViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 12/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import AVFoundation

var emailId = ""

class RedeemCodeViewController: ParentViewController {
    
    @IBOutlet weak var txtCode:UITextField!
    @IBOutlet weak var vwScanView:UIView!
    @IBOutlet weak var vwScanToggle:UIView!

    @IBOutlet weak var vwOfferDetail:UIView!
    @IBOutlet weak var vwOfferDetailContent:UIView!
  
    @IBOutlet weak var lblOfferType:UILabel!
    @IBOutlet weak var lblOfferValue:UILabel!
    @IBOutlet weak var lblExpireDate:UILabel!
    @IBOutlet weak var lblRefrrelsCount: UILabel!
    @IBOutlet weak var lblTotalRefCase: UILabel!
    @IBOutlet weak var lblCondition:UILabel!
    @IBOutlet weak var lblConditionTitle:UILabel!
    @IBOutlet weak var lblCurrentCashBackOffer: UILabel!
    
    @IBOutlet var vwScanToggleCenterY:NSLayoutConstraint!
    
    
    @IBOutlet var claimAmountView: UIView!
    
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var gotomerchant: UIButton!
    
    
    var customerId = ""
    var qrcode = ""
    var offer : Offer?
    var arrOffer : [Offer]?
    var isStopScanAnimation = false
    var isverified = false
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var percentage = ""
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        initialize()
        self.title = appDelegate?.loginUser?.name
        var emaillId = appDelegate?.loginUser?.email
        emailId = emaillId ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
            isStopScanAnimation = false
            self.startAnimation()
        }
        createListCashBackFromServer()
        
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK:-
    // MARK:- GENERAL METHODS
    
    
    
    fileprivate func loginWithUserInfo() {
        
        let param = ["email": emailId]
        
        APIRequest.shared().loginWithNormal(param) { (response, error) in
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                
                if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                    
                    switch meta.valueForInt(key: CJsonStatus) {
                        
                    case CStatusZero:
                        
                        if let data = json[CJsonData] as? [String : Any] {
                            CUserDefaults.setValue(data.valueForString(key: "id"), forKey: UserDefaultLoginMerchantID)
                        }
                        
                        CUserDefaults.setValue(meta.valueForString(key: "token"), forKey: UserDefaultLoginUserToken)
                        CUserDefaults.synchronize()
                        self.isverified = true
                        if let verifyEmailVC = CLRF_SB.instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController {
                            verifyEmailVC.iObject = param
                            verifyEmailVC.fromVC = "LOGIN"
                            verifyEmailVC.isFromHomePage = true
                            //                            self.present(UINavigationController(rootViewController: verifyEmailVC), animated: true, completion: nil)
                            self.navigationController?.pushViewController(verifyEmailVC, animated: true)
                        }
                        
                    case CStatusFour:
                        
                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: meta.valueForString(key: "message"), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            
                        }, btnTwoTitle: "Verify Now", btnTwoTapped: { (action) in
                            //                            self.resendOTPEmail()
                        })
                        
                    default:
                        self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                        
                        print("Rahul", CJsonMessage)
                    }
                    
                }
            }
        }
    }
    fileprivate func initialize()  {
        
//        self.title = "REDEEM CODE"
        
        vwOfferDetailContent.layer.cornerRadius = 5
        vwOfferDetailContent.layer.masksToBounds = true
        vwOfferDetail.bounds = view.bounds
        captureConfiguration()
        
        if let merchantId = self.iObject as? String {
            print(merchantId)
        }
    }
    
    
    @IBAction func amountCancelBtnTapped(_ sender: Any) {
        
        self.dismissPopUp(view: claimAmountView) {
            if (self.captureSession?.isRunning == false) {
                self.captureSession.startRunning()
                self.isStopScanAnimation = false
                self.startAnimation()
            }
        }
    }
    
    
    @IBAction func amountConfirmBtnTapped(_ sender: Any) {
        
        let cash = amountTF.text
        if (cash == ""){
            print("please enter amount")
        }else{
            self.dismissPopUp(view: claimAmountView) {
                
                self.createClaimcashBackOffer()
            }
        }
       
    }
    // MARK:-
    // MARK:- ACTION EVENT
    
    
    @IBAction func goToMerchantPage(_ sender: Any) {
        
        loginWithUserInfo()
    }
    
    
    
    @IBAction fileprivate func btnSubmitClicked(_ sender:UIButton) {
        
        self.resignKeyboard()
        self.qrcode =  txtCode.text!
        if !(txtCode.text?.isBlank)!{
            self.presentPopUp(view: claimAmountView, shouldOutSideClick: true, type: .center, completionHandler: {
               // self.qrcode = json.valueForString(key: "value")
                self.lblCurrentCashBackOffer.text = "Your current cashback offer " + self.percentage + "%"
            })
        }
       
        
//        if !(txtCode.text?.isBlank)! {
//
//            scanOfferDetails(txtCode.text!)
//        }
        
       
    }
    @IBAction fileprivate func btnConfirmClicked(_ sender:UIButton) {
        
        self.dismissPopUp(view: vwOfferDetail) {
            
            self.redeeemOffer()
        }
    }
    
    @IBAction fileprivate func btnCancelClicked(_ sender:UIButton) {
        
        self.dismissPopUp(view: vwOfferDetail) {
            if (self.captureSession?.isRunning == false) {
                self.captureSession.startRunning()
                self.isStopScanAnimation = false
                self.startAnimation()
            }
        }
    }
    
    
    
    fileprivate func createClaimcashBackOffer(){
         
         var param = [String : Any]()
         
        
            param["offer_amount"] = amountTF.text
            
        param["qr_code"] =  self.qrcode
        param["customer_id"] = self.customerId
          // param["customer_id"] = CUserDefaults.value(forKey: UserDefaultCustID)
     //   param["merchant_id"] = CUserDefaults.value(forKey: UserDefaultLoginMerchantID)
        
//        CUserDefaults.set(data.valueForString(key: "merchant_id"), forKey: "MerchantId")
//        CUserDefaults.set(data.valueForString(key: "login_mail"), forKey: "LoginMail")
        
        param["login_id"] = CUserDefaults.value(forKey: "LoginID")
        param["login_user"] =  CUserDefaults.value(forKey: "LoginUser")
        param["login_type"] = CUserDefaults.value(forKey: "LoginType")
        param["user_type"] = CUserDefaults.value(forKey: "UserType")
        param["merchant_id"] = CUserDefaults.value(forKey: "MerchantId")
        param["login_mail"] = CUserDefaults.value(forKey: "LoginMail")
        
        
        print(param, "params")
        APIRequest.shared().claimCashBack(param, completion:  { (response, error) in
          
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let json = response as? [String : Any] {
                        
                        let strSucc = json["status"] as? String ?? ""
                        let strMessage = json["message"] as? String ?? ""
                        
                        if strSucc == "success" {
                            let alert = UIAlertController(title: "Success", message: "Store credit of \(self.amountTF.text ?? "") Rs is addded successfully", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            //MIToastAlert.shared.showToastAlert(position: .bottom, message: strMessage)
                        }
//                         print(meta.valueForString(key: CJsonMessage))
//                             print(data.valueForString(key: "message"))
//
//                             let alert = UIAlertController(title: "Success", message: "Your Cashback Added to Store Credit", preferredStyle: UIAlertControllerStyle.alert)
//                             alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//                             self.present(alert, animated: true, completion: nil)
//                             MIToastAlert.shared.showToastAlert(position: .bottom, message: data.valueForString(key: "message"))
                    }
                }
            })
     }
     
}
// MARK:-
// MARK:- Server request
extension RedeemCodeViewController {
    
    fileprivate func scanOfferDetails(_ code :String) {
        
        APIRequest.shared().scanOffer(["code":code]) { (response, error) in
            
            if APIRequest.shared().isJSONDataValid(withResponse: response) {
                
                if let dict = response as? [String : Any], let data = dict[CJsonData] as? [String : Any],let meta = dict[CJsonMeta] as? [String : Any] {
                    self.lblTotalRefCase.text = "Total RefCash  : \(meta.valueForString(key: "refcash"))"
                    self.showOfferDetails(data)
                }
            }
        }
    }
    
    fileprivate func redeeemOffer() {
        
        if let id = offer?.id {
            
           
            
            CUserDefaults.value(forKey: UserDefaultCustID)
            
            var param = [String : Any]()
            param["id"] = id
            param["login_id"] = CUserDefaults.value(forKey: "LoginID")
            param["login_user"] =  CUserDefaults.value(forKey: "LoginUser")
            param["login_type"] = CUserDefaults.value(forKey: "LoginType")
            param["user_type"] = CUserDefaults.value(forKey: "UserType")
            
            APIRequest.shared().redeemOffer(["id" : id]) { (response, error) in
                
                if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                    
                    if let dict = response as? [String : Any], let meta = dict[CJsonMeta] as? [String : Any] {
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meta.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            appDelegate?.loginUser?.refcash = meta.valueForString(key: "refcash")
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                } else {
                    
                    if let dict = response as? [String : Any], let meta = dict[CJsonMeta] as? [String : Any] {
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meta.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            
                            // Start video capture.
                            self.captureSession.startRunning()
                            self.isStopScanAnimation = false
                            self.startAnimation()
                        })
                        
                    }else {
                        
                        self.showAlertView(CMessageNoInternet, completion: { (action) in
                            // Start video capture.
                            self.captureSession.startRunning()
                            self.isStopScanAnimation = false
                            self.startAnimation()
                        })
                    }
                }
            }
        }
    }
}

// MARK:-
// MARK:- Helper METHODS
extension RedeemCodeViewController {
    
    fileprivate func captureConfiguration() {
        captureSession = AVCaptureSession()
        
        var videoCaptureDevice : AVCaptureDevice!
        
        // Get the back-facing camera for capturing videos
        if #available(iOS 10.0, *) {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return
            }
            videoCaptureDevice = captureDevice
            
        } else { // Fallback on earlier versions
            
            // Get the back-facing camera for capturing videos
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
            videoCaptureDevice = captureDevice
        }
        
        
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            // Set the input device on the capture session.`
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                
                failed()
                return
            }
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                // Set delegate and use the default dispatch queue to execute the call back
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = supportedCodeTypes
            } else {
                // If any error occurs, simply print it out and don't continue any more.
                failed()
                return
            }
            
        } catch {
            
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.previewLayer.frame = self.vwScanView.layer.bounds
            self.vwScanView.layer.addSublayer(self.previewLayer)
            self.startAnimation()
        }
        
        
        // Start video capture.
        captureSession.startRunning()
    }
    
   fileprivate  func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    fileprivate func found(code: String) {
        
        print(code, "qrCode----")
        
        do {
            if let data = code.data(using: .utf8) {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("\n\nReceive Json :-\n\n\(json)")
                
                if let json = json as? [String : Any], json.valueForString(key: "app") == QRUNIQCODE {
                    scanOfferDetails(json.valueForString(key: "value"))
                    
                }else if let json = json as? [String : Any], json.valueForString(key: "app") == "CASHBACK" {
                    self.presentPopUp(view: claimAmountView, shouldOutSideClick: true, type: .center, completionHandler: {
                        self.qrcode = json.valueForString(key: "value")
                        self.customerId = json.valueForString(key: "customer_id")
                        self.lblCurrentCashBackOffer.text = "Your current cashback offer " + self.percentage + "%"
                    })
                } else {
                    inValidQRCodePopup()
                }
            }else {
                inValidQRCodePopup()
            }
            
        } catch {
            inValidQRCodePopup()
        }
    }
    
    
    fileprivate func startAnimation() {
        
        if isStopScanAnimation {
            return
        }
        
        if vwScanToggleCenterY.constant == 0 { // CenterY to Top
            
            UIView.animate(withDuration: 1.0, animations: {
                self.vwScanToggleCenterY.constant = -(self.vwScanView.CViewHeight/2)
                self.view.layoutIfNeeded()
            }) { (completion) in
                self.startAnimation()
            }
        } else if self.vwScanToggleCenterY.constant == -(self.vwScanView.CViewHeight/2) { // Top to Bottom
            
            UIView.animate(withDuration: 1.0, animations: {
                self.vwScanToggleCenterY.constant = (self.vwScanView.CViewHeight/2)
                self.view.layoutIfNeeded()
            }) { (completion) in
                self.startAnimation()
            }
        }  else if self.vwScanToggleCenterY.constant == (self.vwScanView.CViewHeight/2) { // Bottom to Top
            
            UIView.animate(withDuration: 1.0, animations: {
                self.vwScanToggleCenterY.constant = -(self.vwScanView.CViewHeight/2)
                self.view.layoutIfNeeded()
            }) { (completion) in
                self.startAnimation()
            }
        }
    }
    
    fileprivate func stopAnimation() {
        isStopScanAnimation = true
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
    
    fileprivate func inValidQRCodePopup() {
        
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage:  CMessageInValidQRCode, btnOneTitle: CBtnOk) { (action) in
            
            // Start video capture.
            self.captureSession.startRunning()
            self.isStopScanAnimation = false
            self.startAnimation()
        }
    }
    
    fileprivate func showOfferDetails(_ data : [String : Any]) {
        
        offer = Offer(object: data)
        lblOfferType.text = offer?.offerTitle
        print("offer percentage",offer?.offer_percentage)
        
        if let expireDate = offer?.expiryDate?.dateFromString , expireDate != "" {
            lblExpireDate.text = "Expires on: \(expireDate)"
        }
        
        if let offer = offer , (offer.offerType != nil) {
            lblTotalRefCase.isHidden = false
            if let subOffer = offer.subOffer?.first {
                
                lblOfferValue.text = subOffer.title
                lblCondition.text = subOffer.conditions
                lblConditionTitle.text = lblCondition.text!.isBlank ? "" : "Condition"
                if subOffer.subOfferType == .Referral {
                    lblRefrrelsCount.text = "Referral will be sent to : \(offer.referral_count ?? "0") people"
                }
            }else{
                lblOfferType.text = "Offer Details"
                lblOfferValue.text = ""
                lblConditionTitle.text = ""
                lblCondition.text = offer.message
            }
            
        } else {
            lblOfferType.text = "Store Credit"
            lblOfferValue.text = data.valueForString(key: CJsonMessage)
            lblExpireDate.hide(byHeight: true)
            lblConditionTitle.hide(byHeight: true)
            lblCondition.hide(byHeight: true)
            lblTotalRefCase.hide(byHeight: true)
        }
        self.presentPopUp(view: self.vwOfferDetail, shouldOutSideClick: false, type: .center) {
            
        }
    }
}



extension RedeemCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        stopAnimation()
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            if supportedCodeTypes.contains(readableObject.type) {
                // If the found metadata is equal to the QR code metadata (or barcode)
                guard let stringValue = readableObject.stringValue else {
                    inValidQRCodePopup()
                    return
                }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
                isStopScanAnimation = true
            } else {
                inValidQRCodePopup()
            }
            
        }
        
    }
    
}
extension RedeemCodeViewController  {
    
    fileprivate  func createListCashBackFromServer(){
        
        APIRequest.shared().listCashBack(completion: { (response, error) in
            
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]]{
                    
                    print(data)
                    self.arrOffer = []
                    for item in data {
                        self.arrOffer?.append(Offer(object: item))
                    }
                   // self.tableView.reloadData()
                    print(self.arrOffer)
                    let data = self.arrOffer?[0]
                    self.percentage = "\(data?.offer_percentage ?? 0)"
                    print(self.percentage, "offer percentage")
                    //MIToastAlert.shared.showToastAlert(position: .bottom, message: data.valueForString(key: CJsonMessage))
                }
            }
           
        })
        
    }

}
