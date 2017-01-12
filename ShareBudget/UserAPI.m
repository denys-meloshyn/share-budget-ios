//
//  UserAPI.m
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import "UserAPI.h"

#import "BaseAPI.h"
#import "AsynchronousURLConnection.h"

@implementation UserAPI

+ (NSURLSessionTask *)update:(NSObject *)user completionBlock:(APICompletionBlock)completionBlock
{
    NSURLComponents *components = [BaseAPI components];
    components.path = @"/user";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    request.HTTPMethod = @"PUT";
    
    [request addValue:@"last name" forHTTPHeaderField:kLastName];
    [request addValue:@"1" forHTTPHeaderField:kPassword];
    [request addValue:@"ned1988@gmail.com" forHTTPHeaderField:kEmail];
    [request addValue:@"name" forHTTPHeaderField:kFirstName];
    [request addValue:[@YES stringValue] forHTTPHeaderField:kIsRemoved];
    
    return [AsynchronousURLConnection createAsynchronousRequest:request completionBlock:completionBlock];
}

@end
