//
//  Constants.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import ChameleonFramework

let kDate = "date"
let kName = "name"
let kLimit = "limit"
let kEmail = "email"
let kPrice = "price"
let kToken = "token"
let kResult = "result"
let kStatus = "status"
let kUserID = "userID"
let kGroupID = "groupID"
let kMessage = "message"
let kPassword = "password"
let kLastName = "lastName"
let kFirstName = "firstName"
let kExpenseID = "expenseID"
let kIsRemoved = "isRemoved"
let kTimeStamp = "timeStamp"
let kInternalID = "internalID"
let kCategoryID = "categoryID"
let kUserGroupID = "userGroupID"
let kCreationDate = "creationDate"
let kBudgetLimitID = "budgetLimitID"
let kModifiedUserID = "modifiedUserID"
let kCategoryLimitID = "categoryLimitID"

let kPagination = "pagination"
let kPaginationStart = "start"
let kPaginationTotal = "total"
let kPaginationPageSize = "pageSize"
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

let launchViewControllerID = "klaunchViewControllerID"

struct Constants {
    struct key {
        struct testing {
            static let launchViewControllerID = "klaunchViewControllerID"
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
