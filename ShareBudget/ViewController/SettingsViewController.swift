//
//  SettingsViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout() {
        SyncManager.shared.stop()
        Dependency.userCredentials.logout()
        ModelManager.dropAllEntities()

        UIApplication.shared.delegate?.window??.rootViewController = R.storyboard.main.loginNavigationViewController()
    }
    
    @IBAction func reset() {
        ModelManager.dropAllEntities()
        UserCredentials.resetTimeStamps()
        SyncManager.shared.stop()
        SyncManager.shared.run()
    }
}
