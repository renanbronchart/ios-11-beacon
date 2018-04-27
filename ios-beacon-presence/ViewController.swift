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
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let session = URLSession.shared
//        let u = URL(string: "0.0.0.0://api/login")
//        var request = URLRequest(url: u!)
//
//        request.httpMethod = "POST"
//        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
//        request.httpBody = "{\"Email\": \"\(emailField.text ?? "")\", \"Password\": \"\(passwordField.text ?? "")\"}".data(using: .utf8)
//
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            if let d = data {
//                print(String(data: d, encoding: .utf8))
//                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
//                    // print(o["test"])
//                    print(o["token"])
//                    if (o["token"] != nil) {
//                        appDelegate?.token = o["token"]!
//                    } else {
//                        return
//                    }
//
//                    let dataOut = try? JSONSerialization.data(withJSONObject: o, options: .prettyPrinted)
//
//                    print(dataOut)
//
//                    if let token {
//                        UserDefaults.standard.set(true, forKey: token)
//                        if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRCodeViewController {
//
//                            self.emailField?.text = ""
//                            self.passwordField?.text = ""
//                            self.navigationController?.pushViewController(view_qr_code, animated: true)
//                        }
//                    }
//                }
//            }
//        }
//
//        task.resume()
        
        // À supprimer ensuite
        if (emailField?.text == "test" && passwordField?.text == "test") {
            UserDefaults.standard.set(true, forKey: "USERLOGGEDIN")
            if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRCodeViewController {
                
                emailField?.text = ""
                passwordField?.text = ""
                self.navigationController?.pushViewController(view_qr_code, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

