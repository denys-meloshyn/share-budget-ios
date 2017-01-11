//
//  AppDelegate.h
//  ShareBudget
//
//  Created by Denys Meloshyn on 11.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

