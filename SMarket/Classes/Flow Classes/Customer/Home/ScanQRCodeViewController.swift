//
//  ScanQRCodeViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 10/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: ParentViewController {
    
    @IBOutlet weak var vwScanView:UIView!
    @IBOutlet weak var vwScanToggle:UIView!
    
    @IBOutlet var vwScanToggleCenterY:NSLayoutConstraint!
    var isStopScanAnimation = false
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
            isStopScanAnimation = false
            self.startAnimation()
        }
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
    fileprivate func initialize()  {
        
        self.title = "SCANQR CODE"
        
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
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func found(code: String) {
        print(code)
        if code.contains("http"){
            let arrayCode = code.components(separatedBy: "/")
            if let detailVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as? MerchantDetailsViewController {
                if arrayCode.count == 6{
                    detailVC.iObject = arrayCode[4]
                }else if arrayCode.count == 7{
                    detailVC.iObject = arrayCode[5]
                }
               
                print(arrayCode[5] ,"merchantId")
                print(arrayCode.count ,"merchantIdCount")
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            return
        }
        
        do {
            if let data = code.data(using: .utf8) {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("\n\nReceive Json :-\n\n\(json)")
                
                if let json = json as? [String : Any], json.valueForString(key: "app") == QRUNIQCODE {
                    if let detailVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as? MerchantDetailsViewController {
                        detailVC.iObject = json.valueForString(key: "merchant_id")
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }else {
                    inValidQRCodePopup()
                }
            }else {
                inValidQRCodePopup()
            }
            
        } catch {
            inValidQRCodePopup()
        }
    }
    
    
    func startAnimation() {
        
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
    
    func stopAnimation() {
        isStopScanAnimation = true
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
}


extension ScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
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
// MARK:-
// MARK:- Helper METHODS
extension ScanQRCodeViewController {
    
    fileprivate func inValidQRCodePopup() {
        
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage:  CMessageInValidQRCode, btnOneTitle: CBtnOk) { (action) in
            
            // Start video capture.
            self.captureSession.startRunning()
            self.isStopScanAnimation = false
            self.startAnimation()
        }
    }
}
