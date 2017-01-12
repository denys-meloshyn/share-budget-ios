//
//  AsynchronousURLConnection.h
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface AsynchronousURLConnection : NSObject

+ (NSURLSessionDataTask *)runAsynchronousRequest:(NSURLRequest *)request completionBlock:(APICompletionBlock)completionBlock;
+ (NSURLSessionDataTask *)createAsynchronousRequest:(NSURLRequest *)request completionBlock:(APICompletionBlock)completionBlock;

@end
