//
//  AppGhostButton.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class AppGhostButton: UIButton {
    override func awakeFromNib() {
        // Add class to ghost button to factor
        super.awakeFromNib()
        let layer = self.layer
        
        // change border radius
        layer.cornerRadius = 4
        
        // change label color of button
        self.setTitleColor(UIColor(red: 0/255, green: 158/255, blue: 253/255, alpha: 1), for: .normal)
        
        // Add padding
        self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layer.borderWidth = 1
        
        // change color of border
        layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        // change background color
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    }
    
}
