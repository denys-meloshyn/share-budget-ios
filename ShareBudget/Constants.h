//
//  Constants.h
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APICompletionBlock)(id data, NSURLResponse *response, NSError *error);

static NSString *const kDate = @"date";
static NSString *const kName = @"name";
static NSString *const kLimit = @"limit";
static NSString *const kEmail = @"email";
static NSString *const kPrice = @"price";
static NSString *const kToken = @"token";
static NSString *const kResult = @"result";
static NSString *const kStatus = @"status";
static NSString *const kUserID = @"userID";
static NSString *const kMessage = @"message";
static NSString *const kGroupID = @"groupID";
static NSString *const kPassword = @"password";
static NSString *const kLastName = @"lastName";
static NSString *const kFirstName = @"firstName";
static NSString *const kExpenseID = @"expenseID";
static NSString *const kIsRemoved = @"isRemoved";
static NSString *const kTimeStamp = @"timeStamp";
static NSString *const kInternalID = @"internalID";
static NSString *const kCategoryID = @"categoryID";
static NSString *const kUserGroupID = @"userGroupID";
static NSString *const kBudgetLimitID = @"budgetLimitID";
static NSString *const kModifiedUserID = @"modifiedUserID";
static NSString *const kCategoryLimitID = @"categoryLimitID";

@interface Constants : NSObject

@end
