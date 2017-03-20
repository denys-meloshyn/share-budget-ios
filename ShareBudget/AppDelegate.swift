//
//  AppDelegate.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private func configureLogger() {
        // Create a logger object with no destinations
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        // Optionally set some configuration options
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        
        // Add the destination to the logger
        log.add(destination: systemDestination)
        
        // Create a file log destination
        let fileDestination = FileDestination(writeToFile: "/path/to/file", identifier: "advancedLogger.fileDestination")
        
        // Optionally set some configuration options
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        log.add(destination: fileDestination)
        
        // Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configureLogger()
        self.configureAppearance()
        
        if !UserCredentials.isLoggedIn {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewControler = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController")
            self.window?.rootViewController = loginViewControler
        }
        else {
            SyncManager.run()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        ModelManager.saveContext(ModelManager.managedObjectContext)
    }
    
    private func configureAppearance() {
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barTintColor = Constants.defaultApperanceColor
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.selected)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Constants.defaultApperanceColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
//        UITextField.appearance().tintColor = Constants.defaultActiveColor
    }
}

