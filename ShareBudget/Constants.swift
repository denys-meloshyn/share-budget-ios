//
//  Constants.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

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

let kPasswordMinLength = 1

let loginBorderColor = UIColor.blue
let loginErrorBorderColor = UIColor.red

let kUserNotExist = "userNotExist"
let kTokenEpired = "token_expired"
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
    case unknown
}
