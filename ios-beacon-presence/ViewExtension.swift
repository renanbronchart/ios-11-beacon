//
//  ViewGradient.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

extension UIViewController {
    // Add init color function to create gradient in all of view
    func initGradient() {
        var gradientLayer: CAGradientLayer!
        
        gradientLayer = CAGradientLayer()
        
        // get all of view dimensions
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor(red: 42/255, green: 245/255, blue: 152/255, alpha: 1).cgColor, UIColor(red: 0/255, green: 158/255, blue: 253/255, alpha: 1).cgColor]
        
        // insert just above the view
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
