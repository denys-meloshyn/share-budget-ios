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

let kPasswordMinLength = 1

let loginBorderColor = UIColor.blue
let loginErrorBorderColor = UIColor.red

let kUserNotExist = "userNotExist"
let kTokenExpired = "token_expired"
let kTokenNotValid = "token_not_valid"
let kEmailNotApproved = "email_not_approved"
let kUserIsAlreadyExist = "user_is_already_exist"
let kUserPasswordIsWrong = "user_password_is_wrong"

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

class Constants {
    static let defaultTextTintColor = UIColor.white
    static let defaultActionColor = UIColor(hexString: "#E91E63")!
    static let defaultApperanceColor = UIColor(hexString: "#4CAF50")!
    static let defaultBackgroundColor = UIColor(hexString: "#F5F5F5")
}
