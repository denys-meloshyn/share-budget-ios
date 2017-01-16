//
//  LoginViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = LoginRouter(with: self)
        let interactin = LoginInteraction(with: router)
        let presenter = LoginPresenter(with: interactin)
        self.viperView = LoginView(with: presenter, and: self)
        
        guard let view = self.viperView as? LoginView else {
            return
        }
        
        self.linkStoryboardViews(to: view)
    }

    func linkStoryboardViews(to view: LoginView) {
        
    }
}
