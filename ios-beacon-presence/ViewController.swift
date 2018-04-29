//
//  ViewController.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 26/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    // Declare behaviors
    var animator:UIDynamicAnimator?
    var snap: UISnapBehavior!
    var snapEmail: UISnapBehavior!
    var snapPassword: UISnapBehavior!
    var snapButton: UISnapBehavior!
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()

    func deplaceLabel () {
        // reference view controller for animation
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Add vector on gravity
        gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
        
        // Add gravity behavior on animation view controller
        gravity.addItem(titleLabel)
        gravity.addItem(passwordField)
        
        // adding the collision behavior on multi items
        collider.addItem(titleLabel)
        collider.addItem(emailField)
        collider.addItem(passwordField)
        collider.addItem(buttonLabel)
        
        // Add collision and gravity behavior on animation view controller
        animator?.addBehavior(collider)
        animator?.addBehavior(gravity)
    }
    
    
    /////////////
    /////////////
    // if login API doesn't work, hidden request code and hide comments on DEV Mode
    /////////////
    /////////////
    @IBAction func logIn(_ sender: Any) {
        let session = URLSession.shared
        let u = URL(string: "\(Constants.BASE_URL)api/login")
        var request = URLRequest(url: u!)
        
        // Add waiting message
        DispatchQueue.main.async {
            self.titleLabel.text = "Connexion..."
        }
        
        let email = emailField.text ?? ""
        let hashedPass = passwordField.text?.sha512() ?? ""
        
        // Add post method
        request.httpMethod = "POST"
        // Allow gzip compression
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        // Add body for login request with hashed pass with sha512
        request.httpBody = "Email=\(email)&Password=\(hashedPass)".data(using: .utf8)

        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let d = data {
                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
                    if (o["token"] != nil) {
                        // Add User defaults to registry app login
                        UserDefaults.standard.set(true, forKey: "USERLOGGEDIN")
                        if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRViewController {
                            // Add animation on label and text field
                            self.deplaceLabel()

                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                // Navigate to next view
                                self.navigationController?.pushViewController(view_qr_code, animated: true)
                            })
                        }

                        self.saveResultToAppDelegate(token: o["token"]!)
                    } else {
                        // Add message error
                        DispatchQueue.main.async {
                            print(error ?? "No errors")
                            self.titleLabel.text = "Veuillez réessayer..."
                        }
                        return
                    }
                }
            } else {
                // Add message error
                DispatchQueue.main.async {
                    print(error ?? "No errors")
                    self.titleLabel.text = "Veuillez réessayer..."
                }

            }
        }

        task.resume()

//        ////////// DEV MODE To bypass login API //////////
//        if (emailField?.text == "test" && passwordField?.text == "test") {
//            UserDefaults.standard.set(true, forKey: "USERLOGGEDIN")
//            if let view_qr_code = self.storyboard?.instantiateViewController(withIdentifier: "QRView") as? QRViewController {
//                deplaceLabel()
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
//                    self.emailField?.text = ""
//                    self.passwordField?.text = ""
//
//                    self.navigationController?.pushViewController(view_qr_code, animated: true)
//                })
//            }
//        }
//        ////////// DEV MODE To bypass login API //////////
    }

    func saveResultToAppDelegate(token: String!) {
        let session = URLSession.shared
        let u = URL(string: "\(Constants.BASE_URL)api/getLocation")
        var request = URLRequest(url: u!)

        request.httpMethod = "GET"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "Token=\(token)".data(using: .utf8)

        session.dataTask(with: request) {
            (data, response, error) in
            if let d = data {
                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
                    print(o["location"] ?? "No location found !")

                    DispatchQueue.main.async {
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.token = token!
                        appDelegate?.location = o["location"] ?? ""
                        appDelegate?.date = o["date"] ?? ""
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // If login user defaults is true, push to home view.
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

    override func viewWillAppear(_ animated: Bool) {
        // init gradient to view controller
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
    
    override func viewWillDisappear(_ animated: Bool) {
        animator?.removeAllBehaviors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

