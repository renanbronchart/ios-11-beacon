//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//


//
// Inspiration source:
// https://stackoverflow.com/questions/48576959/qr-code-scanner-wont-work-in-swift-4
// Thanks : Ganesh Manickam *867*
//

import UIKit
import AVFoundation
import CoreLocation

class QRViewController: UIViewController, CLLocationManagerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    let manager = CLLocationManager()
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "F2A74FC4-7625-44DB-9B08-CB7E130B2029")!, identifier: "beacon-hetic")
    var beaconsFound = [""]
    var task: URLSessionTask?
    var firstTime = true
    var QRString: String?
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var labelClassroom: UILabel!
    @IBOutlet weak var logoutButton: DangerButton!
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "USERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func requestCode(success: Bool) {
        if let response_view = self.storyboard?.instantiateViewController(withIdentifier: "responseView") as? ResponseViewController {
            response_view.success = false
            self.navigationController?.pushViewController(response_view, animated: true)
        }
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        requestCode(success: true)
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        initGradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        } else {
            startRanging()
        }

        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        
        view.layer.addSublayer(videoPreviewLayer!)
        
        // à voir...
        view.bringSubview(toFront: labelClassroom)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
            view.bringSubview(toFront: logoutButton)
        }
    }
    
//
//    "QRCodeData" : "OK",
//    "date": "",
//    "beaconCollection":
//    [
//    12,
//    44,
//    128
//    ]
//    },
//    "Token": "1234567890123456789012345678901234567890"
    
    func requestUrl () {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let session = URLSession.shared
        let u = URL(string: "\(Constants.BASE_URL)api/login")
        var request = URLRequest(url: u!)
        var success = false
        
        request.httpMethod = "POST"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        
        let dateString = Formatter.iso8601.string(from: Date())
        let date = Formatter.iso8601.date(from: dateString)
        print(beaconsFound)
    
        request.httpBody = "QRCodeData=\(QRString ?? "")&Date=\(date)&beaconCollection=[\(beaconsFound ?? [])]&Token=\(appDelegate?.token ?? "")".data(using: .utf8)
    
    let task = session.dataTask(with: request) {
        (data, response, error) in
        if let d = data {
            if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
                if (o["response"] != nil) {
                    success = o["response"]! == "OK"
                    DispatchQueue.main.async { [unowned self] in
                        self.requestCode(success: success)
                        print("ça marche")
                    }
                } else {
                    print("ça marche pas")
                    return
                }
            }
        }
    }
    
    task.resume()
    }
    
    fileprivate func startRanging () {
//        let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "F2A74FC4-7625-44DB-9B08-CB7E130B2029")!, major: 65535, minor: 382, identifier: "premier")
        manager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(region.identifier)
        print(beacons)
        
        beaconsFound = []
        
        for b in beacons {
            beaconsFound.append("\(b.minor)\(b.major)")

            print(b.minor)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startRanging()
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //            messageLabel.text = "No QR code is detected"
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if (metadataObj.stringValue != nil && firstTime == true) {
                firstTime = false
                
                print(metadataObj.stringValue)
                QRString = metadataObj.stringValue
                manager.stopRangingBeacons(in: beaconRegion)
                requestUrl()
                firstTime = false
                captureSession.stopRunning()
                print("_______________________________________________________________")
                //                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
