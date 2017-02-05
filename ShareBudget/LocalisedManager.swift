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
        static let errorTitle = NSLocalizedString("Error", comment: "Generic error title")
        static let errorMessage = NSLocalizedString("Something was wrong", comment: "Generic error message")
    }
    
    struct error {
        static let userNotExist = NSLocalizedString("User with provided email doesn't exist", comment: "Error message when user doesn't exist")
        static let passwordIsWrong = NSLocalizedString("Password is wrong", comment: "Error message when user password is wrong")
        static let userIsAlreadyExist = NSLocalizedString("User is already exist", comment: "Error message when user trying to register existed email")
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
        static let sendAgain = NSLocalizedString("Send again", comment: "Send registration email title")
        static let sendRegistrationEmailMessage = NSLocalizedString("Please approve your E-mail", comment: "Send registration email error description message")
    }
    
    struct validation {
        static let wrongEmailFormat = NSLocalizedString("E-mail format is wrong", comment: "Error mesage for email validation")
        static let wrongPasswordFormat = NSLocalizedString("Password has wrong format", comment: "Error mesage for password validation")
        static let repeatPasswordIsDifferent = NSLocalizedString("Repeat password not the same as Password", comment: "Error mesage for repeat password validation")
        static let firstNameIsEmpty = NSLocalizedString("First name is empty", comment: "Error mesage for first name validation")
    }
    
    struct edit {
        struct expense {
            static let price = NSLocalizedString("Price", comment: "Expense price title in Edit expense page")
            static let name = NSLocalizedString("Name", comment: "Expense name title in Edit expense page")
            static let category = NSLocalizedString("Category", comment: "Expense category title in Edit expense page")
            static let date = NSLocalizedString("Date", comment: "Expense date title in Edit expense page")
            static let create = NSLocalizedString("Create", comment: "Create title in Edit expense page")
        }
    }
}
