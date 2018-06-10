//
//  LoginView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum LoginTextFieldError: AutoEquatable {
    case email(String)
    case password(String)
    case repeatPassword(String)
    case firstName(String)
    case lastName(String)
}

enum LoginTextFieldName: String {
    case email
    case password
    case lastName
    case firstName
    case repeatPassword
}

protocol LoginViewProtocol: BaseViewProtocol {
    var stackView: UIStackView? { get set }
    var scrollView: UIScrollView? { get set }
    var authorisationButton: UIButton? { get set }
    var authorisationModeButton: UIButton? { get set }
}

class LoginView<T: LoginPresenterProtocol>: BaseView<T>, LoginViewProtocol {
    weak var stackView: UIStackView?
    weak var scrollView: UIScrollView?
    weak var authorisationButton: UIButton?
    weak var authorisationModeButton: UIButton?
    
    private let email = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private let password = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private let lastName = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private let firstName = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private let repeatPassword = R.nib.textFieldErrorMessage.firstView(owner: nil)
    
    override init(with presenter: T, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        presenter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lastName = lastName {
            lastName.isHidden = true
            lastName.textField.delegate = presenter
            lastName.textField.tagName = LoginTextFieldName.lastName.rawValue
            lastName.textField.returnKeyType = .go
            stackView?.insertArrangedSubview(lastName, at: 0)
        }
        
        if let firstName = firstName {
            firstName.isHidden = true
            firstName.textField.delegate = presenter
            firstName.textField.returnKeyType = .next
            firstName.textField.tagName = LoginTextFieldName.firstName.rawValue
            stackView?.insertArrangedSubview(firstName, at: 0)
        }
        
        if let repeatPassword = repeatPassword {
            repeatPassword.isHidden = true
            repeatPassword.textField.delegate = presenter
            repeatPassword.textField.returnKeyType = .go
            repeatPassword.textField.isSecureTextEntry = true
            repeatPassword.textField.tagName = LoginTextFieldName.repeatPassword.rawValue
            stackView?.insertArrangedSubview(repeatPassword, at: 0)
        }
        
        if let password = password {
            password.textField.delegate = presenter
            password.textField?.isSecureTextEntry = true
            password.textField.tagName = LoginTextFieldName.password.rawValue
            stackView?.insertArrangedSubview(password, at: 0)
        }
        
        if let email = email {
            email.textField.delegate = presenter
            email.textField?.returnKeyType = .next
            email.textField?.autocorrectionType = .no
            email.textField?.keyboardType = .emailAddress
            email.textField.tagName = LoginTextFieldName.email.rawValue
            stackView?.insertArrangedSubview(email, at: 0)
        }
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
    
    private func textField(for type: LoginTextFieldName) -> TextFieldErrorMessage? {
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
        }
    }
    
    private func textField(for type: LoginTextFieldError) -> TextFieldErrorMessage? {
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
    
    func hideError(for field: LoginTextFieldName) {
        let login = textField(for: field)
        
        login?.isErrorHidden = true
    }
    
    func showError(for field: LoginTextFieldError) {
        var errorMessage: String?
        let inputTextField = textField(for: field)
        
        switch field {
        case let .email(value):
            errorMessage = value
            
        case let .password(value):
            errorMessage = value
            
        default:
            break
        }
        
        inputTextField?.isErrorHidden = false
        inputTextField?.errorMessageLabel?.text = errorMessage
    }
    
    func showKeyboard(for textField: LoginTextFieldName) {
        let login = self.textField(for: textField)
        let loginTextField = login?.textField
        
        loginTextField?.becomeFirstResponder()
    }
    
    func showAuthorisation(title: String) {
        authorisationButton?.setTitle(title, for: .normal)
        authorisationButton?.setTitle(title, for: .highlighted)
    }
    
    func configureTextField(_ textField: LoginTextFieldName, placeholder: String) {
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

        contentInsets.bottom = viewController.view.safeAreaInsets.bottom
        
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
