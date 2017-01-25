//
//  Validator.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class Validator {
    class func email(_ email: String) -> Bool {
        let regExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExp)
        
        return predicate.evaluate(with: email)
    }
    
    class func password(_ password: String) -> Bool {
        return password.characters.count >= kPasswordMinLength
    }
    
    class func repeatPassword(password: String, repeat repeatPassword: String) -> Bool {
        return password == repeatPassword
    }
    
    class func firstName(_ firstName: String) -> Bool {
        let cleanedValue = firstName.trimmingCharacters(in: CharacterSet.whitespaces)
        return cleanedValue.characters.count > 0
    }
}
