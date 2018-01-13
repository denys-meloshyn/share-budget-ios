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
    func showError(for field: LoginTextFieldError)
    func hideError(for field: LoginTextFieldName)
    func showKeyboard(for textField: LoginTextFieldName)
    func configureTextField(_ textField: LoginTextFieldName, placeholder: String)
}

protocol LoginPresenterProtocol: BasePresenterProtocol, UITextFieldDelegate {
    weak var delegate: LoginPresenterDelegate? { get set }

    func authoriseUser()
    func switchAuthorisationMode()
}

class LoginPresenter<T: LoginInteractionProtocol>: BasePresenter<T>, LoginPresenterProtocol {
    private var email = ""
    private var password = ""
    private var lastName = ""
    private var firstName = ""
    private var repeatPassword = ""
    private var mode = AuthorisationMode.login
    
    weak var delegate: LoginPresenterDelegate?

    override func configure() {
        super.configure()

        updateAthorisationView()
        configureLoginTextFields()
    }

    // MARK: - Public

    func switchAuthorisationMode() {
        if mode == .login {
            mode = .signUp
        } else {
            mode = .login
        }

        delegate?.hideKeyboard()
        updateAthorisationView()
        resetAllLoginErrorStatuses()
    }
    
    func authoriseUser() {
        let notValidField = findNotValidField()

        if notValidField == .none {
            delegate?.hideKeyboard()

            delegate?.showSpinnerView()
            if mode == .login {
                interaction.login(email: email, password: password) { (_, error) -> Void in
                    DispatchQueue.main.async {
                        self.delegate?.hideSpinnerView()

                        guard error == .none else {
                            var actions = [self.alertOkAction()]
                            var message = LocalisedManager.generic.errorMessage

                            switch error {
                            case .userNotExist:
                                message = LocalisedManager.error.userNotExist

                            case .userPasswordIsWrong:
                                message = LocalisedManager.error.passwordIsWrong

                            case .emailNotApproved:
                                let sendEmailAction = UIAlertAction(title: LocalisedManager.login.sendAgain, style: .default) { _ in
                                    self.interaction.sendRegistrationEmail(self.email)
                                }
                                message = LocalisedManager.login.sendRegistrationEmailMessage
                                actions.append(sendEmailAction)

                            default:
                                break
                            }

                            self.delegate?.showMessage(with: LocalisedManager.generic.errorTitle, message, actions)
                            return
                        }

                        guard let router = self.router as? LoginRouter else {
                            return
                        }

                        SyncManager.shared.run()
                        router.showHomePage()
                    }
                }
            } else {
                interaction.singUp(email: email, password: password, firstName: firstName, lastName: lastName) { (_, error) -> Void in
                    DispatchQueue.main.async {
                        self.delegate?.hideSpinnerView()

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
                }
            }
        } else {
            delegate?.showError(for: notValidField!)
        }
    }

    func keyboardWillShown(notofication: Notification) {
        if let info = notofication.userInfo {
            if let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                delegate?.shiftBottomOffset(kbSize.height)
            }
        }
    }

