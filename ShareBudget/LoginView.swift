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
    weak var emailTextField: UITextField?
    weak var authorisationButton: UIButton?
    weak var passwordTextField: UITextField?
    weak var lastNameTextField: UITextField?
    weak var firstNameTextField: UITextField?
    weak var authorisationModeButton: UIButton?
    weak var repeatPasswordTextField: UITextField?
    
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
        self.lastNameTextField?.isHidden = hidden
        self.firstNameTextField?.isHidden = hidden
        self.repeatPasswordTextField?.isHidden = hidden
    }
    
    private func nextArrangedView(_ view: UIView) -> UIView? {
        guard let stackView = self.stackView else {
            return nil
        }
        
        guard let index = stackView.arrangedSubviews.index(of: view), index < stackView.arrangedSubviews.count else {
            return nil
        }
        
        return stackView.arrangedSubviews[index + 1]
    }
    
    private func createErrorLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.red
        
        return label
    }
    
    private func updatePasswordReturnKey(_ returnKeyType: UIReturnKeyType) {
        self.passwordTextField?.returnKeyType = returnKeyType
    }
    
    private func hideKeyboard() {
        _ = self.emailTextField?.resignFirstResponder()
        _ = self.passwordTextField?.resignFirstResponder()
        _ = self.repeatPasswordTextField?.resignFirstResponder()
        _ = self.firstNameTextField?.resignFirstResponder()
        _ = self.lastNameTextField?.resignFirstResponder()
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
            return self.emailTextField?.text ?? ""
            
        case .password(_):
            return self.passwordTextField?.text ?? ""
            
        case .repeatPassword(_):
            return self.repeatPasswordTextField?.text ?? ""
            
        case .firstName(_):
            return self.firstNameTextField?.text ?? ""
            
        case .lastName(_):
            return self.lastNameTextField?.text ?? ""
            
        default:
            return ""
        }
    }
    
    func textType(for textField: UITextField) -> LoginTextField {
        if textField === self.emailTextField {
            return .email(textField.text ?? "")
        }
        
        if textField === self.passwordTextField {
            return .password(textField.text ?? "")
        }
        
        if textField === self.repeatPasswordTextField {
            return .repeatPassword(textField.text ?? "")
        }
        
        if textField === self.firstNameTextField {
            return .firstName(textField.text ?? "")
        }
        
        if textField === self.lastNameTextField {
            return .lastName(textField.text ?? "")
        }
        
        return .none
    }
    
    func hideError(for field: LoginTextField) {
        var textField: UITextField?
        
        switch field {
        case .email(_):
            textField = self.emailTextField
            
        default:
            break
        }
        
        guard let currentTextField = textField else {
            return
        }
        
        guard let nextView = self.nextArrangedView(currentTextField), nextView.isKind(of: UILabel.self) else {
            return
        }
        
        nextView.removeFromSuperview()
    }
    
    func showError(for field: LoginTextField) {
        XCGLogger.error("Error")
        
        switch field {
        case let .email(value):
            guard let emailTextField = self.emailTextField else {
                return
            }
            
            guard let index = self.stackView?.arrangedSubviews.index(of: emailTextField) else {
                return
            }
            
            let label = self.createErrorLabel(with: value)
            self.stackView?.insertArrangedSubview(label, at: index + 1)
            
            break
            
        default:
            break
        }
    }
    
    func showKeyboard(for textField: LoginTextField) {
        var loginTextField: UITextField?
        
        switch textField {
        case .password(_):
            loginTextField = self.passwordTextField
            
        case .repeatPassword(_):
            loginTextField = self.repeatPasswordTextField
            
        case .firstName(_):
            loginTextField = self.firstNameTextField
            
        case .lastName(_):
            loginTextField = self.lastNameTextField
            
        default:
            break
        }
        
        loginTextField?.becomeFirstResponder()
    }
    
    func showAuthorisation(title: String) {
        self.authorisationButton?.setTitle(title, for: .normal)
        self.authorisationButton?.setTitle(title, for: .highlighted)
    }
}
