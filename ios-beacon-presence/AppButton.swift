//
//  buttonApp.swift
//  newTest
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

// Reference app button class to factor
class AppButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = self.layer
        
        // Add corner radius
        layer.cornerRadius = 4
        // Add colors
        self.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        // Add min padding
        self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Add design on border
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0/255, green: 158/255, blue: 253/255, alpha: 1).cgColor
        layer.backgroundColor = UIColor(red: 0/255, green: 158/255, blue: 253/255, alpha: 1).cgColor
        
        
    }
    
}
