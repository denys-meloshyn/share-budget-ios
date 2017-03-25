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
        
        UserCredentials.logout()
        ModelManager.dropAllEntities()
        
        if let loginViewControler = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationViewController") {
            UIApplication.shared.delegate?.window??.rootViewController = loginViewControler
        }
    }
    
    @IBAction func reset() {
        UserCredentials.resetTimeStamps()
    }
}