    func keyboardWillBeHidden() {
        delegate?.removeBottomOffset()
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count > 0 else {
            return
        }

        validate(textField: textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activateNextKeyboard(for: textField)

        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldListener = textField as? TextFieldListener
        
        let stringObjc = NSString(string: textField.text ?? "")
        let newValue = stringObjc.replacingCharacters(in: range, with: string)
        
        switch LoginTextFieldName(rawValue: textFieldListener?.tagName ?? "") {
        case .email?:
            email = newValue
            
        case .password?:
            password = newValue
            
        case .repeatPassword?:
            repeatPassword = newValue
            
        case .firstName?:
            firstName = newValue
            
        default:
            break
        }
        
        delegate?.hideError(for: LoginTextFieldName(rawValue: textFieldListener?.tagName ?? "")!)

        return true
    }

    // MARK: - Private

    private func resetAllLoginErrorStatuses() {
        delegate?.hideError(for: .email)
        delegate?.hideError(for: .password)
        delegate?.hideError(for: .repeatPassword)
        delegate?.hideError(for: .firstName)
    }

    private func configureLoginTextFields() {
        delegate?.configureTextField(.email, placeholder: LocalisedManager.login.email)
        delegate?.configureTextField(.password, placeholder: LocalisedManager.login.password)
        delegate?.configureTextField(.repeatPassword, placeholder: LocalisedManager.login.repeatPassword)
        delegate?.configureTextField(.firstName, placeholder: LocalisedManager.login.firstName)
        delegate?.configureTextField(.lastName, placeholder: LocalisedManager.login.lastName)
    }

    private func findNotValidField() -> LoginTextFieldError? {
        if !Validator.email(email) {
            delegate?.showKeyboard(for: .email)
            return .email(LocalisedManager.validation.wrongEmailFormat)
        }

        if !Validator.password(password) {
            delegate?.showKeyboard(for: .password)
            return .password(LocalisedManager.validation.wrongPasswordFormat)
        }

        if !Validator.repeatPassword(password: password, repeat: repeatPassword) {
            delegate?.showKeyboard(for: .repeatPassword)
            return .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent)
        }

        if !Validator.firstName(firstName) {
            delegate?.showKeyboard(for: .firstName)
            return .firstName(LocalisedManager.validation.firstNameIsEmpty)
        }
        
        return nil
    }

    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            self.keyboardWillShown(notofication: notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { _ in
            self.keyboardWillBeHidden()
        }
    }

    fileprivate func validate(textField: UITextField) {
        let textFieldListener = textField as? TextFieldListener
        
        switch LoginTextFieldName(rawValue: textFieldListener?.tagName ?? "") {
        case .email?:
            if !Validator.email(email) {
                delegate?.showError(for: .email(LocalisedManager.validation.wrongEmailFormat))
            }

        case .password?:
            if !Validator.password(password) {
                delegate?.showError(for: .password(LocalisedManager.validation.wrongPasswordFormat))
            }

        case .repeatPassword?:
            if !Validator.repeatPassword(password: password, repeat: repeatPassword) {
                delegate?.showError(for: .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent))
            }

        case .firstName?:
            if !Validator.firstName(firstName) {
                delegate?.showError(for: .firstName(LocalisedManager.validation.firstNameIsEmpty))
            }

        default:
            break
        }
    }

    fileprivate func updateAthorisationView() {
        switch mode {
        case .login:
            delegate?.showLogin(title: LocalisedManager.login.dontHaveAccount)
            delegate?.showPage(title: LocalisedManager.login.title)
            delegate?.showAuthorisation(title: LocalisedManager.login.title)
        case .signUp:
            delegate?.showSignUp(title: LocalisedManager.login.loginWithExistingAccount)
            delegate?.showPage(title: LocalisedManager.login.signUp)
            delegate?.showAuthorisation(title: LocalisedManager.login.signUp)
        }
    }

    fileprivate func activateNextKeyboard(for textField: UITextField) {
        let textFieldListener = textField as? TextFieldListener

        switch LoginTextFieldName(rawValue: textFieldListener?.tagName ?? "") {
        case .email?:
            delegate?.showKeyboard(for: .password)

        case .password?:
            if mode == .login {
                authoriseUser()
            } else {
                delegate?.showKeyboard(for: .repeatPassword)
            }

        case .repeatPassword?:
            delegate?.showKeyboard(for: .firstName)

        case .firstName?:
            delegate?.showKeyboard(for: .lastName)

        case .lastName?:
            authoriseUser()

        default:
            break
        }
    }
}

 // MARK: - LifeCycleStateProtocol

extension LoginPresenter: LifeCycleStateProtocol {
    func viewDidLoad() {
    }

    func viewWillAppear(_ animated: Bool) {
        configureNotifications()
    }

    func viewDidAppear(_ animated: Bool) {
    }

    func viewWillDisappear(_ animated: Bool) {
        removeNotifications()
    }

    func viewDidDisappear(_ animated: Bool) {
    }
}
