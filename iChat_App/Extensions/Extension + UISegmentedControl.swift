//
//  Extension + UISegmentedControl.swift
//  iChat_App
//
//  Created by Felix Titov on 7/10/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation
import UIKit

extension UISegmentedControl {
    convenience init(first: String, second: String) {
        self.init()
        insertSegment(withTitle: first, at: 0, animated: true)
        insertSegment(withTitle: second, at: 1, animated: true)
        selectedSegmentIndex = 0
    }
}
