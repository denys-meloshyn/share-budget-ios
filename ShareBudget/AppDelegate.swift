//
//  AppDelegate.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import Firebase
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    override init() {
        super.init()
        Dependency.configure()
    }

    var window: UIWindow? 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if Dependency.environment() != .testing {
            FirebaseApp.configure()
            Fabric.sharedSDK().debug = true
        }
        
        // Override point for customization after application launch.
        self.configureAppearance()
        
        if let launchViewControllerID = ProcessInfo.processInfo.environment[Constants.key.testing.launchViewControllerID] {
            let storyboard =  UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: launchViewControllerID)
            self.window?.rootViewController = viewController
            return true
        }
        
        if !Dependency.userCredentials.isLoggedIn {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewControler = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController")
            self.window?.rootViewController = loginViewControler
        } else {
            SyncManager.shared.run()
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
        UITabBar.appearance().tintColor = Constants.color.dflt.textTintColor
        UITabBar.appearance().barTintColor = Constants.color.dflt.apperanceColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Constants.color.dflt.actionColor], for: .selected)
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = Constants.color.dflt.actionColor
        UINavigationBar.appearance().barTintColor = Constants.color.dflt.apperanceColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Constants.color.dflt.textTintColor]
        
        UITextField.appearance().tintColor = Constants.color.dflt.actionColor
        
        self.window?.tintColor = Constants.color.dflt.actionColor
    }
}
