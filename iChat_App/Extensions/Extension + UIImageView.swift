//
//  Extension + UIImageView.swift
//  iChat_App
//
//  Created by Felix Titov on 7/9/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
}
