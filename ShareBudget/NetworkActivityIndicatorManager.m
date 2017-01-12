//
//  NetworkActivityIndicatorManager.m
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import "NetworkActivityIndicatorManager.h"

#import <UIKit/UIKit.h>

@interface NetworkActivityIndicatorManager ()
{
    NSInteger _statusActivities;
}

@end

@implementation NetworkActivityIndicatorManager

+ (NetworkActivityIndicatorManager *)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static NetworkActivityIndicatorManager *shareInstance = nil;
    
    // Init singleton
    dispatch_once(&onceToken, ^{
        shareInstance = [[NetworkActivityIndicatorManager alloc] init];
    });
    
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self != nil) {
        _statusActivities = 0;
    }
    
    return self;
}

- (void)stopLoading
{
    @synchronized(self) {
        _statusActivities = MAX(0, _statusActivities - 1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_statusActivities == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        });
    }
}

- (void)startLoading
{
    @synchronized(self) {
        _statusActivities++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
    }
}

@end
