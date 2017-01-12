//
//  NetworkActivityIndicatorManager.h
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivityIndicatorManager : NSObject

+ (NetworkActivityIndicatorManager *)sharedInstance;

- (void)stopLoading;
- (void)startLoading;

@end
