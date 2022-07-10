//
//  SelfConfigureCell.swift
//  iChat_App
//
//  Created by Felix Titov on 7/10/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

protocol SelfConfigureCell {
    static var reuseID: String { get }
    func configure(with value: MChat)
}
