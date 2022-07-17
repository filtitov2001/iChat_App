//
//  CloseButton.swift
//  iChat_App
//
//  Created by Felix Titov on 7/17/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class CloseButton: UIButton {
    
    convenience init(tintColor: UIColor) {
        self.init(type: .close)
        self.configuration = .tinted()
        self.tintColor = tintColor
        
        self.widthAnchor.constraint(equalToConstant: 35).isActive = true
        self.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
