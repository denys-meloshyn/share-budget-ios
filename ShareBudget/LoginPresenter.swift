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

protocol LoginPresenterProtocol: BasePresenterProtocol {
    weak var delegate: LoginPresenterDelegate? { get set }

    func authoriseUser()
    func switchAuthorisationMode()
    func listenTextFieldChanges(_ textField: UITextField?)
}

class LoginPresenter<T: LoginInteractionProtocol>: BasePresenter<T>, LoginPresenterProtocol, UITextFieldDelegate {
    weak var delegate: LoginPresenterDelegate?

    private var mode = AuthorisationMode.login

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
        guard let delegate = delegate else {
            return
        }

        let notValidField = findNotValidField()

        if notValidField == .none {
            delegate.hideKeyboard()

            guard let interaction = interaction as? LoginInteraction else {
                return
            }

            let email = delegate.loginValue(for: .email(""))
            let password = delegate.loginValue(for: .password(""))

            delegate.showSpinnerView()
            if mode == .login {
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
                            delegate.showMessage(with: LocalisedManager.generic.errorTitle, message, actions)
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

    func keyboardWillShown(notofication: NSNotification) {
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
        guard let inputTextField = delegate?.textType(for: textField) else {
            return true
        }

        delegate?.hideError(for: inputTextField)

        return true
    }

    // MARK: - Private

    private func resetAllLoginErrorStatuses() {
        delegate?.hideError(for: .email(""))
        delegate?.hideError(for: .password(""))
        delegate?.hideError(for: .repeatPassword(""))
        delegate?.hideError(for: .firstName(""))
    }

    private func configureLoginTextFields() {
        delegate?.configureTextField(.email(""), placeholder: LocalisedManager.login.email)
        delegate?.configureTextField(.password(""), placeholder: LocalisedManager.login.password)
        delegate?.configureTextField(.repeatPassword(""), placeholder: LocalisedManager.login.repeatPassword)
        delegate?.configureTextField(.firstName(""), placeholder: LocalisedManager.login.firstName)
        delegate?.configureTextField(.lastName(""), placeholder: LocalisedManager.login.lastName)
    }

    private func findNotValidField() -> LoginTextField {
        guard let delegate = delegate else {
            return .all
        }

        var value = delegate.loginValue(for: .email(""))
        if !Validator.email(value) {
            delegate.showKeyboard(for: .email(""))
            return .email(LocalisedManager.validation.wrongEmailFormat)
        }

        value = delegate.loginValue(for: .password(""))
        if !Validator.password(value) {
            delegate.showKeyboard(for: .password(""))
            return .password(LocalisedManager.validation.wrongPasswordFormat)
        }

        if mode == .login {
            return .none
        }

        let password = delegate.loginValue(for: .password(""))
        value = delegate.loginValue(for: .repeatPassword(""))
        if !Validator.repeatPassword(password: password, repeat: value) {
            delegate.showKeyboard(for: .repeatPassword(""))
            return .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent)
        }

        value = delegate.loginValue(for: .firstName(""))
        if !Validator.firstName(value) {
            delegate.showKeyboard(for: .firstName(""))
            return .firstName(LocalisedManager.validation.firstNameIsEmpty)
        }

        return .none
    }

    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func configureNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginPresenter.keyboardWillShown(notofication:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginPresenter.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    fileprivate func validate(textField: UITextField) {
        guard let input = delegate?.textType(for: textField) else {
            return
        }

        switch input {
        case let .email(value):
            if !Validator.email(value) {
                delegate?.showError(for: .email(LocalisedManager.validation.wrongEmailFormat))
            }

        case let .password(value):
            if !Validator.password(value) {
                delegate?.showError(for: .password(LocalisedManager.validation.wrongPasswordFormat))
            }

        case let .repeatPassword(value):
            guard let delegate = delegate else {
                return
            }

            let password = delegate.loginValue(for: .password(""))
            if !Validator.repeatPassword(password: password, repeat: value) {
                delegate.showError(for: .repeatPassword(LocalisedManager.validation.repeatPasswordIsDifferent))
            }

        case let .firstName(value):
            if !Validator.firstName(value) {
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
        guard let loginTextField = delegate?.textType(for: textField) else {
            return
        }

        switch loginTextField {
        case .email:
            delegate?.showKeyboard(for: .password(""))

        case .password:
            if mode == .login {
                authoriseUser()
            } else {
                delegate?.showKeyboard(for: .repeatPassword(""))
            }

        case .repeatPassword:
            delegate?.showKeyboard(for: .firstName(""))

        case .firstName:
            delegate?.showKeyboard(for: .lastName(""))

        case .lastName:
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
