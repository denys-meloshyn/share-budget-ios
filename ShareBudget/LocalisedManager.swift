//
//  LocalisedManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 22.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation
import Rswift

struct LocalisedManager {
    struct generic {
        static let ok = NSLocalizedString("OK", comment: "Generic OK message")
    }
    
    struct login {
        static let dontHaveAccount = NSLocalizedString("Don't have an account?", comment: "Button title to switch to Sign Up form")
        static let title = NSLocalizedString("Login", comment: "Login title")
        static let loginWithExistingAccount = NSLocalizedString("Login with existing account", comment: "Button title to switch to Login form")
        static let signUp = NSLocalizedString("Sign Up", comment: "Sign Up title")
        static let repeatPassword = NSLocalizedString("Repeat password", comment: "Placeholder for Repeat Password text field")
        static let firstName = NSLocalizedString("First name", comment: "Placeholder for First Name text field")
        static let lastName = NSLocalizedString("Last name", comment: "Placeholder for Last Name text field")
        static let password = NSLocalizedString("Password", comment: "Placeholder for Password text field")
        static let email = NSLocalizedString("E-mail", comment: "Placeholder for Email text field")
    }
    
    struct validation {
        static let wrongEmailFormat = NSLocalizedString("E-mail format is wrong", comment: "Error mesage for email validation")
        static let wrongPasswordFormat = NSLocalizedString("Password has wrong format", comment: "Error mesage for password validation")
        static let repeatPasswordIsDifferent = NSLocalizedString("Repeat password not the same as Password", comment: "Error mesage for repeat password validation")
        static let firstNameIsEmpty = NSLocalizedString("First name is empty", comment: "Error mesage for first name validation")
    }
}
