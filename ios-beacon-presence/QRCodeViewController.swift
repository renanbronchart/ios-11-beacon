//
//  QRCodeViewController.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 26/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class QRCodeViewController: UIViewController, CLLocationManagerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    let manager = CLLocationManager()
    var beaconsFound : Array<Any>?
    var task: URLSessionTask?
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false
    
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var qrLabel: UILabel!
    
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "USERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func scannCode(_ sender: Any) {
        requestUrl()
        
        if let response_view = self.storyboard?.instantiateViewController(withIdentifier: "responseView") as? ResponseViewController {
            response_view.success = false
            self.navigationController?.pushViewController(response_view, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        } else {
            startRanging()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("KO : Pas de caméra.")
            return
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(deviceInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            view.bringSubview(toFront: qrLabel)
        } catch {
            print(error)
            return
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if metadataObjects.count == 0 {
                scanView?.frame = CGRect.zero
                qrLabel.text = "Pas de QR code"
                return
            }
            
            // Get the metadata object.
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                scanView?.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    qrLabel.text = metadataObj.stringValue
                }
            }
        }
        
    }
    
    func requestUrl () {
        let session = URLSession.shared
        let u = URL(string: "http://www.perdu.com")
        var request = URLRequest(url: u!)
        request.httpMethod = "GET"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "{\"Hello\" : \"Hello\"}".data(using: .utf8)
        
        task = session.dataTask(with: request) {
            (data, response, error) in
            if let d = data {
                print(String(data: d, encoding: .utf8))
                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
                    // print(o["test"])
                    print(o)
                    
                    let dataOut = try? JSONSerialization.data(withJSONObject: o, options: .prettyPrinted)
                    
                    // faire ici la requete avec entete de qr code + les beacons,
                    // envoyer la reponse et changer selon le resultat la valeur de response_view.success.
                    print("_________________________________________________________")
                    print(dataOut)
                    print("_________________________________________________________")
                }
            }
            
            print("merde")
            print(response ?? "")
            print("__________________--------------")
            print(error ?? "")
        }
        
        task?.resume()
    }
    

    
    fileprivate func startRanging () {
        let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "F2A74FC4-7625-44DB-9B08-CB7E130B2029")!, major: 65535, minor: 382, identifier: "premier")
        
        manager.startRangingBeacons(in: beaconRegion)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(region.identifier)
        print(beacons)
        
        beaconsFound = beacons
        
        for b in beacons {
            print(b.minor)
            print(b.accuracy)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startRanging()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // task?.cancel()
    }
    
}
