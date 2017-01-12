//
//  AsynchronousURLConnection.m
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import "AsynchronousURLConnection.h"

#import "NetworkActivityIndicatorManager.h"

@implementation AsynchronousURLConnection

+ (NSURLSessionDataTask *)runAsynchronousRequest:(NSURLRequest *)request completionBlock:(APICompletionBlock)completionBlock
{
    NSURLSessionDataTask *task = [AsynchronousURLConnection createAsynchronousRequest:request completionBlock:^(id data, NSURLResponse *response, NSError *error) {
        [[NetworkActivityIndicatorManager sharedInstance] startLoading];
        
        if (completionBlock != nil) {
            completionBlock(data, response, error);
        }
    }];
    [task resume];
    
    return task;
}

+ (NSURLSessionDataTask *)createAsynchronousRequest:(NSURLRequest *)request completionBlock:(APICompletionBlock)completionBlock
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (task.state == NSURLSessionTaskStateCanceling || error.code == NSURLErrorCancelled) {
            return;
        }
        
        if (error != nil) {
            if (completionBlock != nil) {
                completionBlock(nil, response, error);
            }
            
            return;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if (statusCode != 200) {
            if (completionBlock != nil) {
                error = [NSError errorWithDomain:@"Status code is not OK" code:statusCode userInfo:nil];
                completionBlock(nil, response, error);
            }
            
            return;
        }
        
        NSError *errorJSON;
        NSObject *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorJSON];
        
        if (errorJSON != nil) {
            if (completionBlock != nil) {
                completionBlock(nil, response, errorJSON);
            }
            
            return;
        }
        
        if (completionBlock != nil) {
            completionBlock(result, response, nil);
        }
    }];
    
    return task;
}

@end
