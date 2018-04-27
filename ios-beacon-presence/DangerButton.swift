//
//  DangerButton.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class DangerButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = self.layer
        
        layer.cornerRadius = 4
        self.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1).cgColor
        layer.backgroundColor = UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1).cgColor
        
        
    }
    
}
