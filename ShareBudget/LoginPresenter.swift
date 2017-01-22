//
//  LoginPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import XCGLogger

enum AuthorisationMode {
    case login
    case signUp
}

protocol LoginPresenterDelegate: BasePresenterDelegate {
    func showLogin(title: String)
    func showSignUp(title: String)
    func showError(for field: LoginTextField)
    func hideError(for field: LoginTextField)
    func showKeyboard(for textField: LoginTextField)
    func textType(for textField: UITextField) -> LoginTextField
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
    }
    
    fileprivate func validate(textField: UITextField) {
        guard let input = self.delegate?.textType(for: textField) else {
            return
        }
        
        switch input {
        case let .email(value):
            if !Validator.email(value) {
                self.delegate?.showError(for: .email("E-mail is wrong"))
            }
            
        default:
            break
        }
    }
    
    fileprivate func updateAthorisationView() {
        switch self.mode {
        case .login:
            self.delegate?.showLogin(title: "Don't have an account?")
            self.delegate?.showPage(title: "Login")
        case .signUp:
            self.delegate?.showSignUp(title: "Login with existing account")
            self.delegate?.showPage(title: "Sign Up")
        }
    }
    
    fileprivate func activateNextKeyboard(for textField: UITextField) {
        guard let loginTextField = self.delegate?.textType(for: textField) else {
            return
        }
        
        switch loginTextField {
        case .email(_):
            self.delegate?.showKeyboard(for: .password(""))
            
        case .password(_):
            if self.mode == .login {
                
            }
            else {
                self.delegate?.showKeyboard(for: .repeatPassword(""))
            }
            
        case .repeatPassword(_):
            self.delegate?.showKeyboard(for: .firstName(""))
            
        case .firstName(_):
            self.delegate?.showKeyboard(for: .lastName(""))
            
        default:
            break
        }
    }
}

extension LoginPresenter: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let inputTextField = self.delegate?.textType(for: textField) else {
            return
        }
        
        self.delegate?.hideError(for: inputTextField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.characters.count > 0 else {
            return
        }
        
        self.validate(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activateNextKeyboard(for: textField)
        
        return false
    }
}
