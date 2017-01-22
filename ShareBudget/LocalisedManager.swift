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
        static let wrongEmailFormat = NSLocalizedString("E-mail format is wrong", comment: "Error mesage during email validation")
        static let dontHaveAccount = NSLocalizedString("Don't have an account?", comment: "Button title to switch to Sign Up form")
        static let title = NSLocalizedString("Login", comment: "Login title")
        static let loginWithExistingAccount = NSLocalizedString("Login with existing account", comment: "Button title to switch to Login form")
        static let signUp = NSLocalizedString("Sign Up", comment: "Sign Up title")
    }
}
