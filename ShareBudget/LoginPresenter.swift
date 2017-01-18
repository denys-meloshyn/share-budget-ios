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
    func currentTextField() -> InputTextField
    func textValue(for field: InputTextField) -> String
    func showError(_ message: String, for field: InputTextField)
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
    
    func listenTextFieldChanges(_ textField: UITextField?) {
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(LoginPresenter.validateInputValue), for: .editingChanged)
    }
    
    func validateInputValue() {
        guard let input = self.delegate?.currentTextField() else {
            return
        }
        
        guard var value = self.delegate?.textValue(for: input), value.characters.count == 0 else {
            return
        }
        
        switch input {
        case .email:
            if !Validator.email(value) {
                self.delegate?.showError("E-mail is wrong", for: .email)
            }
            
        default:
            break
        }
    }
    
    private func updateAthorisationView() {
        switch self.mode {
        case .login:
            self.delegate?.showLogin(title: "Don't have an account?")
            self.delegate?.showPage(title: "Login")
        case .signUp:
            self.delegate?.showSignUp(title: "Login with existing credentials")
            self.delegate?.showPage(title: "Sign Up")
        }
    }
}

extension LoginPresenter: UITextFieldDelegate {
    
}
