//
//  UserAPI.h
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface UserAPI : NSObject

+ (NSURLSessionTask *)update:(NSObject *)user completionBlock:(APICompletionBlock)completionBlock;

@end
