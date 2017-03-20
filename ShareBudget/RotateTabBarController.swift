//
//  RotateTabBarController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 20.03.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class RotateTabBarController: UITabBarController {
    override var shouldAutorotate: Bool {
        get {
            if let selectedVC = self.selectedViewController {
                return selectedVC.shouldAutorotate
            }
            
            return false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if let selectedVC = self.selectedViewController {
                return selectedVC.supportedInterfaceOrientations
            }
            
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            if let selectedVC = self.selectedViewController {
                return selectedVC.preferredInterfaceOrientationForPresentation
            }
            
            return UIInterfaceOrientation.portrait
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
}
