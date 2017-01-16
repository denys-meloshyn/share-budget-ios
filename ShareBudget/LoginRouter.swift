//
//  LoginRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class LoginRouter: BaseRouter {
    private weak var viewController: UIViewController?
    
    init(with viewController: UIViewController) {
        self.viewController = viewController
    }
}
