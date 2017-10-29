//
//  LoginView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum LoginTextField {
    case none
    case email(String)
    case password(String)
    case repeatPassword(String)
    case firstName(String)
    case lastName(String)
    case all
}

extension LoginTextField: Equatable {
    static func == (lhs: LoginTextField, rhs: LoginTextField) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
            
        case (let .email(lEmail), let .email(rEmail)):
            return lEmail == rEmail
            
        case (let .password(lPassword), let .password(rPassword)):
            return lPassword == rPassword
            
        case (let .repeatPassword(lRepeatPassword), let .repeatPassword(rRepeatPassword)):
            return lRepeatPassword == rRepeatPassword
            
        case (let .firstName(lFirstName), let .firstName(rFirstName)):
            return lFirstName == rFirstName
            
        case (let .lastName(lLastName), let .lastName(rLastName)):
            return lLastName == rLastName
            
        case (.all, .all):
            return true
            
        default:
            return false
        }
    }
}

class LoginView: BaseView {
    weak var stackView: UIStackView?
    weak var scrollView: UIScrollView?
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
    
    private func textField(for type: LoginTextField) -> TextFieldErrorMessage? {
        switch type {
        case .email:
            return self.email
            
        case .password:
            return self.password
            
        case .repeatPassword:
            return self.repeatPassword
            
        case .firstName:
            return self.firstName
            
        case .lastName:
            return self.lastName
            
        default:
            return nil
        }
    }
    
    func showLogin(title: String) {
        self.updatePasswordReturnKey(.go)
        
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: true)
            self.updateButton(title: title)
        }
    }
    
    func showSignUp(title: String) {
        self.updatePasswordReturnKey(.next)
        
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: false)
            self.updateButton(title: title)
        }
    }
    
    func loginValue(for field: LoginTextField) -> String {
        let login = self.textField(for: field)
        return login?.textField?.text ?? ""
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
        let login = self.textField(for: field)
        
        login?.isErrorHidden = true
    }
    
    func showError(for field: LoginTextField) {
        var errorMessage: String?
        let login = self.textField(for: field)
        
        switch field {
        case let .email(value):
            errorMessage = value
            
        case let .password(value):
            errorMessage = value
            
        default:
            break
        }
        
        login?.isErrorHidden = false
        login?.errorMessageLabel?.text = errorMessage
    }
    
    func showKeyboard(for textField: LoginTextField) {
        let login = self.textField(for: textField)
        let loginTextField = login?.textField
        
        loginTextField?.becomeFirstResponder()
    }
    
    func showAuthorisation(title: String) {
        self.authorisationButton?.setTitle(title, for: .normal)
        self.authorisationButton?.setTitle(title, for: .highlighted)
    }
    
    func configureTextField(_ textField: LoginTextField, placeholder: String) {
        let login = self.textField(for: textField)
        login?.textField?.placeholder = placeholder
    }
    
    func hideKeyboard() {
        _ = self.email?.textField?.resignFirstResponder()
        _ = self.password?.textField?.resignFirstResponder()
        _ = self.repeatPassword?.textField?.resignFirstResponder()
        _ = self.firstName?.textField?.resignFirstResponder()
        _ = self.lastName?.textField?.resignFirstResponder()
    }
    
    func showSpinnerView() {
        
    }
    
    func hideSpinnerView() {
        
    }
    
    func removeBottomOffset() {
        guard var contentInsets = self.scrollView?.contentInset else {
            return
        }
        
        if let length = self.viewController?.bottomLayoutGuide.length {
            contentInsets.bottom = length
        }
        
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    func shiftBottomOffset(_ offset: CGFloat) {
        guard var contentInsets = self.scrollView?.contentInset else {
            return
        }
        
        contentInsets.bottom = offset
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
}
