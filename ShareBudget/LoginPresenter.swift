//
//  LoginPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import Rswift

enum AuthorisationMode {
    case login
    case signUp
}

protocol LoginPresenterDelegate: BasePresenterDelegate {
    func hideKeyboard()
    func showSpinnerView()
    func hideSpinnerView()
    func removeBottomOffset()
    func showLogin(title: String)
    func showSignUp(title: String)
    func showAuthorisation(title: String)
    func shiftBottomOffset(_ offset: CGFloat)
    func showError(for field: LoginTextField)
    func hideError(for field: LoginTextField)
    func showKeyboard(for textField: LoginTextField)
    func loginValue(for field: LoginTextField) -> String
    func textType(for textField: UITextField) -> LoginTextField
    func configureTextField(_ textField: LoginTextField, placeholder: String)
}

class LoginPresenter: BasePresenter {
    var mode = AuthorisationMode.login
    weak var delegate: LoginPresenterDelegate?
    
    override func configure() {
        self.updateAthorisationView()
        self.configureLoginTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotifications()
    }
    
    // MARK: - Public
    
    @objc func switchAuthorisationMode() {
        if self.mode == .login {
            self.mode = .signUp
        } else {
            self.mode = .login
        }
        
        self.delegate?.hideKeyboard()
        self.updateAthorisationView()
        self.resetAllLoginErrorStatuses()
    }
    
    @objc func authoriseUser() {
        guard let delegate = self.delegate else {
            return
        }
        
        let notValidField = self.findNotValidField()
        
        if notValidField == .none {
            delegate.hideKeyboard()
            
            guard let interaction = self.interaction as? LoginInteraction else {
                return
            }
            
            let email = delegate.loginValue(for: .email(""))
            let password = delegate.loginValue(for: .password(""))
            
            delegate.showSpinnerView()
            if self.mode == .login {
                interaction.login(email: email, password: password, completion: { (_, error) -> Void in
                    DispatchQueue.main.async {
                        delegate.hideSpinnerView()
                        
                        guard error == .none else {
                            var actions = [self.alertOkAction()]
                            var message = LocalisedManager.generic.errorMessage
                            
                            switch error {
                            case .userNotExist:
                                message = LocalisedManager.error.userNotExist
                                
                            case .userPasswordIsWrong:
                                message = LocalisedManager.error.passwordIsWrong
                                
                            case .emailNotApproved:
                                let sendEmailAction = UIAlertAction(title: LocalisedManager.login.sendAgain, style: .default, handler: { _ in
                                    interaction.sendRegistrationEmail(email)
                                })
                                message = LocalisedManager.login.sendRegistrationEmailMessage
                                actions.append(sendEmailAction)
                                
                            default:
                                break
                            }
                            
                            delegate.showMessage(with: LocalisedManager.generic.errorTitle, message, actions)
                            return
                        }
                        
                        guard let router = self.router as? LoginRouter else {
                            return
                        }
                        
                        SyncManager.shared.run()
                        router.showHomePage()
                    }
                })
            } else {
                let firstName = delegate.loginValue(for: .firstName(""))
                let lastName = delegate.loginValue(for: .lastName(""))
                
                interaction.singUp(email: email, password: password, firstName: firstName, lastName: lastName, completion: { (_, error) -> Void in
                    DispatchQueue.main.async {
                        delegate.hideSpinnerView()
                        
                        guard error == .none else {
                            var message = LocalisedManager.generic.errorMessage
                            
                            switch error {
                            case .userIsAlreadyExist:
                                message = LocalisedManager.error.userIsAlreadyExist
                                
                            default:
                                break
                            }
                            
                            let actions = [self.alertOkAction()]
                            self.delegate?.showMessage(with: LocalisedManager.generic.errorTitle, message, actions)
                            return
                        }
                    }
                })
            }
        } else {
            delegate.showError(for: notValidField)
        }
    }
    
    func listenTextFieldChanges(_ textField: UITextField?) {
        textField?.delegate = self
    }
    
