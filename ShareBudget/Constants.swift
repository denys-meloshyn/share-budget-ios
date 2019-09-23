//
//  Constants.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum ErrorTypeAPI: Error {
    case none
    case userNotExist
    case emailNotApproved
    case userPasswordIsWrong
    case userIsAlreadyExist
    case tokenExpired
    case tokenNotValid
    case unknown
}

protocol AutoMockable {}
protocol AutoEquatable {}

struct Constants {
    enum Errors: Error {
        case urlNotValid
        case wrongResponseFormat
    }
    
    struct values {
        static let paginationSize = 30
        static let passwordMinLength = 1
    }
    
    struct key {
        struct testing {
            static let launchViewControllerID = "klaunchViewControllerID"
        }
        
        struct error {
            static let userNotExist = "userNotExist"
            static let tokenExpired = "token_expired"
            static let tokenNotValid = "token_not_valid"
            static let emailNotApproved = "email_not_approved"
            static let userIsAlreadyExist = "user_is_already_exist"
            static let userPasswordIsWrong = "user_password_is_wrong"
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
            
            static let logBody = "response"
        }
    }
    
    struct color {
        struct dflt {
            static let textTintColor = UIColor.black
            static let inputTextColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1) // #C7C7CD
            static let actionColor = #colorLiteral(red: 0.9137254902, green: 0.1176470588, blue: 0.3882352941, alpha: 1) // #E91E63
            static let apperanceColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1) // #EEEEEE
            static let backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) // #F5F5F5
        }
        
        struct login {
            static let validBorderColor = UIColor.blue
            static let errorBorderColor = UIColor.red
        }
    }
}
