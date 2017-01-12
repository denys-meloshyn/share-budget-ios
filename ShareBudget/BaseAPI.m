//
//  BaseAPI.m
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import "BaseAPI.h"

@implementation BaseAPI

+ (NSURLComponents *)components
{
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = @"127.0.0.1";
    components.port = @5000;
    
    return components;
}

@end
