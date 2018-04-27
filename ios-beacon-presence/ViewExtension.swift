//
//  ViewGradient.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

extension UIViewController {
    func initGradient() {
        var gradientLayer: CAGradientLayer!
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        
        gradientLayer.colors = [UIColor(red: 42/255, green: 245/255, blue: 152/255, alpha: 1).cgColor, UIColor(red: 0/255, green: 158/255, blue: 253/255, alpha: 1).cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
