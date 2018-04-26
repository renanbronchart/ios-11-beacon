//
//  ViewController.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 26/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if UserDefaults.standard.bool(forKey: "USERLOGGEDIN") == true {
            print("is already connected")
            // user is already logged so navigate to home qr code
            if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRCodeViewController {
                
                
                self.navigationController?.pushViewController(view_qr_code, animated: false)
            }
        } else {
            print("is not  connected")
        }
        
    }
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func logIn(_ sender: Any) {
        if (emailField?.text == "test" && passwordField?.text == "test") {
            UserDefaults.standard.set(true, forKey: "USERLOGGEDIN")
            if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRCodeViewController {
                
                
                self.navigationController?.pushViewController(view_qr_code, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

