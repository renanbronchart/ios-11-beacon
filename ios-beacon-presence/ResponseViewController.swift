//
//  ResponseViewController.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 26/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController {
    var success = false
    
    var overlayView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var labelButton: UIButton!
    
    // Declare behaviors and animation
    var animator:UIDynamicAnimator? = nil
    var animatorAlert:UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    var snap: UISnapBehavior!
    
    // Alert function
    
    @IBAction func closeAlert(_ sender: Any) {
        // close Alert function with animation
        
        // reference response view controller for animation
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Safety behaviors to remove all behaviors
        animator?.removeAllBehaviors()
        
        // add gravity to alert
        gravity.addItem(alertView)

        gravity.gravityDirection = CGVector(dx: 0.0, dy: 1.0)
        animator?.addBehavior(gravity)

        if (success == false) {
            self.navigationController?.popViewController(animated: true)
        }

        // Add angular velocity behavior to alert view
        let itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [alertView])
        itemBehaviour.addAngularVelocity(CGFloat(Double.pi / 2), for: alertView)
        animator?.addBehavior(itemBehaviour)
        
        // animate overlay and alert opacity
        UIView.animate(withDuration: 0.4, animations: {
            self.alertView?.alpha = 0.0
            self.overlayView?.alpha = 0.0
        }, completion: {
            (value: Bool) in
            self.removeOverlay()
            self.animator?.removeAllBehaviors()
        })
    }
    
    func createOverlay() {
        // Add overlay behind alert
        overlayView = UIView(frame: self.view.bounds)
        let layer = overlayView.layer
        
        layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        self.view.insertSubview(overlayView, belowSubview: alertView)
        
        // animate overlay opacity
        UIView.animate(withDuration: 0.3, animations: {
            layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
            
        })
    }
    
    func removeOverlay () {
        self.overlayView?.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // init gradient on response controller
        initGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createOverlay()
        
        // Change text if request is success or not
        if (success == false) {
            labelButton?.setTitle("Je rentente le coup", for: .normal)
        } else {
            labelButton?.setTitle("Yes", for: .normal)
        }

        let layer = alertView.layer

        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.alertView?.alpha = 0.0

        UIView.animate(withDuration: 0.4, animations: {
            self.alertView?.alpha = 1.0
        })
        
        // Add snap to center for alert view
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.animator = UIDynamicAnimator(referenceView: self.view)
            self.snap = UISnapBehavior(item: self.alertView, snapTo: self.view.center)
            self.animator?.addBehavior(self.snap)
        })
    }

}
