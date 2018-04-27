//
//  buttonApp.swift
//  newTest
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import UIKit

class AppButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = self.layer
        
        layer.cornerRadius = 4
        self.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 44/255, green: 123/255, blue: 246/255, alpha: 0.8).cgColor
        layer.backgroundColor = UIColor(red: 44/255, green: 123/255, blue: 246/255, alpha: 0.8).cgColor
    }
    
}
