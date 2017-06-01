//
//  AppDelegate.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import le
import XCGLogger
import BugfenderSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    private func configureLogger() {
        //LELog.sharedInstance().token = "3c7c276a-44b2-4804-8f48-03c7cf3b43fb"
        
        Bugfender.activateLogger("x041vOzFfgsTGl7PGfHlzlof9lPXxBjb")
        Bugfender.setPrintToConsole(false)
        Bugfender.enableUIEventLogging()  // optional, log user interactions automatically
        
        // Create a logger object with no destinations
        let log = XCGLogger.default
        
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
        let logPath: URL = self.cacheDirectory.appendingPathComponent("XCGLogger_Log.txt")
        let fileDestination = FileDestination(writeToFile: logPath, identifier: "advancedLogger.fileDestination")
        
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
        
        let remoteLogsDestination = RemoteLogsDestination(identifier: "advancedLogger.remoteDestination")
        remoteLogsDestination.outputLevel = .debug
        remoteLogsDestination.showLogIdentifier = false
        remoteLogsDestination.showFunctionName = true
        remoteLogsDestination.showThreadName = true
        remoteLogsDestination.showLevel = true
        remoteLogsDestination.showFileName = true
        remoteLogsDestination.showLineNumber = true
        remoteLogsDestination.showDate = true
        
        log.add(destination: remoteLogsDestination)
        
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
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = Constants.defaultTextTintColor
        UITabBar.appearance().barTintColor = Constants.defaultApperanceColor
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : Constants.defaultActionColor], for: .selected)
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = Constants.defaultTextTintColor
        UINavigationBar.appearance().barTintColor = Constants.defaultApperanceColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : Constants.defaultTextTintColor]
        
        UITextField.appearance().tintColor = Constants.defaultActionColor
        
        self.window?.tintColor = Constants.defaultActionColor
    }
}

