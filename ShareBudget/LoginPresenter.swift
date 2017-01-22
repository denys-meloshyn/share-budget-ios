//
//  LoginPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import Rswift
import XCGLogger

enum AuthorisationMode {
    case login
    case signUp
}

protocol LoginPresenterDelegate: BasePresenterDelegate {
    func showLogin(title: String)
    func showSignUp(title: String)
    func showAuthorisation(title: String)
    func showError(for field: LoginTextField)
    func hideError(for field: LoginTextField)
    func showKeyboard(for textField: LoginTextField)
    func loginValue(for field: LoginTextField) -> String
    func textType(for textField: UITextField) -> LoginTextField
}

class LoginPresenter: BasePresenter {
    var mode = AuthorisationMode.login
    weak var delegate: LoginPresenterDelegate?
    
    override func configure() {
        self.updateAthorisationView()
    }
    
    // MARK: - Public
    
    func switchAuthorisationMode() {
        if self.mode == .login {
            self.mode = .signUp
        } else {
            self.mode = .login
        }
        
        self.updateAthorisationView()
    }
    
    func authoriseUser() {
        let notValidField = self.findNotValidField()
        switch notValidField {
        case .email(_):
            self.delegate?.showError(for: .email(LocalisedManager.login.wrongEmailFormat))
            
        default:
            break
        }
    }
    
    func listenTextFieldChanges(_ textField: UITextField?) {
        textField?.delegate = self
    }
    
    // MARK: - Private
    
    private func findNotValidField() -> LoginTextField {
        guard let delegate = self.delegate else {
            return .all
        }
        
        var value = delegate.loginValue(for: .email(""))
        if !Validator.email(value) {
            return .email("")
        }
        
        value = delegate.loginValue(for: .password(""))
        if !Validator.password(value) {
            return .password("")
        }
        
        if self.mode == .login {
            return .none
        }
        
        return .none
    }
    
    fileprivate func validate(textField: UITextField) {
        guard let input = self.delegate?.textType(for: textField) else {
            return
        }
        
        switch input {
        case let .email(value):
            if !Validator.email(value) {
                self.delegate?.showError(for: .email(LocalisedManager.login.wrongEmailFormat))
            }
            
        default:
            break
        }
    }
    
    fileprivate func updateAthorisationView() {
        switch self.mode {
        case .login:
            self.delegate?.showLogin(title: LocalisedManager.login.dontHaveAccount)
            self.delegate?.showPage(title: LocalisedManager.login.title)
            self.delegate?.showAuthorisation(title: LocalisedManager.login.title)
        case .signUp:
            self.delegate?.showSignUp(title: LocalisedManager.login.loginWithExistingAccount)
            self.delegate?.showPage(title: LocalisedManager.login.signUp)
            self.delegate?.showAuthorisation(title: LocalisedManager.login.signUp)
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
