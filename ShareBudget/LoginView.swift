//
//  LoginView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum InputTextField {
    case none
    case email
    case password
    case repeatPassword
    case firstName
    case lastName
}

class LoginView: BaseView {
    weak var stackView: UIStackView?
    weak var emailTextField: UITextField?
    weak var authorisationButton: UIButton?
    weak var passwordTextField: UITextField?
    weak var lastNameTextField: UITextField?
    weak var firstNameTextField: UITextField?
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
        self.authorisationButton?.setTitle(title, for: .normal)
        self.authorisationButton?.setTitle(title, for: .selected)
    }
    
    private func updateSignUpViews(hidden: Bool) {
        self.lastNameTextField?.isHidden = hidden
        self.firstNameTextField?.isHidden = hidden
        self.repeatPasswordTextField?.isHidden = hidden
    }
    
    func showLogin(title: String) {
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: true)
            self.updateButton(title: title)
        }
    }
    
    func showSignUp(title: String) {
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: false)
            self.updateButton(title: title)
        }
    }
    
    func textValue(for field: InputTextField) -> String {
        var value: String?
        
        switch field {
        case .email:
            value = self.emailTextField?.text
            
        case .password:
            value = self.passwordTextField?.text
            
        case .repeatPassword:
            value = self.repeatPasswordTextField?.text
            
        case .firstName:
            value = self.firstNameTextField?.text
            
        case .lastName:
            value = self.lastNameTextField?.text
            
        default:
            break
        }
        
        return value ?? ""
    }
    
    func currentTextField() -> InputTextField {
        if let emailTextField = self.emailTextField, emailTextField.isFirstResponder {
            return .email
        }
        
        if let passwordTextField = self.passwordTextField, passwordTextField.isFirstResponder {
            return .password
        }
        
        if let repeatPasswordTextField = self.repeatPasswordTextField, repeatPasswordTextField.isFirstResponder {
            return .repeatPassword
        }
        
        if let firstNameTextField = self.firstNameTextField, firstNameTextField.isFirstResponder {
            return .firstName
        }
        
        if let lastNameTextField = self.lastNameTextField, lastNameTextField.isFirstResponder {
            return .lastName
        }
        
        return .none
    }
    
    func showError(_ message: String, for field: InputTextField) {
        
    }
}
