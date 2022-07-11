//
//  AuthError.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case serverError
    case unknownError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Fill all fields!", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email format is false!", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("The passwords do not match!", comment: "")
        case .serverError:
            return NSLocalizedString("Server error!", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error!", comment: "")
        }
    }
}
