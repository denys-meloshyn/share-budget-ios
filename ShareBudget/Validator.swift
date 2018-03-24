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
        return password.count >= Constants.values.passwordMinLength
    }
    
    class func repeatPassword(password: String, repeat repeatPassword: String) -> Bool {
        return password == repeatPassword
    }
    
    class func firstName(_ firstName: String) -> Bool {
        let cleanedValue = firstName.trimmingCharacters(in: CharacterSet.whitespaces)
        return cleanedValue.count > 0
    }
    
    class func isNumberValid(_ value: String) -> Bool {
        if Double(value) == nil {
            return false
        }
        
        return true
    }
    
    class func removeWhiteSpaces(_ string: String) -> String {
        let nsString = string as NSString
        let range = NSMakeRange(0, nsString.length)
        let result = nsString.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: range)
        
        if result == " " {
            return ""
        }
        
        return result
    }
    
    class func isNullOrBlank(_ string: String?) -> Bool {
        guard let string = string  else {
            return true
        }
        
        let result = self.removeWhiteSpaces(string)
        
        return result.isEmpty
    }
}
