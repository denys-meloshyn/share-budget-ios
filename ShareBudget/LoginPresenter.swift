//
//  LoginPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum AuthorisationMode {
    case login
    case signUp
}

protocol LoginPresenterDelegate: BasePresenterDelegate {
    func showLogin(title: String)
    func showSignUp(title: String)
}

class LoginPresenter: BasePresenter {
    var mode = AuthorisationMode.login
    weak var delegate: LoginPresenterDelegate?
    
    override func configure() {
        self.updateAthorisationView()
    }
    
    func switchAuthorisationMode() {
        if self.mode == .login {
            self.mode = .signUp
        } else {
            self.mode = .login
        }
        
        self.updateAthorisationView()
    }
    
    private func updateAthorisationView() {
        switch self.mode {
        case .login:
            self.delegate?.showLogin(title: "Switch to Sign Up")
            self.delegate?.showPage(title: "Login")
        case .signUp:
            self.delegate?.showSignUp(title: "Switch to Login")
            self.delegate?.showPage(title: "Sign Up")
        }
    }
}

extension LoginPresenter: UITextFieldDelegate {
    
}
