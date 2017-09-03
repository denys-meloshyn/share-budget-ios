//
//  Constants.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import ChameleonFramework

let paginationSize = 30

let kPasswordMinLength = 1

let loginBorderColor = UIColor.blue
let loginErrorBorderColor = UIColor.red

let kUserNotExist = "userNotExist"
let kTokenExpired = "token_expired"
let kTokenNotValid = "token_not_valid"
let kEmailNotApproved = "email_not_approved"
let kUserIsAlreadyExist = "user_is_already_exist"
let kUserPasswordIsWrong = "user_password_is_wrong"

let kLogBody = "response"

enum ErrorTypeAPI {
    case none
    case userNotExist
    case emailNotApproved
    case userPasswordIsWrong
    case userIsAlreadyExist
    case tokenExpired
    case tokenNotValid
    case unknown
}

struct Constants {
    struct key {
        struct testing {
            static let launchViewControllerID = "klaunchViewControllerID"
        }
        
        struct json {
            static let date = "date"
            static let name = "name"
            static let limit = "limit"
            static let email = "email"
            static let price = "price"
            static let token = "token"
            static let result = "result"
            static let status = "status"
            static let userID = "userID"
            static let groupID = "groupID"
            static let message = "message"
            static let password = "password"
            static let lastName = "lastName"
            static let firstName = "firstName"
            static let expenseID = "expenseID"
            static let isRemoved = "isRemoved"
            static let timeStamp = "timeStamp"
            static let internalID = "internalID"
            static let categoryID = "categoryID"
            static let userGroupID = "userGroupID"
            static let creationDate = "creationDate"
            static let budgetLimitID = "budgetLimitID"
            static let modifiedUserID = "modifiedUserID"
            static let categoryLimitID = "categoryLimitID"
            
            static let pagination = "pagination"
            static let paginationStart = "start"
            static let paginationTotal = "total"
            static let paginationPageSize = "pageSize"
        }
    }
    
    struct appearance {
        struct dflt {
            static let textTintColor = UIColor.black
            static let inputTextColor = UIColor(hexString:"#C7C7CD")!
            static let actionColor = UIColor(hexString: "#E91E63")!
            static let apperanceColor = UIColor(hexString: "#EEEEEE")!
            static let backgroundColor = UIColor(hexString: "#F5F5F5")
        }
    }
}
