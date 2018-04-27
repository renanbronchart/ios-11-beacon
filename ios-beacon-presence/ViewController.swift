//
//  ViewController.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 26/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    var animator:UIDynamicAnimator?
    var snap: UISnapBehavior!
    var snapEmail: UISnapBehavior!
    var snapPassword: UISnapBehavior!
    var snapButton: UISnapBehavior!
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    var titleOriginX: CGFloat?
    var titleOriginY: CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        initGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animator = UIDynamicAnimator(referenceView: view)
        self.snap = UISnapBehavior(item: titleLabel, snapTo: CGPoint(x: view.center.x, y: (view.center.y - (view.frame.height / 2) + 150)))
        self.snapEmail = UISnapBehavior(item: emailField, snapTo: CGPoint(x: view.center.x, y: (view.center.y - (view.frame.height / 2) + 270)))
        self.snapPassword = UISnapBehavior(item: passwordField, snapTo: CGPoint(x: view.center.x, y: (view.center.y - (view.frame.height / 2) + 350)))
        self.snapButton = UISnapBehavior(item: buttonLabel, snapTo: CGPoint(x: view.center.x, y: (view.center.y - (view.frame.height / 2) + 480)))
        self.animator?.addBehavior(self.snap)
        self.animator?.addBehavior(self.snapEmail)
        self.animator?.addBehavior(self.snapPassword)
        self.animator?.addBehavior(self.snapButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let frmTitleLabel: CGRect = titleLabel.frame
        titleOriginX = frmTitleLabel.origin.x
        titleOriginY = frmTitleLabel.origin.y

        if UserDefaults.standard.bool(forKey: "USERLOGGEDIN") == true {
            print("is already connected")
            // user is already logged so navigate to home qr code
            if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRViewController {
                
                
                self.navigationController?.pushViewController(view_qr_code, animated: false)
            }
        } else {
            print("is not  connected")
        }
        
    }
    
    func deplaceLabel () {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
        animator?.addBehavior(gravity)
        
        gravity.addItem(titleLabel)
        
        gravity.addItem(passwordField)
        
        
        //adding the collision behavior
        
        collider.addItem(titleLabel)
        collider.addItem(emailField)
        collider.addItem(passwordField)
        collider.addItem(buttonLabel)
        
//        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
    }


    
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
            if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRViewController {
                deplaceLabel()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.emailField?.text = ""
                    self.passwordField?.text = ""
                    
                    self.navigationController?.pushViewController(view_qr_code, animated: true)
                })
            }
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animator?.removeAllBehaviors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

