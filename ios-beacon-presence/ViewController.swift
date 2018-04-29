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
    
    var animator:UIDynamicAnimator?
    var snap: UISnapBehavior!
    var snapEmail: UISnapBehavior!
    var snapPassword: UISnapBehavior!
    var snapButton: UISnapBehavior!
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    var titleOriginX: CGFloat?
    var titleOriginY: CGFloat?


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

        let session = URLSession.shared
        let u = URL(string: "\(Constants.BASE_URL)api/login")
        var request = URLRequest(url: u!)

        DispatchQueue.main.async {
            self.titleLabel.text = "Tentative de connexion..."
        }

        let email = emailField.text
        let hashedPass = passwordField.text?.sha512()

        request.httpMethod = "POST"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "Email=\(email!)&Password=\(hashedPass!)".data(using: .utf8)

        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let d = data {
                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
                    if (o["token"] != nil) {
                        UserDefaults.standard.set(true, forKey: o["token"]!)
                        self.saveResultToAppDelegate(token: o["token"]!, session: session)
                    } else {
                        return
                    }
                }
            } else {
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

    func saveResultToAppDelegate(token: String!, session: URLSession! ) {
        let u = URL(string: "\(Constants.BASE_URL)api/getLocation")
        var request = URLRequest(url: u!)

        request.httpMethod = "GET"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "token=\(token)".data(using: .utf8)

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
    
    override func viewWillDisappear(_ animated: Bool) {
        animator?.removeAllBehaviors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