    @objc func keyboardWillShown(notofication: NSNotification) {
        if let info = notofication.userInfo {
            if let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.delegate?.shiftBottomOffset(kbSize.height)
            }
        }
    }
    
    @objc func keyboardWillBeHidden() {
        self.delegate?.removeBottomOffset()
    }
    
    // MARK: - Private
    
    private func resetAllLoginErrorStatuses() {
        self.delegate?.hideError(for: .email(""))
        self.delegate?.hideError(for: .password(""))
        self.delegate?.hideError(for: .repeatPassword(""))
        self.delegate?.hideError(for: .firstName(""))
    }
    
    private func configureLoginTextFields() {
        self.delegate?.configureTextField(.email(""), placeholder: LocalisedManager.login.email)
        self.delegate?.configureTextField(.password(""), placeholder: LocalisedManager.login.password)
        self.delegate?.configureTextField(.repeatPassword(""), placeholder: LocalisedManager.login.repeatPassword)
        self.delegate?.configureTextField(.firstName(""), placeholder: LocalisedManager.login.firstName)
        self.delegate?.configureTextField(.lastName(""), placeholder: LocalisedManager.login.lastName)
    }
    
    private func findNotValidField() -> LoginTextField {
        guard let delegate = self.delegate else {
            return .all
        }
        
        var value = delegate.loginValue(for: .email(""))
        if !Validator.email(value) {
            self.delegate?.showKeyboard(for: .email(""))
            return .email(LocalisedManager.validation.wrongEmailFormat)
        }
        
        value = delegate.loginValue(for: .password(""))
        if !Validator.password(value) {
            self.delegate?.showKeyboard(for: .password(""))
            return .password(LocalisedManager.validation.wrongPasswordFormat)
        }
        
        if self.mode == .login {
            return .none
        }
        
        let password = delegate.loginValue(for: .password(""))
        value = delegate.loginValue(for: .repeatPassword(""))
        if !Validator.repeatPassword(password: password, repeat: value) {
            self.delegate?.showKeyboard(for: .repeatPassword(""))
            return .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent)
        }
        
        value = delegate.loginValue(for: .firstName(""))
        if !Validator.firstName(value) {
            self.delegate?.showKeyboard(for: .firstName(""))
            return .firstName(LocalisedManager.validation.firstNameIsEmpty)
        }
        
        return .none
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPresenter.keyboardWillShown(notofication:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPresenter.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func validate(textField: UITextField) {
        guard let input = self.delegate?.textType(for: textField) else {
            return
        }
        
        switch input {
        case let .email(value):
            if !Validator.email(value) {
                self.delegate?.showError(for: .email(LocalisedManager.validation.wrongEmailFormat))
            }
            
        case let .password(value):
            if !Validator.password(value) {
                self.delegate?.showError(for: .password(LocalisedManager.validation.wrongPasswordFormat))
            }
            
        case let .repeatPassword(value):
            guard let delegate = self.delegate else {
                self.delegate?.showError(for: .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent))
                return
            }
            
            let password = delegate.loginValue(for: .password(""))
            if !Validator.repeatPassword(password: password, repeat: value) {
                self.delegate?.showError(for: .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent))
            }
            
        case let .firstName(value):
            if !Validator.firstName(value) {
                self.delegate?.showError(for: .firstName(LocalisedManager.validation.firstNameIsEmpty))
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
        case .email:
            self.delegate?.showKeyboard(for: .password(""))
            
        case .password:
            if self.mode == .login {
                self.authoriseUser()
            } else {
                self.delegate?.showKeyboard(for: .repeatPassword(""))
            }
            
        case .repeatPassword:
            self.delegate?.showKeyboard(for: .firstName(""))
            
        case .firstName:
            self.delegate?.showKeyboard(for: .lastName(""))
            
        case .lastName:
            self.authoriseUser()
            
        default:
            break
        }
    }
}

extension LoginPresenter: UITextFieldDelegate {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let inputTextField = self.delegate?.textType(for: textField) else {
            return true
        }
        
        self.delegate?.hideError(for: inputTextField)
        
        return true
    }
}
