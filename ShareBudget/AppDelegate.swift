//
//  AppDelegate.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import Fabric
import RxSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let disposeBag = DisposeBag()
    let userGroupAPI = UserGroupAPI()
    
    override init() {
        super.init()
        Dependency.configure()
    }

    var window: UIWindow? 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
            let loginNavigationViewController = R.storyboard.main.loginNavigationViewController()
            self.window?.rootViewController = loginNavigationViewController
        } else {
            SyncManager.shared.run()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let path = components.path,
            path == "/v1/user/group",
            let params = components.queryItems,
            let token = params.first(where: { $0.name == "token" } )?.value else {
                return false
        }

        userGroupAPI.addUserToGroup(token: token).subscribe { event in

        }.disposed(by: disposeBag)

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
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.color.dflt.actionColor], for: .selected)
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = Constants.color.dflt.actionColor
        UINavigationBar.appearance().barTintColor = Constants.color.dflt.apperanceColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.color.dflt.textTintColor]
        
        UITextField.appearance().tintColor = Constants.color.dflt.actionColor
        
        self.window?.tintColor = Constants.color.dflt.actionColor
    }
}
