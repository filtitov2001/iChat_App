//
//  UserError.swift
//  iChat_App
//
//  Created by Felix Titov on 7/12/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToMUser
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Fill all fields!", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Add your photo!", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Cannot load user info", comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString("Cannot convert data from Firebase to MUser", comment: "")
        }
    }
}
