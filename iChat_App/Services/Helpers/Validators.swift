//
//  Validators.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

class Validators {
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let password = password,
              let confirmPassword = confirmPassword,
              let email = email,
              password != "",
              confirmPassword != "",
              email != "" else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
            let emailRegEx = "^.+@.+\\..{2,}$"
            return check(text: email, regEx: emailRegEx)
        }
        
        private static func check(text: String, regEx: String) -> Bool {
            let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
            return predicate.evaluate(with: text)
        }
}
