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

protocol LoginViewProtocol: BaseViewProtocol {
    weak var stackView: UIStackView? { get set }
    weak var scrollView: UIScrollView? { get set }
    weak var email: TextFieldErrorMessage? { get set }
    weak var authorisationButton: UIButton? { get set }
    weak var password: TextFieldErrorMessage? { get set }
    weak var lastName: TextFieldErrorMessage? { get set }
    weak var firstName: TextFieldErrorMessage? { get set }
    weak var authorisationModeButton: UIButton? { get set }
    weak var repeatPassword: TextFieldErrorMessage? { get set }
}

class LoginView<T: LoginPresenterProtocol>: BaseView<T>, LoginViewProtocol {
    weak var stackView: UIStackView?
    weak var scrollView: UIScrollView?
    weak var email: TextFieldErrorMessage?
    weak var authorisationButton: UIButton?
    weak var password: TextFieldErrorMessage?
    weak var lastName: TextFieldErrorMessage?
    weak var firstName: TextFieldErrorMessage?
    weak var authorisationModeButton: UIButton?
    weak var repeatPassword: TextFieldErrorMessage?
    
    override init(with presenter: T, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        presenter.delegate = self
    }
}

extension LoginView: LoginPresenterDelegate {
    private func updateButton(title: String) {
        authorisationModeButton?.setTitle(title, for: .normal)
        authorisationModeButton?.setTitle(title, for: .selected)
    }
    
    private func updateSignUpViews(hidden: Bool) {
        lastName?.isHidden = hidden
        firstName?.isHidden = hidden
        repeatPassword?.isHidden = hidden
    }
    
    private func createErrorLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.red
        
        return label
    }
    
    private func updatePasswordReturnKey(_ returnKeyType: UIReturnKeyType) {
        password?.textField?.returnKeyType = returnKeyType
    }
    
    private func textField(for type: LoginTextField) -> TextFieldErrorMessage? {
        switch type {
        case .email:
            return email
            
        case .password:
            return password
            
        case .repeatPassword:
            return repeatPassword
            
        case .firstName:
            return firstName
            
        case .lastName:
            return lastName
            
        default:
            return nil
        }
    }
    
    func showLogin(title: String) {
        updatePasswordReturnKey(.go)
        
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: true)
            self.updateButton(title: title)
        }
    }
    
    func showSignUp(title: String) {
        updatePasswordReturnKey(.next)
        
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: false)
            self.updateButton(title: title)
        }
    }
    
    func loginValue(for field: LoginTextField) -> String {
        let login = textField(for: field)
        return login?.textField?.text ?? ""
    }
    
    func textType(for textField: UITextField) -> LoginTextField {
        if textField === email?.textField {
            return .email(textField.text ?? "")
        }
        
        if textField === password?.textField {
            return .password(textField.text ?? "")
        }
        
        if textField === repeatPassword?.textField {
            return .repeatPassword(textField.text ?? "")
        }
        
        if textField === firstName?.textField {
            return .firstName(textField.text ?? "")
        }
        
        if textField === lastName?.textField {
            return .lastName(textField.text ?? "")
        }
        
        return .none
    }
    
    func hideError(for field: LoginTextField) {
        let login = textField(for: field)
        
        login?.isErrorHidden = true
    }
    
    func showError(for field: LoginTextField) {
        var errorMessage: String?
        let login = textField(for: field)
        
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
        _ = email?.textField?.resignFirstResponder()
        _ = password?.textField?.resignFirstResponder()
        _ = repeatPassword?.textField?.resignFirstResponder()
        _ = firstName?.textField?.resignFirstResponder()
        _ = lastName?.textField?.resignFirstResponder()
    }
    
    func showSpinnerView() {
    }
    
    func hideSpinnerView() {
    }
    
    func removeBottomOffset() {
        guard var contentInsets = scrollView?.contentInset else {
            return
        }
        
        if let length = viewController?.bottomLayoutGuide.length {
            contentInsets.bottom = length
        }
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    func shiftBottomOffset(_ offset: CGFloat) {
        guard var contentInsets = scrollView?.contentInset else {
            return
        }
        
        contentInsets.bottom = offset
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
}
