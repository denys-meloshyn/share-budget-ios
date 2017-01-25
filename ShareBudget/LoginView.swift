//
//  LoginView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import XCGLogger

enum LoginTextField {
    case none
    case email(String)
    case password(String)
    case repeatPassword(String)
    case firstName(String)
    case lastName(String)
    case all
}

class LoginView: BaseView {
    weak var stackView: UIStackView?
    weak var email: TextFieldErrorMessage?
    weak var authorisationButton: UIButton?
    weak var password: TextFieldErrorMessage?
    weak var lastName: TextFieldErrorMessage?
    weak var firstName: TextFieldErrorMessage?
    weak var authorisationModeButton: UIButton?
    weak var repeatPassword: TextFieldErrorMessage?
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        guard let presenter = presenter as? LoginPresenter else {
            return
        }
        
        presenter.delegate = self
    }
}

extension LoginView: LoginPresenterDelegate {
    private func updateButton(title: String) {
        self.authorisationModeButton?.setTitle(title, for: .normal)
        self.authorisationModeButton?.setTitle(title, for: .selected)
    }
    
    private func updateSignUpViews(hidden: Bool) {
        self.lastName?.isHidden = hidden
        self.firstName?.isHidden = hidden
        self.repeatPassword?.isHidden = hidden
    }
    
    private func createErrorLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.red
        
        return label
    }
    
    private func updatePasswordReturnKey(_ returnKeyType: UIReturnKeyType) {
        self.password?.textField?.returnKeyType = returnKeyType
    }
    
    private func hideKeyboard() {
        _ = self.email?.textField?.resignFirstResponder()
        _ = self.password?.textField?.resignFirstResponder()
        _ = self.repeatPassword?.textField?.resignFirstResponder()
        _ = self.firstName?.textField?.resignFirstResponder()
        _ = self.lastName?.textField?.resignFirstResponder()
    }
    
    func showLogin(title: String) {
        self.updatePasswordReturnKey(.go)
        self.hideKeyboard()
        
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: true)
            self.updateButton(title: title)
        }
    }
    
    func showSignUp(title: String) {
        self.updatePasswordReturnKey(.next)
        self.hideKeyboard()
        
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: false)
            self.updateButton(title: title)
        }
    }
    
    func loginValue(for field: LoginTextField) -> String {
        switch field {
        case .email(_):
            return self.email?.textField?.text ?? ""
            
        case .password(_):
            return self.password?.textField?.text ?? ""
            
        case .repeatPassword(_):
            return self.repeatPassword?.textField?.text ?? ""
            
        case .firstName(_):
            return self.firstName?.textField?.text ?? ""
            
        case .lastName(_):
            return self.lastName?.textField?.text ?? ""
            
        default:
            return ""
        }
    }
    
    func textType(for textField: UITextField) -> LoginTextField {
        if textField === self.email?.textField {
            return .email(textField.text ?? "")
        }
        
        if textField === self.password?.textField {
            return .password(textField.text ?? "")
        }
        
        if textField === self.repeatPassword?.textField {
            return .repeatPassword(textField.text ?? "")
        }
        
        if textField === self.firstName?.textField {
            return .firstName(textField.text ?? "")
        }
        
        if textField === self.lastName?.textField {
            return .lastName(textField.text ?? "")
        }
        
        return .none
    }
    
    func hideError(for field: LoginTextField) {
        switch field {
        case .email(_):
            self.email?.isErrorHidden = true
            
        default:
            break
        }
    }
    
    func showError(for field: LoginTextField) {
        XCGLogger.error("Error")
        
        var errorMessage: String?
        var loginTextField: TextFieldErrorMessage?
        
        switch field {
        case let .email(value):
            loginTextField = self.email
            errorMessage = value
            
        case let .password(value):
            loginTextField = self.password
            errorMessage = value
            
        default:
            break
        }
        
        loginTextField?.isErrorHidden = false
        loginTextField?.errorMessageLabel?.text = errorMessage
    }
    
    func showKeyboard(for textField: LoginTextField) {
        var loginTextField: UITextField?
        
        switch textField {
        case .password(_):
            loginTextField = self.password?.textField
            
        case .repeatPassword(_):
            loginTextField = self.repeatPassword?.textField
            
        case .firstName(_):
            loginTextField = self.firstName?.textField
            
        case .lastName(_):
            loginTextField = self.lastName?.textField
            
        default:
            break
        }
        
        loginTextField?.becomeFirstResponder()
    }
    
    func showAuthorisation(title: String) {
        self.authorisationButton?.setTitle(title, for: .normal)
        self.authorisationButton?.setTitle(title, for: .highlighted)
    }
    
    func configureTextField(_ textField: LoginTextField, placeholder: String) {
        switch textField {
        case .email(_):
            self.email?.textField?.placeholder = placeholder
            
        case .password(_):
            self.password?.textField?.placeholder = placeholder
            
        case .repeatPassword(_):
            self.repeatPassword?.textField?.placeholder = placeholder
            
        case .firstName(_):
            self.firstName?.textField?.placeholder = placeholder
            
        case .lastName(_):
            self.lastName?.textField?.placeholder = placeholder
            
        default:
            break
        }
    }
}
