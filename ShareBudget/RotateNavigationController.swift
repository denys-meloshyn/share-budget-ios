//
//  RotateNavigationViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 20.03.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class RotateNavigationController: UINavigationController {
    override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
