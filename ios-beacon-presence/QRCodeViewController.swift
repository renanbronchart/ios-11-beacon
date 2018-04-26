//
//  QRCodeViewController.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 26/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import CoreLocation

class QRCodeViewController: UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "USERLOGGEDIN")
        self.navigationController?.popToRootViewController(animated: true)
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
    
}
